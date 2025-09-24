-- Step2：增加文旅企业信息维度（本地验证版本）
-- 将多个维度的企业信息合并到Step1的结果中
-- 基于Step1的CSV导入结果进行扩展


WITH company AS (
    -- 从Step1的结果开始，使用CSV导入的行业代码
    WITH base_company AS (
        SELECT
            UNI_SOCIAL_CRD_CD,                           -- 统一社会信用代码
            COMP_NM,                                      -- 企业名称
            REG_ORG,                                      -- 登记机关
            COMP_TYPE,                                    -- 企业类型
            ADDR,                                         -- 地址
            LEGAL_REPRE,                                  -- 法定代表人
            INDV_ID,                                      -- 行业名称
            INDV_CODE,                                    -- 行业数字代码
            INDV_NM,                                      -- 行业名称（完整）
            OPT_SCOP,                                     -- 经营范围
            APPR_DT,                                      -- 核准日期
            EST_DT,                                       -- 成立日期
            DOMDI_STRICT,                                 -- 所在区县
            PRO_LOC,                                      -- 生产经营地址
            OPT_STRICT,                                   -- 区县市
            OPT_LOC                                       -- 住所
        FROM dw_zj_scjdgl_scztxx
        WHERE UNI_SOCIAL_CRD_CD IS NOT NULL
    ),

    -- 将基础企业信息与文化目录进行关联
    cultural_company AS (
        SELECT
            be.*,
            '文化产业' AS industry_category,
            1 AS is_cultural,
            0 AS is_tourism
        FROM base_company be
        INNER JOIN cultural_industry_codes cic
            ON be.INDV_CODE = cic.industry_code
    ),

    -- 将基础企业信息与旅游目录进行关联
    tourism_company AS (
        SELECT
            be.*,
            '旅游产业' AS industry_category,
            0 AS is_cultural,
            1 AS is_tourism
        FROM base_company be
        INNER JOIN tourism_industry_codes tic
            ON be.INDV_CODE = tic.industry_code
    ),

    -- 根据白名单企业的社会信用代码，将文旅目录与基础企业信息进行关联
    white_list_company AS (
        SELECT
            be.*,
            '白名单企业' AS industry_category,
            1 AS is_cultural,
            1 AS is_tourism
        FROM base_company be
        INNER JOIN social_credit_codes scc
            ON be.UNI_SOCIAL_CRD_CD = scc.social_credit_code
    ),

    -- 合并所有文旅企业
    all_cultural_tourism AS (
        SELECT * FROM cultural_company
        UNION ALL
        SELECT * FROM tourism_company
        UNION ALL
        SELECT * FROM white_list_company
    ),

    -- 去重处理（按社会信用代码去重，优先保留白名单企业）
    ranked_company AS (
        SELECT
            *,
            ROW_NUMBER() OVER (
                PARTITION BY UNI_SOCIAL_CRD_CD
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
        UNI_SOCIAL_CRD_CD,                               -- 统一社会信用代码
        COMP_NM,                                          -- 企业名称
        REG_ORG,                                          -- 登记机关
        COMP_TYPE,                                        -- 企业类型
        ADDR,                                             -- 地址
        LEGAL_REPRE,                                      -- 法定代表人
        INDV_ID,                                          -- 行业名称
        INDV_CODE,                                        -- 行业数字代码
        INDV_NM,                                          -- 行业名称（完整）
        OPT_SCOP,                                         -- 经营范围
        APPR_DT,                                          -- 核准日期
        EST_DT,                                           -- 成立日期
        DOMDI_STRICT,                                     -- 所在区县
        PRO_LOC,                                          -- 生产经营地址
        OPT_STRICT,                                       -- 区县市
        OPT_LOC,                                          -- 住所
        industry_category,                                -- 行业类别
        is_cultural,                                      -- 是否文化产业
        is_tourism                                        -- 是否旅游产业
    FROM ranked_company
    WHERE rn = 1
),

-- 2. 法定代表人详细信息（从DW_ZJ_SCJDGL_FDDBRXX表）
legal_rep_info AS (
    SELECT
        UNI_SOCIAL_CRD_CD,                               -- 统一社会信用代码
        NM,                                               -- 法定代表人姓名
        CER_NO,                                           -- 身份证号码
        TEL_NUM,                                          -- 固定电话
        MOBTEL,                                           -- 手机号码
        EMAIL,                                            -- 电子邮箱
        POSITION_CN                                       -- 职务
    FROM DW_ZJ_SCJDGL_FDDBRXX
    WHERE UNI_SOCIAL_CRD_CD IS NOT NULL
      AND LEREP_SIGN = 1  -- 法定代表人标志
),

-- 3. 经营异常名录信息（从DW_ZJ_SCJDGL_JYYCMLXX表）
business_abnormal AS (
    SELECT
        UNI_SOCIAL_CRD_CD,                               -- 统一社会信用代码
        CASE WHEN INCLU_REASON IS NOT NULL THEN 1 ELSE 0 END AS has_business_abnormal,
        INCLU_REASON,                                     -- 列入原因
        INCLU_DT,                                         -- 列入日期
        REMEXCPRES_CN,                                    -- 移出原因
        REMOVE_DT                                         -- 移出日期
    FROM DW_ZJ_SCJDGL_JYYCMLXX
    WHERE UNI_SOCIAL_CRD_CD IS NOT NULL
),

-- 4. 严重违法失信企业名单信息（从DW_ZJ_SCJDGL_YZWFSX表）
serious_violation AS (
    SELECT
        UNI_SOCIAL_CRD_CD,                               -- 统一社会信用代码
        CASE WHEN SERILL_REA IS NOT NULL THEN 1 ELSE 0 END AS has_serious_violation,
        SERILL_REA,                                       -- 严重违法失信原因
        ABN_TM,                                           -- 列入时间
        REM_EXCPRES_REA,                                  -- 移出原因
        REM_DT                                            -- 移出时间
    FROM DW_ZJ_SCJDGL_YZWFSX
    WHERE UNI_SOCIAL_CRD_CD IS NOT NULL
),

-- 5. 网站网店信息（从DW_NB_SCJDGL_QYNBWZHWDXX表）
website_shop AS (
    SELECT
        UNI_SOCIAL_CRD_CD,                               -- 统一社会信用代码
        CASE WHEN WEB_ID IS NOT NULL THEN 1 ELSE 0 END AS has_website_shop,
        WEB_STORE_NM,                                     -- 网站网店名称
        WEB_STORE_URL,                                    -- 网站网店网址
        WEB_STORE_TYPE,                                   -- 网站类型
        ECOM_TYPE                                         -- 电商类型
    FROM DW_NB_SCJDGL_QYNBWZHWDXX
    WHERE UNI_SOCIAL_CRD_CD IS NOT NULL
),

-- 6. 股权变更信息（从DW_NB_SCJDGL_GQBG表）
equity_change AS (
    SELECT
        UNI_SOCIAL_CRD_CD,                               -- 统一社会信用代码
        CASE WHEN ALT_DT IS NOT NULL THEN 1 ELSE 0 END AS has_equity_change,
        ALT_DT,                                           -- 变更日期
        INV,                                               -- 投资人
        TRANSAMPR_BF,                                     -- 变更前股权
        TRANSAMPR_AF                                      -- 变更后股权
    FROM DW_NB_SCJDGL_GQBG
    WHERE UNI_SOCIAL_CRD_CD IS NOT NULL
),

-- 7. 企业年报资产信息（从DW_NB_SCJDGL_QYNBZCXX表）
annual_report_assets AS (
    SELECT
        UNI_SOCIAL_CRD_CD,                               -- 统一社会信用代码
        ANNUAL_YEAR,                                      -- 年报年份
        ASSET_ZMT,                                        -- 资产总额
        DEBT_AMT,                                         -- 负债总额
        OWNER_EQUITY_TOATAL,                              -- 所有者权益合计
        OPT_INCOME_TOTAL,                                 -- 营业总收入
        PROFIT_TOTAL,                                     -- 利润总额
        NET_PROFIT,                                       -- 净利润
        TAX_TOTAL                                         -- 纳税总额
    FROM DW_NB_SCJDGL_QYNBZCXX
    WHERE UNI_SOCIAL_CRD_CD IS NOT NULL
      AND ANNUAL_YEAR IS NOT NULL
),

-- 8. 对外担保信息（从DW_NB_SCJDGL_DWTGBZDBXX表）
guarantee_info AS (
    SELECT
        UNI_SOCIAL_CRD_CD,                               -- 统一社会信用代码
        CASE WHEN EXTERNAL_GUA IS NOT NULL THEN 1 ELSE 0 END AS has_external_guarantee,
        CREDITOR,                                         -- 债权人
        DEBTOR,                                           -- 债务人
        MAJOR_CREDIT_AMT,                                 -- 担保金额
        PERIOD_FROM,                                      -- 担保起始日期
        PERIOD_TO                                         -- 担保结束日期
    FROM DW_NB_SCJDGL_DWTGBZDBXX
    WHERE UNI_SOCIAL_CRD_CD IS NOT NULL
),

-- 9. 科技型小微企业信息（从DW_NB_KJ_SGCZKJXZXQY表）
tech_small_enterprise AS (
    SELECT
        UNI_SOCIAL_CRD_CD,                               -- 统一社会信用代码
        CASE WHEN CONGNIZ_TEAR IS NOT NULL THEN 1 ELSE 0 END AS is_tech_small_enterprise,
        CONGNIZ_ORG,                                      -- 认定机构
        CONGNIZ_TEAR                                      -- 认定年份
    FROM DW_NB_KJ_SGCZKJXZXQY
    WHERE UNI_SOCIAL_CRD_CD IS NOT NULL
),

-- 10. 失信被执行人信息（从DW_SHL_QYWLXSXCPXX表）
dishonest_person AS (
    SELECT
        UNI_SOCIAL_CRD_CD,                               -- 统一社会信用代码
        CASE WHEN EXECUTE_COURT IS NOT NULL THEN 1 ELSE 0 END AS is_dishonest_person,
        EXECUTE_COURT,                                    -- 执行法院
        EXECUTE_AMT,                                      -- 执行金额
        NOT_EXECUTE_AMT,                                  -- 未执行金额
        FILING_DT                                         -- 立案日期
    FROM DW_SHL_QYWLXSXCPXX
    WHERE UNI_SOCIAL_CRD_CD IS NOT NULL
),

-- 11. 信用评价信息（从DW_NB_HYWLQYXYDJXX表）
credit_evaluation AS (
    SELECT
        UNI_SOCIAL_CRD_CD,                               -- 统一社会信用代码
        CREDIT_CMNT_NM,                                   -- 信用评价名称
        CMNT_RESULT,                                      -- 评价结果
        CMNT_ORG,                                         -- 评价机构
        ASSESS_DT                                         -- 评价日期
    FROM DW_NB_HYWLQYXYDJXX
    WHERE UNI_SOCIAL_CRD_CD IS NOT NULL
),

-- 12. 企业变更信息（从DW_NB_SWBGXX表）
change_info AS (
    SELECT
        UNI_SOCIAL_CRD_CD,                               -- 统一社会信用代码
        CHAN_DT,                                          -- 变更日期
        CHAN_PROJECT,                                     -- 变更项目
        CHAN_BEF_TEXT,                                    -- 变更前内容
        CHAN_AFT_TEXT                                     -- 变更后内容
    FROM DW_NB_SWBGXX
    WHERE UNI_SOCIAL_CRD_CD IS NOT NULL
),

-- 13. 纳税信息（从DW_NB_SW_SBJNXX表）
tax_info AS (
    SELECT
        UNI_SOCIAL_CRD_CD,                               -- 统一社会信用代码
        PAID_AMT,                                         -- 实缴金额
        COLL_ITEM,                                        -- 征收项目
        PERIOD_FROM,                                      -- 所属期起
        PERIOD_TO                                         -- 所属期止
    FROM DW_NB_SW_SBJNXX
    WHERE UNI_SOCIAL_CRD_CD IS NOT NULL
),

-- 14. A级纳税人信息（从DW_NB_SW_XYPJXXA表）
grade_a_taxpayer AS (
    SELECT
        UNI_SOCIAL_CRD_CD,                               -- 统一社会信用代码
        CASE WHEN TAX_CREDI_LEVEL = 'A' THEN 1 ELSE 0 END AS is_grade_a_taxpayer,
        EVAL_ORG,                                         -- 评价部门
        EVAL_DT,                                          -- 评价日期
        TAX_CREDI_LEVEL                                   -- 纳税信用等级
    FROM DW_NB_SW_XYPJXXA
    WHERE UNI_SOCIAL_CRD_CD IS NOT NULL
),

-- 15. 社保信息（从DW_NB_RLSB_SBJYLYSHBXJBXX表）
social_security AS (
    SELECT
        UNI_SOCIAL_CRD_CD,                               -- 统一社会信用代码
        PENS_NUM,                                         -- 养老保险人数
        MEDIC_NUM,                                        -- 医疗保险人数
        UNEMPLOY_NUM,                                     -- 失业保险人数
        INJURY_NUM,                                       -- 工伤保险人数
        MATERNI_NUM,                                      -- 生育保险人数
        PENS_PAY_YM,                                      -- 养老保险缴费年月
        MEDIC_PAY_YM                                      -- 医疗保险缴费年月
    FROM DW_NB_RLSB_SBJYLYSHBXJBXX
    WHERE UNI_SOCIAL_CRD_CD IS NOT NULL
),

-- 16. 社保缴费明细（从DW_NB_RLSB_CBGRYJSYBXFHDXX表）
social_security_detail AS (
    SELECT
        UNI_SOCIAL_CRD_CD,                               -- 统一社会信用代码
        INSUR_TYPE,                                       -- 险种类型
        PAY_MONS,                                         -- 缴费月数
        PER_PAY_BASE,                                     -- 个人缴费基数
        PAY_AMT,                                          -- 缴费金额
        CORP_PAY_AMT,                                     -- 单位缴费金额
        PER_PAY_AMT,                                      -- 个人缴费金额
        FEE_PERIOD                                        -- 费款所属期
    FROM DW_NB_RLSB_CBGRYJSYBXFHDXX
    WHERE UNI_SOCIAL_CRD_CD IS NOT NULL
),

-- 17. 行政处罚信息（从DW_NB_SCJDGL_XZCFGSXX表）
administrative_penalty AS (
    SELECT
        UNI_SOCIAL_CRD_CD,                               -- 统一社会信用代码
        CASE WHEN ADMIN_PUNISH_DOC IS NOT NULL THEN 1 ELSE 0 END AS has_penalty,
        ADMIN_PUNISH_DOC,                                 -- 行政处罚决定书文号
        PUNISH_REA,                                       -- 处罚事由
        PUNISH_DT,                                        -- 处罚日期
        PUNISH_RESULT                                     -- 处罚结果
    FROM DW_NB_SCJDGL_XZCFGSXX
    WHERE UNI_SOCIAL_CRD_CD IS NOT NULL
),

-- 18. 行政许可信息（从DW_NB_SCJDGL_XZXK表）
administrative_license AS (
    SELECT
        UNI_SOCIAL_CRD_CD,                               -- 统一社会信用代码
        CASE WHEN LIC_NO IS NOT NULL THEN 1 ELSE 0 END AS has_license,
        LIC_NO,                                           -- 许可证号
        LIC_NM,                                           -- 许可证名称
        LIC_ANTH,                                         -- 许可机关
        VAL_FROM,                                         -- 有效期自
        VAL_TO                                            -- 有效期至
    FROM DW_NB_SCJDGL_XZXK
    WHERE UNI_SOCIAL_CRD_CD IS NOT NULL
)

-- 最终合并所有维度信息
SELECT
    bct.*,
    -- 法定代表人信息
    lri.NM,                                               -- 法定代表人姓名
    lri.CER_NO,                                           -- 身份证号码
    lri.TEL_NUM,                                          -- 固定电话
    lri.MOBTEL,                                           -- 手机号码
    lri.EMAIL,                                            -- 电子邮箱
    lri.POSITION_CN,                                      -- 职务
    -- 经营异常信息
    ba.has_business_abnormal,
    ba.INCLU_REASON,                                      -- 列入原因
    ba.INCLU_DT,                                          -- 列入日期
    ba.REMEXCPRES_CN,                                     -- 移出原因
    ba.REMOVE_DT,                                         -- 移出日期
    -- 严重违法失信信息
    sv.has_serious_violation,
    sv.SERILL_REA,                                        -- 严重违法失信原因
    sv.ABN_TM,                                            -- 列入时间
    sv.REM_EXCPRES_REA,                                   -- 移出原因
    sv.REM_DT,                                            -- 移出时间
    -- 网站网店信息
    ws.has_website_shop,
    ws.WEB_STORE_NM,                                      -- 网站网店名称
    ws.WEB_STORE_URL,                                     -- 网站网店网址
    ws.WEB_STORE_TYPE,                                    -- 网站类型
    ws.ECOM_TYPE,                                         -- 电商类型
    -- 股权变更信息
    ec.has_equity_change,
    ec.ALT_DT,                                            -- 变更日期
    ec.INV,                                               -- 投资人
    ec.TRANSAMPR_BF,                                      -- 变更前股权
    ec.TRANSAMPR_AF,                                      -- 变更后股权
    -- 年报资产信息
    ara.ANNUAL_YEAR,                                      -- 年报年份
    ara.ASSET_ZMT,                                        -- 资产总额
    ara.DEBT_AMT,                                         -- 负债总额
    ara.OWNER_EQUITY_TOATAL,                              -- 所有者权益合计
    ara.OPT_INCOME_TOTAL,                                 -- 营业总收入
    ara.PROFIT_TOTAL,                                     -- 利润总额
    ara.NET_PROFIT,                                       -- 净利润
    ara.TAX_TOTAL,                                        -- 纳税总额
    -- 对外担保信息
    gi.has_external_guarantee,
    gi.CREDITOR,                                          -- 债权人
    gi.DEBTOR,                                            -- 债务人
    gi.MAJOR_CREDIT_AMT,                                  -- 担保金额
    gi.PERIOD_FROM,                                       -- 担保起始日期
    gi.PERIOD_TO,                                         -- 担保结束日期
    -- 科技型小微企业信息
    tse.is_tech_small_enterprise,
    tse.CONGNIZ_ORG,                                      -- 认定机构
    tse.CONGNIZ_TEAR,                                     -- 认定年份
    -- 失信被执行人信息
    dp.is_dishonest_person,
    dp.EXECUTE_COURT,                                     -- 执行法院
    dp.EXECUTE_AMT,                                       -- 执行金额
    dp.NOT_EXECUTE_AMT,                                   -- 未执行金额
    dp.FILING_DT,                                         -- 立案日期
    -- 信用评价信息
    ce.CREDIT_CMNT_NM,                                    -- 信用评价名称
    ce.CMNT_RESULT,                                       -- 评价结果
    ce.CMNT_ORG,                                          -- 评价机构
    ce.ASSESS_DT,                                         -- 评价日期
    -- 变更信息
    ci.CHAN_DT,                                           -- 变更日期
    ci.CHAN_PROJECT,                                      -- 变更项目
    ci.CHAN_BEF_TEXT,                                     -- 变更前内容
    ci.CHAN_AFT_TEXT,                                     -- 变更后内容
    -- 纳税信息
    ti.PAID_AMT,                                          -- 实缴金额
    ti.COLL_ITEM,                                         -- 征收项目
    ti.PERIOD_FROM,                                       -- 所属期起
    ti.PERIOD_TO,                                         -- 所属期止
    -- A级纳税人信息
    gat.is_grade_a_taxpayer,
    gat.EVAL_ORG,                                         -- 评价部门
    gat.EVAL_DT,                                          -- 评价日期
    gat.TAX_CREDI_LEVEL,                                  -- 纳税信用等级
    -- 社保信息
    ss.PENS_NUM,                                          -- 养老保险人数
    ss.MEDIC_NUM,                                         -- 医疗保险人数
    ss.UNEMPLOY_NUM,                                      -- 失业保险人数
    ss.INJURY_NUM,                                        -- 工伤保险人数
    ss.MATERNI_NUM,                                       -- 生育保险人数
    ss.PENS_PAY_YM,                                       -- 养老保险缴费年月
    ss.MEDIC_PAY_YM,                                      -- 医疗保险缴费年月
    -- 社保缴费明细
    ssd.INSUR_TYPE,                                       -- 险种类型
    ssd.PAY_MONS,                                         -- 缴费月数
    ssd.PER_PAY_BASE,                                     -- 个人缴费基数
    ssd.PAY_AMT,                                          -- 缴费金额
    ssd.CORP_PAY_AMT,                                     -- 单位缴费金额
    ssd.PER_PAY_AMT,                                      -- 个人缴费金额
    ssd.FEE_PERIOD,                                       -- 费款所属期
    -- 行政处罚信息
    ap.has_penalty,
    ap.ADMIN_PUNISH_DOC,                                  -- 行政处罚决定书文号
    ap.PUNISH_REA,                                        -- 处罚事由
    ap.PUNISH_DT,                                         -- 处罚日期
    ap.PUNISH_RESULT,                                     -- 处罚结果
    -- 行政许可信息
    al.has_license,
    al.LIC_NO,                                            -- 许可证号
    al.LIC_NM,                                            -- 许可证名称
    al.LIC_ANTH,                                          -- 许可机关
    al.VAL_FROM,                                          -- 有效期自
    al.VAL_TO                                             -- 有效期至
FROM company bct
LEFT JOIN legal_rep_info lri ON bct.UNI_SOCIAL_CRD_CD = lri.UNI_SOCIAL_CRD_CD
LEFT JOIN business_abnormal ba ON bct.UNI_SOCIAL_CRD_CD = ba.UNI_SOCIAL_CRD_CD
LEFT JOIN serious_violation sv ON bct.UNI_SOCIAL_CRD_CD = sv.UNI_SOCIAL_CRD_CD
LEFT JOIN website_shop ws ON bct.UNI_SOCIAL_CRD_CD = ws.UNI_SOCIAL_CRD_CD
LEFT JOIN equity_change ec ON bct.UNI_SOCIAL_CRD_CD = ec.UNI_SOCIAL_CRD_CD
LEFT JOIN annual_report_assets ara ON bct.UNI_SOCIAL_CRD_CD = ara.UNI_SOCIAL_CRD_CD
LEFT JOIN guarantee_info gi ON bct.UNI_SOCIAL_CRD_CD = gi.UNI_SOCIAL_CRD_CD
LEFT JOIN tech_small_enterprise tse ON bct.UNI_SOCIAL_CRD_CD = tse.UNI_SOCIAL_CRD_CD
LEFT JOIN dishonest_person dp ON bct.UNI_SOCIAL_CRD_CD = dp.UNI_SOCIAL_CRD_CD
LEFT JOIN credit_evaluation ce ON bct.UNI_SOCIAL_CRD_CD = ce.UNI_SOCIAL_CRD_CD
LEFT JOIN change_info ci ON bct.UNI_SOCIAL_CRD_CD = ci.UNI_SOCIAL_CRD_CD
LEFT JOIN tax_info ti ON bct.UNI_SOCIAL_CRD_CD = ti.UNI_SOCIAL_CRD_CD
LEFT JOIN grade_a_taxpayer gat ON bct.UNI_SOCIAL_CRD_CD = gat.UNI_SOCIAL_CRD_CD
LEFT JOIN social_security ss ON bct.UNI_SOCIAL_CRD_CD = ss.UNI_SOCIAL_CRD_CD
LEFT JOIN social_security_detail ssd ON bct.UNI_SOCIAL_CRD_CD = ssd.UNI_SOCIAL_CRD_CD
LEFT JOIN administrative_penalty ap ON bct.UNI_SOCIAL_CRD_CD = ap.UNI_SOCIAL_CRD_CD
LEFT JOIN administrative_license al ON bct.UNI_SOCIAL_CRD_CD = al.UNI_SOCIAL_CRD_CD
ORDER BY bct.UNI_SOCIAL_CRD_CD;