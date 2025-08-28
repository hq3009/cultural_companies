-- 文化兼旅游行业统计分析优化版（云服务器版本）
-- 基于extended_enterprises表，提取文化兼旅游行业企业进行统计分析
-- 优化输出格式，使用中文列名，更直观的表格形式

-- 删除表（如果已存在）
DROP TABLE IF EXISTS wenhua_and_lyuyou_enterprises;

-- 创建文化兼旅游行业企业子表
CREATE TABLE wenhua_and_lyuyou_enterprises AS
SELECT * FROM extended_enterprises
WHERE INDV_NM IN (
    -- 文化兼旅游行业代码列表（来自 industry_codes/wenhua_and_lyuyou.txt）
    '3473', '5622', '6432', '7121', '7123', '7298', '7711', '7712', '7713', '7714',
    '7715', '7716', '7719', '7850', '8060', '8810', '8820', '8840', '8850', '8860',
    '9011', '9012', '9019', '9020', '9030', '9090'
);

-- 为新表添加主键约束
ALTER TABLE wenhua_and_lyuyou_enterprises ADD PRIMARY KEY (UNI_SOCIAL_CRD_CD);

-- ========================================
-- 1. 文化兼旅游行业企业基础统计概览
-- ========================================
SELECT
    '文化兼旅游行业企业基础统计' AS 统计类别,
    COUNT(*) AS 企业总数,
    COUNT(DISTINCT INDV_NM) AS 涉及行业数,
    COUNT(DISTINCT COMP_TYPE) AS 企业类型数,
    COUNT(DISTINCT DOMDI_STRICT) AS 涉及区县数,
    COUNT(DISTINCT REG_ORG) AS 登记机关数
FROM wenhua_and_lyuyou_enterprises;

-- ========================================
-- 2. 文化兼旅游行业按行业代码的企业分布统计
-- ========================================
SELECT
    INDV_NM AS 行业代码,
    COUNT(*) AS 企业数量,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM wenhua_and_lyuyou_enterprises), 2) AS 占比百分比,
    COUNT(CASE WHEN EST_DT >= '2020-01-01' THEN 1 END) AS 新业态企业数,
    COUNT(CASE WHEN EST_DT < '2020-01-01' THEN 1 END) AS 传统企业数,
    ROUND(COUNT(CASE WHEN EST_DT >= '2020-01-01' THEN 1 END) * 100.0 / COUNT(*), 2) AS 新业态占比
FROM wenhua_and_lyuyou_enterprises
GROUP BY INDV_NM
ORDER BY 企业数量 DESC;

-- ========================================
-- 3. 文化兼旅游行业按企业类型统计
-- ========================================
SELECT
    COMP_TYPE AS 企业类型,
    COUNT(*) AS 企业数量,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM wenhua_and_lyuyou_enterprises), 2) AS 占比百分比,
    COUNT(CASE WHEN EST_DT >= '2020-01-01' THEN 1 END) AS 新业态企业数,
    ROUND(COUNT(CASE WHEN EST_DT >= '2020-01-01' THEN 1 END) * 100.0 / COUNT(*), 2) AS 新业态占比
FROM wenhua_and_lyuyou_enterprises
GROUP BY COMP_TYPE
ORDER BY 企业数量 DESC;

-- ========================================
-- 4. 文化兼旅游行业按区县统计
-- ========================================
SELECT
    DOMDI_STRICT AS 区县代码,
    COUNT(*) AS 企业数量,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM wenhua_and_lyuyou_enterprises), 2) AS 占比百分比,
    COUNT(CASE WHEN EST_DT >= '2020-01-01' THEN 1 END) AS 新业态企业数,
    ROUND(COUNT(CASE WHEN EST_DT >= '2020-01-01' THEN 1 END) * 100.0 / COUNT(*), 2) AS 新业态占比
FROM wenhua_and_lyuyou_enterprises
GROUP BY DOMDI_STRICT
ORDER BY 企业数量 DESC;

-- ========================================
-- 5. 文化兼旅游行业经营状况统计（有财务数据的企业）
-- ========================================
SELECT
    '文化兼旅游行业经营状况统计' AS 统计类别,
    COUNT(*) AS 有财务数据企业数,
    ROUND(AVG(ara.ASSET_ZMT), 2) AS 平均资产总额,
    ROUND(SUM(ara.ASSET_ZMT), 2) AS 总资产总额,
    ROUND(AVG(ara.OPT_INCOME_TOTAL), 2) AS 平均营业收入,
    ROUND(SUM(ara.OPT_INCOME_TOTAL), 2) AS 总营业收入,
    ROUND(AVG(ara.PROFIT_TOTAL), 2) AS 平均利润总额,
    ROUND(SUM(ara.PROFIT_TOTAL), 2) AS 总利润总额,
    ROUND(AVG(ara.NET_PROFIT), 2) AS 平均净利润,
    ROUND(SUM(ara.NET_PROFIT), 2) AS 总净利润,
    ROUND(AVG(ara.TAX_TOTAL), 2) AS 平均纳税总额,
    ROUND(SUM(ara.TAX_TOTAL), 2) AS 总纳税总额
FROM wenhua_and_lyuyou_enterprises e
LEFT JOIN DW_NB_SCJDGL_QYNBZCXX ara ON e.UNI_SOCIAL_CRD_CD = ara.UNI_SOCIAL_CRD_CD
WHERE ara.ASSET_ZMT IS NOT NULL OR ara.OPT_INCOME_TOTAL IS NOT NULL;

-- ========================================
-- 6. 文化兼旅游行业风险企业统计
-- ========================================
SELECT
    '文化兼旅游行业风险企业统计' AS 统计类别,
    COUNT(*) AS 企业总数,
    COUNT(CASE WHEN ba.INCLU_REASON IS NOT NULL THEN 1 END) AS 经营异常企业数,
    COUNT(CASE WHEN sv.SERILL_REA IS NOT NULL THEN 1 END) AS 严重违法失信企业数,
    COUNT(CASE WHEN dp.EXECUTE_COURT IS NOT NULL THEN 1 END) AS 失信被执行人企业数,
    COUNT(CASE WHEN ap.ADMIN_PUNISH_DOC IS NOT NULL THEN 1 END) AS 有行政处罚企业数,
    ROUND(COUNT(CASE WHEN ba.INCLU_REASON IS NOT NULL THEN 1 END) * 100.0 / COUNT(*), 2) AS 经营异常占比,
    ROUND(COUNT(CASE WHEN sv.SERILL_REA IS NOT NULL THEN 1 END) * 100.0 / COUNT(*), 2) AS 严重违法失信占比,
    ROUND(COUNT(CASE WHEN dp.EXECUTE_COURT IS NOT NULL THEN 1 END) * 100.0 / COUNT(*), 2) AS 失信被执行人占比,
    ROUND(COUNT(CASE WHEN ap.ADMIN_PUNISH_DOC IS NOT NULL THEN 1 END) * 100.0 / COUNT(*), 2) AS 行政处罚占比
FROM wenhua_and_lyuyou_enterprises e
LEFT JOIN DW_ZJ_SCJDGL_JYYCMLXX ba ON e.UNI_SOCIAL_CRD_CD = ba.UNI_SOCIAL_CRD_CD
LEFT JOIN DW_ZJ_SCJDGL_YZWFSX sv ON e.UNI_SOCIAL_CRD_CD = sv.UNI_SOCIAL_CRD_CD
LEFT JOIN DW_SHL_QYWLXSXCPXX dp ON e.UNI_SOCIAL_CRD_CD = dp.UNI_SOCIAL_CRD_CD
LEFT JOIN DW_NB_SCJDGL_XZCFGSXX ap ON e.UNI_SOCIAL_CRD_CD = ap.UNI_SOCIAL_CRD_CD;

-- ========================================
-- 7. 文化兼旅游行业优质企业统计
-- ========================================
SELECT
    '文化兼旅游行业优质企业统计' AS 统计类别,
    COUNT(*) AS 企业总数,
    COUNT(CASE WHEN tse.CONGNIZ_ORG IS NOT NULL THEN 1 END) AS 科技型小微企业数,
    COUNT(CASE WHEN gat.TAX_CREDI_LEVEL = 'A' THEN 1 END) AS A级纳税人企业数,
    COUNT(CASE WHEN ws.WEB_STORE_NM IS NOT NULL THEN 1 END) AS 有网站网店企业数,
    COUNT(CASE WHEN al.LIC_NO IS NOT NULL THEN 1 END) AS 有行政许可企业数,
    ROUND(COUNT(CASE WHEN tse.CONGNIZ_ORG IS NOT NULL THEN 1 END) * 100.0 / COUNT(*), 2) AS 科技型小微占比,
    ROUND(COUNT(CASE WHEN gat.TAX_CREDI_LEVEL = 'A' THEN 1 END) * 100.0 / COUNT(*), 2) AS A级纳税人占比,
    ROUND(COUNT(CASE WHEN ws.WEB_STORE_NM IS NOT NULL THEN 1 END) * 100.0 / COUNT(*), 2) AS 有网站网店占比,
    ROUND(COUNT(CASE WHEN al.LIC_NO IS NOT NULL THEN 1 END) * 100.0 / COUNT(*), 2) AS 有行政许可占比
FROM wenhua_and_lyuyou_enterprises e
LEFT JOIN DW_NB_KJ_SGCZKJXZXQY tse ON e.UNI_SOCIAL_CRD_CD = tse.UNI_SOCIAL_CRD_CD
LEFT JOIN DW_NB_SW_XYPJXXA gat ON e.UNI_SOCIAL_CRD_CD = gat.UNI_SOCIAL_CRD_CD
LEFT JOIN DW_NB_SCJDGL_QYNBWZHWDXX ws ON e.UNI_SOCIAL_CRD_CD = ws.UNI_SOCIAL_CRD_CD
LEFT JOIN DW_NB_SCJDGL_XZXK al ON e.UNI_SOCIAL_CRD_CD = al.UNI_SOCIAL_CRD_CD;

-- ========================================
-- 8. 文化兼旅游行业社保参与统计
-- ========================================
SELECT
    '文化兼旅游行业社保参与统计' AS 统计类别,
    COUNT(*) AS 企业总数,
    COUNT(CASE WHEN ss.PENS_NUM IS NOT NULL THEN 1 END) AS 参与社保企业数,
    COUNT(CASE WHEN ss.PENS_NUM IS NULL THEN 1 END) AS 未参与社保企业数,
    ROUND(COUNT(CASE WHEN ss.PENS_NUM IS NOT NULL THEN 1 END) * 100.0 / COUNT(*), 2) AS 社保参与率,
    ROUND(AVG(ss.PENS_NUM), 2) AS 平均养老保险人数,
    ROUND(AVG(ss.MEDIC_NUM), 2) AS 平均医疗保险人数,
    ROUND(AVG(ss.UNEMPLOY_NUM), 2) AS 平均失业保险人数,
    ROUND(AVG(ss.INJURY_NUM), 2) AS 平均工伤保险人数,
    ROUND(AVG(ss.MATERNI_NUM), 2) AS 平均生育保险人数
FROM wenhua_and_lyuyou_enterprises e
LEFT JOIN DW_NB_RLSB_SBJYLYSHBXJBXX ss ON e.UNI_SOCIAL_CRD_CD = ss.UNI_SOCIAL_CRD_CD;

-- ========================================
-- 9. 文化兼旅游行业企业变更活跃度统计
-- ========================================
SELECT
    '文化兼旅游行业企业变更活跃度统计' AS 统计类别,
    COUNT(*) AS 企业总数,
    COUNT(CASE WHEN ci.CHAN_DT IS NOT NULL THEN 1 END) AS 有变更记录企业数,
    COUNT(CASE WHEN ec.ALT_DT IS NOT NULL THEN 1 END) AS 有股权变更企业数,
    COUNT(CASE WHEN gi.EXTERNAL_GUA IS NOT NULL THEN 1 END) AS 有对外担保企业数,
    ROUND(COUNT(CASE WHEN ci.CHAN_DT IS NOT NULL THEN 1 END) * 100.0 / COUNT(*), 2) AS 变更活跃度,
    ROUND(COUNT(CASE WHEN ec.ALT_DT IS NOT NULL THEN 1 END) * 100.0 / COUNT(*), 2) AS 股权变更活跃度,
    ROUND(COUNT(CASE WHEN gi.EXTERNAL_GUA IS NOT NULL THEN 1 END) * 100.0 / COUNT(*), 2) AS 对外担保活跃度
FROM wenhua_and_lyuyou_enterprises e
LEFT JOIN DW_NB_SWBGXX ci ON e.UNI_SOCIAL_CRD_CD = ci.UNI_SOCIAL_CRD_CD
LEFT JOIN DW_NB_SCJDGL_GQBG ec ON e.UNI_SOCIAL_CRD_CD = ec.UNI_SOCIAL_CRD_CD
LEFT JOIN DW_NB_SCJDGL_DWTGBZDBXX gi ON e.UNI_SOCIAL_CRD_CD = gi.UNI_SOCIAL_CRD_CD;

-- ========================================
-- 10. 文化兼旅游行业综合排名TOP20（按资产总额）
-- ========================================
SELECT
    ROW_NUMBER() OVER (ORDER BY ara.ASSET_ZMT DESC) AS 排名,
    e.COMP_NM AS 企业名称,
    e.INDV_NM AS 行业代码,
    e.COMP_TYPE AS 企业类型,
    e.DOMDI_STRICT AS 区县代码,
    ROUND(ara.ASSET_ZMT, 2) AS 资产总额,
    ROUND(ara.OPT_INCOME_TOTAL, 2) AS 营业收入,
    ROUND(ara.PROFIT_TOTAL, 2) AS 利润总额,
    ROUND(ara.NET_PROFIT, 2) AS 净利润,
    ROUND(ara.TAX_TOTAL, 2) AS 纳税总额,
    ROUND(ara.PROFIT_TOTAL / NULLIF(ara.OPT_INCOME_TOTAL, 0) * 100, 2) AS 利润率百分比,
    ROUND(ara.NET_PROFIT / NULLIF(ara.OPT_INCOME_TOTAL, 0) * 100, 2) AS 净利率百分比
FROM wenhua_and_lyuyou_enterprises e
LEFT JOIN DW_NB_SCJDGL_QYNBZCXX ara ON e.UNI_SOCIAL_CRD_CD = ara.UNI_SOCIAL_CRD_CD
WHERE ara.ASSET_ZMT IS NOT NULL AND ara.ASSET_ZMT > 0
ORDER BY ara.ASSET_ZMT DESC
LIMIT 20;

-- ========================================
-- 11. 文化兼旅游行业风险企业TOP20（按风险指标综合评分）
-- ========================================
SELECT
    ROW_NUMBER() OVER (ORDER BY risk_score DESC) AS 风险排名,
    e.COMP_NM AS 企业名称,
    e.INDV_NM AS 行业代码,
    e.COMP_TYPE AS 企业类型,
    e.DOMDI_STRICT AS 区县代码,
    CASE WHEN ba.INCLU_REASON IS NOT NULL THEN '是' ELSE '否' END AS 经营异常,
    CASE WHEN sv.SERILL_REA IS NOT NULL THEN '是' ELSE '否' END AS 严重违法失信,
    CASE WHEN dp.EXECUTE_COURT IS NOT NULL THEN '是' ELSE '否' END AS 失信被执行人,
    CASE WHEN ap.ADMIN_PUNISH_DOC IS NOT NULL THEN '是' ELSE '否' END AS 行政处罚,
    risk_score AS 风险评分
FROM (
    SELECT
        e.UNI_SOCIAL_CRD_CD,
        e.COMP_NM,
        e.INDV_NM,
        e.COMP_TYPE,
        e.DOMDI_STRICT,
        (CASE WHEN ba.INCLU_REASON IS NOT NULL THEN 25 ELSE 0 END) +
        (CASE WHEN sv.SERILL_REA IS NOT NULL THEN 25 ELSE 0 END) +
        (CASE WHEN dp.EXECUTE_COURT IS NOT NULL THEN 25 ELSE 0 END) +
        (CASE WHEN ap.ADMIN_PUNISH_DOC IS NOT NULL THEN 25 ELSE 0 END) AS risk_score
    FROM wenhua_and_lyuyou_enterprises e
    LEFT JOIN DW_ZJ_SCJDGL_JYYCMLXX ba ON e.UNI_SOCIAL_CRD_CD = ba.UNI_SOCIAL_CRD_CD
    LEFT JOIN DW_ZJ_SCJDGL_YZWFSX sv ON e.UNI_SOCIAL_CRD_CD = sv.UNI_SOCIAL_CRD_CD
    LEFT JOIN DW_SHL_QYWLXSXCPXX dp ON e.UNI_SOCIAL_CRD_CD = dp.UNI_SOCIAL_CRD_CD
    LEFT JOIN DW_NB_SCJDGL_XZCFGSXX ap ON e.UNI_SOCIAL_CRD_CD = ap.UNI_SOCIAL_CRD_CD
) risk_analysis
JOIN wenhua_and_lyuyou_enterprises e ON risk_analysis.UNI_SOCIAL_CRD_CD = e.UNI_SOCIAL_CRD_CD
LEFT JOIN DW_ZJ_SCJDGL_JYYCMLXX ba ON e.UNI_SOCIAL_CRD_CD = ba.UNI_SOCIAL_CRD_CD
LEFT JOIN DW_ZJ_SCJDGL_YZWFSX sv ON e.UNI_SOCIAL_CRD_CD = sv.UNI_SOCIAL_CRD_CD
LEFT JOIN DW_SHL_QYWLXSXCPXX dp ON e.UNI_SOCIAL_CRD_CD = dp.UNI_SOCIAL_CRD_CD
LEFT JOIN DW_NB_SCJDGL_XZCFGSXX ap ON e.UNI_SOCIAL_CRD_CD = ap.UNI_SOCIAL_CRD_CD
WHERE risk_score > 0
ORDER BY risk_score DESC
LIMIT 20;

-- ========================================
-- 12. 文化兼旅游行业竞争力分析（按平均资产和利润率）
-- ========================================
SELECT
    e.INDV_NM AS 行业代码,
    COUNT(*) AS 企业数量,
    ROUND(AVG(ara.ASSET_ZMT), 2) AS 平均资产总额,
    ROUND(SUM(ara.ASSET_ZMT), 2) AS 行业总资产,
    ROUND(AVG(ara.OPT_INCOME_TOTAL), 2) AS 平均营业收入,
    ROUND(SUM(ara.OPT_INCOME_TOTAL), 2) AS 行业总收入,
    ROUND(AVG(ara.PROFIT_TOTAL), 2) AS 平均利润总额,
    ROUND(SUM(ara.PROFIT_TOTAL), 2) AS 行业总利润,
    ROUND(AVG(ara.PROFIT_TOTAL / NULLIF(ara.OPT_INCOME_TOTAL, 0)) * 100, 2) AS 平均利润率百分比,
    ROUND(AVG(ara.NET_PROFIT / NULLIF(ara.OPT_INCOME_TOTAL, 0)) * 100, 2) AS 平均净利率百分比
FROM wenhua_and_lyuyou_enterprises e
LEFT JOIN DW_NB_SCJDGL_QYNBZCXX ara ON e.UNI_SOCIAL_CRD_CD = ara.UNI_SOCIAL_CRD_CD
WHERE ara.ASSET_ZMT IS NOT NULL AND ara.OPT_INCOME_TOTAL IS NOT NULL
GROUP BY e.INDV_NM
HAVING COUNT(*) >= 2  -- 只显示有足够样本的行业
ORDER BY 平均资产总额 DESC;
