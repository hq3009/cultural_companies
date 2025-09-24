-- 文化产业统计分析（分步执行）
-- 每个查询都可以单独执行，立即看到结果
-- 基于 wenhua 表（文化产业企业表）

-- ========================================
-- 查看基础数据
-- ========================================
SELECT
    COUNT(*) AS total_company, -- 文化企业总数
    COUNT(DISTINCT indv_nm) AS industry_count, -- 文化行业种类数量
    COUNT(DISTINCT comp_type) AS company_type_count, -- 企业类型数量
    COUNT(DISTINCT domdi_strict) AS district_count -- 涉及区县数量
FROM wenhua;

-- ========================================
-- 文化企业家数统计
-- ========================================
SELECT
    '文化企业家数统计' AS statistics_category, -- 统计类别
    (SELECT COUNT(*) FROM wenhua) AS total_company, -- 文化企业总数
    0 AS changed_company, -- 变更企业数
    (SELECT COUNT(*) FROM company_jyyc jyyc
     JOIN wenhua w ON jyyc.uni_social_crd_cd = w.uni_social_crd_cd) AS abnormal_operation_company, -- 经营异常企业数
    (SELECT COUNT(*) FROM company_yzwf yzwf
     JOIN wenhua w ON yzwf.uni_social_crd_cd = w.uni_social_crd_cd) AS serious_violation_company, -- 严重违法失信企业数
    (SELECT COUNT(*) FROM company_sxr sxr
     JOIN wenhua w ON sxr.uni_social_crd_cd = w.uni_social_crd_cd) AS dishonest_executed_company, -- 失信被执行人企业数
    0 AS tech_small_company, -- 科技型小微企业数（需要单独统计）
    (SELECT COUNT(*) FROM company_xypj xypj
     JOIN wenhua w ON xypj.uni_social_crd_cd = w.uni_social_crd_cd
     WHERE xypj.tax_credi_level = 'A') AS grade_a_taxpayer_company, -- A级纳税人企业数
    (SELECT COUNT(*) FROM company_wzwd wzwd
     JOIN wenhua w ON wzwd.uni_social_crd_cd = w.uni_social_crd_cd) AS company_with_website, -- 有网站网店企业数
    (SELECT COUNT(*) FROM company_xzcf xzcf
     JOIN wenhua w ON xzcf.uni_social_crd_cd = w.uni_social_crd_cd) AS company_with_penalty, -- 有行政处罚企业数
    (SELECT COUNT(*) FROM company_gqbg gqbg
     JOIN wenhua w ON gqbg.uni_social_crd_cd = w.uni_social_crd_cd) AS company_with_equity_change, -- 有股权变更企业数
    0 AS company_with_guarantee -- 有对外担保企业数（需要单独统计）
FROM wenhua LIMIT 1;

-- ========================================
-- 文化企业经营状况统计
-- ========================================
SELECT
    '文化企业经营状况统计' AS statistics_category, -- 统计类别
    COUNT(*) AS company_with_financial_data, -- 有财务数据企业数
    ROUND(AVG(nb.asset_zmt), 2) AS avg_total_assets, -- 平均资产总额
    ROUND(SUM(nb.asset_zmt), 2) AS total_assets, -- 总资产总额
    ROUND(AVG(nb.nb_opt_income_total), 2) AS avg_operating_income, -- 平均营业收入
    ROUND(SUM(nb.nb_opt_income_total), 2) AS total_operating_income, -- 总营业收入
    ROUND(AVG(nb.nb_net_profit), 2) AS avg_net_profit, -- 平均净利润
    ROUND(SUM(nb.nb_net_profit), 2) AS total_net_profit, -- 总净利润
    ROUND(AVG(nb.nb_tax_total), 2) AS avg_total_tax, -- 平均纳税总额
    ROUND(SUM(nb.nb_tax_total), 2) AS total_tax, -- 总纳税总额
    ROUND(AVG(ns.tax_amt), 2) AS avg_tax_amount, -- 平均纳税金额
    ROUND(SUM(ns.tax_amt), 2) AS total_tax_amount -- 总纳税金额
FROM wenhua w
LEFT JOIN company_nb nb ON w.uni_social_crd_cd = nb.uni_social_crd_cd
LEFT JOIN company_ns ns ON w.uni_social_crd_cd = ns.uni_social_crd_cd
WHERE nb.asset_zmt IS NOT NULL OR nb.nb_opt_income_total IS NOT NULL;

-- ========================================
-- 文化企业社保参与统计
-- ========================================
SELECT
    '文化企业社保参与统计' AS statistics_category, -- 统计类别
    (SELECT COUNT(*) FROM wenhua) AS total_company, -- 企业总数
    0 AS company_with_social_insurance, -- 参与社保企业数（需要单独统计）
    0 AS company_without_social_insurance, -- 未参与社保企业数
    0 AS social_insurance_participation_rate, -- 社保参与率
    0 AS avg_pension_insurance_count, -- 平均养老保险人数
    0 AS total_pension_insurance_count -- 总养老保险人数
FROM wenhua LIMIT 1;

-- ========================================
-- 文化企业变更活动统计
-- ========================================
SELECT
    '文化企业变更活动统计' AS statistics_category, -- 统计类别
    (SELECT COUNT(*) FROM wenhua) AS total_company, -- 企业总数
    (SELECT ROUND(AVG(jyyc.jyyc_count), 2)
     FROM company_jyyc jyyc
     JOIN wenhua w ON jyyc.uni_social_crd_cd = w.uni_social_crd_cd) AS avg_abnormal_operation_records, -- 平均经营异常记录数
    (SELECT ROUND(AVG(yzwf.yzwf_count), 2)
     FROM company_yzwf yzwf
     JOIN wenhua w ON yzwf.uni_social_crd_cd = w.uni_social_crd_cd) AS avg_serious_violation_records, -- 平均严重违法记录数
    (SELECT ROUND(AVG(gqbg.gqbg_count), 2)
     FROM company_gqbg gqbg
     JOIN wenhua w ON gqbg.uni_social_crd_cd = w.uni_social_crd_cd) AS avg_equity_change_records, -- 平均股权变更记录数
    (SELECT ROUND(AVG(sxr.sxr_count), 2)
     FROM company_sxr sxr
     JOIN wenhua w ON sxr.uni_social_crd_cd = w.uni_social_crd_cd) AS avg_dishonest_execution_records, -- 平均失信执行记录数
    0 AS avg_guarantee_records, -- 平均担保记录数（需要单独统计）
    (SELECT ROUND(AVG(xzcf.xzcf_count), 2)
     FROM company_xzcf xzcf
     JOIN wenhua w ON xzcf.uni_social_crd_cd = w.uni_social_crd_cd) AS avg_penalty_records -- 平均行政处罚记录数
FROM wenhua LIMIT 1;

-- ========================================
-- 文化企业信用状况统计
-- ========================================
SELECT
    '文化企业信用状况统计' AS statistics_category, -- 统计类别
    (SELECT COUNT(*) FROM wenhua) AS total_company, -- 企业总数
    (SELECT COUNT(*) FROM company_xypj xypj
     JOIN wenhua w ON xypj.uni_social_crd_cd = w.uni_social_crd_cd
     WHERE xypj.tax_credi_level = 'A') AS grade_a_taxpayers, -- A级纳税人数量
    (SELECT COUNT(*) FROM company_xypj xypj
     JOIN wenhua w ON xypj.uni_social_crd_cd = w.uni_social_crd_cd
     WHERE xypj.tax_credi_level = 'B') AS grade_b_taxpayers, -- B级纳税人数量
    (SELECT COUNT(*) FROM company_xypj xypj
     JOIN wenhua w ON xypj.uni_social_crd_cd = w.uni_social_crd_cd
     WHERE xypj.tax_credi_level = 'C') AS grade_c_taxpayers, -- C级纳税人数量
    (SELECT COUNT(*) FROM company_xypj xypj
     JOIN wenhua w ON xypj.uni_social_crd_cd = w.uni_social_crd_cd
     WHERE xypj.tax_credi_level = 'D') AS grade_d_taxpayers, -- D级纳税人数量
    ROUND((SELECT COUNT(*) FROM company_xypj xypj
            JOIN wenhua w ON xypj.uni_social_crd_cd = w.uni_social_crd_cd
            WHERE xypj.tax_credi_level = 'A') * 100.0 / (SELECT COUNT(*) FROM wenhua), 2) AS grade_a_rate, -- A级纳税人比例
    0 AS company_with_credit_evaluation, -- 有信用评价企业数（需要单独统计）
    0 AS credit_evaluation_rate -- 信用评价覆盖率（需要单独统计）
FROM wenhua LIMIT 1;

-- ========================================
-- 文化企业成立时间分布统计
-- ========================================
SELECT
    '文化企业成立时间分布' AS statistics_category, -- 统计类别
    COUNT(CASE WHEN est_dt >= '2020-01-01' THEN 1 END) AS company_after_2020, -- 2020年后成立企业数
    COUNT(CASE WHEN est_dt >= '2015-01-01' AND est_dt < '2020-01-01' THEN 1 END) AS company_2015_2019, -- 2015-2019年成立企业数
    COUNT(CASE WHEN est_dt >= '2010-01-01' AND est_dt < '2015-01-01' THEN 1 END) AS company_2010_2014, -- 2010-2014年成立企业数
    COUNT(CASE WHEN est_dt < '2010-01-01' THEN 1 END) AS company_before_2010, -- 2010年前成立企业数
    ROUND(COUNT(CASE WHEN est_dt >= '2020-01-01' THEN 1 END) * 100.0 / COUNT(*), 2) AS percentage_after_2020, -- 2020年后占比
    ROUND(COUNT(CASE WHEN est_dt >= '2015-01-01' AND est_dt < '2020-01-01' THEN 1 END) * 100.0 / COUNT(*), 2) AS percentage_2015_2019, -- 2015-2019年占比
    ROUND(COUNT(CASE WHEN est_dt >= '2010-01-01' AND est_dt < '2015-01-01' THEN 1 END) * 100.0 / COUNT(*), 2) AS percentage_2010_2014, -- 2010-2014年占比
    ROUND(COUNT(CASE WHEN est_dt < '2010-01-01' THEN 1 END) * 100.0 / COUNT(*), 2) AS percentage_before_2010 -- 2010年前占比
FROM wenhua;

-- ========================================
-- 文化企业行业分布统计
-- ========================================
SELECT
    '文化企业行业分布' AS statistics_category, -- 统计类别
    COUNT(*) AS total_company, -- 企业总数
    COUNT(CASE WHEN indv_nm LIKE '22%' THEN 1 END) AS news_publishing_company, -- 新闻出版企业数
    COUNT(CASE WHEN indv_nm LIKE '23%' THEN 1 END) AS broadcasting_company, -- 广播电视企业数
    COUNT(CASE WHEN indv_nm LIKE '24%' THEN 1 END) AS cultural_creation_company, -- 文化创作企业数
    COUNT(CASE WHEN indv_nm LIKE '51%' THEN 1 END) AS software_company, -- 软件企业数
    COUNT(CASE WHEN indv_nm LIKE '52%' THEN 1 END) AS internet_company, -- 互联网企业数
    COUNT(CASE WHEN indv_nm LIKE '71%' THEN 1 END) AS research_company, -- 研发企业数
    COUNT(CASE WHEN indv_nm LIKE '72%' THEN 1 END) AS professional_service_company, -- 专业服务企业数
    COUNT(CASE WHEN indv_nm LIKE '86%' THEN 1 END) AS education_company, -- 教育企业数
    COUNT(CASE WHEN indv_nm LIKE '87%' THEN 1 END) AS health_company, -- 卫生企业数
    COUNT(CASE WHEN indv_nm LIKE '88%' THEN 1 END) AS sports_company, -- 体育企业数
    COUNT(CASE WHEN indv_nm LIKE '90%' THEN 1 END) AS entertainment_company -- 娱乐企业数
FROM wenhua;