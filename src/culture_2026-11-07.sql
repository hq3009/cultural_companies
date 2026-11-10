-- 宁波市文旅经营主体数据分析脚本（MaxCompute版）
--
-- 运行环境：阿里云 MaxCompute，连接项目 jrsjc_dev；源表在 odps_jrsjc_pod，
-- 一律写全限定名 odps_jrsjc_pod.dw_xxx；自建表在 jrsjc_dev，保持裸名。
--
-- 逐条执行：DROP 与 CREATE 连续跑完，CREATE 后用自检 SELECT 确认表建成。
-- 往下跑之前必须看 1.2 的 matched_rows，为 0 则停止。
--
-- SECTION 0  执行前检查
-- SECTION 1  行业代码表 industry_codes
-- SECTION 2  主体筛选 company / company_core
-- SECTION 3  维度扩展 company_* / company_profile
-- SECTION 4  企业统计
-- SECTION 5  区域结构
-- SECTION 6  报告取数 rpt_wenlv
-- SECTION 7  执行后核对
-- SECTION 8  TOP 3000 遴选
--
-- ============================================================================
-- SECTION 0  执行前检查
-- ============================================================================
--
-- 0.0 全局自检：单独跑这一条，对照 README 的输出表清单找缺哪张表
SHOW TABLES;

-- 0.1 确认行业代码字段形态。本文件假设 indv_nm 在当前数据中存放的是四位
--     下面只看前 10 个高频取值；是否真的能与代码表匹配，要看 SECTION 1
--     建完 industry_codes 之后的 1.2 核对，那条才是硬校验。
SELECT indv_nm,
    COUNT(*) AS cnt
FROM odps_jrsjc_pod.dw_zj_scjdgl_scztxx
GROUP BY indv_nm
ORDER BY cnt DESC
LIMIT 10;

--
-- ============================================================================
-- SECTION 1  基础代码与字典表
-- 建 industry_codes（63 个四位行业代码）
-- ============================================================================
--
-- ----------------------------------------------------------------------------
-- 1.1 文旅行业代码表：来源 docs/文旅行业名称与行业代码.xlsx，只存代码。
--     63 个代码只在此维护，下游统一用 IN (SELECT indv_nm FROM industry_codes)。
--     MaxCompute 版为 STRING、无主键、COMMENT 不带等号；每次先 DROP 再 CREATE。
-- ----------------------------------------------------------------------------
DROP TABLE IF EXISTS industry_codes;

CREATE TABLE industry_codes (indv_nm STRING COMMENT '国民经济行业小类') COMMENT '文旅行业代码表';

INSERT INTO TABLE industry_codes
VALUES ('3471'),
    ('3931'),
    ('3932'),
    ('3933'),
    ('3934'),
    ('3939'),
    ('3953'),
    ('5143'),
    ('5144'),
    ('5145'),
    ('5178'),
    ('5181'),
    ('5243'),
    ('5244'),
    ('5422'),
    ('5511'),
    ('5512'),
    ('5513'),
    ('5531'),
    ('5622'),
    ('5822'),
    ('6110'),
    ('6121'),
    ('6129'),
    ('6321'),
    ('6322'),
    ('6331'),
    ('7124'),
    ('7125'),
    ('7291'),
    ('7298'),
    ('7712'),
    ('7715'),
    ('7716'),
    ('7850'),
    ('7861'),
    ('7862'),
    ('7869'),
    ('8070'),
    ('8610'),
    ('8621'),
    ('8622'),
    ('8623'),
    ('8624'),
    ('8629'),
    ('8710'),
    ('8720'),
    ('8750'),
    ('8760'),
    ('8810'),
    ('8820'),
    ('8840'),
    ('8850'),
    ('8860'),
    ('9011'),
    ('9012'),
    ('9013'),
    ('9020'),
    ('9051'),
    ('9053'),
    ('9059'),
    ('9090'),
    ('9542');

SELECT COUNT(*) AS industry_code_count
FROM industry_codes;

-- ----------------------------------------------------------------------------
-- 1.2 硬校验：确认 indv_nm 与代码表能否匹配。
--     matched_rows 为 0 或明显偏小，说明该字段不是四位代码，SECTION 2 会筛出
--     空表且不报错。此时改用正确代码字段或清洗源表，再往下执行。
-- ----------------------------------------------------------------------------
SELECT COUNT(*) AS total_rows,
    SUM(
        CASE
            WHEN c.indv_nm IS NOT NULL THEN 1
            ELSE 0
        END
    ) AS matched_rows,
    COUNT(DISTINCT s.indv_nm) AS distinct_indv_nm
FROM odps_jrsjc_pod.dw_zj_scjdgl_scztxx s
    LEFT JOIN (
        SELECT DISTINCT indv_nm
        FROM industry_codes
    ) c ON s.indv_nm = c.indv_nm;

-- ############################################################################
-- SECTION 2  文旅经营主体筛选
-- ############################################################################
-- 去重前核对：看同一信用代码是否确有多条记录，以及 appr_dt 能否区分新旧
SELECT uni_social_crd_cd,
    COUNT(*) AS record_count,
    COUNT(DISTINCT appr_dt) AS appr_dt_kinds,
    MIN(appr_dt) AS first_appr_dt,
    MAX(appr_dt) AS latest_appr_dt
FROM odps_jrsjc_pod.dw_zj_scjdgl_scztxx
WHERE indv_nm IN (
        SELECT indv_nm
        FROM industry_codes
    )
GROUP BY uni_social_crd_cd
HAVING COUNT(*) > 1
ORDER BY record_count DESC
LIMIT 20;

-- ----------------------------------------------------------------------------
-- 2.1 创建 company 表
--     按 63 个行业代码提取，按信用代码去重留最新一条
-- ----------------------------------------------------------------------------
DROP TABLE IF EXISTS company;

CREATE TABLE company AS
SELECT reg_org,
    comp_nm,
    uni_social_crd_cd addr,
    domdi_strict,
    comp_type,
    appr_dt,
    est_dt,
    indv_id,
    indv_nm,
    legal_repre,
    reg_capt,
    reg_org,
    reg_state,
    reg_state,
    FROM (
        SELECT s.*,
            ROW_NUMBER() OVER (
                PARTITION BY s.uni_social_crd_cd
                ORDER BY s.appr_dt DESC
            ) AS rn
        FROM odps_jrsjc_pod.dw_zj_scjdgl_scztxx s
        WHERE s.indv_nm IN (
                SELECT indv_nm
                FROM industry_codes
            )
    ) t
WHERE rn = 1;

-- MaxCompute 表存储无序，CTAS 末尾的 ORDER BY 无意义且会触发 LIMIT 校验，已删除。
-- 显示创建结果：company 与 unique_company 应相等，否则说明去重未生效
SELECT COUNT(*) AS company,
    COUNT(DISTINCT uni_social_crd_cd) AS unique_company,
    COUNT(DISTINCT indv_nm) AS unique_indv_nm,
    COUNT(DISTINCT comp_type) AS unique_company_types,
    COUNT(DISTINCT domdi_strict) AS unique_districts
FROM company;

-- 显示表结构
DESC company;

-- 显示前10条记录
SELECT *
FROM company
LIMIT 10;

-- 查看 reg_state 的所有可能值
SELECT DISTINCT reg_state
FROM company
ORDER BY reg_state
LIMIT 100;

-- 统计每种 reg_state 的数量
SELECT reg_state,
    COUNT(*) AS count_per_state
FROM company
GROUP BY reg_state
ORDER BY count_per_state DESC
LIMIT 1000;

-- 企业类型分布（筛选后）：按 comp_type 原值看文旅企业的构成，供报告阶段归类
SELECT COALESCE(comp_type, '未知') AS comp_type_value,
    COUNT(*) AS company_count
FROM company
GROUP BY COALESCE(comp_type, '未知')
ORDER BY company_count DESC
LIMIT 1000;

-- ----------------------------------------------------------------------------
-- 2.2 创建企业核心信息表
--     抽取核心字段，作为全链路基准表
-- ----------------------------------------------------------------------------
DROP TABLE IF EXISTS company_core;

CREATE TABLE company_core AS
SELECT comp_nm,
    uni_social_crd_cd,
    indv_nm,
    indv_id,
    comp_type,
    addr,
    domdi_strict,
    reg_org,
    reg_state,
    reg_capt,
    est_dt,
    appr_dt,
    FROM company;

SELECT COUNT(*) AS core_count
FROM company_core;

-- 显示表结构
DESC company_core;

-- 显示前10条记录
SELECT *
FROM company_core
LIMIT 10;

-- ============================================================================
-- SECTION 3  企业维度扩展
-- 以 company_core 为基准，各扩展表平行生成、先在源表内预聚合再左连。
-- 字段命名：*_count 次数、latest_* 最新值、nb_ 年报财务。
-- ============================================================================
--
-- ----------------------------------------------------------------------------
-- 3.1 扩展经营异常名录信息
-- ----------------------------------------------------------------------------
DROP TABLE IF EXISTS company_jyyc;

CREATE TABLE company_jyyc AS
SELECT core.*,
    COALESCE(jyyc_agg.jyyc_count, 0) AS jyyc_count,
    jyyc_agg.jyyc_latest_inclu_dt,
    jyyc_agg.jyyc_latest_reason
FROM company_core core
    LEFT JOIN (
        SELECT uni_social_crd_cd,
            COUNT(*) AS jyyc_count,
            MAX(
                CASE
                    WHEN rn = 1 THEN inclu_dt
                END
            ) AS jyyc_latest_inclu_dt,
            MAX(
                CASE
                    WHEN rn = 1 THEN inclu_reason
                END
            ) AS jyyc_latest_reason
        FROM (
                SELECT uni_social_crd_cd,
                    inclu_dt,
                    inclu_reason,
                    ROW_NUMBER() OVER (
                        PARTITION BY uni_social_crd_cd
                        ORDER BY inclu_dt DESC,
                            busexclist
                    ) AS rn
                FROM odps_jrsjc_pod.dw_zj_scjdgl_jyycmlxx
            ) t
        GROUP BY uni_social_crd_cd
    ) jyyc_agg ON core.uni_social_crd_cd = jyyc_agg.uni_social_crd_cd;

SELECT COUNT(*) AS jyyc_count
FROM company_jyyc;

SELECT *
FROM company_jyyc
LIMIT 10;

-- ----------------------------------------------------------------------------
-- 扩展严重违法失信企业名单信息
-- ----------------------------------------------------------------------------
DROP TABLE IF EXISTS company_yzwf;

CREATE TABLE company_yzwf AS
SELECT core.*,
    COALESCE(yzwf_agg.yzwf_count, 0) AS yzwf_count,
    yzwf_agg.latest_serill_rea
FROM company_core core
    LEFT JOIN (
        SELECT uni_social_crd_cd,
            COUNT(*) AS yzwf_count,
            MAX(
                CASE
                    WHEN rn = 1 THEN serill_rea
                END
            ) AS latest_serill_rea
        FROM (
                SELECT uni_social_crd_cd,
                    serill_rea,
                    ROW_NUMBER() OVER (
                        PARTITION BY uni_social_crd_cd
                        ORDER BY abn_tm DESC,
                            ill_comp_id
                    ) AS rn
                FROM odps_jrsjc_pod.dw_zj_scjdgl_yzwfsx
            ) t
        GROUP BY uni_social_crd_cd
    ) yzwf_agg ON core.uni_social_crd_cd = yzwf_agg.uni_social_crd_cd;

SELECT COUNT(*) AS yzwf_count
FROM company_yzwf;

-- 3.3 数据形态核对：abn_tm 若为 '2019-9-4' 这类非补零字符串，字典序降序会误判月份，
--     需改用 ORDER BY TO_DATE(abn_tm, 'yyyy-MM-dd') DESC, ill_comp_id。
SELECT abn_tm,
    COUNT(*) AS cnt
FROM odps_jrsjc_pod.dw_zj_scjdgl_yzwfsx
GROUP BY abn_tm
ORDER BY cnt DESC
LIMIT 20;

SELECT *
FROM company_yzwf
LIMIT 10;

-- ==========================================
-- 扩展企业年报网站或网店信息（先 ROW_NUMBER 取最新再左连，不用相关标量子查询）
-- ==========================================
DROP TABLE IF EXISTS company_wzwd;

CREATE TABLE company_wzwd AS
SELECT core.*,
    w.web_store_url AS wzwd_url
FROM company_core core
    LEFT JOIN (
        SELECT uni_social_crd_cd,
            web_store_url
        FROM (
                SELECT uni_social_crd_cd,
                    web_store_url,
                    ROW_NUMBER() OVER (
                        PARTITION BY uni_social_crd_cd
                        ORDER BY annual_year DESC,
                            web_store_url
                    ) AS rn
                FROM odps_jrsjc_pod.dw_nb_scjdgl_qynbwzhwdxx
            ) t
        WHERE rn = 1
    ) w ON core.uni_social_crd_cd = w.uni_social_crd_cd;

SELECT COUNT(*) AS wzwd_count
FROM company_wzwd;

SELECT *
FROM company_wzwd
LIMIT 10;

-- ==========================================
-- 扩展企业年报资产信息：只取不晚于 2025 年度的最新年报，annual_year 先 CAST。
-- 本段口径为“不晚于 2025”，8.1 遴选要求恰为 2025，两处差异见 README。
-- ==========================================
DROP TABLE IF EXISTS company_nb;

CREATE TABLE company_nb AS
SELECT core.*,
    nb_latest.asset_zmt,
    nb_latest.debt_amt,
    nb_latest.opt_income_total AS nb_opt_income_total,
    nb_latest.profit_total AS nb_profit_total,
    nb_latest.net_profit AS nb_net_profit,
    nb_latest.tax_total AS nb_tax_total,
    nb_latest.annual_year AS nb_year
FROM company_core core
    LEFT JOIN (
        SELECT uni_social_crd_cd,
            asset_zmt,
            debt_amt,
            opt_income_total,
            profit_total,
            net_profit,
            tax_total,
            annual_year,
            ROW_NUMBER() OVER (
                PARTITION BY uni_social_crd_cd
                ORDER BY annual_year DESC,
                    annual_id
            ) AS rn
        FROM odps_jrsjc_pod.dw_nb_scjdgl_qynbzcxx
        WHERE CAST(annual_year AS BIGINT) <= 2025
    ) nb_latest ON core.uni_social_crd_cd = nb_latest.uni_social_crd_cd
    AND nb_latest.rn = 1;

-- SELECT * FROM odps_jrsjc_pod.dw_nb_scjdgl_qynbzcxx LIMIT 10;
SELECT COUNT(*) AS nb_count
FROM company_nb;

SELECT *
FROM company_nb
WHERE nb_year IS NOT NULL
LIMIT 100;

SELECT *
FROM company_nb
WHERE CAST(nb_year AS BIGINT) >= 2020
LIMIT 100;

SELECT COUNT(*) AS nb_year_not_zero_count
FROM company_nb
WHERE nb_year IS NOT NULL
    AND CAST(nb_year AS BIGINT) <> 0;

SELECT AVG(asset_zmt) AS avg_asset_zmt_2019
FROM company_nb
WHERE CAST(nb_year AS BIGINT) = 2019
    AND nb_year IS NOT NULL
    AND asset_zmt > 10
    AND asset_zmt < 10000;

-- ==========================================
-- 扩展纳税信息
-- ==========================================
DROP TABLE IF EXISTS company_ns;

CREATE TABLE company_ns AS
SELECT core.*,
    ns_latest.tax_amt,
    ns_latest.sale_inco,
    ns_latest.count_dt
FROM company_core core
    LEFT JOIN (
        SELECT uni_social_crd_cd,
            tax_amt,
            sale_inco,
            count_dt,
            ROW_NUMBER() OVER (
                PARTITION BY uni_social_crd_cd
                ORDER BY count_dt DESC,
                    tax_amt
            ) AS rn
        FROM odps_jrsjc_pod.dw_nb_sw_nsxx
    ) ns_latest ON core.uni_social_crd_cd = ns_latest.uni_social_crd_cd
    AND ns_latest.rn = 1;

SELECT COUNT(*) AS ns_count
FROM company_ns;

SELECT *
FROM company_ns
LIMIT 10;

-- ==========================================
-- 扩展信用评价信息（A级纳税人）
-- ==========================================
DROP TABLE IF EXISTS company_xypj;

CREATE TABLE company_xypj AS
SELECT core.*,
    xypj_latest.tax_credi_level,
    xypj_latest.eval_year
FROM company_core core
    LEFT JOIN (
        SELECT uni_social_crd_cd,
            tax_credi_level,
            eval_year,
            ROW_NUMBER() OVER (
                PARTITION BY uni_social_crd_cd
                ORDER BY eval_dt DESC,
                    sjid
            ) AS rn
        FROM odps_jrsjc_pod.dw_nb_sw_xypjxxa
    ) xypj_latest ON core.uni_social_crd_cd = xypj_latest.uni_social_crd_cd
    AND xypj_latest.rn = 1;

SELECT COUNT(*) AS xypj_count
FROM company_xypj;

SELECT *
FROM company_xypj
LIMIT 10;

-- ==========================================
-- 扩展失信被执行人信息
-- ==========================================
DROP TABLE IF EXISTS company_sxr;

CREATE TABLE company_sxr AS
SELECT core.*,
    COALESCE(sxr_agg.sxr_count, 0) AS sxr_count,
    sxr_agg.latest_executed_nm,
    sxr_agg.latest_executed_court,
    sxr_agg.latest_fil_dt
FROM company_core core
    LEFT JOIN (
        SELECT uni_social_crd_cd,
            COUNT(*) AS sxr_count,
            MAX(
                CASE
                    WHEN rn = 1 THEN executed_nm
                END
            ) AS latest_executed_nm,
            MAX(
                CASE
                    WHEN rn = 1 THEN executed_court
                END
            ) AS latest_executed_court,
            MAX(
                CASE
                    WHEN rn = 1 THEN fil_dt
                END
            ) AS latest_fil_dt
        FROM (
                SELECT uni_social_crd_cd,
                    executed_nm,
                    executed_court,
                    fil_dt,
                    ROW_NUMBER() OVER (
                        PARTITION BY uni_social_crd_cd
                        ORDER BY fil_dt DESC,
                            dishonest_id
                    ) AS rn
                FROM odps_jrsjc_pod.dw_zj_fzgg_sxbzxrxx
            ) t
        GROUP BY uni_social_crd_cd
    ) sxr_agg ON core.uni_social_crd_cd = sxr_agg.uni_social_crd_cd;

-- 3.8 关联键核对：dw_zj_fzgg_sxbzxrxx.uni_social_crd_cd 字典标为“组织机构代码”，
--     matched_company 明显偏低时 sxr_count 不可信，需先确认真实关联字段。
SELECT COUNT(*) AS total_company,
    SUM(
        CASE
            WHEN sxr_count > 0 THEN 1
            ELSE 0
        END
    ) AS matched_company
FROM company_sxr;

SELECT COUNT(*) AS sxr_count
FROM company_sxr;

SELECT *
FROM company_sxr
LIMIT 10;

-- ==========================================
-- 扩展行政处罚信息（最终表）
-- ==========================================
DROP TABLE IF EXISTS company_xzcf;

CREATE TABLE company_xzcf AS
SELECT core.*,
    COALESCE(xzcf_agg.xzcf_count, 0) AS xzcf_count,
    xzcf_agg.latest_punish_doc,
    xzcf_agg.latest_punish_dt,
    xzcf_agg.latest_punish_rea
FROM company_core core
    LEFT JOIN (
        SELECT uni_social_crd_cd,
            COUNT(*) AS xzcf_count,
            MAX(
                CASE
                    WHEN rn = 1 THEN admin_punish_doc
                END
            ) AS latest_punish_doc,
            MAX(
                CASE
                    WHEN rn = 1 THEN punish_dt
                END
            ) AS latest_punish_dt,
            MAX(
                CASE
                    WHEN rn = 1 THEN punish_rea
                END
            ) AS latest_punish_rea
        FROM (
                SELECT uni_social_crd_cd,
                    admin_punish_doc,
                    punish_dt,
                    punish_rea,
                    ROW_NUMBER() OVER (
                        PARTITION BY uni_social_crd_cd
                        ORDER BY punish_dt DESC,
                            admin_punish_doc
                    ) AS rn
                FROM odps_jrsjc_pod.dw_nb_scjdgl_xzcfgsxx
            ) t
        GROUP BY uni_social_crd_cd
    ) xzcf_agg ON core.uni_social_crd_cd = xzcf_agg.uni_social_crd_cd;

SELECT COUNT(*) AS xzcf_count
FROM company_xzcf;

SELECT *
FROM company_xzcf
LIMIT 10;

-- ----------------------------------------------------------------------------
-- 3.11 股权变更补建：源表 odps_jrsjc_pod.dw_nb_scjdgl_gqbg，先在源表按信用代码
--      聚合保证一企业一行，再 LEFT JOIN（字段见 tables.md）。
-- ----------------------------------------------------------------------------
DROP TABLE IF EXISTS company_gqbg;

CREATE TABLE company_gqbg AS
SELECT core.*,
    COALESCE(agg.gqbg_count, 0) AS gqbg_count,
    agg.latest_gqbg_dt
FROM company_core core
    LEFT JOIN (
        SELECT uni_social_crd_cd,
            COUNT(*) AS gqbg_count,
            MAX(alt_dt) AS latest_gqbg_dt
        FROM odps_jrsjc_pod.dw_nb_scjdgl_gqbg
        GROUP BY uni_social_crd_cd
    ) agg ON core.uni_social_crd_cd = agg.uni_social_crd_cd;

-- 3.11 关联命中率核对：为 0 说明源表关联键不是统一社会信用代码
SELECT COUNT(*) AS total_company,
    SUM(
        CASE
            WHEN gqbg_count > 0 THEN 1
            ELSE 0
        END
    ) AS matched_company
FROM company_gqbg;

-- ----------------------------------------------------------------------------
-- 3.12 对外担保
--      取年报年度最新一条担保记录，同时统计担保记录数。
-- ----------------------------------------------------------------------------
DROP TABLE IF EXISTS company_db;

CREATE TABLE company_db AS
SELECT core.*,
    COALESCE(agg.db_count, 0) AS db_count,
    agg.latest_creditor,
    agg.latest_credit_amt
FROM company_core core
    LEFT JOIN (
        SELECT uni_social_crd_cd,
            COUNT(*) AS db_count,
            MAX(
                CASE
                    WHEN rn = 1 THEN creditor
                END
            ) AS latest_creditor,
            MAX(
                CASE
                    WHEN rn = 1 THEN major_credit_amt
                END
            ) AS latest_credit_amt
        FROM (
                SELECT uni_social_crd_cd,
                    creditor,
                    major_credit_amt,
                    ROW_NUMBER() OVER (
                        PARTITION BY uni_social_crd_cd
                        ORDER BY annual_year DESC,
                            creditor
                    ) AS rn
                FROM odps_jrsjc_pod.dw_nb_scjdgl_dwtgbzdbxx
            ) t
        GROUP BY uni_social_crd_cd
    ) agg ON core.uni_social_crd_cd = agg.uni_social_crd_cd;

SELECT COUNT(*) AS db_count
FROM company_db;

-- ----------------------------------------------------------------------------
-- 3.13 社会保险参保：源表 dw_nb_rlsb_sbjylyshbxjbxx 按 pens_pay_ym 取最新一条。
--      该表无 issue_end_dt，字段以官方字典为准。
-- ----------------------------------------------------------------------------
DROP TABLE IF EXISTS company_sb_jbxx;

CREATE TABLE company_sb_jbxx AS
SELECT core.*,
    sb.pens_num,
    sb.medic_num,
    sb.unemploy_num,
    sb.injury_num,
    sb.materni_num,
    sb.pens_pay_ym,
    sb.issue_start_dt
FROM company_core core
    LEFT JOIN (
        SELECT *
        FROM (
                SELECT uni_social_crd_cd,
                    pens_num,
                    medic_num,
                    unemploy_num,
                    injury_num,
                    materni_num,
                    pens_pay_ym,
                    issue_start_dt,
                    ROW_NUMBER() OVER (
                        PARTITION BY uni_social_crd_cd
                        ORDER BY pens_pay_ym DESC,
                            issue_start_dt
                    ) AS rn
                FROM odps_jrsjc_pod.dw_nb_rlsb_sbjylyshbxjbxx
            ) t
        WHERE rn = 1
    ) sb ON core.uni_social_crd_cd = sb.uni_social_crd_cd;

SELECT COUNT(*) AS sb_count
FROM company_sb_jbxx;

-- ----------------------------------------------------------------------------
-- 3.14 科技型小微：源表无 uni_social_crd_cd，按 comp_nm 关联；先按名称聚合取
--      最早认定年份。源字段 congniz_tear 输出别名 congniz_year。
--      名称匹配覆盖率偏低，两侧 TRIM，全半角差异仍需另行清洗。
-- ----------------------------------------------------------------------------
DROP TABLE IF EXISTS company_kjzx;

CREATE TABLE company_kjzx AS
SELECT core.*,
    agg.congniz_year
FROM company_core core
    LEFT JOIN (
        SELECT TRIM(comp_nm) AS comp_nm_key,
            MIN(congniz_tear) AS congniz_year
        FROM odps_jrsjc_pod.dw_nb_kj_sgczkjxzxqy
        GROUP BY TRIM(comp_nm)
    ) agg ON TRIM(core.comp_nm) = agg.comp_nm_key;

SELECT COUNT(*) AS kjzx_count
FROM company_kjzx;

-- ----------------------------------------------------------------------------
-- 3.15 公共信用分：取 dw_nb_dsj_xypjxx 的信用分，评价日期字段 evalu_dt，
--      输出别名 eval_dt（与 3.7 的 eval_dt 不是同一字段）。
-- ----------------------------------------------------------------------------
DROP TABLE IF EXISTS company_cred;

CREATE TABLE company_cred AS
SELECT core.*,
    agg.cred_scard,
    agg.evalu_dt AS eval_dt
FROM company_core core
    LEFT JOIN (
        SELECT *
        FROM (
                SELECT uni_social_crd_cd,
                    cred_scard,
                    evalu_dt,
                    ROW_NUMBER() OVER (
                        PARTITION BY uni_social_crd_cd
                        ORDER BY evalu_dt DESC,
                            cred_scard
                    ) AS rn
                FROM odps_jrsjc_pod.dw_nb_dsj_xypjxx
            ) t
        WHERE rn = 1
    ) agg ON core.uni_social_crd_cd = agg.uni_social_crd_cd;

SELECT COUNT(*) AS cred_count
FROM company_cred;

-- ----------------------------------------------------------------------------
-- 3.16 汇总宽表 company_profile：按信用代码拼 14 张平行扩展表，供统计与导出。
--      缺 company_gqbg（3.11）会报 Table not found。
-- ----------------------------------------------------------------------------
DROP TABLE IF EXISTS company_profile;

CREATE TABLE company_profile AS
SELECT c.uni_social_crd_cd,
    c.comp_nm,
    c.comp_type,
    c.reg_state,
    c.indv_nm,
    c.reg_capt,
    c.est_dt,
    c.domdi_strict,
    c.reg_org,
    f.fddb_nm,
    f.fddb_tel_num,
    j.jyyc_count,
    j.jyyc_latest_inclu_dt,
    j.jyyc_latest_reason,
    y.yzwf_count,
    y.latest_serill_rea,
    w.wzwd_url,
    g.gqbg_count,
    g.latest_gqbg_dt,
    n.asset_zmt,
    n.debt_amt,
    n.nb_opt_income_total,
    n.nb_profit_total,
    n.nb_net_profit,
    n.nb_tax_total,
    n.nb_year,
    s.tax_amt,
    s.sale_inco,
    s.count_dt,
    xp.tax_credi_level,
    xp.eval_year,
    cr.cred_scard,
    cr.eval_dt AS cred_eval_dt,
    sx.sxr_count,
    sx.latest_executed_nm,
    sx.latest_executed_court,
    sx.latest_fil_dt,
    xz.xzcf_count,
    xz.latest_punish_doc,
    xz.latest_punish_dt,
    xz.latest_punish_rea,
    d.db_count,
    d.latest_creditor,
    d.latest_credit_amt,
    sb.pens_num,
    sb.medic_num,
    sb.unemploy_num,
    sb.injury_num,
    sb.materni_num,
    sb.pens_pay_ym,
    sb.issue_start_dt,
    kj.congniz_year
FROM company_core c
    LEFT JOIN company_fddb f ON c.uni_social_crd_cd = f.uni_social_crd_cd
    LEFT JOIN company_jyyc j ON c.uni_social_crd_cd = j.uni_social_crd_cd
    LEFT JOIN company_yzwf y ON c.uni_social_crd_cd = y.uni_social_crd_cd
    LEFT JOIN company_wzwd w ON c.uni_social_crd_cd = w.uni_social_crd_cd
    LEFT JOIN company_gqbg g ON c.uni_social_crd_cd = g.uni_social_crd_cd
    LEFT JOIN company_nb n ON c.uni_social_crd_cd = n.uni_social_crd_cd
    LEFT JOIN company_ns s ON c.uni_social_crd_cd = s.uni_social_crd_cd
    LEFT JOIN company_xypj xp ON c.uni_social_crd_cd = xp.uni_social_crd_cd
    LEFT JOIN company_cred cr ON c.uni_social_crd_cd = cr.uni_social_crd_cd
    LEFT JOIN company_sxr sx ON c.uni_social_crd_cd = sx.uni_social_crd_cd
    LEFT JOIN company_xzcf xz ON c.uni_social_crd_cd = xz.uni_social_crd_cd
    LEFT JOIN company_db d ON c.uni_social_crd_cd = d.uni_social_crd_cd
    LEFT JOIN company_sb_jbxx sb ON c.uni_social_crd_cd = sb.uni_social_crd_cd
    LEFT JOIN company_kjzx kj ON c.uni_social_crd_cd = kj.uni_social_crd_cd;

-- 3.17 扩展结果校验：三个数字应当完全相等，否则说明有表出现了一对多膨胀
--      MaxCompute 不支持无 FROM 的多个标量子查询，改用 CROSS JOIN 聚合结果。
SELECT a.core_rows,
    b.profile_rows,
    b.profile_unique
FROM (
        SELECT COUNT(*) AS core_rows
        FROM company_core
    ) a
    CROSS JOIN (
        SELECT COUNT(*) AS profile_rows,
            COUNT(DISTINCT uni_social_crd_cd) AS profile_unique
        FROM company_profile
    ) b;

-- ############################################################################
-- SECTION 4  文旅企业统计（统一口径）
-- 基于 company_profile 全量，每段输出一行“统计类别 + 指标列”的宽表。
-- 财务类取“不晚于 2025 年度的最新年报”，与 SECTION 8 口径不同。
-- ############################################################################
-- 4.1 基础数据：企业总数、行业小类数、企业类型数、涉及区县数
SELECT '基础数据' AS statistics_category,
    COUNT(*) AS total_company,
    COUNT(DISTINCT indv_nm) AS industry_count,
    COUNT(DISTINCT comp_type) AS company_type_count,
    COUNT(DISTINCT domdi_strict) AS district_count
FROM company_profile;

-- 4.2 企业家数：各类监管、信用、经营特征覆盖多少家企业
SELECT '企业家数统计' AS statistics_category,
    COUNT(*) AS total_company,
    SUM(
        CASE
            WHEN jyyc_count > 0 THEN 1
            ELSE 0
        END
    ) AS abnormal_operation_company,
    SUM(
        CASE
            WHEN yzwf_count > 0 THEN 1
            ELSE 0
        END
    ) AS serious_violation_company,
    SUM(
        CASE
            WHEN sxr_count > 0 THEN 1
            ELSE 0
        END
    ) AS dishonest_executed_company,
    SUM(
        CASE
            WHEN congniz_year IS NOT NULL THEN 1
            ELSE 0
        END
    ) AS tech_small_company,
    SUM(
        CASE
            WHEN UPPER(tax_credi_level) = 'A' THEN 1
            ELSE 0
        END
    ) AS grade_a_taxpayer_company,
    SUM(
        CASE
            WHEN wzwd_url IS NOT NULL THEN 1
            ELSE 0
        END
    ) AS company_with_website,
    SUM(
        CASE
            WHEN xzcf_count > 0 THEN 1
            ELSE 0
        END
    ) AS company_with_penalty,
    SUM(
        CASE
            WHEN gqbg_count > 0 THEN 1
            ELSE 0
        END
    ) AS company_with_equity_change,
    SUM(
        CASE
            WHEN db_count > 0 THEN 1
            ELSE 0
        END
    ) AS company_with_guarantee,
    SUM(
        CASE
            WHEN pens_num IS NOT NULL THEN 1
            ELSE 0
        END
    ) AS company_with_social_insurance
FROM company_profile;

-- 4.3 经营状况：只看有财务或纳税数据的企业，均值与合计
--     年报财务（nb_*）与税务纳税（tax_amt / sale_inco）分开列示。
SELECT '经营状况统计' AS statistics_category,
    COUNT(*) AS company_with_financial_data,
    ROUND(AVG(asset_zmt), 2) AS avg_total_assets,
    ROUND(SUM(asset_zmt), 2) AS total_assets,
    ROUND(AVG(nb_opt_income_total), 2) AS avg_operating_income,
    ROUND(SUM(nb_opt_income_total), 2) AS total_operating_income,
    ROUND(AVG(nb_net_profit), 2) AS avg_net_profit,
    ROUND(SUM(nb_net_profit), 2) AS total_net_profit,
    ROUND(AVG(nb_tax_total), 2) AS avg_annual_tax,
    ROUND(SUM(nb_tax_total), 2) AS total_annual_tax,
    ROUND(AVG(tax_amt), 2) AS avg_tax_amount,
    ROUND(SUM(tax_amt), 2) AS total_tax_amount,
    ROUND(AVG(sale_inco), 2) AS avg_sale_income
FROM company_profile
WHERE asset_zmt IS NOT NULL
    OR nb_opt_income_total IS NOT NULL
    OR tax_amt IS NOT NULL;

-- 4.4 社保参与：参保企业数、参保率、五险平均参保人数
SELECT '社保参与统计' AS statistics_category,
    COUNT(*) AS total_company,
    SUM(
        CASE
            WHEN pens_num IS NOT NULL THEN 1
            ELSE 0
        END
    ) AS company_with_social_insurance,
    SUM(
        CASE
            WHEN pens_num IS NULL THEN 1
            ELSE 0
        END
    ) AS company_without_social_insurance,
    ROUND(
        SUM(
            CASE
                WHEN pens_num IS NOT NULL THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS social_insurance_participation_rate,
    ROUND(AVG(pens_num), 2) AS avg_pension_insurance_count,
    ROUND(AVG(medic_num), 2) AS avg_medical_insurance_count,
    ROUND(AVG(unemploy_num), 2) AS avg_unemployment_insurance_count,
    ROUND(AVG(injury_num), 2) AS avg_work_injury_insurance_count,
    ROUND(AVG(materni_num), 2) AS avg_maternity_insurance_count
FROM company_profile;

-- 4.5 变更活动：人均各类监管与变更记录数
SELECT '企业变更活动统计' AS statistics_category,
    COUNT(*) AS total_company,
    ROUND(AVG(jyyc_count), 2) AS avg_abnormal_operation_records,
    ROUND(AVG(yzwf_count), 2) AS avg_serious_violation_records,
    ROUND(AVG(gqbg_count), 2) AS avg_equity_change_records,
    ROUND(AVG(sxr_count), 2) AS avg_dishonest_execution_records,
    ROUND(AVG(db_count), 2) AS avg_guarantee_records,
    ROUND(AVG(xzcf_count), 2) AS avg_penalty_records
FROM company_profile;

-- 4.6 信用状况：纳税信用等级分布，以及公共信用评价覆盖率
SELECT '企业信用状况统计' AS statistics_category,
    COUNT(*) AS total_company,
    SUM(
        CASE
            WHEN UPPER(tax_credi_level) = 'A' THEN 1
            ELSE 0
        END
    ) AS grade_a_taxpayers,
    SUM(
        CASE
            WHEN UPPER(tax_credi_level) = 'B' THEN 1
            ELSE 0
        END
    ) AS grade_b_taxpayers,
    SUM(
        CASE
            WHEN UPPER(tax_credi_level) = 'C' THEN 1
            ELSE 0
        END
    ) AS grade_c_taxpayers,
    SUM(
        CASE
            WHEN UPPER(tax_credi_level) = 'D' THEN 1
            ELSE 0
        END
    ) AS grade_d_taxpayers,
    ROUND(
        SUM(
            CASE
                WHEN UPPER(tax_credi_level) = 'A' THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS grade_a_rate,
    SUM(
        CASE
            WHEN cred_scard IS NOT NULL THEN 1
            ELSE 0
        END
    ) AS company_with_credit_evaluation,
    ROUND(
        SUM(
            CASE
                WHEN cred_scard IS NOT NULL THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS credit_evaluation_rate
FROM company_profile;

-- 4.7 成立时间分布：四个时间段的企业数与占比
--     增加“成立日期缺失”一列：原写法下四个时间段之和可能小于总数、四段
--     百分比相加不足 100%，原因无法从结果里看出来。
SELECT '企业成立时间分布' AS statistics_category,
    SUM(
        CASE
            WHEN est_dt >= '2020-01-01' THEN 1
            ELSE 0
        END
    ) AS company_after_2020,
    SUM(
        CASE
            WHEN est_dt >= '2015-01-01'
            AND est_dt < '2020-01-01' THEN 1
            ELSE 0
        END
    ) AS company_2015_2019,
    SUM(
        CASE
            WHEN est_dt >= '2010-01-01'
            AND est_dt < '2015-01-01' THEN 1
            ELSE 0
        END
    ) AS company_2010_2014,
    SUM(
        CASE
            WHEN est_dt < '2010-01-01' THEN 1
            ELSE 0
        END
    ) AS company_before_2010,
    SUM(
        CASE
            WHEN est_dt IS NULL THEN 1
            ELSE 0
        END
    ) AS company_without_est_dt,
    ROUND(
        SUM(
            CASE
                WHEN est_dt >= '2020-01-01' THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS percentage_after_2020,
    ROUND(
        SUM(
            CASE
                WHEN est_dt >= '2015-01-01'
                AND est_dt < '2020-01-01' THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS percentage_2015_2019,
    ROUND(
        SUM(
            CASE
                WHEN est_dt >= '2010-01-01'
                AND est_dt < '2015-01-01' THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS percentage_2010_2014,
    ROUND(
        SUM(
            CASE
                WHEN est_dt < '2010-01-01' THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS percentage_before_2010,
    ROUND(
        SUM(
            CASE
                WHEN est_dt IS NULL THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS percentage_without_est_dt
FROM company_profile;

-- 4.8 行业分布：企业数最多的 20 个行业小类
--     分母原来是 SELECT 列表里的标量子查询，改为 CROSS JOIN 聚合结果，
--     MaxCompute 与 MySQL 都能稳定执行；GROUP BY 时用 MAX(t.total_company) 取值。
SELECT '行业分布统计' AS statistics_category,
    p.indv_nm,
    COUNT(*) AS company_count,
    ROUND(COUNT(*) * 100.0 / MAX(t.total_company), 2) AS percentage
FROM company_profile p
    CROSS JOIN (
        SELECT COUNT(*) AS total_company
        FROM company_profile
    ) t
GROUP BY p.indv_nm
ORDER BY company_count DESC
LIMIT 20;

-- ############################################################################
-- SECTION 5  区域结构（统一文旅口径）
-- 数据取自 company_profile，行业小类分布见 4.8 与 6.4。
-- ############################################################################
-- 5.1 按住所行政区划（区县）分布（LIMIT 1000 远大于实际区县数）
SELECT COALESCE(p.domdi_strict, '未填写') AS district,
    COUNT(*) AS company_count,
    ROUND(COUNT(*) * 100.0 / MAX(t.total_company), 2) AS percentage,
    ROUND(AVG(p.asset_zmt), 2) AS avg_total_assets
FROM company_profile p
    CROSS JOIN (
        SELECT COUNT(*) AS total_company
        FROM company_profile
    ) t
GROUP BY COALESCE(p.domdi_strict, '未填写')
ORDER BY company_count DESC
LIMIT 1000;

-- 5.2 按登记机关分布
SELECT COALESCE(reg_org, '未填写') AS reg_org,
    COUNT(*) AS company_count
FROM company_profile
GROUP BY COALESCE(reg_org, '未填写')
ORDER BY company_count DESC
LIMIT 1000;

-- ############################################################################
-- SECTION 6  报告取数（统一文旅口径）
-- 基于 SECTION 2 的 company，先建 rpt_wenlv，再出各口径数字。
-- ############################################################################
-- ----------------------------------------------------------------------------
-- 6.1 统一分析底表 rpt_wenlv：保留报告所需字段，行业代码取 indv_nm 原值。
--     MaxCompute 表存储无序，CTAS 末尾不写 ORDER BY。
-- ----------------------------------------------------------------------------
DROP TABLE IF EXISTS rpt_wenlv;

CREATE TABLE rpt_wenlv AS
SELECT c.uni_social_crd_cd,
    c.comp_nm,
    c.indv_nm,
    c.comp_type,
    c.reg_state,
    c.reg_org,
    c.est_dt,
    c.domdi_strict
FROM company c;

-- 校验：rpt_wenlv 行数应与 company 一致
SELECT a.company_rows,
    b.rpt_wenlv_rows
FROM (
        SELECT COUNT(*) AS company_rows
        FROM company
    ) a
    CROSS JOIN (
        SELECT COUNT(*) AS rpt_wenlv_rows
        FROM rpt_wenlv
    ) b;

-- ----------------------------------------------------------------------------
-- 6.2 报告核心数字：经营主体总量与企业类型取值数（分类见 6.5）。
-- ----------------------------------------------------------------------------
SELECT COUNT(DISTINCT uni_social_crd_cd) AS total_wenlv_company,
    COUNT(DISTINCT comp_type) AS comp_type_value_count
FROM rpt_wenlv;

-- ----------------------------------------------------------------------------
-- 6.3 行业覆盖度：63 个行业代码中实际覆盖了多少个
-- ----------------------------------------------------------------------------
SELECT COUNT(DISTINCT r.indv_nm) AS covered_industry_count,
    MAX(c.total_industry_count) AS total_industry_count,
    ROUND(
        COUNT(DISTINCT r.indv_nm) * 100.0 / MAX(c.total_industry_count),
        2
    ) AS coverage_rate
FROM rpt_wenlv r
    CROSS JOIN (
        SELECT COUNT(*) AS total_industry_count
        FROM industry_codes
    ) c;

-- ----------------------------------------------------------------------------
-- 6.4 企业数量最多的 10 个行业小类（按行业代码）
-- ----------------------------------------------------------------------------
SELECT r.indv_nm,
    COUNT(DISTINCT r.uni_social_crd_cd) AS company_count,
    ROUND(
        COUNT(DISTINCT r.uni_social_crd_cd) * 100.0 / MAX(t.total_company),
        2
    ) AS percentage
FROM rpt_wenlv r
    CROSS JOIN (
        SELECT COUNT(DISTINCT uni_social_crd_cd) AS total_company
        FROM rpt_wenlv
    ) t
GROUP BY r.indv_nm
ORDER BY company_count DESC
LIMIT 10;

-- ----------------------------------------------------------------------------
-- 6.5 企业类型与登记状态分布
--     企业类型直接按市场主体总表的 comp_type 原值分组，供报告阶段自行归类。
-- ----------------------------------------------------------------------------
SELECT COALESCE(comp_type, '未知') AS comp_type_value,
    COUNT(DISTINCT uni_social_crd_cd) AS company_count
FROM rpt_wenlv
GROUP BY COALESCE(comp_type, '未知')
ORDER BY company_count DESC
LIMIT 1000;

SELECT COALESCE(reg_state, '未知') AS reg_state,
    COUNT(DISTINCT uni_social_crd_cd) AS company_count
FROM rpt_wenlv
GROUP BY COALESCE(reg_state, '未知')
ORDER BY company_count DESC
LIMIT 1000;

-- ----------------------------------------------------------------------------
-- 6.6 社会贡献与信用：取自 SECTION 3 的 company_profile。
-- ----------------------------------------------------------------------------
SELECT COUNT(*) AS total_company,
    SUM(
        CASE
            WHEN pens_num IS NOT NULL THEN 1
            ELSE 0
        END
    ) AS with_social_insurance,
    ROUND(AVG(pens_num), 2) AS avg_pension_insurance_count,
    SUM(
        CASE
            WHEN tax_amt IS NOT NULL THEN 1
            ELSE 0
        END
    ) AS with_tax_data,
    ROUND(SUM(tax_amt), 2) AS total_tax_amount,
    ROUND(AVG(nb_opt_income_total), 2) AS avg_operating_income,
    SUM(
        CASE
            WHEN tax_credi_level IS NOT NULL THEN 1
            ELSE 0
        END
    ) AS with_tax_credit_level,
    SUM(
        CASE
            WHEN UPPER(tax_credi_level) = 'A' THEN 1
            ELSE 0
        END
    ) AS grade_a_taxpayers,
    SUM(
        CASE
            WHEN cred_scard IS NOT NULL THEN 1
            ELSE 0
        END
    ) AS with_credit_score
FROM company_profile;

-- ############################################################################
-- SECTION 7  执行后核对清单
-- ############################################################################
-- 7.1 各阶段表行数。company 与 rpt_wenlv 行数相同；company_core 与
--     company_profile 行数相同（已按信用代码去重）。
SELECT 'company' AS tbl,
    COUNT(*) AS rows_cnt
FROM company
UNION ALL
SELECT 'company_core',
    COUNT(*)
FROM company_core
UNION ALL
SELECT 'company_profile',
    COUNT(*)
FROM company_profile
UNION ALL
SELECT 'rpt_wenlv',
    COUNT(*)
FROM rpt_wenlv;

-- 7.2 统一口径核对：四张表的去重企业数应当完全一致。
--     原写法是 4 个无 FROM 的标量子查询，MaxCompute 不支持，改 CROSS JOIN。
--     注意本条只比去重数；JOIN 膨胀要靠 3.17 与 7.1 的 COUNT(*) 才能发现。
SELECT a.company_count,
    b.core_count,
    c.profile_count,
    d.rpt_count
FROM (
        SELECT COUNT(DISTINCT uni_social_crd_cd) AS company_count
        FROM company
    ) a
    CROSS JOIN (
        SELECT COUNT(DISTINCT uni_social_crd_cd) AS core_count
        FROM company_core
    ) b
    CROSS JOIN (
        SELECT COUNT(DISTINCT uni_social_crd_cd) AS profile_count
        FROM company_profile
    ) c
    CROSS JOIN (
        SELECT COUNT(DISTINCT uni_social_crd_cd) AS rpt_count
        FROM rpt_wenlv
    ) d;

-- 7.3 行业覆盖度：宁波文旅主体实际覆盖的国民经济行业小类数。
SELECT COUNT(DISTINCT indv_nm) AS covered_industry_count
FROM rpt_wenlv;

-- 7.4 抽查扩展表的空值情况，判断是源表确实没有数据还是关联键没对上。
SELECT COUNT(*) AS total_company,
    SUM(
        CASE
            WHEN asset_zmt IS NOT NULL THEN 1
            ELSE 0
        END
    ) AS with_annual_report,
    SUM(
        CASE
            WHEN tax_amt IS NOT NULL THEN 1
            ELSE 0
        END
    ) AS with_tax_data,
    SUM(
        CASE
            WHEN pens_num IS NOT NULL THEN 1
            ELSE 0
        END
    ) AS with_social_insurance,
    SUM(
        CASE
            WHEN cred_scard IS NOT NULL THEN 1
            ELSE 0
        END
    ) AS with_credit_score,
    SUM(
        CASE
            WHEN tax_credi_level IS NOT NULL THEN 1
            ELSE 0
        END
    ) AS with_tax_credit_level,
    SUM(
        CASE
            WHEN sxr_count > 0 THEN 1
            ELSE 0
        END
    ) AS with_dishonest_record,
    SUM(
        CASE
            WHEN gqbg_count > 0 THEN 1
            ELSE 0
        END
    ) AS with_equity_change
FROM company_profile;

-- ############################################################################
-- SECTION 8  信用质量较好企业遴选（TOP 3000）
-- 候选池取 company_profile；删除情形 xzcf_count / yzwf_count / jyyc_count /
-- sxr_count 任一命中即删；要求 nb_year = 2025 且 asset_zmt 非空。
-- 按资产与社保分别排名，名次相加升序取前 3000。删除只作用于名单。
-- ############################################################################
-- ----------------------------------------------------------------------------
-- 8.1 候选池：逐项打删除标记，excl_no_2025_asset 为数据时点标记。
-- ----------------------------------------------------------------------------
DROP TABLE IF EXISTS selection_pool;

CREATE TABLE selection_pool AS
SELECT p.uni_social_crd_cd,
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
    CASE
        WHEN COALESCE(p.xzcf_count, 0) > 0 THEN 1
        ELSE 0
    END AS excl_xzcf,
    CASE
        WHEN COALESCE(p.yzwf_count, 0) > 0 THEN 1
        ELSE 0
    END AS excl_yzwf,
    CASE
        WHEN COALESCE(p.jyyc_count, 0) > 0 THEN 1
        ELSE 0
    END AS excl_jyyc,
    CASE
        WHEN COALESCE(p.sxr_count, 0) > 0 THEN 1
        ELSE 0
    END AS excl_sxr,
    CASE
        WHEN CAST(p.nb_year AS BIGINT) = 2025
        AND p.asset_zmt IS NOT NULL THEN 0
        ELSE 1
    END AS excl_no_2025_asset
FROM company_profile p;

SELECT COUNT(*) AS pool_count
FROM selection_pool;

-- ----------------------------------------------------------------------------
-- 8.2 通过删除条件与时点要求的企业，按资产规模与社保人数分别排名
--     RANK 让取值相同的企业共用一个名次，避免并列被随机拆开。
-- ----------------------------------------------------------------------------
DROP TABLE IF EXISTS selection_ranked;

CREATE TABLE selection_ranked AS
SELECT t.*,
    RANK() OVER (
        ORDER BY t.asset_zmt DESC
    ) AS asset_rank,
    RANK() OVER (
        ORDER BY t.pens_num DESC
    ) AS social_rank
FROM (
        SELECT s.*
        FROM selection_pool s
        WHERE s.excl_xzcf = 0
            AND s.excl_yzwf = 0
            AND s.excl_jyyc = 0
            AND s.excl_sxr = 0
            AND s.excl_no_2025_asset = 0
    ) t;

SELECT COUNT(*) AS ranked_count
FROM selection_ranked;

-- ----------------------------------------------------------------------------
-- 8.3 最终名单：综合名次升序取前 3000 名
--     末尾 ORDER BY 带 LIMIT 3000，符合 MaxCompute 的 ORDER BY 校验。
-- ----------------------------------------------------------------------------
DROP TABLE IF EXISTS selected_top3000;

CREATE TABLE selected_top3000 AS
SELECT ROW_NUMBER() OVER (
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

SELECT COUNT(*) AS selected_rows
FROM selected_top3000;

-- 8.4 删除过程核对：四类情形分别命中多少家，另有几家取不到 2025 年末资产
SELECT COUNT(*) AS pool_total,
    SUM(excl_xzcf) AS excl_xzcf_company,
    SUM(excl_yzwf) AS excl_yzwf_company,
    SUM(excl_jyyc) AS excl_jyyc_company,
    SUM(excl_sxr) AS excl_sxr_company,
    SUM(excl_no_2025_asset) AS no_2025_asset_company,
    SUM(
        CASE
            WHEN excl_xzcf = 0
            AND excl_yzwf = 0
            AND excl_jyyc = 0
            AND excl_sxr = 0
            AND excl_no_2025_asset = 0 THEN 1
            ELSE 0
        END
    ) AS eligible_company
FROM selection_pool;

-- 8.5 名单核对：应为 3000 家且无重复；不足 3000 说明合格企业数不够。
--     asset_from_2025_report 应等于入选家数，without_asset_data 应为 0。
SELECT COUNT(*) AS selected_rows,
    COUNT(DISTINCT uni_social_crd_cd) AS selected_company,
    MIN(final_rank) AS min_rank,
    MAX(final_rank) AS max_rank,
    MIN(asset_zmt) AS min_asset_zmt,
    MAX(asset_zmt) AS max_asset_zmt,
    MIN(pens_num) AS min_pens_num,
    MAX(pens_num) AS max_pens_num,
    SUM(
        CASE
            WHEN CAST(nb_year AS BIGINT) = 2025
            AND asset_zmt IS NOT NULL THEN 1
            ELSE 0
        END
    ) AS asset_from_2025_report,
    SUM(
        CASE
            WHEN asset_zmt IS NULL THEN 1
            ELSE 0
        END
    ) AS without_asset_data,
    SUM(
        CASE
            WHEN pens_num IS NULL THEN 1
            ELSE 0
        END
    ) AS without_social_data
FROM selected_top3000;

-- 8.6 残留检查：入选名单里不应有任一删除情形，也不应缺 2025 年末资产，结果应为 0
SELECT COUNT(*) AS residual_excluded
FROM selected_top3000 s
    JOIN selection_pool p ON s.uni_social_crd_cd = p.uni_social_crd_cd
WHERE p.excl_xzcf = 1
    OR p.excl_yzwf = 1
    OR p.excl_jyyc = 1
    OR p.excl_sxr = 1
    OR p.excl_no_2025_asset = 1;

-- ----------------------------------------------------------------------------
-- 8.7 基准日核对：财务年度不应晚于 2025；若企业停在往年，报告统计仍会用其数据，
--     引用时须注明年度口径。第二条看有无晚于 2025-12-31 成立的企业。
-- ----------------------------------------------------------------------------
SELECT nb_year,
    COUNT(*) AS company_count,
    SUM(
        CASE
            WHEN asset_zmt IS NOT NULL THEN 1
            ELSE 0
        END
    ) AS with_asset_data
FROM company_profile
GROUP BY nb_year
ORDER BY nb_year DESC
LIMIT 100;

SELECT SUM(
        CASE
            WHEN est_dt > '2025-12-31' THEN 1
            ELSE 0
        END
    ) AS company_after_2025,
    SUM(
        CASE
            WHEN est_dt IS NULL THEN 1
            ELSE 0
        END
    ) AS company_without_est_dt,
    MAX(est_dt) AS latest_est_dt
FROM company_profile;

-- 名单预览
SELECT *
FROM selected_top3000
ORDER BY final_rank
LIMIT 20;