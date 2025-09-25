-- 基于已创建的 company 表，逐步左连接其他表，每步生成一个中间表
-- 使用聚合函数避免数据膨胀，确保每个企业只有一条记录

-- ==========================================
-- 扩展法定代表人信息
-- ==========================================

DROP TABLE IF EXISTS company_fddb;

CREATE TABLE company_fddb AS
SELECT
    core.*,
    MAX(fddb.nm) AS fddb_nm,                   -- 法定代表人姓名
    MAX(fddb.tel_num) AS fddb_tel_num          -- 法定代表人固定电话
FROM company_core core
LEFT JOIN dw_zj_scjdgl_fddbrxx fddb ON core.uni_social_crd_cd = fddb.uni_social_crd_cd AND fddb.lerep_sign = 1
GROUP BY core.uni_social_crd_cd;

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
-- 扩展股权变更信息
-- ==========================================

DROP TABLE IF EXISTS company_gqbg;

CREATE TABLE company_gqbg AS
SELECT
    core.*,
    COUNT(gqbg.uni_social_crd_cd) AS gqbg_count,  -- 股权变更次数
    (SELECT gqbg.alt_dt
     FROM dw_nb_scjdgl_gqbg gqbg
     WHERE gqbg.uni_social_crd_cd = core.uni_social_crd_cd
     ORDER BY gqbg.alt_dt DESC
     LIMIT 1) AS latest_gqbg_dt  -- 最新股权变更日期
FROM company_core core
LEFT JOIN dw_nb_scjdgl_gqbg gqbg ON core.uni_social_crd_cd = gqbg.uni_social_crd_cd
GROUP BY core.uni_social_crd_cd;

SELECT
    COUNT(*) AS gqbg_count
FROM company_gqbg;

SELECT * FROM company_gqbg LIMIT 10;

-- ==========================================
-- 扩展企业年报资产信息
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
