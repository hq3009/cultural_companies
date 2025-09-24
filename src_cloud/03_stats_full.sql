-- 统计分析（分步执行）
-- 每个查询都可以单独执行，立即看到结果
-- 基于 company_core 表和各业务领域扩展表

-- ========================================
-- 查看基础数据
-- ========================================
SELECT
    COUNT(*) AS total_company, -- 企业总数
    COUNT(DISTINCT indv_nm) AS industry_count, -- 行业种类数量
    COUNT(DISTINCT comp_type) AS company_type_count, -- 企业类型数量
    COUNT(DISTINCT domdi_strict) AS district_count -- 涉及区县数量
FROM company_core;

-- ========================================
-- 企业家数统计
-- ========================================
SELECT
    '企业家数统计' AS statistics_category, -- 统计类别
    (SELECT COUNT(*) FROM company_core) AS total_company, -- 企业总数
    0 AS changed_company, -- 变更企业数
    (SELECT COUNT(DISTINCT uni_social_crd_cd) FROM company_jyyc WHERE busexclist IS NOT NULL) AS abnormal_operation_company, -- 经营异常企业数
    (SELECT COUNT(DISTINCT uni_social_crd_cd) FROM company_yzwf WHERE ill_comp_id IS NOT NULL) AS serious_violation_company, -- 严重违法失信企业数
    (SELECT COUNT(DISTINCT uni_social_crd_cd) FROM company_sxr WHERE executed_nm IS NOT NULL) AS dishonest_executed_company, -- 失信被执行人企业数
    (SELECT COUNT(DISTINCT uni_social_crd_cd) FROM company_kjxw WHERE cogn_year IS NOT NULL) AS tech_small_company, -- 科技型小微企业数
    (SELECT COUNT(DISTINCT uni_social_crd_cd) FROM company_xypj_a WHERE tax_credi_level = 'A') AS grade_a_taxpayer_company, -- A级纳税人企业数
    (SELECT COUNT(DISTINCT uni_social_crd_cd) FROM company_wzwd WHERE web_id IS NOT NULL) AS company_with_website, -- 有网站网店企业数
    (SELECT COUNT(DISTINCT uni_social_crd_cd) FROM company_xzcf WHERE admin_punish_doc IS NOT NULL) AS company_with_penalty, -- 有行政处罚企业数
    (SELECT COUNT(DISTINCT uni_social_crd_cd) FROM company_gqbg WHERE inv IS NOT NULL) AS company_with_equity_change, -- 有股权变更企业数
    (SELECT COUNT(DISTINCT uni_social_crd_cd) FROM company_db WHERE creditor IS NOT NULL) AS company_with_guarantee -- 有对外担保企业数
FROM company_core LIMIT 1;

-- ========================================
-- 经营状况统计
-- ========================================
SELECT
    '经营状况统计' AS statistics_category, -- 统计类别
    COUNT(core.uni_social_crd_cd) AS total_companies_with_financial_data, -- 有财务数据企业总数
    ROUND(AVG(nb.asset_zmt), 2) AS avg_total_assets, -- 平均资产总额
    ROUND(SUM(nb.asset_zmt), 2) AS total_assets, -- 总资产总额
    ROUND(AVG(nb.opt_income_total), 2) AS avg_operating_income, -- 平均营业收入
    ROUND(SUM(nb.opt_income_total), 2) AS total_operating_income, -- 总营业收入
    ROUND(AVG(nb.net_profit), 2) AS avg_net_profit, -- 平均净利润
    ROUND(SUM(nb.net_profit), 2) AS total_net_profit, -- 总净利润
    ROUND(AVG(nb.annual_tax_total), 2) AS avg_total_tax, -- 平均纳税总额
    ROUND(SUM(nb.annual_tax_total), 2) AS total_tax, -- 总纳税总额
    ROUND(AVG(ns.tax_amt), 2) AS avg_tax_amount, -- 平均纳税金额
    ROUND(SUM(ns.tax_amt), 2) AS total_tax_amount -- 总纳税金额
FROM company_core core
LEFT JOIN company_nb nb ON core.uni_social_crd_cd = nb.uni_social_crd_cd
LEFT JOIN company_ns ns ON core.uni_social_crd_cd = ns.uni_social_crd_cd
WHERE nb.asset_zmt IS NOT NULL OR nb.opt_income_total IS NOT NULL OR ns.tax_amt IS NOT NULL;

-- ========================================
-- 社保参与统计
-- ========================================
SELECT
    '社保参与统计' AS statistics_category, -- 统计类别
    (SELECT COUNT(*) FROM company_core) AS total_company, -- 企业总数
    (SELECT COUNT(DISTINCT uni_social_crd_cd) FROM company_sb_jbxx WHERE pens_num IS NOT NULL) AS company_with_social_insurance, -- 参与社保企业数
    (SELECT COUNT(DISTINCT uni_social_crd_cd) FROM company_core c LEFT JOIN company_sb_jbxx sb ON c.uni_social_crd_cd = sb.uni_social_crd_cd WHERE sb.pens_num IS NULL) AS company_without_social_insurance, -- 未参与社保企业数
    ROUND((SELECT COUNT(DISTINCT uni_social_crd_cd) FROM company_sb_jbxx WHERE pens_num IS NOT NULL) * 100.0 / (SELECT COUNT(*) FROM company_core), 2) AS social_insurance_participation_rate, -- 社保参与率
    (SELECT ROUND(AVG(pens_num), 2) FROM company_sb_jbxx WHERE pens_num IS NOT NULL) AS avg_pension_insurance_count, -- 平均养老保险人数
    (SELECT ROUND(AVG(medic_num), 2) FROM company_sb_jbxx WHERE medic_num IS NOT NULL) AS avg_medical_insurance_count, -- 平均医疗保险人数
    (SELECT ROUND(AVG(unemploy_num), 2) FROM company_sb_jbxx WHERE unemploy_num IS NOT NULL) AS avg_unemployment_insurance_count, -- 平均失业保险人数
    (SELECT ROUND(AVG(injury_num), 2) FROM company_sb_jbxx WHERE injury_num IS NOT NULL) AS avg_work_injury_insurance_count, -- 平均工伤保险人数
    (SELECT ROUND(AVG(materni_num), 2) FROM company_sb_jbxx WHERE materni_num IS NOT NULL) AS avg_maternity_insurance_count -- 平均生育保险人数
FROM company_core LIMIT 1;

-- ========================================
-- 企业变更活动统计
-- ========================================
SELECT
    '企业变更活动统计' AS statistics_category, -- 统计类别
    (SELECT COUNT(*) FROM company_core) AS total_company, -- 企业总数
    (SELECT COUNT(*) FROM company_fddb WHERE fddb_nm IS NOT NULL) AS legal_representative_changes, -- 法定代表人变更次数
    (SELECT COUNT(*) FROM company_jyyc WHERE busexclist IS NOT NULL) AS abnormal_operation_records, -- 经营异常记录数
    (SELECT COUNT(*) FROM company_yzwf WHERE ill_comp_id IS NOT NULL) AS serious_violation_records, -- 严重违法记录数
    (SELECT COUNT(*) FROM company_gqbg WHERE inv IS NOT NULL) AS equity_change_records, -- 股权变更记录数
    (SELECT COUNT(*) FROM company_sxr WHERE executed_nm IS NOT NULL) AS dishonest_execution_records, -- 失信执行记录数
    (SELECT COUNT(*) FROM company_db WHERE creditor IS NOT NULL) AS guarantee_records, -- 担保记录数
    (SELECT COUNT(*) FROM company_xzcf WHERE admin_punish_doc IS NOT NULL) AS penalty_records -- 行政处罚记录数
FROM company_core LIMIT 1;

-- ========================================
-- 企业信用状况统计
-- ========================================
SELECT
    '企业信用状况统计' AS statistics_category, -- 统计类别
    (SELECT COUNT(*) FROM company_core) AS total_company, -- 企业总数
    (SELECT COUNT(*) FROM company_xypj_a WHERE tax_credi_level = 'A') AS grade_a_taxpayers, -- A级纳税人数量
    (SELECT COUNT(*) FROM company_xypj_a WHERE tax_credi_level = 'B') AS grade_b_taxpayers, -- B级纳税人数量
    (SELECT COUNT(*) FROM company_xypj_a WHERE tax_credi_level = 'C') AS grade_c_taxpayers, -- C级纳税人数量
    (SELECT COUNT(*) FROM company_xypj_a WHERE tax_credi_level = 'D') AS grade_d_taxpayers, -- D级纳税人数量
    ROUND((SELECT COUNT(*) FROM company_xypj_a WHERE tax_credi_level = 'A') * 100.0 / (SELECT COUNT(*) FROM company_core), 2) AS grade_a_rate, -- A级纳税人比例
    (SELECT COUNT(DISTINCT uni_social_crd_cd) FROM company_xypj WHERE credi_scard IS NOT NULL) AS company_with_credit_evaluation, -- 有信用评价企业数
    ROUND((SELECT COUNT(DISTINCT uni_social_crd_cd) FROM company_xypj WHERE credi_scard IS NOT NULL) * 100.0 / (SELECT COUNT(*) FROM company_core), 2) AS credit_evaluation_rate -- 信用评价覆盖率
FROM company_core LIMIT 1;

-- ========================================
-- 企业成立时间分布统计
-- ========================================
SELECT
    '企业成立时间分布' AS statistics_category, -- 统计类别
    COUNT(CASE WHEN est_dt >= '2020-01-01' THEN 1 END) AS company_after_2020, -- 2020年后成立企业数
    COUNT(CASE WHEN est_dt >= '2015-01-01' AND est_dt < '2020-01-01' THEN 1 END) AS company_2015_2019, -- 2015-2019年成立企业数
    COUNT(CASE WHEN est_dt >= '2010-01-01' AND est_dt < '2015-01-01' THEN 1 END) AS company_2010_2014, -- 2010-2014年成立企业数
    COUNT(CASE WHEN est_dt < '2010-01-01' THEN 1 END) AS company_before_2010, -- 2010年前成立企业数
    ROUND(COUNT(CASE WHEN est_dt >= '2020-01-01' THEN 1 END) * 100.0 / COUNT(*), 2) AS percentage_after_2020, -- 2020年后占比
    ROUND(COUNT(CASE WHEN est_dt >= '2015-01-01' AND est_dt < '2020-01-01' THEN 1 END) * 100.0 / COUNT(*), 2) AS percentage_2015_2019, -- 2015-2019年占比
    ROUND(COUNT(CASE WHEN est_dt >= '2010-01-01' AND est_dt < '2015-01-01' THEN 1 END) * 100.0 / COUNT(*), 2) AS percentage_2010_2014, -- 2010-2014年占比
    ROUND(COUNT(CASE WHEN est_dt < '2010-01-01' THEN 1 END) * 100.0 / COUNT(*), 2) AS percentage_before_2010 -- 2010年前占比
FROM company_core;

-- ========================================
-- 行业分布统计
-- ========================================
SELECT
    '行业分布统计' AS statistics_category, -- 统计类别
    indv_nm, -- 行业代码
    COUNT(*) AS company_count, -- 企业数量
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM company_core), 2) AS percentage -- 占比
FROM company_core
GROUP BY indv_nm
ORDER BY company_count DESC
LIMIT 20;
