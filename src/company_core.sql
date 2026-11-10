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