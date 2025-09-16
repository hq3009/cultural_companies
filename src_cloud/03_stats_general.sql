-- 统计分析（分步执行）
-- 每个查询都可以单独执行，立即看到结果
-- 基于 enterprises_extended_window 表（窗口函数优化版本）

-- ========================================
-- 查看基础数据
-- ========================================
SELECT
    COUNT(*) AS total_enterprises, -- 企业总数
    COUNT(DISTINCT INDV_NM) AS industry_count, -- 行业种类数量
    COUNT(DISTINCT COMP_TYPE) AS company_type_count, -- 企业类型数量
FROM enterprises_extended_window;

-- ========================================
-- 企业家数统计
-- ========================================
SELECT
    '企业家数统计' AS statistics_category, -- 统计类别
    COUNT(*) AS total_enterprises, -- 企业总数
    0 AS changed_enterprises, -- 变更企业数
    SUM(CASE WHEN JYYC_LATEST_REASON IS NOT NULL THEN 1 ELSE 0 END) AS abnormal_operation_enterprises, -- 经营异常企业数
    SUM(CASE WHEN LATEST_SERILL_REA IS NOT NULL THEN 1 ELSE 0 END) AS serious_violation_enterprises, -- 严重违法失信企业数
    SUM(CASE WHEN LATEST_EXECUTED_COURT IS NOT NULL THEN 1 ELSE 0 END) AS dishonest_executed_enterprises, -- 失信被执行人企业数
    SUM(CASE WHEN KJZX_CONGNIZ_ORG IS NOT NULL THEN 1 ELSE 0 END) AS tech_small_enterprises, -- 科技型小微企业数
    SUM(CASE WHEN TAX_CREDI_LEVEL = 'A' THEN 1 ELSE 0 END) AS grade_a_taxpayer_enterprises, -- A级纳税人企业数
    SUM(CASE WHEN WEB_STORE_URL IS NOT NULL THEN 1 ELSE 0 END) AS enterprises_with_website, -- 有网站网店企业数
    SUM(CASE WHEN LATEST_PUNISH_DOC IS NOT NULL THEN 1 ELSE 0 END) AS enterprises_with_penalty, -- 有行政处罚企业数
    SUM(CASE WHEN LATEST_GQBG_DT IS NOT NULL THEN 1 ELSE 0 END) AS enterprises_with_equity_change, -- 有股权变更企业数
    SUM(CASE WHEN LATEST_CREDITOR IS NOT NULL THEN 1 ELSE 0 END) AS enterprises_with_guarantee -- 有对外担保企业数
FROM enterprises_extended_window;

-- ========================================
-- 经营状况统计
-- ========================================
SELECT
    '经营状况统计' AS statistics_category, -- 统计类别
    COUNT(*) AS enterprises_with_financial_data, -- 有财务数据企业数
    ROUND(AVG(ASSET_ZMT), 2) AS avg_total_assets, -- 平均资产总额
    ROUND(SUM(ASSET_ZMT), 2) AS total_assets, -- 总资产总额
    ROUND(AVG(ASSET_SALE_INCO), 2) AS avg_operating_income, -- 平均营业收入
    ROUND(SUM(ASSET_SALE_INCO), 2) AS total_operating_income, -- 总营业收入
    ROUND(AVG(NET_PROFIT), 2) AS avg_net_profit, -- 平均净利润
    ROUND(SUM(NET_PROFIT), 2) AS total_net_profit, -- 总净利润
    ROUND(AVG(TAX_TOTAL), 2) AS avg_total_tax, -- 平均纳税总额
    ROUND(SUM(TAX_TOTAL), 2) AS total_tax, -- 总纳税总额
    ROUND(AVG(TAX_AMT), 2) AS avg_tax_amount, -- 平均纳税金额
    ROUND(SUM(TAX_AMT), 2) AS total_tax_amount -- 总纳税金额
FROM enterprises_extended_window
WHERE ASSET_ZMT IS NOT NULL OR ASSET_SALE_INCO IS NOT NULL;

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
    ROUND(SUM(PENS_NUM), 2) AS total_pension_insurance_count -- 总养老保险人数
FROM enterprises_extended_window;

-- ========================================
-- 企业变更活动统计
-- ========================================
SELECT
    '企业变更活动统计' AS statistics_category, -- 统计类别
    COUNT(*) AS total_enterprises, -- 企业总数
    ROUND(AVG(FDDB_COUNT), 2) AS avg_legal_representative_changes, -- 平均法定代表人变更次数
    ROUND(AVG(JYYC_COUNT), 2) AS avg_abnormal_operation_records, -- 平均经营异常记录数
    ROUND(AVG(SXQY_COUNT), 2) AS avg_serious_violation_records, -- 平均严重违法记录数
    ROUND(AVG(GQBG_COUNT), 2) AS avg_equity_change_records, -- 平均股权变更记录数
    ROUND(AVG(SXR_COUNT), 2) AS avg_dishonest_execution_records, -- 平均失信执行记录数
    ROUND(AVG(DB_COUNT), 2) AS avg_guarantee_records, -- 平均担保记录数
    ROUND(AVG(XZCF_COUNT), 2) AS avg_penalty_records -- 平均行政处罚记录数
FROM enterprises_extended_window;

-- ========================================
-- 企业信用状况统计
-- ========================================
SELECT
    '企业信用状况统计' AS statistics_category, -- 统计类别
    COUNT(*) AS total_enterprises, -- 企业总数
    COUNT(CASE WHEN TAX_CREDI_LEVEL = 'A' THEN 1 END) AS grade_a_taxpayers, -- A级纳税人数量
    COUNT(CASE WHEN TAX_CREDI_LEVEL = 'B' THEN 1 END) AS grade_b_taxpayers, -- B级纳税人数量
    COUNT(CASE WHEN TAX_CREDI_LEVEL = 'C' THEN 1 END) AS grade_c_taxpayers, -- C级纳税人数量
    COUNT(CASE WHEN TAX_CREDI_LEVEL = 'D' THEN 1 END) AS grade_d_taxpayers, -- D级纳税人数量
    ROUND(COUNT(CASE WHEN TAX_CREDI_LEVEL = 'A' THEN 1 END) * 100.0 / COUNT(*), 2) AS grade_a_rate, -- A级纳税人比例
    COUNT(CASE WHEN XYPJ_CRED_SCARD IS NOT NULL THEN 1 END) AS enterprises_with_credit_evaluation, -- 有信用评价企业数
    ROUND(COUNT(CASE WHEN XYPJ_CRED_SCARD IS NOT NULL THEN 1 END) * 100.0 / COUNT(*), 2) AS credit_evaluation_rate -- 信用评价覆盖率
FROM enterprises_extended_window;
