-- 企业扩展信息表（使用窗口函数优化版本）
-- 使用聚合函数避免一对多关系导致的数据膨胀，确保每个企业只有一条记录
-- 采用窗口函数替代子查询，提升查询性能

CREATE TABLE enterprises_extended AS
WITH latest_records AS (
    SELECT
        ent.*,

        -- 法定代表人信息（使用窗口函数获取最新记录）
        fddb.IDENTI_ID AS FDDB_IDENTI_ID,
        fddb.INDV_NM AS FDDB_INDV_NM,
        fddb.LEREP_SIGN,
        fddb.REG_DT AS FDDB_REG_DT,
        ROW_NUMBER() OVER (PARTITION BY fddb.UNI_SOCIAL_CRD_CD ORDER BY fddb.REG_DT DESC) AS fddb_rn,

        -- 经营异常名录信息
        jyyc.INCLU_DT AS JYYC_INCLU_DT,
        jyyc.INCLU_REASON AS JYYC_INCLU_REASON,
        ROW_NUMBER() OVER (PARTITION BY jyyc.UNI_SOCIAL_CRD_CD ORDER BY jyyc.INCLU_DT DESC) AS jyyc_rn,

        -- 严重违法失信企业名单信息
        sxqy.ABN_TM AS SXQY_ABN_TM,
        sxqy.SERILL_REA AS SXQY_SERILL_REA,
        ROW_NUMBER() OVER (PARTITION BY sxqy.UNI_SOCIAL_CRD_CD ORDER BY sxqy.ABN_TM DESC) AS sxqy_rn,

        -- 网站信息
        wz.WEB_STORE_URL,
        wz.WEB_TYPE,
        wz.ECOM_TYPE,
        wz.ICP_NO,
        wz.ANNUAL_ID AS WEB_ANNUAL_ID,
        ROW_NUMBER() OVER (PARTITION BY wz.UNI_SOCIAL_CRD_CD ORDER BY CAST(wz.ANNUAL_ID AS INTEGER) DESC) AS wz_rn,

        -- 股权变更信息
        gqbg.ALT_DT AS GQBG_ALT_DT,
        gqbg.INV AS GQBG_INV,
        ROW_NUMBER() OVER (PARTITION BY gqbg.UNI_SOCIAL_CRD_CD ORDER BY gqbg.ALT_DT DESC) AS gqbg_rn,

        -- 企业年报资产信息
        nb.ANNUAL_YEAR AS ASSET_ANNUAL_YEAR,
        nb.ASSET_ZMT,
        nb.DEBT_AMT,
        nb.OWNER_EQUITY,
        nb.SALE_INCO AS ASSET_SALE_INCO,
        nb.NET_PROFIT,
        nb.TAX_TOTAL,
        ROW_NUMBER() OVER (PARTITION BY nb.UNI_SOCIAL_CRD_CD ORDER BY nb.ANNUAL_YEAR DESC) AS nb_rn,

        -- 担保信息
        db.CREDITOR AS DB_CREDITOR,
        db.MAJOR_CREDIT_AMT AS DB_MAJOR_CREDIT_AMT,
        ROW_NUMBER() OVER (PARTITION BY db.UNI_SOCIAL_CRD_CD ORDER BY db.GUARANTEE_DT DESC) AS db_rn,

        -- 科技型小微企业信息
        kjzx.CONGNIZ_ORG AS KJZX_CONGNIZ_ORG,
        kjzx.CONGNIZ_TEAR AS KJZX_CONGNIZ_TEAR,

        -- 失信被执行人信息
        sxr.EXECUTED_NM AS SXR_EXECUTED_NM,
        sxr.EXECUTED_COURT AS SXR_EXECUTED_COURT,
        sxr.FIL_DT AS SXR_FIL_DT,
        ROW_NUMBER() OVER (PARTITION BY sxr.UNI_SOCIAL_CRD_CD ORDER BY sxr.FIL_DT DESC) AS sxr_rn,

        -- 纳税信息
        ns.TAX_AMT AS NS_TAX_AMT,
        ns.SALE_INCO AS NS_SALE_INCO,
        ns.COUNT_DT AS NS_COUNT_DT,
        ROW_NUMBER() OVER (PARTITION BY ns.UNI_SOCIAL_CRD_CD ORDER BY ns.COUNT_DT DESC) AS ns_rn,

        -- 信用评价信息
        xypj.CRED_SCARD AS XYPJ_CRED_SCARD,

        -- 纳税信用评价信息（A级纳税人）
        xypja.CREDI_SCARD AS TAX_CREDI_SCARD,
        xypja.TAX_CREDI_LEVEL,
        xypja.EVAL_YEAR,
        xypja.EVAL_DT AS TAX_EVAL_DT,
        xypja.MAJOR_TAX_ORG,

        -- 社会保险基本信息（只保留养老保险人数）
        sb.PENS_NUM,
        sb.PENS_PAY_YM,
        ROW_NUMBER() OVER (PARTITION BY sb.UNI_SOCIAL_CRD_CD ORDER BY sb.PENS_PAY_YM DESC) AS sb_rn,

        -- 行政处罚公示信息
        xzcf.ADMIN_PUNISH_DOC AS XZCF_ADMIN_PUNISH_DOC,
        xzcf.PUNISH_DT AS XZCF_PUNISH_DT,
        xzcf.PUNISH_REA AS XZCF_PUNISH_REA,
        ROW_NUMBER() OVER (PARTITION BY xzcf.UNI_SOCIAL_CRD_CD ORDER BY xzcf.PUNISH_DT DESC) AS xzcf_rn

    FROM enterprises ent
    -- 法定代表人信息
    LEFT JOIN DW_ZJ_SCJDGL_FDDBRXX fddb ON ent.UNI_SOCIAL_CRD_CD = fddb.UNI_SOCIAL_CRD_CD AND fddb.LEREP_SIGN = 1
    -- 经营异常名录信息
    LEFT JOIN DW_ZJ_SCJDGL_JYYCMLXX jyyc ON ent.UNI_SOCIAL_CRD_CD = jyyc.UNI_SOCIAL_CRD_CD
    -- 严重违法失信企业名单信息
    LEFT JOIN DW_ZJ_SCJDGL_YZWFSX sxqy ON ent.UNI_SOCIAL_CRD_CD = sxqy.UNI_SOCIAL_CRD_CD
    -- 网站信息
    LEFT JOIN DW_NB_SCJDGL_QYNBWZHWDXX wz ON ent.UNI_SOCIAL_CRD_CD = wz.UNI_SOCIAL_CRD_CD
    -- 股权变更信息
    LEFT JOIN DW_NB_SCJDGL_GQBG gqbg ON ent.UNI_SOCIAL_CRD_CD = gqbg.UNI_SOCIAL_CRD_CD
    -- 企业年报资产信息
    LEFT JOIN DW_NB_SCJDGL_QYNBZCXX nb ON ent.UNI_SOCIAL_CRD_CD = nb.UNI_SOCIAL_CRD_CD
    -- 担保信息
    LEFT JOIN DW_NB_SCJDGL_DBXX db ON ent.UNI_SOCIAL_CRD_CD = db.UNI_SOCIAL_CRD_CD
    -- 科技型小微企业信息
    LEFT JOIN DW_NB_KJ_SGCZKJXZXQY kjzx ON ent.UNI_SOCIAL_CRD_CD = kjzx.UNI_SOCIAL_CRD_CD
    -- 失信被执行人信息
    LEFT JOIN DW_ZJ_FZGG_SXBZXRXX sxr ON ent.UNI_SOCIAL_CRD_CD = sxr.UNI_SOCIAL_CRD_CD
    -- 纳税信息
    LEFT JOIN DW_NB_SW_NSXX ns ON ent.UNI_SOCIAL_CRD_CD = ns.UNI_SOCIAL_CRD_CD
    -- 信用评价信息
    LEFT JOIN DW_NB_DSJ_XYPJXX xypj ON ent.UNI_SOCIAL_CRD_CD = xypj.UNI_SOCIAL_CRD_CD
    -- 纳税信用评价信息（A级纳税人）
    LEFT JOIN DW_NB_SW_XYPJXXA xypja ON ent.UNI_SOCIAL_CRD_CD = xypja.UNI_SOCIAL_CRD_CD
    -- 社会保险基本信息
    LEFT JOIN DW_NB_RLSB_SBJYLYSHBXJBXX sb ON ent.UNI_SOCIAL_CRD_CD = sb.UNI_SOCIAL_CRD_CD
    -- 行政处罚公示信息
    LEFT JOIN DW_NB_SCJDGL_XZCFGSXX xzcf ON ent.UNI_SOCIAL_CRD_CD = xzcf.UNI_SOCIAL_CRD_CD
),
aggregated_counts AS (
    SELECT
        UNI_SOCIAL_CRD_CD,
        -- 计数统计
        COUNT(DISTINCT fddb.IDENTI_ID) AS FDDB_COUNT,
        COUNT(DISTINCT jyyc.INCLU_DT) AS JYYC_COUNT,
        COUNT(DISTINCT sxqy.ABN_TM) AS SXQY_COUNT,
        COUNT(DISTINCT gqbg.ALT_DT) AS GQBG_COUNT,
        COUNT(DISTINCT sxr.FIL_DT) AS SXR_COUNT,
        COUNT(DISTINCT db.GUARANTEE_DT) AS DB_COUNT,
        COUNT(DISTINCT xzcf.PUNISH_DT) AS XZCF_COUNT
    FROM latest_records
    GROUP BY UNI_SOCIAL_CRD_CD
)
SELECT
    -- 企业基本信息
    ent.REG_ORG,
    ent.COMP_TYPE,
    ent.REG_STATE,
    ent.UNI_SOCIAL_CRD_CD,
    ent.COMP_NM,
    ent.ADDR,
    ent.LEGAL_REPRE,
    ent.INDV_ID,
    ent.REG_CAPT,
    ent.CAPT_KIND,
    ent.OPT_SCOP,
    ent.REG_NO,
    ent.APPR_DT,
    ent.EST_DT,
    ent.OPT_FROM,
    ent.OPT_TO,
    ent.DOMDI_STRICT,
    ent.OPT_STRICT,
    ent.POSTAL_CODE,
    ent.INDV_NM,

    -- 法定代表人信息
    CASE WHEN lr.fddb_rn = 1 THEN lr.FDDB_IDENTI_ID END AS FDDB_IDENTI_ID,
    CASE WHEN lr.fddb_rn = 1 THEN lr.FDDB_INDV_NM END AS FDDB_INDV_NM,
    CASE WHEN lr.fddb_rn = 1 THEN lr.LEREP_SIGN END AS LEREP_SIGN,
    CASE WHEN lr.fddb_rn = 1 THEN lr.FDDB_REG_DT END AS FDDB_REG_DT,
    ac.FDDB_COUNT,

    -- 经营异常名录信息
    CASE WHEN lr.jyyc_rn = 1 THEN lr.JYYC_INCLU_DT END AS JYYC_LATEST_INCLU_DT,
    CASE WHEN lr.jyyc_rn = 1 THEN lr.JYYC_INCLU_REASON END AS JYYC_LATEST_REASON,
    ac.JYYC_COUNT,

    -- 严重违法失信企业名单信息
    CASE WHEN lr.sxqy_rn = 1 THEN lr.SXQY_SERILL_REA END AS LATEST_SERILL_REA,
    ac.SXQY_COUNT,

    -- 网站信息（按最新年报年度）
    CASE WHEN lr.wz_rn = 1 THEN lr.WEB_STORE_URL END AS WEB_STORE_URL,
    CASE WHEN lr.wz_rn = 1 THEN lr.WEB_TYPE END AS WEB_TYPE,
    CASE WHEN lr.wz_rn = 1 THEN lr.ECOM_TYPE END AS ECOM_TYPE,
    CASE WHEN lr.wz_rn = 1 THEN lr.ICP_NO END AS ICP_NO,

    -- 股权变更信息
    CASE WHEN lr.gqbg_rn = 1 THEN lr.GQBG_ALT_DT END AS LATEST_GQBG_DT,
    CASE WHEN lr.gqbg_rn = 1 THEN lr.GQBG_INV END AS LATEST_INV,
    ac.GQBG_COUNT,

    -- 企业年报资产信息
    CASE WHEN lr.nb_rn = 1 THEN lr.ASSET_ZMT END AS ASSET_ZMT,
    CASE WHEN lr.nb_rn = 1 THEN lr.DEBT_AMT END AS DEBT_AMT,
    CASE WHEN lr.nb_rn = 1 THEN lr.OWNER_EQUITY END AS OWNER_EQUITY,
    CASE WHEN lr.nb_rn = 1 THEN lr.ASSET_SALE_INCO END AS ASSET_SALE_INCO,
    CASE WHEN lr.nb_rn = 1 THEN lr.NET_PROFIT END AS NET_PROFIT,
    CASE WHEN lr.nb_rn = 1 THEN lr.TAX_TOTAL END AS TAX_TOTAL,

    -- 担保信息
    CASE WHEN lr.db_rn = 1 THEN lr.DB_CREDITOR END AS LATEST_CREDITOR,
    CASE WHEN lr.db_rn = 1 THEN lr.DB_MAJOR_CREDIT_AMT END AS LATEST_CREDIT_AMT,
    ac.DB_COUNT,

    -- 科技型小微企业信息
    lr.KJZX_CONGNIZ_ORG,
    lr.KJZX_CONGNIZ_TEAR,

    -- 失信被执行人信息
    CASE WHEN lr.sxr_rn = 1 THEN lr.SXR_EXECUTED_NM END AS LATEST_EXECUTED_NM,
    CASE WHEN lr.sxr_rn = 1 THEN lr.SXR_EXECUTED_COURT END AS LATEST_EXECUTED_COURT,
    CASE WHEN lr.sxr_rn = 1 THEN lr.SXR_FIL_DT END AS LATEST_FIL_DT,
    ac.SXR_COUNT,

    -- 纳税信息
    CASE WHEN lr.ns_rn = 1 THEN lr.NS_TAX_AMT END AS TAX_AMT,
    CASE WHEN lr.ns_rn = 1 THEN lr.NS_SALE_INCO END AS SALE_INCO,
    CASE WHEN lr.ns_rn = 1 THEN lr.NS_COUNT_DT END AS COUNT_DT,

    -- 信用评价信息
    lr.XYPJ_CRED_SCARD,

    -- 纳税信用评价信息（A级纳税人）
    lr.TAX_CREDI_SCARD,
    lr.TAX_CREDI_LEVEL,
    lr.EVAL_YEAR,
    lr.TAX_EVAL_DT,
    lr.MAJOR_TAX_ORG,

    -- 社会保险基本信息（最新养老保险缴费年月）
    CASE WHEN lr.sb_rn = 1 THEN lr.PENS_NUM END AS PENS_NUM,

    -- 行政处罚公示信息
    CASE WHEN lr.xzcf_rn = 1 THEN lr.XZCF_ADMIN_PUNISH_DOC END AS LATEST_PUNISH_DOC,
    CASE WHEN lr.xzcf_rn = 1 THEN lr.XZCF_PUNISH_DT END AS LATEST_PUNISH_DT,
    CASE WHEN lr.xzcf_rn = 1 THEN lr.XZCF_PUNISH_REA END AS LATEST_PUNISH_REA,
    ac.XZCF_COUNT

FROM enterprises ent
JOIN latest_records lr ON ent.UNI_SOCIAL_CRD_CD = lr.UNI_SOCIAL_CRD_CD
JOIN aggregated_counts ac ON ent.UNI_SOCIAL_CRD_CD = ac.UNI_SOCIAL_CRD_CD
WHERE lr.fddb_rn = 1 OR lr.fddb_rn IS NULL  -- 只保留每个企业的一条记录
GROUP BY
    ent.REG_ORG, ent.COMP_TYPE, ent.REG_STATE, ent.UNI_SOCIAL_CRD_CD,
    ent.COMP_NM, ent.ADDR, ent.LEGAL_REPRE, ent.INDV_ID, ent.REG_CAPT,
    ent.CAPT_KIND, ent.OPT_SCOP, ent.REG_NO, ent.APPR_DT, ent.EST_DT,
    ent.OPT_FROM, ent.OPT_TO, ent.DOMDI_STRICT, ent.OPT_STRICT,
    ent.POSTAL_CODE, ent.INDV_NM;
