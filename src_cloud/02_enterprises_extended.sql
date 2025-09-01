-- Step2：扩展 enterprises 表的数据维度
-- 基于已创建的 enterprises 表，添加法定代表人、经营异常、行政处罚等详细信息
-- 不使用别名，保持原字段名，通过注释说明字段含义
-- 将扩展后的结果创建为新表 extended_enterprises

-- 注意：如果云服务器不允许创建永久表，请使用以下临时表语法之一：
-- MySQL 临时表语法：
-- CREATE TEMPORARY TABLE extended_enterprises AS

-- SQL Server 临时表语法：
-- CREATE TABLE #extended_enterprises AS

-- 别名对应关系：
-- 表别名说明（用于后续SQL字段注释）
-- ent   : enterprises（主表，市场主体基本信息）
-- fddb  : DW_ZJ_SCJDGL_FDDBRXX（法定代表人信息）
-- jyyc  : DW_ZJ_SCJDGL_JYYCMLXX（经营异常名录信息）
-- sxqy    : DW_ZJ_SCJDGL_YZWFSX（严重违法失信企业名单信息）
-- wz    : DW_NB_SCJDGL_QYNBWZHWDXX（网站或网店信息）
-- gqbg  : DW_NB_SCJDGL_GQBG（股权变更信息）
-- nb    : DW_NB_SCJDGL_QYNBZCXX（企业年报资产信息）
-- db    : DW_NB_SCJDGL_DWTGBZDBXX（对外担保信息）
-- kjzx  : DW_NB_KJ_SGCZKJXZXQY（科技型中小企业信息）
-- sxr   : DW_ZJ_FZGG_SXBZXRXX（失信被执行人信息）
-- xypj  : DW_NB_DSJ_XYPJXX（信用评价信息）
-- qybg  : DW_NB_SCJDGL_QYBGGS（企业变更公示信息）
-- ns    : DW_NB_SW_NSXX（纳税信息）
-- ajns  : DW_NB_SW_XYPJXXA（A级纳税人信息）
-- sb    : DW_NB_RLSB_SBJYLYSHBXJBXX（社会保险基本信息）
-- sybx  : DW_NB_RLSB_CBGRYJSYBXFHDXX（失业保险费核定信息）
-- xzcf  : DW_NB_SCJDGL_XZCFGSXX（行政处罚公示信息）
-- xzxk  : DW_NB_SCJDGL_XZXK（行政许可公示信息）

-- 删除表（如果已存在）
DROP TABLE IF EXISTS extended_enterprises;

-- 创建 extended_enterprises 表，包含所有扩展维度信息
CREATE TABLE extended_enterprises AS
SELECT
    -- 市场主体信息 （来自 enterprises 表）
    ent.REG_ORG,            -- 登记机关
    ent.COMP_TYPE,          -- 企业类型大类（中文）
    ent.REG_STATE,          -- 登记状态（中文）
    ent.UNI_SOCIAL_CRD_CD,  -- 统一社会信用代码
    ent.COMP_NM,            -- 企业名称（字号名称）
    ent.ADDR,               -- 住所（登记、个体户经营场所）
    ent.LEGAL_REPRE,        -- 法定代表人(经营者姓名)
    ent.INDV_ID,            -- 行业代码（中文）
    ent.REG_CAPT,           -- 注册资本(资金数额)
    ent.CAPT_KIND,          -- 币种
    ent.OPT_SCOP,           -- 经营范围
    ent.REG_NO,             -- 注册号
    ent.APPR_DT,            -- 核准日期（登记、吊销、注销日期）
    ent.EST_DT,             -- 成立日期
    ent.OPT_FROM,           -- 经营(营业)起始日期
    ent.OPT_TO,             -- 经营(营业)截止日期
    ent.DOMDI_STRICT,       -- 住所所在行政区划
    ent.PRO_LOC,            -- 生产经营地
    ent.OPT_STRICT,         -- 生产经营地所在行政区划
    ent.POSTAL_CODE,        -- 邮政编码
    ent.OPT_LOC,            -- 经营场所
    ent.INDV_NM,            -- 行业代码（中文）

    -- 法定代表人信息 （来自 DW_ZJ_SCJDGL_FDDBRXX 表）
    fddb.PERSONID,          -- 人员ID
    fddb.LEREP_SIGN,        -- 法定代表人标志/首席代表标志/负责人标识 2 董事
    fddb.NM,                -- 姓名
    fddb.POSITION,          -- 职务
    fddb.CERTYPE,           -- 证件类型
    fddb.COUNTRY,           -- 国籍
    fddb.POSITION_CN,       -- 职务（中文名称）
    fddb.CERTYPE_CN,        -- 证件类型（中文）
    fddb.COUNTRY_CN,        -- 国籍（中文）
    fddb.CER_NO,            -- 身份证件号码
    fddb.TEL_NUM,           -- 固定电话
    fddb.MOBTEL,            -- 移动电话
    fddb.EMAIL,             -- 电子邮箱

    -- 经营异常名录信息 （来自 DW_ZJ_SCJDGL_JYYCMLXX 表）
    jyyc.INCLU_DT,          -- 列入日期
    jyyc.INCLU_REASON,      -- 列入经营异常名录原因
    jyyc.REDECORG_CN,       -- 作出决定机关(移出)
    jyyc.REMEXCPRES_CN,     -- 移出经营异常名录原因
    jyyc.REMOVE_DT,         -- 移出日期
    jyyc.DECORG_CN,         -- 作出决定机关(列入)

    -- 严重违法失信企业名单信息 （来自 DW_ZJ_SCJDGL_YZWFSX 表）
    sxqy.ILL_COMP_ID,       -- 严重违法失信企业名单ID
    sxqy.ABN_TM,            -- 列入日期
    sxqy.SERILL_REA,        -- 列入严重违法失信企业名单原因
    sxqy.REM_DT,            -- 移出日期
    sxqy.RECORG_OGR,        -- 作出决定机关(移出)
    sxqy.REM_EXCPRES_REA,   -- 移出严重违法失信企业名单原因
    sxqy.DECORG_ORG,        -- 作出决定机关(列入)

    -- 企业年报网站或网店信息 （来自 DW_NB_SCJDGL_QYNBWZHWDXX 表）
    wz.WEB_ID,               -- 网站标识
    wz.ANNUAL_ID,            -- 年报ID
    wz.WEB_STORE_TYPE,       -- 网站网店类型
    wz.WEB_STORE_NM,         -- 网站（网店）名称
    wz.WEB_STORE_URL,        -- 网站（网店）网址
    wz.WEB_TYPE,             -- 网站类型
    wz.WEB_PLAT_TYPE,        -- 网络交易平台运营类型
    wz.WEB_PRODUCT_TYPE,     -- 网络交易产品类型
    wz.ECOM_TYPE,            -- 电商类型
    wz.ICP_NO,               -- ICP证号/备案号
    wz.WECHAT_PUBLIC,        -- 微信公众服务号
    wz.APP_NM,               -- APP软件名称
    wz.PLAT_NM,              -- 所属平台名称
    wz.DELI_ADDR,            -- 发货地址
    wz.RETURN_ADDR,          -- 退货地址
    wz.PRIPID,               -- 主体身份代码
    wz.UNI_SOCIAL_CRD_CD,    -- 统一社会信用代码
    wz.COMP_NM,              -- 企业名称（字号名称）
    wz.ANNUAL_YEAR,          -- 年报年度

    -- 股权变更信息 （来自 DW_NB_SCJDGL_GQBG 表）
    gqbg.PRIPID,           -- 主体身份代码
    gqbg.INV,              -- 股东
    gqbg.ALT_DT,           -- 股权变更日期
    gqbg.PUBLIC_DT,        -- 公示日期
    gqbg.TRANSAMPR_BF,     -- 变更前股权比例
    gqbg.TRANSAMPR_AF,     -- 变更后股权比例

    -- 企业年报资产信息 （来自 DW_NB_SCJDGL_QYNBZCXX 表）
    nb.ANNUAL_YEAR,           -- 年报年度
    nb.ASSET_ZMT,             -- 资产总额
    nb.DEBT_AMT,              -- 负债总额
    nb.OWNER_EQUITY_TOATAL,   -- 所有者权益合计
    nb.OPT_INCOME_TOTAL,      -- 营业总收入
    nb.PROFIT_TOTAL,          -- 利润总额
    nb.NET_PROFIT,            -- 净利润
    nb.TAX_TOTAL,             -- 纳税总额

    -- 对外提供保证担保信息 （来自 DW_NB_SCJDGL_DWTGBZDBXX 表）
    db.CREDITOR,           -- 债权人
    db.DEBTOR,             -- 债务人
    db.MAJOR_CREDIT_TYPE,  -- 主债权种类
    db.MAJOR_CREDIT_AMT,   -- 主债权数额
    db.PERIOD_FROM,        -- 履行债务的期限自
    db.PERIOD_TO,          -- 履行债务的期限至
    db.PROMIS_DUR,         -- 保证的期间
    db.IS_PUBLIC,          -- 对外担保是否公示
    db.PROMIS_WAY,         -- 保证的方式
    db.ANNUAL_YEAR,        -- 年报年度

    -- 科技型小微企业信息 （来自 DW_NB_KJ_SGCZKJXZXQY 表）
    kjzx.CONGNIZ_ORG,     -- 认定机构
    kjzx.CONGNIZ_TEAR,    -- 认定年份 (TEAR or YEAR?)

    -- 失信被执行人信息 （来自 DW_ZJ_FZGG_SXBZXRXX 表）
    -- 如果没有查询结果，直接删掉 (2025-09-01)
    sxr.EXECUTED_NM,         -- 被执行人姓名/名称
    sxr.IDENTI_ID,           -- 身份证号码
    sxr.LEGAL_REPRE,         -- 法定代表人或者负责人姓名
    sxr.EXECUTED_COURT,      -- 执行法院
    sxr.ENFORCE_BASIS,       -- 执行依据文号
    sxr.FIL_DT,              -- 立案时间
    sxr.CASE_NO,             -- 案号
    sxr.DECI_EXECUTED_UNIT,  -- 做出执行依据单位
    sxr.EFFECT_DOC_OBLI,     -- 生效法律文书确定的义务
    sxr.EXECUTED_PERFOR,     -- 被执行人的履行情况
    sxr.PUBLISH_DT,          -- 发布时间
    sxr.SEARCH_CASE_YEAR,    -- 搜案年号
    sxr.SEARCH_CASE_NO,      -- 搜案编号
    sxr.PERFORMED_PART,      -- 已履行部分
    sxr.UN_PERFORMED_PART,   -- 未履行部分
    sxr.DISHONEST_ID,        -- 失信ID
    sxr.GEN,                 -- 性别
    sxr.EXECUTED_NATURE,     -- 被执行人性质
    sxr.BIRTH_DT,            -- 出生日期
    sxr.DISHONEST_BEHAV,     -- 失信被执行人行为情况

    -- 纳税信息 （来自 DW_NB_SW_NSXX 表）
    -- Excel表中灰色底是什么意思？
    ns.TAX_AMT,            -- 纳税总额
    ns.SALE_INCO,          -- 销售收入
    ns.COUNT_DT,           -- 统计时间

    -- 信用评价信息（来自 DW_NB_DSJ_XYPJXX 表）
    xypj.CRED_SCARD,         -- 信用分
    xypj.EVAL_DT,            -- 评价时间

    -- 信用评价信息（A级纳税人） （来自 DW_NB_SW_XYPJXXA 表）
    xypja.CREDI_SCARD,         -- 信用分
    xypja.EVAL_ORG,            -- 评价机构
    xypja.TAX_CREDI_LEVEL,     -- 纳税信用等级
    xypja.EVAL_YEAR,           -- 纳税信用等级评定年度
    xypja.EVAL_DT,             -- 纳税信用等级评定日期
    xypja.MAJOR_TAX_ORG,       -- 主管税务机关

    -- 社会保险基本信息 （来自 DW_NB_RLSB_SBJYLYSHBXJBXX 表）
    sb.PENS_NUM,             -- 养老保险人数
    sb.MEDIC_NUM,            -- 医疗保险人数
    sb.UNEMPLOY_NUM,         -- 失业保险人数
    sb.INJURY_NUM,           -- 工伤保险人数
    sb.MATERNI_NUM,          -- 生育保险人数
    sb.PENS_PAY_YM,          -- 养老保险缴费年月
    sb.MEDIC_PAY_YM,         -- 医疗保险缴费年月
    sb.UNEMPLOY_PAY_YM,      -- 失业保险缴费年月
    sb.INJURY_PAY_YM,        -- 工伤保险缴费年月
    sb.MATERNI_PAY_YM,       -- 生育保险缴费年月

    -- 失业保险费核定信息 （来自 DW_NB_RLSB_CBGRYJSYBXFHDXX 表）
    -- 如果没有查询结果，直接删掉 (2025-09-01)
    sybx.ISSU_TYPE,          -- 险种类型
    sybx.PAY_MONTHS,         -- 缴费月数
    sybx.PER_PAY_BASIS,      -- 个人缴费基数
    sybx.PAY_AMT,            -- 缴费总金额
    sybx.UNIT_PAY_AMT,       -- 单位应交金额
    sybx.PER_PAY_AMT,        -- 个人应缴金额
    sybx.FEE_PERIOD,         -- 费款所属期

    -- 行政处罚公示信息 （来自 DW_NB_SCJDGL_XZCFGSXX 表）
    xzcf.ADMIN_PUNISH_DOC,    -- 行政处罚文号
    xzcf.PUNISH_REA,          -- 处罚原因
    xzcf.PUNISH_DT,           -- 处罚时间
    xzcf.PUNISH_RESULT,       -- 处罚结果

    -- 行政许可公示信息 （来自 DW_NB_SCJDGL_XZXK 表）
    -- xzxk.LIC_NO,              -- 许可文件编号
    -- xzxk.LIC_NM,              -- 许可文件名称
    -- xzxk.LIC_ANTH,            -- 许可机关
    -- xzxk.LIC_ITEM,            --许可内容
    -- xzxk.VAL_FROM,            -- 有效期自
    -- xzxk.VAL_TO,              -- 有效期至

FROM enterprises ent
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
-- 信用评价信息
LEFT JOIN DW_NB_HYWLQYXYDJXX xy ON ent.UNI_SOCIAL_CRD_CD = xy.UNI_SOCIAL_CRD_CD
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
LEFT JOIN DW_NB_RLSB_CBGRYJSYBXFHDXX sybx ON ent.UNI_SOCIAL_CRD_CD = sybx.UNI_SOCIAL_CRD_CD
-- 行政处罚信息
LEFT JOIN DW_NB_SCJDGL_XZCFGSXX xzcf ON ent.UNI_SOCIAL_CRD_CD = xzcf.UNI_SOCIAL_CRD_CD
-- 行政许可信息
-- LEFT JOIN DW_NB_SCJDGL_XZXK xzxk ON ent.UNI_SOCIAL_CRD_CD = xzxk.UNI_SOCIAL_CRD_CD

ORDER BY ent.UNI_SOCIAL_CRD_CD;

-- 为新表添加主键约束
-- ALTER TABLE extended_enterprises
-- ADD PRIMARY KEY (UNI_SOCIAL_CRD_CD);

-- 显示创建结果
SELECT
    COUNT(*) AS total_extended_enterprises,
    COUNT(DISTINCT UNI_SOCIAL_CRD_CD) AS unique_enterprises,
    COUNT(DISTINCT INDV_NM) AS unique_industry_codes
FROM extended_enterprises;

-- 显示表结构
DESCRIBE extended_enterprises;
