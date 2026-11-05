/* ============================================================================
   宁波市文旅经营主体数据分析脚本
   文件：src/culture.sql

   【脚本目的】
   1. 按行业代码筛出宁波文旅经营主体，统计主体总量，并按行业小类、区县、
      企业类型、登记状态、成立时间等维度给出分布。
   2. 在筛出的主体中遴选信用质量相对较好的前 3000 家，形成名单
      selected_top3000，供后续分析使用。

   【运行环境】
   MySQL 8.0+，云服务器政务数据共享库。源表为 dw_* 表，以统一社会信用代码
   uni_social_crd_cd 关联；源表的表名与字段以官方字段字典为准：
   docs/数据库字段与结构/金融主题库字段表_20250715.xlsx（目录页列出标准表名，
   各编号页列出该表的标准化字段名、类型与样例数据）。
   两处字段特例见 3.14、3.15。需要有建表权限；若云端只允许临时表，
   请把本文件中的 CREATE TABLE 改成 CREATE TEMPORARY TABLE。

   【执行步骤】
   建议分段选中执行，每段跑完看结果行数再继续；所有建表语句前都有
   DROP TABLE IF EXISTS，整文件重复跑不会报表已存在。
     SECTION 0  查看源表字段形态
     SECTION 1  建行业代码表 industry_codes（63 个行业小类）
     SECTION 2  按行业代码筛出 company 并去重，抽取 company_core
     SECTION 3  逐维度扩展画像，汇总为 company_profile
     SECTION 4  企业统计
     SECTION 5  区域结构
     SECTION 6  报告取数，建统一分析底表 rpt_wenlv
     SECTION 7  执行后核对
     SECTION 8  遴选名单 selected_top3000，自带核对
   执行前先备份库中已有的 company_*、rpt_wenlv 表；取报告数字前跑一遍
   SECTION 7，名单取数看 SECTION 8。

   【数据口径】
   企业范围：只按 industry_codes 中的 63 个行业代码，从市场主体总表
   dw_zj_scjdgl_scztxx 提取，取 indv_nm 字段（当前数据中存放的就是四位
   行业代码）。不叠加经营范围关键词，不区分文化、旅游、文旅融合，
   全文件只有一套企业范围。同一统一社会信用代码只保留最新一条记录，
   以核准日期 appr_dt 为准，成立日期与经营起始日期兜底。
   代码表来源 docs/文旅行业名称与行业代码.xlsx。
   企业类型：取市场主体总表的 comp_type 原值，分布见 6.5；需要公司制企业、
   个体工商户等归类时按实际取值另行判断。
   基准日：2025-12-31。按年报报送规律，正常企业应在次年 1 至 6 月完成年度
   年报，因此可取得的财务数据为 2025 年度年报的资产总额 asset_zmt、
   营业总收入 nb_opt_income_total 等。财务年度是否整齐、库内有无晚于
   基准日成立的企业，见 8.7 核对。

   【遴选口径（SECTION 8）】
   删除情形：行政处罚 xzcf_count、严重违法失信 yzwf_count、经营异常
   jyyc_count、失信被执行人 sxr_count，任一命中即从名单删除。
   数据时点：要求有 2025 年度年报的资产数据，取不到 2025 年末资产的不进名单。
   排名：企业规模按年报资产总额 asset_zmt、社保人数按 pens_num 分别取名次，
   两个名次相加升序取前 3000 名。
   删除只作用于遴选名单，不回写 company / company_core，因此 SECTION 4 / 5 / 6
   的总数与分类统计保持全量口径。

   【输出表速查】
   字典：industry_codes（行业代码表）
   主体：company / company_core
   画像：company_*（见 SECTION 3）/ company_profile（汇总宽表）
   报告：rpt_wenlv（统一分析底表，见 SECTION 6）
   名单：selection_pool / selection_ranked / selected_top3000（见 SECTION 8）
   ============================================================================ */


-- ############################################################################
-- SECTION 0  执行前检查
-- ############################################################################

-- 0.1 确认源表可读，并查看企业类型字段 comp_type 的实际取值形态。
--     该字段既可能是数字代码，也可能是中文名称，先看一眼再决定如何归类。
SELECT comp_type, COUNT(*) AS cnt
FROM dw_zj_scjdgl_scztxx
GROUP BY comp_type
ORDER BY cnt DESC
LIMIT 20;

-- 0.2 确认行业代码字段形态。indv_nm 在当前数据中存放的就是四位国民经济
--     行业小类代码，字段名容易让人误以为是行业名称，按代码比较即可；
--     本次使用的 63 个代码见 SECTION 1 的 industry_codes 表。
SELECT indv_nm, COUNT(*) AS cnt
FROM dw_zj_scjdgl_scztxx
GROUP BY indv_nm
ORDER BY cnt DESC
LIMIT 10;


-- ############################################################################
-- SECTION 1  基础代码与字典表
-- 本段建 industry_codes 一张表：63 个国民经济行业小类，只存代码。
-- 是全文件筛选企业的唯一代码来源。
-- 企业类型不设字典表，取市场主体总表的 comp_type 原值，分布见 6.5；
-- 需要公司制或个体户等归类时按实际取值另行判断。
-- ############################################################################

-- ----------------------------------------------------------------------------
-- 1.1 文旅行业代码表（唯一代码表）
--     代码清单来自 docs/文旅行业名称与行业代码.xlsx（Sheet1，共 63 行），
--     本表只存四位行业代码，不存行业名称，避免与源库名称口径不一致。
--     indv_nm 对应源表 dw_* 的 indv_nm 字段；该字段名容易让人误以为是
--     行业名称，当前数据中实际存放的就是代码。
--     维护方式：增减行业只改这一张表的数据，下游筛选自动跟随。
-- ----------------------------------------------------------------------------
DROP TABLE IF EXISTS industry_codes;
CREATE TABLE industry_codes (
    indv_nm        VARCHAR(10)  NOT NULL COMMENT '行业代码（四位国民经济行业小类）',
    PRIMARY KEY (indv_nm)
) COMMENT = '文旅行业代码表';

INSERT INTO industry_codes (indv_nm) VALUES
('3471'), ('3931'), ('3932'), ('3933'), ('3934'), ('3939'), ('3953'), ('5143'), ('5144'), ('5145'), ('5178'), ('5181'), ('5243'), ('5244'), ('5422'), ('5511'), ('5512'), ('5513'), ('5531'), ('5622'), ('5822'), ('6110'), ('6121'), ('6129'), ('6321'), ('6322'), ('6331'), ('7124'), ('7125'), ('7291'), ('7298'), ('7712'), ('7715'), ('7716'), ('7850'), ('7861'), ('7862'), ('7869'), ('8070'), ('8610'), ('8621'), ('8622'), ('8623'), ('8624'), ('8629'), ('8710'), ('8720'), ('8750'), ('8760'), ('8810'), ('8820'), ('8840'), ('8850'), ('8860'), ('9011'), ('9012'), ('9013'), ('9020'), ('9051'), ('9053'), ('9059'), ('9090'), ('9542');

-- 校验：结果应为 63
SELECT COUNT(*) AS code_count FROM industry_codes;

-- ############################################################################
-- SECTION 2  文旅经营主体筛选
-- 步骤：
--   2.1 company       从市场主体总表 dw_zj_scjdgl_scztxx 按 63 个行业代码
--                     提取，再按统一社会信用代码去重、只留最新一条
--   2.2 company_core  从 company 抽取核心字段，作为全链路基准表
-- 各段自带的 COUNT / DESCRIBE / LIMIT 用于人工核对，可逐段执行
-- ############################################################################

-- 准备企业基础信息表

-- 企业基础信息

-- 去重前核对：看同一信用代码是否确有多条记录，以及 appr_dt 能否区分新旧
SELECT
    uni_social_crd_cd,
    COUNT(*) AS record_count,
    COUNT(DISTINCT appr_dt) AS appr_dt_kinds,
    MIN(appr_dt) AS first_appr_dt,
    MAX(appr_dt) AS latest_appr_dt
FROM dw_zj_scjdgl_scztxx
WHERE indv_nm IN (SELECT indv_nm FROM industry_codes)
GROUP BY uni_social_crd_cd
HAVING COUNT(*) > 1
ORDER BY record_count DESC
LIMIT 20;

-- 创建 company 表
DROP TABLE IF EXISTS company;

CREATE TABLE company AS
SELECT
    reg_org,            -- 登记机关
    comp_type,          -- 企业类型大类（中文）
    reg_state,          -- 登记状态（中文）
    uni_social_crd_cd,  -- 统一社会信用代码
    comp_nm,            -- 企业名称（字号名称）
    addr,               -- 住所（登记、个体户经营场所）
    legal_repre,        -- 法定代表人(经营者姓名)
    indv_id,            -- 行业代码（中文）
    reg_capt,           -- 注册资本(资金数额)
    capt_kind,          -- 币种
    -- opt_scop,           -- 经营范围
    -- reg_no,             -- 注册号
    appr_dt,            -- 核准日期（登记、吊销、注销日期）
    est_dt,             -- 成立日期
    opt_from,           -- 经营(营业)起始日期
    opt_to,             -- 经营(营业)截止日期
    domdi_strict,       -- 住所所在行政区划
    -- pro_loc,            -- 生产经营地
    -- opt_strict,         -- 生产经营地所在行政区划
    -- postal_code,        -- 邮政编码
    -- opt_loc,            -- 经营场所
    indv_nm             -- 行业代码（中文）
FROM (
    -- 同一统一社会信用代码在源表里可能有不同年份或时期的多条记录，
    -- 按信用代码去重，只留最新一条：以核准日期 appr_dt 为准（登记、变更、
    -- 吊销、注销日期），再用 est_dt、opt_from 兜底，保证并列时结果稳定。
    -- 代码清单来自 SECTION 1 的 industry_codes 表，增减行业只改该表数据。
    SELECT s.*,
           ROW_NUMBER() OVER (
               PARTITION BY s.uni_social_crd_cd
               ORDER BY s.appr_dt DESC, s.est_dt DESC, s.opt_from DESC
           ) AS rn
    FROM dw_zj_scjdgl_scztxx s
    WHERE s.indv_nm IN (SELECT indv_nm FROM industry_codes)
) t
WHERE rn = 1
ORDER BY uni_social_crd_cd;

-- 显示创建结果：company 与 unique_company 应相等，否则说明去重未生效
SELECT
    COUNT(*) AS company,
    COUNT(DISTINCT uni_social_crd_cd) AS unique_company,
    COUNT(DISTINCT indv_nm) AS unique_indv_nm,
    COUNT(DISTINCT comp_type) AS unique_company_types,
    COUNT(DISTINCT domdi_strict) AS unique_districts
FROM
    company;

-- 显示表结构
DESCRIBE company;

-- 显示前10条记录
SELECT * FROM company LIMIT 10;

-- 查看 reg_state 的所有可能值
SELECT DISTINCT reg_state FROM company ORDER BY reg_state;

-- 统计每种 reg_state 的数量
SELECT reg_state, COUNT(*) AS count_per_state FROM company GROUP BY reg_state ORDER BY count_per_state DESC;

-- 企业核心信息

-- 创建企业核心信息表：company 已一企业一行，这里只抽取核心字段
DROP TABLE IF EXISTS company_core;

CREATE TABLE company_core AS
SELECT
    comp_type,          -- 企业类型
    reg_state,          -- 登记状态
    uni_social_crd_cd,  -- 统一社会信用代码：全链路唯一关联键
    comp_nm,            -- 企业名称（字号名称）
    addr,               -- 住所
    indv_id,            -- 行业代码
    reg_capt,           -- 注册资本（资金数额）
    est_dt,             -- 成立日期
    -- opt_strict,         -- 生产经营地所在行政区划
    indv_nm,            -- 行业代码（国民经济行业小类）
    domdi_strict,       -- 住所所在行政区划：供区县统计使用
    reg_org             -- 登记机关：供地区分布统计使用
FROM company;

SELECT COUNT(*) as core_count FROM company_core;

DESCRIBE company_core;

SELECT * FROM company_core LIMIT 10;

-- ############################################################################
-- SECTION 3  企业维度扩展（一企业一行）
-- 统一策略：以 company_core 为基准，每张扩展表都是一张平行表（不是链式累积），
--           用 ROW_NUMBER() 或 GROUP BY 先在源表内取到每家企业的最新一条或计数，
--           再 LEFT JOIN 回来，保证一个信用代码只有一行，避免连乘膨胀。
-- 字段命名：次数类用 *_count，最新值类用 latest_* 或 *_latest_*，
--           年报财务字段统一加 nb_ 前缀，避免与纳税表字段混淆。
-- ############################################################################

-- 基于已创建的 company 表，逐步左连接其他表，每步生成一个中间表
-- 使用聚合函数避免数据膨胀，确保每个企业只有一条记录

-- ==========================================
-- 扩展法定代表人信息
-- ==========================================

DROP TABLE IF EXISTS company_fddb;

CREATE TABLE company_fddb AS
SELECT
    core.*,
    agg.fddb_nm,          -- 法定代表人姓名
    agg.fddb_tel_num      -- 法定代表人固定电话
FROM company_core core
LEFT JOIN (
    -- 先在源表内按企业聚合，避免 core.* 与 GROUP BY 冲突（ONLY_FULL_GROUP_BY）
    SELECT uni_social_crd_cd,
           MAX(nm)      AS fddb_nm,
           MAX(tel_num) AS fddb_tel_num
    FROM dw_zj_scjdgl_fddbrxx
    WHERE lerep_sign = 1
    GROUP BY uni_social_crd_cd
) agg ON core.uni_social_crd_cd = agg.uni_social_crd_cd;

SELECT  -- 显示结果
    COUNT(*) AS fddb_count
FROM company_fddb;

SELECT * FROM company_fddb LIMIT 10;

-- ==========================================
-- 扩展经营异常名录信息
-- ==========================================

DROP TABLE IF EXISTS company_jyyc;

CREATE TABLE company_jyyc AS
SELECT
    core.*,
    COALESCE(jyyc_agg.jyyc_count, 0) AS jyyc_count,                -- 经营异常记录数
    jyyc_agg.jyyc_latest_inclu_dt,                                 -- 最新列入日期
    jyyc_agg.jyyc_latest_reason                                   -- 最新列入原因
FROM company_core core
LEFT JOIN (
    SELECT
        uni_social_crd_cd,
        COUNT(*) AS jyyc_count,
        MAX(CASE WHEN rn = 1 THEN inclu_dt END) AS jyyc_latest_inclu_dt,
        MAX(CASE WHEN rn = 1 THEN inclu_reason END) AS jyyc_latest_reason
    FROM (
        SELECT
            uni_social_crd_cd,
            inclu_dt,
            inclu_reason,
            ROW_NUMBER() OVER (PARTITION BY uni_social_crd_cd ORDER BY inclu_dt DESC) AS rn
        FROM dw_zj_scjdgl_jyycmlxx
    ) t
    GROUP BY uni_social_crd_cd
) jyyc_agg
ON core.uni_social_crd_cd = jyyc_agg.uni_social_crd_cd;

SELECT
    COUNT(*) AS jyyc_count
FROM company_jyyc;

SELECT * FROM company_jyyc LIMIT 10;

-- ==========================================
-- 扩展严重违法失信企业名单信息
-- ==========================================

DROP TABLE IF EXISTS company_yzwf;

CREATE TABLE company_yzwf AS
SELECT
    core.*,
    COALESCE(yzwf_agg.yzwf_count, 0) AS yzwf_count,         -- 严重违法失信企业名单记录数
    yzwf_agg.latest_serill_rea                              -- 最新列入严重违法失信企业名单原因
FROM company_core core
LEFT JOIN (
    SELECT
        uni_social_crd_cd,
        COUNT(*) AS yzwf_count,
        MAX(CASE WHEN rn = 1 THEN serill_rea END) AS latest_serill_rea
    FROM (
        SELECT
            uni_social_crd_cd,
            serill_rea,
            ROW_NUMBER() OVER (PARTITION BY uni_social_crd_cd ORDER BY abn_tm DESC) AS rn
        FROM dw_zj_scjdgl_yzwfsx
    ) t
    GROUP BY uni_social_crd_cd
) yzwf_agg
ON core.uni_social_crd_cd = yzwf_agg.uni_social_crd_cd;

SELECT
    COUNT(*) AS yzwf_count
FROM company_yzwf;

SELECT * FROM company_yzwf LIMIT 10;

-- ==========================================
-- 扩展企业年报网站或网店信息
-- ==========================================

-- 删除表（如果已存在）
DROP TABLE IF EXISTS company_wzwd;

CREATE TABLE company_wzwd AS
SELECT
    core.*,
    (SELECT wzwd.web_store_url
     FROM dw_nb_scjdgl_qynbwzhwdxx wzwd
     WHERE wzwd.uni_social_crd_cd = core.uni_social_crd_cd
     ORDER BY wzwd.annual_year DESC
     LIMIT 1) AS wzwd_url  -- 最新年报年度的网站（网店）网址
FROM company_core core;

SELECT
    COUNT(*) AS wzwd_count
FROM company_wzwd;

SELECT * FROM company_wzwd LIMIT 10;

-- ==========================================
-- 扩展企业年报资产信息
-- 按 annual_year 取最新一条，数据基准年度为 2025 年度。
-- 遴选段只保留 2025 年度资产，取不到该年度资产的企业从名单去除。
-- ==========================================

DROP TABLE IF EXISTS company_nb;

CREATE TABLE company_nb AS
SELECT
    core.*,
    nb_latest.asset_zmt,             -- 最新年报年度的资产总额
    nb_latest.debt_amt,              -- 最新年报年度的负债总额
    nb_latest.opt_income_total AS nb_opt_income_total,      -- 最新年报年度的营业总收入
    nb_latest.profit_total AS nb_profit_total,          -- 最新年报年度的利润总额
    nb_latest.net_profit AS nb_net_profit,            -- 最新年报年度的净利润
    nb_latest.tax_total AS nb_tax_total,             -- 最新年报年度的纳税总额
    nb_latest.annual_year AS nb_year      -- 最新年报年度
FROM company_core core
LEFT JOIN (
    SELECT
        uni_social_crd_cd,
        asset_zmt,
        debt_amt,
        opt_income_total,
        profit_total,
        net_profit,
        tax_total,
        annual_year,
        ROW_NUMBER() OVER (PARTITION BY uni_social_crd_cd ORDER BY annual_year DESC) as rn
    FROM dw_nb_scjdgl_qynbzcxx
) nb_latest ON core.uni_social_crd_cd = nb_latest.uni_social_crd_cd
    AND nb_latest.rn = 1;

-- SELECT * FROM dw_nb_scjdgl_qynbzcxx LIMIT 10;

SELECT
    COUNT(*) AS nb_count
FROM company_nb;

SELECT * FROM company_nb WHERE nb_year IS NOT NULL LIMIT 100;

SELECT * FROM company_nb WHERE nb_year >= 2020 LIMIT 100;

SELECT
    COUNT(*) AS nb_year_not_zero_count
FROM company_nb
WHERE nb_year IS NOT NULL AND nb_year <> 0;

SELECT
    AVG(asset_zmt) AS avg_asset_zmt_2019
FROM company_nb
WHERE nb_year = 2019 AND nb_year IS NOT NULL AND asset_zmt > 10 AND asset_zmt < 10000;

-- ==========================================
-- 扩展纳税信息
-- ==========================================

DROP TABLE IF EXISTS company_ns;

CREATE TABLE company_ns AS
SELECT
    core.*,
    ns_latest.tax_amt,         -- 最新纳税总额
    ns_latest.sale_inco,       -- 最新销售收入
    ns_latest.count_dt         -- 最新统计时间
FROM company_core core
LEFT JOIN (
    SELECT
        uni_social_crd_cd,
        tax_amt,
        sale_inco,
        count_dt,
        ROW_NUMBER() OVER (PARTITION BY uni_social_crd_cd ORDER BY count_dt DESC) as rn
    FROM dw_nb_sw_nsxx
) ns_latest ON core.uni_social_crd_cd = ns_latest.uni_social_crd_cd AND ns_latest.rn = 1;

SELECT
    COUNT(*) AS ns_count
FROM company_ns;

SELECT * FROM company_ns LIMIT 10;

-- ==========================================
-- 扩展信用评价信息（A级纳税人）
-- ==========================================

DROP TABLE IF EXISTS company_xypj;

CREATE TABLE company_xypj AS
SELECT
    core.*,
    xypj_latest.tax_credi_level,  -- 最新评定日期的纳税信用等级
    xypj_latest.eval_year         -- 最新评定日期的纳税信用等级评定年度
FROM company_core core
LEFT JOIN (
    SELECT
        uni_social_crd_cd,
        tax_credi_level,
        eval_year,
        ROW_NUMBER() OVER (PARTITION BY uni_social_crd_cd ORDER BY eval_dt DESC) AS rn
    FROM dw_nb_sw_xypjxxa
) xypj_latest
ON core.uni_social_crd_cd = xypj_latest.uni_social_crd_cd AND xypj_latest.rn = 1;

SELECT
    COUNT(*) AS xypj_count
FROM company_xypj;

SELECT * FROM company_xypj LIMIT 10;

-- ==========================================
-- 扩展失信被执行人信息
-- ==========================================

DROP TABLE IF EXISTS company_sxr;

CREATE TABLE company_sxr AS
SELECT
    core.*,
    COALESCE(sxr_agg.sxr_count, 0) AS sxr_count,  -- 失信记录数
    sxr_agg.latest_executed_nm,                   -- 最新被执行人姓名
    sxr_agg.latest_executed_court,                -- 最新执行法院
    sxr_agg.latest_fil_dt                         -- 最新立案时间
FROM company_core core
LEFT JOIN (
    SELECT
        uni_social_crd_cd,
        COUNT(*) AS sxr_count,
        -- 使用窗口函数获取最新记录
        MAX(CASE WHEN rn = 1 THEN executed_nm END) AS latest_executed_nm,
        MAX(CASE WHEN rn = 1 THEN executed_court END) AS latest_executed_court,
        MAX(CASE WHEN rn = 1 THEN fil_dt END) AS latest_fil_dt
    FROM (
        SELECT
            uni_social_crd_cd,
            executed_nm,
            executed_court,
            fil_dt,
            ROW_NUMBER() OVER (PARTITION BY uni_social_crd_cd ORDER BY fil_dt DESC) AS rn
        FROM dw_zj_fzgg_sxbzxrxx
    ) t
    GROUP BY uni_social_crd_cd
) sxr_agg
ON core.uni_social_crd_cd = sxr_agg.uni_social_crd_cd;

SELECT
    COUNT(*) AS sxr_count
FROM company_sxr;

SELECT * FROM company_sxr LIMIT 10;

-- ==========================================
-- 扩展行政处罚信息（最终表）
-- ==========================================

DROP TABLE IF EXISTS company_xzcf;

CREATE TABLE company_xzcf AS
SELECT
    core.*,
    COALESCE(xzcf_agg.xzcf_count, 0) AS xzcf_count,         -- 行政处罚次数
    xzcf_agg.latest_punish_doc,                             -- 最新行政处罚文号
    xzcf_agg.latest_punish_dt,                              -- 最新处罚时间
    xzcf_agg.latest_punish_rea                              -- 最新处罚原因
FROM company_core core
LEFT JOIN (
    SELECT
        uni_social_crd_cd,
        COUNT(*) AS xzcf_count,
        MAX(CASE WHEN rn = 1 THEN admin_punish_doc END) AS latest_punish_doc,
        MAX(CASE WHEN rn = 1 THEN punish_dt END) AS latest_punish_dt,
        MAX(CASE WHEN rn = 1 THEN punish_rea END) AS latest_punish_rea
    FROM (
        SELECT
            uni_social_crd_cd,
            admin_punish_doc,
            punish_dt,
            punish_rea,
            ROW_NUMBER() OVER (PARTITION BY uni_social_crd_cd ORDER BY punish_dt DESC) AS rn
        FROM dw_nb_scjdgl_xzcfgsxx
    ) t
    GROUP BY uni_social_crd_cd
) xzcf_agg
ON core.uni_social_crd_cd = xzcf_agg.uni_social_crd_cd;

SELECT
    COUNT(*) AS xzcf_count
FROM company_xzcf;

SELECT * FROM company_xzcf LIMIT 10;


-- ----------------------------------------------------------------------------
-- 3.12 对外担保
--      取年报年度最新一条担保记录，同时统计担保记录数。
-- ----------------------------------------------------------------------------
DROP TABLE IF EXISTS company_db;
CREATE TABLE company_db AS
SELECT
    core.*,
    COALESCE(agg.db_count, 0) AS db_count,        -- 对外担保记录数
    agg.latest_creditor,                          -- 最新债权人
    agg.latest_credit_amt                         -- 最新主债权数额
FROM company_core core
LEFT JOIN (
    SELECT
        uni_social_crd_cd,
        COUNT(*) AS db_count,
        MAX(CASE WHEN rn = 1 THEN creditor END)         AS latest_creditor,
        MAX(CASE WHEN rn = 1 THEN major_credit_amt END) AS latest_credit_amt
    FROM (
        SELECT uni_social_crd_cd, creditor, major_credit_amt,
               ROW_NUMBER() OVER (PARTITION BY uni_social_crd_cd
                                  ORDER BY annual_year DESC) AS rn
        FROM dw_nb_scjdgl_dwtgbzdbxx
    ) t
    GROUP BY uni_social_crd_cd
) agg ON core.uni_social_crd_cd = agg.uni_social_crd_cd;

-- ----------------------------------------------------------------------------
-- 3.13 社会保险参保
--      源表 dw_nb_rlsb_sbjylyshbxjbxx 一家企业可能有多个缴费年月，
--      按 pens_pay_ym 取最新一条，得到五险人数与缴费年月。
--      该表没有 issue_end_dt 字段，可用字段以官方字典为准。
-- ----------------------------------------------------------------------------
DROP TABLE IF EXISTS company_sb_jbxx;
CREATE TABLE company_sb_jbxx AS
SELECT
    core.*,
    sb.pens_num,          -- 养老保险人数
    sb.medic_num,         -- 医疗保险人数
    sb.unemploy_num,      -- 失业保险人数
    sb.injury_num,        -- 工伤保险人数
    sb.materni_num,       -- 生育保险人数
    sb.pens_pay_ym,       -- 最新养老保险缴费年月
    sb.issue_start_dt     -- 投保起始日期
FROM company_core core
LEFT JOIN (
    SELECT *
    FROM (
        SELECT uni_social_crd_cd, pens_num, medic_num, unemploy_num,
               injury_num, materni_num, pens_pay_ym, issue_start_dt,
               ROW_NUMBER() OVER (PARTITION BY uni_social_crd_cd
                                  ORDER BY pens_pay_ym DESC) AS rn
        FROM dw_nb_rlsb_sbjylyshbxjbxx
    ) t
    WHERE rn = 1
) sb ON core.uni_social_crd_cd = sb.uni_social_crd_cd;

-- ----------------------------------------------------------------------------
-- 3.14 科技型小微企业认定
--      源表认定年份字段名为 congniz_tear，对外统一别名为 congniz_year。
--      字段依据：金融主题库字段表_20250715.xlsx。该表没有 uni_social_crd_cd，
--      只有 comp_nm、congniz_org、congniz_tear、no、org_id，
--      因此只能按企业名称 comp_nm 关联；先在源表内按名称聚合取最早认定年份，
--      保证一个名称一行，避免 LEFT JOIN 后行数膨胀。
--      按名称匹配的覆盖率低于信用代码关联，引用该指标时需注明口径。
-- ----------------------------------------------------------------------------
DROP TABLE IF EXISTS company_kjzx;
CREATE TABLE company_kjzx AS
SELECT
    core.*,
    agg.congniz_year      -- 最早认定年份
FROM company_core core
LEFT JOIN (
    SELECT comp_nm, MIN(congniz_tear) AS congniz_year
    FROM dw_nb_kj_sgczkjxzxqy
    GROUP BY comp_nm
) agg ON core.comp_nm = agg.comp_nm;

-- ----------------------------------------------------------------------------
-- 3.15 公共信用分
--      与 3.8 的纳税信用等级不是一回事：这里取 dw_nb_dsj_xypjxx 的信用分。
--      字段依据：金融主题库字段表_20250715.xlsx。该表的评价日期字段是
--      evalu_dt，不要与 3.8 的 dw_nb_sw_xypjxxa.eval_dt 混淆；
--      对外仍输出别名 eval_dt，保持 company_profile 等下游引用不变。
-- ----------------------------------------------------------------------------
DROP TABLE IF EXISTS company_cred;
CREATE TABLE company_cred AS
SELECT
    core.*,
    agg.cred_scard,             -- 最新评价日期的信用分
    agg.evalu_dt AS eval_dt     -- 评价日期（源字段名 evalu_dt）
FROM company_core core
LEFT JOIN (
    SELECT *
    FROM (
        SELECT uni_social_crd_cd, cred_scard, evalu_dt,
               ROW_NUMBER() OVER (PARTITION BY uni_social_crd_cd
                                  ORDER BY evalu_dt DESC) AS rn
        FROM dw_nb_dsj_xypjxx
    ) t
    WHERE rn = 1
) agg ON core.uni_social_crd_cd = agg.uni_social_crd_cd;

-- ----------------------------------------------------------------------------
-- 3.16 汇总宽表 company_profile
--      把上面 14 张平行扩展表按信用代码拼成一张表，供 SECTION 4 / 5 统计，
--      也便于直接导出 CSV。只取各表的扩展字段，不重复搬运 core.*。
-- ----------------------------------------------------------------------------
DROP TABLE IF EXISTS company_profile;
CREATE TABLE company_profile AS
SELECT
    c.uni_social_crd_cd, c.comp_nm, c.comp_type, c.reg_state, c.indv_nm,
    c.reg_capt, c.est_dt,
    -- c.opt_strict,
    c.domdi_strict, c.reg_org,

    f.fddb_nm, f.fddb_tel_num,

    j.jyyc_count, j.jyyc_latest_inclu_dt, j.jyyc_latest_reason,
    y.yzwf_count, y.latest_serill_rea,
    w.wzwd_url,
    g.gqbg_count, g.latest_gqbg_dt,

    n.asset_zmt, n.debt_amt, n.nb_opt_income_total, n.nb_profit_total,
    n.nb_net_profit, n.nb_tax_total, n.nb_year,

    s.tax_amt, s.sale_inco, s.count_dt,
    xp.tax_credi_level, xp.eval_year,
    cr.cred_scard, cr.eval_dt AS cred_eval_dt,

    sx.sxr_count, sx.latest_executed_nm, sx.latest_executed_court, sx.latest_fil_dt,
    xz.xzcf_count, xz.latest_punish_doc, xz.latest_punish_dt, xz.latest_punish_rea,

    d.db_count, d.latest_creditor, d.latest_credit_amt,
    sb.pens_num, sb.medic_num, sb.unemploy_num, sb.injury_num, sb.materni_num,
    sb.pens_pay_ym, sb.issue_start_dt,
    kj.congniz_year
FROM company_core c
LEFT JOIN company_fddb     f  ON c.uni_social_crd_cd = f.uni_social_crd_cd
LEFT JOIN company_jyyc     j  ON c.uni_social_crd_cd = j.uni_social_crd_cd
LEFT JOIN company_yzwf     y  ON c.uni_social_crd_cd = y.uni_social_crd_cd
LEFT JOIN company_wzwd     w  ON c.uni_social_crd_cd = w.uni_social_crd_cd
LEFT JOIN company_gqbg     g  ON c.uni_social_crd_cd = g.uni_social_crd_cd
LEFT JOIN company_nb       n  ON c.uni_social_crd_cd = n.uni_social_crd_cd
LEFT JOIN company_ns       s  ON c.uni_social_crd_cd = s.uni_social_crd_cd
LEFT JOIN company_xypj     xp ON c.uni_social_crd_cd = xp.uni_social_crd_cd
LEFT JOIN company_cred     cr ON c.uni_social_crd_cd = cr.uni_social_crd_cd
LEFT JOIN company_sxr      sx ON c.uni_social_crd_cd = sx.uni_social_crd_cd
LEFT JOIN company_xzcf     xz ON c.uni_social_crd_cd = xz.uni_social_crd_cd
LEFT JOIN company_db       d  ON c.uni_social_crd_cd = d.uni_social_crd_cd
LEFT JOIN company_sb_jbxx  sb ON c.uni_social_crd_cd = sb.uni_social_crd_cd
LEFT JOIN company_kjzx     kj ON c.uni_social_crd_cd = kj.uni_social_crd_cd;

-- 3.17 扩展结果校验：三个数字应当完全相等，否则说明有表出现了一对多膨胀
SELECT
    (SELECT COUNT(*) FROM company_core)    AS core_rows,
    (SELECT COUNT(*) FROM company_profile) AS profile_rows,
    (SELECT COUNT(DISTINCT uni_social_crd_cd) FROM company_profile) AS profile_unique;


-- ############################################################################
-- SECTION 4  文旅企业统计（统一口径）
-- 口径：基于 SECTION 2 的 company_core 全量，数据取自汇总宽表 company_profile。
-- 每段输出一行“统计类别 + 指标列”的宽表，可直接复制进报告或 Excel。
-- 指标名用英文别名，中文含义写在行内注释里。
-- ############################################################################

-- 4.1 基础数据：企业总数、行业小类数、企业类型数、涉及区县数
SELECT
    '基础数据' AS statistics_category,
    COUNT(*)                        AS total_company,
    COUNT(DISTINCT indv_nm)         AS industry_count,
    COUNT(DISTINCT comp_type)       AS company_type_count,
    COUNT(DISTINCT domdi_strict)    AS district_count
FROM company_profile;

-- 4.2 企业家数：各类监管、信用、经营特征覆盖多少家企业
SELECT
    '企业家数统计' AS statistics_category,
    COUNT(*) AS total_company,
    SUM(CASE WHEN jyyc_count > 0 THEN 1 ELSE 0 END)              AS abnormal_operation_company,
    SUM(CASE WHEN yzwf_count > 0 THEN 1 ELSE 0 END)              AS serious_violation_company,
    SUM(CASE WHEN sxr_count > 0 THEN 1 ELSE 0 END)               AS dishonest_executed_company,
    SUM(CASE WHEN congniz_year IS NOT NULL THEN 1 ELSE 0 END)    AS tech_small_company,
    SUM(CASE WHEN UPPER(tax_credi_level) = 'A' THEN 1 ELSE 0 END) AS grade_a_taxpayer_company,
    SUM(CASE WHEN wzwd_url IS NOT NULL THEN 1 ELSE 0 END)        AS company_with_website,
    SUM(CASE WHEN xzcf_count > 0 THEN 1 ELSE 0 END)              AS company_with_penalty,
    SUM(CASE WHEN gqbg_count > 0 THEN 1 ELSE 0 END)              AS company_with_equity_change,
    SUM(CASE WHEN db_count > 0 THEN 1 ELSE 0 END)                AS company_with_guarantee,
    SUM(CASE WHEN pens_num IS NOT NULL THEN 1 ELSE 0 END)        AS company_with_social_insurance
FROM company_profile;

-- 4.3 经营状况：只看有财务或纳税数据的企业，均值与合计
--     年报财务（nb_*）与税务纳税（tax_amt / sale_inco）分开列示。
SELECT
    '经营状况统计' AS statistics_category,
    COUNT(*) AS company_with_financial_data,
    ROUND(AVG(asset_zmt), 2)          AS avg_total_assets,
    ROUND(SUM(asset_zmt), 2)          AS total_assets,
    ROUND(AVG(nb_opt_income_total), 2) AS avg_operating_income,
    ROUND(SUM(nb_opt_income_total), 2) AS total_operating_income,
    ROUND(AVG(nb_net_profit), 2)       AS avg_net_profit,
    ROUND(SUM(nb_net_profit), 2)       AS total_net_profit,
    ROUND(AVG(nb_tax_total), 2)        AS avg_annual_tax,
    ROUND(SUM(nb_tax_total), 2)        AS total_annual_tax,
    ROUND(AVG(tax_amt), 2)            AS avg_tax_amount,
    ROUND(SUM(tax_amt), 2)            AS total_tax_amount,
    ROUND(AVG(sale_inco), 2)          AS avg_sale_income
FROM company_profile
WHERE asset_zmt IS NOT NULL
   OR nb_opt_income_total IS NOT NULL
   OR tax_amt IS NOT NULL;

-- 4.4 社保参与：参保企业数、参保率、五险平均参保人数
SELECT
    '社保参与统计' AS statistics_category,
    COUNT(*) AS total_company,
    SUM(CASE WHEN pens_num IS NOT NULL THEN 1 ELSE 0 END) AS company_with_social_insurance,
    SUM(CASE WHEN pens_num IS NULL THEN 1 ELSE 0 END)     AS company_without_social_insurance,
    ROUND(SUM(CASE WHEN pens_num IS NOT NULL THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2)
                                                          AS social_insurance_participation_rate,
    ROUND(AVG(pens_num), 2)     AS avg_pension_insurance_count,
    ROUND(AVG(medic_num), 2)    AS avg_medical_insurance_count,
    ROUND(AVG(unemploy_num), 2) AS avg_unemployment_insurance_count,
    ROUND(AVG(injury_num), 2)   AS avg_work_injury_insurance_count,
    ROUND(AVG(materni_num), 2)  AS avg_maternity_insurance_count
FROM company_profile;

-- 4.5 变更活动：人均各类监管与变更记录数
SELECT
    '企业变更活动统计' AS statistics_category,
    COUNT(*) AS total_company,
    ROUND(AVG(jyyc_count), 2) AS avg_abnormal_operation_records,
    ROUND(AVG(yzwf_count), 2) AS avg_serious_violation_records,
    ROUND(AVG(gqbg_count), 2) AS avg_equity_change_records,
    ROUND(AVG(sxr_count), 2)  AS avg_dishonest_execution_records,
    ROUND(AVG(db_count), 2)   AS avg_guarantee_records,
    ROUND(AVG(xzcf_count), 2) AS avg_penalty_records
FROM company_profile;

-- 4.6 信用状况：纳税信用等级分布，以及公共信用评价覆盖率
SELECT
    '企业信用状况统计' AS statistics_category,
    COUNT(*) AS total_company,
    SUM(CASE WHEN UPPER(tax_credi_level) = 'A' THEN 1 ELSE 0 END) AS grade_a_taxpayers,
    SUM(CASE WHEN UPPER(tax_credi_level) = 'B' THEN 1 ELSE 0 END) AS grade_b_taxpayers,
    SUM(CASE WHEN UPPER(tax_credi_level) = 'C' THEN 1 ELSE 0 END) AS grade_c_taxpayers,
    SUM(CASE WHEN UPPER(tax_credi_level) = 'D' THEN 1 ELSE 0 END) AS grade_d_taxpayers,
    ROUND(SUM(CASE WHEN UPPER(tax_credi_level) = 'A' THEN 1 ELSE 0 END)
          * 100.0 / COUNT(*), 2)                                   AS grade_a_rate,
    SUM(CASE WHEN cred_scard IS NOT NULL THEN 1 ELSE 0 END)        AS company_with_credit_evaluation,
    ROUND(SUM(CASE WHEN cred_scard IS NOT NULL THEN 1 ELSE 0 END)
          * 100.0 / COUNT(*), 2)                                   AS credit_evaluation_rate
FROM company_profile;

-- 4.7 成立时间分布：四个时间段的企业数与占比
SELECT
    '企业成立时间分布' AS statistics_category,
    SUM(CASE WHEN est_dt >= '2020-01-01' THEN 1 ELSE 0 END) AS company_after_2020,
    SUM(CASE WHEN est_dt >= '2015-01-01' AND est_dt < '2020-01-01' THEN 1 ELSE 0 END) AS company_2015_2019,
    SUM(CASE WHEN est_dt >= '2010-01-01' AND est_dt < '2015-01-01' THEN 1 ELSE 0 END) AS company_2010_2014,
    SUM(CASE WHEN est_dt < '2010-01-01' THEN 1 ELSE 0 END) AS company_before_2010,
    ROUND(SUM(CASE WHEN est_dt >= '2020-01-01' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS percentage_after_2020,
    ROUND(SUM(CASE WHEN est_dt >= '2015-01-01' AND est_dt < '2020-01-01' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS percentage_2015_2019,
    ROUND(SUM(CASE WHEN est_dt >= '2010-01-01' AND est_dt < '2015-01-01' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS percentage_2010_2014,
    ROUND(SUM(CASE WHEN est_dt < '2010-01-01' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS percentage_before_2010
FROM company_profile;

-- 4.8 行业分布：企业数最多的 20 个行业小类
SELECT
    '行业分布统计' AS statistics_category,
    indv_nm,
    COUNT(*) AS company_count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM company_profile), 2) AS percentage
FROM company_profile
GROUP BY indv_nm
ORDER BY company_count DESC
LIMIT 20;


-- ############################################################################
-- SECTION 5  区域结构（统一文旅口径）
-- 描述统一文旅主体的区域分布，数据取自 company_profile。
-- 行业小类分布见 4.8 与 6.4。
-- ############################################################################

-- 5.1 按住所行政区划（区县）分布
SELECT
    COALESCE(domdi_strict, '未填写') AS district,
    COUNT(*)                        AS company_count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM company_profile), 2) AS percentage,
    ROUND(AVG(asset_zmt), 2)        AS avg_total_assets
FROM company_profile
GROUP BY COALESCE(domdi_strict, '未填写')
ORDER BY company_count DESC;

-- 5.2 按登记机关分布
SELECT
    COALESCE(reg_org, '未填写') AS reg_org,
    COUNT(*)                   AS company_count
FROM company_profile
GROUP BY COALESCE(reg_org, '未填写')
ORDER BY company_count DESC;


-- ############################################################################
-- SECTION 6  报告取数（统一文旅口径）
-- 报告数字全部基于 SECTION 2 按 63 个行业代码筛出的 company，
-- 先建统一分析底表 rpt_wenlv，再由该表出各口径数字。
-- ############################################################################

-- ----------------------------------------------------------------------------
-- 6.1 统一分析底表 rpt_wenlv
--     以 company 为基础保留报告所需字段，行业代码取 indv_nm 原值，
--     企业类型取市场主体总表的 comp_type 原值。
-- ----------------------------------------------------------------------------
DROP TABLE IF EXISTS rpt_wenlv;
CREATE TABLE rpt_wenlv AS
SELECT
    c.uni_social_crd_cd,
    c.comp_nm,
    c.indv_nm,
    c.comp_type,
    c.reg_state,
    c.reg_org,
    c.est_dt,
    -- c.opt_strict,
    c.domdi_strict
FROM company c
ORDER BY c.uni_social_crd_cd;

-- 校验：rpt_wenlv 行数应与 company 一致
SELECT (SELECT COUNT(*) FROM company)   AS company_rows,
       (SELECT COUNT(*) FROM rpt_wenlv) AS rpt_wenlv_rows;

-- ----------------------------------------------------------------------------
-- 6.2 报告核心数字：经营主体总量与企业类型取值数
--     企业类型分布见 6.5，需要公司制企业、个体工商户等归类时，
--     由报告阶段按 comp_type 的实际取值判断。
-- ----------------------------------------------------------------------------
SELECT
    COUNT(DISTINCT uni_social_crd_cd) AS total_wenlv_company,
    COUNT(DISTINCT comp_type)         AS comp_type_value_count
FROM rpt_wenlv;

-- ----------------------------------------------------------------------------
-- 6.3 行业覆盖度：63 个行业代码中实际覆盖了多少个
-- ----------------------------------------------------------------------------
SELECT
    COUNT(DISTINCT indv_nm) AS covered_industry_count,
    (SELECT COUNT(*) FROM industry_codes) AS total_industry_count,
    ROUND(COUNT(DISTINCT indv_nm) * 100.0
          / (SELECT COUNT(*) FROM industry_codes), 2) AS coverage_rate
FROM rpt_wenlv;

-- ----------------------------------------------------------------------------
-- 6.4 企业数量最多的 10 个行业小类（按行业代码）
-- ----------------------------------------------------------------------------
SELECT
    indv_nm,
    COUNT(DISTINCT uni_social_crd_cd) AS company_count,
    ROUND(COUNT(DISTINCT uni_social_crd_cd) * 100.0
          / (SELECT COUNT(DISTINCT uni_social_crd_cd) FROM rpt_wenlv), 2) AS percentage
FROM rpt_wenlv
GROUP BY indv_nm
ORDER BY company_count DESC
LIMIT 10;

-- ----------------------------------------------------------------------------
-- 6.5 企业类型与登记状态分布
--     企业类型直接按市场主体总表的 comp_type 原值分组，供报告阶段自行归类。
-- ----------------------------------------------------------------------------
SELECT
    COALESCE(comp_type, '未知') AS comp_type_value,
    COUNT(DISTINCT uni_social_crd_cd) AS company_count
FROM rpt_wenlv
GROUP BY COALESCE(comp_type, '未知')
ORDER BY company_count DESC;

SELECT
    COALESCE(reg_state, '未知') AS reg_state,
    COUNT(DISTINCT uni_social_crd_cd) AS company_count
FROM rpt_wenlv
GROUP BY COALESCE(reg_state, '未知')
ORDER BY company_count DESC;

-- ----------------------------------------------------------------------------
-- 6.6 社会贡献与信用：取自 SECTION 3 的 company_profile。
-- ----------------------------------------------------------------------------
SELECT
    COUNT(*) AS total_company,
    SUM(CASE WHEN pens_num IS NOT NULL THEN 1 ELSE 0 END) AS with_social_insurance,
    ROUND(AVG(pens_num), 2)          AS avg_pension_insurance_count,
    SUM(CASE WHEN tax_amt IS NOT NULL THEN 1 ELSE 0 END) AS with_tax_data,
    ROUND(SUM(tax_amt), 2)           AS total_tax_amount,
    ROUND(AVG(nb_opt_income_total), 2) AS avg_operating_income,
    SUM(CASE WHEN tax_credi_level IS NOT NULL THEN 1 ELSE 0 END) AS with_tax_credit_level,
    SUM(CASE WHEN UPPER(tax_credi_level) = 'A' THEN 1 ELSE 0 END) AS grade_a_taxpayers,
    SUM(CASE WHEN cred_scard IS NOT NULL THEN 1 ELSE 0 END) AS with_credit_score
FROM company_profile;


-- ############################################################################
-- SECTION 7  执行后核对清单
-- ############################################################################

-- 7.1 各阶段表行数。company 与 rpt_wenlv 行数相同；company_core 与
--     company_profile 行数相同（已按信用代码去重）。
SELECT 'company'          AS tbl, COUNT(*) AS rows_cnt FROM company
UNION ALL SELECT 'company_core',    COUNT(*) FROM company_core
UNION ALL SELECT 'company_profile', COUNT(*) FROM company_profile
UNION ALL SELECT 'rpt_wenlv',       COUNT(*) FROM rpt_wenlv;

-- 7.2 统一口径核对：四张表的去重企业数应当完全一致。
SELECT
    (SELECT COUNT(DISTINCT uni_social_crd_cd) FROM company)         AS company_count,
    (SELECT COUNT(DISTINCT uni_social_crd_cd) FROM company_core)    AS core_count,
    (SELECT COUNT(DISTINCT uni_social_crd_cd) FROM company_profile) AS profile_count,
    (SELECT COUNT(DISTINCT uni_social_crd_cd) FROM rpt_wenlv)       AS rpt_count;

-- 7.3 行业覆盖度：宁波文旅主体实际覆盖的国民经济行业小类数。
SELECT COUNT(DISTINCT indv_nm) AS covered_industry_count FROM rpt_wenlv;

-- 7.4 抽查扩展表的空值情况，判断是源表确实没有数据还是关联键没对上。
SELECT
    COUNT(*) AS total_company,
    SUM(CASE WHEN asset_zmt IS NOT NULL THEN 1 ELSE 0 END)   AS with_annual_report,
    SUM(CASE WHEN tax_amt IS NOT NULL THEN 1 ELSE 0 END)     AS with_tax_data,
    SUM(CASE WHEN pens_num IS NOT NULL THEN 1 ELSE 0 END)    AS with_social_insurance,
    SUM(CASE WHEN cred_scard IS NOT NULL THEN 1 ELSE 0 END)  AS with_credit_score,
    SUM(CASE WHEN tax_credi_level IS NOT NULL THEN 1 ELSE 0 END) AS with_tax_credit_level
FROM company_profile;

-- ############################################################################
-- SECTION 8  信用质量较好企业遴选（TOP 3000）
-- 口径：
--   1. 候选池为 SECTION 2 按 industry_codes 中 63 个行业代码筛出的统一文旅企业，
--      取数用 SECTION 3.16 的 company_profile（一企业一行）。
--      本段的删除只作用于遴选名单，不回写 company / company_core，
--      因此 SECTION 4 / 5 / 6 的企业总数与分类统计保持全量口径不变。
--   2. 删除情形：行政处罚 xzcf_count、严重违法失信 yzwf_count、
--      经营异常 jyyc_count，以及失信被执行人 sxr_count。
--      四项都用 COALESCE 归零，无记录视同无此情形；任一命中即从名单删除。
--      若只需删除其中若干项，去掉 8.2 中对应的 AND 条件即可。
--   3. 数据时点：财务数据以 2025 年度年报为准（正常企业在次年 1 至 6 月
--      完成报送）。只有 nb_year = 2025 且 asset_zmt 不为空的企业才进名单，
--      取不到 2025 年末资产数据的一律去除，不按名次靠后处理。
--   4. 企业规模按年报资产总额 asset_zmt 排名，资产取自 2025 年度年报
--      （2025 年末时点，见 SECTION 3 的 company_nb）；营收类字段同源。
--      用名次而非原值，可压低极端值对排序的影响。
--   5. 社保人数取 pens_num（养老保险人数，见 SECTION 3 的
--      company_sb_jbxx 与 4.4），缺失时该维度名次并列靠后。
--   6. 在通过删除条件的企业中分别按 asset_zmt、pens_num 降序取名次，
--      综合名次为两个名次之和，升序取前 3000 名；并列时依次按资产原值、
--      社保原值、统一社会信用代码固定次序，保证重复执行结果一致。
-- ############################################################################

-- ----------------------------------------------------------------------------
-- 8.1 候选池：逐项打上删除标记，便于核对各类情形命中多少家企业
--     经营异常字段在本文件中名为 jyyc_count，源表 dw_zj_scjdgl_jyycmlxx。
--     excl_no_2025_asset 是数据时点标记，没有 2025 年度年报资产即置 1。
-- ----------------------------------------------------------------------------
DROP TABLE IF EXISTS selection_pool;
CREATE TABLE selection_pool AS
SELECT
    p.uni_social_crd_cd,
    p.comp_nm,
    p.indv_nm,
    p.comp_type,
    p.reg_state,
    p.reg_capt,
    p.est_dt,
    p.domdi_strict,
    p.reg_org,
    p.asset_zmt,
    p.nb_year,
    p.pens_num,
    CASE WHEN COALESCE(p.xzcf_count, 0)  > 0 THEN 1 ELSE 0 END AS excl_xzcf,
    CASE WHEN COALESCE(p.yzwf_count, 0)  > 0 THEN 1 ELSE 0 END AS excl_yzwf,
    CASE WHEN COALESCE(p.jyyc_count, 0) > 0 THEN 1 ELSE 0 END AS excl_jyyc,
    CASE WHEN COALESCE(p.sxr_count,  0) > 0 THEN 1 ELSE 0 END AS excl_sxr,
    CASE WHEN p.nb_year = 2025 AND p.asset_zmt IS NOT NULL
         THEN 0 ELSE 1 END AS excl_no_2025_asset
FROM company_profile p;

-- ----------------------------------------------------------------------------
-- 8.2 通过删除条件与时点要求的企业，按资产规模与社保人数分别排名
--     RANK 让取值相同的企业共用一个名次，避免并列被随机拆开。
-- ----------------------------------------------------------------------------
DROP TABLE IF EXISTS selection_ranked;
CREATE TABLE selection_ranked AS
SELECT
    t.*,
    RANK() OVER (ORDER BY t.asset_zmt DESC) AS asset_rank,
    RANK() OVER (ORDER BY t.pens_num  DESC) AS social_rank
FROM (
    SELECT s.*
    FROM selection_pool s
    WHERE s.excl_xzcf = 0
      AND s.excl_yzwf = 0
      AND s.excl_jyyc = 0
      AND s.excl_sxr  = 0
      AND s.excl_no_2025_asset = 0
) t;

-- ----------------------------------------------------------------------------
-- 8.3 最终名单：综合名次升序取前 3000 名
-- ----------------------------------------------------------------------------
DROP TABLE IF EXISTS selected_top3000;
CREATE TABLE selected_top3000 AS
SELECT
    ROW_NUMBER() OVER (
        ORDER BY r.asset_rank + r.social_rank,
                 r.asset_zmt DESC,
                 r.pens_num DESC,
                 r.uni_social_crd_cd
    ) AS final_rank,
    (r.asset_rank + r.social_rank) AS combined_rank,
    r.asset_rank,
    r.social_rank,
    r.uni_social_crd_cd,
    r.comp_nm,
    r.indv_nm,
    r.comp_type,
    r.reg_state,
    r.est_dt,
    r.domdi_strict,
    r.reg_org,
    r.asset_zmt,
    r.nb_year,
    r.pens_num,
    r.reg_capt
FROM selection_ranked r
ORDER BY r.asset_rank + r.social_rank,
         r.asset_zmt DESC,
         r.pens_num DESC,
         r.uni_social_crd_cd
LIMIT 3000;

-- 8.4 删除过程核对：四类情形分别命中多少家，另有几家取不到 2025 年末资产
SELECT
    COUNT(*) AS pool_total,
    SUM(excl_xzcf) AS excl_xzcf_company,
    SUM(excl_yzwf) AS excl_yzwf_company,
    SUM(excl_jyyc) AS excl_jyyc_company,
    SUM(excl_sxr)  AS excl_sxr_company,
    SUM(excl_no_2025_asset) AS no_2025_asset_company,
    SUM(CASE WHEN excl_xzcf = 0 AND excl_yzwf = 0
              AND excl_jyyc = 0 AND excl_sxr  = 0
              AND excl_no_2025_asset = 0
             THEN 1 ELSE 0 END) AS eligible_company
FROM selection_pool;

-- 8.5 名单核对：应为 3000 家且无重复；不足 3000 说明合格企业数不够。
--     asset_from_2025_report 应等于入选家数，without_asset_data 应为 0。
SELECT
    COUNT(*) AS selected_rows,
    COUNT(DISTINCT uni_social_crd_cd) AS selected_company,
    MIN(final_rank) AS min_rank,
    MAX(final_rank) AS max_rank,
    MIN(asset_zmt)  AS min_asset_zmt,
    MAX(asset_zmt)  AS max_asset_zmt,
    MIN(pens_num)   AS min_pens_num,
    MAX(pens_num)   AS max_pens_num,
    SUM(CASE WHEN nb_year = 2025 AND asset_zmt IS NOT NULL
             THEN 1 ELSE 0 END)        AS asset_from_2025_report,
    SUM(CASE WHEN asset_zmt IS NULL THEN 1 ELSE 0 END) AS without_asset_data,
    SUM(CASE WHEN pens_num  IS NULL THEN 1 ELSE 0 END) AS without_social_data
FROM selected_top3000;

-- 8.6 残留检查：入选名单里不应有任一删除情形，也不应缺 2025 年末资产，结果应为 0
SELECT COUNT(*) AS residual_excluded
FROM selected_top3000 s
JOIN selection_pool p ON s.uni_social_crd_cd = p.uni_social_crd_cd
WHERE p.excl_xzcf = 1 OR p.excl_yzwf = 1
   OR p.excl_jyyc = 1 OR p.excl_sxr  = 1
   OR p.excl_no_2025_asset = 1;

-- ----------------------------------------------------------------------------
-- 8.7 数据基准日核对：财务数据应为 2025 年度（2025 年末）
--     第一条看财务年度分布。若出现晚于 2025 的年度，说明库里混入了更晚数据，
--     需要先在 SECTION 3 的 company_nb 里限定年度再重跑遴选；若不少企业停在
--     2025 以前，说明其只报了往年，这类企业已按 8.1 的时点标记从名单去除。
--     第二条看市场主体总表里有没有 2025-12-31 之后成立的企业，用来判断
--     文旅企业总数是否需要显式加上成立日期不晚于基准日的条件。
-- ----------------------------------------------------------------------------
SELECT
    nb_year,
    COUNT(*) AS company_count,
    SUM(CASE WHEN asset_zmt IS NOT NULL THEN 1 ELSE 0 END) AS with_asset_data
FROM company_profile
GROUP BY nb_year
ORDER BY nb_year DESC;

SELECT
    SUM(CASE WHEN est_dt > '2025-12-31' THEN 1 ELSE 0 END) AS company_after_2025,
    SUM(CASE WHEN est_dt IS NULL THEN 1 ELSE 0 END)         AS company_without_est_dt,
    MAX(est_dt) AS latest_est_dt
FROM company_profile;

-- 名单预览
SELECT * FROM selected_top3000 ORDER BY final_rank LIMIT 20;

