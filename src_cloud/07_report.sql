-- ========================================
-- 宁波文旅行业报告数据查询
-- 基于报告大纲：report/文旅行业报告.md
-- 基础数据已经由 01_comp_init.sql 生成，并粘贴到本文档
-- 扩展数据已经由 02_comp_ext_aggr_steps.sql 生成，部分代码并粘贴到本文档
-- ========================================

-- =========================
-- 按照《国民经济行业分类》中的“文化、体育和娱乐业”筛选企业
-- 文化、体育和娱乐业经营主体共XX家，其中公司制企业XX家，个体工商户XX家
-- =========================

DROP TABLE IF EXISTS wentiyu;

CREATE TABLE wentiyu AS
    SELECT
        uni_social_crd_cd,      -- 统一社会信用代码
        comp_nm,                -- 企业名称（字号名称）
        indv_nm,                -- 行业代码
        comp_type,              -- 企业类型
        reg_state,              -- 登记状态
        reg_org,                -- 登记机关
        est_dt,                 -- 成立日期
        opt_strict              -- 生产经营地所在行政区划
    FROM dw_zj_scjdgl_scztxx
    WHERE SUBSTRING(TRIM(indv_nm), 1, 2) IN ('86', '87', '88', '89', '90')
    ORDER BY uni_social_crd_cd;

SELECT COUNT(DISTINCT uni_social_crd_cd) from wentiyu;

-- 显示前面20条记录
SELECT * FROM wentiyu LIMIT 20;

-- 计算有多少种 comp_type 的值
SELECT COUNT(DISTINCT(comp_type)) FROM wentiyu;

-- =========================
-- 创建带有企业类型信息的 wentiyu 扩展表
-- 将 wentiyu 表与 comp_type 表进行 LEFT JOIN
-- =========================

DROP TABLE IF EXISTS wentiyu_with_type;

CREATE TABLE wentiyu_with_type AS
SELECT
    w.uni_social_crd_cd,
    w.comp_nm,
    w.indv_nm,
    w.comp_type,
    ct.comp_type_name,
    ct.comp_dalei,
    w.reg_state,
    w.reg_org,
    w.est_dt,
    w.opt_strict
FROM wentiyu w
LEFT JOIN comp_type ct ON w.comp_type = ct.comp_type
ORDER BY w.uni_social_crd_cd;

-- 查看扩展后的表
SELECT COUNT(*) AS total_type_num FROM wentiyu_with_type;
SELECT * FROM wentiyu_with_type LIMIT 20;

-- 统计各企业大类的数量
SELECT
    ct.comp_dalei,
    COUNT(*) AS comp_count
FROM wentiyu_with_type ct
WHERE ct.comp_dalei IS NOT NULL
GROUP BY ct.comp_dalei
ORDER BY comp_count DESC;

-- 统计各企业类型的数量（前20个）
SELECT
    ct.comp_type,
    ct.comp_type_name,
    ct.comp_dalei,
    COUNT(*) AS comp_count
FROM wentiyu_with_type ct
WHERE ct.comp_type_name IS NOT NULL
GROUP BY ct.comp_type, ct.comp_type_name, ct.comp_dalei
ORDER BY comp_count DESC
LIMIT 20;

-- 统计经营状况数量
SELECT
    ct.reg_state,
    COUNT(*) AS comp_count
FROM wentiyu_with_type ct
WHERE ct.reg_state IS NOT NULL
GROUP BY ct.reg_state
ORDER BY comp_count DESC;

-- 文体娱行业中"公司"类型企业数量

DROP TABLE IF EXISTS wentiyu_gongsi;

CREATE TABLE wentiyu_gongsi AS
SELECT * FROM wentiyu
WHERE comp_type IN ('1000', '1100', '1110', '1120', '1121', '1122', '1123', '1124', '1130', '1140', '1150', '1151', '1152', '1153', '1154', '1190', '1200', '1210', '1211', '1212', '1213', '1219', '1220', '1221', '1222', '1223', '1229');

SELECT COUNT(DISTINCT uni_social_crd_cd) FROM wentiyu_gongsi;


-- 文体娱行业中"个体工商户"类型企业数量

DROP TABLE IF EXISTS wentiyu_geti;

CREATE TABLE wentiyu_geti AS
SELECT * FROM wentiyu
WHERE comp_type IN ('0450', '9500');

SELECT COUNT(DISTINCT uni_social_crd_cd) FROM wentiyu_geti;

SELECT * FROM wentiyu_geti LIMIT 5;




-- =========================
-- 按照《文化及相关产业分类2018》文化经营主体共有XX家，其中公司制企业XX家，个体工商户XX家
-- =========================

CREATE TABLE wenhua AS
    SELECT
        uni_social_crd_cd,      -- 统一社会信用代码
        comp_nm,                -- 企业名称（字号名称）
        indv_nm,                -- 行业代码
        comp_type,              -- 企业类型
        reg_state,              -- 登记状态
        reg_org,                -- 登记机关
        est_dt,                 -- 成立日期
        opt_strict              -- 生产经营地所在行政区划
    FROM dw_zj_scjdgl_scztxx
    WHERE indv_nm IN (
        '8610', '8622', '8710', '8720', '8740', '6421', '6429', '8621', '8623', '8624',
        '8625', '8626', '8629', '8730', '8770', '8810', '8870', '8890', '6572', '6422',
        '8831', '8832', '8840', '8850', '8860', '2431', '2432', '2433', '2434', '2435',
        '2436', '2437', '2438', '2439', '3075', '3076', '7251', '7259', '7491', '7492',
        '5143', '5144', '5145', '5243', '5244', '7124', '7125', '6321', '6322', '6331',
        '8750', '8760', '8820', '5183', '5184', '5146', '5245', '5246', '9011', '9012',
        '9013', '9019', '9020', '9090', '7850', '7861', '7862', '7869', '7712', '7715',
        '7716', '9030', '5622', '2222', '2642', '2644', '2664', '2311', '2312', '2319',
        '2320', '2330', '8060', '7281', '7282', '7283', '7284', '7289', '9051', '9053',
        '9059', '7298', '7121', '7123', '7350', '8393', '3542', '3474', '3931', '3932',
        '3933', '3934', '3939', '5178', '3471', '3953', '3472', '3473', '5248', '3873',
        '2461', '2462', '2469', '2421', '2422', '2423', '2429', '5147', '5247', '2411',
        '5141', '5241', '2412', '2414', '2451', '2452', '2453', '2454', '2455', '2456',
        '2459', '2672', '3951', '3952', '5137', '5271', '5149', '5249'
    )
    OR (
        indv_nm IN (
            '6513', '6319', '6579', '7484', '6432', '7212', '7211', '7221', '2221',
            '7520', '8070', '5181', '9521', '8399', '3963', '5175', '3961', '3969'
        )
        AND (
            opt_scop LIKE '%文化%' OR
            opt_scop LIKE '%文化宣传%' OR
            opt_scop LIKE '%多媒体%' OR
            opt_scop LIKE '%游戏%' OR
            opt_scop LIKE '%动漫%' OR
            opt_scop LIKE '%建筑设计%' OR
            opt_scop LIKE '%舞台%' OR
            opt_scop LIKE '%婚庆%' OR
            opt_scop LIKE '%娱乐%' OR
            opt_scop LIKE '%版权%' OR
            opt_scop LIKE '%会议%' OR
            opt_scop LIKE '%展览%' OR
            opt_scop LIKE '%广告%' OR
            opt_scop LIKE '%旅游%' OR
            opt_scop LIKE '%出行%' OR
            opt_scop LIKE '%游客%' OR
            opt_scop LIKE '%观光%' OR
            opt_scop LIKE '%游览%' OR
            opt_scop LIKE '%旅行%' OR
            opt_scop LIKE '%体育%' OR
            opt_scop LIKE '%休闲%' OR
            opt_scop LIKE '%公共交通%' OR
            opt_scop LIKE '%健康%' OR
            opt_scop LIKE '%休养%' OR
            opt_scop LIKE '%会展%' OR
            opt_scop LIKE '%翻译%' OR
            opt_scop LIKE '%健身%' OR
            opt_scop LIKE '%保健%' OR
            opt_scop LIKE '%虚拟现实%' OR
            opt_scop LIKE '%音乐%' OR
            opt_scop LIKE '%书法%' OR
            opt_scop LIKE '%文学%' OR
            opt_scop LIKE '%广播%' OR
            opt_scop LIKE '%电视%' OR
            opt_scop LIKE '%公园%' OR
            opt_scop LIKE '%文艺%' OR
            opt_scop LIKE '%软件%' OR
            opt_scop LIKE '%演出%' OR
            opt_scop LIKE '%购票%' OR
            opt_scop LIKE '%音视频%' OR
            opt_scop LIKE '%艺术%' OR
            opt_scop LIKE '%鉴定%' OR
            opt_scop LIKE '%拍卖%' OR
            opt_scop LIKE '%平台%' OR
            opt_scop LIKE '%园区%' OR
            opt_scop LIKE '%印刷%' OR
            opt_scop LIKE '%图书%' OR
            opt_scop LIKE '%音像%' OR
            opt_scop LIKE '%新闻%' OR
            opt_scop LIKE '%报刊%' OR
            opt_scop LIKE '%电影%' OR
            opt_scop LIKE '%作家%' OR
            opt_scop LIKE '%美术%' OR
            opt_scop LIKE '%摄影%' OR
            opt_scop LIKE '%文物%' OR
            opt_scop LIKE '%博物馆%' OR
            opt_scop LIKE '%图书馆%' OR
            opt_scop LIKE '%文化馆%' OR
            opt_scop LIKE '%游乐%' OR
            opt_scop LIKE '%舞蹈%' OR
            opt_scop LIKE '%武术%' OR
            opt_scop LIKE '%照明%' OR
            opt_scop LIKE '%著作权%' OR
            opt_scop LIKE '%装饰%' OR
            opt_scop LIKE '%园林%' OR
            opt_scop LIKE '%出版%' OR
            opt_scop LIKE '%文化产业%' OR
            opt_scop LIKE '%酒店%'
        )
    )
    ORDER BY uni_social_crd_cd;

SELECT COUNT(DISTINCT uni_social_crd_cd) from wenhua;

-- 文化行业中"公司"类型企业数量
SELECT COUNT(DISTINCT uni_social_crd_cd)
FROM wenhua
WHERE comp_type LIKE '%公司%';

-- 文化行业中"个体工商户"类型企业数量
SELECT COUNT(DISTINCT uni_social_crd_cd)
FROM wenhua
WHERE comp_type = '个体工商户';

-- =========================
-- 按照《旅游及相关产业分类2018》旅游经营主体共有XX家，其中公司制企业XX家，个体工商户XX家。
-- =========================

CREATE TABLE lvyou AS
    SELECT
        uni_social_crd_cd,      -- 统一社会信用代码
        comp_nm,                -- 企业名称（字号名称）
        indv_nm,                -- 行业代码
        comp_type,              -- 企业类型
        reg_state,              -- 登记状态
        reg_org,                -- 登记机关
        est_dt,                 -- 成立日期
        opt_strict              -- 生产经营地所在行政区划
    FROM dw_zj_scjdgl_scztxx
    WHERE
        SUBSTRING(TRIM(indv_nm), 1, 3) IN ( '531', '542', '551', '612', '786')
        OR
        indv_nm IN (
            '5331', '5531', '5611', '5622', '5631', '5632', '5822', '6110', '7850', '9020',
            '8840', '8850', '9542', '8860', '7291'
        )
        OR (
            (
                SUBSTRING(TRIM(indv_nm), 1, 3) IN (
                    '015', '541', '521', '522', '523', '524', '526', '544', '623', '722', '725',
                    '728', '771', '892', '834'
                )
                OR
                indv_nm IN (
                    '7111', '7115', '7119', '6130', '6140', '6190', '8511', '6210', '6220',
                    '6291', '6241', '0141', '0143', '0149', '0412', '8810', '8820', '9011',
                    '9012', '9019', '8060', '8930', '8051', '8052', '8053', '8412', '8413',
                    '8414', '8415', '8416', '9030', '9090', '7297', '7298', '7299', '6432',
                    '6434', '6439', '6440', '6450', '7215', '7219', '9522', '5333', '5339',
                    '5539', '5639', '5910', '6621', '6623', '6624', '6629', '6634', '6635',
                    '6636', '6637', '6639', '6813', '6814', '6820', '6999', '8336', '8391',
                    '7271', '7272', '7294', '7121', '7122', '7123', '7129', '7130', '9221',
                    '9222'
                )
            )
            AND (
                opt_scop LIKE '%观光%' OR
                opt_scop LIKE '%旅游%' OR
                opt_scop LIKE '%游客%' OR
                opt_scop LIKE '%景区%' OR
                opt_scop LIKE '%免税店%' OR
                opt_scop LIKE '%旅行社%' OR
                opt_scop LIKE '%表演%' OR
                opt_scop LIKE '%演艺%' OR
                opt_scop LIKE '%游艺%' OR
                opt_scop LIKE '%棋牌%' OR
                opt_scop LIKE '%健身%' OR
                opt_scop LIKE '%台球%' OR
                opt_scop LIKE '%导游%' OR
                opt_scop LIKE '%公园%' OR
                opt_scop LIKE '%海滩%' OR
                opt_scop LIKE '%门票%' OR
                opt_scop LIKE '%旅居%' OR
                opt_scop LIKE '%纪念品%' OR
                opt_scop LIKE '%客运%' OR
                opt_scop LIKE '%轨道交通%' OR
                opt_scop LIKE '%出租车%' OR
                opt_scop LIKE '%旅游用车%' OR
                opt_scop LIKE '%旅游船舶%' OR
                opt_scop LIKE '%飞行器的租赁%' OR
                opt_scop LIKE '%房车%' OR
                opt_scop LIKE '%航空%' OR
                opt_scop LIKE '%铁路%' OR
                opt_scop LIKE '%船舶%' OR
                opt_scop LIKE '%机场%' OR
                opt_scop LIKE '%旅馆%' OR
                opt_scop LIKE '%农家%' OR
                opt_scop LIKE '%露营%' OR
                opt_scop LIKE '%营地%' OR
                opt_scop LIKE '%休养所%' OR
                opt_scop LIKE '%餐饮%' OR
                opt_scop LIKE '%饭馆%' OR
                opt_scop LIKE '%茶馆%' OR
                opt_scop LIKE '%咖啡%' OR
                opt_scop LIKE '%冷饮%' OR
                opt_scop LIKE '%自然保护区%' OR
                opt_scop LIKE '%动物园%' OR
                opt_scop LIKE '%海洋馆%' OR
                opt_scop LIKE '%植物园%' OR
                opt_scop LIKE '%古村镇%' OR
                opt_scop LIKE '%陵园%' OR
                opt_scop LIKE '%纪念馆%' OR
                opt_scop LIKE '%教育基地%' OR
                opt_scop LIKE '%歌舞厅%' OR
                opt_scop LIKE '%KTV%' OR
                opt_scop LIKE '%剧院%' OR
                opt_scop LIKE '%戏剧%' OR
                opt_scop LIKE '%手工艺%' OR
                opt_scop LIKE '%民俗%' OR
                opt_scop LIKE '%按摩%' OR
                opt_scop LIKE '%足疗%' OR
                opt_scop LIKE '%疗养%' OR
                opt_scop LIKE '%康复%' OR
                opt_scop LIKE '%保龄球%' OR
                opt_scop LIKE '%签证%' OR
                opt_scop LIKE '%护照%' OR
                opt_scop LIKE '%外汇%' OR
                opt_scop LIKE '%体育%' OR
                opt_scop LIKE '%赛事%'
            )
        )
    ORDER BY uni_social_crd_cd;

-- 旅游行业中"公司"类型企业数量
SELECT COUNT(DISTINCT uni_social_crd_cd)
FROM lvyou
WHERE comp_type LIKE '%公司%';

-- 旅游行业中"个体工商户"类型企业数量
SELECT COUNT(DISTINCT uni_social_crd_cd)
FROM lvyou
WHERE comp_type = '个体工商户';

-- =========================
-- 文旅融合企业（三个表的纵向合并）
-- =========================

CREATE TABLE wenlv_temp AS
    SELECT * FROM wentiyu
    UNION ALL
    SELECT * FROM wenhua
    UNION ALL
    SELECT * FROM lvyou
    ORDER BY uni_social_crd_cd;

-- 去重：删除重复的 uni_social_crd_cd，只保留第一条
CREATE TABLE wenlv AS
    SELECT *
    FROM (
        SELECT *,
            ROW_NUMBER() OVER (PARTITION BY uni_social_crd_cd ORDER BY (SELECT NULL)) AS rn
        FROM wenlv_temp
    ) AS t
    WHERE rn = 1;

DROP TABLE wenlv_temp;

SELECT COUNT(DISTINCT uni_social_crd_cd) FROM wenlv;

-- 文旅融合企业中"公司"类型企业数量
SELECT COUNT(DISTINCT uni_social_crd_cd)
FROM wenlv
WHERE comp_type LIKE '%公司%';

-- 文旅融合企业中"个体工商户"类型企业数量
SELECT COUNT(DISTINCT uni_social_crd_cd)
FROM wenlv
WHERE comp_type = '个体工商户';

-- =========================
-- 共涵盖国民经济行业小类共XX个，宁波所有文旅经营主体共覆盖国民经济行业小类XX个，行业覆盖度达到XX%。
-- =========================

SELECT COUNT(DISTINCT indv_nm) FROM wenlv;

-- =========================
-- 按照国民经济行业分类，宁波文旅企业数量最多的10个行业小类有：
-- 按照文化及相关产业分类，宁波文旅企业数量最多的10个行业小类有：
-- 按照旅游及相关产业分类，宁波文旅企业数量最多的10个行业小类有：
-- =========================

SELECT indv_nm, COUNT(DISTINCT uni_social_crd_cd)
FROM wenlv
GROUP BY indv_nm
ORDER BY COUNT(DISTINCT uni_social_crd_cd) DESC
LIMIT 10;

SELECT indv_nm, COUNT(DISTINCT uni_social_crd_cd)
FROM wenhua
GROUP BY indv_nm
ORDER BY COUNT(DISTINCT uni_social_crd_cd) DESC
LIMIT 10;

SELECT indv_nm, COUNT(DISTINCT uni_social_crd_cd)
FROM lvyou
GROUP BY indv_nm
ORDER BY COUNT(DISTINCT uni_social_crd_cd) DESC
LIMIT 10;

-- =========================
-- 按照工商注册机关进行地区分类，分别计算各区市县的经营主体数量。
-- =========================

SELECT
    reg_org,
    COUNT(*) AS company_count
FROM wenlv
GROUP BY reg_org
ORDER BY company_count DESC;

-- =========================
-- 分析企业五险的参保人数
-- 统计企业社保缴费的连续性
-- =========================

CREATE TABLE wenlv_shebao AS
SELECT
    wenlv.*,
    sb.pens_num,                    -- 参保人数
    sb.issue_start_dt,              -- 开始缴费日期
    sb.issue_end_dt                 -- 最新缴费日期
FROM wenlv
LEFT JOIN (
    SELECT
        uni_social_crd_cd,
        pens_num,
        issue_start_dt,
        issue_end_dt,
        ROW_NUMBER() OVER (PARTITION BY uni_social_crd_cd ORDER BY issue_end_dt DESC) AS rn
    FROM dw_nb_rlsb_sbjylyshbxjbxx
) sb ON wenlv.uni_social_crd_cd = sb.uni_social_crd_cd AND sb.rn = 1;

-- 查看结果
SELECT COUNT(*) FROM wenlv_shebao;

-- 查看有社保数据的企业数量
SELECT COUNT(*) FROM wenlv_shebao WHERE pens_num IS NOT NULL;

-- 查看前10条记录
SELECT * FROM wenlv_shebao LIMIT 10;

-- =========================
-- 评估企业在社会保险费及相关税费方面的贡献
-- 估算企业带动的就业规模
-- =========================

CREATE TABLE wenlv_ss AS
SELECT
    wenlv.*,
    ss.tax_amt,                      -- 税收
    ss.sale_inco,                    -- 营业收入
    ss.count_dt                      -- 统计日期
FROM wenlv
LEFT JOIN (
    SELECT
        uni_social_crd_cd,
        tax_amt,
        sale_inco,
        count_dt,
        ROW_NUMBER() OVER (PARTITION BY uni_social_crd_cd ORDER BY count_dt DESC) AS rn
    FROM dw_nb_sw_nsxx
) ss ON wenlv.uni_social_crd_cd = ss.uni_social_crd_cd AND ss.rn = 1;

-- 有纳税的企业数量
SELECT COUNT(*) FROM wenlv_ss WHERE tax_amt IS NOT NULL;

-- 有营业收入的企业数量
SELECT COUNT(*) FROM wenlv_ss WHERE sale_inco IS NOT NULL;

-- =========================
-- 基于"信用分"字段分析企业信用分的集中区间
-- 结合"评价时间"观察信用分的时间变化趋势
-- =========================

DROP TABLE IF EXISTS wenlv_xypj;

CREATE TABLE wenlv_xypj AS
SELECT
    wenlv.*,
    xypj_latest.tax_credi_level,    -- 最新评定日期的纳税信用等级
    xypj_latest.eval_year           -- 最新评定日期的纳税信用等级评定年度
FROM wenlv
LEFT JOIN (
    SELECT
        uni_social_crd_cd,
        tax_credi_level,
        eval_year,
        ROW_NUMBER() OVER (PARTITION BY uni_social_crd_cd ORDER BY eval_dt DESC) AS rn
    FROM dw_nb_sw_xypjxxa
) xypj_latest
ON wenlv.uni_social_crd_cd = xypj_latest.uni_social_crd_cd AND xypj_latest.rn = 1;

SELECT COUNT(*) AS xypj_count FROM wenlv_xypj;

SELECT * FROM wenlv_xypj LIMIT 10;

-- 有信用评价企业的数量
SELECT COUNT(*) FROM wenlv_xypj WHERE tax_credi_level IS NOT NULL;

-- 有信用评价企业的占比
SELECT
    ROUND(
        COUNT(CASE WHEN tax_credi_level IS NOT NULL THEN 1 END) * 100.0 / NULLIF(COUNT(*), 0),
        2
    ) AS percent_xypj
FROM wenlv_xypj;

-- 信用评价为A的企业数量
SELECT COUNT(*) FROM wenlv_xypj WHERE tax_credi_level = 'A';

-- 信用评价为A的企业占比
SELECT
    ROUND(
        COUNT(CASE WHEN tax_credi_level = 'A' THEN 1 END) * 100.0 / NULLIF(COUNT(*), 0),
        2
    ) AS percent_a
FROM wenlv_xypj;
