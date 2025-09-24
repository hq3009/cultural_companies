-- 统计分析（分步执行）
-- 每个查询都可以单独执行，立即看到结果
-- 基于 company_core 表和各业务领域聚合表

-- ========================================
-- 查看基础数据
-- ========================================
SELECT
    COUNT(*) AS total_company, -- 企业总数
    COUNT(DISTINCT indv_nm) AS industry_count, -- 行业种类数量
    COUNT(DISTINCT comp_type) AS company_type_count, -- 企业类型数量
FROM company_core;

-- ========================================
-- 企业家数统计
-- ========================================
SELECT
    '企业家数统计' AS statistics_category, -- 统计类别
    (SELECT COUNT(*) FROM company_core) AS total_company, -- 企业总数
    0 AS changed_company, -- 变更企业数
    (SELECT COUNT(*) FROM company_jyyc WHERE jyyc_latest_reason IS NOT NULL) AS abnormal_operation_company, -- 经营异常企业数
    (SELECT COUNT(*) FROM company_yzwf WHERE latest_serill_rea IS NOT NULL) AS serious_violation_company, -- 严重违法失信企业数
    (SELECT COUNT(*) FROM company_sxr WHERE latest_executed_nm IS NOT NULL) AS dishonest_executed_company, -- 失信被执行人企业数
    0 AS tech_small_company, -- 科技型小微企业数（需要单独统计）
    (SELECT COUNT(*) FROM company_xypj WHERE tax_credi_level = 'A') AS grade_a_taxpayer_company, -- A级纳税人企业数
    (SELECT COUNT(*) FROM company_wzwd WHERE wzwd_url IS NOT NULL) AS company_with_website, -- 有网站网店企业数
    (SELECT COUNT(*) FROM company_xzcf WHERE latest_punish_doc IS NOT NULL) AS company_with_penalty, -- 有行政处罚企业数
    (SELECT COUNT(*) FROM company_gqbg WHERE latest_gqbg_dt IS NOT NULL) AS company_with_equity_change, -- 有股权变更企业数
    0 AS company_with_guarantee -- 有对外担保企业数（需要单独统计）
FROM company_core LIMIT 1;

-- ========================================
-- 经营状况统计
-- ========================================
SELECT
    '经营状况统计' AS statistics_category, -- 统计类别
    COUNT(*) AS company_with_financial_data, -- 有财务数据企业数
    ROUND(AVG(asset_zmt), 2) AS avg_total_assets, -- 平均资产总额
    ROUND(SUM(asset_zmt), 2) AS total_assets, -- 总资产总额
    ROUND(AVG(nb_opt_income_total), 2) AS avg_operating_income, -- 平均营业收入
    ROUND(SUM(nb_opt_income_total), 2) AS total_operating_income, -- 总营业收入
    ROUND(AVG(nb_net_profit), 2) AS avg_net_profit, -- 平均净利润
    ROUND(SUM(nb_net_profit), 2) AS total_net_profit, -- 总净利润
    ROUND(AVG(nb_tax_total), 2) AS avg_total_tax, -- 平均纳税总额
    ROUND(SUM(nb_tax_total), 2) AS total_tax, -- 总纳税总额
    ROUND(AVG(tax_amt), 2) AS avg_tax_amount, -- 平均纳税金额
    ROUND(SUM(tax_amt), 2) AS total_tax_amount -- 总纳税金额
FROM company_nb
WHERE asset_zmt IS NOT NULL OR nb_opt_income_total IS NOT NULL;

-- ========================================
-- 社保参与统计
-- ========================================
SELECT
    '社保参与统计' AS statistics_category, -- 统计类别
    (SELECT COUNT(*) FROM company_core) AS total_company, -- 企业总数
    0 AS company_with_social_insurance, -- 参与社保企业数（需要单独统计）
    0 AS company_without_social_insurance, -- 未参与社保企业数
    0 AS social_insurance_participation_rate, -- 社保参与率
    0 AS avg_pension_insurance_count, -- 平均养老保险人数
    0 AS total_pension_insurance_count -- 总养老保险人数
FROM company_core LIMIT 1;

-- ========================================
-- 企业变更活动统计
-- ========================================
SELECT
    '企业变更活动统计' AS statistics_category, -- 统计类别
    (SELECT COUNT(*) FROM company_core) AS total_company, -- 企业总数
    (SELECT ROUND(AVG(jyyc_count), 2) FROM company_jyyc) AS avg_abnormal_operation_records, -- 平均经营异常记录数
    (SELECT ROUND(AVG(yzwf_count), 2) FROM company_yzwf) AS avg_serious_violation_records, -- 平均严重违法记录数
    (SELECT ROUND(AVG(gqbg_count), 2) FROM company_gqbg) AS avg_equity_change_records, -- 平均股权变更记录数
    (SELECT ROUND(AVG(sxr_count), 2) FROM company_sxr) AS avg_dishonest_execution_records, -- 平均失信执行记录数
    0 AS avg_guarantee_records, -- 平均担保记录数（需要单独统计）
    (SELECT ROUND(AVG(xzcf_count), 2) FROM company_xzcf) AS avg_penalty_records -- 平均行政处罚记录数
FROM company_core LIMIT 1;

-- ========================================
-- 企业信用状况统计
-- ========================================
SELECT
    '企业信用状况统计' AS statistics_category, -- 统计类别
    (SELECT COUNT(*) FROM company_core) AS total_company, -- 企业总数
    (SELECT COUNT(*) FROM company_xypj WHERE tax_credi_level = 'A') AS grade_a_taxpayers, -- A级纳税人数量
    (SELECT COUNT(*) FROM company_xypj WHERE tax_credi_level = 'B') AS grade_b_taxpayers, -- B级纳税人数量
    (SELECT COUNT(*) FROM company_xypj WHERE tax_credi_level = 'C') AS grade_c_taxpayers, -- C级纳税人数量
    (SELECT COUNT(*) FROM company_xypj WHERE tax_credi_level = 'D') AS grade_d_taxpayers, -- D级纳税人数量
    ROUND((SELECT COUNT(*) FROM company_xypj WHERE tax_credi_level = 'A') * 100.0 / (SELECT COUNT(*) FROM company_core), 2) AS grade_a_rate, -- A级纳税人比例
    0 AS company_with_credit_evaluation, -- 有信用评价企业数（需要单独统计）
    0 AS credit_evaluation_rate -- 信用评价覆盖率（需要单独统计）
FROM company_core LIMIT 1;
