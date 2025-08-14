# 文旅市场主体数据处理

## 简介

对文旅市场主体数据进行提取、清洗、分类和整合，形成结构化的文旅企业信息表，并增加相关企业维度信息，支持后续的数据分析与决策。

## 项目结构

```
cultural_companies/
├── analysis_queries/          # 业务分析查询（Step1→Step2→Step3流程）
│   ├── step1_get_enterprises_directly.sql
│   ├── step1_get_enterprises_from_csv.sql
│   ├── step2_add_enterprise_dimensions.sql
│   ├── step3_statistical_analysis.sql
│   └── step3_queries_separated.sql
├── test_database/             # 测试数据库（建表、假数据、测试查询）
│   ├── 01_create_database.sql
│   ├── 02_insert_sample_data.sql
│   └── 03_test_queries.sql
├── scripts/                   # Python工具脚本
│   ├── generate_fake_data.py  # 生成假数据
│   ├── data_preparing.py      # 数据准备
│   ├── extract_field_mapping.py
│   ├── find_dw_zj_scjdgl_scztxx.py
│   ├── generate_table_fields_md.py
│   └── read_excel_fields.py
├── codes/                     # 行业代码文件
│   ├── cultural_industry_codes.csv
│   ├── tourism_industry_codes.csv
│   └── social_credit_codes.csv
├── data/                      # 数据文件
├── resources/                 # 资源文件
├── table_fields.md           # 表字段文档
└── README.md                 # 项目说明
```

## 快速开始

### 1. 创建测试数据库
```sql
-- 执行建表脚本
mysql -u username -p < test_database/01_create_database.sql

-- 插入测试数据
mysql -u username -p < test_database/02_insert_sample_data.sql

-- 运行测试查询
mysql -u username -p < test_database/03_test_queries.sql
```

### 2. 生成更多测试数据
```bash
cd scripts
python generate_fake_data.py
```

### 3. 执行业务分析
```sql
-- 执行Step1：获取文旅企业
mysql -u username -p < analysis_queries/step1_get_enterprises_directly.sql

-- 执行Step2：关联维度信息
mysql -u username -p < analysis_queries/step2_add_enterprise_dimensions.sql

-- 执行Step3：统计分析
mysql -u username -p < analysis_queries/step3_statistical_analysis.sql
```

## 字段映射说明

本文档中的字段名采用以下格式：
- 中文字段名 (`标准化字段名`)

其中：
- **中文字段名**：业务需求中的中文描述
- **标准化字段名**：数据库中的实际字段名（大写字母和下划线组成）

**注意**：部分字段标记为"待确认"，表示需要根据实际数据库结构进一步确认对应的标准化字段名。

## 操作步骤

### Step1：获取全部文旅市场主体数据

1. 表名（中文）：市场主体信息（含个体) / 表名（数据库）：`dw_zj_scjdgl_scztxx`) 标准化字段名：
   - 统一社会信用代码 (`UNI_SOCIAL_CRD_CD`)
   - 企业名称（字号名称） (`COMP_NM`)
   - 登记机关 (`REG_ORG`)
   - 企业类型大类（中文） (`COMP_TYPE`)
   - 住所（登记、个体户经营场所） (`ADDR`)
   - 法定代表人（经营者姓名） (`LEGAL_REPRE`)
   - 行业代码（中文） (`INDV_ID`)
   - 行业代码 (`INDV_CODE`)
   - 行业名称 (`INDV_NM`)
   - 经营范围 (`OPT_SCOP`)
   - 核准日期（登记、吊销、注销日期） (`APPR_DT`)
   - 成立日期 (`EST_DT`)
   - 住所所在行政区划 (`DOMDI_STRICT`)
   - 生产经营地 (`PRO_LOC`)
   - 生产经营地所在行政区划 (`OPT_STRICT`)
   - 经营场所 (`OPT_LOC`)

2. `dw_zj_scjdgl_scztxx` 和 "文旅目录0722.xlsx"，按照行业代码（中文）、行业代码进行并表。

3. 筛选出具有文化、旅游标记的所有企业。

4. 将所有企业分为两张子表：
   - (1) 按照"国民经济行业小类均归属文化或旅游产业"，形成一张表格"文旅1表"
   - (2) 按照"国民经济行业小类均不全部归属文化或旅游产业"，形成一张表格"文旅2表"

5. 对"文旅2表"，按照经营范围查找关键词，没有下列关键词的删掉：

   - `wh_keywords: "文化","多媒体","游戏","动漫","数字出版","建筑设计","舞台","婚庆","娱乐","版权","会议","展览","广告","工艺美术"`
   - `ly_keywords: "旅游","出行","游客","观光","游览","旅行","体育","娱乐","休闲","公共交通","娱乐","健康""休养","会展","展览","翻译","健身","保健","酒店"`

6. 将文旅1表和删减后的文旅2表合并。

### Step2：增加文旅企业信息维度

1. 法定代表人信息：
   - 姓名 (`NM`)
   - 身份证号码 (`CER_NO`)
   - 固定电话 (`TEL_NUM`)

2. 经营异常名录信息：
   - 列入经营异常名录原因 (`INCLU_REASON`)
   - 移出经营异常名录原因 (`REMEXCPRES_CN`)

3. 严重违法失信企业名单信息：
   - 列入严重违法失信企业名单原因 (`SERILL_REA`)
   - 移出严重违法失信企业名单原因 (`REM_EXCPRES_REA`)

4. 宁波市市场监督领域企业年报网站或网店信息：
   - 网站标识 (`WEB_ID`)
   - 网站（网店）名称 (`WEB_STORE_NM`)
   - 网站（网店）网址 (`WEB_STORE_URL`)

5. 股权变更公示信息：
   - 股权变更日期 (`ALT_DT`)
   - 变更前股权比例 (`TRANSAMPR_BF`)
   - 变更后股权比例 (`TRANSAMPR_AF`)

6. 企业年报资产信息：
   - 年报年度 (`ANNUAL_YEAR`)
   - 资产总额 (`ASSET_ZMT`)
   - 负债总额 (`DEBT_AMT`)
   - 营业总收入 (`OPT_INCOME_TOTAL`)
   - 利润总额 (`PROFIT_TOTAL`)
   - 纳税总额 (`TAX_TOTAL`)

7. 宁波市市场监督领域企业年报对外提供保证担保信息：
   - 对外担保标识ID (`EXTERNAL_GUA`)
   - 债权人 (`CREDITOR`)
   - 债务人 (`DEBTOR`)
   - 主债权数额 (`MAJOR_CREDIT_AMT`)

8. 宁波市科技型小微企业信息：
   - 认定年份 (`CONGNIZ_TEAR`)
   - 认定机构 (`CONGNIZ_ORG`)

9. 失信被执行人信息：
   - 执行法院 (`EXECUTE_COURT`)
   - 执行金额 (`EXECUTE_AMT`)
   - 未执行金额 (`NOT_EXECUTE_AMT`)

10. 信用评价信息：
    - 信用评价名称 (`CREDIT_CMNT_NM`)
    - 评价结果 (`CMNT_RESULT`)
    - 评价机构 (`CMNT_ORG`)

11. 宁波市企业注销信息：
    - 变更日期 (`CHAN_DT`)
    - 变更项目 (`CHAN_PROJECT`)

12. 纳税信息：
    - 实缴金额 (`PAID_AMT`)
    - 征收项目 (`COLL_ITEM`)

13. 信用评价信息（A级纳税人）：
    - 信用等级 (`TAX_CREDIT_LEVEL`)
    - 评价单位 (`EVALUA_DEPT`)
    - 评定时间 (`EVALUA_DT`)

14. 宁波市社保就业领域社会保险基本信息：
    - 险种类型 (`INSUR_TYPE`)
    - 缴费月数 (`PAY_MONS`)
    - 人员缴费基数 (`PER_PAY_BASE`)
    - 缴费总金额 (`PAY_AMT`)
    - 单位应缴金额 (`CORP_PAY_AMT`)
    - 个人应缴金额 (`PER_PAY_AMT`)

15. 将上述数据按照行业代码（中文）、行业代码归并到step1结果中，形成数据库"wl××××"。

### Step3：统计分析思路

1. 企业家数：
   - 各文旅小类的企业数量以及新业态数量
   - 报告期内的注销企业数
   - 经营异常企业数
   - 失信企业数

2. 经营状况：
   - 一般经营信息：
     - 资产总额 (`ASSET_ZMT`)
     - 负债总额 (`DEBT_AMT`)
     - 营业总收入 (`OPT_INCOME_TOTAL`)
     - 利润总额 (`PROFIT_TOTAL`)
     - 纳税总额 (`TAX_TOTAL`)
   - 股权变更 (`ALT_DT`)
   - 对外保证担保 (`EXTERNAL_GUA`)

3. 社保就业：
   - 缴纳社保企业数量（未缴纳数量）
   - 各社保缴纳人数

## 数据表说明

### 主要数据表：dw_zj_scjdgl_scztxx

**表名含义**：浙江省市场监督管理局市场主体信息数据仓库表
**中文名称**：市场主体信息（含个体)
**主键**：PRIPID,ENTNAME,CREDIT_CODE

### 字段映射说明

本文档中所有字段名都已在各步骤中标注了对应的标准化字段名。主要字段包括：

- **基础信息**：统一社会信用代码 (`UNI_SOCIAL_CRD_CD`)、企业名称 (`COMP_NM`)、登记机关 (`REG_ORG`) 等
- **经营信息**：经营范围 (`OPT_SCOP`)、行业代码 (`INDV_CODE`)、成立日期 (`EST_DT`) 等
- **扩展维度**：法定代表人信息、经营异常信息、年报资产信息、社保信息等

### SQL查询示例

```sql
-- 基础企业信息查询
SELECT
    UNI_SOCIAL_CRD_CD AS social_credit_code,
    COMP_NM AS company_name,
    REG_ORG AS reg_authority,
    COMP_TYPE AS company_type,
    ADDR AS reg_address,
    LEGAL_REPRE AS legal_repre,
    INDV_ID AS industry_name,
    INDV_CODE AS industry_code,
    INDV_NM AS industry_name_full,
    OPT_SCOP AS business_scope,
    APPR_DT AS approval_date,
    EST_DT AS establishment_date,
    DOMDI_STRICT AS domicile_district_code,
    PRO_LOC AS production_address,
    OPT_STRICT AS business_district_code,
    OPT_LOC AS business_premises
FROM dw_zj_scjdgl_scztxx
WHERE UNI_SOCIAL_CRD_CD IS NOT NULL;
```

## 注意事项

1. **数据类型**: 数据类型可能需要根据实际数据库类型进行调整
2. **表关联**: 不同表之间的关联字段需要确认是否一致
3. **数据质量**: 需要注意数据的完整性和准确性
4. **性能优化**: 大数据量查询时需要考虑索引和查询优化
