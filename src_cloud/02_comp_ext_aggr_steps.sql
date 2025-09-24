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
    COUNT(jyyc.uni_social_crd_cd) AS jyyc_count,  -- 经营异常记录数
    (SELECT jyyc.inclu_dt
     FROM dw_zj_scjdgl_jyycmlxx jyyc
     WHERE jyyc.uni_social_crd_cd = core.uni_social_crd_cd
     ORDER BY jyyc.inclu_dt DESC
     LIMIT 1) AS jyyc_latest_inclu_dt,  -- 最新列入日期
    (SELECT jyyc.inclu_reason
     FROM dw_zj_scjdgl_jyycmlxx jyyc
     WHERE jyyc.uni_social_crd_cd = core.uni_social_crd_cd
     ORDER BY jyyc.inclu_dt DESC
     LIMIT 1) AS jyyc_latest_reason     -- 最新列入原因

FROM company_core core
LEFT JOIN dw_zj_scjdgl_jyycmlxx jyyc ON core.uni_social_crd_cd = jyyc.uni_social_crd_cd
GROUP BY core.uni_social_crd_cd;

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
    COUNT(yzwf.uni_social_crd_cd) AS yzwf_count, -- 严重违法失信企业名单记录数
    (SELECT yzwf.serill_rea
     FROM dw_zj_scjdgl_yzwfsx yzwf
     WHERE yzwf.uni_social_crd_cd = core.uni_social_crd_cd
     ORDER BY yzwf.abn_tm DESC
     LIMIT 1) AS latest_serill_rea  -- 最新列入严重违法失信企业名单原因
FROM company_core core
LEFT JOIN dw_zj_scjdgl_yzwfsx yzwf ON core.uni_social_crd_cd = yzwf.uni_social_crd_cd
GROUP BY core.UNI_SOCIAL_CRD_CD;

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
    (SELECT nb.asset_zmt
     FROM dw_nb_scjdgl_qynbzcxx nb
     WHERE nb.uni_social_crd_cd = core.uni_social_crd_cd
     ORDER BY nb.annual_year DESC
     LIMIT 1) AS asset_zmt,             -- 最新年报年度的资产总额
    (SELECT nb.debt_amt
     FROM dw_nb_scjdgl_qynbzcxx nb
     WHERE nb.uni_social_crd_cd = core.uni_social_crd_cd
     ORDER BY nb.annual_year DESC
     LIMIT 1) AS debt_amt,              -- 最新年报年度的负债总额
    (SELECT nb.opt_income_total
     FROM dw_nb_scjdgl_qynbzcxx nb
     WHERE nb.uni_social_crd_cd = core.uni_social_crd_cd
     ORDER BY nb.annual_year DESC
     LIMIT 1) AS nb_opt_income_total,      -- 最新年报年度的营业总收入
    (SELECT nb.profit_total
     FROM dw_nb_scjdgl_qynbzcxx nb
     WHERE nb.uni_social_crd_cd = core.uni_social_crd_cd
     ORDER BY nb.annual_year DESC
     LIMIT 1) AS nb_profit_total,          -- 最新年报年度的利润总额
    (SELECT nb.net_profit
     FROM dw_nb_scjdgl_qynbzcxx nb
     WHERE nb.uni_social_crd_cd = core.uni_social_crd_cd
     ORDER BY nb.annual_year DESC
     LIMIT 1) AS nb_net_profit,            -- 最新年报年度的净利润
    (SELECT nb.tax_total
     FROM dw_nb_scjdgl_qynbzcxx nb
     WHERE nb.uni_social_crd_cd = core.uni_social_crd_cd
     ORDER BY nb.annual_year DESC
     LIMIT 1) AS nb_tax_total,             -- 最新年报年度的纳税总额
    (SELECT nb.annual_year
     FROM dw_nb_scjdgl_qynbzcxx nb
     WHERE nb.uni_social_crd_cd = core.uni_social_crd_cd
     ORDER BY nb.annual_year DESC
     LIMIT 1) AS nb_year      -- 最新年报年度
FROM company_core core
LEFT JOIN dw_nb_scjdgl_qynbzcxx nb ON core.uni_social_crd_cd = nb.uni_social_crd_cd
GROUP BY core.uni_social_crd_cd;

SELECT
    COUNT(*) AS nb_count
FROM company_nb;

SELECT * FROM company_nb LIMIT 10;

-- ==========================================
-- 扩展纳税信息
-- ==========================================

DROP TABLE IF EXISTS company_ns;

CREATE TABLE company_ns AS
SELECT
    core.*,
    (SELECT ns.tax_amt
     FROM dw_nb_sw_nsxx ns
     WHERE ns.uni_social_crd_cd = core.uni_social_crd_cd
     ORDER BY ns.count_dt DESC
     LIMIT 1) AS tax_amt,               -- 最新纳税总额
    (SELECT ns.sale_inco
     FROM dw_nb_sw_nsxx ns
     WHERE ns.uni_social_crd_cd = core.uni_social_crd_cd
     ORDER BY ns.count_dt DESC
     LIMIT 1) AS tax_sale_inco,             -- 最新销售收入
    (SELECT ns.count_dt
     FROM dw_nb_sw_nsxx ns
     WHERE ns.uni_social_crd_cd = core.uni_social_crd_cd
     ORDER BY ns.count_dt DESC
     LIMIT 1) AS tax_count_dt,              -- 最新统计时间
FROM company_core core;

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
    (SELECT xypj.tax_credi_level
     FROM dw_nb_sw_xypjxxa xypj
     WHERE xypj.uni_social_crd_cd = core.uni_social_crd_cd
     ORDER BY xypj.eval_dt DESC
     LIMIT 1) AS tax_credi_level,       -- 最新评定日期的纳税信用等级
    (SELECT xypj.eval_year
     FROM dw_nb_sw_xypjxxa xypj
     WHERE xypj.uni_social_crd_cd = core.uni_social_crd_cd
     ORDER BY xypj.eval_dt DESC
     LIMIT 1) AS eval_year              -- 最新评定日期的纳税信用等级评定年度
FROM company_core core;

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
    COUNT(sxr.uni_social_crd_cd) AS sxr_count,  -- 失信记录数
    (SELECT sxr.executed_nm
     FROM dw_zj_fzgg_sxbzxrxx sxr
     WHERE sxr.uni_social_crd_cd = core.uni_social_crd_cd
     ORDER BY sxr.fil_dt DESC
     LIMIT 1) AS latest_executed_nm,     -- 最新被执行人姓名
    (SELECT sxr.executed_court
     FROM dw_zj_fzgg_sxbzxrxx sxr
     WHERE sxr.uni_social_crd_cd = core.uni_social_crd_cd
     ORDER BY sxr.fil_dt DESC
     LIMIT 1) AS latest_executed_court,  -- 最新执行法院
    (SELECT sxr.fil_dt
     FROM dw_zj_fzgg_sxbzxrxx sxr
     WHERE sxr.uni_social_crd_cd = core.uni_social_crd_cd
     ORDER BY sxr.fil_dt DESC
     LIMIT 1) AS latest_fil_dt           -- 最新立案时间
FROM company_core core
LEFT JOIN dw_zj_fzgg_sxbzxrxx sxr ON core.uni_social_crd_cd = sxr.uni_social_crd_cd
GROUP BY core.uni_social_crd_cd;

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
    COUNT(xzcf.uni_social_crd_cd) AS xzcf_count,  -- 行政处罚次数
    (SELECT xzcf.admin_punish_doc
     FROM dw_nb_scjdgl_xzcfgsxx xzcf
     WHERE xzcf.uni_social_crd_cd = core.uni_social_crd_cd
     ORDER BY xzcf.punish_dt DESC
     LIMIT 1) AS latest_punish_doc,     -- 最新行政处罚文号
    (SELECT xzcf.punish_dt
     FROM dw_nb_scjdgl_xzcfgsxx xzcf
     WHERE xzcf.uni_social_crd_cd = core.uni_social_crd_cd
     ORDER BY xzcf.punish_dt DESC
     LIMIT 1) AS latest_punish_dt,      -- 最新处罚时间
    (SELECT xzcf.punish_rea
     FROM dw_nb_scjdgl_xzcfgsxx xzcf
     WHERE xzcf.uni_social_crd_cd = core.uni_social_crd_cd
     ORDER BY xzcf.punish_dt DESC
     LIMIT 1) AS latest_punish_rea      -- 最新处罚原因
FROM company_core core
LEFT JOIN dw_nb_scjdgl_xzcfgsxx xzcf ON core.uni_social_crd_cd = xzcf.uni_social_crd_cd
GROUP BY core.uni_social_crd_cd;

SELECT
    COUNT(*) AS xzcf_count
FROM company_xzcf;

SELECT * FROM company_xzcf LIMIT 10;
