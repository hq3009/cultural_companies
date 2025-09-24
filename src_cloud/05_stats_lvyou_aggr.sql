-- 旅游行业统计分析（聚合版本）
-- 每个查询都可以单独执行，立即看到结果
-- 基于 lvyou 表和各业务领域聚合表


-- ========================================
-- 查看基础数据
-- ========================================
SELECT
    '基础数据' AS statistics_category, -- 统计类别
    COUNT(*) AS total_company, -- 旅游企业总数
    COUNT(DISTINCT indv_nm) AS industry_count, -- 旅游行业种类数量
    COUNT(DISTINCT comp_type) AS company_type_count, -- 企业类型数量
    COUNT(DISTINCT domdi_strict) AS district_count -- 涉及区县数量
FROM lvyou;

-- ========================================
-- 旅游企业家数统计
-- ========================================
SELECT
    '旅游企业家数统计' AS statistics_category, -- 统计类别
    (SELECT COUNT(*) FROM lvyou) AS total_company, -- 旅游企业总数
    0 AS changed_company, -- 变更企业数
    (SELECT COUNT(*) FROM company_jyyc jyyc
     JOIN lvyou l ON jyyc.uni_social_crd_cd = l.uni_social_crd_cd) AS abnormal_operation_company, -- 经营异常企业数
    (SELECT COUNT(*) FROM company_yzwf yzwf
     JOIN lvyou l ON yzwf.uni_social_crd_cd = l.uni_social_crd_cd) AS serious_violation_company, -- 严重违法失信企业数
    (SELECT COUNT(*) FROM company_sxr sxr
     JOIN lvyou l ON sxr.uni_social_crd_cd = l.uni_social_crd_cd) AS dishonest_executed_company, -- 失信被执行人企业数
    0 AS tech_small_company, -- 科技型小微企业数（需要单独统计）
    (SELECT COUNT(*) FROM company_xypj xypj
     JOIN lvyou l ON xypj.uni_social_crd_cd = l.uni_social_crd_cd
     WHERE xypj.tax_credi_level = 'A') AS grade_a_taxpayer_company, -- A级纳税人企业数
    (SELECT COUNT(*) FROM company_wzwd wzwd
     JOIN lvyou l ON wzwd.uni_social_crd_cd = l.uni_social_crd_cd) AS company_with_website, -- 有网站网店企业数
    (SELECT COUNT(*) FROM company_xzcf xzcf
     JOIN lvyou l ON xzcf.uni_social_crd_cd = l.uni_social_crd_cd) AS company_with_penalty, -- 有行政处罚企业数
    (SELECT COUNT(*) FROM company_gqbg gqbg
     JOIN lvyou l ON gqbg.uni_social_crd_cd = l.uni_social_crd_cd) AS company_with_equity_change, -- 有股权变更企业数
    0 AS company_with_guarantee -- 有对外担保企业数（需要单独统计）
FROM lvyou LIMIT 1;

-- ========================================
-- 旅游企业经营状况统计
-- ========================================
SELECT
    '旅游企业经营状况统计' AS statistics_category, -- 统计类别
    COUNT(l.uni_social_crd_cd) AS total_companies_with_financial_data, -- 有财务数据企业总数
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
FROM lvyou l
LEFT JOIN company_nb nb ON l.uni_social_crd_cd = nb.uni_social_crd_cd
LEFT JOIN company_ns ns ON l.uni_social_crd_cd = ns.uni_social_crd_cd
WHERE nb.asset_zmt IS NOT NULL OR nb.nb_opt_income_total IS NOT NULL OR ns.tax_amt IS NOT NULL;

-- ========================================
-- 旅游行业企业社保参与统计
-- ========================================
SELECT
    '旅游行业社保参与统计' AS statistics_category, -- 统计类别
    (SELECT COUNT(*) FROM lvyou) AS total_company, -- 企业总数
    (SELECT COUNT(*) FROM company_sb_jbxx sb JOIN lvyou l ON sb.uni_social_crd_cd = l.uni_social_crd_cd WHERE sb.pens_num IS NOT NULL) AS company_with_social_insurance, -- 参与社保企业数
    (SELECT COUNT(*) FROM lvyou l LEFT JOIN company_sb_jbxx sb ON l.uni_social_crd_cd = sb.uni_social_crd_cd WHERE sb.pens_num IS NULL) AS company_without_social_insurance, -- 未参与社保企业数
    ROUND((SELECT COUNT(*) FROM company_sb_jbxx sb JOIN lvyou l ON sb.uni_social_crd_cd = l.uni_social_crd_cd WHERE sb.pens_num IS NOT NULL) * 100.0 / (SELECT COUNT(*) FROM lvyou), 2) AS social_insurance_participation_rate, -- 社保参与率
    (SELECT ROUND(AVG(sb.pens_num), 2) FROM company_sb_jbxx sb JOIN lvyou l ON sb.uni_social_crd_cd = l.uni_social_crd_cd) AS avg_pension_insurance_count, -- 平均养老保险人数
    (SELECT ROUND(AVG(sb.medic_num), 2) FROM company_sb_jbxx sb JOIN lvyou l ON sb.uni_social_crd_cd = l.uni_social_crd_cd) AS avg_medical_insurance_count, -- 平均医疗保险人数
    (SELECT ROUND(AVG(sb.unemploy_num), 2) FROM company_sb_jbxx sb JOIN lvyou l ON sb.uni_social_crd_cd = l.uni_social_crd_cd) AS avg_unemployment_insurance_count, -- 平均失业保险人数
    (SELECT ROUND(AVG(sb.injury_num), 2) FROM company_sb_jbxx sb JOIN lvyou l ON sb.uni_social_crd_cd = l.uni_social_crd_cd) AS avg_work_injury_insurance_count, -- 平均工伤保险人数
    (SELECT ROUND(AVG(sb.materni_num), 2) FROM company_sb_jbxx sb JOIN lvyou l ON sb.uni_social_crd_cd = l.uni_social_crd_cd) AS avg_maternity_insurance_count -- 平均生育保险人数
FROM lvyou LIMIT 1;

-- ========================================
-- 旅游企业变更活动统计
-- ========================================
SELECT
    '旅游企业变更活动统计' AS statistics_category, -- 统计类别
    (SELECT COUNT(*) FROM lvyou) AS total_company, -- 企业总数
    (SELECT ROUND(AVG(jyyc.jyyc_count), 2)
     FROM company_jyyc jyyc
     JOIN lvyou l ON jyyc.uni_social_crd_cd = l.uni_social_crd_cd) AS avg_abnormal_operation_records, -- 平均经营异常记录数
    (SELECT ROUND(AVG(yzwf.yzwf_count), 2)
     FROM company_yzwf yzwf
     JOIN lvyou l ON yzwf.uni_social_crd_cd = l.uni_social_crd_cd) AS avg_serious_violation_records, -- 平均严重违法记录数
    (SELECT ROUND(AVG(gqbg.gqbg_count), 2)
     FROM company_gqbg gqbg
     JOIN lvyou l ON gqbg.uni_social_crd_cd = l.uni_social_crd_cd) AS avg_equity_change_records, -- 平均股权变更记录数
    (SELECT ROUND(AVG(sxr.sxr_count), 2)
     FROM company_sxr sxr
     JOIN lvyou l ON sxr.uni_social_crd_cd = l.uni_social_crd_cd) AS avg_dishonest_execution_records, -- 平均失信执行记录数
    0 AS avg_guarantee_records, -- 平均担保记录数（需要单独统计）
    (SELECT ROUND(AVG(xzcf.xzcf_count), 2)
     FROM company_xzcf xzcf
     JOIN lvyou l ON xzcf.uni_social_crd_cd = l.uni_social_crd_cd) AS avg_penalty_records -- 平均行政处罚记录数
FROM lvyou LIMIT 1;

-- ========================================
-- 旅游企业信用状况统计
-- ========================================
SELECT
    '旅游企业信用状况统计' AS statistics_category, -- 统计类别
    (SELECT COUNT(*) FROM lvyou) AS total_company, -- 企业总数
    (SELECT COUNT(*) FROM company_xypj xypj
     JOIN lvyou l ON xypj.uni_social_crd_cd = l.uni_social_crd_cd
     WHERE xypj.tax_credi_level = 'A') AS grade_a_taxpayers, -- A级纳税人数量
    (SELECT COUNT(*) FROM company_xypj xypj
     JOIN lvyou l ON xypj.uni_social_crd_cd = l.uni_social_crd_cd
     WHERE xypj.tax_credi_level = 'B') AS grade_b_taxpayers, -- B级纳税人数量
    (SELECT COUNT(*) FROM company_xypj xypj
     JOIN lvyou l ON xypj.uni_social_crd_cd = l.uni_social_crd_cd
     WHERE xypj.tax_credi_level = 'C') AS grade_c_taxpayers, -- C级纳税人数量
    (SELECT COUNT(*) FROM company_xypj xypj
     JOIN lvyou l ON xypj.uni_social_crd_cd = l.uni_social_crd_cd
     WHERE xypj.tax_credi_level = 'D') AS grade_d_taxpayers, -- D级纳税人数量
    ROUND((SELECT COUNT(*) FROM company_xypj xypj
            JOIN lvyou l ON xypj.uni_social_crd_cd = l.uni_social_crd_cd
            WHERE xypj.tax_credi_level = 'A') * 100.0 / (SELECT COUNT(*) FROM lvyou), 2) AS grade_a_rate, -- A级纳税人比例
    0 AS company_with_credit_evaluation, -- 有信用评价企业数（需要单独统计）
    0 AS credit_evaluation_rate -- 信用评价覆盖率（需要单独统计）
FROM lvyou LIMIT 1;

-- ========================================
-- 旅游企业成立时间分布统计
-- ========================================
SELECT
    '旅游企业成立时间分布' AS statistics_category, -- 统计类别
    COUNT(CASE WHEN est_dt >= '2020-01-01' THEN 1 END) AS company_after_2020, -- 2020年后成立企业数
    COUNT(CASE WHEN est_dt >= '2015-01-01' AND est_dt < '2020-01-01' THEN 1 END) AS company_2015_2019, -- 2015-2019年成立企业数
    COUNT(CASE WHEN est_dt >= '2010-01-01' AND est_dt < '2015-01-01' THEN 1 END) AS company_2010_2014, -- 2010-2014年成立企业数
    COUNT(CASE WHEN est_dt < '2010-01-01' THEN 1 END) AS company_before_2010, -- 2010年前成立企业数
    ROUND(COUNT(CASE WHEN est_dt >= '2020-01-01' THEN 1 END) * 100.0 / COUNT(*), 2) AS percentage_after_2020, -- 2020年后占比
    ROUND(COUNT(CASE WHEN est_dt >= '2015-01-01' AND est_dt < '2020-01-01' THEN 1 END) * 100.0 / COUNT(*), 2) AS percentage_2015_2019, -- 2015-2019年占比
    ROUND(COUNT(CASE WHEN est_dt >= '2010-01-01' AND est_dt < '2015-01-01' THEN 1 END) * 100.0 / COUNT(*), 2) AS percentage_2010_2014, -- 2010-2014年占比
    ROUND(COUNT(CASE WHEN est_dt < '2010-01-01' THEN 1 END) * 100.0 / COUNT(*), 2) AS percentage_before_2010 -- 2010年前占比
FROM lvyou;

-- ========================================
-- 旅游行业分布统计
-- ========================================
SELECT
    '旅游行业分布统计' AS statistics_category, -- 统计类别
    indv_nm, -- 行业代码
    COUNT(*) AS company_count, -- 企业数量
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM lvyou), 2) AS percentage -- 占比
FROM lvyou
GROUP BY indv_nm
ORDER BY company_count DESC;
