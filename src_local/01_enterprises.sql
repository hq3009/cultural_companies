-- Step1：获取全部文旅市场主体数据（本地验证版本）
-- 1. 从 dw_zj_scjdgl_scztxx 提取基础企业信息
-- 2. 直接读取CSV文件中的行业代码和社会信用代码
-- 3. 筛选文旅企业并分类

-- 导入CSV数据，创建临时表来存储CSV数据
LOAD DATA INFILE 'industry_codes/indv_nm.txt'
INTO TABLE indus_codes
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
(industry_code);

-- 读取本地数据库 local_db/cul_comp.sql，作为后续分析对象
-- 假设 local_db/cul_comp.sql 已经通过 SOURCE 或其他方式导入到数据库中
-- 这里可以创建一个视图或临时表指向该数据，便于后续分析
CREATE TEMPORARY TABLE IF NOT EXISTS local_cul_comp AS
SELECT * FROM local_db.cul_comp;
-- 直接使用 indus_codes 作为行业代码表，无需再创建文化/旅游产业行业代码临时表
-- 后续查询中可直接通过 indus_codes 进行行业代码的筛选和关联
-- 直接使用 indus_codes 作为文旅行业代码表，无需区分文化和旅游
-- 后续查询中通过 indus_codes 进行行业代码筛选和关联

-- 主要查询：获取文旅市场主体数据
WITH base_enterprises AS (
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
)