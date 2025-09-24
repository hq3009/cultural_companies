-- 基于已创建的 company_core 表，分别创建不同业务领域的扩展表
-- 采用一张表一张表合并的方式，避免复杂连接

-- ==========================================
-- 企业基础信息扩展表
-- ==========================================

-- 企业法定代表人扩展表
DROP TABLE IF EXISTS company_fddb;

CREATE TABLE company_fddb AS
SELECT
    core.*,                 -- 所有核心字段
    fddb.personid,          -- 法定代表人ID
    fddb.lerep_sign,        -- 法定代表人标志/首席代表标志/负责人标识
    fddb.nm AS fddb_nm,    -- 法定代表人姓名
    fddb.position_cn,       -- 职务（中文名称）
    fddb.certype,           -- 证件类型代码
    fddb.certype_cn,        -- 证件类型（中文）
    fddb.cer_no,            -- 身份证件号码
    fddb.tel_num            -- 法定代表人固定电话
FROM company_core core
LEFT JOIN dw_zj_scjdgl_fddbrxx fddb
    ON core.uni_social_crd_cd = fddb.uni_social_crd_cd
    AND fddb.lerep_sign = 1;  -- 只选择法定代表人记录

-- 显示创建结果
SELECT
    COUNT(*) AS total_records,
    COUNT(fddb_nm) AS records_with_fddb_info
FROM company_fddb;

SELECT * FROM company_fddb LIMIT 10;

-- ==========================================
-- 企业信用监管扩展表
-- ==========================================

-- 1. 经营异常名录扩展表
DROP TABLE IF EXISTS company_jyyc;

CREATE TABLE company_jyyc AS
SELECT
    core.*,                 -- 所有核心字段
    jyyc.busexclist,        -- 经营异常名录ID
    jyyc.inclu_dt,          -- 列入日期
    jyyc.inclu_reason,      -- 列入经营异常名录原因
    jyyc.remove_dt,         -- 移出日期
    jyyc.remexcpres_cn,     -- 移出经营异常名录原因
    jyyc.decorg_cn,         -- 作出决定机关(列入)
    jyyc.redecorg_cn        -- 作出决定机关(移出)
FROM company_core core
LEFT JOIN dw_zj_scjdgl_jyycmlxx jyyc ON core.uni_social_crd_cd = jyyc.uni_social_crd_cd;

-- 显示创建结果
SELECT
    COUNT(*) AS total_records,
    COUNT(busexclist) AS records_with_jyyc_info
FROM company_jyyc;

SELECT * FROM company_jyyc LIMIT 10;

-- 2. 严重违法失信企业名单扩展表
DROP TABLE IF EXISTS company_yzwf;

CREATE TABLE company_yzwf AS
SELECT
    core.*,                 -- 所有核心字段
    yzwf.ill_comp_id,       -- 严重违法失信企业名单ID
    yzwf.abn_tm,            -- 列入日期
    yzwf.serill_rea,        -- 列入严重违法失信企业名单原因
    yzwf.rem_dt,            -- 移出日期
    yzwf.rem_excpres_rea,   -- 移出严重违法失信企业名单原因
    yzwf.decorg_org,        -- 作出决定机关(列入)
    yzwf.recorg_ogr         -- 作出决定机关(移出)
FROM company_core core
LEFT JOIN dw_zj_scjdgl_yzwfsx yzwf ON core.uni_social_crd_cd = yzwf.uni_social_crd_cd;

-- 显示创建结果
SELECT
    COUNT(*) AS total_records,
    COUNT(DISTINCT uni_social_crd_cd) AS unique_company,
    COUNT(ill_comp_id) AS records_with_yzwf_info
FROM company_yzwf;

SELECT * FROM company_yzwf LIMIT 10;

-- 3. 失信被执行人扩展表
DROP TABLE IF EXISTS company_sxr;

CREATE TABLE company_sxr AS
SELECT
    core.*,                 -- 所有核心字段
    sxr.executed_nm,        -- 被执行人姓名/名称
    sxr.executed_court,     -- 执行法院
    sxr.case_no,            -- 案号
    sxr.fil_dt,             -- 立案时间
    sxr.publish_dt,         -- 发布时间
    sxr.executed_perfor,    -- 被执行人的履行情况
    sxr.dishonest_behav     -- 失信被执行人行为情况
FROM company_core core
LEFT JOIN dw_zj_fzgg_sxbzxrxx sxr ON core.uni_social_crd_cd = sxr.uni_social_crd_cd;

-- 显示创建结果
SELECT
    COUNT(*) AS total_records,
    COUNT(DISTINCT uni_social_crd_cd) AS unique_company,
    COUNT(executed_nm) AS records_with_sxr_info
FROM company_sxr;

SELECT * FROM company_sxr LIMIT 10;

-- 4. 信用评价扩展表
DROP TABLE IF EXISTS company_xypj;

CREATE TABLE company_xypj AS
SELECT
    core.*,                 -- 所有核心字段
    xypj.cred_scard,        -- 信用分
    xypj.evalu_dt           -- 评价时间
FROM company_core core
LEFT JOIN dw_nb_dsj_xypjxx xypj ON core.uni_social_crd_cd = xypj.uni_social_crd_cd;

-- 显示创建结果
SELECT
    COUNT(*) AS total_records,
    COUNT(DISTINCT uni_social_crd_cd) AS unique_company,
    COUNT(cred_scard) AS records_with_xypj_info
FROM company_xypj;

SELECT * FROM company_xypj LIMIT 10;

-- 5. 行政处罚扩展表
DROP TABLE IF EXISTS company_xzcf;

CREATE TABLE company_xzcf AS
SELECT
    core.*,                 -- 所有核心字段
    xzcf.admin_punish_doc,  -- 行政处罚文号
    xzcf.punish_rea,        -- 处罚原因
    xzcf.punish_dt,         -- 处罚时间
    xzcf.punish_result      -- 处罚结果
FROM company_core core
LEFT JOIN dw_nb_scjdgl_xzcfgsxx xzcf ON core.uni_social_crd_cd = xzcf.uni_social_crd_cd;

-- 显示创建结果
SELECT
    COUNT(*) AS total_records,
    COUNT(DISTINCT uni_social_crd_cd) AS unique_company,
    COUNT(admin_punish_doc) AS records_with_xzcf_info
FROM company_xzcf;

SELECT * FROM company_xzcf LIMIT 10;

-- 6. 行政许可扩展表
DROP TABLE IF EXISTS company_xzxk;

CREATE TABLE company_xzxk AS
SELECT
    core.*,                 -- 所有核心字段
    xzxk.lic_no,            -- 许可文件编号
    xzxk.lic_nm,            -- 许可文件名称
    xzxk.lic_anth,          -- 许可机关
    xzxk.lic_item,          -- 许可内容
    xzxk.val_from,          -- 有效期自
    xzxk.val_to             -- 有效期至
FROM company_core core
LEFT JOIN dw_nb_scjdgl_xzxk xzxk ON core.uni_social_crd_cd = xzxk.uni_social_crd_cd;

-- 显示创建结果
SELECT
    COUNT(*) AS total_records,
    COUNT(DISTINCT uni_social_crd_cd) AS unique_company,
    COUNT(lic_no) AS records_with_xzxk_info
FROM company_xzxk;

SELECT * FROM company_xzxk LIMIT 10;

-- ==========================================
-- 企业财税金融扩展表
-- ==========================================

-- 1. 企业年报资产信息扩展表
DROP TABLE IF EXISTS company_nb;

CREATE TABLE company_nb AS
SELECT
    core.*,                                 -- 所有核心字段
    nb.annual_year AS asset_annual_year,    -- 年报年度
    nb.asset_zmt,                          -- 资产总额
    nb.debt_amt,                           -- 负债总额
    nb.owner_equity_toatal,                -- 所有者权益合计
    nb.opt_income_total,                   -- 营业总收入
    nb.profit_total,                       -- 利润总额
    nb.net_profit,                         -- 净利润
    nb.tax_total AS annual_tax_total       -- 年报纳税总额
FROM company_core core
LEFT JOIN dw_nb_scjdgl_qynbzcxx nb ON core.uni_social_crd_cd = nb.uni_social_crd_cd;

-- 显示创建结果
SELECT
    COUNT(*) AS total_records,
    COUNT(DISTINCT uni_social_crd_cd) AS unique_company,
    COUNT(asset_zmt) AS records_with_asset_info
FROM company_nb;

SELECT * FROM company_nb LIMIT 10;

-- 2. 纳税信息扩展表
DROP TABLE IF EXISTS company_ns;

CREATE TABLE company_ns AS
SELECT
    core.*,                 -- 所有核心字段
    ns.tax_amt,             -- 税额总额
    ns.sale_inco,           -- 销售收入
    ns.count_dt             -- 统计时间
FROM company_core core
LEFT JOIN dw_nb_sw_nsxx ns ON core.uni_social_crd_cd = ns.uni_social_crd_cd;

-- 显示创建结果
SELECT
    COUNT(*) AS total_records,
    COUNT(DISTINCT uni_social_crd_cd) AS unique_company,
    COUNT(tax_amt) AS records_with_tax_info
FROM company_ns;

SELECT * FROM company_ns LIMIT 10;

-- 3. A级纳税人信用评价信息扩展表
DROP TABLE IF EXISTS company_xypj_a;

CREATE TABLE company_xypj_a AS
SELECT
    core.*,                 -- 所有核心字段
    xypj.credi_scard,       -- 信用分
    xypj.tax_credi_level,   -- 纳税信用等级
    xypj.eval_year,         -- 纳税信用等级评定年度
    xypj.eval_dt,           -- 纳税信用等级评定日期
    xypj.eval_org,          -- 评价机构
    xypj.major_tax_org      -- 主管税务机关
FROM company_core core
LEFT JOIN dw_nb_sw_xypjxxa xypj ON core.uni_social_crd_cd = xypj.uni_social_crd_cd;

-- 显示创建结果
SELECT
    COUNT(*) AS total_records,
    COUNT(DISTINCT uni_social_crd_cd) AS unique_company,
    COUNT(tax_credi_level) AS records_with_tax_credit_info
FROM company_xypj_a;

SELECT * FROM company_xypj_a LIMIT 10;

-- 4. 社保缴纳信息扩展表
DROP TABLE IF EXISTS company_sb;

CREATE TABLE company_sb AS
SELECT
    core.*,                 -- 所有核心字段
    sb.coll_item,       -- 征收项目
    sb.period_from,     -- 税款所属期起
    sb.period_to,       -- 税款所属期止
    sb.tax_type,        -- 税款种类
    sb.paid_amt         -- 实缴金额
FROM company_core core
LEFT JOIN dw_nb_sw_sbjnxx sb ON core.uni_social_crd_cd = sb.uni_social_crd_cd;

-- 显示创建结果
SELECT
    COUNT(*) AS total_records,
    COUNT(DISTINCT uni_social_crd_cd) AS unique_company,
    COUNT(paid_amt) AS records_with_sb_payment_info
FROM company_sb;

SELECT * FROM company_sb LIMIT 10;

-- 5. 公积金年度缴存信息扩展表
DROP TABLE IF EXISTS company_gjj;

CREATE TABLE company_gjj AS
SELECT
    core.*,                     -- 所有核心字段
    gjj_year.pay_amt AS annual_housing_fund,  -- 缴存总金额
    gjj_year.pay_year,          -- 缴存年度
    gjj_year.unit_acco          -- 单位账号
FROM company_core core
LEFT JOIN dw_zj_js_qygjjndjcxx gjj_year ON core.uni_social_crd_cd = gjj_year.uni_social_crd_cd;

-- 显示创建结果
SELECT
    COUNT(*) AS total_records,
    COUNT(DISTINCT uni_social_crd_cd) AS unique_company,
    COUNT(annual_housing_fund) AS records_with_gjj_info
FROM company_gjj;

SELECT * FROM company_gjj LIMIT 10;

-- 6. 对外提供保证担保信息扩展表
DROP TABLE IF EXISTS company_db;

CREATE TABLE company_db AS
SELECT
    core.*,                 -- 所有核心字段
    db.creditor,            -- 债权人
    db.debtor,              -- 债务人
    db.major_credit_type,   -- 主债权种类
    db.major_credit_amt,    -- 主债权数额
    db.period_from AS guarantee_from,  -- 履行债务的期限自
    db.period_to AS guarantee_to,      -- 履行债务的期限至
    db.promis_dur,          -- 保证的期间
    db.is_public,           -- 对外担保是否公示
    db.promis_way           -- 保证的方式
FROM company_core core
LEFT JOIN dw_nb_scjdgl_dwtgbzdbxx db ON core.uni_social_crd_cd = db.uni_social_crd_cd;

-- 显示创建结果
SELECT
    COUNT(*) AS total_records,
    COUNT(DISTINCT uni_social_crd_cd) AS unique_company,
    COUNT(creditor) AS records_with_guarantee_info
FROM company_db;

SELECT * FROM company_db LIMIT 10;

-- ==========================================
-- 企业科技服务扩展表
-- ==========================================

-- 1. 高新技术企业信息扩展表
DROP TABLE IF EXISTS company_gxjs;

CREATE TABLE company_gxjs AS
SELECT
    core.*,                 -- 所有核心字段
    gxjs.high_tech_doc,     -- 高企证书号
    gxjs.issue_dt,          -- 发证日期
    gxjs.award_cert,        -- 颁证单位
    gxjs.trust_info_nm,     -- 守信信息名称
    gxjs.cogn_basis         -- 认定依据
FROM company_core core
LEFT JOIN dw_nb_kj_gxjsqyxx gxjs ON core.uni_social_crd_cd = gxjs.hold_cert_cd;

-- 显示创建结果
SELECT
    COUNT(*) AS total_records,
    COUNT(DISTINCT uni_social_crd_cd) AS unique_company,
    COUNT(high_tech_doc) AS records_with_high_tech_info
FROM company_gxjs;

SELECT * FROM company_gxjs LIMIT 10;

-- 2. 省级科技型中小企业信息扩展表
DROP TABLE IF EXISTS company_sjkj;

CREATE TABLE company_sjkj AS
SELECT
    core.*,                 -- 所有核心字段
    sjkj.year_id AS tech_sme_year,  -- 认定年份
    sjkj.name AS tech_sme_name,     -- 企业名称
    sjkj.area_name          -- 区县市
FROM company_core core
LEFT JOIN dw_nb_kj_sjkjxzxqyxx sjkj ON core.comp_nm = sjkj.name;

-- 显示创建结果
SELECT
    COUNT(*) AS total_records,
    COUNT(DISTINCT uni_social_crd_cd) AS unique_company,
    COUNT(tech_sme_year) AS records_with_provincial_tech_sme_info
FROM company_sjkj;

SELECT * FROM company_sjkj LIMIT 10;

-- 3. 科技型小微企业信息扩展表
DROP TABLE IF EXISTS company_kjxw;

CREATE TABLE company_kjxw AS
SELECT
    core.*,                 -- 所有核心字段
    kjxw.cogn_year,         -- 认定年份
    kjxw.cogn_unit          -- 认定机构
FROM company_core core
LEFT JOIN dw_nb_kj_nbskjxxwqyxx kjxw ON core.comp_nm = kjxw.comp_nm;

-- 显示创建结果
SELECT
    COUNT(*) AS total_records,
    COUNT(DISTINCT uni_social_crd_cd) AS unique_company,
    COUNT(cogn_year) AS records_with_tech_micro_info
FROM company_kjxw;

SELECT * FROM company_kjxw LIMIT 10;

-- 4. 高成长科技型中小企业信息扩展表
DROP TABLE IF EXISTS company_kjzx;

CREATE TABLE company_kjzx AS
SELECT
    core.*,                 -- 所有核心字段
    kjzx.congniz_tear AS congniz_year,      -- 认定年份，这里原始表有拼写错误, year/tear
    kjzx.congniz_org        -- 认定机构
FROM company_core core
LEFT JOIN dw_nb_kj_sgczkjxzxqy kjzx ON core.comp_nm = kjzx.comp_nm;

-- 显示创建结果
SELECT
    COUNT(*) AS total_records,
    COUNT(DISTINCT uni_social_crd_cd) AS unique_company,
    COUNT(congniz_tear) AS records_with_high_growth_tech_info
FROM company_kjzx;

SELECT * FROM company_kjzx LIMIT 10;

-- ==========================================
-- 企业社保就业扩展表
-- ==========================================

-- 1. 企业社保参保人数信息扩展表
DROP TABLE IF EXISTS company_sb_cbrs;

CREATE TABLE company_sb_cbrs AS
SELECT
    core.*,                 -- 所有核心字段
    cb.rece_ym,             -- 应收年月
    cb.mon_insurd_prsons,   -- 月参保总人数
    cb.corp_nature,         -- 单位性质
    cb.indv_class,          -- 行业分类
    cb.econ_nature,         -- 经济性质
    cb.corp_local_street,   -- 单位所处街道
    cb.admin_region         -- 行政区
FROM company_core core
LEFT JOIN dw_nb_rlsb_qysbcbrsxx cb ON core.uni_social_crd_cd = cb.uni_social_crd_cd;

-- 显示创建结果
SELECT
    COUNT(*) AS total_records,
    COUNT(DISTINCT uni_social_crd_cd) AS unique_company,
    COUNT(mon_insurd_prsons) AS records_with_insurance_count_info
FROM company_sb_cbrs;

SELECT * FROM company_sb_cbrs LIMIT 10;

-- 2. 社会保险基本信息扩展表
DROP TABLE IF EXISTS company_sb_jbxx;

CREATE TABLE company_sb_jbxx AS
SELECT
    core.*,                 -- 所有核心字段
    sb.pens_num,            -- 养老保险人数
    sb.medic_num,           -- 医疗保险人数
    sb.unemploy_num,        -- 失业保险人数
    sb.injury_num,          -- 工伤保险人数
    sb.materni_num,         -- 生育保险人数
    sb.pens_pay_ym,         -- 养老保险缴费年月
    sb.medic_pay_ym,        -- 医疗保险缴费年月
    sb.unemploy_pay_ym,     -- 失业保险缴费年月
    sb.injury_pay_ym,       -- 工伤保险缴费年月
    sb.materni_pay_ym,      -- 生育保险缴费年月
    sb.stat AS insurance_status  -- 当前状态
FROM company_core core
LEFT JOIN dw_nb_rlsb_sbjylyshbxjbxx sb ON core.uni_social_crd_cd = sb.uni_social_crd_cd;

-- 显示创建结果
SELECT
    COUNT(*) AS total_records,
    COUNT(DISTINCT uni_social_crd_cd) AS unique_company,
    COUNT(pens_num) AS records_with_pension_info
FROM company_sb_jbxx;

SELECT * FROM company_sb_jbxx LIMIT 10;

-- 3. 人员参保信息扩展表
DROP TABLE IF EXISTS company_sb_rycb;

CREATE TABLE company_sb_rycb AS
SELECT
    core.*,                 -- 所有核心字段
    ry.issue_stat,          -- 参保状态
    ry.corre_fee_period,    -- 对应费款所属期
    ry.issue_type,          -- 险种
    ry.admin_area           -- 行政区划
FROM company_core core
LEFT JOIN dw_nb_rlsb_sbjylyrycbxx ry ON core.uni_social_crd_cd = ry.tax_reg_no;

-- 显示创建结果
SELECT
    COUNT(*) AS total_records,
    COUNT(DISTINCT uni_social_crd_cd) AS unique_company,
    COUNT(issue_stat) AS records_with_personnel_info
FROM company_sb_rycb;

SELECT * FROM company_sb_rycb LIMIT 10;

-- ==========================================
-- 企业经营活动扩展表
-- ==========================================

-- 1. 企业年报网站或网店信息扩展表
DROP TABLE IF EXISTS company_wzwd;

CREATE TABLE company_wzwd AS
SELECT
    core.*,                 -- 所有核心字段
    wz.web_id,              -- 网站标识
    wz.web_store_type,      -- 网站网店类型
    wz.web_store_nm,        -- 网站（网店）名称
    wz.web_store_url,       -- 网站（网店）网址
    wz.web_type,            -- 网站类型
    wz.ecom_type,           -- 电商类型
    wz.icp_no,              -- ICP证号/备案号
    wz.app_nm,              -- APP软件名称
    wz.plat_nm              -- 所属平台名称
FROM company_core core
LEFT JOIN dw_nb_scjdgl_qynbwzhwdxx wz ON core.uni_social_crd_cd = wz.uni_social_crd_cd;

-- 显示创建结果
SELECT
    COUNT(*) AS total_records,
    COUNT(DISTINCT uni_social_crd_cd) AS unique_company,
    COUNT(web_id) AS records_with_website_info
FROM company_wzwd;

SELECT * FROM company_wzwd LIMIT 10;

-- 2. 股权变更信息扩展表
DROP TABLE IF EXISTS company_gqbg;

CREATE TABLE company_gqbg AS
SELECT
    core.*,                 -- 所有核心字段
    gqbg.inv,               -- 股东
    gqbg.alt_dt,            -- 股权变更日期
    gqbg.public_dt,         -- 公示日期
    gqbg.transampr_bf,      -- 变更前股权比例
    gqbg.transampr_af       -- 变更后股权比例
FROM company_core core
LEFT JOIN dw_nb_scjdgl_gqbg gqbg ON core.uni_social_crd_cd = gqbg.uni_social_crd_cd;

-- 显示创建结果
SELECT
    COUNT(*) AS total_records,
    COUNT(DISTINCT uni_social_crd_cd) AS unique_company,
    COUNT(inv) AS records_with_equity_change_info
FROM company_gqbg;

SELECT * FROM company_gqbg LIMIT 10;

-- 3. 股东及出资信息扩展表
DROP TABLE IF EXISTS company_gdcz;

CREATE TABLE company_gdcz AS
SELECT
    core.*,                 -- 所有核心字段
    gd.stocker_nm,          -- 股东/发起人名称
    gd.cumula_sub_amt,      -- 累计认缴额
    gd.subscrip_amt_dt,     -- 认缴出资日期
    gd.subscrip_amt_way_cn, -- 认缴出资方式中文名称
    gd.cumula_paid_amt,     -- 累计实缴额
    gd.paid_amt_dt,         -- 实缴出资日期
    gd.paid_amt_way_cn      -- 实缴出资方式中文名称
FROM company_core core
LEFT JOIN dw_nb_scjdgl_qynbgdjczxx gd ON core.uni_social_crd_cd = gd.uni_social_crd_cd;

-- 显示创建结果
SELECT
    COUNT(*) AS total_records,
    COUNT(DISTINCT uni_social_crd_cd) AS unique_company,
    COUNT(stocker_nm) AS records_with_shareholder_info
FROM company_gdcz;

SELECT * FROM company_gdcz LIMIT 10;

-- 4. 餐饮经营许可证信息扩展表
DROP TABLE IF EXISTS company_cyjy;

CREATE TABLE company_cyjy AS
SELECT
    core.*,                 -- 所有核心字段
    cy.subject_stat         -- 主体业态
FROM company_core core
LEFT JOIN dw_nb_scjdgl_cyjyxkzxx cy ON core.uni_social_crd_cd = cy.uni_social_crd_cd;

-- 显示创建结果
SELECT
    COUNT(*) AS total_records,
    COUNT(DISTINCT uni_social_crd_cd) AS unique_company,
    COUNT(subject_stat) AS records_with_catering_license_info
FROM company_cyjy;

SELECT * FROM company_cyjy LIMIT 10;

-- 5. 企业资质证书信息扩展表
DROP TABLE IF EXISTS company_zzzs;

CREATE TABLE company_zzzs AS
SELECT
    core.*,                 -- 所有核心字段
    zz.cert_no,             -- 证书编号
    zz.issure_org,          -- 发证机关
    zz.start_dt,            -- 起始日期
    zz.end_dt               -- 终止日期
FROM company_core core
LEFT JOIN dw_nb_jt_qyzhzsxx zz ON core.uni_social_crd_cd = zz.uni_social_crd_cd;

-- 显示创建结果
SELECT
    COUNT(*) AS total_records,
    COUNT(DISTINCT uni_social_crd_cd) AS unique_company,
    COUNT(cert_no) AS records_with_qualification_info
FROM company_zzzs;

SELECT * FROM company_zzzs LIMIT 10;
