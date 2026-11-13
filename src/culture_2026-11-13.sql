-- 宁波市文旅经营主体数据分析脚本（MaxCompute版）
--
-- 运行环境：阿里 MaxCompute
-- 项目空间: odps_jrsjc_pod
-- 一律写全限定名 odps_jrsjc_pod.dw_xxx
--
-- SECTION 0  执行前检查
-- SECTION 1  基础代码与字典表
-- SECTION 2  文旅经营主体筛选
-- SECTION 3  根据负面指标删选
-- SECTION 4  根据正面指标排序
-- SECTION 5  输出结果
--
-- ============================================================================
-- SECTION 0  执行前检查
-- ============================================================================
--
-- 全局自检
SHOW TABLES;
-- 确认行业代码字段形态。indv_nm 实际为国民经济行业小类代码
SELECT indv_nm,
    COUNT(*) AS cnt
FROM odps_jrsjc_pod.dw_zj_scjdgl_scztxx
GROUP BY indv_nm
ORDER BY cnt DESC
LIMIT 10;
-- ============================================================================
-- SECTION 1  基础代码与字典表
-- ============================================================================
--
-- ----------------------------------------------------------------------------
-- 建 industry_codes（62 个四位行业代码）
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
-- 自检：预期 62 条
SELECT COUNT(*) AS industry_code_count
FROM industry_codes;
-- ----------------------------------------------------------------------------
-- 校验：确认 indv_nm 与代码表能否匹配。
-- matched_rows 为 0 或明显偏小，说明该字段不是四位代码
-- 空表且不报错。此时改用正确代码字段或清洗源表，再往下执行。
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
-- ============================================================================
-- SECTION 2  文旅经营主体筛选
-- ============================================================================
--
-- 去重前核对：看同一信用代码是否确有多条记录，以及 appr_dt 能否区分新旧
-- 如果有重复记录，结果会显示重复的记录数，以及重复的 appr_dt 种类数
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
-- 创建 company 表
-- 按 62 个行业代码提取，按信用代码去重留最新一条
-- 空信用代码无法参与后续任何关联，且会被窗口函数并成一个分区只留一条，
-- 这里先排除；核准日期相同时补主体身份代码作第二键，固定并列时的次序。
-- ----------------------------------------------------------------------------
DROP TABLE IF EXISTS company;
CREATE TABLE company AS
SELECT reg_org,
    comp_nm,
    uni_social_crd_cd,
    addr,
    domdi_strict,
    comp_type,
    appr_dt,
    est_dt,
    indv_id,
    indv_nm,
    legal_repre,
    reg_capt,
    reg_state
FROM (
        SELECT s.*,
            ROW_NUMBER() OVER (
                PARTITION BY s.uni_social_crd_cd
                ORDER BY s.appr_dt DESC,
                    s.main_identi_id ASC
            ) AS rn
        FROM odps_jrsjc_pod.dw_zj_scjdgl_scztxx s
        WHERE s.uni_social_crd_cd IS NOT NULL
            AND TRIM(s.uni_social_crd_cd) <> ''
            AND s.indv_nm IN (
                SELECT indv_nm
                FROM industry_codes
            )
    ) t
WHERE rn = 1;
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
-- 统计开业状态为“K"的数量
SELECT COUNT(*) AS before_count,
    SUM(
        CASE
            WHEN reg_state = 'K' THEN 1
            ELSE 0
        END
    ) AS keep_count
FROM company;
-- 更新company，仅保留开业状态为“K"的企业
INSERT OVERWRITE TABLE company
SELECT *
FROM company
WHERE reg_state = 'K';
-- 自检，after_count 应等于 keep_count
SELECT COUNT(*) AS after_count
FROM company;
-- 企业类型分布：按 comp_type 原值看文旅企业的构成
SELECT COALESCE(comp_type, '未知') AS comp_type_value,
    COUNT(*) AS company_count
FROM company
GROUP BY COALESCE(comp_type, '未知')
ORDER BY company_count DESC
LIMIT 1000;
-- 行业小类分布（筛选后）：按 indv_nm 原值看文旅企业的构成
SELECT COALESCE(indv_nm, '未知') AS indv_nm_value,
    COUNT(*) AS company_count
FROM company
GROUP BY COALESCE(indv_nm, '未知')
ORDER BY company_count DESC
LIMIT 1000;
-- ----------------------------------------------------------------------------
-- 创建企业核心信息表
-- ----------------------------------------------------------------------------
DROP TABLE IF EXISTS company_core;
-- 从 company 中提取核心信息
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
    appr_dt
FROM company;
-- 显示创建结果
SELECT COUNT(*) AS core_count
FROM company_core;
-- 显示表结构
DESC company_core;
-- 显示前10条记录
SELECT *
FROM company_core
LIMIT 10;
-- ============================================================================
-- SECTION 3 根据负面指标删选
-- 一票否决项：严重违法失信、失信被执行人、未履行生效裁判、经营异常。
-- ============================================================================
--
-- 先把 company_core 复制到 company_remain
DROP TABLE IF EXISTS company_remain;
CREATE TABLE company_remain AS
SELECT *
FROM company_core;
-- ----------------------------------------------------------------------------
-- 更新 company_remain，添加一列社保参保人数
-- 本段是原地改写表本身，不是只算一个结果：先 ALTER 加列，再用
-- INSERT OVERWRITE 把 company_remain 全表重写一遍，把人数写进新列。
-- 来源标准表：DW_NB_RLSB_QYSBCBRSXX（企业社保参保人数信息），docs/正面和
-- 负面指标.md 的社保参保人数项也指向该表；按应收年月 rece_ym 取最新一条。
-- 现场 DESC 确认：该表真实列名是 credit_code（信用代码）与 ijfrs（月参保
-- 总人数），与字段字典里的 uni_social_crd_cd、mon_insurd_prsons 不一致；
-- 内层把 credit_code 取别名 uni_social_crd_cd，外层关联不用改。
-- 写入 company_remain 时按列位置落到自建列 mon_insurd_prsons，CAST 成 BIGINT。
-- 该表按单位按月报送，一家企业有多条，先按信用代码分区取 rn = 1 再左连，
-- 否则一对多会把 company_remain 行数放大，破坏剩余企业口径。
-- 关联不上的企业该列留空，只表示源表未覆盖，不能解释为没有参保人数。
-- MaxCompute 的 INSERT OVERWRITE 按列位置写入，SELECT 必须按建表顺序显式
-- 列出全部列；用 c.* 会把刚加的空列一起展开，再加一列就多出一列而报错。
-- 整段单独重跑会重复加列，重跑请从上面的 DROP TABLE company_remain 开始。
-- 若要改取五险人数，把子查询换成 DW_NB_RLSB_SBJYLYSHBXJBXX 的 pens_num 等，
-- 旧脚本就是拿 pens_num 作社保排名依据，两者口径不同不要混用。
-- ----------------------------------------------------------------------------
ALTER TABLE company_remain
ADD COLUMNS (mon_insurd_prsons BIGINT);
DESC odps_jrsjc_pod.dw_nb_rlsb_qysbcbrsxx;
INSERT OVERWRITE TABLE company_remain
SELECT c.comp_nm,
    c.uni_social_crd_cd,
    c.indv_nm,
    c.indv_id,
    c.comp_type,
    c.addr,
    c.domdi_strict,
    c.reg_org,
    c.reg_state,
    c.reg_capt,
    c.est_dt,
    c.appr_dt,
    CAST(sb.ijfrs AS BIGINT)
FROM company_remain c
    LEFT JOIN (
        SELECT uni_social_crd_cd,
            ijfrs
        FROM (
                SELECT credit_code AS uni_social_crd_cd,
                    ijfrs,
                    ROW_NUMBER() OVER (
                        PARTITION BY credit_code
                        ORDER BY priod_dt DESC,
                            ijfrs DESC
                    ) AS rn
                FROM odps_jrsjc_pod.dw_nb_rlsb_qysbcbrsxx
                WHERE credit_code IS NOT NULL
                    AND TRIM(credit_code) <> ''
            ) t
        WHERE rn = 1
    ) sb ON c.uni_social_crd_cd = sb.uni_social_crd_cd;
-- 自检：本段只补列不删行，行数应与上一步剔除后一致，顺带看覆盖率
SELECT COUNT(*) AS remain_count,
    SUM(
        CASE
            WHEN mon_insurd_prsons IS NOT NULL THEN 1
            ELSE 0
        END
    ) AS with_sb_count
FROM company_remain;
-- ----------------------------------------------------------------------------
-- 继续更新 company_remain，添加一列纳税等级
-- 同样是原地改写表本身：先 ALTER 加列，再用 INSERT OVERWRITE 全表重写。
-- 来源标准表：DW_NB_SW_NSXYDJXX（纳税信用等级信息），取 tax_credit_level。
-- 一家企业可能有多个评价年度，按 evalua_year 前四位年份降序、同年度按
-- evalua_dt 降序取 rn = 1，只保留最新一条，避免一对多把行数放大。
-- evalua_year 是 STRING，只取前四位年份比较，兼容带后缀的写法。
-- 关联不上的企业该列留空，SECTION 4 的等级映射会把空值一律排最后。
-- SELECT 仍按建表顺序显式列出全部列，新列追加在末尾；MaxCompute 的
-- INSERT OVERWRITE 按列位置写入，用 c.* 会多展开刚加的空列而列数不匹配。
-- 整段单独重跑会重复加列，重跑请从上面的 DROP TABLE company_remain 开始。
-- ----------------------------------------------------------------------------
ALTER TABLE company_remain
ADD COLUMNS (tax_credit_level STRING);
INSERT OVERWRITE TABLE company_remain
SELECT c.comp_nm,
    c.uni_social_crd_cd,
    c.indv_nm,
    c.indv_id,
    c.comp_type,
    c.addr,
    c.domdi_strict,
    c.reg_org,
    c.reg_state,
    c.reg_capt,
    c.est_dt,
    c.appr_dt,
    c.mon_insurd_prsons,
    lv.tax_credit_level
FROM company_remain c
    LEFT JOIN (
        SELECT uni_social_crd_cd,
            tax_credit_level
        FROM (
                SELECT uni_social_crd_cd,
                    tax_credit_level,
                    ROW_NUMBER() OVER (
                        PARTITION BY uni_social_crd_cd
                        ORDER BY SUBSTR(TRIM(evalua_year), 1, 4) DESC,
                            evalua_dt DESC
                    ) AS rn
                FROM odps_jrsjc_pod.dw_nb_sw_nsxydjxx
                WHERE uni_social_crd_cd IS NOT NULL
                    AND TRIM(uni_social_crd_cd) <> ''
            ) t
        WHERE rn = 1
    ) lv ON c.uni_social_crd_cd = lv.uni_social_crd_cd;
-- 自检：本段只补列不删行，顺带看纳税等级覆盖率
SELECT COUNT(*) AS remain_count,
    SUM(
        CASE
            WHEN tax_credit_level IS NOT NULL
            AND TRIM(tax_credit_level) <> '' THEN 1
            ELSE 0
        END
    ) AS with_tax_level_count
FROM company_remain;
-- ----------------------------------------------------------------------------
-- 剔除近 3 年存在严重违法失信的企业
-- 思路：把命中企业从 company_remain 中去掉后原地覆写，保留的是未命中的好企业。
-- 来源标准表：DW_ZJ_SCJDGL_YZWFSX。
-- 口径：以本脚本基准日 2025-12-31 计，近 3 年为 2023、2024、2025 三个年度；
-- 按列入日期 abn_tm 的年份判断，只取年份前四位。
-- 命中即整户剔除，不论后续是否已移出。
-- ----------------------------------------------------------------------------
-- 命中家数自检：为 0 说明近 3 年口径或关联键有问题，先查清再往下覆写
SELECT COUNT(DISTINCT c.uni_social_crd_cd) AS hit_count
FROM company_remain c
    JOIN (
        SELECT DISTINCT uni_social_crd_cd
        FROM odps_jrsjc_pod.dw_zj_scjdgl_yzwfsx
        WHERE uni_social_crd_cd IS NOT NULL
            AND TRIM(uni_social_crd_cd) <> ''
            AND SUBSTR(abn_tm, 1, 4) IN ('2023', '2024', '2025')
    ) bad ON c.uni_social_crd_cd = bad.uni_social_crd_cd;
INSERT OVERWRITE TABLE company_remain
SELECT c.*
FROM company_remain c
    LEFT JOIN (
        SELECT DISTINCT uni_social_crd_cd
        FROM odps_jrsjc_pod.dw_zj_scjdgl_yzwfsx
        WHERE uni_social_crd_cd IS NOT NULL
            AND TRIM(uni_social_crd_cd) <> ''
            AND SUBSTR(abn_tm, 1, 4) IN ('2023', '2024', '2025')
    ) bad ON c.uni_social_crd_cd = bad.uni_social_crd_cd
WHERE bad.uni_social_crd_cd IS NULL;
-- 自检：剩余家数应比本步之前少，差额即被剔除家数
SELECT COUNT(*) AS remain_count
FROM company_remain;
-- ----------------------------------------------------------------------------
-- 剔除近 3 年存在失信被执行人的企业
-- 思路：同样反连接后原地覆写 company_remain，本步只看失信被执行人一类记录。
-- 来源标准表：DW_ZJ_FZGG_SXBZXRXX。
-- 口径：以本脚本基准日 2025-12-31 计，近 3 年为 2023、2024、2025 三个年度；
-- 按立案时间 fil_dt 的年份判断，只取年份前四位。
-- 命中即整户剔除，不论后续是否已从失信名单移出。
--
-- 关联键体检：字段字典把该表 uni_social_crd_cd 标为组织机构代码，样例是 7 位，
-- 与主体表 18 位统一社会信用代码可能匹配不上；该表还混有自然人记录。
-- 先看长度分布，再看命中家数，命中为 0 时须确认真实的企业关联字段后重跑本步，
-- 不能只看剩余家数没变就当作没有失信企业。
-- ----------------------------------------------------------------------------
SELECT LENGTH(uni_social_crd_cd) AS code_len,
    COUNT(*) AS row_count
FROM odps_jrsjc_pod.dw_zj_fzgg_sxbzxrxx
WHERE uni_social_crd_cd IS NOT NULL
GROUP BY LENGTH(uni_social_crd_cd)
ORDER BY code_len
LIMIT 100;
SELECT COUNT(DISTINCT c.uni_social_crd_cd) AS hit_count
FROM company_remain c
    JOIN (
        SELECT DISTINCT uni_social_crd_cd
        FROM odps_jrsjc_pod.dw_zj_fzgg_sxbzxrxx
        WHERE uni_social_crd_cd IS NOT NULL
            AND TRIM(uni_social_crd_cd) <> ''
            AND SUBSTR(CAST(fil_dt AS STRING), 1, 4) IN ('2023', '2024', '2025')
    ) bad ON c.uni_social_crd_cd = bad.uni_social_crd_cd;
INSERT OVERWRITE TABLE company_remain
SELECT c.*
FROM company_remain c
    LEFT JOIN (
        SELECT DISTINCT uni_social_crd_cd
        FROM odps_jrsjc_pod.dw_zj_fzgg_sxbzxrxx
        WHERE uni_social_crd_cd IS NOT NULL
            AND TRIM(uni_social_crd_cd) <> ''
            AND SUBSTR(CAST(fil_dt AS STRING), 1, 4) IN ('2023', '2024', '2025')
    ) bad ON c.uni_social_crd_cd = bad.uni_social_crd_cd
WHERE bad.uni_social_crd_cd IS NULL;
-- 自检：剩余家数应比本步之前少，差额即被剔除家数
SELECT COUNT(*) AS remain_count
FROM company_remain;
-- ----------------------------------------------------------------------------
-- 剔除近 3 年存在未履行生效裁判的企业
-- 思路：同样反连接后原地覆写 company_remain，本步只看未履行生效裁判一类记录。
-- 来源标准表：DW_SHL_QYWLXSXCPXX。
-- 口径：以本脚本基准日 2025-12-31 计，近 3 年为 2023、2024、2025 三个年度；
-- 按立案日期 filing_dt 的年份判断，只取年份前四位。
-- 命中即整户剔除，不论后续是否已履行。
-- 业务口径文档另给出未执行金额 not_execute_amt 大于 0 才否决的写法，
-- 若后续改成按金额判断，在本段两处子查询里同步加条件即可。
-- ----------------------------------------------------------------------------
SELECT COUNT(DISTINCT c.uni_social_crd_cd) AS hit_count
FROM company_remain c
    JOIN (
        SELECT DISTINCT uni_social_crd_cd
        FROM odps_jrsjc_pod.dw_shl_qywlxsxcpxx
        WHERE uni_social_crd_cd IS NOT NULL
            AND TRIM(uni_social_crd_cd) <> ''
            AND SUBSTR(CAST(filing_dt AS STRING), 1, 4) IN ('2023', '2024', '2025')
    ) bad ON c.uni_social_crd_cd = bad.uni_social_crd_cd;
INSERT OVERWRITE TABLE company_remain
SELECT c.*
FROM company_remain c
    LEFT JOIN (
        SELECT DISTINCT uni_social_crd_cd
        FROM odps_jrsjc_pod.dw_shl_qywlxsxcpxx
        WHERE uni_social_crd_cd IS NOT NULL
            AND TRIM(uni_social_crd_cd) <> ''
            AND SUBSTR(CAST(filing_dt AS STRING), 1, 4) IN ('2023', '2024', '2025')
    ) bad ON c.uni_social_crd_cd = bad.uni_social_crd_cd
WHERE bad.uni_social_crd_cd IS NULL;
-- 自检：剩余家数应比本步之前少，差额即被剔除家数
SELECT COUNT(*) AS remain_count
FROM company_remain;
-- ============================================================================
-- SECTION 4 根据正面指标排序
-- 在 company_remain 中，首先根据纳税信用等级排序，其次按照注册资本排序
-- ============================================================================
--
-- ----------------------------------------------------------------------------
-- 直接用 company_remain 的纳税等级列，先按等级、再按注册资本生成排名并落表
-- 纳税等级已在 SECTION 3 补列时按最新评价年度取定，这里不再重复关联
-- DW_NB_SW_NSXYDJXX，否则 SELECT c.* 与再次取出的列同名会冲突，口径也可能不一致。
-- 等级优先级显式映射为 A、B、M、C、D，其余取值与无等级记录一律排最后；
-- 不能按等级字典序直接排，否则 M 级会落到 D 级之后，与业务含义不符。
-- 现场值域与本映射不一致时，只改下面这一处 CASE。
-- 排序窗口末尾补 uni_social_crd_cd 作唯一键，避免等级与注册资本并列时结果漂移。
-- MaxCompute 表存储无序，顺序只能以 rank_no 列固化，ORDER BY 只影响显示；
-- company_remain 保持纯剩余主体口径不变，带 rank_no 的结果落到 company_remain_ranked。
-- ----------------------------------------------------------------------------
DROP TABLE IF EXISTS company_remain_ranked;
CREATE TABLE company_remain_ranked AS
SELECT ranked.*,
    ROW_NUMBER() OVER (
        ORDER BY credit_rank ASC,
            reg_capt DESC,
            uni_social_crd_cd ASC
    ) AS rank_no
FROM (
        SELECT c.*,
            CASE
                SUBSTR(UPPER(TRIM(c.tax_credit_level)), 1, 1)
                WHEN 'A' THEN 1
                WHEN 'B' THEN 2
                WHEN 'M' THEN 3
                WHEN 'C' THEN 4
                WHEN 'D' THEN 5
                ELSE 9
            END AS credit_rank
        FROM company_remain c
    ) ranked;
-- 全量结果已固化在表里，取全量直接读表，不带 ORDER BY 就不受 LIMIT 校验约束
SELECT COUNT(*) AS ranked_count,
    COUNT(DISTINCT rank_no) AS rank_no_kinds
FROM company_remain_ranked;
-- 按 rank_no 查看有序结果。ranked_count 超过下面的 LIMIT 时，按 rank_no 分段取，
-- 或执行一次 SETPROJECT odps.sql.validate.orderby.limit=false 后去掉 LIMIT
SELECT *
FROM company_remain_ranked
ORDER BY rank_no
LIMIT 3000;
-- ----------------------------------------------------------------------------
-- 按上面的排序规则，每个行业代码取前 50 名，合并落表 company_remain_ranked_2
-- 行业代码字段是 indv_nm（SECTION 1 已现场确认它存四位代码，indv_id 才是中文名称）；
-- company 建表时已用 industry_codes 过滤，indv_nm 必是 62 个有效代码之一，不用再排空。
-- 上面的排序规则已固化成 company_remain_ranked.rank_no，组内按 rank_no 升序
-- 取前 50，等价于在组内重跑一遍纳税等级、注册资本、信用代码的排序。
-- ROW_NUMBER 一次分区即完成分行业取名次再合并，不必逐行业 UNION ALL；
-- 新表比原表多一列 indv_rank_no（行业内名次），全局 rank_no 保留原值会跳号。
-- 每组最多 50 家，62 个行业理论上最多 3100 家，实际取决于各组现有家数。
-- ----------------------------------------------------------------------------
DROP TABLE IF EXISTS company_remain_ranked_2;
CREATE TABLE company_remain_ranked_2 AS
SELECT *
FROM (
        SELECT r.*,
            ROW_NUMBER() OVER (
                PARTITION BY indv_nm
                ORDER BY rank_no ASC
            ) AS indv_rank_no
        FROM company_remain_ranked r
    ) t
WHERE indv_rank_no <= 50;
-- 自检：行业数应不超过 62，rank_no 种类数应等于行数
SELECT COUNT(*) AS ranked_2_count,
    COUNT(DISTINCT indv_nm) AS industry_count,
    COUNT(DISTINCT rank_no) AS rank_no_kinds
FROM company_remain_ranked_2;
-- 自检：看各行业实际取到多少家，满 50 的说明该行业原表还有更多企业被截下
SELECT indv_nm,
    COUNT(*) AS indv_cnt
FROM company_remain_ranked_2
GROUP BY indv_nm
ORDER BY indv_cnt DESC
LIMIT 100;
-- ----------------------------------------------------------------------------
-- 最后输出纯文本清单：按 rank_no 取前 3000 名，用信用代码后 5 位回 company
-- 取完整代码。company_remain_ranked 的 uni_social_crd_cd 在结果窗口里中间
-- 段显示不全，截屏带走的不是完整社会信用代码，这里改从 company 输出。
-- 脚本建的 company 表没有 uni_social_crd_cd_last5 列，后 5 位按
-- SUBSTR(uni_social_crd_cd, LENGTH(uni_social_crd_cd) - 4, 5) 现算；现场库里
-- 若确有该列，把 company 侧子查询换成直接取列即可，关联条件不用改。
-- 后 5 位不是唯一键，下面两条自检先看有没有碰撞和匹配不上的名次。
-- WITHIN GROUP (ORDER BY rank_no) 保证输出顺序与排名一致；LEFT JOIN 保留
-- 全部名次，匹配不到时该名次取不到完整代码，先看自检的 unmatched_rows。
-- 默认 3000 个拼进一个单元格；查询窗口截断超长单元格时把 3000.0 改小
-- （如 100.0）就变成每 100 个一行、约 30 行。
-- 若报函数或语法不支持，取消下一行注释并与本查询一起提交执行：
-- SET odps.sql.type.system.odps2=true;
-- ----------------------------------------------------------------------------
-- 自检：company 里后 5 位若有重复，一个排名会匹配出多个完整代码
SELECT cd_last5,
    COUNT(DISTINCT uni_social_crd_cd) AS cd_kinds
FROM (
        SELECT uni_social_crd_cd,
            SUBSTR(
                uni_social_crd_cd,
                LENGTH(uni_social_crd_cd) - 4,
                5
            ) AS cd_last5
        FROM company
        WHERE uni_social_crd_cd IS NOT NULL
            AND TRIM(uni_social_crd_cd) <> ''
    ) t
GROUP BY cd_last5
HAVING COUNT(DISTINCT uni_social_crd_cd) > 1
ORDER BY cd_kinds DESC
LIMIT 100;
-- 自检：matched_rows 应等于 rank_no_kinds，unmatched_rows 应为 0；
-- matched_rows 偏大就是后 5 位碰撞造成一对多膨胀
SELECT COUNT(*) AS matched_rows,
    COUNT(DISTINCT r.rank_no) AS rank_no_kinds,
    SUM(
        CASE
            WHEN c.uni_social_crd_cd IS NULL THEN 1
            ELSE 0
        END
    ) AS unmatched_rows
FROM (
        SELECT rank_no,
            uni_social_crd_cd,
            SUBSTR(
                uni_social_crd_cd,
                LENGTH(uni_social_crd_cd) - 4,
                5
            ) AS cd_last5
        FROM company_remain_ranked
        WHERE rank_no <= 3000
            AND uni_social_crd_cd IS NOT NULL
            AND TRIM(uni_social_crd_cd) <> ''
    ) r
    LEFT JOIN (
        SELECT uni_social_crd_cd,
            SUBSTR(
                uni_social_crd_cd,
                LENGTH(uni_social_crd_cd) - 4,
                5
            ) AS cd_last5
        FROM company
        WHERE uni_social_crd_cd IS NOT NULL
            AND TRIM(uni_social_crd_cd) <> ''
    ) c ON r.cd_last5 = c.cd_last5;
SELECT batch_no,
    WM_CONCAT (', ', c.uni_social_crd_cd) WITHIN GROUP (
        ORDER BY rank_no
    ) AS codes
FROM (
        SELECT CEIL(rank_no / 3000.0) AS batch_no,
            rank_no,
            uni_social_crd_cd,
            SUBSTR(
                uni_social_crd_cd,
                LENGTH(uni_social_crd_cd) - 4,
                5
            ) AS cd_last5
        FROM company_remain_ranked
        WHERE rank_no <= 3000
            AND uni_social_crd_cd IS NOT NULL
            AND TRIM(uni_social_crd_cd) <> ''
    ) r
    LEFT JOIN (
        SELECT uni_social_crd_cd,
            SUBSTR(
                uni_social_crd_cd,
                LENGTH(uni_social_crd_cd) - 4,
                5
            ) AS cd_last5
        FROM company
        WHERE uni_social_crd_cd IS NOT NULL
            AND TRIM(uni_social_crd_cd) <> ''
    ) c ON r.cd_last5 = c.cd_last5
GROUP BY batch_no
ORDER BY batch_no
LIMIT 3000;
-- ----------------------------------------------------------------------------
-- 公司名同样再出一份纯文本清单：末尾输出时 comp_nm 也会被结果显示截断，
-- 这里按与上面代码清单完全相同的关联和次序，从 company 取完整企业名称。
-- batch_no 与代码清单一致，同一行内第 N 个名称对应代码清单的第 N 个代码，
-- 两份清单按位置配对使用；先看上面的 unmatched_rows 自检，为 0 才不会错位。
-- 分隔符沿用逗号加空格；企业名本身若含逗号会混淆，可换成竖线等不会出现的符号。
-- 名称比代码长，默认 3000 个拼进一个单元格更容易被窗口截断，按同样办法
-- 把 3000.0 改小（如 100.0）分批；两处 batch 参数要一起改，否则批次对不上。
-- ----------------------------------------------------------------------------
SELECT batch_no,
    WM_CONCAT (', ', c.comp_nm) WITHIN GROUP (
        ORDER BY rank_no
    ) AS NAMES
FROM (
        SELECT CEIL(rank_no / 3000.0) AS batch_no,
            rank_no,
            uni_social_crd_cd,
            SUBSTR(
                uni_social_crd_cd,
                LENGTH(uni_social_crd_cd) - 4,
                5
            ) AS cd_last5
        FROM company_remain_ranked
        WHERE rank_no <= 3000
            AND uni_social_crd_cd IS NOT NULL
            AND TRIM(uni_social_crd_cd) <> ''
    ) r
    LEFT JOIN (
        SELECT comp_nm,
            SUBSTR(
                uni_social_crd_cd,
                LENGTH(uni_social_crd_cd) - 4,
                5
            ) AS cd_last5
        FROM company
        WHERE uni_social_crd_cd IS NOT NULL
            AND TRIM(uni_social_crd_cd) <> ''
    ) c ON r.cd_last5 = c.cd_last5
GROUP BY batch_no
ORDER BY batch_no
LIMIT 3000;