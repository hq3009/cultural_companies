-- Step2：扩展 enterprises 表的数据维度
-- 基于已创建的 enterprises 表，添加法定代表人、经营异常、行政处罚等详细信息
-- 不使用别名，保持原字段名，通过注释说明字段含义
-- 将扩展后的结果创建为新表 extended_enterprises

-- 别名对应关系：
-- e: enterprises (主表)
-- lri: DW_ZJ_SCJDGL_FDDBRXX (法定代表人信息)
-- ba: DW_ZJ_SCJDGL_JYYCMLXX (经营异常名录)
-- sv: DW_ZJ_SCJDGL_YZWFSX (严重违法失信)
-- ws: DW_NB_SCJDGL_QYNBWZHWDXX (网站网店信息)
-- ec: DW_NB_SCJDGL_GQBG (股权变更)
-- ara: DW_NB_SCJDGL_QYNBZCXX (企业年报资产)
-- gi: DW_NB_SCJDGL_DWTGBZDBXX (对外担保)
-- tse: DW_NB_KJ_SGCZKJXZXQY (科技型小微企业)
-- dp: DW_SHL_QYWLXSXCPXX (失信被执行人)
-- ce: DW_NB_HYWLQYXYDJXX (信用评价)
-- ci: DW_NB_SWBGXX (企业变更)
-- ti: DW_NB_SW_SBJNXX (纳税信息)
-- gat: DW_NB_SW_XYPJXXA (A级纳税人)
-- ss: DW_NB_RLSB_SBJYLYSHBXJBXX (社保信息)
-- ssd: DW_NB_RLSB_CBGRYJSYBXFHDXX (社保缴费明细)
-- ap: DW_NB_SCJDGL_XZCFGSXX (行政处罚)
-- al: DW_NB_SCJDGL_XZXK (行政许可)

-- 创建 extended_enterprises 表，包含所有扩展维度信息
CREATE TABLE extended_enterprises AS
SELECT
    -- 基础企业信息（来自 enterprises 表）
    e.UNI_SOCIAL_CRD_CD,                           -- 统一社会信用代码
    e.COMP_NM,                                      -- 企业名称
    e.REG_ORG,                                      -- 登记机关
    e.COMP_TYPE,                                    -- 企业类型
    e.ADDR,                                         -- 地址
    e.LEGAL_REPRE,                                  -- 法定代表人
    e.INDV_NM,                                      -- 行业代码
    e.OPT_SCOP,                                     -- 经营范围
    e.APPR_DT,                                      -- 核准日期
    e.EST_DT,                                       -- 成立日期
    e.DOMDI_STRICT,                                 -- 住所所在行政区划代码
    e.OPT_STRICT,                                   -- 生产经营地所在行政区划代码

    -- 法定代表人详细信息（来自 DW_ZJ_SCJDGL_FDDBRXX 表）
    lri.NM,                                         -- 法定代表人姓名
    lri.CER_NO,                                     -- 身份证号码
    lri.TEL_NUM,                                    -- 固定电话
    lri.MOBTEL,                                     -- 手机号码
    lri.EMAIL,                                      -- 电子邮箱
    lri.POSITION_CN,                                -- 职务

    -- 经营异常名录信息（来自 DW_ZJ_SCJDGL_JYYCMLXX 表）
    ba.INCLU_REASON,                                -- 列入原因
    ba.INCLU_DT,                                    -- 列入日期
    ba.REMEXCPRES_CN,                               -- 移出原因
    ba.REMOVE_DT,                                   -- 移出日期

    -- 严重违法失信企业名单信息（来自 DW_ZJ_SCJDGL_YZWFSX 表）
    sv.SERILL_REA,                                  -- 严重违法失信原因
    sv.ABN_TM,                                      -- 列入时间
    sv.REM_EXCPRES_REA,                             -- 移出原因
    sv.REM_DT,                                      -- 移出时间

    -- 网站网店信息（来自 DW_NB_SCJDGL_QYNBWZHWDXX 表）
    ws.WEB_STORE_NM,                                -- 网站网店名称
    ws.WEB_STORE_URL,                               -- 网站网店网址
    ws.WEB_STORE_TYPE,                              -- 网站类型
    ws.ECOM_TYPE,                                   -- 电商类型

    -- 股权变更信息（来自 DW_NB_SCJDGL_GQBG 表）
    ec.ALT_DT,                                      -- 变更日期
    ec.INV,                                         -- 投资人
    ec.TRANSAMPR_BF,                                -- 变更前股权
    ec.TRANSAMPR_AF,                                -- 变更后股权

    -- 企业年报资产信息（来自 DW_NB_SCJDGL_QYNBZCXX 表）
    ara.ANNUAL_YEAR,                                -- 年报年份
    ara.ASSET_ZMT,                                  -- 资产总额
    ara.DEBT_AMT,                                   -- 负债总额
    ara.OWNER_EQUITY_TOATAL,                        -- 所有者权益合计
    ara.OPT_INCOME_TOTAL,                           -- 营业总收入
    ara.PROFIT_TOTAL,                               -- 利润总额
    ara.NET_PROFIT,                                 -- 净利润
    ara.TAX_TOTAL,                                  -- 纳税总额

    -- 对外担保信息（来自 DW_NB_SCJDGL_DWTGBZDBXX 表）
    gi.EXTERNAL_GUA,                                -- 对外担保
    gi.CREDITOR,                                    -- 债权人
    gi.DEBTOR,                                      -- 债务人
    gi.MAJOR_CREDIT_AMT,                            -- 担保金额
    gi.PERIOD_FROM,                                 -- 担保起始日期
    gi.PERIOD_TO,                                   -- 担保结束日期

    -- 科技型小微企业信息（来自 DW_NB_KJ_SGCZKJXZXQY 表）
    tse.CONGNIZ_ORG,                                -- 认定机构
    tse.CONGNIZ_TEAR,                               -- 认定年份

    -- 失信被执行人信息（来自 DW_SHL_QYWLXSXCPXX 表）
    dp.EXECUTE_COURT,                               -- 执行法院
    dp.EXECUTE_AMT,                                 -- 执行金额
    dp.NOT_EXECUTE_AMT,                             -- 未执行金额
    dp.FILING_DT,                                   -- 立案日期

    -- 信用评价信息（来自 DW_NB_HYWLQYXYDJXX 表）
    ce.CREDIT_CMNT_NM,                              -- 信用评价名称
    ce.CMNT_RESULT,                                 -- 评价结果
    ce.CMNT_ORG,                                    -- 评价机构
    ce.ASSESS_DT,                                   -- 评价日期

    -- 企业变更信息（来自 DW_NB_SWBGXX 表）
    ci.CHAN_DT,                                     -- 变更日期
    ci.CHAN_PROJECT,                                -- 变更项目
    ci.CHAN_BEF_TEXT,                               -- 变更前内容
    ci.CHAN_AFT_TEXT,                               -- 变更后内容

    -- 纳税信息（来自 DW_NB_SW_SBJNXX 表）
    ti.PAID_AMT,                                    -- 实缴金额
    ti.COLL_ITEM,                                   -- 征收项目
    ti.PERIOD_FROM,                                 -- 所属期起
    ti.PERIOD_TO,                                   -- 所属期止

    -- A级纳税人信息（来自 DW_NB_SW_XYPJXXA 表）
    gat.EVAL_ORG,                                   -- 评价部门
    gat.EVAL_DT,                                    -- 评价日期
    gat.TAX_CREDI_LEVEL,                            -- 纳税信用等级

    -- 社保信息（来自 DW_NB_RLSB_SBJYLYSHBXJBXX 表）
    ss.PENS_NUM,                                    -- 养老保险人数
    ss.MEDIC_NUM,                                   -- 医疗保险人数
    ss.UNEMPLOY_NUM,                                -- 失业保险人数
    ss.INJURY_NUM,                                  -- 工伤保险人数
    ss.MATERNI_NUM,                                 -- 生育保险人数
    ss.PENS_PAY_YM,                                 -- 养老保险缴费年月
    ss.MEDIC_PAY_YM,                                -- 医疗保险缴费年月

    -- 社保缴费明细（来自 DW_NB_RLSB_CBGRYJSYBXFHDXX 表）
    ssd.ISSU_TYPE,                                  -- 险种类型
    ssd.PAY_MONTHS,                                 -- 缴费月数
    ssd.PER_PAY_BASIS,                              -- 个人缴费基数
    ssd.PAY_AMT,                                    -- 缴费金额
    ssd.UNIT_PAY_AMT,                               -- 单位缴费金额
    ssd.PER_PAY_AMT,                                -- 个人缴费金额
    ssd.FEE_PERIOD,                                 -- 费款所属期

    -- 行政处罚信息（来自 DW_NB_SCJDGL_XZCFGSXX 表）
    ap.ADMIN_PUNISH_DOC,                            -- 行政处罚决定书文号
    ap.PUNISH_REA,                                  -- 处罚事由
    ap.PUNISH_DT,                                   -- 处罚日期
    ap.PUNISH_RESULT,                               -- 处罚结果

    -- 行政许可信息（来自 DW_NB_SCJDGL_XZXK 表）
    al.LIC_NO,                                      -- 许可证号
    al.LIC_NM,                                      -- 许可证名称
    al.LIC_ANTH,                                    -- 许可机关
    al.VAL_FROM,                                    -- 有效期自
    al.VAL_TO                                       -- 有效期至

FROM enterprises e
-- 法定代表人信息
LEFT JOIN DW_ZJ_SCJDGL_FDDBRXX lri ON e.UNI_SOCIAL_CRD_CD = lri.UNI_SOCIAL_CRD_CD AND lri.LEREP_SIGN = 1
-- 经营异常名录信息
LEFT JOIN DW_ZJ_SCJDGL_JYYCMLXX ba ON e.UNI_SOCIAL_CRD_CD = ba.UNI_SOCIAL_CRD_CD
-- 严重违法失信企业名单信息
LEFT JOIN DW_ZJ_SCJDGL_YZWFSX sv ON e.UNI_SOCIAL_CRD_CD = sv.UNI_SOCIAL_CRD_CD
-- 网站网店信息
LEFT JOIN DW_NB_SCJDGL_QYNBWZHWDXX ws ON e.UNI_SOCIAL_CRD_CD = ws.UNI_SOCIAL_CRD_CD
-- 股权变更信息
LEFT JOIN DW_NB_SCJDGL_GQBG ec ON e.UNI_SOCIAL_CRD_CD = ec.UNI_SOCIAL_CRD_CD
-- 企业年报资产信息
LEFT JOIN DW_NB_SCJDGL_QYNBZCXX ara ON e.UNI_SOCIAL_CRD_CD = ara.UNI_SOCIAL_CRD_CD
-- 对外担保信息
LEFT JOIN DW_NB_SCJDGL_DWTGBZDBXX gi ON e.UNI_SOCIAL_CRD_CD = gi.UNI_SOCIAL_CRD_CD
-- 科技型小微企业信息
LEFT JOIN DW_NB_KJ_SGCZKJXZXQY tse ON e.UNI_SOCIAL_CRD_CD = tse.UNI_SOCIAL_CRD_CD
-- 失信被执行人信息
LEFT JOIN DW_SHL_QYWLXSXCPXX dp ON e.UNI_SOCIAL_CRD_CD = dp.UNI_SOCIAL_CRD_CD
-- 信用评价信息
LEFT JOIN DW_NB_HYWLQYXYDJXX ce ON e.UNI_SOCIAL_CRD_CD = ce.UNI_SOCIAL_CRD_CD
-- 企业变更信息
LEFT JOIN DW_NB_SWBGXX ci ON e.UNI_SOCIAL_CRD_CD = ci.UNI_SOCIAL_CRD_CD
-- 纳税信息
LEFT JOIN DW_NB_SW_SBJNXX ti ON e.UNI_SOCIAL_CRD_CD = ti.UNI_SOCIAL_CRD_CD
-- A级纳税人信息
LEFT JOIN DW_NB_SW_XYPJXXA gat ON e.UNI_SOCIAL_CRD_CD = gat.UNI_SOCIAL_CRD_CD
-- 社保信息
LEFT JOIN DW_NB_RLSB_SBJYLYSHBXJBXX ss ON e.UNI_SOCIAL_CRD_CD = ss.UNI_SOCIAL_CRD_CD
-- 社保缴费明细
LEFT JOIN DW_NB_RLSB_CBGRYJSYBXFHDXX ssd ON e.UNI_SOCIAL_CRD_CD = ssd.UNI_SOCIAL_CRD_CD
-- 行政处罚信息
LEFT JOIN DW_NB_SCJDGL_XZCFGSXX ap ON e.UNI_SOCIAL_CRD_CD = ap.UNI_SOCIAL_CRD_CD
-- 行政许可信息
LEFT JOIN DW_NB_SCJDGL_XZXK al ON e.UNI_SOCIAL_CRD_CD = al.UNI_SOCIAL_CRD_CD

ORDER BY e.UNI_SOCIAL_CRD_CD;

-- 为新表添加主键约束
ALTER TABLE extended_enterprises
ADD PRIMARY KEY (UNI_SOCIAL_CRD_CD);

-- 显示创建结果
SELECT
    COUNT(*) AS total_extended_enterprises,
    COUNT(DISTINCT UNI_SOCIAL_CRD_CD) AS unique_enterprises,
    COUNT(DISTINCT INDV_NM) AS unique_industry_codes
FROM extended_enterprises;

-- 显示表结构
DESCRIBE extended_enterprises;
