-- 宁波市文旅经营主体数据分析脚本（MaxCompute版）
--
-- 运行环境：阿里云 MaxCompute，连接项目 jrsjc_dev；源表在 odps_jrsjc_pod，
-- 一律写全限定名 odps_jrsjc_pod.dw_xxx；自建表在 jrsjc_dev，保持裸名。
--
-- 逐条执行：DROP 与 CREATE 连续跑完，CREATE 后用自检 SELECT 确认表建成。
-- 往下跑之前必须看 SECTION 1 的行业代码匹配核对，matched_rows 为 0 则停止。
--
-- SECTION 0  执行前检查
-- SECTION 1  基础代码与字典表
-- SECTION 2  文旅经营主体筛选
-- SECTION 3  根据负面指标删选
-- SECTION 4  根据正面指标排序
--
-- ============================================================================
-- SECTION 0  执行前检查
-- ============================================================================
--
-- 全局自检：单独跑这一条，对照 README 的输出表清单找缺哪张表
SHOW TABLES;

-- 确认行业代码字段形态。本文件假设 indv_nm 在当前数据中存放的是四位行业代码，
-- 下面只看前 10 个高频取值；是否真的能与代码表匹配，要看 SECTION 1
-- 建完 industry_codes 之后的匹配核对，那条才是硬校验。
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
-- 文旅行业代码表：来源 docs/文旅行业名称与行业代码.xlsx，只存代码。
-- 63 个代码只在此维护，下游统一用 IN (SELECT indv_nm FROM industry_codes)。
-- MaxCompute 版为 STRING、无主键、COMMENT 不带等号；每次先 DROP 再 CREATE。
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
-- 硬校验：确认 indv_nm 与代码表能否匹配。
-- 字段字典把 indv_nm 标为行业名称，把 indv_code 标为行业代码，与脚本假设
-- 可能不一致，必须以本条结果为准，不能只看字典中文名就往下跑。
-- matched_rows 为 0 或明显偏小，说明该字段不是四位代码，SECTION 2 会筛出
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

-- ############################################################################
-- SECTION 2  文旅经营主体筛选
-- ############################################################################
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
-- 按 63 个行业代码提取，按信用代码去重留最新一条
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
            AND s.indv_nm IN (
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
-- 创建企业核心信息表
-- 抽取核心字段，作为全链路基准表
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
    appr_dt
FROM company;

SELECT COUNT(*) AS core_count
FROM company_core;

-- 显示表结构
DESC company_core;

-- 显示前10条记录
SELECT *
FROM company_core
LIMIT 10;

-- 从 company_core 中只保留在册企业，作为逐项剔除的统一剩余表
-- company_remain 之后始终表示当前剩余企业，每步原地覆写，不再为每步新建表
-- K 是在册状态码，依据 docs/企业状态码值.xlsx 与 docs/正面和负面指标.md；
-- 字段字典把样例写成开业，那是同一状态的中文展示值，此处按状态码取。
-- 现场若另有取值，先跑上面的 reg_state 分布核对再改这一行。
DROP TABLE IF EXISTS company_remain;

CREATE TABLE company_remain AS
SELECT *
FROM company_core
WHERE reg_state = 'K';

SELECT COUNT(*) AS remain_count
FROM company_remain;

-- ============================================================================
-- SECTION 3 根据负面指标删选
-- 本版只落地三类一票否决项：严重违法失信、失信被执行人、未履行生效裁判。
-- 重大税收违法黑名单、纳税非正常户、纳税信用低等级、敏感行业标志、经营异常、
-- 行政处罚等尚未写入，插入新步骤时照下面三段的结构续写即可。
--
-- company_remain 是全链路唯一的剩余企业表：由 company_core 建立在册企业后，
-- 每步都用 INSERT OVERWRITE 原地覆写，不再为每步新建表。
-- 每步先跑命中家数自检，为 0 要先查关联键与日期口径，再决定是否覆写；
-- 覆写后再看剩余家数，否则关联失效会被静默掩盖。
-- 每步注释写明本步剔除的负面指标、来源标准表与判断口径，便于插入或调整顺序。
-- ============================================================================
--
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
            AND SUBSTR(abn_tm, 1, 4) IN ('2023', '2024', '2025')
    ) bad ON c.uni_social_crd_cd = bad.uni_social_crd_cd;

INSERT OVERWRITE TABLE company_remain
SELECT c.*
FROM company_remain c
    LEFT JOIN (
        SELECT DISTINCT uni_social_crd_cd
        FROM odps_jrsjc_pod.dw_zj_scjdgl_yzwfsx
        WHERE uni_social_crd_cd IS NOT NULL
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
            AND SUBSTR(CAST(fil_dt AS STRING), 1, 4) IN ('2023', '2024', '2025')
    ) bad ON c.uni_social_crd_cd = bad.uni_social_crd_cd;

INSERT OVERWRITE TABLE company_remain
SELECT c.*
FROM company_remain c
    LEFT JOIN (
        SELECT DISTINCT uni_social_crd_cd
        FROM odps_jrsjc_pod.dw_zj_fzgg_sxbzxrxx
        WHERE uni_social_crd_cd IS NOT NULL
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
            AND SUBSTR(CAST(filing_dt AS STRING), 1, 4) IN ('2023', '2024', '2025')
    ) bad ON c.uni_social_crd_cd = bad.uni_social_crd_cd;

INSERT OVERWRITE TABLE company_remain
SELECT c.*
FROM company_remain c
    LEFT JOIN (
        SELECT DISTINCT uni_social_crd_cd
        FROM odps_jrsjc_pod.dw_shl_qywlxsxcpxx
        WHERE uni_social_crd_cd IS NOT NULL
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
-- ----------------------------------------------------------------------------
-- 关联最新纳税信用等级，先按等级、再按注册资本生成排名并落表
-- 来源标准表：DW_NB_SW_NSXYDJXX（纳税信用等级信息），用 tax_credit_level、evalua_year。
-- 一家企业可能有多个评价年度，先取最新一条，避免关联时一对多膨胀。
-- evalua_year 在字段字典中是 STRING，只取前四位年份参与比较，兼容带后缀的写法；
-- 同一年度有多条时按评定时间 evalua_dt 递减固定次序。
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
            t.tax_credit_level,
            CASE
                SUBSTR(UPPER(TRIM(t.tax_credit_level)), 1, 1)
                WHEN 'A' THEN 1
                WHEN 'B' THEN 2
                WHEN 'M' THEN 3
                WHEN 'C' THEN 4
                WHEN 'D' THEN 5
                ELSE 9
            END AS credit_rank
        FROM company_remain c
            LEFT JOIN (
                SELECT uni_social_crd_cd,
                    tax_credit_level,
                    ROW_NUMBER() OVER (
                        PARTITION BY uni_social_crd_cd
                        ORDER BY SUBSTR(TRIM(evalua_year), 1, 4) DESC,
                            evalua_dt DESC
                    ) AS rn
                FROM odps_jrsjc_pod.dw_nb_sw_nsxydjxx
                WHERE uni_social_crd_cd IS NOT NULL
            ) t ON c.uni_social_crd_cd = t.uni_social_crd_cd
            AND t.rn = 1
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
-- 最后输出纯文本清单，按 rank_no 取前 3000 名
-- 原来是 3000 行 1 列的表格，截屏要翻很多页；这里用 WM_CONCAT 拼成
-- 逗号分隔的紧凑文本，WITHIN GROUP (ORDER BY rank_no) 保证顺序与排名一致。
-- 默认 3000 个全拼进一个单元格；若查询窗口截断超长单元格，把 3000.0
-- 改小（如 100.0）就变成每 100 个一行、约 30 行，行数少，几屏就能截完。
-- 若报函数或语法不支持，取消下一行注释并与本查询一起提交执行：
-- SET odps.sql.type.system.odps2=true;
-- ----------------------------------------------------------------------------
SELECT batch_no,
    WM_CONCAT(', ', uni_social_crd_cd) WITHIN GROUP (
        ORDER BY rank_no
    ) AS codes
FROM (
        SELECT CEIL(rank_no / 3000.0) AS batch_no,
            rank_no,
            uni_social_crd_cd
        FROM company_remain_ranked
        WHERE rank_no <= 3000
            AND uni_social_crd_cd IS NOT NULL
            AND TRIM(uni_social_crd_cd) <> ''
    ) s
GROUP BY batch_no
ORDER BY batch_no
LIMIT 3000;