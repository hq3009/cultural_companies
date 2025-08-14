-- Step2：增加文旅企业信息维度（云服务器版本）
-- 将多个维度的企业信息合并到Step1的结果中
-- 基于Step1的dw_zj_scjdgl_scztxx表进行扩展，硬编码行业代码

WITH base_cultural_tourism AS (
    -- 从Step1的结果开始，直接使用step1的查询结果
    SELECT
        UNI_SOCIAL_CRD_CD AS social_credit_code,      -- 统一社会信用代码
        COMP_NM AS company_name,                      -- 企业名称
        REG_ORG AS reg_authority,                     -- 登记机关
        COMP_TYPE AS company_type,                    -- 企业类型
        ADDR AS reg_address,                              -- 地址
        LEGAL_REPRE AS legal_repre,                     -- 法定代表人
        INDV_NM AS industry_code,                     -- 行业代码
        OPT_SCOP AS business_scope,                   -- 经营范围
        APPR_DT AS approval_date,                     -- 核准日期
        EST_DT AS establishment_date,                 -- 成立日期
        DOMDI_STRICT AS domicile_district_code,                 -- 所在区县
        OPT_STRICT AS business_district_code                 -- 区县市
    FROM dw_zj_scjdgl_scztxx
    WHERE UNI_SOCIAL_CRD_CD IS NOT NULL
      AND INDV_NM IN (
        -- 文旅行业代码列表（硬编码）
        '0141', '0143', '0149', '0151', '0152', '0153', '0154', '0159',
        '0412', '1784', '1922', '2221', '2222', '2311', '2312', '2319',
        '2320', '2330', '2411', '2412', '2414', '2421', '2422', '2423',
        '2429', '2431', '2432', '2433', '2434', '2435', '2436', '2437',
        '2438', '2439', '2441', '2442', '2449', '2451', '2452', '2453',
        '2454', '2455', '2456', '2459', '2461', '2462', '2469', '2642',
        '2644', '2664', '2672', '3075', '3076', '3471', '3472', '3473',
        '3474', '3542', '3733', '3780', '3873', '3931', '3932', '3933',
        '3934', '3939', '3951', '3952', '3953', '3961', '3963', '3969',
        '5137', '5141', '5143', '5144', '5145', '5146', '5147', '5149',
        '5175', '5178', '5181', '5183', '5184', '5211', '5212', '5213',
        '5219', '5221', '5222', '5223', '5224', '5225', '5226', '5227',
        '5229', '5231', '5232', '5233', '5234', '5235', '5236', '5237',
        '5238', '5239', '5241', '5242', '5243', '5244', '5245', '5246',
        '5247', '5248', '5249', '5261', '5262', '5263', '5264', '5265',
        '5266', '5267', '5271', '5311', '5312', '5313', '5331', '5333',
        '5339', '5411', '5412', '5413', '5414', '5419', '5421', '5422',
        '5429', '5441', '5442', '5443', '5449', '5511', '5512', '5513',
        '5531', '5539', '5611', '5622', '5631', '5632', '5639', '5822',
        '5910', '6110', '6121', '6129', '6130', '6140', '6190', '6210',
        '6220', '6231', '6232', '6233', '6239', '6241', '6291', '6319',
        '6321', '6322', '6331', '6421', '6422', '6429', '6432', '6434',
        '6439', '6440', '6450', '6513', '6572', '6579', '6621', '6623',
        '6624', '6629', '6634', '6635', '6636', '6637', '6639', '6813',
        '6814', '6820', '6999', '7111', '7115', '7119', '7121', '7122',
        '7123', '7124', '7125', '7129', '7130', '7211', '7212', '7215',
        '7219', '7221', '7222', '7223', '7224', '7229', '7251', '7259',
        '7271', '7272', '7281', '7282', '7283', '7284', '7289', '7291',
        '7294', '7297', '7298', '7299', '7350', '7484', '7491', '7492',
        '7520', '7711', '7712', '7713', '7714', '7715', '7716', '7719',
        '7850', '7861', '7862', '7869', '8051', '8052', '8053', '8060',
        '8070', '8336', '8341', '8342', '8391', '8393', '8399', '8412',
        '8413', '8414', '8415', '8416', '8511', '8512', '8610', '8621',
        '8622', '8623', '8624', '8625', '8626', '8629', '8710', '8720',
        '8730', '8740', '8750', '8760', '8770', '8810', '8820', '8831',
        '8832', '8840', '8850', '8860', '8870', '8890', '8921', '8929',
        '8930', '9011', '9012', '9013', '9019', '9020', '9030', '9051',
        '9053', '9059', '9090', '9221', '9222', '9521', '9522', '9542'
      )
      AND (
        -- 经营范围关键词筛选（硬编码）
        OPT_SCOP LIKE '%文化%' OR
        OPT_SCOP LIKE '%多媒体%' OR
        OPT_SCOP LIKE '%游戏%' OR
        OPT_SCOP LIKE '%动漫%' OR
        OPT_SCOP LIKE '%数字出版%' OR
        OPT_SCOP LIKE '%建筑设计%' OR
        OPT_SCOP LIKE '%舞台%' OR
        OPT_SCOP LIKE '%婚庆%' OR
        OPT_SCOP LIKE '%娱乐%' OR
        OPT_SCOP LIKE '%版权%' OR
        OPT_SCOP LIKE '%会议%' OR
        OPT_SCOP LIKE '%展览%' OR
        OPT_SCOP LIKE '%广告%' OR
        OPT_SCOP LIKE '%工艺美术%' OR
        OPT_SCOP LIKE '%旅游%' OR
        OPT_SCOP LIKE '%出行%' OR
        OPT_SCOP LIKE '%游客%' OR
        OPT_SCOP LIKE '%观光%' OR
        OPT_SCOP LIKE '%游览%' OR
        OPT_SCOP LIKE '%旅行%' OR
        OPT_SCOP LIKE '%体育%' OR
        OPT_SCOP LIKE '%休闲%' OR
        OPT_SCOP LIKE '%公共交通%' OR
        OPT_SCOP LIKE '%健康%' OR
        OPT_SCOP LIKE '%休养%' OR
        OPT_SCOP LIKE '%会展%' OR
        OPT_SCOP LIKE '%翻译%' OR
        OPT_SCOP LIKE '%健身%' OR
        OPT_SCOP LIKE '%保健%' OR
        OPT_SCOP LIKE '%酒店%'
      )
),

-- 2. 法定代表人详细信息（从DW_ZJ_SCJDGL_FDDBRXX表）
legal_rep_info AS (
    SELECT
        UNI_SOCIAL_CRD_CD AS social_credit_code,
        NM AS legal_rep_name,
        CER_NO AS id_card_number,
        TEL_NUM AS fixed_phone,
        MOBTEL AS mobile_phone,
        EMAIL AS email,
        POSITION_CN AS position_title
    FROM DW_ZJ_SCJDGL_FDDBRXX
    WHERE UNI_SOCIAL_CRD_CD IS NOT NULL
      AND LEREP_SIGN = 1  -- 法定代表人标志
),

-- 3. 经营异常名录信息（从DW_ZJ_SCJDGL_JYYCMLXX表）
business_abnormal AS (
    SELECT
        UNI_SOCIAL_CRD_CD AS social_credit_code,
        CASE WHEN INCLU_REASON IS NOT NULL THEN 1 ELSE 0 END AS has_business_abnormal,
        INCLU_REASON AS abnormal_reason,
        INCLU_DT AS include_date,
        REMEXCPRES_CN AS removal_reason,
        REMOVE_DT AS removal_date
    FROM DW_ZJ_SCJDGL_JYYCMLXX
    WHERE UNI_SOCIAL_CRD_CD IS NOT NULL
),

-- 4. 严重违法失信企业名单信息（从DW_ZJ_SCJDGL_YZWFSX表）
serious_violation AS (
    SELECT
        UNI_SOCIAL_CRD_CD AS social_credit_code,
        CASE WHEN SERILL_REA IS NOT NULL THEN 1 ELSE 0 END AS has_serious_violation,
        SERILL_REA AS violation_reason,
        ABN_TM AS include_date,
        REM_EXCPRES_REA AS removal_reason,
        REM_DT AS removal_date
    FROM DW_ZJ_SCJDGL_YZWFSX
    WHERE UNI_SOCIAL_CRD_CD IS NOT NULL
),

-- 5. 网站网店信息（从DW_NB_SCJDGL_QYNBWZHWDXX表）
website_shop AS (
    SELECT
        UNI_SOCIAL_CRD_CD AS social_credit_code,
        CASE WHEN WEB_ID IS NOT NULL THEN 1 ELSE 0 END AS has_website_shop,
        WEB_STORE_NM AS website_shop_name,
        WEB_STORE_URL AS website_shop_url,
        WEB_STORE_TYPE AS website_type,
        ECOM_TYPE AS ecommerce_type
    FROM DW_NB_SCJDGL_QYNBWZHWDXX
    WHERE UNI_SOCIAL_CRD_CD IS NOT NULL
),

-- 6. 股权变更信息（从DW_NB_SCJDGL_GQBG表）
equity_change AS (
    SELECT
        UNI_SOCIAL_CRD_CD AS social_credit_code,
        CASE WHEN ALT_DT IS NOT NULL THEN 1 ELSE 0 END AS has_equity_change,
        ALT_DT AS change_date,
        INV AS investor_name,
        TRANSAMPR_BF AS equity_before,
        TRANSAMPR_AF AS equity_after
    FROM DW_NB_SCJDGL_GQBG
    WHERE UNI_SOCIAL_CRD_CD IS NOT NULL
),

-- 7. 企业年报资产信息（从DW_NB_SCJDGL_QYNBZCXX表）
annual_report_assets AS (
    SELECT
        UNI_SOCIAL_CRD_CD AS social_credit_code,
        ANNUAL_YEAR AS report_year,
        ASSET_ZMT AS total_assets,
        DEBT_AMT AS total_liabilities,
        OWNER_EQUITY_TOATAL AS owner_equity,
        OPT_INCOME_TOTAL AS total_revenue,
        PROFIT_TOTAL AS total_profit,
        NET_PROFIT AS net_profit,
        TAX_TOTAL AS total_tax
    FROM DW_NB_SCJDGL_QYNBZCXX
    WHERE UNI_SOCIAL_CRD_CD IS NOT NULL
      AND ANNUAL_YEAR IS NOT NULL
),

-- 8. 对外担保信息（从DW_NB_SCJDGL_DWTGBZDBXX表）
guarantee_info AS (
    SELECT
        UNI_SOCIAL_CRD_CD AS social_credit_code,
        CASE WHEN EXTERNAL_GUA IS NOT NULL THEN 1 ELSE 0 END AS has_external_guarantee,
        CREDITOR AS creditor,
        DEBTOR AS debtor,
        MAJOR_CREDIT_AMT AS guarantee_amount,
        PERIOD_FROM AS guarantee_start_date,
        PERIOD_TO AS guarantee_end_date
    FROM DW_NB_SCJDGL_DWTGBZDBXX
    WHERE UNI_SOCIAL_CRD_CD IS NOT NULL
),

-- 9. 科技型小微企业信息（从DW_NB_KJ_SGCZKJXZXQY表）
tech_small_enterprise AS (
    SELECT
        UNI_SOCIAL_CRD_CD AS social_credit_code,
        CASE WHEN CONGNIZ_TEAR IS NOT NULL THEN 1 ELSE 0 END AS is_tech_small_enterprise,
        CONGNIZ_ORG AS recognition_organization,
        CONGNIZ_TEAR AS recognition_year
    FROM DW_NB_KJ_SGCZKJXZXQY
    WHERE UNI_SOCIAL_CRD_CD IS NOT NULL
),

-- 10. 失信被执行人信息（从DW_SHL_QYWLXSXCPXX表）
dishonest_person AS (
    SELECT
        UNI_SOCIAL_CRD_CD AS social_credit_code,
        CASE WHEN EXECUTE_COURT IS NOT NULL THEN 1 ELSE 0 END AS is_dishonest_person,
        EXECUTE_COURT AS execute_court,
        EXECUTE_AMT AS execute_amount,
        NOT_EXECUTE_AMT AS not_execute_amount,
        FILING_DT AS filing_date
    FROM DW_SHL_QYWLXSXCPXX
    WHERE UNI_SOCIAL_CRD_CD IS NOT NULL
),

-- 11. 信用评价信息（从DW_NB_HYWLQYXYDJXX表）
credit_evaluation AS (
    SELECT
        UNI_SOCIAL_CRD_CD AS social_credit_code,
        CREDIT_CMNT_NM AS credit_evaluation_name,
        CMNT_RESULT AS evaluation_result,
        CMNT_ORG AS evaluation_organization,
        ASSESS_DT AS evaluation_date
    FROM DW_NB_HYWLQYXYDJXX
    WHERE UNI_SOCIAL_CRD_CD IS NOT NULL
),

-- 12. 企业变更信息（从DW_NB_SWBGXX表）
change_info AS (
    SELECT
        UNI_SOCIAL_CRD_CD AS social_credit_code,
        CHAN_DT AS change_date,
        CHAN_PROJECT AS change_project,
        CHAN_BEF_TEXT AS change_before,
        CHAN_AFT_TEXT AS change_after
    FROM DW_NB_SWBGXX
    WHERE UNI_SOCIAL_CRD_CD IS NOT NULL
),

-- 13. 纳税信息（从DW_NB_SW_SBJNXX表）
tax_info AS (
    SELECT
        UNI_SOCIAL_CRD_CD AS social_credit_code,
        PAID_AMT AS total_tax_amount,
        COLL_ITEM AS tax_items,
        PERIOD_FROM AS tax_period_start,
        PERIOD_TO AS tax_period_end
    FROM DW_NB_SW_SBJNXX
    WHERE UNI_SOCIAL_CRD_CD IS NOT NULL
),

-- 14. A级纳税人信息（从DW_NB_SW_XYPJXXA表）
grade_a_taxpayer AS (
    SELECT
        UNI_SOCIAL_CRD_CD AS social_credit_code,
        CASE WHEN TAX_CREDI_LEVEL = 'A' THEN 1 ELSE 0 END AS is_grade_a_taxpayer,
        EVAL_ORG AS evaluation_department,
        EVAL_DT AS evaluation_date,
        TAX_CREDI_LEVEL AS tax_credit_level
    FROM DW_NB_SW_XYPJXXA
    WHERE UNI_SOCIAL_CRD_CD IS NOT NULL
),

-- 15. 社保信息（从DW_NB_RLSB_SBJYLYSHBXJBXX表）
social_security AS (
    SELECT
        UNI_SOCIAL_CRD_CD AS social_credit_code,
        PENS_NUM AS pension_count,
        MEDIC_NUM AS medical_count,
        UNEMPLOY_NUM AS unemployment_count,
        INJURY_NUM AS injury_count,
        MATERNI_NUM AS maternity_count,
        PENS_PAY_YM AS pension_pay_date,
        MEDIC_PAY_YM AS medical_pay_date
    FROM DW_NB_RLSB_SBJYLYSHBXJBXX
    WHERE UNI_SOCIAL_CRD_CD IS NOT NULL
),

-- 16. 社保缴费明细（从DW_NB_RLSB_CBGRYJSYBXFHDXX表）
social_security_detail AS (
    SELECT
        UNI_SOCIAL_CRD_CD AS social_credit_code,
        INSUR_TYPE AS insurance_type,
        PAY_MONS AS payment_months,
        PER_PAY_BASE AS personal_payment_base,
        PAY_AMT AS payment_amount,
        CORP_PAY_AMT AS corporate_payment_amount,
        PER_PAY_AMT AS personal_payment_amount,
        FEE_PERIOD AS fee_period
    FROM DW_NB_RLSB_CBGRYJSYBXFHDXX
    WHERE UNI_SOCIAL_CRD_CD IS NOT NULL
),

-- 17. 行政处罚信息（从DW_NB_SCJDGL_XZCFGSXX表）
administrative_penalty AS (
    SELECT
        UNI_SOCIAL_CRD_CD AS social_credit_code,
        CASE WHEN ADMIN_PUNISH_DOC IS NOT NULL THEN 1 ELSE 0 END AS has_penalty,
        ADMIN_PUNISH_DOC AS penalty_document,
        PUNISH_REA AS penalty_reason,
        PUNISH_DT AS penalty_date,
        PUNISH_RESULT AS penalty_result
    FROM DW_NB_SCJDGL_XZCFGSXX
    WHERE UNI_SOCIAL_CRD_CD IS NOT NULL
),

-- 18. 行政许可信息（从DW_NB_SCJDGL_XZXK表）
administrative_license AS (
    SELECT
        UNI_SOCIAL_CRD_CD AS social_credit_code,
        CASE WHEN LIC_NO IS NOT NULL THEN 1 ELSE 0 END AS has_license,
        LIC_NO AS license_number,
        LIC_NM AS license_name,
        LIC_ANTH AS license_authority,
        VAL_FROM AS valid_from,
        VAL_TO AS valid_to
    FROM DW_NB_SCJDGL_XZXK
    WHERE UNI_SOCIAL_CRD_CD IS NOT NULL
)

-- 最终合并所有维度信息
SELECT
    bct.*,
    -- 法定代表人信息
    lri.legal_rep_name,
    lri.id_card_number,
    lri.fixed_phone,
    lri.mobile_phone,
    lri.email,
    lri.position_title,
    -- 经营异常信息
    ba.has_business_abnormal,
    ba.abnormal_reason,
    ba.include_date AS abnormal_include_date,
    ba.removal_reason,
    ba.removal_date AS abnormal_removal_date,
    -- 严重违法失信信息
    sv.has_serious_violation,
    sv.violation_reason,
    sv.include_date AS violation_include_date,
    sv.removal_reason AS violation_removal_reason,
    sv.removal_date AS violation_removal_date,
    -- 网站网店信息
    ws.has_website_shop,
    ws.website_shop_name,
    ws.website_shop_url,
    ws.website_type,
    ws.ecommerce_type,
    -- 股权变更信息
    ec.has_equity_change,
    ec.change_date AS equity_change_date,
    ec.investor_name,
    ec.equity_before,
    ec.equity_after,
    -- 年报资产信息
    ara.report_year,
    ara.total_assets,
    ara.total_liabilities,
    ara.owner_equity,
    ara.total_revenue,
    ara.total_profit,
    ara.net_profit,
    ara.total_tax,
    -- 对外担保信息
    gi.has_external_guarantee,
    gi.creditor,
    gi.debtor,
    gi.guarantee_amount,
    gi.guarantee_start_date,
    gi.guarantee_end_date,
    -- 科技型小微企业信息
    tse.is_tech_small_enterprise,
    tse.recognition_organization,
    tse.recognition_year,
    -- 失信被执行人信息
    dp.is_dishonest_person,
    dp.execute_court,
    dp.execute_amount,
    dp.not_execute_amount,
    dp.filing_date,
    -- 信用评价信息
    ce.credit_evaluation_name,
    ce.evaluation_result,
    ce.evaluation_organization,
    ce.evaluation_date,
    -- 变更信息
    ci.change_date,
    ci.change_project,
    ci.change_before,
    ci.change_after,
    -- 纳税信息
    ti.total_tax_amount,
    ti.tax_items,
    ti.tax_period_start,
    ti.tax_period_end,
    -- A级纳税人信息
    gat.is_grade_a_taxpayer,
    gat.evaluation_department,
    gat.evaluation_date,
    gat.tax_credit_level,
    -- 社保信息
    ss.pension_count,
    ss.medical_count,
    ss.unemployment_count,
    ss.injury_count,
    ss.maternity_count,
    ss.pension_pay_date,
    ss.medical_pay_date,
    -- 社保缴费明细
    ssd.insurance_type,
    ssd.payment_months,
    ssd.personal_payment_base,
    ssd.payment_amount,
    ssd.corporate_payment_amount,
    ssd.personal_payment_amount,
    ssd.fee_period,
    -- 行政处罚信息
    ap.has_penalty,
    ap.penalty_document,
    ap.penalty_reason,
    ap.penalty_date,
    ap.penalty_result,
    -- 行政许可信息
    al.has_license,
    al.license_number,
    al.license_name,
    al.license_authority,
    al.valid_from,
    al.valid_to
FROM base_cultural_tourism bct
LEFT JOIN legal_rep_info lri ON bct.social_credit_code = lri.social_credit_code
LEFT JOIN business_abnormal ba ON bct.social_credit_code = ba.social_credit_code
LEFT JOIN serious_violation sv ON bct.social_credit_code = sv.social_credit_code
LEFT JOIN website_shop ws ON bct.social_credit_code = ws.social_credit_code
LEFT JOIN equity_change ec ON bct.social_credit_code = ec.social_credit_code
LEFT JOIN annual_report_assets ara ON bct.social_credit_code = ara.social_credit_code
LEFT JOIN guarantee_info gi ON bct.social_credit_code = gi.social_credit_code
LEFT JOIN tech_small_enterprise tse ON bct.social_credit_code = tse.social_credit_code
LEFT JOIN dishonest_person dp ON bct.social_credit_code = dp.social_credit_code
LEFT JOIN credit_evaluation ce ON bct.social_credit_code = ce.social_credit_code
LEFT JOIN change_info ci ON bct.social_credit_code = ci.social_credit_code
LEFT JOIN tax_info ti ON bct.social_credit_code = ti.social_credit_code
LEFT JOIN grade_a_taxpayer gat ON bct.social_credit_code = gat.social_credit_code
LEFT JOIN social_security ss ON bct.social_credit_code = ss.social_credit_code
LEFT JOIN social_security_detail ssd ON bct.social_credit_code = ssd.social_credit_code
LEFT JOIN administrative_penalty ap ON bct.social_credit_code = ap.social_credit_code
LEFT JOIN administrative_license al ON bct.social_credit_code = al.social_credit_code
ORDER BY bct.social_credit_code;