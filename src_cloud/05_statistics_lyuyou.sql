-- Step3：旅游行业统计分析（云服务器版本）
-- 基于Step2的extended_enterprises表，提取旅游行业企业进行统计分析
-- 旅游行业代码：0141, 0143, 0149, 0151, 0152, 0153, 0154, 0159, 0412, 1784, 1922, 2441, 2442, 2449, 2461, 2462, 2469, 3733, 3780, 5211, 5212, 5213, 5219, 5221, 5222, 5223, 5224, 5225, 5226, 5227, 5229, 5231, 5232, 5233, 5234, 5235, 5236, 5237, 5238, 5239, 5242, 5261, 5262, 5263, 5264, 5265, 5266, 5267, 5311, 5312, 5313, 5331, 5333, 5339, 5411, 5412, 5413, 5414, 5419, 5421, 5422, 5429, 5441, 5442, 5443, 5449, 5511, 5512, 5513, 5531, 5539, 5611, 5631, 5632, 5639, 5822, 5910, 6110, 6121, 6129, 6130, 6140, 6190, 6210, 6220, 6231, 6232, 6233, 6239, 6241, 6291, 6432, 6434, 6439, 6440, 6450, 6621, 6623, 6624, 6629, 6634, 6635, 6636, 6637, 6639, 6813, 6814, 6820, 6999, 7111, 7115, 7119, 7122, 7129, 7130, 7215, 7219, 7222, 7223, 7224, 7229, 7271, 7272, 7291, 7294, 7297, 7299, 7861, 7862, 7869, 8051, 8052, 8053, 8336, 8341, 8342, 8391, 8412, 8413, 8414, 8415, 8416, 8511, 8512, 8921, 8929, 8930, 8930, 9221, 9222, 9522, 9542

-- 创建旅游行业企业子表
DROP TABLE IF EXISTS lyuyou_enterprises;

CREATE TABLE lyuyou_enterprises AS
SELECT * FROM extended_enterprises
WHERE INDV_NM IN (
    '0141', '0143', '0149', '0151', '0152', '0153', '0154', '0159',
    '0412', '1784', '1922', '2441', '2442', '2449', '2461', '2462',
    '2469', '3733', '3780', '5211', '5212', '5213', '5219', '5221',
    '5222', '5223', '5224', '5225', '5226', '5227', '5229', '5231',
    '5232', '5233', '5234', '5235', '5236', '5237', '5238', '5239',
    '5242', '5261', '5262', '5263', '5264', '5265', '5266', '5267',
    '5311', '5312', '5313', '5331', '5333', '5339', '5411', '5412',
    '5413', '5414', '5419', '5421', '5422', '5429', '5441', '5442',
    '5443', '5449', '5511', '5512', '5513', '5531', '5539', '5611',
    '5631', '5632', '5639', '5822', '5910', '6110', '6121', '6129',
    '6130', '6140', '6190', '6210', '6220', '6231', '6232', '6233',
    '6239', '6241', '6291', '6432', '6434', '6439', '6440', '6450',
    '6621', '6623', '6624', '6629', '6634', '6635', '6636', '6637',
    '6639', '6813', '6814', '6820', '6999', '7111', '7115', '7119',
    '7122', '7129', '7130', '7215', '7219', '7222', '7223', '7224',
    '7229', '7271', '7272', '7291', '7294', '7297', '7299', '7861',
    '7862', '7869', '8051', '8052', '8053', '8336', '8341', '8342',
    '8391', '8412', '8413', '8414', '8415', '8416', '8511', '8512',
    '8921', '8929', '8930', '8930', '9221', '9222', '9522', '9542'
);

-- 显示旅游行业企业数量
SELECT
    COUNT(*) AS lyuyou_enterprise_count,
    COUNT(DISTINCT INDV_NM) AS unique_industry_codes,
    COUNT(DISTINCT COMP_TYPE) AS unique_company_types,
    COUNT(DISTINCT DOMDI_STRICT) AS unique_districts
FROM lyuyou_enterprises;

-- ========================================
-- 旅游行业统计分析
-- ========================================

WITH base_data AS (
    SELECT * FROM lyuyou_enterprises
),

-- 1. 旅游行业企业数量统计
lyuyou_count_stats AS (
    SELECT
        INDV_NM AS industry_code,
        COMP_TYPE AS company_type,
        DOMDI_STRICT AS domicile_district_code,
        OPT_STRICT AS business_district_code,
        COUNT(*) AS enterprise_count,
        -- 新业态数量（2020年后成立的企业）
        SUM(CASE WHEN EST_DT >= '2020-01-01' THEN 1 ELSE 0 END) AS new_format_count,
        -- 报告期内的变更企业数（2023年后变更）
        SUM(CASE WHEN ci.CHAN_DT IS NOT NULL AND ci.CHAN_DT >= '2023-01-01' THEN 1 ELSE 0 END) AS changed_count,
        -- 经营异常企业数
        SUM(CASE WHEN ba.INCLU_REASON IS NOT NULL THEN 1 ELSE 0 END) AS abnormal_count,
        -- 严重违法失信企业数
        SUM(CASE WHEN sv.SERILL_REA IS NOT NULL THEN 1 ELSE 0 END) AS serious_violation_count,
        -- 失信被执行人企业数
        SUM(CASE WHEN dp.EXECUTE_COURT IS NOT NULL THEN 1 ELSE 0 END) AS dishonest_person_count,
        -- 科技型小微企业数
        SUM(CASE WHEN tse.CONGNIZ_ORG IS NOT NULL THEN 1 ELSE 0 END) AS tech_small_enterprise_count,
        -- A级纳税人企业数
        SUM(CASE WHEN gat.TAX_CREDI_LEVEL = 'A' THEN 1 ELSE 0 END) AS grade_a_taxpayer_count,
        -- 有网站或网店的企业数
        SUM(CASE WHEN ws.WEB_STORE_NM IS NOT NULL THEN 1 ELSE 0 END) AS website_shop_count,
        -- 有行政处罚的企业数
        SUM(CASE WHEN ap.ADMIN_PUNISH_DOC IS NOT NULL THEN 1 ELSE 0 END) AS penalty_count,
        -- 有行政许可的企业数
        SUM(CASE WHEN al.LIC_NO IS NOT NULL THEN 1 ELSE 0 END) AS license_count,
        -- 有股权变更的企业数
        SUM(CASE WHEN ec.ALT_DT IS NOT NULL THEN 1 ELSE 0 END) AS equity_change_count,
        -- 有对外担保的企业数
        SUM(CASE WHEN gi.EXTERNAL_GUA IS NOT NULL THEN 1 ELSE 0 END) AS external_guarantee_count
    FROM base_data
    GROUP BY INDV_NM, COMP_TYPE, DOMDI_STRICT, OPT_STRICT
),

-- 2. 旅游行业经营状况统计
lyuyou_business_stats AS (
    SELECT
        INDV_NM AS industry_code,
        COMP_TYPE AS company_type,
        DOMDI_STRICT AS domicile_district_code,
        OPT_STRICT AS business_district_code,
        -- 资产总额统计
        AVG(ara.ASSET_ZMT) AS avg_total_assets,
        SUM(ara.ASSET_ZMT) AS sum_total_assets,
        MAX(ara.ASSET_ZMT) AS max_total_assets,
        MIN(ara.ASSET_ZMT) AS min_total_assets,
        -- 负债总额统计
        AVG(ara.DEBT_AMT) AS avg_total_liabilities,
        SUM(ara.DEBT_AMT) AS sum_total_liabilities,
        MAX(ara.DEBT_AMT) AS max_total_liabilities,
        MIN(ara.DEBT_AMT) AS min_total_liabilities,
        -- 所有者权益统计
        AVG(ara.OWNER_EQUITY_TOATAL) AS avg_owner_equity,
        SUM(ara.OWNER_EQUITY_TOATAL) AS sum_owner_equity,
        MAX(ara.OWNER_EQUITY_TOATAL) AS max_owner_equity,
        MIN(ara.OWNER_EQUITY_TOATAL) AS min_owner_equity,
        -- 营业总收入统计
        AVG(ara.OPT_INCOME_TOTAL) AS avg_total_revenue,
        SUM(ara.OPT_INCOME_TOTAL) AS sum_total_revenue,
        MAX(ara.OPT_INCOME_TOTAL) AS max_total_revenue,
        MIN(ara.OPT_INCOME_TOTAL) AS min_total_revenue,
        -- 利润总额统计
        AVG(ara.PROFIT_TOTAL) AS avg_total_profit,
        SUM(ara.PROFIT_TOTAL) AS sum_total_profit,
        MAX(ara.PROFIT_TOTAL) AS max_total_profit,
        MIN(ara.PROFIT_TOTAL) AS min_total_profit,
        -- 净利润统计
        AVG(ara.NET_PROFIT) AS avg_net_profit,
        SUM(ara.NET_PROFIT) AS sum_net_profit,
        MAX(ara.NET_PROFIT) AS max_net_profit,
        MIN(ara.NET_PROFIT) AS min_net_profit,
        -- 纳税总额统计
        AVG(ara.TAX_TOTAL) AS avg_total_tax,
        SUM(ara.TAX_TOTAL) AS sum_total_tax,
        MAX(ara.TAX_TOTAL) AS max_total_tax,
        MIN(ara.TAX_TOTAL) AS min_total_tax,
        -- 纳税信息统计
        AVG(ti.PAID_AMT) AS avg_total_tax_amount,
        SUM(ti.PAID_AMT) AS sum_total_tax_amount
    FROM base_data
    WHERE ara.ASSET_ZMT IS NOT NULL OR ara.OPT_INCOME_TOTAL IS NOT NULL OR ti.PAID_AMT IS NOT NULL
    GROUP BY INDV_NM, COMP_TYPE, DOMDI_STRICT, OPT_STRICT
),

-- 3. 旅游行业社保就业统计
lyuyou_social_security_stats AS (
    SELECT
        INDV_NM AS industry_code,
        COMP_TYPE AS company_type,
        DOMDI_STRICT AS domicile_district_code,
        OPT_STRICT AS business_district_code,
        -- 缴纳社保企业数量
        SUM(CASE WHEN ssd.ISSU_TYPE IS NOT NULL OR ssd.PAY_MONTHS > 0 THEN 1 ELSE 0 END) AS social_security_enterprise_count,
        -- 未缴纳社保企业数量
        SUM(CASE WHEN (ssd.ISSU_TYPE IS NULL OR ssd.ISSU_TYPE = '')
                  AND (ssd.PAY_MONTHS IS NULL OR ssd.PAY_MONTHS = 0) THEN 1 ELSE 0 END) AS no_social_security_enterprise_count,
        -- 社保缴费统计
        AVG(ssd.PAY_MONTHS) AS avg_payment_months,
        SUM(ssd.PAY_MONTHS) AS total_payment_months,
        AVG(ssd.PER_PAY_BASIS) AS avg_personal_payment_base,
        SUM(ssd.PER_PAY_BASIS) AS sum_personal_payment_base,
        AVG(ssd.PAY_AMT) AS avg_payment_amount,
        SUM(ssd.PAY_AMT) AS sum_payment_amount,
        AVG(ssd.UNIT_PAY_AMT) AS avg_corporate_payment_amount,
        SUM(ssd.UNIT_PAY_AMT) AS sum_corporate_payment_amount,
        AVG(ssd.PER_PAY_AMT) AS avg_personal_payment_amount,
        SUM(ssd.PER_PAY_AMT) AS sum_personal_payment_amount,
        -- 社保人数统计
        AVG(ss.PENS_NUM) AS avg_pension_count,
        SUM(ss.PENS_NUM) AS sum_pension_count,
        AVG(ss.MEDIC_NUM) AS avg_medical_count,
        SUM(ss.MEDIC_NUM) AS sum_medical_count,
        AVG(ss.UNEMPLOY_NUM) AS avg_unemployment_count,
        SUM(ss.UNEMPLOY_NUM) AS sum_unemployment_count,
        AVG(ss.INJURY_NUM) AS avg_injury_count,
        SUM(ss.INJURY_NUM) AS sum_injury_count,
        AVG(ss.MATERNI_NUM) AS avg_maternity_count,
        SUM(ss.MATERNI_NUM) AS sum_maternity_count
    FROM base_data
    GROUP BY INDV_NM, COMP_TYPE, DOMDI_STRICT, OPT_STRICT
),

-- 4. 旅游行业综合统计视图
lyuyou_comprehensive_stats AS (
    SELECT
        lcs.industry_code,
        lcs.company_type,
        lcs.domicile_district_code,
        lcs.business_district_code,
        -- 企业数量统计
        lcs.enterprise_count,
        lcs.new_format_count,
        lcs.changed_count,
        lcs.abnormal_count,
        lcs.serious_violation_count,
        lcs.dishonest_person_count,
        lcs.tech_small_enterprise_count,
        lcs.grade_a_taxpayer_count,
        lcs.website_shop_count,
        lcs.penalty_count,
        lcs.license_count,
        lcs.equity_change_count,
        lcs.external_guarantee_count,
        -- 经营状况统计
        lbs.avg_total_assets,
        lbs.sum_total_assets,
        lbs.max_total_assets,
        lbs.min_total_assets,
        lbs.avg_total_liabilities,
        lbs.sum_total_liabilities,
        lbs.max_total_liabilities,
        lbs.min_total_liabilities,
        lbs.avg_owner_equity,
        lbs.sum_owner_equity,
        lbs.max_owner_equity,
        lbs.min_owner_equity,
        lbs.avg_total_revenue,
        lbs.sum_total_revenue,
        lbs.max_total_revenue,
        lbs.min_total_revenue,
        lbs.avg_total_profit,
        lbs.sum_total_profit,
        lbs.max_total_profit,
        lbs.min_total_profit,
        lbs.avg_net_profit,
        lbs.sum_net_profit,
        lbs.max_net_profit,
        lbs.min_net_profit,
        lbs.avg_total_tax,
        lbs.sum_total_tax,
        lbs.max_total_tax,
        lbs.min_total_tax,
        lbs.avg_total_tax_amount,
        lbs.sum_total_tax_amount,
        -- 社保就业统计
        lsss.social_security_enterprise_count,
        lsss.no_social_security_enterprise_count,
        lsss.avg_payment_months,
        lsss.total_payment_months,
        lsss.avg_personal_payment_base,
        lsss.sum_personal_payment_base,
        lsss.avg_payment_amount,
        lsss.sum_payment_amount,
        lsss.avg_corporate_payment_amount,
        lsss.sum_corporate_payment_amount,
        lsss.avg_personal_payment_amount,
        lsss.sum_personal_payment_amount,
        lsss.avg_pension_count,
        lsss.sum_pension_count,
        lsss.avg_medical_count,
        lsss.sum_medical_count,
        lsss.avg_unemployment_count,
        lsss.sum_unemployment_count,
        lsss.avg_injury_count,
        lsss.sum_injury_count,
        lsss.avg_maternity_count,
        lsss.sum_maternity_count,
        -- 计算比率
        CASE WHEN lcs.enterprise_count > 0 THEN
            ROUND(lcs.new_format_count * 100.0 / lcs.enterprise_count, 2)
        ELSE 0 END AS new_format_ratio,
        CASE WHEN lcs.enterprise_count > 0 THEN
            ROUND(lcs.abnormal_count * 100.0 / lcs.enterprise_count, 2)
        ELSE 0 END AS abnormal_ratio,
        CASE WHEN lcs.enterprise_count > 0 THEN
            ROUND(lcs.serious_violation_count * 100.0 / lcs.enterprise_count, 2)
        ELSE 0 END AS serious_violation_ratio,
        CASE WHEN lcs.enterprise_count > 0 THEN
            ROUND(lcs.dishonest_person_count * 100.0 / lcs.enterprise_count, 2)
        ELSE 0 END AS dishonest_person_ratio,
        CASE WHEN lcs.enterprise_count > 0 THEN
            ROUND(lcs.tech_small_enterprise_count * 100.0 / lcs.enterprise_count, 2)
        ELSE 0 END AS tech_small_enterprise_ratio,
        CASE WHEN lcs.enterprise_count > 0 THEN
            ROUND(lcs.grade_a_taxpayer_count * 100.0 / lcs.enterprise_count, 2)
        ELSE 0 END AS grade_a_taxpayer_ratio,
        CASE WHEN lcs.enterprise_count > 0 THEN
            ROUND(lcs.website_shop_count * 100.0 / lcs.enterprise_count, 2)
        ELSE 0 END AS website_shop_ratio,
        CASE WHEN lcs.enterprise_count > 0 THEN
            ROUND(lcs.penalty_count * 100.0 / lcs.enterprise_count, 2)
        ELSE 0 END AS penalty_ratio,
        CASE WHEN lcs.enterprise_count > 0 THEN
            ROUND(lcs.license_count * 100.0 / lcs.enterprise_count, 2)
        ELSE 0 END AS license_ratio,
        CASE WHEN (lsss.social_security_enterprise_count + lsss.no_social_security_enterprise_count) > 0 THEN
            ROUND(lsss.social_security_enterprise_count * 100.0 / (lsss.social_security_enterprise_count + lsss.no_social_security_enterprise_count), 2)
        ELSE 0 END AS social_security_ratio
    FROM lyuyou_count_stats lcs
    LEFT JOIN lyuyou_business_stats lbs ON lcs.industry_code = lbs.industry_code
        AND lcs.company_type = lbs.company_type
        AND lcs.domicile_district_code = lbs.domicile_district_code
        AND lcs.business_district_code = lbs.business_district_code
    LEFT JOIN lyuyou_social_security_stats lsss ON lcs.industry_code = lsss.industry_code
        AND lcs.company_type = lsss.company_type
        AND lcs.domicile_district_code = lsss.domicile_district_code
        AND lcs.business_district_code = lsss.business_district_code
)

-- 查询1：旅游行业详细统计结果（按企业数量排序）
SELECT * FROM lyuyou_comprehensive_stats
ORDER BY enterprise_count DESC;

-- ========================================
-- 查询2：旅游行业总体汇总统计
-- ========================================
SELECT
    '旅游行业总体汇总' AS category,
    COUNT(*) AS total_enterprise_count,
    SUM(new_format_count) AS total_new_format_count,
    SUM(changed_count) AS total_changed_count,
    SUM(abnormal_count) AS total_abnormal_count,
    SUM(serious_violation_count) AS total_serious_violation_count,
    SUM(dishonest_person_count) AS total_dishonest_person_count,
    SUM(tech_small_enterprise_count) AS total_tech_small_enterprise_count,
    SUM(grade_a_taxpayer_count) AS total_grade_a_taxpayer_count,
    SUM(website_shop_count) AS total_website_shop_count,
    SUM(penalty_count) AS total_penalty_count,
    SUM(license_count) AS total_license_count,
    SUM(equity_change_count) AS total_equity_change_count,
    SUM(external_guarantee_count) AS total_external_guarantee_count,
    SUM(sum_total_assets) AS total_assets_sum,
    SUM(sum_total_revenue) AS total_revenue_sum,
    SUM(sum_total_profit) AS total_profit_sum,
    SUM(sum_net_profit) AS total_net_profit_sum,
    SUM(sum_total_tax) AS total_tax_sum,
    SUM(sum_total_tax_amount) AS total_tax_amount_sum,
    SUM(social_security_enterprise_count) AS total_social_security_enterprise_count,
    SUM(no_social_security_enterprise_count) AS total_no_social_security_enterprise_count,
    SUM(total_payment_months) AS total_payment_months_sum,
    SUM(sum_payment_amount) AS total_payment_amount_sum,
    SUM(sum_corporate_payment_amount) AS total_corporate_payment_amount_sum,
    SUM(sum_personal_payment_amount) AS total_personal_payment_amount_sum,
    SUM(sum_pension_count) AS total_pension_count_sum,
    SUM(sum_medical_count) AS total_medical_count_sum,
    SUM(sum_unemployment_count) AS total_unemployment_count_sum,
    SUM(sum_injury_count) AS total_injury_count_sum,
    SUM(sum_maternity_count) AS total_maternity_count_sum,
    ROUND(AVG(new_format_ratio), 2) AS avg_new_format_ratio,
    ROUND(AVG(abnormal_ratio), 2) AS avg_abnormal_ratio,
    ROUND(AVG(serious_violation_ratio), 2) AS avg_serious_violation_ratio,
    ROUND(AVG(dishonest_person_ratio), 2) AS avg_dishonest_person_ratio,
    ROUND(AVG(tech_small_enterprise_ratio), 2) AS avg_tech_small_enterprise_ratio,
    ROUND(AVG(grade_a_taxpayer_ratio), 2) AS avg_grade_a_taxpayer_ratio,
    ROUND(AVG(website_shop_ratio), 2) AS avg_website_shop_ratio,
    ROUND(AVG(penalty_ratio), 2) AS avg_penalty_ratio,
    ROUND(AVG(license_ratio), 2) AS avg_license_ratio,
    ROUND(AVG(social_security_ratio), 2) AS avg_social_security_ratio
FROM lyuyou_comprehensive_stats;

-- ========================================
-- 查询3：旅游行业按企业类型统计
-- ========================================
SELECT
    company_type,
    COUNT(*) AS enterprise_count,
    SUM(new_format_count) AS new_format_count,
    SUM(abnormal_count) AS abnormal_count,
    SUM(serious_violation_count) AS serious_violation_count,
    SUM(dishonest_person_count) AS dishonest_person_count,
    SUM(tech_small_enterprise_count) AS tech_small_enterprise_count,
    SUM(grade_a_taxpayer_count) AS grade_a_taxpayer_count,
    SUM(website_shop_count) AS website_shop_count,
    SUM(penalty_count) AS penalty_count,
    SUM(license_count) AS license_count,
    SUM(sum_total_assets) AS total_assets_sum,
    SUM(sum_total_revenue) AS total_revenue_sum,
    SUM(sum_total_profit) AS total_profit_sum,
    SUM(sum_net_profit) AS total_net_profit_sum,
    SUM(sum_total_tax) AS total_tax_sum,
    SUM(social_security_enterprise_count) AS social_security_enterprise_count,
    SUM(no_social_security_enterprise_count) AS no_social_security_enterprise_count,
    ROUND(AVG(new_format_ratio), 2) AS avg_new_format_ratio,
    ROUND(AVG(abnormal_ratio), 2) AS avg_abnormal_ratio,
    ROUND(AVG(serious_violation_ratio), 2) AS avg_serious_violation_ratio,
    ROUND(AVG(dishonest_person_ratio), 2) AS avg_dishonest_person_ratio,
    ROUND(AVG(tech_small_enterprise_ratio), 2) AS avg_tech_small_enterprise_ratio,
    ROUND(AVG(grade_a_taxpayer_ratio), 2) AS avg_grade_a_taxpayer_ratio,
    ROUND(AVG(website_shop_ratio), 2) AS avg_website_shop_ratio,
    ROUND(AVG(penalty_ratio), 2) AS avg_penalty_ratio,
    ROUND(AVG(license_ratio), 2) AS avg_license_ratio,
    ROUND(AVG(social_security_ratio), 2) AS avg_social_security_ratio
FROM lyuyou_comprehensive_stats
GROUP BY company_type
ORDER BY enterprise_count DESC;

-- ========================================
-- 查询4：旅游行业按区县统计
-- ========================================
SELECT
    domicile_district_code,
    COUNT(*) AS enterprise_count,
    SUM(new_format_count) AS new_format_count,
    SUM(abnormal_count) AS abnormal_count,
    SUM(serious_violation_count) AS serious_violation_count,
    SUM(dishonest_person_count) AS dishonest_person_count,
    SUM(tech_small_enterprise_count) AS tech_small_enterprise_count,
    SUM(grade_a_taxpayer_count) AS grade_a_taxpayer_count,
    SUM(website_shop_count) AS website_shop_count,
    SUM(penalty_count) AS penalty_count,
    SUM(license_count) AS license_count,
    SUM(sum_total_assets) AS total_assets_sum,
    SUM(sum_total_revenue) AS total_revenue_sum,
    SUM(sum_total_profit) AS total_profit_sum,
    SUM(sum_net_profit) AS total_net_profit_sum,
    SUM(sum_total_tax) AS total_tax_sum,
    SUM(social_security_enterprise_count) AS social_security_enterprise_count,
    SUM(no_social_security_enterprise_count) AS no_social_security_enterprise_count,
    ROUND(AVG(new_format_ratio), 2) AS avg_new_format_ratio,
    ROUND(AVG(abnormal_ratio), 2) AS avg_abnormal_ratio,
    ROUND(AVG(serious_violation_ratio), 2) AS avg_serious_violation_ratio,
    ROUND(AVG(dishonest_person_ratio), 2) AS avg_dishonest_person_ratio,
    ROUND(AVG(tech_small_enterprise_ratio), 2) AS avg_tech_small_enterprise_ratio,
    ROUND(AVG(grade_a_taxpayer_ratio), 2) AS avg_grade_a_taxpayer_ratio,
    ROUND(AVG(website_shop_ratio), 2) AS avg_website_shop_ratio,
    ROUND(AVG(penalty_ratio), 2) AS avg_penalty_ratio,
    ROUND(AVG(license_ratio), 2) AS avg_license_ratio,
    ROUND(AVG(social_security_ratio), 2) AS avg_social_security_ratio
FROM lyuyou_comprehensive_stats
GROUP BY domicile_district_code
ORDER BY enterprise_count DESC;

-- ========================================
-- 查询5：旅游行业经营状况排名（按资产总额）
-- ========================================
SELECT
    industry_code,
    company_type,
    domicile_district_code,
    enterprise_count,
    sum_total_assets,
    avg_total_assets,
    sum_total_revenue,
    avg_total_revenue,
    sum_total_profit,
    avg_total_profit,
    sum_net_profit,
    avg_net_profit,
    sum_total_tax,
    avg_total_tax,
    ROUND(sum_total_profit / NULLIF(sum_total_revenue, 0) * 100, 2) AS profit_margin_percent,
    ROUND(sum_net_profit / NULLIF(sum_total_revenue, 0) * 100, 2) AS net_profit_margin_percent,
    ROUND(sum_total_tax / NULLIF(sum_total_revenue, 0) * 100, 2) AS tax_rate_percent
FROM lyuyou_comprehensive_stats
WHERE sum_total_assets IS NOT NULL AND sum_total_assets > 0
ORDER BY sum_total_assets DESC
LIMIT 20;

-- ========================================
-- 查询6：旅游行业风险企业分析
-- ========================================
SELECT
    industry_code,
    company_type,
    domicile_district_code,
    enterprise_count,
    abnormal_count,
    serious_violation_count,
    dishonest_person_count,
    penalty_count,
    ROUND(abnormal_count * 100.0 / enterprise_count, 2) AS abnormal_ratio,
    ROUND(serious_violation_count * 100.0 / enterprise_count, 2) AS serious_violation_ratio,
    ROUND(dishonest_person_count * 100.0 / enterprise_count, 2) AS dishonest_person_ratio,
    ROUND(penalty_count * 100.0 / enterprise_count, 2) AS penalty_ratio,
    ROUND((abnormal_count + serious_violation_count + dishonest_person_count + penalty_count) * 100.0 / enterprise_count, 2) AS total_risk_ratio
FROM lyuyou_comprehensive_stats
WHERE enterprise_count > 0
ORDER BY total_risk_ratio DESC;

-- ========================================
-- 查询7：旅游行业社保参与度分析
-- ========================================
SELECT
    industry_code,
    company_type,
    domicile_district_code,
    enterprise_count,
    social_security_enterprise_count,
    no_social_security_enterprise_count,
    ROUND(social_security_enterprise_count * 100.0 / enterprise_count, 2) AS social_security_participation_rate,
    avg_payment_months,
    avg_payment_amount,
    avg_corporate_payment_amount,
    avg_personal_payment_amount,
    avg_pension_count,
    avg_medical_count,
    avg_unemployment_count,
    avg_injury_count,
    avg_maternity_count
FROM lyuyou_comprehensive_stats
WHERE enterprise_count > 0
ORDER BY social_security_participation_rate DESC;

-- ========================================
-- 查询8：旅游行业代码分布统计
-- ========================================
SELECT
    industry_code,
    COUNT(*) AS enterprise_count,
    SUM(new_format_count) AS new_format_count,
    SUM(abnormal_count) AS abnormal_count,
    SUM(serious_violation_count) AS serious_violation_count,
    SUM(dishonest_person_count) AS dishonest_person_count,
    SUM(tech_small_enterprise_count) AS tech_small_enterprise_count,
    SUM(grade_a_taxpayer_count) AS grade_a_taxpayer_count,
    SUM(website_shop_count) AS website_shop_count,
    SUM(penalty_count) AS penalty_count,
    SUM(license_count) AS license_count,
    SUM(sum_total_assets) AS total_assets_sum,
    SUM(sum_total_revenue) AS total_revenue_sum,
    SUM(sum_total_profit) AS total_profit_sum,
    SUM(sum_net_profit) AS total_net_profit_sum,
    SUM(sum_total_tax) AS total_tax_sum,
    SUM(social_security_enterprise_count) AS social_security_enterprise_count,
    SUM(no_social_security_enterprise_count) AS no_social_security_enterprise_count,
    ROUND(AVG(new_format_ratio), 2) AS avg_new_format_ratio,
    ROUND(AVG(abnormal_ratio), 2) AS avg_abnormal_ratio,
    ROUND(AVG(serious_violation_ratio), 2) AS avg_serious_violation_ratio,
    ROUND(AVG(dishonest_person_ratio), 2) AS avg_dishonest_person_ratio,
    ROUND(AVG(tech_small_enterprise_ratio), 2) AS avg_tech_small_enterprise_ratio,
    ROUND(AVG(grade_a_taxpayer_ratio), 2) AS avg_grade_a_taxpayer_ratio,
    ROUND(AVG(website_shop_ratio), 2) AS avg_website_shop_ratio,
    ROUND(AVG(penalty_ratio), 2) AS avg_penalty_ratio,
    ROUND(AVG(license_ratio), 2) AS avg_license_ratio,
    ROUND(AVG(social_security_ratio), 2) AS avg_social_security_ratio
FROM lyuyou_comprehensive_stats
GROUP BY industry_code
ORDER BY enterprise_count DESC;
