-- Step2：扩展 enterprises 表的数据维度（分步聚合版本）
-- 基于已创建的 enterprises 表，分步添加法定代表人、经营异常、行政处罚等详细信息
-- 使用聚合函数避免一对多关系导致的数据膨胀，确保每个企业只有一条记录
-- 分步骤进行便于调试和验证每个表的数据提取情况

-- ==========================================
-- 前置检查：确保 enterprises 表存在
-- ==========================================
-- 检查 enterprises 表是否存在
SELECT
    COUNT(*) AS enterprises_count,
    'enterprises table exists' AS status
FROM enterprises
LIMIT 1;

-- ==========================================
-- Step 1：创建基础扩展表（仅包含企业基本信息）
-- ==========================================
DROP TABLE IF EXISTS step1_enterprises_base;
CREATE TABLE step1_enterprises_base AS
SELECT
    -- 市场主体信息 （来自 enterprises 表）
    REG_ORG,            -- 登记机关
    COMP_TYPE,          -- 企业类型大类（中文）
    REG_STATE,          -- 登记状态（中文）
    UNI_SOCIAL_CRD_CD,  -- 统一社会信用代码
    COMP_NM,            -- 企业名称（字号名称）
    ADDR,               -- 住所（登记、个体户经营场所）
    LEGAL_REPRE,        -- 法定代表人(经营者姓名)
    INDV_ID,            -- 行业代码（中文）
    REG_CAPT,           -- 注册资本(资金数额)
    CAPT_KIND,          -- 币种
    OPT_SCOP,           -- 经营范围
    EST_DT,             -- 成立日期
    OPT_TO,             -- 经营(营业)截止日期
    DOMDI_STRICT,       -- 住所所在行政区划
    OPT_STRICT,         -- 生产经营地所在行政区划
    POSTAL_CODE,        -- 邮政编码
    INDV_NM             -- 行业代码（中文）
FROM enterprises;

-- 验证 Step 1 结果
SELECT
    COUNT(*) AS step1_count,
    'Step 1: Base enterprises created' AS status
FROM step1_enterprises_base;

-- ==========================================
-- Step 2：添加法定代表人信息
-- ==========================================
DROP TABLE IF EXISTS step2_with_legal_rep;
CREATE TABLE step2_with_legal_rep AS
SELECT
    base.*,
    -- 法定代表人信息 （来自 DW_ZJ_SCJDGL_FDDBRXX 表）
    MAX(fddb.NM) AS FDDB_NM,                   -- 姓名
    MAX(fddb.TEL_NUM) AS FDDB_TEL_NUM          -- 固定电话
FROM step1_enterprises_base base
LEFT JOIN DW_ZJ_SCJDGL_FDDBRXX fddb ON base.UNI_SOCIAL_CRD_CD = fddb.UNI_SOCIAL_CRD_CD AND fddb.LEREP_SIGN = 1
GROUP BY
    base.REG_ORG, base.COMP_TYPE, base.REG_STATE, base.UNI_SOCIAL_CRD_CD,
    base.COMP_NM, base.ADDR, base.LEGAL_REPRE, base.INDV_ID, base.REG_CAPT,
    base.CAPT_KIND, base.OPT_SCOP, base.EST_DT, base.OPT_TO, base.DOMDI_STRICT,
    base.OPT_STRICT, base.POSTAL_CODE, base.INDV_NM;

-- 验证 Step 2 结果
SELECT
    COUNT(*) AS step2_count,
    COUNT(FDDB_NM) AS legal_rep_count,
    'Step 2: Legal representative info added' AS status
FROM step2_with_legal_rep;

-- ==========================================
-- Step 3：添加经营异常名录信息
-- ==========================================
DROP TABLE IF EXISTS step3_with_abnormal;
CREATE TABLE step3_with_abnormal AS
SELECT
    base.*,
    -- 经营异常名录信息
    COUNT(jyyc.UNI_SOCIAL_CRD_CD) AS JYYC_COUNT,  -- 经营异常记录数
    -- 子查询版本（获取按日期最新的记录）：
    (SELECT jyyc.INCLU_DT
     FROM DW_ZJ_SCJDGL_JYYCMLXX jyyc
     WHERE jyyc.UNI_SOCIAL_CRD_CD = base.UNI_SOCIAL_CRD_CD
     ORDER BY jyyc.INCLU_DT DESC
     LIMIT 1) AS JYYC_LATEST_INCLU_DT,  -- 最新列入日期
    (SELECT jyyc.INCLU_REASON
     FROM DW_ZJ_SCJDGL_JYYCMLXX jyyc
     WHERE jyyc.UNI_SOCIAL_CRD_CD = base.UNI_SOCIAL_CRD_CD
     ORDER BY jyyc.INCLU_DT DESC
     LIMIT 1) AS JYYC_LATEST_REASON     -- 最新列入原因
FROM step2_with_legal_rep base
LEFT JOIN DW_ZJ_SCJDGL_JYYCMLXX jyyc ON base.UNI_SOCIAL_CRD_CD = jyyc.UNI_SOCIAL_CRD_CD
GROUP BY
    base.REG_ORG, base.COMP_TYPE, base.REG_STATE, base.UNI_SOCIAL_CRD_CD,
    base.COMP_NM, base.ADDR, base.LEGAL_REPRE, base.INDV_ID, base.REG_CAPT,
    base.CAPT_KIND, base.OPT_SCOP, base.EST_DT, base.OPT_TO, base.DOMDI_STRICT,
    base.OPT_STRICT, base.POSTAL_CODE, base.INDV_NM, base.FDDB_NM, base.FDDB_TEL_NUM;

-- 验证 Step 3 结果
SELECT
    COUNT(*) AS step3_count,
    COUNT(JYYC_COUNT) AS abnormal_count,
    'Step 3: Abnormal business info added' AS status
FROM step3_with_abnormal;

-- ==========================================
-- Step 4：添加严重违法失信企业名单信息
-- ==========================================
DROP TABLE IF EXISTS step4_with_violation;
CREATE TABLE step4_with_violation AS
SELECT
    base.*,
    -- 严重违法失信企业名单信息
    COUNT(sxqy.UNI_SOCIAL_CRD_CD) AS SXQY_COUNT, -- 该企业严重违法失信企业名单记录数
    (SELECT sxqy.SERILL_REA
     FROM DW_ZJ_SCJDGL_YZWFSX sxqy
     WHERE sxqy.UNI_SOCIAL_CRD_CD = base.UNI_SOCIAL_CRD_CD
     ORDER BY sxqy.ABN_TM DESC
     LIMIT 1) AS LATEST_SERILL_REA  -- 最新列入严重违法失信企业名单原因（按日期）
FROM step3_with_abnormal base
LEFT JOIN DW_ZJ_SCJDGL_YZWFSX sxqy ON base.UNI_SOCIAL_CRD_CD = sxqy.UNI_SOCIAL_CRD_CD
GROUP BY
    base.REG_ORG, base.COMP_TYPE, base.REG_STATE, base.UNI_SOCIAL_CRD_CD,
    base.COMP_NM, base.ADDR, base.LEGAL_REPRE, base.INDV_ID, base.REG_CAPT,
    base.CAPT_KIND, base.OPT_SCOP, base.EST_DT, base.OPT_TO, base.DOMDI_STRICT,
    base.OPT_STRICT, base.POSTAL_CODE, base.INDV_NM, base.FDDB_NM, base.FDDB_TEL_NUM,
    base.JYYC_COUNT, base.JYYC_LATEST_INCLU_DT, base.JYYC_LATEST_REASON;

-- 验证 Step 4 结果
SELECT
    COUNT(*) AS step4_count,
    COUNT(SXQY_COUNT) AS violation_count,
    'Step 4: Violation info added' AS status
FROM step4_with_violation;

-- ==========================================
-- Step 5：添加网站网店信息
-- ==========================================
DROP TABLE IF EXISTS step5_with_website;
CREATE TABLE step5_with_website AS
SELECT
    base.*,
    -- 企业年报网站或网店信息
    (SELECT wz1.WEB_STORE_URL
     FROM DW_NB_SCJDGL_QYNBWZHWDXX wz1
     WHERE wz1.UNI_SOCIAL_CRD_CD = base.UNI_SOCIAL_CRD_CD
     ORDER BY CAST(wz1.ANNUAL_ID AS INTEGER) DESC
     LIMIT 1) AS WEB_STORE_URL  -- 最新年报年度的网站（网店）网址
FROM step4_with_violation base
LEFT JOIN DW_NB_SCJDGL_QYNBWZHWDXX wz ON base.UNI_SOCIAL_CRD_CD = wz.UNI_SOCIAL_CRD_CD
GROUP BY
    base.REG_ORG, base.COMP_TYPE, base.REG_STATE, base.UNI_SOCIAL_CRD_CD,
    base.COMP_NM, base.ADDR, base.LEGAL_REPRE, base.INDV_ID, base.REG_CAPT,
    base.CAPT_KIND, base.OPT_SCOP, base.EST_DT, base.OPT_TO, base.DOMDI_STRICT,
    base.OPT_STRICT, base.POSTAL_CODE, base.INDV_NM, base.FDDB_NM, base.FDDB_TEL_NUM,
    base.JYYC_COUNT, base.JYYC_LATEST_INCLU_DT, base.JYYC_LATEST_REASON,
    base.SXQY_COUNT, base.LATEST_SERILL_REA;

-- 验证 Step 5 结果
SELECT
    COUNT(*) AS step5_count,
    COUNT(WEB_STORE_URL) AS website_count,
    'Step 5: Website info added' AS status
FROM step5_with_website;

-- ==========================================
-- Step 6：添加股权变更信息
-- ==========================================
DROP TABLE IF EXISTS step6_with_equity;
CREATE TABLE step6_with_equity AS
SELECT
    base.*,
    -- 股权变更信息
    COUNT(gqbg.UNI_SOCIAL_CRD_CD) AS GQBG_COUNT,  -- 股权变更次数
    (SELECT gqbg.ALT_DT
     FROM DW_NB_SCJDGL_GQBG gqbg
     WHERE gqbg.UNI_SOCIAL_CRD_CD = base.UNI_SOCIAL_CRD_CD
     ORDER BY gqbg.ALT_DT DESC
     LIMIT 1) AS LATEST_GQBG_DT  -- 最新股权变更日期
FROM step5_with_website base
LEFT JOIN DW_NB_SCJDGL_GQBG gqbg ON base.UNI_SOCIAL_CRD_CD = gqbg.UNI_SOCIAL_CRD_CD
GROUP BY
    base.REG_ORG, base.COMP_TYPE, base.REG_STATE, base.UNI_SOCIAL_CRD_CD,
    base.COMP_NM, base.ADDR, base.LEGAL_REPRE, base.INDV_ID, base.REG_CAPT,
    base.CAPT_KIND, base.OPT_SCOP, base.EST_DT, base.OPT_TO, base.DOMDI_STRICT,
    base.OPT_STRICT, base.POSTAL_CODE, base.INDV_NM, base.FDDB_NM, base.FDDB_TEL_NUM,
    base.JYYC_COUNT, base.JYYC_LATEST_INCLU_DT, base.JYYC_LATEST_REASON,
    base.SXQY_COUNT, base.LATEST_SERILL_REA, base.WEB_STORE_URL;

-- 验证 Step 6 结果
SELECT
    COUNT(*) AS step6_count,
    COUNT(GQBG_COUNT) AS equity_count,
    'Step 6: Equity change info added' AS status
FROM step6_with_equity;

-- ==========================================
-- Step 7：添加企业年报资产信息
-- ==========================================
DROP TABLE IF EXISTS step7_with_assets;
CREATE TABLE step7_with_assets AS
SELECT
    base.*,
    -- 企业年报资产信息
    (SELECT nb1.ASSET_ZMT
     FROM DW_NB_SCJDGL_QYNBZCXX nb1
     WHERE nb1.UNI_SOCIAL_CRD_CD = base.UNI_SOCIAL_CRD_CD
     ORDER BY nb1.ANNUAL_YEAR DESC
     LIMIT 1) AS ASSET_ZMT,             -- 最新年报年度的资产总额
    (SELECT nb1.DEBT_AMT
     FROM DW_NB_SCJDGL_QYNBZCXX nb1
     WHERE nb1.UNI_SOCIAL_CRD_CD = base.UNI_SOCIAL_CRD_CD
     ORDER BY nb1.ANNUAL_YEAR DESC
     LIMIT 1) AS DEBT_AMT,              -- 最新年报年度的负债总额
    (SELECT nb1.OWNER_EQUITY_TOATAL
     FROM DW_NB_SCJDGL_QYNBZCXX nb1
     WHERE nb1.UNI_SOCIAL_CRD_CD = base.UNI_SOCIAL_CRD_CD
     ORDER BY nb1.ANNUAL_YEAR DESC
     LIMIT 1) AS OWNER_EQUITY_TOATAL,   -- 最新年报年度的所有者权益合计
    (SELECT nb1.OPT_INCOME_TOTAL
     FROM DW_NB_SCJDGL_QYNBZCXX nb1
     WHERE nb1.UNI_SOCIAL_CRD_CD = base.UNI_SOCIAL_CRD_CD
     ORDER BY nb1.ANNUAL_YEAR DESC
     LIMIT 1) AS OPT_INCOME_TOTAL,      -- 最新年报年度的营业总收入
    (SELECT nb1.PROFIT_TOTAL
     FROM DW_NB_SCJDGL_QYNBZCXX nb1
     WHERE nb1.UNI_SOCIAL_CRD_CD = base.UNI_SOCIAL_CRD_CD
     ORDER BY nb1.ANNUAL_YEAR DESC
     LIMIT 1) AS PROFIT_TOTAL,          -- 最新年报年度的利润总额
    (SELECT nb1.NET_PROFIT
     FROM DW_NB_SCJDGL_QYNBZCXX nb1
     WHERE nb1.UNI_SOCIAL_CRD_CD = base.UNI_SOCIAL_CRD_CD
     ORDER BY nb1.ANNUAL_YEAR DESC
     LIMIT 1) AS NET_PROFIT,            -- 最新年报年度的净利润
    (SELECT nb1.TAX_TOTAL
     FROM DW_NB_SCJDGL_QYNBZCXX nb1
     WHERE nb1.UNI_SOCIAL_CRD_CD = base.UNI_SOCIAL_CRD_CD
     ORDER BY nb1.ANNUAL_YEAR DESC
     LIMIT 1) AS TAX_TOTAL,             -- 最新年报年度的纳税总额
    (SELECT nb1.ANNUAL_YEAR
     FROM DW_NB_SCJDGL_QYNBZCXX nb1
     WHERE nb1.UNI_SOCIAL_CRD_CD = base.UNI_SOCIAL_CRD_CD
     ORDER BY nb1.ANNUAL_YEAR DESC
     LIMIT 1) AS ASSET_ANNUAL_YEAR      -- 最新年报年度
FROM step6_with_equity base
LEFT JOIN DW_NB_SCJDGL_QYNBZCXX nb ON base.UNI_SOCIAL_CRD_CD = nb.UNI_SOCIAL_CRD_CD
GROUP BY
    base.REG_ORG, base.COMP_TYPE, base.REG_STATE, base.UNI_SOCIAL_CRD_CD,
    base.COMP_NM, base.ADDR, base.LEGAL_REPRE, base.INDV_ID, base.REG_CAPT,
    base.CAPT_KIND, base.OPT_SCOP, base.EST_DT, base.OPT_TO, base.DOMDI_STRICT,
    base.OPT_STRICT, base.POSTAL_CODE, base.INDV_NM, base.FDDB_NM, base.FDDB_TEL_NUM,
    base.JYYC_COUNT, base.JYYC_LATEST_INCLU_DT, base.JYYC_LATEST_REASON,
    base.SXQY_COUNT, base.LATEST_SERILL_REA, base.WEB_STORE_URL,
    base.GQBG_COUNT, base.LATEST_GQBG_DT;

-- 验证 Step 7 结果
SELECT
    COUNT(*) AS step7_count,
    COUNT(ASSET_ZMT) AS asset_count,
    'Step 7: Asset info added' AS status
FROM step7_with_assets;

-- ==========================================
-- Step 8：添加对外担保信息
-- ==========================================
DROP TABLE IF EXISTS step8_with_guarantee;
CREATE TABLE step8_with_guarantee AS
SELECT
    base.*,
    -- 对外提供保证担保信息
    COUNT(db.UNI_SOCIAL_CRD_CD) AS DB_COUNT,  -- 同一家企业的担保记录数
    (SELECT db1.CREDITOR
     FROM DW_NB_SCJDGL_DWTGBZDBXX db1
     WHERE db1.UNI_SOCIAL_CRD_CD = base.UNI_SOCIAL_CRD_CD
     ORDER BY db1.ANNUAL_YEAR DESC
     LIMIT 1) AS LATEST_CREDITOR,        -- 最新债权人
    (SELECT db1.MAJOR_CREDIT_AMT
     FROM DW_NB_SCJDGL_DWTGBZDBXX db1
     WHERE db1.UNI_SOCIAL_CRD_CD = base.UNI_SOCIAL_CRD_CD
     ORDER BY db1.ANNUAL_YEAR DESC
     LIMIT 1) AS LATEST_CREDIT_AMT       -- 最新主债权数额
FROM step7_with_assets base
LEFT JOIN DW_NB_SCJDGL_DWTGBZDBXX db ON base.UNI_SOCIAL_CRD_CD = db.UNI_SOCIAL_CRD_CD
GROUP BY
    base.REG_ORG, base.COMP_TYPE, base.REG_STATE, base.UNI_SOCIAL_CRD_CD,
    base.COMP_NM, base.ADDR, base.LEGAL_REPRE, base.INDV_ID, base.REG_CAPT,
    base.CAPT_KIND, base.OPT_SCOP, base.EST_DT, base.OPT_TO, base.DOMDI_STRICT,
    base.OPT_STRICT, base.POSTAL_CODE, base.INDV_NM, base.FDDB_NM, base.FDDB_TEL_NUM,
    base.JYYC_COUNT, base.JYYC_LATEST_INCLU_DT, base.JYYC_LATEST_REASON,
    base.SXQY_COUNT, base.LATEST_SERILL_REA, base.WEB_STORE_URL,
    base.GQBG_COUNT, base.LATEST_GQBG_DT, base.ASSET_ZMT, base.DEBT_AMT,
    base.OWNER_EQUITY_TOATAL, base.OPT_INCOME_TOTAL, base.PROFIT_TOTAL,
    base.NET_PROFIT, base.TAX_TOTAL, base.ASSET_ANNUAL_YEAR;

-- 验证 Step 8 结果
SELECT
    COUNT(*) AS step8_count,
    COUNT(DB_COUNT) AS guarantee_count,
    'Step 8: Guarantee info added' AS status
FROM step8_with_guarantee;

-- ==========================================
-- Step 9：添加科技型小微企业信息
-- ==========================================
DROP TABLE IF EXISTS step9_with_tech;
CREATE TABLE step9_with_tech AS
SELECT
    base.*,
    -- 科技型小微企业信息
    MIN(kjzx.CONGNIZ_TEAR) AS CONGNIZ_TEAR  -- 认定年份
FROM step8_with_guarantee base
LEFT JOIN DW_NB_KJ_SGCZKJXZXQY kjzx ON base.UNI_SOCIAL_CRD_CD = kjzx.UNI_SOCIAL_CRD_CD
GROUP BY
    base.REG_ORG, base.COMP_TYPE, base.REG_STATE, base.UNI_SOCIAL_CRD_CD,
    base.COMP_NM, base.ADDR, base.LEGAL_REPRE, base.INDV_ID, base.REG_CAPT,
    base.CAPT_KIND, base.OPT_SCOP, base.EST_DT, base.OPT_TO, base.DOMDI_STRICT,
    base.OPT_STRICT, base.POSTAL_CODE, base.INDV_NM, base.FDDB_NM, base.FDDB_TEL_NUM,
    base.JYYC_COUNT, base.JYYC_LATEST_INCLU_DT, base.JYYC_LATEST_REASON,
    base.SXQY_COUNT, base.LATEST_SERILL_REA, base.WEB_STORE_URL,
    base.GQBG_COUNT, base.LATEST_GQBG_DT, base.ASSET_ZMT, base.DEBT_AMT,
    base.OWNER_EQUITY_TOATAL, base.OPT_INCOME_TOTAL, base.PROFIT_TOTAL,
    base.NET_PROFIT, base.TAX_TOTAL, base.ASSET_ANNUAL_YEAR,
    base.DB_COUNT, base.LATEST_CREDITOR, base.LATEST_CREDIT_AMT;

-- 验证 Step 9 结果
SELECT
    COUNT(*) AS step9_count,
    COUNT(CONGNIZ_TEAR) AS tech_count,
    'Step 9: Tech SME info added' AS status
FROM step9_with_tech;

-- ==========================================
-- Step 10：添加失信被执行人信息
-- ==========================================
DROP TABLE IF EXISTS step10_with_dishonest;
CREATE TABLE step10_with_dishonest AS
SELECT
    base.*,
    -- 失信被执行人信息
    COUNT(sxr.UNI_SOCIAL_CRD_CD) AS SXR_COUNT,  -- 失信记录数
    (SELECT sxr.EXECUTED_NM
     FROM DW_ZJ_FZGG_SXBZXRXX sxr
     WHERE sxr.UNI_SOCIAL_CRD_CD = base.UNI_SOCIAL_CRD_CD
     ORDER BY sxr.FIL_DT DESC
     LIMIT 1) AS LATEST_EXECUTED_NM,  -- 最新被执行人姓名
    (SELECT sxr.EXECUTED_COURT
     FROM DW_ZJ_FZGG_SXBZXRXX sxr
     WHERE sxr.UNI_SOCIAL_CRD_CD = base.UNI_SOCIAL_CRD_CD
     ORDER BY sxr.FIL_DT DESC
     LIMIT 1) AS LATEST_EXECUTED_COURT,  -- 最新执行法院
    (SELECT sxr.FIL_DT
     FROM DW_ZJ_FZGG_SXBZXRXX sxr
     WHERE sxr.UNI_SOCIAL_CRD_CD = base.UNI_SOCIAL_CRD_CD
     ORDER BY sxr.FIL_DT DESC
     LIMIT 1) AS LATEST_FIL_DT  -- 最新立案时间
FROM step9_with_tech base
LEFT JOIN DW_ZJ_FZGG_SXBZXRXX sxr ON base.UNI_SOCIAL_CRD_CD = sxr.UNI_SOCIAL_CRD_CD
GROUP BY
    base.REG_ORG, base.COMP_TYPE, base.REG_STATE, base.UNI_SOCIAL_CRD_CD,
    base.COMP_NM, base.ADDR, base.LEGAL_REPRE, base.INDV_ID, base.REG_CAPT,
    base.CAPT_KIND, base.OPT_SCOP, base.EST_DT, base.OPT_TO, base.DOMDI_STRICT,
    base.OPT_STRICT, base.POSTAL_CODE, base.INDV_NM, base.FDDB_NM, base.FDDB_TEL_NUM,
    base.JYYC_COUNT, base.JYYC_LATEST_INCLU_DT, base.JYYC_LATEST_REASON,
    base.SXQY_COUNT, base.LATEST_SERILL_REA, base.WEB_STORE_URL,
    base.GQBG_COUNT, base.LATEST_GQBG_DT, base.ASSET_ZMT, base.DEBT_AMT,
    base.OWNER_EQUITY_TOATAL, base.OPT_INCOME_TOTAL, base.PROFIT_TOTAL,
    base.NET_PROFIT, base.TAX_TOTAL, base.ASSET_ANNUAL_YEAR,
    base.DB_COUNT, base.LATEST_CREDITOR, base.LATEST_CREDIT_AMT, base.CONGNIZ_TEAR;

-- 验证 Step 10 结果
SELECT
    COUNT(*) AS step10_count,
    COUNT(SXR_COUNT) AS dishonest_count,
    'Step 10: Dishonest execution info added' AS status
FROM step10_with_dishonest;

-- ==========================================
-- Step 11：添加纳税信息
-- ==========================================
DROP TABLE IF EXISTS step11_with_tax;
CREATE TABLE step11_with_tax AS
SELECT
    base.*,
    -- 纳税信息
    (SELECT ns1.TAX_AMT
     FROM DW_NB_SW_NSXX ns1
     WHERE ns1.UNI_SOCIAL_CRD_CD = base.UNI_SOCIAL_CRD_CD
     ORDER BY ns1.COUNT_DT DESC
     LIMIT 1) AS TAX_AMT,                 -- 最新纳税总额
    (SELECT ns1.SALE_INCO
     FROM DW_NB_SW_NSXX ns1
     WHERE ns1.UNI_SOCIAL_CRD_CD = base.UNI_SOCIAL_CRD_CD
     ORDER BY ns1.COUNT_DT DESC
     LIMIT 1) AS SALE_INCO,             -- 最新销售收入
    (SELECT ns1.COUNT_DT
     FROM DW_NB_SW_NSXX ns1
     WHERE ns1.UNI_SOCIAL_CRD_CD = base.UNI_SOCIAL_CRD_CD
     ORDER BY ns1.COUNT_DT DESC
     LIMIT 1) AS COUNT_DT                -- 最新统计时间
FROM step10_with_dishonest base
LEFT JOIN DW_NB_SW_NSXX ns ON base.UNI_SOCIAL_CRD_CD = ns.UNI_SOCIAL_CRD_CD
GROUP BY
    base.REG_ORG, base.COMP_TYPE, base.REG_STATE, base.UNI_SOCIAL_CRD_CD,
    base.COMP_NM, base.ADDR, base.LEGAL_REPRE, base.INDV_ID, base.REG_CAPT,
    base.CAPT_KIND, base.OPT_SCOP, base.EST_DT, base.OPT_TO, base.DOMDI_STRICT,
    base.OPT_STRICT, base.POSTAL_CODE, base.INDV_NM, base.FDDB_NM, base.FDDB_TEL_NUM,
    base.JYYC_COUNT, base.JYYC_LATEST_INCLU_DT, base.JYYC_LATEST_REASON,
    base.SXQY_COUNT, base.LATEST_SERILL_REA, base.WEB_STORE_URL,
    base.GQBG_COUNT, base.LATEST_GQBG_DT, base.ASSET_ZMT, base.DEBT_AMT,
    base.OWNER_EQUITY_TOATAL, base.OPT_INCOME_TOTAL, base.PROFIT_TOTAL,
    base.NET_PROFIT, base.TAX_TOTAL, base.ASSET_ANNUAL_YEAR,
    base.DB_COUNT, base.LATEST_CREDITOR, base.LATEST_CREDIT_AMT, base.CONGNIZ_TEAR,
    base.SXR_COUNT, base.LATEST_EXECUTED_NM, base.LATEST_EXECUTED_COURT, base.LATEST_FIL_DT;

-- 验证 Step 11 结果
SELECT
    COUNT(*) AS step11_count,
    COUNT(TAX_AMT) AS tax_count,
    'Step 11: Tax info added' AS status
FROM step11_with_tax;

-- ==========================================
-- Step 12：添加信用评价信息
-- ==========================================
DROP TABLE IF EXISTS step12_with_credit;
CREATE TABLE step12_with_credit AS
SELECT
    base.*,
    -- 信用评价信息
    (SELECT xypj1.CRED_SCARD
     FROM DW_NB_DSJ_XYPJXX xypj1
     WHERE xypj1.UNI_SOCIAL_CRD_CD = base.UNI_SOCIAL_CRD_CD
     ORDER BY xypj1.EVAL_DT DESC
     LIMIT 1) AS CRED_SCARD,         -- 最新评价日期的信用分
    -- 信用评价信息（A级纳税人）
    (SELECT xypja1.CREDI_SCARD
     FROM DW_NB_SW_XYPJXXA xypja1
     WHERE xypja1.UNI_SOCIAL_CRD_CD = base.UNI_SOCIAL_CRD_CD
     ORDER BY xypja1.EVAL_DT DESC
     LIMIT 1) AS TAX_CREDI_SCARD,  -- 最新评定日期的纳税信用分
    (SELECT xypja1.TAX_CREDI_LEVEL
     FROM DW_NB_SW_XYPJXXA xypja1
     WHERE xypja1.UNI_SOCIAL_CRD_CD = base.UNI_SOCIAL_CRD_CD
     ORDER BY xypja1.EVAL_DT DESC
     LIMIT 1) AS TAX_CREDI_LEVEL, -- 最新评定日期的纳税信用等级
    (SELECT xypja1.EVAL_YEAR
     FROM DW_NB_SW_XYPJXXA xypja1
     WHERE xypja1.UNI_SOCIAL_CRD_CD = base.UNI_SOCIAL_CRD_CD
     ORDER BY xypja1.EVAL_DT DESC
     LIMIT 1) AS EVAL_YEAR          -- 最新评定日期的纳税信用等级评定年度
FROM step11_with_tax base
LEFT JOIN DW_NB_DSJ_XYPJXX xypj ON base.UNI_SOCIAL_CRD_CD = xypj.UNI_SOCIAL_CRD_CD
LEFT JOIN DW_NB_SW_XYPJXXA xypja ON base.UNI_SOCIAL_CRD_CD = xypja.UNI_SOCIAL_CRD_CD
GROUP BY
    base.REG_ORG, base.COMP_TYPE, base.REG_STATE, base.UNI_SOCIAL_CRD_CD,
    base.COMP_NM, base.ADDR, base.LEGAL_REPRE, base.INDV_ID, base.REG_CAPT,
    base.CAPT_KIND, base.OPT_SCOP, base.EST_DT, base.OPT_TO, base.DOMDI_STRICT,
    base.OPT_STRICT, base.POSTAL_CODE, base.INDV_NM, base.FDDB_NM, base.FDDB_TEL_NUM,
    base.JYYC_COUNT, base.JYYC_LATEST_INCLU_DT, base.JYYC_LATEST_REASON,
    base.SXQY_COUNT, base.LATEST_SERILL_REA, base.WEB_STORE_URL,
    base.GQBG_COUNT, base.LATEST_GQBG_DT, base.ASSET_ZMT, base.DEBT_AMT,
    base.OWNER_EQUITY_TOATAL, base.OPT_INCOME_TOTAL, base.PROFIT_TOTAL,
    base.NET_PROFIT, base.TAX_TOTAL, base.ASSET_ANNUAL_YEAR,
    base.DB_COUNT, base.LATEST_CREDITOR, base.LATEST_CREDIT_AMT, base.CONGNIZ_TEAR,
    base.SXR_COUNT, base.LATEST_EXECUTED_NM, base.LATEST_EXECUTED_COURT, base.LATEST_FIL_DT,
    base.TAX_AMT, base.SALE_INCO, base.COUNT_DT;

-- 验证 Step 12 结果
SELECT
    COUNT(*) AS step12_count,
    COUNT(CRED_SCARD) AS credit_count,
    'Step 12: Credit evaluation info added' AS status
FROM step12_with_credit;

-- ==========================================
-- Step 13：添加社会保险信息
-- ==========================================
DROP TABLE IF EXISTS step13_with_social;
CREATE TABLE step13_with_social AS
SELECT
    base.*,
    -- 社会保险基本信息
    (SELECT sb1.PENS_NUM
     FROM DW_NB_RLSB_SBJYLYSHBXJBXX sb1
     WHERE sb1.UNI_SOCIAL_CRD_CD = base.UNI_SOCIAL_CRD_CD
     ORDER BY sb1.PENS_PAY_YM DESC
     LIMIT 1) AS PENS_NUM               -- 最新养老保险缴费年月的养老保险人数
FROM step12_with_credit base
LEFT JOIN DW_NB_RLSB_SBJYLYSHBXJBXX sb ON base.UNI_SOCIAL_CRD_CD = sb.UNI_SOCIAL_CRD_CD
GROUP BY
    base.REG_ORG, base.COMP_TYPE, base.REG_STATE, base.UNI_SOCIAL_CRD_CD,
    base.COMP_NM, base.ADDR, base.LEGAL_REPRE, base.INDV_ID, base.REG_CAPT,
    base.CAPT_KIND, base.OPT_SCOP, base.EST_DT, base.OPT_TO, base.DOMDI_STRICT,
    base.OPT_STRICT, base.POSTAL_CODE, base.INDV_NM, base.FDDB_NM, base.FDDB_TEL_NUM,
    base.JYYC_COUNT, base.JYYC_LATEST_INCLU_DT, base.JYYC_LATEST_REASON,
    base.SXQY_COUNT, base.LATEST_SERILL_REA, base.WEB_STORE_URL,
    base.GQBG_COUNT, base.LATEST_GQBG_DT, base.ASSET_ZMT, base.DEBT_AMT,
    base.OWNER_EQUITY_TOATAL, base.OPT_INCOME_TOTAL, base.PROFIT_TOTAL,
    base.NET_PROFIT, base.TAX_TOTAL, base.ASSET_ANNUAL_YEAR,
    base.DB_COUNT, base.LATEST_CREDITOR, base.LATEST_CREDIT_AMT, base.CONGNIZ_TEAR,
    base.SXR_COUNT, base.LATEST_EXECUTED_NM, base.LATEST_EXECUTED_COURT, base.LATEST_FIL_DT,
    base.TAX_AMT, base.SALE_INCO, base.COUNT_DT, base.CRED_SCARD,
    base.TAX_CREDI_SCARD, base.TAX_CREDI_LEVEL, base.EVAL_YEAR;

-- 验证 Step 13 结果
SELECT
    COUNT(*) AS step13_count,
    COUNT(PENS_NUM) AS social_count,
    'Step 13: Social insurance info added' AS status
FROM step13_with_social;

-- ==========================================
-- Step 14：添加行政处罚信息
-- ==========================================
DROP TABLE IF EXISTS step14_with_punishment;
CREATE TABLE step14_with_punishment AS
SELECT
    base.*,
    -- 行政处罚公示信息
    COUNT(xzcf.UNI_SOCIAL_CRD_CD) AS XZCF_COUNT, -- 行政处罚次数
    (SELECT xzcf.ADMIN_PUNISH_DOC
     FROM DW_NB_SCJDGL_XZCFGSXX xzcf
     WHERE xzcf.UNI_SOCIAL_CRD_CD = base.UNI_SOCIAL_CRD_CD
     ORDER BY xzcf.PUNISH_DT DESC
     LIMIT 1) AS LATEST_PUNISH_DOC, -- 最新行政处罚文号
    (SELECT xzcf.PUNISH_DT
     FROM DW_NB_SCJDGL_XZCFGSXX xzcf
     WHERE xzcf.UNI_SOCIAL_CRD_CD = base.UNI_SOCIAL_CRD_CD
     ORDER BY xzcf.PUNISH_DT DESC
     LIMIT 1) AS LATEST_PUNISH_DT,    -- 最新处罚时间
    (SELECT xzcf.PUNISH_REA
     FROM DW_NB_SCJDGL_XZCFGSXX xzcf
     WHERE xzcf.UNI_SOCIAL_CRD_CD = base.UNI_SOCIAL_CRD_CD
     ORDER BY xzcf.PUNISH_DT DESC
     LIMIT 1) AS LATEST_PUNISH_REA   -- 最新处罚原因
FROM step13_with_social base
LEFT JOIN DW_NB_SCJDGL_XZCFGSXX xzcf ON base.UNI_SOCIAL_CRD_CD = xzcf.UNI_SOCIAL_CRD_CD
GROUP BY
    base.REG_ORG, base.COMP_TYPE, base.REG_STATE, base.UNI_SOCIAL_CRD_CD,
    base.COMP_NM, base.ADDR, base.LEGAL_REPRE, base.INDV_ID, base.REG_CAPT,
    base.CAPT_KIND, base.OPT_SCOP, base.EST_DT, base.OPT_TO, base.DOMDI_STRICT,
    base.OPT_STRICT, base.POSTAL_CODE, base.INDV_NM, base.FDDB_NM, base.FDDB_TEL_NUM,
    base.JYYC_COUNT, base.JYYC_LATEST_INCLU_DT, base.JYYC_LATEST_REASON,
    base.SXQY_COUNT, base.LATEST_SERILL_REA, base.WEB_STORE_URL,
    base.GQBG_COUNT, base.LATEST_GQBG_DT, base.ASSET_ZMT, base.DEBT_AMT,
    base.OWNER_EQUITY_TOATAL, base.OPT_INCOME_TOTAL, base.PROFIT_TOTAL,
    base.NET_PROFIT, base.TAX_TOTAL, base.ASSET_ANNUAL_YEAR,
    base.DB_COUNT, base.LATEST_CREDITOR, base.LATEST_CREDIT_AMT, base.CONGNIZ_TEAR,
    base.SXR_COUNT, base.LATEST_EXECUTED_NM, base.LATEST_EXECUTED_COURT, base.LATEST_FIL_DT,
    base.TAX_AMT, base.SALE_INCO, base.COUNT_DT, base.CRED_SCARD,
    base.TAX_CREDI_SCARD, base.TAX_CREDI_LEVEL, base.EVAL_YEAR, base.PENS_NUM;

-- 验证 Step 14 结果
SELECT
    COUNT(*) AS step14_count,
    COUNT(XZCF_COUNT) AS punishment_count,
    'Step 14: Administrative punishment info added' AS status
FROM step14_with_punishment;

-- ==========================================
-- Step 15：创建最终扩展表
-- ==========================================
DROP TABLE IF EXISTS enterprises_extended;
CREATE TABLE enterprises_extended AS
SELECT * FROM step14_with_punishment;

-- 验证最终结果
SELECT
    COUNT(*) AS total_enterprises_extended,
    COUNT(DISTINCT UNI_SOCIAL_CRD_CD) AS unique_enterprises,
    COUNT(DISTINCT INDV_NM) AS unique_industry_codes,
    'Final: All steps completed' AS status
FROM enterprises_extended;

-- 显示表结构
DESCRIBE enterprises_extended;

-- 显示前10条记录
SELECT * FROM enterprises_extended LIMIT 10;

-- ==========================================
-- 清理中间表（可选）
-- ==========================================
-- 如果需要清理中间表，可以取消注释以下语句
-- DROP TABLE IF EXISTS step1_enterprises_base;
-- DROP TABLE IF EXISTS step2_with_legal_rep;
-- DROP TABLE IF EXISTS step3_with_abnormal;
-- DROP TABLE IF EXISTS step4_with_violation;
-- DROP TABLE IF EXISTS step5_with_website;
-- DROP TABLE IF EXISTS step6_with_equity;
-- DROP TABLE IF EXISTS step7_with_assets;
-- DROP TABLE IF EXISTS step8_with_guarantee;
-- DROP TABLE IF EXISTS step9_with_tech;
-- DROP TABLE IF EXISTS step10_with_dishonest;
-- DROP TABLE IF EXISTS step11_with_tax;
-- DROP TABLE IF EXISTS step12_with_credit;
-- DROP TABLE IF EXISTS step13_with_social;
-- DROP TABLE IF EXISTS step14_with_punishment;