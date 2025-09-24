-- Step2：扩展 company 表的数据维度
-- 基于已创建的 company 表，添加法定代表人、经营异常、行政处罚等详细信息
-- 不使用别名，保持原字段名，通过注释说明字段含义
-- 将扩展后的结果创建为新表 company_extended

-- ==========================================

-- 删除表（如果已存在）
DROP TABLE IF EXISTS company_extended;

-- 创建 company_extended 表，包含所有扩展维度信息
-- 使用聚合函数避免一对多关系导致的数据膨胀，确保每个企业只有一条记录
CREATE TABLE company_extended AS
SELECT
    -- 市场主体信息 （来自 company 表）
    ent.reg_org,            -- 登记机关
    ent.comp_type,          -- 企业类型大类（中文）
    ent.reg_state,          -- 登记状态（中文）
    ent.uni_social_crd_cd,  -- 统一社会信用代码
    ent.comp_nm,            -- 企业名称（字号名称）
    ent.addr,               -- 住所（登记、个体户经营场所）
    ent.legal_repre,        -- 法定代表人(经营者姓名)
    ent.indv_id,            -- 行业代码（中文）
    ent.reg_capt,           -- 注册资本(资金数额)
    ent.capt_kind,          -- 币种
    ent.opt_scop,           -- 经营范围
    -- ent.REG_NO,             -- 注册号
    -- ent.APPR_DT,            -- 核准日期（登记、吊销、注销日期）
    ent.est_dt,             -- 成立日期
    -- ent.OPT_FROM,           -- 经营(营业)起始日期
    ent.OPT_TO,             -- 经营(营业)截止日期
    ent.domdi_strict,       -- 住所所在行政区划
    -- ent.PRO_LOC,            -- 生产经营地
    ent.opt_strict,         -- 生产经营地所在行政区划
    ent.postal_code,        -- 邮政编码
    -- ent.OPT_LOC,            -- 经营场所
    ent.indv_nm,            -- 行业代码（中文）

    -- 法定代表人信息 （来自 DW_ZJ_SCJDGL_FDDBRXX 表）
    -- MAX(fddb.LEREP_SIGN) AS LEREP_SIGN,        -- 法定代表人标志/首席代表标志/负责人标识
    MAX(fddb.NM) AS fddb_nm,                   -- 姓名
    -- MAX(fddb.CER_NO) AS FDDB_CER_NO,           -- 身份证件号码
    MAX(fddb.tel_num) AS fddb_tel_num,         -- 固定电话

    -- 经营异常名录信息 （来自 DW_ZJ_SCJDGL_JYYCMLXX 表）
    COUNT(jyyc.uni_social_crd_cd) AS jyyc_count,  -- 经营异常记录数

    -- 子查询版本（获取按日期最新的记录）：
    (SELECT jyyc.inclu_dt
     FROM DW_ZJ_SCJDGL_JYYCMLXX jyyc
     WHERE jyyc.uni_social_crd_cd = ent.uni_social_crd_cd
     ORDER BY jyyc.inclu_dt DESC
     LIMIT 1) AS jyyc_latest_inclu_dt,  -- 最新列入日期
    (SELECT jyyc.INCLU_REASON
     FROM DW_ZJ_SCJDGL_JYYCMLXX jyyc
     WHERE jyyc.UNI_SOCIAL_CRD_CD = ent.UNI_SOCIAL_CRD_CD
     ORDER BY jyyc.INCLU_DT DESC
     LIMIT 1) AS JYYC_LATEST_REASON, -- 最新列入原因

    -- 严重违法失信企业名单信息 （来自 DW_ZJ_SCJDGL_YZWFSX 表）
    COUNT(sxqy.UNI_SOCIAL_CRD_CD) AS SXQY_COUNT, -- 该企业严重违法失信企业名单记录数

    (SELECT sxqy.SERILL_REA
     FROM DW_ZJ_SCJDGL_YZWFSX sxqy
     WHERE sxqy.UNI_SOCIAL_CRD_CD = ent.UNI_SOCIAL_CRD_CD
     ORDER BY sxqy.ABN_TM DESC
     LIMIT 1) AS LATEST_SERILL_REA,  -- 最新列入严重违法失信企业名单原因（按日期）

    -- 企业年报网站或网店信息 （来自 DW_NB_SCJDGL_QYNBWZHWDXX 表）

    -- (SELECT wz1.WEB_STORE_NM
    --  FROM DW_NB_SCJDGL_QYNBWZHWDXX wz1
    --  WHERE wz1.UNI_SOCIAL_CRD_CD = ent.UNI_SOCIAL_CRD_CD
    --  ORDER BY CAST(wz1.ANNUAL_ID AS INTEGER) DESC
    --  LIMIT 1) AS WEB_STORE_NM,                  -- 最新年报年度的网站（网店）名称
    (SELECT wz1.WEB_STORE_URL
     FROM DW_NB_SCJDGL_QYNBWZHWDXX wz1
     WHERE wz1.UNI_SOCIAL_CRD_CD = ent.UNI_SOCIAL_CRD_CD
     ORDER BY CAST(wz1.ANNUAL_ID AS INTEGER) DESC
     LIMIT 1) AS WEB_STORE_URL,                 -- 最新年报年度的网站（网店）网址
    -- (SELECT wz1.WEB_TYPE
    --  FROM DW_NB_SCJDGL_QYNBWZHWDXX wz1
    --  WHERE wz1.UNI_SOCIAL_CRD_CD = ent.UNI_SOCIAL_CRD_CD
    --  ORDER BY CAST(wz1.ANNUAL_ID AS INTEGER) DESC
    --  LIMIT 1) AS WEB_TYPE,                      -- 最新年报年度的网站类型
    -- (SELECT wz1.ECOM_TYPE
    --  FROM DW_NB_SCJDGL_QYNBWZHWDXX wz1
    --  WHERE wz1.UNI_SOCIAL_CRD_CD = ent.UNI_SOCIAL_CRD_CD
    --  ORDER BY CAST(wz1.ANNUAL_ID AS INTEGER) DESC
    --  LIMIT 1) AS ECOM_TYPE,                     -- 最新年报年度的电商类型

    -- 股权变更信息 （来自 DW_NB_SCJDGL_GQBG 表）
    COUNT(gqbg.UNI_SOCIAL_CRD_CD) AS GQBG_COUNT,              -- 股权变更次数

    (SELECT gqbg.ALT_DT
     FROM DW_NB_SCJDGL_GQBG gqbg
     WHERE gqbg.UNI_SOCIAL_CRD_CD = ent.UNI_SOCIAL_CRD_CD
     ORDER BY gqbg.ALT_DT DESC
     LIMIT 1) AS LATEST_GQBG_DT,         -- 最新股权变更日期
    -- (SELECT gqbg.INV
    --  FROM DW_NB_SCJDGL_GQBG gqbg
    --  WHERE gqbg.UNI_SOCIAL_CRD_CD = ent.UNI_SOCIAL_CRD_CD
    --  ORDER BY gqbg.ALT_DT DESC
    --  LIMIT 1) AS LATEST_INV,                -- 最新股东

    -- 企业年报资产信息 （来自 DW_NB_SCJDGL_QYNBZCXX 表）
    (SELECT nb1.ASSET_ZMT
     FROM DW_NB_SCJDGL_QYNBZCXX nb1
     WHERE nb1.UNI_SOCIAL_CRD_CD = ent.UNI_SOCIAL_CRD_CD
     ORDER BY nb1.ANNUAL_YEAR DESC
     LIMIT 1) AS ASSET_ZMT,             -- 最新年报年度的资产总额
    (SELECT nb1.DEBT_AMT
     FROM DW_NB_SCJDGL_QYNBZCXX nb1
     WHERE nb1.UNI_SOCIAL_CRD_CD = ent.UNI_SOCIAL_CRD_CD
     ORDER BY nb1.ANNUAL_YEAR DESC
     LIMIT 1) AS DEBT_AMT,              -- 最新年报年度的负债总额
    (SELECT nb1.OWNER_EQUITY_TOATAL
     FROM DW_NB_SCJDGL_QYNBZCXX nb1
     WHERE nb1.UNI_SOCIAL_CRD_CD = ent.UNI_SOCIAL_CRD_CD
     ORDER BY nb1.ANNUAL_YEAR DESC
     LIMIT 1) AS OWNER_EQUITY_TOATAL,   -- 最新年报年度的所有者权益合计
    (SELECT nb1.OPT_INCOME_TOTAL
     FROM DW_NB_SCJDGL_QYNBZCXX nb1
     WHERE nb1.UNI_SOCIAL_CRD_CD = ent.UNI_SOCIAL_CRD_CD
     ORDER BY nb1.ANNUAL_YEAR DESC
     LIMIT 1) AS OPT_INCOME_TOTAL,      -- 最新年报年度的营业总收入
    (SELECT nb1.PROFIT_TOTAL
     FROM DW_NB_SCJDGL_QYNBZCXX nb1
     WHERE nb1.UNI_SOCIAL_CRD_CD = ent.UNI_SOCIAL_CRD_CD
     ORDER BY nb1.ANNUAL_YEAR DESC
     LIMIT 1) AS PROFIT_TOTAL,          -- 最新年报年度的利润总额
    (SELECT nb1.NET_PROFIT
     FROM DW_NB_SCJDGL_QYNBZCXX nb1
     WHERE nb1.UNI_SOCIAL_CRD_CD = ent.UNI_SOCIAL_CRD_CD
     ORDER BY nb1.ANNUAL_YEAR DESC
     LIMIT 1) AS NET_PROFIT,            -- 最新年报年度的净利润
    (SELECT nb1.TAX_TOTAL
     FROM DW_NB_SCJDGL_QYNBZCXX nb1
     WHERE nb1.UNI_SOCIAL_CRD_CD = ent.UNI_SOCIAL_CRD_CD
     ORDER BY nb1.ANNUAL_YEAR DESC
     LIMIT 1) AS TAX_TOTAL,             -- 最新年报年度的纳税总额
    (SELECT nb1.ANNUAL_YEAR
     FROM DW_NB_SCJDGL_QYNBZCXX nb1
     WHERE nb1.UNI_SOCIAL_CRD_CD = ent.UNI_SOCIAL_CRD_CD
     ORDER BY nb1.ANNUAL_YEAR DESC
     LIMIT 1) AS ASSET_ANNUAL_YEAR,     -- 最新年报年度

    -- 对外提供保证担保信息 （来自 DW_NB_SCJDGL_DWTGBZDBXX 表）
    COUNT(db.UNI_SOCIAL_CRD_CD) AS DB_COUNT,  -- 同一家企业的担保记录数
    (SELECT db1.CREDITOR
     FROM DW_NB_SCJDGL_DWTGBZDBXX db1
     WHERE db1.UNI_SOCIAL_CRD_CD = ent.UNI_SOCIAL_CRD_CD
     ORDER BY db1.ANNUAL_YEAR DESC
     LIMIT 1) AS LATEST_CREDITOR,        -- 最新债权人
    (SELECT db1.MAJOR_CREDIT_AMT
     FROM DW_NB_SCJDGL_DWTGBZDBXX db1
     WHERE db1.UNI_SOCIAL_CRD_CD = ent.UNI_SOCIAL_CRD_CD
     ORDER BY db1.ANNUAL_YEAR DESC
     LIMIT 1) AS LATEST_CREDIT_AMT, -- 最新主债权数额

    -- 科技型小微企业信息 （来自 DW_NB_KJ_SGCZKJXZXQY 表）
    -- MAX(kjzx.CONGNIZ_ORG) AS CONGNIZ_ORG,       -- 认定机构
    MIN(kjzx.CONGNIZ_TEAR) AS CONGNIZ_TEAR,     -- 认定年份

    -- 失信被执行人信息 （来自 DW_ZJ_FZGG_SXBZXRXX 表）
    COUNT(sxr.UNI_SOCIAL_CRD_CD) AS SXR_COUNT,        -- 失信记录数

    -- 子查询版本（获取按日期最新的记录）：
    (SELECT sxr.EXECUTED_NM
     FROM DW_ZJ_FZGG_SXBZXRXX sxr
     WHERE sxr.UNI_SOCIAL_CRD_CD = ent.UNI_SOCIAL_CRD_CD
     ORDER BY sxr.FIL_DT DESC
     LIMIT 1) AS LATEST_EXECUTED_NM, -- 最新被执行人姓名
    (SELECT sxr.EXECUTED_COURT
     FROM DW_ZJ_FZGG_SXBZXRXX sxr
     WHERE sxr.UNI_SOCIAL_CRD_CD = ent.UNI_SOCIAL_CRD_CD
     ORDER BY sxr.FIL_DT DESC
     LIMIT 1) AS LATEST_EXECUTED_COURT, -- 最新执行法院
    (SELECT sxr.FIL_DT
     FROM DW_ZJ_FZGG_SXBZXRXX sxr
     WHERE sxr.UNI_SOCIAL_CRD_CD = ent.UNI_SOCIAL_CRD_CD
     ORDER BY sxr.FIL_DT DESC
     LIMIT 1) AS LATEST_FIL_DT,           -- 最新立案时间

    -- 纳税信息 （来自 DW_NB_SW_NSXX 表）
    (SELECT ns1.TAX_AMT
     FROM DW_NB_SW_NSXX ns1
     WHERE ns1.UNI_SOCIAL_CRD_CD = ent.UNI_SOCIAL_CRD_CD
     ORDER BY ns1.COUNT_DT DESC
     LIMIT 1) AS TAX_AMT,                 -- 最新纳税总额
    (SELECT ns1.SALE_INCO
     FROM DW_NB_SW_NSXX ns1
     WHERE ns1.UNI_SOCIAL_CRD_CD = ent.UNI_SOCIAL_CRD_CD
     ORDER BY ns1.COUNT_DT DESC
     LIMIT 1) AS SALE_INCO,             -- 最新销售收入
    (SELECT ns1.COUNT_DT
     FROM DW_NB_SW_NSXX ns1
     WHERE ns1.UNI_SOCIAL_CRD_CD = ent.UNI_SOCIAL_CRD_CD
     ORDER BY ns1.COUNT_DT DESC
     LIMIT 1) AS count_dt,               -- 最新统计时间

    -- 信用评价信息（来自 DW_NB_DSJ_XYPJXX 表）
    (SELECT xypj1.cred_scard
     FROM dw_nb_dsj_xypjxx xypj1
     WHERE xypj1.uni_social_crd_cd = ent.uni_social_crd_cd
     ORDER BY xypj1.eval_dt DESC
     LIMIT 1) AS cred_scard,         -- 最新评价日期的信用分

    -- 信用评价信息（A级纳税人） （来自 DW_NB_SW_XYPJXXA 表）
    (SELECT xypja1.credi_scard
     FROM DW_NB_SW_XYPJXXA xypja1
     WHERE xypja1.UNI_SOCIAL_CRD_CD = ent.UNI_SOCIAL_CRD_CD
     ORDER BY xypja1.EVAL_DT DESC
     LIMIT 1) AS tax_credi_scard,  -- 最新评定日期的纳税信用分
    -- MAX(xypja.EVAL_ORG) AS EVAL_ORG,            -- 评价机构
    (SELECT xypja1.tax_credi_level
     FROM dw_nb_sw_xypjxxa xypja1
     WHERE xypja1.uni_social_crd_cd = ent.uni_social_crd_cd
     ORDER BY xypja1.EVAL_DT DESC
     LIMIT 1) AS tax_credi_level, -- 最新评定日期的纳税信用等级
    (SELECT xypja1.EVAL_YEAR
     FROM dw_nb_sw_xypjxxa xypja1
     WHERE xypja1.uni_social_crd_cd = ent.uni_social_crd_cd
     ORDER BY xypja1.EVAL_DT DESC
     LIMIT 1) AS eval_year,          -- 最新评定日期的纳税信用等级评定年度
    -- (SELECT xypja1.EVAL_DT
    --  FROM DW_NB_SW_XYPJXXA xypja1
    --  WHERE xypja1.UNI_SOCIAL_CRD_CD = ent.UNI_SOCIAL_CRD_CD
    --  ORDER BY xypja1.EVAL_DT DESC
    --  LIMIT 1) AS TAX_EVAL_DT,          -- 最新纳税信用等级评定日期
    -- (SELECT xypja1.MAJOR_TAX_ORG
    --  FROM DW_NB_SW_XYPJXXA xypja1
    --  WHERE xypja1.UNI_SOCIAL_CRD_CD = ent.UNI_SOCIAL_CRD_CD
    --  ORDER BY xypja1.EVAL_DT DESC
    --  LIMIT 1) AS MAJOR_TAX_ORG,  -- 最新评定日期的主管税务机关

    -- 社会保险基本信息 （来自 DW_NB_RLSB_SBJYLYSHBXJBXX 表）
    -- 原始代码（注释掉以避免一对多关系）：
    -- sb.PENS_NUM,             -- 养老保险人数
    -- sb.MEDIC_NUM,            -- 医疗保险人数
    -- sb.UNEMPLOY_NUM,         -- 失业保险人数
    -- sb.INJURY_NUM,           -- 工伤保险人数
    -- sb.MATERNI_NUM,          -- 生育保险人数
    -- sb.PENS_PAY_YM,          -- 养老保险缴费年月
    -- sb.MEDIC_PAY_YM,         -- 医疗保险缴费年月
    -- sb.UNEMPLOY_PAY_YM,      -- 失业保险缴费年月
    -- sb.INJURY_PAY_YM,        -- 工伤保险缴费年月
    -- sb.MATERNI_PAY_YM,       -- 生育保险缴费年月

    -- 聚合版本（获取最新记录）：
    -- 子查询版本（获取按养老保险缴费年月最新的记录）：
    (SELECT sb1.PENS_NUM
     FROM DW_NB_RLSB_SBJYLYSHBXJBXX sb1
     WHERE sb1.UNI_SOCIAL_CRD_CD = ent.UNI_SOCIAL_CRD_CD
     ORDER BY sb1.PENS_PAY_YM DESC
     LIMIT 1) AS PENS_NUM,               -- 最新养老保险缴费年月的养老保险人数

    -- 失业保险费核定信息 （来自 DW_NB_RLSB_CBGRYJSYBXFHDXX 表）

    -- 行政处罚公示信息 （来自 DW_NB_SCJDGL_XZCFGSXX 表）

    -- 聚合版本（统计信息）：
    COUNT(xzcf.UNI_SOCIAL_CRD_CD) AS XZCF_COUNT, -- 行政处罚次数

    (SELECT xzcf.ADMIN_PUNISH_DOC
     FROM DW_NB_SCJDGL_XZCFGSXX xzcf
     WHERE xzcf.UNI_SOCIAL_CRD_CD = ent.UNI_SOCIAL_CRD_CD
     ORDER BY xzcf.PUNISH_DT DESC
     LIMIT 1) AS LATEST_PUNISH_DOC, -- 最新行政处罚文号
    (SELECT xzcf.PUNISH_DT
     FROM DW_NB_SCJDGL_XZCFGSXX xzcf
     WHERE xzcf.UNI_SOCIAL_CRD_CD = ent.UNI_SOCIAL_CRD_CD
     ORDER BY xzcf.PUNISH_DT DESC
     LIMIT 1) AS LATEST_PUNISH_DT,    -- 最新处罚时间
    (SELECT xzcf.PUNISH_REA
     FROM DW_NB_SCJDGL_XZCFGSXX xzcf
     WHERE xzcf.UNI_SOCIAL_CRD_CD = ent.UNI_SOCIAL_CRD_CD
     ORDER BY xzcf.PUNISH_DT DESC
     LIMIT 1) AS LATEST_PUNISH_REA   -- 最新处罚原因

FROM company ent
-- 法定代表人信息
LEFT JOIN DW_ZJ_SCJDGL_FDDBRXX fddb ON ent.UNI_SOCIAL_CRD_CD = fddb.UNI_SOCIAL_CRD_CD AND fddb.LEREP_SIGN = 1
-- 经营异常名录信息
LEFT JOIN DW_ZJ_SCJDGL_JYYCMLXX jyyc ON ent.UNI_SOCIAL_CRD_CD = jyyc.UNI_SOCIAL_CRD_CD
-- 严重违法失信企业名单信息
LEFT JOIN DW_ZJ_SCJDGL_YZWFSX sxqy ON ent.UNI_SOCIAL_CRD_CD = sxqy.UNI_SOCIAL_CRD_CD
-- 网站网店信息
LEFT JOIN DW_NB_SCJDGL_QYNBWZHWDXX wz ON ent.UNI_SOCIAL_CRD_CD = wz.UNI_SOCIAL_CRD_CD
-- 股权变更信息
LEFT JOIN DW_NB_SCJDGL_GQBG gqbg ON ent.UNI_SOCIAL_CRD_CD = gqbg.UNI_SOCIAL_CRD_CD
-- 企业年报资产信息
LEFT JOIN DW_NB_SCJDGL_QYNBZCXX nb ON ent.UNI_SOCIAL_CRD_CD = nb.UNI_SOCIAL_CRD_CD
-- 对外担保信息
LEFT JOIN DW_NB_SCJDGL_DWTGBZDBXX db ON ent.UNI_SOCIAL_CRD_CD = db.UNI_SOCIAL_CRD_CD
-- 科技型中小企业信息
LEFT JOIN DW_NB_KJ_SGCZKJXZXQY kjzx ON ent.UNI_SOCIAL_CRD_CD = kjzx.UNI_SOCIAL_CRD_CD
-- 失信被执行人信息
LEFT JOIN DW_ZJ_FZGG_SXBZXRXX sxr ON ent.UNI_SOCIAL_CRD_CD = sxr.UNI_SOCIAL_CRD_CD
-- 企业变更信息
-- LEFT JOIN DW_NB_SCJDGL_QYBGGS qybg ON ent.UNI_SOCIAL_CRD_CD = qybg.UNI_SOCIAL_CRD_CD
-- 纳税信息
LEFT JOIN DW_NB_SW_NSXX ns ON ent.UNI_SOCIAL_CRD_CD = ns.UNI_SOCIAL_CRD_CD
-- 信用评价信息
LEFT JOIN DW_NB_DSJ_XYPJXX xypj ON ent.UNI_SOCIAL_CRD_CD = xypj.UNI_SOCIAL_CRD_CD
-- A级纳税人信息
LEFT JOIN DW_NB_SW_XYPJXXA xypja ON ent.UNI_SOCIAL_CRD_CD = xypja.UNI_SOCIAL_CRD_CD
-- 社保信息
LEFT JOIN DW_NB_RLSB_SBJYLYSHBXJBXX sb ON ent.UNI_SOCIAL_CRD_CD = sb.UNI_SOCIAL_CRD_CD
-- 失业保险费核定信息
-- LEFT JOIN DW_NB_RLSB_CBGRYJSYBXFHDXX sybx ON ent.UNI_SOCIAL_CRD_CD = sybx.UNI_SOCIAL_CRD_CD
-- 行政处罚信息
LEFT JOIN DW_NB_SCJDGL_XZCFGSXX xzcf ON ent.UNI_SOCIAL_CRD_CD = xzcf.UNI_SOCIAL_CRD_CD
-- 按企业分组，确保每个企业只有一条记录
GROUP BY
    ent.REG_ORG, ent.COMP_TYPE, ent.REG_STATE, ent.UNI_SOCIAL_CRD_CD,
    ent.COMP_NM, ent.ADDR, ent.LEGAL_REPRE, ent.INDV_ID, ent.REG_CAPT,
    ent.CAPT_KIND, ent.OPT_SCOP, ent.REG_NO, ent.APPR_DT, ent.EST_DT,
    ent.OPT_FROM, ent.OPT_TO, ent.DOMDI_STRICT, ent.OPT_STRICT,
    ent.POSTAL_CODE, ent.INDV_NM;

-- 为新表添加主键约束
-- ALTER TABLE company_extended
-- ADD PRIMARY KEY (UNI_SOCIAL_CRD_CD);

-- 显示创建结果
SELECT
    COUNT(*) AS total_company_extended,
    COUNT(DISTINCT UNI_SOCIAL_CRD_CD) AS unique_company,
    COUNT(DISTINCT INDV_NM) AS unique_industry_codes
FROM company_extended;

-- 显示表结构
DESCRIBE company_extended;

SELECT * FROM company_extended LIMIT 10;
