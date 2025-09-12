-- 统计分析（分步执行）
-- 每个查询都可以单独执行，立即看到结果

-- ========================================
-- 查看基础数据
-- ========================================
SELECT
    COUNT(*) AS total_enterprises, -- 企业总数
    COUNT(DISTINCT INDV_NM) AS industry_count, -- 行业种类数量
    COUNT(DISTINCT COMP_TYPE) AS company_type_count, -- 企业类型数量
FROM enterprises_extended;

-- ========================================
-- 企业家数统计
-- ========================================
SELECT
    '企业家数统计' AS statistics_category, -- 统计类别
    COUNT(*) AS total_enterprises, -- 企业总数
    0 AS changed_enterprises, -- 变更企业数
    SUM(CASE WHEN INCLU_REASON IS NOT NULL THEN 1 ELSE 0 END) AS abnormal_operation_enterprises, -- 经营异常企业数
    SUM(CASE WHEN SERILL_REA IS NOT NULL THEN 1 ELSE 0 END) AS serious_violation_enterprises, -- 严重违法失信企业数
    SUM(CASE WHEN EXECUTED_COURT IS NOT NULL THEN 1 ELSE 0 END) AS dishonest_executed_enterprises, -- 失信被执行人企业数
    SUM(CASE WHEN CONGNIZ_ORG IS NOT NULL THEN 1 ELSE 0 END) AS tech_small_enterprises, -- 科技型小微企业数
    SUM(CASE WHEN TAX_CREDI_LEVEL = 'A' THEN 1 ELSE 0 END) AS grade_a_taxpayer_enterprises, -- A级纳税人企业数
    SUM(CASE WHEN WEB_STORE_NM IS NOT NULL THEN 1 ELSE 0 END) AS enterprises_with_website, -- 有网站网店企业数
    SUM(CASE WHEN ADMIN_PUNISH_DOC IS NOT NULL THEN 1 ELSE 0 END) AS enterprises_with_penalty, -- 有行政处罚企业数
    SUM(CASE WHEN ALT_DT IS NOT NULL THEN 1 ELSE 0 END) AS enterprises_with_equity_change, -- 有股权变更企业数
    SUM(CASE WHEN CREDITOR IS NOT NULL THEN 1 ELSE 0 END) AS enterprises_with_guarantee -- 有对外担保企业数
FROM enterprises_extended;

-- ========================================
-- 经营状况统计
-- ========================================
SELECT
    '经营状况统计' AS statistics_category, -- 统计类别
    COUNT(*) AS enterprises_with_financial_data, -- 有财务数据企业数
    ROUND(AVG(ASSET_ZMT), 2) AS avg_total_assets, -- 平均资产总额
    ROUND(SUM(ASSET_ZMT), 2) AS total_assets, -- 总资产总额
    ROUND(AVG(OPT_INCOME_TOTAL), 2) AS avg_operating_income, -- 平均营业收入
    ROUND(SUM(OPT_INCOME_TOTAL), 2) AS total_operating_income, -- 总营业收入
    ROUND(AVG(PROFIT_TOTAL), 2) AS avg_total_profit, -- 平均利润总额
    ROUND(SUM(PROFIT_TOTAL), 2) AS total_profit, -- 总利润总额
    ROUND(AVG(NET_PROFIT), 2) AS avg_net_profit, -- 平均净利润
    ROUND(SUM(NET_PROFIT), 2) AS total_net_profit, -- 总净利润
    ROUND(AVG(TAX_TOTAL), 2) AS avg_total_tax, -- 平均纳税总额
    ROUND(SUM(TAX_TOTAL), 2) AS total_tax -- 总纳税总额
FROM enterprises_extended
WHERE ASSET_ZMT IS NOT NULL OR OPT_INCOME_TOTAL IS NOT NULL;

-- ========================================
-- 社保参与统计
-- ========================================
SELECT
    '社保参与统计' AS statistics_category, -- 统计类别
    COUNT(*) AS total_enterprises, -- 企业总数
    COUNT(CASE WHEN PENS_NUM IS NOT NULL THEN 1 END) AS enterprises_with_social_insurance, -- 参与社保企业数
    COUNT(CASE WHEN PENS_NUM IS NULL THEN 1 END) AS enterprises_without_social_insurance, -- 未参与社保企业数
    ROUND(COUNT(CASE WHEN PENS_NUM IS NOT NULL THEN 1 END) * 100.0 / COUNT(*), 2) AS social_insurance_participation_rate, -- 社保参与率
    ROUND(AVG(PENS_NUM), 2) AS avg_pension_insurance_count, -- 平均养老保险人数
    ROUND(AVG(MEDIC_NUM), 2) AS avg_medical_insurance_count, -- 平均医疗保险人数
    ROUND(AVG(UNEMPLOY_NUM), 2) AS avg_unemployment_insurance_count, -- 平均失业保险人数
    ROUND(AVG(INJURY_NUM), 2) AS avg_work_injury_insurance_count, -- 平均工伤保险人数
    ROUND(AVG(MATERNI_NUM), 2) AS avg_maternity_insurance_count -- 平均生育保险人数
FROM enterprises_extended
