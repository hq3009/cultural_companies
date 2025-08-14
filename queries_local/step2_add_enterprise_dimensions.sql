-- Step2：增加文旅企业信息维度（本地验证版本）
-- 将多个维度的企业信息合并到Step1的结果中
-- 基于Step1的CSV导入结果进行扩展

-- 首先执行Step1的CSV导入逻辑
-- 创建临时表来存储CSV数据
DROP TEMPORARY TABLE IF EXISTS cultural_industry_codes;
CREATE TEMPORARY TABLE cultural_industry_codes (
    industry_code VARCHAR(20) NOT NULL,
    PRIMARY KEY (industry_code)
);

DROP TEMPORARY TABLE IF EXISTS tourism_industry_codes;
CREATE TEMPORARY TABLE tourism_industry_codes (
    industry_code VARCHAR(20) NOT NULL,
    PRIMARY KEY (industry_code)
);

DROP TEMPORARY TABLE IF EXISTS social_credit_codes;
CREATE TEMPORARY TABLE social_credit_codes (
    social_credit_code VARCHAR(50) NOT NULL,
    PRIMARY KEY (social_credit_code)
);

-- 导入CSV数据
LOAD DATA INFILE 'industry_class/cultural_industry_codes.csv'
INTO TABLE cultural_industry_codes
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
(industry_code);

LOAD DATA INFILE 'industry_class/tourism_industry_codes.csv'
INTO TABLE tourism_industry_codes
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
(industry_code);

LOAD DATA INFILE 'industry_class/social_credit_codes.csv'
INTO TABLE social_credit_codes
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(social_credit_code);

WITH base_cultural_tourism AS (
    -- 从Step1的结果开始，使用CSV导入的行业代码
    WITH base_enterprises AS (
        SELECT
            UNI_SOCIAL_CRD_CD AS social_credit_code,      -- 统一社会信用代码
            COMP_NM AS company_name,                      -- 企业名称
            REG_ORG AS reg_authority,                     -- 登记机关
            COMP_TYPE AS company_type,                    -- 企业类型
            ADDR AS reg_address,                              -- 地址
            LEGAL_REPRE AS legal_repre,                     -- 法定代表人
            INDV_ID AS industry_name,                     -- 行业名称
            INDV_CODE AS industry_code,                   -- 行业数字代码
            INDV_NM AS industry_name_full,                -- 行业名称（完整）
            OPT_SCOP AS business_scope,                   -- 经营范围
            APPR_DT AS approval_date,                     -- 核准日期
            EST_DT AS establishment_date,                 -- 成立日期
            DOMDI_STRICT AS domicile_district_code,                 -- 所在区县
            PRO_LOC AS production_address,                -- 生产经营地址
            OPT_STRICT AS business_district_code,                -- 区县市
            OPT_LOC AS business_premises                  -- 住所
        FROM dw_zj_scjdgl_scztxx
        WHERE UNI_SOCIAL_CRD_CD IS NOT NULL
    ),

    -- 将基础企业信息与文化目录进行关联
    cultural_enterprises AS (
        SELECT
            be.*,
            '文化产业' AS industry_category,
            1 AS is_cultural,
            0 AS is_tourism
        FROM base_enterprises be
        INNER JOIN cultural_industry_codes cic
            ON be.industry_code = cic.industry_code
    ),

    -- 将基础企业信息与旅游目录进行关联
    tourism_enterprises AS (
        SELECT
            be.*,
            '旅游产业' AS industry_category,
            0 AS is_cultural,
            1 AS is_tourism
        FROM base_enterprises be
        INNER JOIN tourism_industry_codes tic
            ON be.industry_code = tic.industry_code
    ),

    -- 根据白名单企业的社会信用代码，将文旅目录与基础企业信息进行关联
    white_list_enterprises AS (
        SELECT
            be.*,
            '白名单企业' AS industry_category,
            1 AS is_cultural,
            1 AS is_tourism
        FROM base_enterprises be
        INNER JOIN social_credit_codes scc
            ON be.social_credit_code = scc.social_credit_code
    ),

    -- 合并所有文旅企业
    all_cultural_tourism AS (
        SELECT * FROM cultural_enterprises
        UNION ALL
        SELECT * FROM tourism_enterprises
        UNION ALL
        SELECT * FROM white_list_enterprises
    ),

    -- 去重处理（按社会信用代码去重，优先保留白名单企业）
    ranked_enterprises AS (
        SELECT
            *,
            ROW_NUMBER() OVER (
                PARTITION BY social_credit_code
                ORDER BY
                    CASE
                        WHEN industry_category = '白名单企业' THEN 1
                        WHEN industry_category = '文化产业' THEN 2
                        WHEN industry_category = '旅游产业' THEN 3
                        ELSE 4
                    END
            ) AS rn
        FROM all_cultural_tourism
    )

    -- 最终去重结果
    SELECT
        social_credit_code,
        company_name,
        reg_authority,
        company_type,
        reg_address,
        legal_repre,
        industry_name,
        industry_code,
        industry_name_full,
        business_scope,
        approval_date,
        establishment_date,
        domicile_district_code,
        production_address,
        business_district_code,
        business_premises,
        industry_category,
        is_cultural,
        is_tourism
    FROM ranked_enterprises
    WHERE rn = 1
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