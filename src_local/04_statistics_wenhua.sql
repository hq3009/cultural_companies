-- 文化行业统计分析（分步执行版本）
-- 每个查询都可以单独执行，立即看到结果

DROP TABLE IF EXISTS wenhua_enterprises;

-- 创建文化行业企业子表
CREATE TABLE wenhua_enterprises AS
SELECT * FROM enterprises_extended
WHERE INDV_NM IN (
    -- 文化行业代码列表
    '2221', '2222', '2311', '2312', '2319', '2320', '2330', '2411', '2412', '2414',
    '2421', '2422', '2423', '2429', '2431', '2432', '2433', '2434', '2435', '2436',
    '2437', '2438', '2439', '2451', '2452', '2453', '2454', '2455', '2456', '2459',
    '2461', '2462', '2469', '2642', '2644', '2664', '2672', '3075', '3076', '3471',
    '3472', '3474', '3542', '3873', '3931', '3932', '3933', '3934', '3939', '3951',
    '3952', '3953', '3961', '3963', '3969', '5137', '5141', '5143', '5144', '5145',
    '5146', '5147', '5149', '5175', '5178', '5181', '5183', '5184', '5241', '5243',
    '5244', '5245', '5246', '5247', '5248', '5249', '5271', '6319', '6321', '6322',
    '6331', '6421', '6422', '6429', '6513', '6572', '6579', '7124', '7125', '7211',
    '7212', '7221', '7251', '7259', '7281', '7282', '7283', '7284', '7289', '7350',
    '7484', '7491', '7492', '7520', '7861', '7862', '7869', '8070', '8393', '8399',
    '8610', '8621', '8622', '8623', '8624', '8625', '8626', '8629', '8710', '8720',
    '8730', '8740', '8750', '8760', '8770', '8831', '8832', '8870', '8890', '9013',
    '9051', '9053', '9059', '9521'
);

-- ========================================
-- 文化行业企业基础数据
-- ========================================
SELECT
    '基础数据' AS statistics_category, -- 统计类别
    COUNT(*) AS total_enterprises, -- 文化企业总数
    COUNT(DISTINCT INDV_NM) AS industry_count, -- 文化行业种类数量
    COUNT(DISTINCT COMP_TYPE) AS company_type_count, -- 企业类型数量
    COUNT(DISTINCT DOMDI_STRICT) AS district_count -- 涉及区县数量
FROM wenhua_enterprises;

-- ========================================
-- 文化行业企业家数统计
-- ========================================
SELECT
    '文化企业家数统计' AS statistics_category, -- 统计类别
    COUNT(*) AS total_enterprises, -- 文化企业总数
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
FROM wenhua_enterprises;

-- ========================================
-- 文化行业企业经营状况统计
-- ========================================
SELECT
    '文化企业经营状况统计' AS statistics_category, -- 统计类别
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
FROM wenhua_enterprises
WHERE ASSET_ZMT IS NOT NULL OR OPT_INCOME_TOTAL IS NOT NULL;

-- ========================================
-- 文化行业企业社保参与统计
-- ========================================
SELECT
    '文化行业社保参与统计' AS statistics_category, -- 统计类别
    COUNT(*) AS total_enterprises, -- 企业总数
    COUNT(CASE WHEN sb.PENS_NUM IS NOT NULL THEN 1 END) AS enterprises_with_social_insurance, -- 参与社保企业数
    COUNT(CASE WHEN sb.PENS_NUM IS NULL THEN 1 END) AS enterprises_without_social_insurance, -- 未参与社保企业数
    ROUND(COUNT(CASE WHEN sb.PENS_NUM IS NOT NULL THEN 1 END) * 100.0 / COUNT(*), 2) AS social_insurance_participation_rate, -- 社保参与率
    ROUND(AVG(sb.PENS_NUM), 2) AS avg_pension_insurance_count, -- 平均养老保险人数
    ROUND(AVG(sb.MEDIC_NUM), 2) AS avg_medical_insurance_count, -- 平均医疗保险人数
    ROUND(AVG(sb.UNEMPLOY_NUM), 2) AS avg_unemployment_insurance_count, -- 平均失业保险人数
    ROUND(AVG(sb.INJURY_NUM), 2) AS avg_work_injury_insurance_count, -- 平均工伤保险人数
    ROUND(AVG(sb.MATERNI_NUM), 2) AS avg_maternity_insurance_count -- 平均生育保险人数
FROM wenhua_enterprises e
LEFT JOIN DW_NB_RLSB_SBJYLYSHBXJBXX sb ON e.UNI_SOCIAL_CRD_CD = sb.UNI_SOCIAL_CRD_CD;

-- ========================================
-- 文化行业企业成立时间分布统计
-- ========================================
SELECT
    '文化企业成立时间分布' AS statistics_category, -- 统计类别
    COUNT(CASE WHEN EST_DT >= '2020-01-01' THEN 1 END) AS enterprises_after_2020, -- 2020年后成立企业数
    COUNT(CASE WHEN EST_DT >= '2015-01-01' AND EST_DT < '2020-01-01' THEN 1 END) AS enterprises_2015_2019, -- 2015-2019年成立企业数
    COUNT(CASE WHEN EST_DT >= '2010-01-01' AND EST_DT < '2015-01-01' THEN 1 END) AS enterprises_2010_2014, -- 2010-2014年成立企业数
    COUNT(CASE WHEN EST_DT < '2010-01-01' THEN 1 END) AS enterprises_before_2010, -- 2010年前成立企业数
    ROUND(COUNT(CASE WHEN EST_DT >= '2020-01-01' THEN 1 END) * 100.0 / COUNT(*), 2) AS percentage_after_2020, -- 2020年后占比
    ROUND(COUNT(CASE WHEN EST_DT >= '2015-01-01' AND EST_DT < '2020-01-01' THEN 1 END) * 100.0 / COUNT(*), 2) AS percentage_2015_2019, -- 2015-2019年占比
    ROUND(COUNT(CASE WHEN EST_DT >= '2010-01-01' AND EST_DT < '2015-01-01' THEN 1 END) * 100.0 / COUNT(*), 2) AS percentage_2010_2014, -- 2010-2014年占比
    ROUND(COUNT(CASE WHEN EST_DT < '2010-01-01' THEN 1 END) * 100.0 / COUNT(*), 2) AS percentage_before_2010 -- 2010年前占比
FROM wenhua_enterprises;
