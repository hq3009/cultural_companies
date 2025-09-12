-- Step2：扩展 enterprises 表的数据维度（云端版本 - Step by Step）
-- 基于 01_enterprises.sql 中已创建的 enterprises 表，添加法定代表人、经营异常、行政处罚等详细信息
-- 分步骤进行便于调试和验证每个表的数据提取情况
-- 注意：此脚本依赖于 01_enterprises.sql 中创建的 enterprises 表
--
-- 执行流程：
-- 1. 前置检查：确保 enterprises 表存在
-- 2. Step 1-15：分别创建15个维度的信息表（法定代表人、经营异常、严重违法失信等）
-- 3. Step 16：逐步合并所有信息到最终表 enterprises_extended
-- 4. 最终结果：包含基础企业信息 + 15个维度扩展信息的完整表

-- ========================================
-- 前置检查：确保 enterprises 表存在
-- ========================================
-- 检查 enterprises 表是否存在
SELECT
    COUNT(*) AS enterprises_count,
    'enterprises table exists' AS status
FROM enterprises
LIMIT 1;

-- ========================================
-- Step 1: 创建法定代表人信息表
-- ========================================
DROP TABLE IF EXISTS step1_legal_rep_info;
CREATE TABLE step1_legal_rep_info AS
SELECT
    UNI_SOCIAL_CRD_CD,                           -- 统一社会信用代码
    PERSONID,                                     -- 人员ID
    LEREP_SIGN,                                   -- 法定代表人标志/首席代表标志/负责人标识 2 董事
    NM,                                           -- 姓名
    POSITION,                                     -- 职务
    CERTYPE,                                      -- 证件类型
    COUNTRY,                                      -- 国籍
    POSITION_CN,                                  -- 职务（中文名称）
    CERTYPE_CN,                                   -- 证件类型（中文）
    COUNTRY_CN,                                   -- 国籍（中文）
    CER_NO,                                       -- 身份证件号码
    TEL_NUM,                                      -- 固定电话
    MOBTEL,                                       -- 移动电话
    EMAIL                                         -- 电子邮箱
FROM DW_ZJ_SCJDGL_FDDBRXX
WHERE UNI_SOCIAL_CRD_CD IS NOT NULL
  AND LEREP_SIGN = 1;  -- 法定代表人标志

-- 验证法定代表人信息
SELECT
    COUNT(*) AS total_legal_reps,
    COUNT(DISTINCT UNI_SOCIAL_CRD_CD) AS unique_enterprises
FROM step1_legal_rep_info;

-- ========================================
-- Step 2: 创建经营异常名录信息表
-- ========================================
DROP TABLE IF EXISTS step2_business_abnormal;
CREATE TABLE step2_business_abnormal AS
SELECT
    UNI_SOCIAL_CRD_CD,                           -- 统一社会信用代码
    INCLU_DT,                                     -- 列入日期
    INCLU_REASON,                                 -- 列入经营异常名录原因
    REDECORG_CN,                                  -- 作出决定机关(移出)
    REMEXCPRES_CN,                                -- 移出经营异常名录原因
    REMOVE_DT,                                    -- 移出日期
    DECORG_CN                                     -- 作出决定机关(列入)
FROM DW_ZJ_SCJDGL_JYYCMLXX
WHERE UNI_SOCIAL_CRD_CD IS NOT NULL;

-- 验证经营异常信息
SELECT
    COUNT(*) AS total_abnormal_records,
    COUNT(DISTINCT UNI_SOCIAL_CRD_CD) AS unique_enterprises
FROM step2_business_abnormal;

-- ========================================
-- Step 3: 创建严重违法失信企业名单信息表
-- ========================================
DROP TABLE IF EXISTS step3_serious_violation;
CREATE TABLE step3_serious_violation AS
SELECT
    UNI_SOCIAL_CRD_CD,                           -- 统一社会信用代码
    ILL_COMP_ID,                                  -- 严重违法失信企业名单ID
    ABN_TM,                                       -- 列入日期
    SERILL_REA,                                   -- 列入严重违法失信企业名单原因
    REM_DT,                                       -- 移出日期
    RECORG_OGR,                                   -- 作出决定机关(移出)
    REM_EXCPRES_REA,                              -- 移出严重违法失信企业名单原因
    DECORG_ORG                                    -- 作出决定机关(列入)
FROM DW_ZJ_SCJDGL_YZWFSX
WHERE UNI_SOCIAL_CRD_CD IS NOT NULL;

-- 验证严重违法失信信息
SELECT
    COUNT(*) AS total_violation_records,
    COUNT(DISTINCT UNI_SOCIAL_CRD_CD) AS unique_enterprises
FROM step3_serious_violation;

-- ========================================
-- Step 4: 创建网站网店信息表
-- ========================================
DROP TABLE IF EXISTS step4_website_shop;
CREATE TABLE step4_website_shop AS
SELECT
    UNI_SOCIAL_CRD_CD,                           -- 统一社会信用代码
    WEB_ID,                                       -- 网站标识
    ANNUAL_ID,                                    -- 年报ID
    WEB_STORE_TYPE,                               -- 网站网店类型
    WEB_STORE_NM,                                 -- 网站（网店）名称
    WEB_STORE_URL,                                -- 网站（网店）网址
    WEB_TYPE,                                     -- 网站类型
    WEB_PLAT_TYPE,                                -- 网络交易平台运营类型
    WEB_PRODUCT_TYPE,                             -- 网络交易产品类型
    ECOM_TYPE,                                    -- 电商类型
    ICP_NO,                                       -- ICP证号/备案号
    WECHAT_PUBLIC,                                -- 微信公众服务号
    APP_NM,                                       -- APP软件名称
    PLAT_NM,                                      -- 所属平台名称
    DELI_ADDR,                                    -- 发货地址
    RETURN_ADDR,                                  -- 退货地址
    PRIPID,                                       -- 主体身份代码
    COMP_NM,                                      -- 企业名称（字号名称）
    ANNUAL_YEAR                                   -- 年报年度
FROM DW_NB_SCJDGL_QYNBWZHWDXX
WHERE UNI_SOCIAL_CRD_CD IS NOT NULL;

-- 验证网站网店信息
SELECT
    COUNT(*) AS total_website_records,
    COUNT(DISTINCT UNI_SOCIAL_CRD_CD) AS unique_enterprises
FROM step4_website_shop;

-- ========================================
-- Step 5: 创建股权变更信息表
-- ========================================
DROP TABLE IF EXISTS step5_equity_change;
CREATE TABLE step5_equity_change AS
SELECT
    UNI_SOCIAL_CRD_CD,                           -- 统一社会信用代码
    PRIPID,                                       -- 主体身份代码
    INV,                                          -- 股东
    ALT_DT,                                       -- 股权变更日期
    PUBLIC_DT,                                    -- 公示日期
    TRANSAMPR_BF,                                 -- 变更前股权比例
    TRANSAMPR_AF                                  -- 变更后股权比例
FROM DW_NB_SCJDGL_GQBG
WHERE UNI_SOCIAL_CRD_CD IS NOT NULL;

-- 验证股权变更信息
SELECT
    COUNT(*) AS total_equity_records,
    COUNT(DISTINCT UNI_SOCIAL_CRD_CD) AS unique_enterprises
FROM step5_equity_change;

-- ========================================
-- Step 6: 创建企业年报资产信息表
-- ========================================
DROP TABLE IF EXISTS step6_annual_report_assets;
CREATE TABLE step6_annual_report_assets AS
SELECT
    UNI_SOCIAL_CRD_CD,                           -- 统一社会信用代码
    ANNUAL_YEAR,                                  -- 年报年度
    ASSET_ZMT,                                    -- 资产总额
    DEBT_AMT,                                     -- 负债总额
    OWNER_EQUITY_TOATAL,                          -- 所有者权益合计
    OPT_INCOME_TOTAL,                             -- 营业总收入
    PROFIT_TOTAL,                                 -- 利润总额
    NET_PROFIT,                                   -- 净利润
    TAX_TOTAL                                     -- 纳税总额
FROM DW_NB_SCJDGL_QYNBZCXX
WHERE UNI_SOCIAL_CRD_CD IS NOT NULL
  AND ANNUAL_YEAR IS NOT NULL;

-- 验证年报资产信息
SELECT
    COUNT(*) AS total_annual_records,
    COUNT(DISTINCT UNI_SOCIAL_CRD_CD) AS unique_enterprises,
    COUNT(DISTINCT ANNUAL_YEAR) AS unique_years
FROM step6_annual_report_assets;

-- ========================================
-- Step 7: 创建对外担保信息表
-- ========================================
DROP TABLE IF EXISTS step7_guarantee_info;
CREATE TABLE step7_guarantee_info AS
SELECT
    UNI_SOCIAL_CRD_CD,                           -- 统一社会信用代码
    CREDITOR,                                     -- 债权人
    DEBTOR,                                       -- 债务人
    MAJOR_CREDIT_TYPE,                            -- 主债权种类
    MAJOR_CREDIT_AMT,                             -- 主债权数额
    PERIOD_FROM,                                  -- 履行债务的期限自
    PERIOD_TO,                                    -- 履行债务的期限至
    PROMIS_DUR,                                   -- 保证的期间
    IS_PUBLIC,                                    -- 对外担保是否公示
    PROMIS_WAY,                                   -- 保证的方式
    ANNUAL_YEAR                                   -- 年报年度
FROM DW_NB_SCJDGL_DWTGBZDBXX
WHERE UNI_SOCIAL_CRD_CD IS NOT NULL;

-- 验证对外担保信息
SELECT
    COUNT(*) AS total_guarantee_records,
    COUNT(DISTINCT UNI_SOCIAL_CRD_CD) AS unique_enterprises
FROM step7_guarantee_info;

-- ========================================
-- Step 8: 创建科技型小微企业信息表
-- ========================================
DROP TABLE IF EXISTS step8_tech_small_enterprise;
CREATE TABLE step8_tech_small_enterprise AS
SELECT
    UNI_SOCIAL_CRD_CD,                           -- 统一社会信用代码
    CONGNIZ_ORG,                                  -- 认定机构
    CONGNIZ_TEAR                                  -- 认定年份
FROM DW_NB_KJ_SGCZKJXZXQY
WHERE UNI_SOCIAL_CRD_CD IS NOT NULL;

-- 验证科技型小微企业信息
SELECT
    COUNT(*) AS total_tech_records,
    COUNT(DISTINCT UNI_SOCIAL_CRD_CD) AS unique_enterprises
FROM step8_tech_small_enterprise;

-- ========================================
-- Step 9: 创建失信被执行人信息表
-- ========================================
DROP TABLE IF EXISTS step9_dishonest_person;
CREATE TABLE step9_dishonest_person AS
SELECT
    UNI_SOCIAL_CRD_CD,                           -- 统一社会信用代码
    EXECUTED_NM,                                  -- 被执行人姓名/名称
    IDENTI_ID,                                    -- 身份证号码
    LEGAL_REPRE,                                  -- 法定代表人或者负责人姓名
    EXECUTED_COURT,                               -- 执行法院
    ENFORCE_BASIS,                                -- 执行依据文号
    FIL_DT,                                       -- 立案时间
    CASE_NO,                                      -- 案号
    DECI_EXECUTED_UNIT,                           -- 做出执行依据单位
    EFFECT_DOC_OBLI,                              -- 生效法律文书确定的义务
    EXECUTED_PERFOR,                              -- 被执行人的履行情况
    PUBLISH_DT,                                   -- 发布时间
    SEARCH_CASE_YEAR,                             -- 搜案年号
    SEARCH_CASE_NO,                               -- 搜案编号
    PERFORMED_PART,                               -- 已履行部分
    UN_PERFORMED_PART,                            -- 未履行部分
    DISHONEST_ID,                                 -- 失信ID
    GEN,                                          -- 性别
    EXECUTED_NATURE,                              -- 被执行人性质
    BIRTH_DT,                                     -- 出生日期
    DISHONEST_BEHAV                               -- 失信被执行人行为情况
FROM DW_ZJ_FZGG_SXBZXRXX
WHERE UNI_SOCIAL_CRD_CD IS NOT NULL;

-- 验证失信被执行人信息
SELECT
    COUNT(*) AS total_dishonest_records,
    COUNT(DISTINCT UNI_SOCIAL_CRD_CD) AS unique_enterprises
FROM step9_dishonest_person;

-- ========================================
-- Step 10: 创建信用评价信息表
-- ========================================
DROP TABLE IF EXISTS step10_credit_evaluation;
CREATE TABLE step10_credit_evaluation AS
SELECT
    UNI_SOCIAL_CRD_CD,                           -- 统一社会信用代码
    CRED_SCARD,                                   -- 信用分
    EVAL_DT                                       -- 评价时间
FROM DW_NB_DSJ_XYPJXX
WHERE UNI_SOCIAL_CRD_CD IS NOT NULL;

-- 验证信用评价信息
SELECT
    COUNT(*) AS total_credit_records,
    COUNT(DISTINCT UNI_SOCIAL_CRD_CD) AS unique_enterprises
FROM step10_credit_evaluation;

-- ========================================
-- Step 11: 创建纳税信息表
-- ========================================
DROP TABLE IF EXISTS step11_tax_info;
CREATE TABLE step11_tax_info AS
SELECT
    UNI_SOCIAL_CRD_CD,                           -- 统一社会信用代码
    TAX_AMT,                                      -- 纳税总额
    SALE_INCO,                                    -- 销售收入
    COUNT_DT                                      -- 统计时间
FROM DW_NB_SW_NSXX
WHERE UNI_SOCIAL_CRD_CD IS NOT NULL
GROUP BY UNI_SOCIAL_CRD_CD, TAX_AMT, SALE_INCO, COUNT_DT;

-- 验证纳税信息
SELECT
    COUNT(*) AS total_tax_records,
    COUNT(DISTINCT UNI_SOCIAL_CRD_CD) AS unique_enterprises
FROM step11_tax_info;

-- ========================================
-- Step 12: 创建A级纳税人信息表
-- ========================================
DROP TABLE IF EXISTS step12_grade_a_taxpayer;
CREATE TABLE step12_grade_a_taxpayer AS
SELECT
    UNI_SOCIAL_CRD_CD,                           -- 统一社会信用代码
    CREDI_SCARD,                                  -- 信用分
    EVAL_ORG,                                     -- 评价机构
    TAX_CREDI_LEVEL,                              -- 纳税信用等级
    EVAL_YEAR,                                    -- 纳税信用等级评定年度
    EVAL_DT,                                      -- 纳税信用等级评定日期
    MAJOR_TAX_ORG                                 -- 主管税务机关
FROM DW_NB_SW_XYPJXXA
WHERE UNI_SOCIAL_CRD_CD IS NOT NULL;

-- 验证A级纳税人信息
SELECT
    COUNT(*) AS total_grade_a_records,
    COUNT(DISTINCT UNI_SOCIAL_CRD_CD) AS unique_enterprises
FROM step12_grade_a_taxpayer;

-- ========================================
-- Step 13: 创建社保信息表
-- ========================================
DROP TABLE IF EXISTS step13_social_security;
CREATE TABLE step13_social_security AS
SELECT
    UNI_SOCIAL_CRD_CD,                           -- 统一社会信用代码
    PENS_NUM,                                     -- 养老保险人数
    MEDIC_NUM,                                    -- 医疗保险人数
    UNEMPLOY_NUM,                                 -- 失业保险人数
    INJURY_NUM,                                   -- 工伤保险人数
    MATERNI_NUM,                                  -- 生育保险人数
    PENS_PAY_YM,                                  -- 养老保险缴费年月
    MEDIC_PAY_YM,                                 -- 医疗保险缴费年月
    UNEMPLOY_PAY_YM,                              -- 失业保险缴费年月
    INJURY_PAY_YM,                                -- 工伤保险缴费年月
    MATERNI_PAY_YM                                -- 生育保险缴费年月
FROM DW_NB_RLSB_SBJYLYSHBXJBXX
WHERE UNI_SOCIAL_CRD_CD IS NOT NULL;

-- 验证社保信息
SELECT
    COUNT(*) AS total_social_security_records,
    COUNT(DISTINCT UNI_SOCIAL_CRD_CD) AS unique_enterprises
FROM step13_social_security;

-- ========================================
-- Step 14: 创建社保缴费明细表
-- ========================================
DROP TABLE IF EXISTS step14_social_security_detail;
CREATE TABLE step14_social_security_detail AS
SELECT
    UNI_SOCIAL_CRD_CD,                           -- 统一社会信用代码
    ISSU_TYPE,                                    -- 险种类型
    PAY_MONTHS,                                   -- 缴费月数
    PER_PAY_BASIS,                                -- 个人缴费基数
    PAY_AMT,                                      -- 缴费总金额
    UNIT_PAY_AMT,                                 -- 单位应交金额
    PER_PAY_AMT,                                  -- 个人应缴金额
    FEE_PERIOD                                    -- 费款所属期
FROM DW_NB_RLSB_CBGRYJSYBXFHDXX
WHERE UNI_SOCIAL_CRD_CD IS NOT NULL;

-- 验证社保缴费明细
SELECT
    COUNT(*) AS total_social_security_detail_records,
    COUNT(DISTINCT UNI_SOCIAL_CRD_CD) AS unique_enterprises
FROM step14_social_security_detail;

-- ========================================
-- Step 15: 创建行政处罚信息表
-- ========================================
DROP TABLE IF EXISTS step15_administrative_penalty;
CREATE TABLE step15_administrative_penalty AS
SELECT
    UNI_SOCIAL_CRD_CD,                           -- 统一社会信用代码
    ADMIN_PUNISH_DOC,                             -- 行政处罚文号
    PUNISH_REA,                                   -- 处罚原因
    PUNISH_DT,                                    -- 处罚时间
    PUNISH_RESULT                                 -- 处罚结果
FROM DW_NB_SCJDGL_XZCFGSXX
WHERE UNI_SOCIAL_CRD_CD IS NOT NULL;

-- 验证行政处罚信息
SELECT
    COUNT(*) AS total_penalty_records,
    COUNT(DISTINCT UNI_SOCIAL_CRD_CD) AS unique_enterprises
FROM step15_administrative_penalty;

-- ========================================
-- Step 16: 创建最终合并表（逐步合并）
-- ========================================
-- 基于 enterprises 表逐步添加各个维度的信息
-- 每一步都基于前一步的结果进行合并

-- 16.1 先合并基础企业信息和法定代表人信息
-- 数据来源：enterprises (基础企业信息) + step1_legal_rep_info (法定代表人信息)
DROP TABLE IF EXISTS step16_1_enterprises_with_legal_rep;
CREATE TABLE step16_1_enterprises_with_legal_rep AS
SELECT
    ent.*,                                              -- 来自 enterprises 表的所有字段
    lri.PERSONID,                                       -- 来自 step1_legal_rep_info 表
    lri.LEREP_SIGN,
    lri.NM,
    lri.POSITION,
    lri.CERTYPE,
    lri.COUNTRY,
    lri.POSITION_CN,
    lri.CERTYPE_CN,
    lri.COUNTRY_CN,
    lri.CER_NO,
    lri.TEL_NUM,
    lri.MOBTEL,
    lri.EMAIL
FROM enterprises ent                                    -- 基础企业信息表
LEFT JOIN step1_legal_rep_info lri ON ent.UNI_SOCIAL_CRD_CD = lri.UNI_SOCIAL_CRD_CD;

-- 验证合并结果
SELECT
    COUNT(*) AS total_records,
    COUNT(lri.NM) AS records_with_legal_rep
FROM step16_1_enterprises_with_legal_rep;

-- 16.2 添加经营异常信息
-- 数据来源：step16_1_enterprises_with_legal_rep (企业+法定代表人) + step2_business_abnormal (经营异常信息)
DROP TABLE IF EXISTS step16_2_enterprises_with_abnormal;
CREATE TABLE step16_2_enterprises_with_abnormal AS
SELECT
    ewlr.*,                                             -- 来自前一步的所有字段
    ba.INCLU_DT,                                        -- 来自 step2_business_abnormal 表
    ba.INCLU_REASON,
    ba.REDECORG_CN,
    ba.REMEXCPRES_CN,
    ba.REMOVE_DT,
    ba.DECORG_CN
FROM step16_1_enterprises_with_legal_rep ewlr          -- 前一步的结果
LEFT JOIN step2_business_abnormal ba ON ewlr.UNI_SOCIAL_CRD_CD = ba.UNI_SOCIAL_CRD_CD;

-- 验证合并结果
SELECT
    COUNT(*) AS total_records,
    COUNT(ba.INCLU_DT) AS records_with_abnormal
FROM step16_2_enterprises_with_abnormal;

-- 16.3 添加严重违法失信信息
-- 数据来源：step16_2_enterprises_with_abnormal (企业+法定代表人+经营异常) + step3_serious_violation (严重违法失信信息)
DROP TABLE IF EXISTS step16_3_enterprises_with_violation;
CREATE TABLE step16_3_enterprises_with_violation AS
SELECT
    ewa.*,                                             -- 来自前一步的所有字段
    sv.ILL_COMP_ID,                                    -- 来自 step3_serious_violation 表
    sv.ABN_TM,
    sv.SERILL_REA,
    sv.REM_DT,
    sv.RECORG_OGR,
    sv.REM_EXCPRES_REA,
    sv.DECORG_ORG
FROM step16_2_enterprises_with_abnormal ewa           -- 前一步的结果
LEFT JOIN step3_serious_violation sv ON ewa.UNI_SOCIAL_CRD_CD = sv.UNI_SOCIAL_CRD_CD;

-- 验证合并结果
SELECT
    COUNT(*) AS total_records,
    COUNT(sv.ILL_COMP_ID) AS records_with_violation
FROM step16_3_enterprises_with_violation;

-- 16.4 添加网站网店信息
DROP TABLE IF EXISTS step16_4_enterprises_with_website;
CREATE TABLE step16_4_enterprises_with_website AS
SELECT
    ewv.*,
    ws.WEB_ID,
    ws.ANNUAL_ID,
    ws.WEB_STORE_TYPE,
    ws.WEB_STORE_NM,
    ws.WEB_STORE_URL,
    ws.WEB_TYPE,
    ws.WEB_PLAT_TYPE,
    ws.WEB_PRODUCT_TYPE,
    ws.ECOM_TYPE,
    ws.ICP_NO,
    ws.WECHAT_PUBLIC,
    ws.APP_NM,
    ws.PLAT_NM,
    ws.DELI_ADDR,
    ws.RETURN_ADDR,
    ws.PRIPID,
    ws.COMP_NM,
    ws.ANNUAL_YEAR
FROM step16_3_enterprises_with_violation ewv
LEFT JOIN step4_website_shop ws ON ewv.UNI_SOCIAL_CRD_CD = ws.UNI_SOCIAL_CRD_CD;

-- 验证合并结果
SELECT
    COUNT(*) AS total_records,
    COUNT(ws.WEB_ID) AS records_with_website
FROM step16_4_enterprises_with_website;

-- 16.5 添加股权变更信息
DROP TABLE IF EXISTS step16_5_enterprises_with_equity;
CREATE TABLE step16_5_enterprises_with_equity AS
SELECT
    eww.*,
    ec.PRIPID,
    ec.INV,
    ec.ALT_DT,
    ec.PUBLIC_DT,
    ec.TRANSAMPR_BF,
    ec.TRANSAMPR_AF
FROM step16_4_enterprises_with_website eww
LEFT JOIN step5_equity_change ec ON eww.UNI_SOCIAL_CRD_CD = ec.UNI_SOCIAL_CRD_CD;

-- 验证合并结果
SELECT
    COUNT(*) AS total_records,
    COUNT(ec.ALT_DT) AS records_with_equity_change
FROM step16_5_enterprises_with_equity;

-- 16.6 添加年报资产信息
DROP TABLE IF EXISTS step16_6_enterprises_with_annual_report;
CREATE TABLE step16_6_enterprises_with_annual_report AS
SELECT
    ewe.*,
    ara.ANNUAL_YEAR,
    ara.ASSET_ZMT,
    ara.DEBT_AMT,
    ara.OWNER_EQUITY_TOATAL,
    ara.OPT_INCOME_TOTAL,
    ara.PROFIT_TOTAL,
    ara.NET_PROFIT,
    ara.TAX_TOTAL
FROM step16_5_enterprises_with_equity ewe
LEFT JOIN step6_annual_report_assets ara ON ewe.UNI_SOCIAL_CRD_CD = ara.UNI_SOCIAL_CRD_CD;

-- 验证合并结果
SELECT
    COUNT(*) AS total_records,
    COUNT(ara.ANNUAL_YEAR) AS records_with_annual_report
FROM step16_6_enterprises_with_annual_report;

-- 16.7 添加对外担保信息
DROP TABLE IF EXISTS step16_7_enterprises_with_guarantee;
CREATE TABLE step16_7_enterprises_with_guarantee AS
SELECT
    ewar.*,
    gi.CREDITOR,
    gi.DEBTOR,
    gi.MAJOR_CREDIT_TYPE,
    gi.MAJOR_CREDIT_AMT,
    gi.PERIOD_FROM,
    gi.PERIOD_TO,
    gi.PROMIS_DUR,
    gi.IS_PUBLIC,
    gi.PROMIS_WAY,
    gi.ANNUAL_YEAR
FROM step16_6_enterprises_with_annual_report ewar
LEFT JOIN step7_guarantee_info gi ON ewar.UNI_SOCIAL_CRD_CD = gi.UNI_SOCIAL_CRD_CD;

-- 验证合并结果
SELECT
    COUNT(*) AS total_records,
    COUNT(gi.CREDITOR) AS records_with_guarantee
FROM step16_7_enterprises_with_guarantee;

-- 16.8 添加科技型小微企业信息
DROP TABLE IF EXISTS step16_8_enterprises_with_tech;
CREATE TABLE step16_8_enterprises_with_tech AS
SELECT
    ewag.*,
    tse.CONGNIZ_ORG,
    tse.CONGNIZ_TEAR
FROM step16_7_enterprises_with_guarantee ewag
LEFT JOIN step8_tech_small_enterprise tse ON ewag.UNI_SOCIAL_CRD_CD = tse.UNI_SOCIAL_CRD_CD;

-- 验证合并结果
SELECT
    COUNT(*) AS total_records,
    COUNT(tse.CONGNIZ_ORG) AS records_with_tech
FROM step16_8_enterprises_with_tech;

-- 16.9 添加失信被执行人信息
DROP TABLE IF EXISTS step16_9_enterprises_with_dishonest;
CREATE TABLE step16_9_enterprises_with_dishonest AS
SELECT
    ewat.*,
    dp.EXECUTED_NM,
    dp.IDENTI_ID,
    dp.LEGAL_REPRE,
    dp.EXECUTED_COURT,
    dp.ENFORCE_BASIS,
    dp.FIL_DT,
    dp.CASE_NO,
    dp.DECI_EXECUTED_UNIT,
    dp.EFFECT_DOC_OBLI,
    dp.EXECUTED_PERFOR,
    dp.PUBLISH_DT,
    dp.SEARCH_CASE_YEAR,
    dp.SEARCH_CASE_NO,
    dp.PERFORMED_PART,
    dp.UN_PERFORMED_PART,
    dp.DISHONEST_ID,
    dp.GEN,
    dp.EXECUTED_NATURE,
    dp.BIRTH_DT,
    dp.DISHONEST_BEHAV
FROM step16_8_enterprises_with_tech ewat
LEFT JOIN step9_dishonest_person dp ON ewat.UNI_SOCIAL_CRD_CD = dp.UNI_SOCIAL_CRD_CD;

-- 验证合并结果
SELECT
    COUNT(*) AS total_records,
    COUNT(dp.EXECUTED_NM) AS records_with_dishonest
FROM step16_9_enterprises_with_dishonest;

-- 16.10 添加信用评价信息
DROP TABLE IF EXISTS step16_10_enterprises_with_credit;
CREATE TABLE step16_10_enterprises_with_credit AS
SELECT
    ewd.*,
    ce.CRED_SCARD,
    ce.EVAL_DT
FROM step16_9_enterprises_with_dishonest ewd
LEFT JOIN step10_credit_evaluation ce ON ewd.UNI_SOCIAL_CRD_CD = ce.UNI_SOCIAL_CRD_CD;

-- 验证合并结果
SELECT
    COUNT(*) AS total_records,
    COUNT(ce.CRED_SCARD) AS records_with_credit
FROM step16_10_enterprises_with_credit;

-- 16.11 添加纳税信息
DROP TABLE IF EXISTS step16_11_enterprises_with_tax;
CREATE TABLE step16_11_enterprises_with_tax AS
SELECT
    ewc.*,
    ti.TAX_AMT,
    ti.SALE_INCO,
    ti.COUNT_DT
FROM step16_10_enterprises_with_credit ewc
LEFT JOIN step11_tax_info ti ON ewc.UNI_SOCIAL_CRD_CD = ti.UNI_SOCIAL_CRD_CD;

-- 验证合并结果
SELECT
    COUNT(*) AS total_records,
    COUNT(ti.TAX_AMT) AS records_with_tax
FROM step16_11_enterprises_with_tax;

-- 16.12 添加A级纳税人信息
DROP TABLE IF EXISTS step16_12_enterprises_with_grade_a;
CREATE TABLE step16_12_enterprises_with_grade_a AS
SELECT
    ewt.*,
    gat.CREDI_SCARD,
    gat.EVAL_ORG,
    gat.TAX_CREDI_LEVEL,
    gat.EVAL_YEAR,
    gat.EVAL_DT,
    gat.MAJOR_TAX_ORG
FROM step16_11_enterprises_with_tax ewt
LEFT JOIN step12_grade_a_taxpayer gat ON ewt.UNI_SOCIAL_CRD_CD = gat.UNI_SOCIAL_CRD_CD;

-- 验证合并结果
SELECT
    COUNT(*) AS total_records,
    COUNT(gat.TAX_CREDI_LEVEL) AS records_with_grade_a
FROM step16_12_enterprises_with_grade_a;

-- 16.13 添加社保信息
DROP TABLE IF EXISTS step16_13_enterprises_with_social_security;
CREATE TABLE step16_13_enterprises_with_social_security AS
SELECT
    ewg.*,
    ss.PENS_NUM,
    ss.MEDIC_NUM,
    ss.UNEMPLOY_NUM,
    ss.INJURY_NUM,
    ss.MATERNI_NUM,
    ss.PENS_PAY_YM,
    ss.MEDIC_PAY_YM,
    ss.UNEMPLOY_PAY_YM,
    ss.INJURY_PAY_YM,
    ss.MATERNI_PAY_YM
FROM step16_12_enterprises_with_grade_a ewg
LEFT JOIN step13_social_security ss ON ewg.UNI_SOCIAL_CRD_CD = ss.UNI_SOCIAL_CRD_CD;

-- 验证合并结果
SELECT
    COUNT(*) AS total_records,
    COUNT(ss.PENS_NUM) AS records_with_social_security
FROM step16_13_enterprises_with_social_security;

-- 16.14 添加社保缴费明细
DROP TABLE IF EXISTS step16_14_enterprises_with_social_security_detail;
CREATE TABLE step16_14_enterprises_with_social_security_detail AS
SELECT
    ews.*,
    ssd.ISSU_TYPE,
    ssd.PAY_MONTHS,
    ssd.PER_PAY_BASIS,
    ssd.PAY_AMT,
    ssd.UNIT_PAY_AMT,
    ssd.PER_PAY_AMT,
    ssd.FEE_PERIOD
FROM step16_13_enterprises_with_social_security ews
LEFT JOIN step14_social_security_detail ssd ON ews.UNI_SOCIAL_CRD_CD = ssd.UNI_SOCIAL_CRD_CD;

-- 验证合并结果
SELECT
    COUNT(*) AS total_records,
    COUNT(ssd.ISSU_TYPE) AS records_with_social_security_detail
FROM step16_14_enterprises_with_social_security_detail;

-- 16.15 添加行政处罚信息（最终表）
DROP TABLE IF EXISTS step16_15_enterprises_extended_final;
CREATE TABLE step16_15_enterprises_extended_final AS
SELECT
    ewsd.*,
    ap.ADMIN_PUNISH_DOC,
    ap.PUNISH_REA,
    ap.PUNISH_DT,
    ap.PUNISH_RESULT
FROM step16_14_enterprises_with_social_security_detail ewsd
LEFT JOIN step15_administrative_penalty ap ON ewsd.UNI_SOCIAL_CRD_CD = ap.UNI_SOCIAL_CRD_CD;

-- 验证最终合并结果
SELECT
    COUNT(*) AS total_records,
    COUNT(lri.NM) AS records_with_legal_rep,
    COUNT(ba.INCLU_DT) AS records_with_abnormal,
    COUNT(sv.ILL_COMP_ID) AS records_with_violation,
    COUNT(ws.WEB_ID) AS records_with_website,
    COUNT(ec.ALT_DT) AS records_with_equity_change,
    COUNT(ara.ANNUAL_YEAR) AS records_with_annual_report,
    COUNT(gi.CREDITOR) AS records_with_guarantee,
    COUNT(tse.CONGNIZ_ORG) AS records_with_tech,
    COUNT(dp.EXECUTED_NM) AS records_with_dishonest,
    COUNT(ce.CRED_SCARD) AS records_with_credit,
    COUNT(ti.TAX_AMT) AS records_with_tax,
    COUNT(gat.TAX_CREDI_LEVEL) AS records_with_grade_a,
    COUNT(ss.PENS_NUM) AS records_with_social_security,
    COUNT(ssd.ISSU_TYPE) AS records_with_social_security_detail,
    COUNT(ap.ADMIN_PUNISH_DOC) AS records_with_penalty
FROM step16_15_enterprises_extended_final;

-- ========================================
-- 最终结果表重命名
-- ========================================
-- 将最终合并结果重命名为 enterprises_extended
-- 此表包含了 enterprises 表的所有基础信息，以及15个维度的扩展信息
DROP TABLE IF EXISTS enterprises_extended;
CREATE TABLE enterprises_extended AS
SELECT * FROM step16_15_enterprises_extended_final;

-- 显示最终结果
SELECT
    'Final Result' AS step,
    COUNT(*) AS total_enterprises,
    COUNT(DISTINCT UNI_SOCIAL_CRD_CD) AS unique_enterprises
FROM enterprises_extended;

-- 显示表结构
DESCRIBE enterprises_extended;
