# 宁波市金融主题库标准表字段映射

本文档根据 `cc20250715_宁波市金融主题库标准表_指标表.xlsx` 生成，用于清晰呈现各数据表的字段信息。

## 目录

1. [源数据库](#1)
2. [英文表名称](#2)
3. [DW_ZJ_SCJDGL_SCZTXX](#3)
4. [POSITION_CN (DW_ZJ_SCJDGL_FDDBRXX)](#4)
5. [DW_ZJ_SCJDGL_JYYCMLXX](#5)
6. [DW_ZJ_SCJDGL_YZWFSX](#6)
7. [DW_NB_SCJDGL_QYNBWZHWDXX](#7)
8. [DW_NB_SCJDGL_XZCFGSXX](#8)
9. [DW_NB_SCJDGL_GQBG](#9)
10. [DW_NB_SCJDGL_XWQYMLJBXX](#10)
11. [DW_NB_SCJDGL_XZXK](#11)
12. [DW_NB_SCJDGL_CYJYXKZXX](#12)
13. [DW_NB_SCJDGL_QYNBZCXX](#13)
14. [DW_NB_SCJDGL_ZSCQCZDJ](#14)
15. [DW_NB_SCJDGL_DWTGBZDBXX](#15)
16. [PAID_AMT_WAY_CN (DW_NB_SCJDGL_QYNBGDJCZXX)](#16)
17. [DW_NB_SCJDGL_SPJYXKZ](#17)
18. [DW_NB_SCJDGL_GTJYYCBJXX](#18)
19. [SUBSCRIP_WAY_CN (DW_NB_SCJDGL_CZRRJMXXX)](#19)
20. [PAID_WAY_CN (DW_NB_SCJDGL_CZRSJMXXX)](#20)
21. [DW_NB_SCJDGL_SCJDLYLLYXX](#21)
22. [DW_NB_SGZW_NBXX](#22)
23. [DW_NB_YBJ_JRXKXX](#23)
24. [DW_NB_SW_SBJNXX](#24)
25. [DW_ZJ_JS_QYGJJNDJCXX](#25)
26. [DW_ZJ_JS_QYGJJYDJCXX](#26)
27. [DW_NB_KJ_GXJSQYXX](#27)
28. [DW_NB_KJ_SJKJXZXQYXX](#28)
29. [DW_NB_KJ_NBSKJXXWQYXX](#29)
30. [DW_NB_KJ_SGCZKJXZXQY](#30)
31. [DW_ZJ_FZGG_CFJBXX](#31)
32. [DW_ZJ_FZGG_XZCFJDXX](#32)
33. [DW_ZJ_FZGG_SXBZXRXX](#33)
34. [DW_NB_SL_SLSWLYQYPJXX](#34)
35. [DW_NB_SL_QJSFQYXX](#35)
36. [DW_NB_ZHZF_FRYSSJXX](#36)
37. [DW_NB_ZHZF_FRYQSJXX](#37)
38. [DW_NB_STHJ_WXFWJYXK](#38)
39. [DW_NB_DSJ_XYPJXX](#39)
40. [DW_NB_JT_QYZHZSXX](#40)
41. [DW_NB_SW_NSRJCXX](#41)
42. [DW_NB_SW_FZCHRD](#42)
43. [DW_NB_SW_QYSKZSXX](#43)
44. [DW_NB_SW_ZDSSWFHMD](#44)
45. [DW_NB_SW_QSXX](#45)
46. [DW_NB_SW_NSXYDJXX](#46)
47. [DW_NB_SW_CSJRXZCFXX](#47)
48. [DW_NB_SW_CSJRSWJCXX](#48)
49. [DW_ZJ_GA_LDRKJBXX](#49)
50. [DW_ZJ_GA_CZRKHK](#50)
51. [DW_ZJ_JS_GJJGRJCXX](#51)
52. [DW_ZJ_JS_GJJGRDKXX](#52)
53. [DW_NB_YB_CXJMJBYLBXCBDJ](#53)
54. [DW_NB_YB_CXJMJBYLBXJFXX](#54)
55. [DW_NB_RLSB_GRYJJBYLBXHDXX](#55)
56. [DW_NB_SWBGXX](#56)
57. [DW_NB_HYWLQYXYDJXX](#57)
58. [DW_SHL_GJZYJSZWRZZGZSXX](#58)
59. [DW_SHL_GRWLXSXCPXX](#59)
60. [DW_SHL_HJYXBGBSPYJXX](#60)
61. [DW_SHL_QYWLXSXCPXX](#61)
62. [DW_SHL_RSKSWJXX](#62)
63. [DW_SHL_TYSHXYDMXXGJXF](#63)
64. [DW_SHL_SCJRXXGJXF](#64)
65. [DW_SHL_SGSXZXK](#65)
66. [DW_SHL_SGSXZXK](#66)
67. [DW_SHL_GJJGRDKXX](#67)
68. [DW_NB_SHFWLYXFJXX](#68)
69. [DW_SHL_SMDXFBLBDXX](#69)
70. [DW_SHL_SMDXFSLBDXX](#70)
71. [DW_SHL_XFRZDRYXX](#71)
72. [DW_SHL_XFJBLGKXX](#72)
73. [DW_SHL_XFJXFSXXX](#73)
74. [DW_SHL_XFJXFSXBLJLXX](#74)
75. [DW_NB_SW_NSXX](#75)
76. [DW_NB_SW_XYPJXXA](#76)
77. [DW_NB_RLSB_QYSBCBRSXX](#77)
78. [DW_NB_RLSB_SBJYLYSHBXJBXX](#78)
79. [DW_NB_RLSB_GTLDZCBDJXX](#79)
80. [DW_NB_RLSB_CBGRYJSYBXFHDXX](#80)
81. [DW_NB_RLSB_SBJYLYRYCBXX](#81)
82. [DW_SHL_AJNSRXX](#82)
83. [DW_SHL_QYZXDJXX](#83)
84. [DW_SHL_XZCFXXGJXF](#84)
85. [DW_NB_ZG_JRLYXDMXBDCQZ](#85)
86. [v_ods_zj_dlgs_dsc_nb_biz_224_zrr_s_power_violate_steal_new_df](#86)
87. [v_stg_nb_csglj_nbsxyfwlyfrrqxx_sbz](#87)
88. [v_stg_nb_jyj_nbsslswlyfrysxx](#88)
89. [DW_SHL_QYHJXWXYPJXX](#89)
90. [DYBM](#90)
91. [DW_NB_XFLYDFGZHFXX](#91)
92. [DW_NB_XFLYDHYDFXX](#92)
93. [DW_NB_XFLYHSDHXX](#93)
94. [DW_NB_XFLYHSSDXX](#94)
95. [DW_NB_XFLYHSWLXX](#95)
96. [DW_NB_XFLYHFXX](#96)
97. [DW_NB_XFLYWDFDHXX](#97)
98. [DW_NB_XFLYXFJXX](#98)
99. [DW_NB_XFLYXFRXXX](#99)
100. [DW_NB_XFLYXJDBXX](#100)
101. [DW_SHL_XFJXX](#101)
102. [DW_SHL_XFRXX](#102)
103. [DSC_SYDEP_TABL](#103)
104. [v_ods_zj_sscjgj_dsc_dd041_hz_e_baseinfo_fr_delta_gt_old_nb_df](#104)
105. [v_ods_zj_sjtyst_dsc_nb_biz_032_jdcwxjyyhbaxx_df](#105)
106. [v_stg_nb_sfgw_nbszdtzxmxx](#106)
107. [v_stg_nb_rsj_sbjyly_cxjmylbzdyxsryxx](#107)
108. [v_stg_nb_sfgw_nbsfgwndzdxmmlxx](#108)
109. [v_ods_zj_sfzggw_dsc_nb_biz_019_tzxm_approval_form_info_df](#109)
110. [v_ods_zj_sfzggw_dsc_nb_biz_019_fssr_swsb_sl_df](#110)
111. [v_ods_zj_sfzggw_dsc_nb_biz_019_tzxm_approve_cert_info_df](#111)
112. [省回流_在线平台-投资项目基本信息](#112)
113. [省回流_在线平台-投资项目办件申报材料信息](#113)
114. [省回流_在线平台-投资项目办件环节信息](#114)
115. [dw_nb_xsxx](#115)
116. [dw_nb_zzxsxx](#116)
117. [dw_nb_xqxsxx](#117)
118. [dw_nb_gxxsxx](#118)
119. [dw_nb_zxxxsxx](#119)
120. [dw_nb_xxxx](#120)
121. [dw_nb_yeyyqxx](#121)
122. [dw_nb_yeyzyyershzxx](#122)
123. [dw_nb_jsxx](#123)
124. [v_ods_dsc_nb_ads_share_jgxw_punish_decision_info_s_d_df](#124)
125. [v_stg_nb_jtysj_t_jtw_m_qyzzzs_1](#125)
126. [v_stg_nb_kjj_t_kjj_m_sgczkjxzxqy_1](#126)
127. [v_stg_nb_JYJ_nbsslswlyqypjxx_df](#127)
128. [v_ods_e_im_ippldgalt_df](#128)

---

<a name="1"></a>
## 1. 目录

**表名**: `源数据库`

**注意**: 未找到字段信息或字段信息格式不标准

---

<a name="2"></a>
## 2. 指标

**表名**: `英文表名称`

**注意**: 未找到字段信息或字段信息格式不标准

---

<a name="3"></a>
## 3. 1

**表名**: `DW_ZJ_SCJDGL_SCZTXX`

### 字段信息

| 中文字段名 | 标准化字段名 | 数据类型 | 样例数据 | 源表字段名 |
| --- | --- | --- | --- | --- |
| 主体身份代码 | MAIN_IDENTI_ID | string | 3302140000185548 | pripid |
| 登记机关 | REG_ORG | string | 宁波市海曙区市场监督管理局 | regorg |
| 企业类型大类（中文） | COMP_TYPE | string | 有限责任公司(自然人投资或控股) | reporttype |
| 登记状态（中文） | REG_STATE | string | 开业 | regstate |
| 统一社会信用代码 | UNI_SOCIAL_CRD_CD | string | 91330203674737244W | uniscid |
| 企业名称（字号名称） | COMP_NM | string | 宁波海曙引钲机电设备有限公司 | entname |
| 住所（登记、个体户经营场所） | ADDR | string | 浙江省宁波市海曙区联丰路182号(集中办公区) | dom |
| 法定代表人(经营者姓名) | LEGAL_REPRE | string | 林英雄 | name |
| 行业代码（中文） | INDV_ID | string | 其他机械设备及电子产品批发 | industryco |
| 注册资本(资金数额) | REG_CAPT | float | 50 | regcap |
| 币种 | CAPT_KIND | string | 人民币元 | regcapcur |
| 经营范围 | OPT_SCOP | string | 气动元器件、机电设备、缝纫设备、建筑材料、五金交电、化工原料及产品(危险品除外)、办公设备、文具用品的批发、零售;自营和代理货物和技术的进出口,但国家限定经营或禁止进出口的货物和技术除外以及其他按法律、法规、国务院决定等规定未禁止或无需经营许可的项目和未列入地方产业发展负面清单的项目。(依法须经批准的项目,经相关部门批准后方可开展经营活动) | opscope |
| 注册号 | REG_NO | string | 330203000030639 | regno |
| 核准日期（登记、吊销、注销日期） | APPR_DT | datetime | 2020-06-18 00:00:00 | apprdate |
| 成立日期 | EST_DT | datetime | 2008-06-16 00:00:00 | estdate |
| 经营(营业)起始日期 | OPT_FROM | datetime | 2008-06-16 00:00:00 | opfrom |
| 经营(营业)截止日期 | OPT_TO | datetime | 9999-09-09 00:00:00 | opto |
| 住所所在行政区划 | DOMDI_STRICT | string | 330203001 | domdistrict |
| 生产经营地 | PRO_LOC | string | 浙江省宁波市海曙区联丰路182号(集中办公区) | proloc |
| 生产经营地所在行政区划 | OPT_STRICT | string | 330203001 | yiedistrict |
| 邮政编码 | POSTAL_CODE | string | 315010 | postalcode |
| 是否个转企 | SFGZQ | string | \N | sfgzq |
| 是否个转企二次转型 | SFGZQZX | string | \N | sfgzqzx |
| 组成形式 | COMPFORM | string | \N | compform |
| 经营场所 | OPT_LOC | string | 浙江省宁波市海曙区联丰路182号(集中办公区) | oploc |
| 其他信息 | OTHERINFO | string | \N | otherinfo |
| 企业信用信息公示系统网址 | PUBURL | string | \N | puburl |
| 二维码 | QRCODE | string | \N | qrcode |
| 隶属企业主体身份代码 | LV_PRIPID | string | \N | lv_pripid |
| 行业代码 | INDV_CODE | string |  | industryco_code |
| 行业名称 | INDV_NM | Sring |  | 关联国家中心字段 |

---

<a name="4"></a>
## 4. 2

**表名**: `DW_ZJ_SCJDGL_FDDBRXX`

**中文名称**: POSITION_CN

### 字段信息

| 中文字段名 | 标准化字段名 | 数据类型 | 样例数据 | 源表字段名 |
| --- | --- | --- | --- | --- |
| 主体身份代码 | IDENTI_NO | string | 3302130000020166 | pripid |
| 人员ID | PERSONID | smallint | 1 | personid |
| 1 法定代表人标志/首席代表标志/负责人标识 2 董事 | LEREP_SIGN | smallint | 1 | lerepsign |
| 姓名 | NM | string | 孙秀英 | name |
| 职务 | POSITION | string | 431A | position |
| 证件类型 | CERTYPE | string | 10 | certype |
| 国籍 | COUNTRY | string | 156 | country |
| 职务（中文名称） | POSITION_CN | string | 董事长 | position_cn |
| 证件类型（中文） | CERTYPE_CN | string | 中华人民共和国居民身份证 | certype_cn |
| 国籍（中文） | COUNTRY_CN | string | 中国 | country_cn |
| 身份证件号码 | CER_NO | string | 120110681231276 | cerno |
| 固定电话 | TEL_NUM | string | 13306450809 | telnumber |
| 移动电话 | MOBTEL | string | *********** | mobtel |
| 电子邮箱 | EMAIL | string | 13567409300@139.com | email |
| 签名摘要 | SIGNHASHCODE | string | a9lFWBwrvE2WiA8EqYB4x4lS4SC2GjbJvuI8/25vFsE= | signhashcode |
| 签名名证书公钥 | SIGNKEY | string | 04F7D65C9BABB5B0D32BF7497F68D65EF376743491AFA3C8806D0B665DA58DB9B5D5ABFF5BDA9ACD32679401E5EDC56E91428BE893122424690352C55C2F30938C | signkey |
| 统一社会信用代码 | UNI_SOCIAL_CRD_CD | string |  | uniscid |
| 企业名称（字号名称） | COMP_NM | string |  | entname |

---

<a name="5"></a>
## 5. 3

**表名**: `DW_ZJ_SCJDGL_JYYCMLXX`

### 字段信息

| 中文字段名 | 标准化字段名 | 数据类型 | 样例数据 | 源表字段名 |
| --- | --- | --- | --- | --- |
| 列入日期 | INCLU_DT | datetime | 2017-07-07 00:00:00 | abntime |
| 经营异常名录ID | BUSEXCLIST | string | 848775 | busexclist |
| 列入经营异常名录原因 | INCLU_REASON | string | 通过登记的住所或者经营场所无法联系的 | specause_cn |
| 统一社会信用代码 | UNI_SOCIAL_CRD_CD | string | 91330203674737244W | uniscid |
| 营业执照注册号 | REG_NO | string | 33021200019832 | regno |
| 作出决定机关(移出) | REDECORG_CN | string | 象山局县 | redecorg_cn |
| 内部序号 | PRIPID | string | 3302040040500336 | pripid |
| 移出经营异常名录原因 | REMEXCPRES_CN | string | 企业注销，自动移出 | remexcpres_cn |
| 移出日期 | REMOVE_DT | datetime | 2017-07-07 00:00:00 | remdate |
| 作出决定机关(列入) | DECORG_CN | string | 江东区局 | decorg_cn |
| 企业名称 | COMP_NM | string | 宁波市江东东风胚布拉绒厂 | entname |

---

<a name="6"></a>
## 6. 4

**表名**: `DW_ZJ_SCJDGL_YZWFSX`

### 字段信息

| 中文字段名 | 标准化字段名 | 数据类型 | 样例数据 | 源表字段名 |
| --- | --- | --- | --- | --- |
| 严重违法失信企业名单ID | ILL_COMP_ID | string | 0036C6DF051246AAAA352F625D7A9A0C | illid |
| 列入日期 | ABN_TM | string | 2019-09-04 00:00:00 | abntime |
| 列入严重违法失信企业名单原因 | SERILL_REA | string | 被列入异常名录届满3年仍未履行相关义务的 | serillrea_cn |
| 移出日期 | REM_DT | string | 2019-09-04 00:00:00 | remdate |
| 作出决定机关(移出) | RECORG_OGR | string | 海曙区局 | recorg_cn |
| 统一社会信用代码 | UNI_SOCIAL_CRD_CD | string | 91330282L07196379D | uniscid |
| 移出严重违法失信企业名单原因 | REM_EXCPRES_REA | string | 企业注销，自动移出 | remexcpres_cn |
| 企业名称 | COMP_NAME | string | 慈溪市浒欣谊渔具配件厂 | entname |
| 营业执照注册号 | REG_NO | string | 330200400070010 | regno |
| 作出决定机关(列入) | DECORG_ORG | string | 浙江省市场监督管理局 | decorg_cn |
| 主体身份代码 | PRIPID | string | 3302270000915991 | pripid |
| 所属地市 | DSC_CITY | string | 宁波市 | dsc_city |
| 所属区/县 | DSC_ADM_REGION | string | 江东区 | dsc_adm_region |

---

<a name="7"></a>
## 7. 5

**表名**: `DW_NB_SCJDGL_QYNBWZHWDXX`

### 字段信息

| 中文字段名 | 标准化字段名 | 数据类型 | 样例数据 | 源表字段名 |
| --- | --- | --- | --- | --- |
| 网站标识 | WEB_ID | string | 101298 | WEBID |
| 年报ID | ANNUAL_ID | string | 33062400000894232015 | ANCHEID |
| 网站网店类型 | WEB_STORE_TYPE | string | 1 | WEBTYPE |
| 网站（网店）名称 | WEB_STORE_NM | string | 找煤网 | WEBSITNAME |
| 网站（网店）网址 | WEB_STORE_URL | string | http://www.zhaomei.com | WEBSITE |
| 网站类型 | WEB_TYPE | string | 1 | WEBSMALLTYPE |
| 网络交易平台运营类型 | WEB_PLAT_TYPE | string | 第三方网络交易平台 | WEBPLATFORMTYPE |
| 网络交易产品类型 | WEB_PRODUCT_TYPE | string | 商品交易类平台 | WEBGOODSTYPE |
| 电商类型 | ECOM_TYPE | string | B2B | ECOMMERCETYPE |
| ICP证号/备案号 | ICP_NO | string | 1155478 | ICPBACKNO |
| 微信公众服务号 | WECHAT_PUBLIC | string | DBS2017 | WECHATPUBLICNO |
| APP软件名称 | APP_NM | string | 三易物流科技 | APPNAMES |
| 所属平台名称 | PLAT_NM | string | 1号店 | BELONGPLATFORMNAME |
| 发货地址 | DELI_ADDR | string | 余姚市 | SENDADDRESS |
| 退货地址 | RETURN_ADDR | string | 余姚市 | BACKADDRESS |
| 主体身份代码 | PRIPID |  | 3302820000175108 | PRIPID |
| 统一社会信用代码 | UNI_SOCIAL_CRD_CD | string | 91330282L07196379D | uniscid |
| 企业名称（字号名称） | COMP_NM | string | 慈溪市浒欣谊渔具配件厂 | entname |
| 年报年度 | ANNUAL_YEAR | string |  | ancheyear |

---

<a name="8"></a>
## 8. 6

**表名**: `DW_NB_SCJDGL_XZCFGSXX`

**主键**: LIC_ID

### 字段信息

| 中文字段名 | 标准化字段名 | 数据类型 | 样例数据 | 源表字段名 |
| --- | --- | --- | --- | --- |
| 业务主键 | LIC_ID | string |  | caseid |
| 主体身份代码 | PRIPID | string |  | pripid |
| 统一社会信用代码 | UNI_SOCIAL_CRD_CD | string | 91330282L07196379D | tyshxydm |
| 纳税人名称 | TAXER_NM | string | 慈溪市浒欣谊渔具配件厂 | nsrmc |
| 行政处罚文号 | ADMIN_PUNISH_DOC | string | 慈税罚（2018）40号 | xzcfwh |
| 处罚原因 | PUNISH_REA | string | 《中华人民共和国税收征收管理法》第六十二条 | cfyy |
| 处罚时间 | PUNISH_DT | datetime | 2018-07-27 00:00:00 | cfsj |
| 处罚结果 | PUNISH_RESULT | string | 罚款2000元 | cfjg |
| 法人姓名 | LEGAL_PER | string | 毛宋斌 | frxm |
| 法人身份证号 | LEGAL_PER_IDENT | string | 330222************ | frsfzh |

---

<a name="9"></a>
## 9. 7

**表名**: `DW_NB_SCJDGL_GQBG`

**主键**: LIC_ID

### 字段信息

| 中文字段名 | 标准化字段名 | 数据类型 | 样例数据 | 源表字段名 |
| --- | --- | --- | --- | --- |
| 业务主键 | LIC_ID | string |  | invaltid |
| 主体身份代码 | PRIPID | string | 3302250000130077 | pripid |
| 统一社会信用代码 | UNI_SOCIAL_CRD_CD | string | 91330282L07196379D | uniscid |
| 股东 | INV | string | 朱传树 | inv |
| 股权变更日期 | ALT_DT | datetime | 2017-07-07 00:00:00 | altdate |
| 公示日期 | PUBLIC_DT | datetime | 2017-07-14 00:00:00 | publicdate |
| 变更前股权比例 | TRANSAMPR_BF | float | 40 | transamprbf |
| 变更后股权比例 | TRANSAMPR_AF | float | 0 | transampraf |

---

<a name="10"></a>
## 10. 8

**表名**: `DW_NB_SCJDGL_XWQYMLJBXX`

### 字段信息

| 中文字段名 | 标准化字段名 | 数据类型 | 样例数据 | 源表字段名 |
| --- | --- | --- | --- | --- |
| 统一社会信用代码 | UNI_SOCIAL_CRD_CD | string | 91330282L07196379D | UNISCID |
| 注册号 | REG_NO | string | 330200600002522 | REGNO |
| 名称 | NM | string | 万邦资产评估有限公司 | ENTNAME |
| 类型 | TYPE | string | 9500 | ENTTYPE |
| 成立日期 | ESTAB_DT | datetime | 2006-05-08 00:00:00 | ESTDATE |
| 注册资本 | REG_CAPT | float | 5,000000 | REGCAP |
| 登记机关 | REG_ORG | string | 330200 | REGORG |
| 所属门类 | INDV | string | F | INDUSTRYPHY |
| 行业代码 | INDV_CD | string | 5132 | INDUSTRYCO |

---

<a name="11"></a>
## 11. 9

**表名**: `DW_NB_SCJDGL_XZXK`

**主键**: LIC_ID

### 字段信息

| 中文字段名 | 标准化字段名 | 数据类型 | 样例数据 | 源表字段名 |
| --- | --- | --- | --- | --- |
| 业务主键 | LIC_ID | string | 000201******257000001 | licid |
| 主体身份代码 | PRIPID | string | 3302120000204959 | pripid |
| 统一社会信用代码 | UNI_SOCIAL_CRD_CD | string | 91330282L07196379D | uniscid |
| 许可文件编号 | LIC_NO | string | SL2019108595 | licno |
| 许可文件名称 | LIC_NM | string | 不定时工作制审批 | licname_cn |
| 许可机关 | LIC_ANTH | string | 浙江省财政厅 | licanth |
| 许可内容 | LIC_ITEM | string | 不定时工作制审批 | licitem |
| 状态 | TYPE | string | 1 | type |
| 有效期自 | VAL_FROM | datetime | 2019-06-25 00:00:00 | valfrom |
| 有效期至 | VAL_TO | datetime | 2099-12-31 00:00;00 | valto |

---

<a name="12"></a>
## 12. 10

**表名**: `DW_NB_SCJDGL_CYJYXKZXX`

**主键**: KEY

### 字段信息

| 中文字段名 | 标准化字段名 | 数据类型 | 样例数据 | 源表字段名 |
| --- | --- | --- | --- | --- |
| 主键 | KEY |  | zlsj667 | ID |
| 企业名称 | COMP_NM | string | 慈溪市太芝餐饮店 | ENTNAME |
| 主体业态 | SUBJECT_STAT | string | 2 | LICZTYT |

---

<a name="13"></a>
## 13. 11

**表名**: `DW_NB_SCJDGL_QYNBZCXX`

### 字段信息

| 中文字段名 | 标准化字段名 | 数据类型 | 样例数据 | 源表字段名 |
| --- | --- | --- | --- | --- |
| 年报ID | ANNUAL_ID | string | 9155d6f86dd948afa478978d7eedc6ba | ANCHEID |
| 年报年度 | ANNUAL_YEAR | string | 2019 | ANCHEYEAR |
| 资产总额 | ASSET_ZMT | float | 34 | ASSGRO |
| 负债总额 | DEBT_AMT | float | 39 | LIAGRO |
| 所有者权益合计 | OWNER_EQUITY_TOATAL | float | -6 | TOTEQU |
| 营业总收入 | OPT_INCOME_TOTAL | float | 28 | VENDINC |
| 利润总额 | PROFIT_TOTAL | float | -6 | PROGRO |
| 净利润 | NET_PROFIT | float | -6 | NETINC |
| 纳税总额 | TAX_TOTAL | float | 0 | RATGRO |
| 主体身份代码 | PRIPID |  | 3302120000204959 | PRIPID |
| 统一社会信用代码 | UNI_SOCIAL_CRD_CD | string | 91330282L07196379D | uniscid |
| 企业名称（字号名称） | COMP_NM | string | 慈溪市太芝餐饮店 | entname |

---

<a name="14"></a>
## 14. 12

**表名**: `DW_NB_SCJDGL_ZSCQCZDJ`

**主键**: LIC_ID

### 字段信息

| 中文字段名 | 标准化字段名 | 数据类型 | 样例数据 | 源表字段名 |
| --- | --- | --- | --- | --- |
| 业务主键 | LIC_ID | string | 2095 | pleid |
| 主体身份代码 | PRIPID | string | 3302120000204959 | pripid |
| 统一社会信用代码 | UNI_SOCIAL_CRD_CD | string | 91330282L07196379D | uniscid |
| 知识产权登记号 | TMREG_NO | string | 10205176 | tmregno |
| 名称 | TM_NM | string | 树图形 | tmname |
| 种类 | KINDS | string | 1 | kinds |
| 出质人名称 | PLEDGOR_NM | string | 三生（中国）健康产业有限公司 | pledgor |
| 质权人名称 | IMPORG_NM | string | 三生（中国）健康产业有限公司 | imporg |
| 状态 | STATE | string | 1 | type |
| 公示日期 | PUBLIC_DT | datetime | 2017-02-04 00:00:00 | publicdate |

---

<a name="15"></a>
## 15. 13

**表名**: `DW_NB_SCJDGL_DWTGBZDBXX`

### 字段信息

| 中文字段名 | 标准化字段名 | 数据类型 | 样例数据 | 源表字段名 |
| --- | --- | --- | --- | --- |
| 对外担保标识ID | EXTERNAL_GUA | string | 101609 | MOREID |
| 年报ID | ANNUAL_ID | string | 33020500005551962015 | ANCHEID |
| 债权人 | CREDITOR | string | 工行镇海支行 | MORE |
| 债务人 | DEBTOR | string | 戴强华 | MORTGAGOR |
| 主债权种类 | MAJOR_CREDIT_TYPE | string | 1 | PRICLASECKIND |
| 主债权数额 | MAJOR_CREDIT_AMT | float | 1900 | PRICLASECAM |
| 履行债务的期限自 | PERIOD_FROM | datetime | 2015-12-31 00:00:00 | PEFPERFORM |
| 履行债务的期限至 | PERIOD_TO | datetime | 2015-12-31 00:00:00 | PEFPERTO |
| 保证的期间 | PROMIS_DUR | string | 2 | GUARANPERIOD |
| 对外担保是否公示 | IS_PUBLIC | string | 2 | MOREDIS |
| 保证的方式 | PROMIS_WAY | string | 3 | GATYPE |
| 主体身份代码 | PRIPID | string | 3302250000130077 | PRIPID |
| 统一社会信用代码 | UNI_SOCIAL_CRD_CD | string | 91330282L07196379D | uniscid |
| 企业名称（字号名） | COMP_NM | string | 万邦资产评估有限公司 | entname |
| 年报年度 | ANNUAL_YEAR | string |  | ancheyear |

---

<a name="16"></a>
## 16. 14

**表名**: `DW_NB_SCJDGL_QYNBGDJCZXX`

**中文名称**: PAID_AMT_WAY_CN

### 字段信息

| 中文字段名 | 标准化字段名 | 数据类型 | 样例数据 | 源表字段名 |
| --- | --- | --- | --- | --- |
| 投资人ID | INVESTOR | string | 0000bd063a094441b152c3f5301d9b47 | INVID |
| 年报ID | ANNUAL_ID | string | 677d4aabe3d947d284b86d6ebed756af | ANCHEID |
| 股东/发起人名称 | STOCKER_NM | string | 陈宝泰 | INVNAME |
| 累计认缴额 | CUMULA_SUB_AMT | float | 40 | LISUBCONAM |
| 认缴出资日期 | SUBSCRIP_AMT_DT | datetime | 2011-08-23 00:00:00 | SUBCONDATE |
| 认缴出资方式 | SUBSCRIP_AMT_WAY | string | 1 | SUBCONFORM |
| 认缴出资方式中文名称 | SUBSCRIP_AMT_WAY_CN | string | 货币 | SUBCONFORM_CN |
| 累计实缴额 | CUMULA_PAID_AMT | float | 40 | LIACCONAM |
| 实缴出资日期 | PAID_AMT_DT | datetime | 2011-08-23 00:00:00 | ACCONDATE |
| 实缴出资方式 | PAID_AMT_WAY | string | 1 | ACCONFORM |
| 实缴出资方式中文名称 | PAID_AMT_WAY_CN | string | 货币 | ACCONFORM_CN |
| 主体身份代码 | PRIPID | string | 3302250000130077 | PRIPID |
| 统一社会信用代码 | UNI_SOCIAL_CRD_CD | string | 91330282L07196379D | uniscid |
| 企业名称（字号名称） | COMP_NM | string | 万邦资产评估有限公司 | entname |
| 年报年度 | ANNUAL_YEAR | string |  | ancheyear |

---

<a name="17"></a>
## 17. 15

**表名**: `DW_NB_SCJDGL_SPJYXKZ`

### 字段信息

| 中文字段名 | 标准化字段名 | 数据类型 | 样例数据 | 源表字段名 |
| --- | --- | --- | --- | --- |
| 经营者名称 | OPT_NM | string | 万邦资产评估有限公司 | entname |
| 统一社会信用代码（身份证号码） | UNI_SOCIAL_CRD_CD | string | 91330212066604667N | uniscid |
| 法定代表人（负责人） | LEGAL_REPRE | string | 金荣华 | leper |
| 住所 | ADDR | string | 浙江省宁波市慈溪市周巷镇兴业北路448-450号 | zs |
| 经营地址 | OPT_ADDR | string | 浙江省宁波市慈溪市周巷镇兴业北路448-450号 | lopoc |
| 主体业态 | MAIN_TYPE | string | 食品销售经营者 | maintype |
| 经营项目 | OPT_PRO | string | 保健食品销售 | licscope |
| 许可证编号 | LICENSING_NO | string | JY13302820290302 | licno |
| 发证日期 | ISSUE_DT | datetime | 2020-11-27 00:00:00 | fzrq |
| 发证机关 | ISSUE_DEPT | string | 慈溪市市场监督管理局 | fzjg |
| 有效期起 | VALID_FROM | datetime | 2020-11-27 00:00:00 | qsrq |
| 有效期止 | VALID_TO | datetime | 2025-11-26 00:00:00 | jzrq |
| 类型 | TYPE | string | 统一社会信用代码 | type |
| 证书状态 | LICENSING_STATE | string | 正常 | opstate |
| 所属区划编码 | AREA_NO | string | 330282 | domdic |
| 许可证名称 | LICENSING_NM | string | 食品经营许可证 | licname |

---

<a name="18"></a>
## 18. 16

**表名**: `DW_NB_SCJDGL_GTJYYCBJXX`

### 字段信息

| 中文字段名 | 标准化字段名 | 数据类型 | 样例数据 | 源表字段名 |
| --- | --- | --- | --- | --- |
| 经营异常标记ID | OPT_UNNOR_MARKID | string | 1000028 | BUSEXCLIST |
| 标记日期 | MARK_DT | datetime | 2016-07-01 00:01:30 | COGDATE |
| 是否恢复 | IS_RECOV | string | 1 | ISRECOVERY |
| 恢复日期 | RECOV_DT | datetime | 2017-04-22 02:00:31 | NORDATE |
| 主体身份代码 | PRIPID | string | 3302263000089193 | PRIPID |
| 统一社会信用代码 | UNI_SOCIAL_CRD_CD | string | 91330212066604667N | uniscid |
| 企业名称（字号名称） | COMP_NM | string | 万邦资产评估有限公司 | entname |

---

<a name="19"></a>
## 19. 17

**表名**: `DW_NB_SCJDGL_CZRRJMXXX`

**中文名称**: SUBSCRIP_WAY_CN

### 字段信息

| 中文字段名 | 标准化字段名 | 数据类型 | 样例数据 | 源表字段名 |
| --- | --- | --- | --- | --- |
| 认缴ID | SUBSCRIP_ID | string | 3737639789358 | SUBID |
| 出资人ID | INVESTOR | string | 789358 | INVID |
| 股东/发起人名称 | STOCKER_NM | string | 张建文 | INV |
| 认缴出资额 | SUBSCRIP_AMT | float | 70 | SUBCONAM |
| 认缴出资方式CA22 | SUBSCRIP_WAY | string | 1 | CONFORM |
| 认缴出资方式中文名称 | SUBSCRIP_WAY_CN | string | 货币 | CONFORM_CN |
| 认缴出资日期 | SUBSCRIP_DT | datetime | 2024-03-24 00:00:00 | CONDATE |
| 公示日期 | PUBLIC_DT | datetime | 2014-10-01 00:00:00 | PUBLICDATE |
| 主体身份代码 | PRIPID | string | 3302263000089193 | PRIPID |
| 统一社会信用代码 | UNI_SOCIAL_CRD_CD | string | 91330212066604667N | uniscid |
| 企业名称（字号名称） | COMP_NM | string | 万邦资产评估有限公司 | entname |

---

<a name="20"></a>
## 20. 18

**表名**: `DW_NB_SCJDGL_CZRSJMXXX`

**中文名称**: PAID_WAY_CN

### 字段信息

| 中文字段名 | 标准化字段名 | 数据类型 | 样例数据 | 源表字段名 |
| --- | --- | --- | --- | --- |
| 实缴ID | PAID_ID | string | 38879191743847 | PAIDID |
| 出资人ID | INVESTOR_ID | string | 1743847 | INVID |
| 股东/发起人名称 | STOCKER_NM | string | 黄斌 | INV |
| 实缴出资额 | PAID_AMT | float | 0 | ACCONAM |
| 实缴出资方式CA22 | PAID_WAY | string | 1 | CONFORM |
| 实缴出资方式中文名称 | PAID_WAY_CN | string | 货币 | CONFORM_CN |
| 实缴出资日期 | PAID_DT | datetime | 1998-12-30 00:00:00 | CONDATE |
| 公示日期 | PUBLIC_DT | datetime | 2016-09-18 00:00:00 | PUBLICDATE |
| 主体身份代码 | PRIPID | string | 3302263000089193 | PRIPID |
| 统一社会信用代码 | UNI_SOCIAL_CRD_CD | string | 91330212066604667N | uniscid |
| 企业名称（字号名称） | COMP_NM | string | 万邦资产评估有限公司 | entname |

---

<a name="21"></a>
## 21. 19

**表名**: `DW_NB_SCJDGL_SCJDLYLLYXX`

### 字段信息

| 中文字段名 | 标准化字段名 | 数据类型 | 样例数据 | 源表字段名 |
| --- | --- | --- | --- | --- |
| 联络员ID | LIAI_ID | string | 00000a3aad774eebcf24ea96de77ba5 | LMID |
| 主体身份代码 | SUB_IDENTI_CD | string | 3302263000089193 | PRIPID |
| 姓名 | NM | string | 王晓洁 | NAME |
| 证件类型 | CERT_TYPE | string | 10 | CERTYPE |
| 证件号码 | CERT_NUM | string | 330226************ | CERNO |
| 联络人员手机号码 | LIAI_TEL | string | 130****8666 | TEL |
| 备案类型 | RECORD_TYPE | string | \N | APPLYTYPE |
| 备案日期 | RECORD_DT | datetime | 2019-06-27 00:00:00 | APPLYTIME |
| 统一社会信用代码 | UNI_SOCIAL_CRD_CD | string | 91330212066604667N | uniscid |
| 企业名称（字号名称） | COMP_NM | string | 万邦资产评估有限公司 | entname |

---

<a name="22"></a>
## 22. 20

**表名**: `DW_NB_SGZW_NBXX`

### 字段信息

| 中文字段名 | 标准化字段名 | 数据类型 | 样例数据 | 源表字段名 |
| --- | --- | --- | --- | --- |
| 营业执照注册号 | REG_NO | string | 110000000343473 | regno |
| 统一社会信用代码 | UNI_SOCIAL_CRD_CD | string | 91330282L07196379D | uniscid |
| 企业名称 | COMP_NM | string | 慈溪市太芝餐饮店 | entname |
| 主体身份代码 | PRIPID | string | 3302120000204959 | pripid |
| 企业类型 | COMP_TYPE | string | 1130 | enttype |
| 营运状况 | OPT_STAT | string | 正常开业 | busst_cn |
| 年度报告日期 | ANNUAL_DATE | string | 2017-08-07 09:51:52 | anchedate |
| 年报ID | ANNUAL_ID | string | 11ed870739944076b310a7e79157314c | ancheid |
| 年报年度 | ANNUAL_YEAR | string | 2022 | ancheyear |
| 资产总额 | ASSET_ZMT | double | 0 | assgro |
| 资产总额是否公示 | PUB_ASSET_ZMT | string | 2 | assgrodis |
| 负债总额 | DEBT_AMT | double | 0 | liagro |
| 负债总额是否公示 | PUB_DEBT_AMT | string | 2 | liagrodis |
| 利润总额 | PROFIT_TOTAL | double | 48.754824 | progro |
| 利润总额是否公示 | PUB_PROFIT_TOTAL | string | 2 | progrodis |
| 净利润 | NET_PROFIT | double | -95.31218 | netinc |
| 净利润是否公示 | PUB_NET_PROFIT | string | 2 | netincdis |
| 所有者权益合计 | OWNER_EQUITY_TOATAL | double | -1e-05 | totequ |
| 所有者权益合计是否公示 | PUB_OWNER_EQUITY_TOATAL | string | 2 | totequdis |
| 销售(营业)收入 | OPT_INCOME_TOTAL | double | -0.79477 | vendinc |
| 销售(营业)收入是否公示 | PUB_OPT_INCOME_TOTAL | string | 1 | vendincdis |
| 其中主营业务收入 | MAIN_BUSI_INCOME | double | 2 | maibusinc |
| 其中主营业务收入是否公示 | PUB_ | string | 2 | maibusincdis |
| 纳税总额 | TAX_TOTAL | double | 3.437791 | ratgro |
| 纳税总额是否公示 | PUB_TAX_TOTAL | string | 2 | ratgrodis |
| 从业人数 | EMPLOYEE_NUM | int | 12 | empnum |
| 从业人数是否公示 | PUB_EMPLOYEE_NUM | string | 2 | empnumdis |
| 所属地市 | CITY | string | 宁波市 | dsc_city |
| 所属区/县 | REGION | string | 江东区 | dsc_adm_region |

---

<a name="23"></a>
## 23. 21

**表名**: `DW_NB_YBJ_JRXKXX`

### 字段信息

| 中文字段名 | 标准化字段名 | 数据类型 | 样例数据 | 源表字段名 |
| --- | --- | --- | --- | --- |
| 机构名称 | ORG_NM | string | 中国建设银行股份有限公司宁波霞浦支行 | JGMC |
| 机构编码 | ORG_CD | string | B0004S233020034 | JGBM |
| 批准成立日期 | PUB_DT | datetime | 1994-09-01 00:00:00 | PZCLRQ |
| 批准终止日期 | STOP_DT | datetime | 2018-07-23 00:00:00 | PZZZRQ |
| 营业地址 | OPT_ADDR | string | 宁波市北仑区霞浦街道霞浦路142号 | YYDZ |
| 金融许可证编号 | FINA_LIC_NO | string | 167203 | JRXKZBH |
| 发证日期 | ISSUE_LIC_DT | datetime | 2007-06-11 00:00:00 | FZRQ |
| 发证机关 | ISSUE_LIC_ORG | string | 宁波银监局 | FZJG |
| 批准文号 | APPR_DOC_NO | string | []号 | unit_file_number |

---

<a name="24"></a>
## 24. 22

**表名**: `DW_NB_SW_SBJNXX`

### 字段信息

| 中文字段名 | 标准化字段名 | 数据类型 | 样例数据 | 源表字段名 |
| --- | --- | --- | --- | --- |
| 序列号 | UUID |  | 0043C10DD3ECD2134D1472CE6B3483E6 | uuid |
| 征收项目 | COLL_ITEM | string | 10201、10202、10203、10204、10205 | zsxm_dm |
| 税款所属期起 | PERIOD_FROM | datetime | 2022-01-01 00:00:00 | sssq_q |
| 税款所属期止 | PERIOD_TO | datetime | 2022-01-31 00:00:00 | sssq_z |
| 纳税人识别号 | TAX_NO | string | 330183******052356 | nsrsbh |
| 企业名称 | COMP_NM | string | 宁波能源集团股份有限公司 | nsrmc |
| 税款种类 | TAX_TYPE | string | 10 | skzl_dm |
| 实缴金额 | PAID_AMT | float | 1007.28 | se |
| 入库日期 | RKRQ |  | 2022-02-15 00:00:00 | rkrq |

---

<a name="25"></a>
## 25. 23

**表名**: `DW_ZJ_JS_QYGJJNDJCXX`

### 字段信息

| 中文字段名 | 标准化字段名 | 数据类型 | 样例数据 | 源表字段名 |
| --- | --- | --- | --- | --- |
| 缴存总金额 | PAY_AMT | double | 3243916.02 | jcje |
| 缴存年度 | PAY_YEAR | string | 2017 | jcnd |
| 企业名称 | COMP_NM | string | 象山县贤庠镇人民政府 | qymc |
| 机构号 | ORG_NO | string | 14 | jgh |
| 单位账号 | UNIT_ACCO | string | 33022530019 | dwzh |
| 统一社会信用代码 | UNI_SOCIAL_CRD_CD | string | 1133022500296433XT | tyshxydm |

---

<a name="26"></a>
## 26. 24

**表名**: `DW_ZJ_JS_QYGJJYDJCXX`

### 字段信息

| 中文字段名 | 标准化字段名 | 数据类型 | 样例数据 | 源表字段名 |
| --- | --- | --- | --- | --- |
| 单位名称 | COMP_NM | string | 宁波可意家用品有限公司 | qymc |
| 本期缴存金额（元） | PAY_AMT | double | 12320 | jcje |
| 公积金单位帐号 | PROV_FUND_ACCO | string | 10100001776 | dwzh |
| 缴存日期 | PAY_DT | datetime | 2017-12-21 00:00:00 | jcrq |
| 组织机构代码 | ORG_ID | string | 74218321-3 | zzjgdm |
| 单位缴存人数 | PAY_PERS_NUM | smallint | 40 | jcrs |
| 公积金中心机构号 | JGH | string | 11 | jgh |

---

<a name="27"></a>
## 27. 25

**表名**: `DW_NB_KJ_GXJSQYXX`

### 字段信息

| 中文字段名 | 标准化字段名 | 数据类型 | 样例数据 | 源表字段名 |
| --- | --- | --- | --- | --- |
| 唯一标识 | UNIQUEID |  | 8BE058CB-5C8E-47DC-9466-F1BB721C178B3 | uniqueid |
| bid | BID |  | 8BE058CB-5C8E-47DC-9466-F1BB721C178B3 | bid |
| 企业名 | COMP_NM | string | 浙江瓦力新能源科技有限公司 | qym |
| 高企证书号 | HIGH_TECH_DOC | string | GR201733100657 | gqzsm |
| 发证日期 | ISSUE_DT | string | 2017-11-29 00:00:00 | fzrq |
| 持证单位代码 | HOLD_CERT_CD | string | 91330200561262545U | czdwdm |
| 颁证单位组织机构代码 | BJDWDM | string | 113300******82090Q | bjdwdm |
| 颁证单位 | AWARD_CERT | string | 浙江省科学技术厅 | bjdw |
| 行政区划代码 | AREA_NM | string | 3****** | xzqhdm |
| 持证主体代码类型 | HOLD_SUB_CD_TYPE | string | 001 | czztdmlx |
| 守信信息名称 | TRUST_INFO_NM | string | 获准高新技术企业认证 | sxxxmc |
| 认定依据 | COGN_BASIS | string | 国科火字[2017]201号 | rdyj |
| 列入事由 | COGN_MATTER | string | 国科火字[2017]201号 | lrsy |

---

<a name="28"></a>
## 28. 26

**表名**: `DW_NB_KJ_SJKJXZXQYXX`

**主键**: ID

### 字段信息

| 中文字段名 | 标准化字段名 | 数据类型 | 样例数据 | 源表字段名 |
| --- | --- | --- | --- | --- |
| 主键 | ID |  | 1 | id |
| 认定年份 | YEAR_ID | string | 2020 | year_id |
| 企业名称 | NAME | string | 宁波托普电器有限公司 | name |
| 区县市 | AREA_NAME | string | 北仑区 | area_name |

---

<a name="29"></a>
## 29. 27

**表名**: `DW_NB_KJ_NBSKJXXWQYXX`

### 字段信息

| 中文字段名 | 标准化字段名 | 数据类型 | 样例数据 | 源表字段名 |
| --- | --- | --- | --- | --- |
| 序号 | SERIALID |  | 10 | serialid |
| 组织机构代码 | CREDITCODE |  | 058252771 | creditcode |
| 认定年份 | COGN_YEAR | smallint | 2013 | cognizanceyear |
| 认定机构 | COGN_UNIT | string | 宁波市科学技术局 | cognizanceunit |
| 企业名称 | COMP_NM | string | 宁波千云塑业科技有限公司 | unitname |

---

<a name="30"></a>
## 30. 28

**表名**: `DW_NB_KJ_SGCZKJXZXQY`

### 字段信息

| 中文字段名 | 标准化字段名 | 数据类型 | 样例数据 | 源表字段名 |
| --- | --- | --- | --- | --- |
| 企业名称 | COMP_NM | string | 浙江首游网络科技有限公司 | unitname |
| 序号 | NO | string | 1 | recordid |
| 认定年份 | CONGNIZ_TEAR | string | 2016 | cognizanceyear |
| 认定机构 | CONGNIZ_ORG | string | 浙江省科学技术厅 | cognizanceunit |
| 组织机构代码 | ORG_ID | string | 913302******307724 | creditcode |

---

<a name="31"></a>
## 31. 29

**表名**: `DW_ZJ_FZGG_CFJBXX`

**主键**: CD_ID

### 字段信息

| 中文字段名 | 标准化字段名 | 数据类型 | 样例数据 | 源表字段名 |
| --- | --- | --- | --- | --- |
| 主键ID | CD_ID | string | 22cab6ac6946434ebe91e6f32f9f36b0 | cd_id |
| 唯一标志符 | RECORD_UNIQUE_IDENTITY | string | 22cab6ac6946434ebe91e6f32f9f36b0 | record_unique_identity |
| 案件编号 | PUNISH_CASE_CODE | string | 113308******31567220212000089 | punish_case_code |
| 处罚行为名称 | PUNISH_ACTION_NAME | string | 对具备使用有毒物品\粉尘超标等易导致职业病因素的作业场所的行政检查 | punish_action_name |
| 执法主体名称 | IMPLEMENT_INSTITUTION | string | 宁波国家高新技术产业开发区社会事务管理局 | implement_institution |
| 执法主体统一社会信用码 | IMPLEMENT_INSTITUTION_CODE | string | 123305******093287 | implement_institution_code |
| 是否委托其他部门实施 | IS_ENTRUST | string | 0 | is_entrust |
| 受委托组织名称 | ENTRUST_DEPT_NAME | string | 临海市卫生监督所 | entrust_dept_name |
| 受委托组织编码 | ENTRUST_DEPT_CODE | string | 12331082472660525j | entrust_dept_code |
| 案件程序类别 | CASE_PROCESS_TYPE | string | 01 | case_process_type |
| 案件来源 | CASE_SOURCE_TYPE | string | 01 | case_source_type |
| 案件来源日期 | CASE_SOURCE_DATE | datetime | 2021-08-02 00:00:00 | case_source_date |
| 检查案件编号 | CHECK_CASE_CODE | string | 095A51D128D1496CB7482D9CE8B2A2B9 | check_case_code |
| 移送部门名称 | DEPORTATION_DEPT_NAME | string | 余姚市人民法院 | deportation_dept_name |
| 移送部门统一社会信用码 | DEPORTATION_DEPT_CODE | string | 12330227419611791H | deportation_dept_code |
| 当事人类型 | ADMINISTRATIVE_CP_TYPE | string | 02 | administrative_cp_type |
| 当事人名称 | ADMINISTRATIVE_CP_NAME | string | 秦敏 | administrative_cp_name |
| 当事人身份证件类型 | ADMINISTRATIVE_CP_CERT_TYPE | string | 001 | administrative_cp_cert_type |
| 当事人证件号码 | ADMINISTRATIVE_CP_CERT_CODE | string | 123302******11791H | administrative_cp_cert_code |
| 当事人联系电话 | ADMINISTRATIVE_CP_TEL | string | 15397249229 | administrative_cp_tel |
| 法定代表人姓名 | LEGAL_REPRESENTATIVE | string | 张国定 | legal_representative |
| 法定代表人身份证号码 | LEGAL_REPRESENTATIVE_IDCARD | string | 330227************ | legal_representative_idcard |
| 住所（住址）行政区划代码(国家标准，不含经济开发区) | AREA_CODE_LIVE | string | 130821106 | area_code_live |
| 住所（住址）行政区划名称 | AREA_NAME_LIVE | string | 丽水市 | area_name_live |
| 住所（住址） | ADDRESS_LIVE | string | 万卷路397号 | address_live |
| 注册地址行政区划编码 | AREA_CODE_REGISTERD | string | 330000 | area_code_registerd |
| 注册地址行政区划名称 | AREA_NAME_REGISTERD | string | 万象街道 | area_name_registerd |
| 注册地址 | ADDRESS_REGISTERD | string | 693号 | address_registerd |
| 经营地址行政区划编码 | AREA_CODE_OPERATING | string | 330000 | area_code_operating |
| 经营地址行政区划名称 | AREA_NAME_OPERATING | string | 万象街道 | area_name_operating |
| 经营地址 | ADDRESS_OPERATING | string | 693号 | address_operating |
| 执法人员姓名 | PUNISH_PERSONNEL_NAME | string | 王亚军,杜晓颖 | punish_personnel_name |
| 执法人员证件编号 | PUNISH_PERSONNEL_CODE | string | ,0205262020040290 | punish_personnel_code |
| 案情介绍 | CASE_DESC | string |  | case_desc |
| 是否移送司法机关 | IS_DEPORTED | smallint | 1 | is_deported |
| 移送、 抄送司法机关时间 | DEPORT_TIME | datetime | 2017-08-24 00:00:00 | deport_time |
| 0:否， 1： 是（如果没有立案，立案相关信息不传） | IS_FILING | smallint | 1 | is_filing |
| 创建时间 | CREATE_TIME | string | 2022-03-04 19:00:06 | create_time |
| 更新类型 | OPT_TYPE | string | I | opt_type |
| 测试数据标识 | ENV_FLAG | bigint | 0 | env_flag |
| 来源厅局编码 | SOURCE_DEPT_CODE | string | 6 | source_dept_code |
| 插入时间 | CD_TIME | datetime | 2022-03-24 10:08:28 | cd_time |
| 行政区划编码 | ADMINI_DIVISION_CODE | string | 330281 | admini_division_code |
| 组织编码 | ORG_CODE | string | 1008002007023 | org_code |
| 法定代表人证件类型 | LEGAL_REPRESENTATIVE_TYPE | string | 111 | legal_representative_type |
| FLAG | FLAG | bigint | 1 | flag |

---

<a name="32"></a>
## 32. 30

**表名**: `DW_ZJ_FZGG_XZCFJDXX`

**主键**: ID

### 字段信息

| 中文字段名 | 标准化字段名 | 数据类型 | 样例数据 | 源表字段名 |
| --- | --- | --- | --- | --- |
| 主键 | ID | string | 1/2000 | id |
| 案件名称 | CASE_NAME | string | 暂无 | xzcfws_name |
| 违法行为类型 | EXTEND_1 | string | 暂无 | extend_1 |
| 处罚类别 | PUNISH_TYPE | string | 通报批评 | extend_4 |
| 行政处罚决定书文号 | ADMIN_PUNISH_DOC | string | 3 | writnumber |
| 对外公开的处罚决定书全文或摘要 | PUNISH_CONTENT | text |  | punishcontent |
| 处罚依据 | LAW_BASIS | text | 暂无 | lawbasis |
| 罚款 | PUNISH_MONEY | string | 10000 | punishmoney |
| 没收违法所得 | ILLEGALITY_MONEY | string | 暂无 | illegalitymoney |
| 暂扣或吊销证照名称 | REVOKE_LICENSE | string | 暂无 | revokelicense |
| 暂扣或吊销证照编号 | REVOKE_CODE | string | 暂无 | revokecode |
| 处罚决定日期 | PUNISH_DECIDE_TM | string | 2019-05-22 00:00:00 | punishdecidetime |
| 处罚有效期 | PUNISH_VALID_DT | string | 无处罚期限 | punishvaliddate |
| 公示截止期 | PUBLIC_DEADLINE | string | 1900-01-01 00:00:00 | publicdeadline |
| 参与该业务办理第一环节的部门名称 | CASEDEPTNAME | string | 暂无 | casedeptname |
| 参与该业务办理第一环节的部门的统一社会信用代码 | EXTEND_2 | string | 暂无 | extend_2 |
| 数据来源单位 | CF_SJLY | string | 浙江省司法厅 | cf_sjly |
| 数据来源单位统一社会信用代码 | CF_SJLYDM | string | 113300******82154N | cf_sjlydm |
| 案件撤销原因 | CANCEL_REASON | text | 暂无 | extend_3 |

---

<a name="33"></a>
## 33. 31

**表名**: `DW_ZJ_FZGG_SXBZXRXX`

### 字段信息

| 中文字段名 | 标准化字段名 | 数据类型 | 样例数据 | 源表字段名 |
| --- | --- | --- | --- | --- |
| 法院代码 | FYDM | string | 675 | fydm |
| 被执行人姓名/名称 | EXECUTED_NM | string | 周玉六 | bzxrmc |
| 身份证号码 | IDENTI_ID | string | 410724************ | sfzhm |
| 组织机构代码 | UNI_SOCIAL_CRD_CD | string | 1616173 | zzjgdm |
| 法定代表人或者负责人姓名 | LEGAL_REPRE | string | 郭赞楼 | fddbr |
| 执行法院 | EXECUTED_COURT | string | 获嘉县人民法院 | zxfy |
| 执行依据文号 | ENFORCE_BASIS | string | (2016)豫0724民初2559号 | zxyjwh |
| 立案时间 | FIL_DT | datetime | 2022-01-24 00:00:00 | larq |
| 案号 | CASE_NO | string | (2022)豫0724执恢54号 | ah |
| 做出执行依据单位 | DECI_EXECUTED_UNIT | string | 获嘉县人民法院 | zczxyjdw |
| 生效法律文书确定的义务 | EFFECT_DOC_OBLI | string | 无 | sxflwsqdyw |
| 被执行人的履行情况 | EXECUTED_PERFOR | string | 全部未履行 | bzxrlxqk |
| 发布时间 | PUBLISH_DT | datetime | 2022-01-27 00:00:00 | fbrq |
| 搜案年号 | SEARCH_CASE_YEAR | string | 2022 | sanh |
| 搜案编号 | SEARCH_CASE_NO | string | 715431643 | sabh |
| 被执行人序号 | BZXRXH | string | 1 | bzxrxh |
| 已履行部分 | PERFORMED_PART | string | 暂无 | ylxbf |
| 未履行部分 | UN_PERFORMED_PART | string | 暂无 | wlxbf |
| 失信ID | DISHONEST_ID | string | 715431643 | sxid |
| 性别 | GEN | string | 男性 | xb |
| 被执行人性质 | EXECUTED_NATURE | string | 自然人 | bzxrxz |
| 出生日期 | BIRTH_DT | datetime | 1969-12-29 00:00:00 | csrq |
| 失信被执行人行为情况 | DISHONEST_BEHAV | string | 其他规避执行 | sxbzxrxwqk |

---

<a name="34"></a>
## 34. 32

**表名**: `DW_NB_SL_SLSWLYQYPJXX`

### 字段信息

| 中文字段名 | 标准化字段名 | 数据类型 | 样例数据 | 源表字段名 |
| --- | --- | --- | --- | --- |
| 企业ID | COMP_ID | string | 88310049-9525-481D-B128-CEA436F70146 | company_id |
| 企业名称 | COMP_NAME | string | 浙江省围海建设集团股份有限公司 | company_name |
| 评价时间 | EVAL_TIME | string | 2016-01-05 16:53:39 | eval_time |
| 评价等级 | RANK_LEVEL | string | A | rank_level |
| 评价版本 | EVAL_RANK_NUMBER | bigint | 1 | eval_rank_number |
| 单位类型 | COMPANY_TYPE | string | 施工单位 | company_type |

---

<a name="35"></a>
## 35. 33

**表名**: `DW_NB_SL_QJSFQYXX`

### 字段信息

| 中文字段名 | 标准化字段名 | 数据类型 | 样例数据 | 源表字段名 |
| --- | --- | --- | --- | --- |
| 统计年月 | COUNT_YM | datetime | 202011 | TJNY |
| 统一社会信用代码 | UNI_SOCIAL_CRD_CD | string | 913302******531452 | TYSHXYDM |
| 用户号 | USER_ID | string | nbfs_172319 | YHH |
| 用户性质 | USER_NATURE | string | 居民用水 | YHXZ |
| 法人机构名称 | LEGAL_ORG_NM | string | 浙江捷达物业服务有限公司 | FRJGMC |
| 用水地址 | USE_ADDR | string | 奉化区方桥宁桂苑消防水池 | YSDZ |
| 账单流水号 | BILL_NO | string | 172319202012 | ZDLSH |
| 欠费期数 | ARREAR_TMS | int | 1 | QFQS |
| 金额 | AMT | float | 137.25 | JE |
| 行政区域代码 | AREA_CD | string | 330213000000 | XZQYDM |

---

<a name="36"></a>
## 36. 34

**表名**: `DW_NB_ZHZF_FRYSSJXX`

### 字段信息

| 中文字段名 | 标准化字段名 | 数据类型 | 样例数据 | 源表字段名 |
| --- | --- | --- | --- | --- |
| 统一社会信用代码 | UNI_SOCIAL_CRD_CD | string | 913101******61427B | tyshxydm |
| 用户号 | YHH | string | 3433500 | yhh |
| 用户性质 | USER_NATURE | string | 工业 | yhxz |
| 抄表日期 | METER_READ_DT | datetime | 2021-10-03 00:00:00 | cbrq |
| 本期抄见 | PERIOD_COPY | string | 38121 | bqcj |
| 本期水量 | WATER_CONSUM | float | 1166 | bqsl |
| 滞纳金额 | OVERDUE_AMT | float | 0 | znje |

---

<a name="37"></a>
## 37. 35

**表名**: `DW_NB_ZHZF_FRYQSJXX`

### 字段信息

| 数据项 | 数据项英文名称 | 数据项标签 | 数据类型 |
| --- | --- | --- | --- |
| 统一社会信用代码 | TYSHXYDM |  | VARCHAR/字符串型C |
| 账单流水号 | ZDLSH |  | VARCHAR/字符串型C |
| 用气证号 | YQZH |  | VARCHAR/字符串型C |
| 表计号 | BSH |  | VARCHAR/字符串型C |
| 滞纳金额 | ZNJE |  | DECIMAL/数值型N |
| 本期用气量 | BQYQL |  | VARCHAR/字符串型C |
| 本期抄见 | BQCJ |  | VARCHAR/字符串型C |
| 数据来源 | SJLY |  | VARCHAR/字符串型C |
| 上次抄表日期 | SCCBRQ |  | DATETIME/日期时间型T |
| 上期抄见 | SQCX |  | VARCHAR/字符串型C |
| 抄表日期 | CBRQ |  | DATETIME/日期时间型T |
| 法人机构名称 | FRJGMC |  | VARCHAR/字符串型C |
| 用户性质 | YHXZ |  | VARCHAR/字符串型C |
| 用户地址 | YHDZ |  | VARCHAR/字符串型C |
| 用户号 | YHH |  | VARCHAR/字符串型C |
| 行政区域代码 | XZQYDM |  | VARCHAR/字符串型C |

---

<a name="38"></a>
## 38. 36

**表名**: `DW_NB_STHJ_WXFWJYXK`

### 字段信息

| 中文字段名 | 标准化字段名 | 数据类型 | 样例数据 | 源表字段名 |
| --- | --- | --- | --- | --- |
| 证件状态 | USE_STATE | string | 有效 | use_state |
| 发证日期 | AUTH_DATE | datetime | 2016-12-07 00:00:00 | auth_date |
| 数据唯一编码 | DATA_ID | string | 689 | data_id |
| 统一社会信用代码 | ENT_CODE | string | 913302******82264P | ent_code |
| 发证机关 | AUTH_DEPART | string | 浙江省生态环境厅 | auth_depart |
| 有效期限起 | AVA_START | datetime | 2016-12-07 00:00:00 | ava_start |
| 证照号 | LIC_NO | string | 3302000225 | lic_no |
| 签名值 | SIGNVALUE | string |  | signvalue |
| 注册地址 | REG_ADDRESS | string | 奉化东江路11号 | reg_address |
| 有效期限止 | AVA_END | datetime | 2021-12-06 00:00:00 | ava_end |
| 签名公钥证书 | SIGNCERT | string |  | signcert |
| 时间戳 | TNSVALUE | string |  | tnsvalue |
| 单位名称 | ENT_NAME | string | 宁波金土地固体废物回收有限公司 | ent_name |
| 经营地址 | BUS_ADDRESS | string | 奉化东江路11号 | bus_address |
| 经营范围 | BUS_AREA | string | 其他废物 | bus_area |
| 法定代表人 | MAIN_LEADER | string | 王云 | main_leader |
| 签名hash值 | SIGNHASHCODE | string |  | signhashcode |
| 证照颁发机构代码 | ISSUECODE | string |  | issuecode |
| 持证主体代码类型 | HOLDERTYPE | string |  | holdertype |
| 行政区划代码 | ARECODE | string | 3***** | arecode |

---

<a name="39"></a>
## 39. 37

**表名**: `DW_NB_DSJ_XYPJXX`

### 字段信息

| 中文字段名 | 标准化字段名 | 数据类型 | 样例数据 | 源表字段名 |
| --- | --- | --- | --- | --- |
| 主体名称 | COMP_NM | string | 绍兴华泽装饰有限公司 | qymc |
| 统一社会信用代码 | UNI_SOCIAL_CRD_CD | string | 913306******UD4P7H | uscc |
| 信用分 | CRED_SCARD | string | 815 | zhxyf |
| 评价时间 | EVALU_DT | datetime | 2022-03-25 00:00:00 | pjsj |
| 所属地市 | LOCAL_CITY | string | \N | dsc_city |
| 所属区/县 | LOCAL_DISTRICT | string | \N | dsc_adm_region |

---

<a name="40"></a>
## 40. 38

**表名**: `DW_NB_JT_QYZHZSXX`

**主键**: KEY_ID

### 字段信息

| 中文字段名 | 标准化字段名 | 数据类型 | 样例数据 | 源表字段名 |
| --- | --- | --- | --- | --- |
| 主键ID | KEY_ID | string | 10000 | ID |
| 证书编号 | CERT_NO | string | D233061246 | CERTIFICATENO |
| 发证机关 | ISSURE_ORG | string | 浙江省交通运输厅 | ISSUECERTIFICATEORGAN |
| 起始日期 | START_DT | datetime | 2016-07-05 00:00:00 | ISSUEDATE |
| 终止日期 | END_DT | datetime | 2021-04-26 00:00:00 | CERTIFICATEENDDATE |

---

<a name="41"></a>
## 41. 39

**表名**: `DW_NB_SW_NSRJCXX`

### 字段信息

| 中文字段名 | 标准化字段名 | 数据类型 | 样例数据 |
| --- | --- | --- | --- |
| 统一社会信用代码 | UNI_ SOCIAL_CRD_ CD | string |  |
| 纳税人识别号 | TAX_ PAYER_NO | string |  |
| 税务登记日期 | TAX_REG_DT | datetime |  |
| 纳税人状态 | TAX_ PAYER_STATE | string |  |
| 企业名称 | COMP NM | string |  |
| 主管税务所代码 | TAX_OFFICE_ NO | string |  |
| 主管税务所名称 | TAX_OFFICE_NM | string |  |
| 主管税务机关代码 | TAX_ DEPT_NO | string |  |
| 主管税务机关名称 | TAX_DEPT_NM | string |  |

---

<a name="42"></a>
## 42. 40

**表名**: `DW_NB_SW_FZCHRD`

### 字段信息

| 中文字段名 | 标准化字段名 | 数据类型 | 样例数据 |
| --- | --- | --- | --- |
| 统一社会信用代码 | UNI_ SOCIAL_CRD_ CD | string |  |
| 企业名称 | COMP NM | string |  |
| 非正常户认定日期 | UNNOR_ COGNI_DT | datetime |  |
| 法定代表人身份证号 | LEGAL_ REPRE_ ID | string |  |
| 法定代表人 | LEGAL_ REPRE | string |  |

---

<a name="43"></a>
## 43. 41

**表名**: `DW_NB_SW_QYSKZSXX`

### 字段信息

| 中文字段名 | 标准化字段名 | 数据类型 | 样例数据 | 源表字段名 |
| --- | --- | --- | --- | --- |
| 主管税务所（科、分局） | MAJOR_TAX_UNIT | string | 国家税务总局宁波市鄞州区税务局姜山税务所 | swjgmc |
| 企业名称 | COMP_NM | string | 宁波农之园菜篮子配送有限公司 | nsrmc |
| 入库日期 | RKRQ | datetime | 2019-09-18 00:00:00 | rkrq |
| 实缴金额 | PAID_AMT | float | 9460 | ybtse |
| 序列号 | YZPZXH | string | 10013319000020648922 | yzpzxh |
| 征收项目 | COLL_ITEM | string | 车辆购置税 | zsxmmc |
| 税款所属期止 | PERIOD_TO | datetime | 2019-08-30 00:00:00 | skssqz |
| 税款所属期起 | PERIOD_FROM | datetime | 2019-08-30 00:00:00 | skssqq |
| 税款种类 | TAX_TYPE | string | 正税 | skzlmc |
| 纳税人识别号 | UNI_SOCIAL_CRD_CD | string | 91330212066604667N | tyshxydm |

---

<a name="44"></a>
## 44. 42

**表名**: `DW_NB_SW_ZDSSWFHMD`

### 字段信息

| 中文字段名 | 标准化字段名 | 数据类型 | 样例数据 |
| --- | --- | --- | --- |
| 纳税人识别号 | TAX_NO | string |  |
| 纳税人名称 | TAX_NM | string |  |
| 法定代表人身份证号 | LEGAL_REPRE_ ID | string |  |
| 法定代表人性别 | LEGAL_REPRE_GENDER | string |  |
| 法定代表人姓名 | LEGAL_REPRE | string |  |
| 注册地址 | REG_ADDR | string |  |
| 组织机构代码 | ORG_NO | string |  |
| 处罚依据 | PUNISH_BASIS | string |  |
| 主要违法事实 | MAIN_ILLG_FACT | string |  |
| 案件性质 | CASE_NATURE | string |  |
| 税务处理处罚情况 | TAX_PUNNISH_STATE | string |  |
| 录入时间 | ENTRY_TM | datetime |  |
| 移出时间 | REMOVE_TM | datetime |  |

---

<a name="45"></a>
## 45. 43

**表名**: `DW_NB_SW_QSXX`

### 字段信息

| 中文字段名 | 标准化字段名 | 数据类型 | 样例数据 |
| --- | --- | --- | --- |
| 纳税人识别号 | TAX_NO | string |  |
| 纳税人名称 | TAX NM | string |  |
| 生产经营地址 | OPR_ADDR | string |  |
| 欠税税种 | OWN_TAX_TYPE | string |  |
| 累计欠税余额 | CUMU_OWN_AMT | float |  |
| 企业个体标志 | COMP_INDI_MARK | string |  |
| 发布部门 | PUB_DEPT | string |  |

---

<a name="46"></a>
## 46. 44

**表名**: `DW_NB_SW_NSXYDJXX`

### 字段信息

| 中文字段名 | 标准化字段名 | 数据类型 | 样例数据 |
| --- | --- | --- | --- |
| 统一社会信用代码 | UNI_SOCIAL_CRD_CD | string |  |
| 纳税人名称 | TAX_NM | string |  |
| 评价年度 | EVALUA_YEAR | string |  |
| 信用等级 | TAX_CREDIT_LEVEL | string |  |
| 评价单位 | EVALUA_DEPT | string |  |
| 评定时间 | EVALUA_DT | datetime |  |
| 信用评价名称 | CREDIT_EVALUA_ NM | string |  |
| 企业个体名称 | COMP SINGL NM | string |  |
| 评价结果有效期始 | EVALUA_RESULT_START | datetime |  |
| 评价结果有效期止 | EVALUA_ RESULT_END | datetime |  |

---

<a name="47"></a>
## 47. 45

**表名**: `DW_NB_SW_CSJRXZCFXX`

### 字段信息

| 中文字段名 | 标准化字段名 | 数据类型 | 样例数据 | 源表字段名 |
| --- | --- | --- | --- | --- |
| 纳税人名称 | TAXER_NM | string | 宁波市筑仁教育信息咨询有限公司 | nsrmc |
| 唯一编码 | UUID | string | \N | uuid |
| 统一社会信用代码 | UNI_SOCIAL_CRD_CD | string | 913302******1J283L | shxydm |
| 处罚日期 | PUNISH_DT | datetime | 20200316 | cfrq |
| 罚款金额 | PUNISH_AMT | string | 100 | fkje |
| 纳税人识别号 | TAXER_NO | string | 913302******1J283L | nsrsbh |
| 行政处罚文号 | ADMIN_PUNISH_DOC | string | 海税简罚(2020)211号 | wh |
| 登记序号 | REG_NO | string | 101192******52751496 | djxh |
| 处罚依据 | PUNISH_REA | string | 2019-06-01至2019-06-30个人所得税(个人薪资所得)未按期进行申报<<中华人民共和国税务征收管理法>>第六十二条 | cfyj |

---

<a name="48"></a>
## 48. 46

**表名**: `DW_NB_SW_CSJRSWJCXX`

### 字段信息

| 中文字段名 | 标准化字段名 | 数据类型 | 样例数据 | 源表字段名 |
| --- | --- | --- | --- | --- |
| 企业名称 | COMP_NM | string |  | NSRMC |
| 统一社会信用代码 | UNI_SOCIAL_CRD_CD | string |  | SHXYDM |
| 组织机构代码 | ORGANI_CODE | string |  | ZZJG_DM |
| 检查所属日期起 | CHECK_DATE_START | string |  | JCSSQJQ |
| 检查所属日期止 | CHECK_DATE_END | string |  | JCSSQJZ |
| 主要违法事实 | MAIN_ILLEGAL_FACTS | string |  | SSWFSD |
| 查补金额 | MEND_AMT | string |  | YJSKZE |
| 处罚决定书文号 | PUNISH_DOC | string |  | WH |
| 处罚日期 | PUNISH_DATE | string |  | JRRQ |
| 处罚金额 | PUNISH_AMT | string |  | YJFKZE |
| 税务登记证号 | TAX_REG_NO | string |  | NSRSBH |
| 移送司法标志 | TRANSF_JUSTI_SIGN | string |  | YSSFBZ |

---

<a name="49"></a>
## 49. 49

**表名**: `DW_ZJ_GA_LDRKJBXX`

### 字段信息

| 中文字段名 | 标准化字段名 | 数据类型 | 样例数据 | 源表字段名 |
| --- | --- | --- | --- | --- |
| 姓名 | NM | string | 王瑞英 | xm |
| 公民身份号码 | IDENTI_ID | string | 522426************ | sfzh |
| 居住证号 | ZZZH | string | 330282******375373 | zzzh |
| 性别（1男；2女） | GEN | string | 2 | xb |
| 民族 | NATION | string | 01 | mz |
| 县（市、区） | COUNTY | string | 330282 | qx |
| 派出所 | POLICE_STATION | string | 330282022 | pcs |
| 街路巷 | STREET | string | \N | jlx |
| 居住地址 | ADDR | string | 周巷村镇东新村后界塘51号东101室 | zzdz |
| 出租人姓名 | LESSOR_NM | string | 吴浩忠 | fzxm |
| 出租人公民身份号码 | LESSOR_ID | string | 330222196502058257 | fzsfzh |
| 登记日期 | REG_DT | datetime | 20190404 | djrq |
| 注销日期 | CAN_DT | datetime | 20190404 | zxrq |
| 出租房屋档案号 | RENTAL_FILE_NUM | string | 330282******034228 | czfwdah |
| 户籍县（市、区） | HOU_REG_COUNTRY | string | 520524 | hjqx |
| 户籍地址 | HOU_REG_ADDR | string | 阿弓镇狗场村兰杆组 | hjdz |
| 联系电话 | TEL | string | 18267429736 | lxdh |
| 性别代码 | GEN_CD | string | 男 | xbdm |
| 民族代码 | NATION_ID | string | 汉族 | mzdm |
| 县（市、区）代码 | QXDM | string | 浙江省慈溪市 | qxdm |
| 派出所代码· | PCSDM | string | 附海派出所 | pcsdm |
| 户籍县（市、区）代码 | HJQXDM | string | 贵州省织金县 | hjqxdm |
| 登记状态名称 | REG_STAT_NM | string | 失效 | djztmc |

---

<a name="50"></a>
## 50. 50

**表名**: `DW_ZJ_GA_CZRKHK`

### 字段信息

| 中文字段名 | 标准化字段名 | 数据类型 | 样例数据 | 源表字段名 |
| --- | --- | --- | --- | --- |
| 人口ID | CZRKRKID | string | 63121805 | czrkrkid |
| 出生地省市县（区） | BIRTH_PCC | string | 浙江省宁波市 | czrkcsdssx |
| 所属省市县区 | BELO_PCC | string | 3***** | czrkssssxq |
| 公民身份号码 | IDENTI_ID | string | 330203************ | czrkgmsfhm |
| 姓名 | NM | string | 包卿雯 | czrkxm |
| 曾用名 | USED_NM | string | 邵家庭 | czrkcym |
| 性别 | GEN | string | 男 | czrkxb |
| 民族 | NATION | string | 汉族 | czrkmz |
| 出生日期 | BIRTH_DT | string | 20180806 | czrkcsrq |
| 出生地国家（地区） | BIRTH_COUNTRY | string | 中国 | czrkcsdgj |
| 籍贯国家（地区） | CZRKJGGJ | string | \N | czrkjggj |
| 籍贯省市县（区） | NATIVE_PCC | string | 浙江省宁波市 | czrkjgssx |
| 文化程度 | EDU_DEGREE | string | 高中 | czrkwhcd |
| 婚姻状况 | MARITAL_STATUS | string | 已婚 | czrkhyzk |
| 兵役状况 | MILI_SER_STATUS | string | 未服兵役 | czrkbyzk |
| 住址 | ADDR | string | 浙江省宁波市海曙区舒沁苑2幢5号906室 | czrkzz |
| 照片URL | XPURL | string | \N | xpurl |
| 户号ID | CZRKHHID | string | 330000001020834643 | czrkhhid |
| 户号 | ACCOUNT_NUM | string | 28039907 | czrkhh |
| 户类型 | ACCOUNT_TYPE | string | 家庭户 | czrkhlx |
| 与户主关系 | HOUSEHOLD_RELA | string | 户主 | czrkyhzgx |
| 死亡日期 | DEAD_DT | datetime | \N | czrkswrq |
| 死亡注销类别 | DEAD_CAN_TYPE | string | \N | czrkswzxlb |
| 迁出日期 | MOVEOUT_DT | datetime | \N | czrkqcrq |
| 迁出注销类别 | MOVEOUT_CAN_TYPE | string | \N | czrkqczxlb |
| 注销日期 | CAN_DT | datetime | \N | czrkzxrq |
| 注销标识 | CAN_ID | string | \N | czrkzxbs |
| 所属派出所名称 | POLICE_STATION_NM | string | 海曙分局望春派出所 | czrkpcsmc |
| 所属派出所机构代码 | CZRKPCSJGDM | string |  | czrkpcsjgdm |
| 所属街路巷名称 | STREET_NM | string | 33********00 | czrkjlxmc |
| 所属居民委会名称 | RESI_COMMIT_NM | string | 舒沁苑 | czrkjwhmc |
| 街路巷代码 | CZRKJLX | string | 33********26 | czrkjlx |
| 居委会代码 | CZRKJWH | string | 330203028018000 | czrkjwh |
| 乡镇街道代码 | CZRKXZJD | string | 330203028 | czrkxzjd |
| 数据项更新时间 | CZRKSJXGXSJ | string | 20211028154247 | czrksjxgxsj |

---

<a name="51"></a>
## 51. 51

**表名**: `DW_ZJ_JS_GJJGRJCXX`

### 字段信息

| 中文字段名 | 标准化字段名 | 数据类型 | 样例数据 | 源表字段名 |
| --- | --- | --- | --- | --- |
| 个人缴存基数 | PER_PAY_BASIS | float(16,2) | 10500 | grjcjs |
| 个人缴存比例 | PER_PAY_RIO | float | 10 | grjcbl |
| 个人账户 | PER_ACCO | string | 236808606 | grzh |
| 个人账户余额（个人缴存余额） | PER_ACCO_BALANCE | float | 24724.95 | grjcye |
| 个人账户状态 | PER_ACCO_STAT | smallint | 3 | zrzhzt |
| 单位名称 | UNIT_NM | string | 宁波诺士敦机电有限公司 | dwmc |
| 姓名 | NM | string | 许新江 | xingming |
| 开户日期 | ACCO_DT | datetime | 2009-09-29 12:00:00 | grkhrq |
| 月缴存额 | MON_PAY_AMT | float | 1050 | gryjce |
| 统一社会信用代码 | UNI_SOCIAL_CRD_CD | string | 913302******960857 | tyshxydm |
| 职工账户销户日期 | GRXHRQ | datetime | 1899-12-31 12:00:00 | grxhrq |
| 证件类型 | CARD_TYPE | string | 1 | zjlx |
| 最近交易日期时间 | LAST_TRANS_DT | string | \N | zxjyrq |
| 证件号码 | IDENTI_ID | string | 330106************ | zjh |
| 机构号 | JGH |  | 13 | jgh |
| 销户日期 | ACCO_CAN_DT | datetime |  | grxhrq |

---

<a name="52"></a>
## 52. 52

**表名**: `DW_ZJ_JS_GJJGRDKXX`

### 字段信息

| 中文字段名 | 标准化字段名 | 数据类型 | 样例数据 | 源表字段名 |
| --- | --- | --- | --- | --- |
| 姓名 | NM | string | 林远龙 | xingming |
| 证件号码 | IDENTI_ID | string | 330921************ | zjh |
| 证件类型 | CARD_TYPE | string | 1 | zjlx |
| 贷款发放日期 | LOAD_GRANT_DT | datetime | 2013-01-09 12:00:00 | dkfkrq |
| 贷款期数 | LOAD_PERIODS | int | 180 | dkqs |
| 贷款结清日期 | LOAD_SETTLE_DT | datetime | 1899-12-31 12:00:00 | dkhqrq |
| 借款合同编号 | LOAD_CONTRACT_NUM | string | 2013政字第00025 | jkhtbh |
| 机构号 | JGH |  | 11 | jgh |
| 个人账号 | PER_ACCO | string | 82742714 | grzh |
| 逾期本金 | OVERDUE_PRINCIPLE | float | 0 | yqbj |
| 最新交易日期 | LAST_TRANS_DT | datetime | \N | zxjyrq |
| 累计逾期期数 | OVERDUE_PERIODS | int | 0 | ljyqqs |
| 逾期次数 | OVERDUE_TMS | int | 0 | yqcs |

---

<a name="53"></a>
## 53. 53

**表名**: `DW_NB_YB_CXJMJBYLBXCBDJ`

### 字段信息

| 中文字段名 | 标准化字段名 | 数据类型 | 样例数据 | 源表字段名 |
| --- | --- | --- | --- | --- |
| 社会保障号 | SOCI_CARE_ID | string | 330212************ | shbzh |
| 姓名 | NM | string | 金蕊 | xm |
| 年度参保类别 | YEAR_ISSU_TYPE | string | 06 | sblb |
| 申报时间 | DECLARE_DT | datetime | 20190926 | sbsj |
| 身份证号 | ID_NO | string | 330212************ | sfzh |
| 联系方式 | TEL | string | 13248712802 | lsfs |
| 参保状态 | ISSU_STATE | string | 1 | cbzt |

---

<a name="54"></a>
## 54. 54

**表名**: `DW_NB_YB_CXJMJBYLBXJFXX`

### 字段信息

| 中文字段名 | 标准化字段名 | 数据类型 | 样例数据 | 源表字段名 |
| --- | --- | --- | --- | --- |
| 人员缴费明细ID | PER_PAY_ID | string | 2017111210058021 | zmlsh |
| 个人编码 | PER_NO | string | 75036623 | ybh |
| 单位ID | UNIT_ID | string | 00003205 | dwdm |
| 社会保障号(身份证号) | SOCI_NO | string | 330203 | shbzh |
| 姓名 | NM | string | 孙捷 | xm |
| 单位名称 | UNIT_NM | string | 宁波市海曙区人民政府望春街道办事处 | dwmc |
| 年度参保类别 | YEAR_ISSU_TYPE | string | \N | sblb |
| 参保年度 | ISSU_YEAR | string | 2008 | sbnd |
| 缴费总金额 | PAY_AMT | string | 100 | yjje |
| 个人应缴金额 | PER_PAY_AMT | float | 50 | grje |
| 财政应缴金额 | FINA_PAY_AMT | float | 50 | mjje |
| 个人到账标志 | PER_ARRIVAL_FLAG | string | \N | grdzbz |
| 个人到账年月 | PER_ARRIVAL_YM | string | \N | dzny |
| 财政到账标志 | FINA_ARRIVAL_FLAG | string | \N | czdzbz |
| 财政到账年月 | FINA_ARRIVAL_YM | string | \N | czdzny |

---

<a name="55"></a>
## 55. 55

**表名**: `DW_NB_RLSB_GRYJJBYLBXHDXX`

### 字段信息

| 中文字段名 | 标准化字段名 | 数据类型 | 样例数据 | 源表字段名 |
| --- | --- | --- | --- | --- |
| 人员征缴明细ID | PER_COLLEC_DTAIL_ID | string | 3020002171620983 | AAZ223 |
| 个人编码 | PER_ID | string | 3020000011627698 | AAC001 |
| 单位编码 | CORP_ID | string | 3029000011429825 | AAB001 |
| 单位名称 | CORP_NM | string | 异地转入 | AAB004 |
| 社会保障号 | SOCI_SECU_NO | string | 370502************ | AAE135 |
| 姓名 | NM | string | 李广健 | AAC003 |
| 险种类型 | INSUR_TYPE | string | 11 | AAE140 |
| 费款所属期 | PAY_PERIOD | string | 201211 | AAE002 |
| 对应费款所属期 | CORRE_PERIOD | string | 201211 | AAE003 |
| 应缴类型 | PAY_TYPE | string | 0 | EAC302 |
| 缴费月数 | PAY_MONS | string | 1 | EAC003 |
| 人员缴费基数 | PER_PAY_BASE | float | 4496 | AAE180 |
| 缴费总金额 | PAY_AMT | float | 0 | AAE058 |
| 单位应缴金额 | CORP_PAY_AMT | float | 0 | AAE020 |
| 个人应缴金额 | PER_PAY_AMT | float | 0 | AAE022 |
| 其他来源一补贴金额 | OTHER_SUB_AMT | float | 0 | AAE024 |
| 其他来源一划账户金额 | OTHER_TRANS_ACC_AMT | float | 359.67 | AAE025 |
| 其他来源二应缴金额 | OTHER_SEC_PAYAMT | float | 0 | AAE026 |
| 其他来源三应缴金额 | OTHER_TRI_PAYAMT | float | 0 | AAE028 |
| 足额到账标志 | FULL_RECE_FLAG | string | 1 | AAE078 |
| 足额到账年月 | FULL_RECE_YM | string | 201601 | AAE079 |
| 账目状态 | ACCO_NATURE | string | 0 | EAC300 |
| 变更年月 | CHAN_YM | string | 201211 | EAZ298 |
| 低保标志 | MINILIVE_SIGN | string |  | EAZ247 |
| 分区字段(费款所属期年份) | PARTITION_PERIOD | string |  |  |

---

<a name="56"></a>
## 56. 56

**表名**: `DW_NB_SWBGXX`

**主键**: KEY

### 字段信息

| 中文字段名 | 标准化字段名 | 数据类型 | 样例数据 | 源表字段名 |
| --- | --- | --- | --- | --- |
| 主键 | KEY | string |  | UUID |
| 统一社会信用代码 | UNI_SOCIAL_CRD_CD | string |  | UNISCID |
| 变更项目 | CHAN_PROJECT | string |  | ALTITEM |
| 变更前内容 | CHAN_BEF_TEXT | string |  | ALTBE |
| 变更后内容 | CHAN_AFT_TEXT | string |  | ALTAF |
| 变更日期 | CHAN_DT | datetime |  | ALTDATE |
| 录入日期 | ENT_DT | datetime |  | LRRQ |
| 状态 | STATE | string |  | OP |

---

<a name="57"></a>
## 57. 57

**表名**: `DW_NB_HYWLQYXYDJXX`

### 字段信息

| 中文字段名 | 标准化字段名 | 数据类型 | 样例数据 | 源表字段名 | 来源 |
| --- | --- | --- | --- | --- | --- |
| 唯一标识 | ONLY_FLG | string |  | UNID | 市口岸办 |
| 企业名称 | COM_NM | string |  | MC | 市口岸办 |
| 统一社会信用代码 | UNI_SOCIAL_CRD_CD | string |  | SHXYDM | 市口岸办 |
| 组织机构代码 | ORG_NO | string |  | ZZJGDM | 市口岸办 |
| 营业执照注册号 | BIZ_LICN_REG_NO | string |  | ZCH | 市口岸办 |
| 信用评价名称 | CREDIT_CMNT_NM | string |  | XYPJMC | 市口岸办 |
| 评价结果 | CMNT_RESULT | string |  | PJJG | 市口岸办 |
| 评定日期 | ASSESS_DT | datetime |  | PDRQ | 市口岸办 |
| 评价机构 | CMNT_ORG | string |  | PJBM | 市口岸办 |
| 评价结果有效期始 | CMNT_RESULT_VLID_DT_BG | datetime |  | YXQS | 市口岸办 |
| 评价结果有效期止 | CMNT_RESULT_EXP_DT | datetime |  | YXQZ | 市口岸办 |
| 记录状态 | RECORD_STATE | int |  | JLZT | 市口岸办 |
| 入库日期 | INPUT_DT | datetime |  | RKRQ | 市口岸办 |
| 处理状态 | DEAL_STATE | int |  | CLZT | 市口岸办 |

---

<a name="58"></a>
## 58. 58

**表名**: `DW_SHL_GJZYJSZWRZZGZSXX`

### 字段信息

| 中文字段名 | 标准化字段名 | 数据类型 | 样例数据 | 源表字段名 |
| --- | --- | --- | --- | --- |
| 证书编号 | CERT_ID | string |  | ZSBH |
| 证件类别 | CERT_TYPE | string |  | ZJLB |
| 证件号码 | ID_NUM | string |  | ZJHM |
| 姓名 | NM | string |  | XM |
| 性别 | GENDER | string |  | XB |
| 工作单位 | WORKING_UNIT | string |  | GZDW |
| 单位性质 | UNIT_PROPR | string |  | DWXZ |
| 在职状态 | BOJOB_STATE | string |  | ZZZT |
| 最高学历 | HIGHEST_EDUC_BACK | string |  | ZGXL |
| 最高学位 | HIGHEST_DEGREE | string |  | ZGXW |
| 毕业学校 | GRADUTE_SCHOOL | string |  | BYXX |
| 所学专业 | HDSTU_MAJOR | string |  | SXZY |
| 专业名称 | MAJOR_NM | string |  | ZYMC |
| 资格名称 | QUAL_NM | string |  | ZGMC |
| 级别名称 | GRADE_NM | string |  | JBMC |
| 所属系列 | UNDR_SET | string |  | SSXL |
| 取得方式 | GAIN_WAY | string |  | QDFS |
| 取得资格时间 | GAIN_QUAL_TM | string |  | QDZGSJ |
| 发证时间 | CERTI_TM | string |  | FZSJ |
| 评委会名称 | JUDG_NM | string |  | PWHMC |
| 发证单位 | CERTI_UNIT | string |  | FZDW |
| 联系电话 | CONTCT_TEL | string |  | DH |
| 通信地址 | MAILING_ADDS | string |  | TXDZ |
| 邮政编码 | POST_ID | string |  | YB |
| 所在地市、省级主管部门 | UNDR_CITY | string |  | SZDS |
| 所在县（市、区）、市本级 | UNDR_COUNTY | string |  | SZXS |
| 录入单位 | ENT_UNIT | string |  | LRDW |
| 公布文号 | ANNOUNS_DOC_NO | string |  | WH |
| 备注 | REMARKS | string |  | BZ |
| 出生年月 | BORN_Y_M | string |  | CSNY |
| 证书查询 | CERT_QUERY | string |  | ZSCX |
| 在线验证码 | ONLIN_PROV_CD | string |  | ZXYZM |
| 照片路径 | PHOTO_PATH | string |  | ZPLJ |
| 状态 | STATE | string |  | STATUS |
| 签名值 | SIGN_VAL | string |  | SIGNVALUE |
| 签名公钥值 | SIGN_PKI_VAL | string |  | SIGNCERT |
| 时间戳签名值 | TIME_SIGN_VAL | string |  | TNSVALUE |
| 签名hash值 | SIGN_HASH_VAL | string |  | SIGNHASHCODE |
| 证照颁发机构代码 | LICN_ISSUE_ORG_CD | string |  | ISSUECODE |
| 持证主体代码类型 | CRD_MAIN_CD_TYPE | string |  | HOLDERTYPE |
| 行政区划代码 | AREA_NUMB | string |  | ARECODE |

---

<a name="59"></a>
## 59. 59

**表名**: `DW_SHL_GRWLXSXCPXX`

### 字段信息

| 中文字段名 | 标准化字段名 | 数据类型 | 样例数据 | 源表字段名 |
| --- | --- | --- | --- | --- |
| 姓名 | NM | string |  | XM |
| 身份证号 | IDENTI_NO | string |  | SFZH |
| 地址 | ADDS | string |  | DZ |
| 法定代表人 | LEGAL_REPRE | string |  | FDDBR |
| 案号 | CASE_NO | string |  | AH |
| 执行法院 | EXECUTE_COURT | string |  | ZXFY |
| 立案日期 | FILING_DT | datetime |  | LARQ |
| 执行依据 | EXECUTE_BASIS | string |  | ZXYJ |
| 执行案由 | EXECUTE_CAUSES | string |  | ZXAY |
| 执行金额 | EXECUTE_AMT | decimal |  | BDJE |
| 执行行为 | EXECUTE_BEHAVE | string |  | ZXXW |
| 执行物品 | EXECUTE_GOODS | string |  | ZXWP |
| 未执行金额 | NOT_EXECUTE_AMT | decimal |  | WLXJE |
| 未执行行为 | NOT_EXECUTE_BEHAVE | string |  | WZXXW |
| 未执行物品 | NOT_EXECUTE_GOODS | string |  | WLXWP |
| 举报电话 | TIP_TEL | string |  | JBDH |
| 举报联系人 | TIP_CONTCT_PRSON | string |  | JBLXR |
| 曝光日期 | EXPO_DT | datetime |  | PGRQ |
| 共同被执行人 | COMM_EXECUTED | string |  | GTBZXR |
| 法院代码 | COURT_CD | string |  | FYDM |
| 搜案编号 | STC_ID | string |  | SABH |
| 当事人编号 | PARTY_ID | string |  | DSRBH |

---

<a name="60"></a>
## 60. 60

**表名**: `DW_SHL_HJYXBGBSPYJXX`

### 字段信息

| 中文字段名 | 标准化字段名 | 数据类型 | 样例数据 | 源表字段名 |
| --- | --- | --- | --- | --- |
| 项目ID | PROJECT_ID | string |  | UNIQUEID |
| 环评审批时间 | EIA_APPR_TM | string |  | APPROVALDATE |
| 签名公钥证书 | SIGN_PKI_CERT | string |  | SIGNCERT |
| 时间戳 | TIME | string |  | TNSVALUE |
| 签名值 | SIGN_VAL | string |  | SIGNVALUE |
| 交换时间 | EXCHE_TM | datetime |  | EXCHANGETIME |
| 填表时间 | FORM_TM | datetime |  | FILLTABLEUNIT |
| 入库时间 | INPUT_TM | datetime |  | UPDATETIME |
| 受理时间 | ACCEPT_TM | datetime |  | ACCEPTANCEDATE |
| 环评批复文号 | EIA_GAO_DOC_NO | string |  | APPROVALCODE |
| 环评审批机关 | EIA_APPR_DEPT | string |  | APPROVALDEPT |
| 环保总投资 | ENVIR_PROT_TOL_INVES | string |  | ENVIRONLNVEST |
| 项目总投资 | PROJECT_TOL_INVES | string |  | PROJECTINVEST |
| 建设地点 | CONSTRU_PLACE | string |  | PROJECTADDRESS |
| 行业名称 | INDS_NM | string |  | CODE_TRADENAME |
| 行业类型 | INDS_TYPE | string |  | CODE_TRADE |
| 环评文件类别 | EIA_DOC_TYPE | string |  | CODE_ASSESSMENTFORM |
| 项目名称 | PROJECT_NM | string |  | PROJECTNAME |
| 签名hash值 | SIGN_HASH_VAL | string |  | SIGNHASHCODE |

---

<a name="61"></a>
## 61. 61

**表名**: `DW_SHL_QYWLXSXCPXX`

### 字段信息

| 中文字段名 | 标准化字段名 | 数据类型 | 样例数据 | 源表字段名 |
| --- | --- | --- | --- | --- |
| 企业名称 | COM_NM | string |  | QYMC |
| 统一社会信用代码 | UNI_SOCIAL_CRD_CD | string |  | TYSHXYDM |
| 组织机构代码 | ORG_NO | string |  | ZZJGDM |
| 法定代表人 | LEGAL_REPRE | string |  | FDDBR |
| 单位地址 | UNIT_ADDS | string |  | DWDZ |
| 执行法院 | EXECUTE_COURT | string |  | ZXFY |
| 案号 | CASE_NO | string |  | AH |
| 执行依据 | EXECUTE_BASIS | string |  | ZXYJ |
| 执行案由 | EXECUTE_CAUSES | string |  | ZXAY |
| 履行时间 | FULFIL_TM | datetime |  | LXSJ |
| 执行金额（元） | EXECUTE_AMT | decimal |  | YLXJE |
| 执行行为 | EXECUTE_BEHAVE | string |  | ZXXW |
| 执行物品 | EXECUTE_GOODS | string |  | ZXWP |
| 未执行金额（元） | NOT_EXECUTE_AMT | decimal |  | WLXJE |
| 未执行行为 | NOT_EXECUTE_BEHAVE | string |  | WLXXW |
| 未执行物品 | NOT_EXECUTE_GOODS | string |  | WLXWP |
| 共同被执行人 | COMM_EXECUTED | string |  | GTBZXR |
| 曝光日期 | EXPO_DT | datetime |  | PGRQ |
| 举报电话 | TIP_TEL | string |  | JBRDH |
| 举报联系人 | TIP_CONTCT_PRSON | string |  | JBLXR |
| 搜案编号 | STC_ID | string |  | SABH |
| 当事人编号 | PARTY_ID | string |  | DSRBH |
| 法院代码 | COURT_CD | string |  | FYDM |
| 立案日期 | FILING_DT | datetime |  | LARQ |

---

<a name="62"></a>
## 62. 62

**表名**: `DW_SHL_RSKSWJXX`

### 字段信息

| 中文字段名 | 标准化字段名 | 数据类型 | 样例数据 | 源表字段名 |
| --- | --- | --- | --- | --- |
| 处理意见 | DEAL_SUGG | string |  | CLYJ |
| 有效期始 | VLID_DT_BG | datetime |  | YXQS |
| 文号 | DOC_NO | string |  | WH |
| 准考证号 | ZKH | string |  | ZKZH |
| 考试名称 | EXAM_NM | string |  | KSMC |
| 决定时间 | DECISE_TM | datetime |  | JDSJ |
| 工作单位 | WORKING_UNIT | string |  | GZDW |
| 姓名 | NM | string |  | XM |
| 身份证号 | IDENTI_NO | string |  | SFZH |
| 违纪行为 | BREACH_BEHAVE | string |  | WJXW |
| 有效期至 | VLID_DT_TO | datetime |  | YXQZ |

---

<a name="63"></a>
## 63. 63

**表名**: `DW_SHL_TYSHXYDMXXGJXF`

### 字段信息

| 中文字段名 | 标准化字段名 | 数据类型 | 样例数据 | 源表字段名 |
| --- | --- | --- | --- | --- |
| 企业名称 | COM_NM | string |  | ENTNAME |
| 统一社会信用代码 | UNI_SOCIAL_CRD_CD | string |  | CREDCODE |
| 工商登记码 | IC_REG_CD | string |  | REGCODE |
| 组织机构代码 | ORG_NO | string |  | ORGCODE |
| 税务登记号 | TAXATION_REG_NO | string |  | TAXCODE |

---

<a name="64"></a>
## 64. 64

**表名**: `DW_SHL_SCJRXXGJXF`

### 字段信息

| 中文字段名 | 标准化字段名 | 数据类型 | 样例数据 | 源表字段名 |
| --- | --- | --- | --- | --- |
| 处罚处理名称 | PENALTY_DEAL_NM | string |  | CFCLMC |
| 处罚处理内容 | PENALTY_DEAL_TEXT | string |  | CFCLNR |
| 处罚处理日期 | PENALTY_DEAL_DT | string |  | CFCLRQ |
| 处罚处理种类 | PENALTY_DEAL_KIND | string |  | CFCLZL |
| 处罚对象类型 | PENALTY_OBJECT_TYPE | int |  | CFDXLX |
| 处罚对象名称 | PENALTY_OBJECT_NM | string |  | CFDXMC |
| 处罚ID | PENALTY_ID | datetime |  | CFID |
| 处罚决定书ID | PENALTY_DECISION_ID | string |  | CFJDSID |
| 处罚机关 | PENALTY_DEPT | string |  | CFJG |
| 加密证件号码 | ENCRY_ID_NUM | string |  | JMZJHM |
| 实际处罚部门 | REAL_PENALTY_DEPT | string |  | SJCFBM |
| 信息类型 | INFO_TYPE | string |  | XXLX |
| 有效截止日期 | VLID_DEADLINE | datetime |  | YXJZRQ |
| 证件类型 | CERT_TYPE | string |  | ZJLX |
| 真实证件号码 | REAL_ID_NUM | string |  | ZSZJHM |

---

<a name="65"></a>
## 65. 65

**表名**: `DW_SHL_SGSXZXK`

**主键**: PUNISH_BASE_INFO_CODE

### 字段信息

| 中文字段名 | 标准化字段名 | 数据类型 | 样例数据 | 源表字段名 | 来源 |
| --- | --- | --- | --- | --- | --- |
| 处罚基本信息主键ID | PUNISH_BASE_INFO_CODE | string |  | PUNISH_BASE_INFO_CODE | 市发改委 |
| 处罚案件编号 | PUNISH_CASE_CODE | string |  | PUNISH_CASE_CODE | 市发改委 |
| 案件程序类别 01 简易程序 02 一般程序 | CASE_PROCESS_TYPE | string |  | CASE_PROCESS_TYPE | 市发改委 |
| 处罚行为名称 | PUNISH_ACTION_NAME | string |  | PUNISH_ACTION_NAME | 市发改委 |
| 违法事实 | ILLEGAL_FACT | string |  | ILLEGAL_FACT | 市发改委 |
| 违法依据 | ILLEGAL_BASIS | string |  | ILLEGAL_BASIS | 市发改委 |
| 处罚决定种类 | PUNISH_TYPE | string |  | PUNISH_TYPE | 市发改委 |
| 处罚决定文书号 | PUNISH_DOCUMENT_CODE | string |  | PUNISH_DOCUMENT_CODE | 市发改委 |
| 行政相对人类型 | ADMIN_CP_TYPE | string |  | ADMIN_CP_TYPE | 市发改委 |
| 当事人名称 | ADMIN_CP_NAME | string |  | ADMIN_CP_NAME | 市发改委 |
| 当事人证件类型 | ADMIN_CP_CERT_TYPE | string |  | ADMIN_CP_CERT_TYPE | 市发改委 |
| 当事人证件号码 | UNI_SOCIAL_CRD_CD | string |  | ADMIN_CP_CERT_CODE | 市发改委 |
| 法定代表人证件类型 | LEGAL_REPRESENT_TYPE | string |  | LEGAL_REPRESENT_TYPE | 市发改委 |
| 法定代表人姓名 | LEGAL_REPRESENT | string |  | LEGAL_REPRESENT | 市发改委 |
| 法定代表人证件号码 | LEGAL_REPRESENT_IDCARD | string |  | LEGAL_REPRESENT_IDCARD | 市发改委 |
| 处罚内容 | PUNISH_CONTENT | string |  | PUNISH_CONTENT | 市发改委 |
| 处罚依据 | PUNISH_BASIS | string |  | PUNISH_BASIS | 市发改委 |
| 罚款金额 | FINE | float |  | FINE | 市发改委 |
| 没收违法所得金额 | CONFISCATE_ILLEGAL_INCOM | float |  | CONFISCATE_ILLEGAL_INCOM | 市发改委 |
| 没收非法财物金额 | CONFISCATE_ILLEGAL_ASSET | float |  | CONFISCATE_ILLEGAL_ASSET | 市发改委 |
| 决定日期 | SET_TIME | datetime |  | SET_TIME | 市发改委 |
| 公示日期 | PUBLIC_DATE | datetime |  | PUBLIC_DATE | 市发改委 |
| 公示截止日期 | PUBLIC_END_DATE | datetime |  | PUBLIC_END_DATE | 市发改委 |
| 公示状态 | PUBLICSTATUS | string |  | PUBLICSTATUS | 市发改委 |
| 撤销处罚的原因说明 | CUTREASON | string |  | CUTREASON | 市发改委 |
| 1:撤销立案 | ISCANCELCASE | string |  | ISCANCELCASE | 市发改委 |

---

<a name="66"></a>
## 66. 66

**表名**: `DW_SHL_SGSXZXK`

**主键**: XK_ID

### 字段信息

| 中文字段名 | 标准化字段名 | 数据类型 | 样例数据 | 源表字段名 |
| --- | --- | --- | --- | --- |
| 行政相对人名称 | XK_XDR_MC | string |  | XK_XDR_MC |
| 行政相对人代码_1(统一社会信用代码) | UNI_SOCIAL_CRD_CD | string |  | XK_XDR_SHXYM |
| 行政相对人代码_2 (工商注册号) | XK_XDR_GSZC | string |  | XK_XDR_GSZC |
| 法定代表人 | XK_FRDB | string |  | XK_FRDB |
| 法定代表人身份证号 | XK_FR_SFZH | string |  | XK_FR_SFZH |
| 证件类型 | XK_XDR_ZJLX | string |  | XK_XDR_ZJLX |
| 证件号码 | XK_XDR_ZJHM | string |  | XK_XDR_ZJHM |
| 行政许可决定文书名称 | XK_XKWS | string |  | XK_XKWS |
| 行政许可决定文书号 | XK_WSH | string |  | XK_WSH |
| 许可类别 | XK_XKLB | string |  | XK_XKLB |
| 许可证书名称 | XK_XKZS | string |  | XK_XKZS |
| 许可编号 | XK_XKBH | string |  | XK_XKBH |
| 许可内容 | XK_NR | string |  | XK_NR |
| 许可决定日期 | XK_JDRQ | datetime |  | XK_JDRQ |
| 有效期自 | XK_YXQZ | datetime |  | XK_YXQZ |
| 有效期至 | XK_YXQZI | datetime |  | XK_YXQZI |
| 许可机关 | XK_XKJG | string |  | XK_XKJG |
| 许可机关统一社会信用代码 | XK_XKJGDM | string |  | XK_XKJGDM |
| 当前状态 | XK_ZT | string |  | XK_ZT |
| 数据来源单位 | XK_LYDW | string |  | XK_LYDW |
| 数据来源单位统一社会信用代码 | XK_LYDWDM | string |  | XK_LYDWDM |
| 备注 | BZ | string |  | BZ |
| 主键 | XK_ID | string |  | XK_ID |

---

<a name="67"></a>
## 67. 67

**表名**: `DW_SHL_GJJGRDKXX`

### 字段信息

| 中文字段名 | 标准化字段名 | 数据类型 | 样例数据 | 源表字段名 |
| --- | --- | --- | --- | --- |
| 姓名 | NM | string | 林远龙 | xingming |
| 证件号码 | IDENTI_ID | string | 330921************ | zjh |
| 证件类型 | CARD_TYPE | string | 1 | zjlx |
| 贷款发放日期 | LOAD_GRANT_DT | datetime | 2013-01-09 12:00:00 | dkfkrq |
| 贷款期数 | LOAD_PERIODS | int | 180 | dkqs |
| 贷款结清日期 | LOAD_SETTLE_DT | datetime | 1899-12-31 12:00:00 | dkhqrq |
| 借款合同编号 | LOAD_CONTRACT_NUM | string | 2013政字第00025 | jkhtbh |
| 机构号 | JGH |  | 11 | jgh |
| 个人账号 | PER_ACCO | string | 82742714 | grzh |
| 逾期本金 | OVERDUE_PRINCIPLE | float | 0 | yqbj |
| 最新交易日期 | LAST_TRANS_DT | datetime | \N | zxjyrq |
| 累计逾期期数 | OVERDUE_PERIODS | int | 0 | ljyqqs |
| 逾期次数 | OVERDUE_TMS | int | 0 | yqcs |

---

<a name="68"></a>
## 68. 68

**表名**: `DW_NB_SHFWLYXFJXX`

**主键**: ZJID

### 字段信息

| 中文字段名 | 标准化字段名 | 数据类型 | 样例数据 | 源表字段名 |
| --- | --- | --- | --- | --- |
| 主键ID | ZJID | string |  | STOREID110 |
| 来电编号 | LDBH | string |  | XFJBH |
| 来电形式 | LDXS | string |  | XFXS |
| 工号 | GH | string |  | GH |
| 登记人姓名 | DJRXM | string |  | DJR |
| 登记单位 | DJDW | string |  | DJDW |
| 呼入时间 | HRSJ | string |  | DJSJ |
| 姓名 | XM | string |  | XM |
| 问题属地 | WTSD | string |  | WTSD |
| 常住地址 | CZDZ | string |  | CZDZ |
| 来电目的 | LDMD | string |  | XFMD |
| 内容分类 | NRFL | string |  | NRFL |
| 反映内容 | FYNR | string |  | FYNR |
| 联系电话 | LXDH | string |  | LXDH |
| 是否匿名 | SFLM | string |  | NMBZ |
| 紧急程度 | JJCD | string |  | JJCD |
| 来电号码 | LDHM | string |  | LDHM |
| 是否保密 | SFBM | string |  | ISSECRET |

---

<a name="69"></a>
## 69. 69

**表名**: `DW_SHL_SMDXFBLBDXX`

**主键**: ZJ

### 字段信息

| 中文字段名 | 标准化字段名 | 数据类型 | 样例数据 | 源表字段名 |
| --- | --- | --- | --- | --- |
| 主键 | ZJ | string |  | ID |
| 办理方式 | BLFS | string |  | BLFS |
| 办理机构 | BLJG | string |  | BLJG |
| 办理部门 | BLBM | string |  | BLBM |
| 办理人 | BLR | string |  | BLR |
| 办理时间 | BLSJ | string |  | BLSJ |
| 去向单位 | QXDW | string |  | QXDW |
| 去向人 | XQXMC | string |  | XQXMC |
| 办理说明 | BLSM | string |  | BLSM |
| 附件信息 | FJXX | string |  | FJXX |
| 是否延期 | SFYQ | string |  | SFYQ |
| 延期时间 | YQSJ | string |  | YQSJ |

---

<a name="70"></a>
## 70. 70

**表名**: `DW_SHL_SMDXFSLBDXX`

**主键**: ZJ

### 字段信息

| 中文字段名 | 标准化字段名 | 数据类型 | 样例数据 | 源表字段名 |
| --- | --- | --- | --- | --- |
| 主键 | ZJ | string |  | ID |
| 信访形式 | XFXS | string |  | XFXS |
| 信访日期 | XFRQ | string |  | XFRQ |
| 登记时间 | DJSJ | string |  | DJSJ |
| 涉及人数 | SJRS | string |  | SJRS |
| 登记部门 | DJBM | string |  | DJBM |
| 登记人姓名 | DJRXM | string |  | DJR |
| 信访人诉求 | XFRSQ | string |  | TSNR |
| 办理状态 | BLZT | string |  | BLZT |
| 内容分类 | NRFL | string |  | NRFLDM |
| 信访目的 | XFMD | string |  | XFMDDM |
| 信访原因 | XFYY | string |  | XFYYDM |
| 是否联名 | LMBZ | string |  | LMBZ |
| 是否匿名 | NMBZ | string |  | NMBZ |
| 是否公开 | GKBZ | string |  | GKBZ |
| 热点问题 | RDWT | string |  | RDWT |
| 是否扬言 | YYBZ | string |  | YYBZ |
| 受信人 | SXR | string |  | SXR |
| 附件 | FJ | string |  | FJXX |
| 信访问题属地 | XFWTSD | string |  | WTSDDM |
| 登记单位 | DJDM | string |  | DJJGDM |

---

<a name="71"></a>
## 71. 71

**表名**: `DW_SHL_XFRZDRYXX`

### 字段信息

| 中文字段名 | 标准化字段名 | 数据类型 | 样例数据 | 源表字段名 |
| --- | --- | --- | --- | --- |
| 信访重点人员id | XFZDRYID | string |  | XFRID |
| 重点人员标志 | ZDRYBZ | string |  | ZDRYBZ |
| 所属地市 | SSDS | string |  | dsc_city |
| 所属区县 | SSQX | string |  | dsc_adm_region |

---

<a name="72"></a>
## 72. 72

**表名**: `DW_SHL_XFJBLGKXX`

**主键**: ZJ

### 字段信息

| 中文字段名 | 标准化字段名 | 数据类型 | 样例数据 | 源表字段名 | 源表中文字段名 |
| --- | --- | --- | --- | --- | --- |
| 主键 | ZJ |  |  | ID | 主键 |
| 事项编号 | XFJBH |  |  | XFJBH | 事项编号 |
| 标题 | BT |  |  | BT | 标题 |
| 姓名 | XM |  |  | XM | 姓名 |
| 手机号 | SJH |  |  | SJH | 手机号 |
| 投诉内容 | TSNR |  |  | TSNR | 投诉内容 |
| 登记时间 | DJSJ |  |  | DJSJ | 登记时间 |
| 办理时间 | BLSJ |  |  | BLSJ | 办理时间 |
| 办理说明 | BLSM |  |  | BLSM | 办理说明 |
| 办理机构 | BLJG |  |  | BLJG | 办理机构 |
| 登记机构名称 | DJJGMC |  |  | DJJGMC | 登记机构名称 |
| 问题属地代码 | WTSDDM |  |  | WTSDDM | 问题属地代码 |
| 问题属地 | WTSD |  |  | WTSD | 问题属地 |
| 信访目的 | XFMD |  |  | XFMD | 信访目的 |
| 信访形式 | XFXS |  |  | XFXS | 信访形式 |
| 信访件状态 | XFJZT |  |  | XFJZT | 信访件状态 |
| 原件来源 | YJLY |  |  | YJLY | 原件来源 |
| 所属地市 | SSDS |  |  | DSC_CITY | 所属地市 |
| 所属区/县 | SSQX |  |  | DSC_ADM_REGION | 所需区/县 |

---

<a name="73"></a>
## 73. 73

**表名**: `DW_SHL_XFJXFSXXX`

### 字段信息

| 中文字段名 | 标准化字段名 | 数据类型 | 样例数据 | 源表字段名 | 源表中文字段名 |
| --- | --- | --- | --- | --- | --- |
| 事项ID | SXID |  |  | ID | 事项ID |
| 事项编号 | SXBH |  |  | XFJBH | 事项编号 |
| 事项类型 | SXLX |  |  | SXLX | 事项类型 |
| 事项办理状态 | SXBLZT |  |  | SXBLZT | 事项办理状态 |
| 数据来源 | SJLY |  |  | SJLY | 数据来源 |
| 事项办结类型 | SXBJLX |  |  | SXBJLX | 事项办结类型 |
| 原件来源 | YJLY |  |  | YJLY | 原件来源 |
| 初重件类型 | CCJLX |  |  | CCJLX | 初重件类型 |
| 关联件编号 | GLJBH |  |  | REPEATED_ID | 关联件编号 |
| 信访来源 | XFLYDM |  |  | XFLYDM | 信访来源 |
| 信访形式代码 | XFXSDM |  |  | XFXSDM | 信访形式代码 |
| 信访目的代码 | XFMDDM |  |  | XFMDDM | 信访目的代码 |
| 信访原因代码 | XFYYDM |  |  | XFYYDM | 信访原因代码 |
| 信访状态 | XFJZT |  |  | XFJZT | 信访状态 |
| 信访人数 | XFRS |  |  | XFRS | 信访人数 |
| 涉及人数 | SJRS |  |  | SJRS | 涉及人数 |
| 信访日期 | XFRQ |  |  | XFRQ | 信访日期 |
| 限办截止时间 | XBJZSJ |  |  | XBJZSJ | 限办截止时间 |
| 流转截止时间 | LZJZSJ |  |  | LZJZSJ | 流转截止时间 |
| 办理程序 | BLCX |  |  | BLCX | 办理程序 |
| 问题属地代码 | WTSDDM |  |  | WTSDDM | 问题属地代码 |
| 内容分类 | NRFL |  |  | NRFL | 内容分类 |
| 内容分类代码 | NRFLDM |  |  | NRFLDM | 内容分类代码 |
| 登记机构级别 | DJJGJB |  |  | DJJGJB | 登记机构级别 |
| 登记机构代码 | DJJGDM |  |  | DJJGDM | 登记机构代码 |
| 登记机构名称 | DJJGMC |  |  | DJJGMC | 登记机构名称 |
| 登记机构类别 | DJJGLB |  |  | DJJGLB | 登记机构类别 |
| 流转标记 | LZBJ |  |  | LZBJ | 流转标记 |
| 查询码状态 | CXMZT |  |  | CXMZT | 查询码状态 |
| 查询码 | CXM |  |  | CXM | 查询码 |
| 事项标题 | BT |  |  | BT | 事项标题 |
| 投诉内容 | TSNR |  |  | TSNR | 投诉内容 |
| 概况 | GKXX |  |  | GKXX | 概况 |
| 热点问题 | RDWT |  |  | RDWT | 热点问题 |
| 是否扬言 | YYBZ |  |  | YYBZ | 是否扬言 |
| 扬言内容 | YYNR |  |  | YYNR | 扬言内容 |
| 扬言人 | YYR |  |  | YYR | 扬言人 |
| 是否保密 | ISBM |  |  | ISBM | 是否保密 |
| 是否公开 | GKBZ |  |  | GKBZ | 是否公开 |
| 是否匿名 | NMBZ |  |  | NMBZ | 是否匿名 |
| 是否涉企 | ISSQ |  |  | ISSQ | 是否涉企 |
| 是否联名 | LMBZ |  |  | LMBZ | 是否联名 |
| 涉企机构名称 | SQJGMC |  |  | SQJGMC | 涉企机构名称 |
| 是否交通 | ISJT |  |  | ISJT | 是否交通 |
| 重大紧急标志 | ZDJJBZ |  |  | ZDJJBZ | 重大紧急标志 |
| 交通车牌号码 | JTCPHM |  |  | JTCPHM | 交通车牌号码 |
| 是否民生诉求 | ISMSSQ |  |  | ISMSSQ | 是否民生诉求 |
| 民生诉求 | MSSQDM |  |  | MSSQDM | 民生诉求 |
| 积案标志 | JABZ |  |  | JABZ | 积案标志 |
| 办结标志 | BJBZ |  |  | BJBZ | 办结标志 |
| 办结时间 | BJSJ |  |  | BJSJ | 办结时间 |
| 实际来访人数 | SJLFRS |  |  | SJLFRS | 实际来访人数 |
| 受信人 | SXR |  |  | SXR | 受信人 |
| 邮戳日期 | YCRQ |  |  | YCRQ | 邮戳日期 |
| 附件数量 | FJSL |  |  | FJSL | 附件数量 |
| 涉法涉诉标志 | SFSSBZ |  |  | SFSSBZ | 涉法涉诉标志 |
| 标签 | BQ |  |  | BQ | 标签 |
| 姓名 | XM |  |  | XM | 姓名 |
| 联系号码 | SJH |  |  | SJH | 联系号码 |
| 事项内容 | SXNR |  |  | SXNR | 事项内容 |
| 问题属地 | WTSD |  |  | WTSD | 问题属地 |
| 问题属地地址 | WTSDDZ |  |  | WTSD_ADDR | 问题属地地址 |
| 来访人数 | LFRS |  |  | LFRS | 来访人数 |
| 是否纳入诚信管理企业 | SFNRCXGLQY |  |  | IS_INTEGRITY_MANAGE | 是否纳入诚信管理企业 |
| 投诉对象类型 | TSDXLX |  |  | COMP_OBJ_TYPE | 投诉对象类型 |
| 投诉对象 | TSDX |  |  | COMP_OBJ | 投诉对象 |
| 是否生成答复意见书标记 | SFSCDFYJSBJ |  |  | SCDFYJFBJ | 是否生成答复意见书标记 |
| 抽查标志 | CCBZ |  |  | CCBZ | 抽查标志 |
| 回访标志 | HFBZ |  |  | HFBZ | 回访标志 |
| 行业内容分类 | HYNRFL |  |  | HYNRFL | 行业内容分类 |
| 限期答复 | XQDF |  |  | XQDF | 限期答复 |
| 事项件办结人 | SXJBJR |  |  | SXJBJR | 事项件办结人 |
| 直接回复内容 | ZJHFNR |  |  | DIRECT_REPLY_CONTENT | 直接回复内容 |
| 初次信访日期 | CCXFRQ |  |  | CCXFRQ | 初次信访日期 |
| 事项标识 | SXBS |  |  | PETITION_IDENTIFICATION | 事项标识 |
| 事项标志 | SXBZ |  |  | PETITION_FLAG | 事项标志 |
| 初重件类型名称 | CCJLXMC |  |  | CCJLXMC | 初重件类型名称 |
| 信访来源代码名称 | XFLYDMMC |  |  | XFLYDMMC | 信访来源代码名称 |
| 信访形式名称 | XFXSMC |  |  | XFXSMC | 信访形式名称 |
| 信访目的名称 | XFMDMC |  |  | XFMDMC | 信访目的名称 |
| 扬言标志名称 | YYBZMC |  |  | YYBZMC | 扬言标志名称 |
| 是否匿名名称1 | ISBMMC |  |  | ISBMMC | 是否匿名名称1 |
| 是否公开名称 | GKBZMC |  |  | GKBZMC | 是否公开名称 |
| 是否匿名名称2 | NMBZMC |  |  | NMBZMC | 是否匿名名称2 |
| 是否涉企名称 | ISSQMC |  |  | ISSQMC | 是否涉企名称 |
| 联名标志名称 | LMBZMC |  |  | LMBZMC | 联名标志名称 |
| 重大紧急标志名称 | ZDJJBZMC |  |  | ZDJJBZMC | 重大紧急标志名称 |
| 积案标志名称 | JABZMC |  |  | JABZMC | 积案标志名称 |
| 办结标志名称 | BJBZMC |  |  | BJBZMC | 办结标志名称 |
| 信访件状态名称 | XFJZTMC |  |  | XFJZTMC | 信访件状态名称 |
| 事项类型名称 | SXLXMC |  |  | SXLXMC | 事项类型名称 |
| 事项办理状态名称 | SXBLZTMC |  |  | SXBLZTMC | 事项办理状态名称 |
| 事项办结类型名称 | SXBJLXMC |  |  | SXBJLXMC | 事项办结类型名称 |
| 原件来源名称 | YJLYMC |  |  | YJLYMC | 原件来源名称 |
| 信访原因名称 | XFYYMC |  |  | XFYYMC | 信访原因名称 |
| 办理程序名称 | BLCXMC |  |  | BLCXMC | 办理程序名称 |
| 办理程序名称 | DJJGJBMC |  |  | DJJGJBMC | 登记机构级别名称 |
| 登记机构类别名称 | DJJGLBMC |  |  | DJJGLBMC | 登记机构类别名称 |
| 查询码状态名称 | CXMZTMC |  |  | CXMZTMC | 查询码状态名称 |
| 投诉对象类型名称 | TSDXLXMC |  |  | COMP_OBJ_TYPEMC | 投诉对象类型名称 |
| 数据来源名称 | SJLYMC |  |  | SJLYMC | 数据来源名称 |
| 所属地市 | SSDS |  |  | DSC_CITY | 所属地市 |
| 所属区/县 | SSQX |  |  | DSC_ADM_REGION | 所需区/县 |

---

<a name="74"></a>
## 74. 74

**表名**: `DW_SHL_XFJXFSXBLJLXX`

**注意**: 未找到字段信息或字段信息格式不标准

---

<a name="75"></a>
## 75. 75

**表名**: `DW_NB_SW_NSXX`

### 字段信息

| 中文字段名 | 标准化字段名 | 数据类型 | 样例数据 | 源表字段名 | 来源 |
| --- | --- | --- | --- | --- | --- |
| 免税销售收入额 | MSXSSR | float | \N | msxssr | 市税务局 |
| 单位经营地址 | UNIT_OPT_LOC | string | 慈溪市白沙路街道八字桥村 | scjydz | 市税务局 |
| 文化事业建设费 | WHSYJSF | float | 0 | whsyjsf | 市税务局 |
| 税额总额 | TAX_AMT | float | 921.26 | se | 市税务局 |
| 销售收入 | SALE_INCO | float | 310152.7 | xssr | 市税务局 |
| 企业名称 | COMP_NM | string | 慈溪市浒欣谊渔具配件厂 | nsrmc | 市税务局 |
| 税务登记证号 | TAX_REG_NO | string | 91330282L07196379D | nsrsbh | 市税务局 |
| 组织机构代码 | ORG_NO | string | L07196379 | zzjg_dm | 市税务局 |
| 统一社会信用代码 | UNI_SOCIAL_CRD_CD | string | 91330282L07196379D | shxydm | 市税务局 |
| 统计时间 | COUNT_DT | string | 20190930 | sssq | 市税务局 |

---

<a name="76"></a>
## 76. 76

**表名**: `DW_NB_SW_XYPJXXA`

### 字段信息

| 中文字段名 | 标准化字段名 | 数据类型 | 样例数据 | 源表字段名 | 来源 |
| --- | --- | --- | --- | --- | --- |
| 信用分 | CREDI_SCARD | smallint | 90 | zddf | 市税务局 |
| 统一社会信用代码 | UNI_SOCIAL_CRD_CD | string | 91330203674737244W | tyshxydm | 市税务局 |
| 交易流水号 | SJID |  | B79F3CB4CB7F8C6CE0535B4C1B50786A | sjid | 市税务局 |
| 所属年度 | BE_YEAR | string | 2019 | ssnd | 市税务局 |
| 法定代表人 | LEGAL_REPRE | string | 乐骏定 | xm_fr | 市税务局 |
| 生产经营地址 | OPT_LOC | string | 开发区商品经营基地 | scjydz | 市税务局 |
| 纳税人识别号 | TAX_NO | string | 91330203674737244W | nsrsbh | 市税务局 |
| 组织机构代码 | ORG_NO | string | 144137903 | zzjgdm | 市税务局 |
| 评价机构 | EVAL_ORG | string | 国家税务总局宁波市北仑区税务局小港税务所 | ksswjgmc | 市税务局 |
| 纳税人名称 | TAXER_NM | string | 宁波经济技术开发区双和高科技有限公司 | nsrmc | 市税务局 |
| 纳税信用等级 | TAX_CREDI_LEVEL | string | A | zz_jb | 市税务局 |
| 纳税信用等级评定年度 | EVAL_YEAR | string | 2019 | pd_nd | 市税务局 |
| 纳税信用等级评定日期 | EVAL_DT | datetime | 2020-03-17 00:00:00 | scsj | 市税务局 |
| 主管税务机关 | MAJOR_TAX_ORG | string | 国家税务总局宁波市北仑区税务局小港税务所 | swjgmc | 市税务局 |

---

<a name="77"></a>
## 77. 77

**表名**: `DW_NB_RLSB_QYSBCBRSXX`

### 字段信息

| 中文字段名 | 标准化字段名 | 数据类型 | 样例数据 | 源表字段名 | 来源 |
| --- | --- | --- | --- | --- | --- |
| 统一社会信用代码 | UNI_SOCIAL_CRD_CD | string | 911101******92690J | tyshxydm | 市人社局 |
| 单位ID | CORP_ID | string |  | AAZ001 | 市人社局 |
| 应收年月 | RECE_YM | string | 201811 | ysny | 市人社局 |
| 单位名称 | CORP_NM | string | 宁波华力鑫业投资管理有限公司 | dwmc | 市人社局 |
| 月参保总人数 | MON_INSURD_PRSONS | int | 1 | ycbzrs | 市人社局 |
| 单位性质 | CORP_NATURE | string | 企业 | dwxz | 市人社局 |
| 行业分类 | INDV_CLASS | string | 资本市场服务 | hyfl | 市人社局 |
| 经济性质 | ECON_NATURE | string | 其他有限责任(公司) | jjxz | 市人社局 |
| 单位所处街道 | CORP_LOCAL_STREET | string | 梅山街道 | dwscjd | 市人社局 |
| 行政区 | ADMIN_REGION | string | 北仑区 | xzq | 市人社局 |

---

<a name="78"></a>
## 78. 78

**表名**: `DW_NB_RLSB_SBJYLYSHBXJBXX`

### 字段信息

| 中文字段名 | 标准化字段名 | 数据类型 | 样例数据 | 源表字段名 | 来源 |
| --- | --- | --- | --- | --- | --- |
| 单位名称 | COMP_NM | string | 宁波花岗石板材有限公司 | MC | 市人力社保局 |
| 统一社会信用代码 | UNI_SOCIAL_CRD_CD | string | 9133021272513935X8 | SHXYDM | 市人力社保局 |
| 组织机构代码 | ORG_CD | string | 72513935X | ZZJGDM | 市人力社保局 |
| 营业执照注册号 | OPT_REG_NO | string | 330200400065251 | ZCH | 市人力社保局 |
| 单位编码 | UNIT_CD | string | 10006697 | DWBM | 市人力社保局 |
| 投保起始日期 | ISSUE_START_DT | datetime | 200109 | QSRQ | 市人力社保局 |
| 养老保险人数 | PENS_NUM | int | 68 | YLBXRS | 市人力社保局 |
| 医疗保险人数 | MEDIC_NUM | int | 68 | YILBXRS | 市人力社保局 |
| 失业保险人数 | UNEMPLOY_NUM | int | 68 | SHIYBXRS | 市人力社保局 |
| 工伤保险人数 | INJURY_NUM | int | 68 | SYBXRS | 市人力社保局 |
| 生育保险人数 | MATERNI_NUM | int | 68 | GSBXRS | 市人力社保局 |
| 养老保险缴费年月 | PENS_PAY_YM | datetime | 202008 | YLBXJFRQ | 市人力社保局 |
| 医疗保险缴费年月 | MEDIC_PAY_YM | datetime | 202008 | YILBXJFRQ | 市人力社保局 |
| 失业保险缴费年月 | UNEMPLOY_PAY_YM | datetime | 202008 | SHIYBXJFRQ | 市人力社保局 |
| 工伤保险缴费年月 | INJURY_PAY_YM | datetime | 202008 | GSBXJFRQ | 市人力社保局 |
| 生育保险缴费年月 | MATERNI_PAY_YM | datetime | 202008 | SYBXJFRQ | 市人力社保局 |
| 当前状态 | STAT | string | 1 | DQZT | 市人力社保局 |

---

<a name="79"></a>
## 79. 79

**表名**: `DW_NB_RLSB_GTLDZCBDJXX`

### 字段信息

| 中文字段名 | 标准化字段名 | 数据类型 | 样例数据 | 源表字段名 | 来源 |
| --- | --- | --- | --- | --- | --- |
| 人员参保关系ID | PER_ISSU_RELA | string | 3020001405340693 | AAZ159 | 市人力社保局 |
| 社会保障号 | SOCI_SECU_NO | string | 330224************ | AAE135 | 市人力社保局 |
| 姓名 | NM | string | 沈水珠 | AAC003 | 市人力社保局 |
| 个人编码 | PER_CD | string | 3200000012529000 | AAC001 | 市人力社保局 |
| 人员参保状态 | ISSU_STAT | string | 1 | AAC008 | 市人力社保局 |
| 开始年月 | START_YM | datetime | 201305 | AAE030 | 市人力社保局 |
| 终止年月 | END_YM | datetime | 201901 | AAE031 | 市人力社保局 |
| 首次参保年月 | FIRST_ISSU_YM | datetime | 201305 | AAC049 | 市人力社保局 |
| 险种类型 | ISSU_TPE | string | 11 | AAE140 | 市人力社保局 |
| 人员类型 | PER_TYPE | string | 1 | EAC070 | 市人力社保局 |
| 当前有效标志 | CUR_VALID_FLAG | string | 1 | AAE100 | 市人力社保局 |
| 账户建立年月 | ACCO_ESTAB_YM | datetime | 201305 | AAE206 | 市人力社保局 |

---

<a name="80"></a>
## 80. 80

**表名**: `DW_NB_RLSB_CBGRYJSYBXFHDXX`

### 字段信息

| 中文字段名 | 标准化字段名 | 数据类型 | 样例数据 | 源表字段名 | 来源 | 备注 |
| --- | --- | --- | --- | --- | --- | --- |
| 人员缴费基数 | PER_PAY_BASIS | float | 2878 | AAE180 | 市人力社保局 |  |
| 缴费总金额 | PAY_AMT | float | 28.8 | AAE058 | 市人力社保局 |  |
| 单位应缴金额 | UNIT_PAY_AMT | float | 28.8 | AAE020 | 市人力社保局 |  |
| 个人应缴金额 | PER_PAY_AMT | float | 0 | AAE022 | 市人力社保局 |  |
| 单位划入金额 | UNIT_INCLU_AMT | float | 0 | AAE021 | 市人力社保局 |  |
| 个人划入金额 | PER_INCLU_AMT | float | 0 | AAE023 | 市人力社保局 |  |
| 足额到账标志 | FULL_RECE_FLAG | string | 1 | AAE078 | 市人力社保局 |  |
| 足额到账年月 | FULL_RECE_YM | string | 201612 | AAE079 | 市人力社保局 | yyyymm |
| 账目状态 | BILL_STAT | string | 0 | EAC300 | 市人力社保局 |  |
| 变更年月 | CHAN_YM | string | 201612 | EAZ298 | 市人力社保局 | yyyymm |
| 低保标志 | SUB_ALLOW_FLAG | string | 0 | EAZ247 | 市人力社保局 |  |
| 人员征缴明细ID | PER_LEVY_DETAIL | string | 3020002341463910 | AAZ223 | 市人力社保局 |  |
| 个人编码 | PER_CD | string | 3020000009723014 | AAC001 | 市人力社保局 |  |
| 单位编码 | UNIT_CD | string | 302000009647333 | AAB001 | 市人力社保局 |  |
| 单位名称 | UNIT_NM | string | 浙江千佳广告有限公司 | AAB004 | 市人力社保局 |  |
| 社会保障号 | SOCI_SECU_NO | string | 330329************ | AAE135 | 市人力社保局 | 身份证号 |
| 姓名 | NM | string | 曹成标 | AAC003 | 市人力社保局 |  |
| 险种类型 | ISSU_TYPE | string | 21 | AAE140 | 市人力社保局 |  |
| 费款所属期 | FEE_PERIOD | string | 201612 | AAE002 | 市人力社保局 | yyyymm |
| 对应费款所属期 | COR_FEE_PERIOD | string | 201612 | AAE003 | 市人力社保局 | yyyymm |
| 应缴类型 | PAY_TYPE | string | 0 | EAC302 | 市人力社保局 |  |
| 缴费月数 | PAY_MONTHS | int | 1 | EAC003 | 市人力社保局 |  |
| 分区字段(费款所属期年份) | PARTITION_PERIOD | string |  |  |  |  |

---

<a name="81"></a>
## 81. 81

**表名**: `DW_NB_RLSB_SBJYLYRYCBXX`

### 字段信息

| 中文字段名 | 标准化字段名 | 数据类型 | 样例数据 | 源表字段名 | 来源 |
| --- | --- | --- | --- | --- | --- |
| 参保状态 | ISSUE_STAT | string | 1(aac008??) | CBZT | 市人力社保局 |
| 流水号 | SERIAL_NUM | string | 3020000107199890 | AAZ223 | 市人力社保局 |
| 对应费款所属期 | CORRE_FEE_PERIOD | string | 201406 | AAE003 | 市人力社保局 |
| 单位名称 | COMP_NM | string | 宁波群志光电邮箱公司 | AAB004 | 市人力社保局 |
| 税务登记证号码 | TAX_REG_NO | string | 330227************ | EAB229 | 市人力社保局 |
| 证件号码 | CERT_NO | string | 330227************ | AAE135 | 市人力社保局 |
| 姓名 | NM | string | 李培元 | AAC003 | 市人力社保局 |
| 险种 | ISSUE_TYPE | string | 41 | AAE140 | 市人力社保局 |
| 单位编号 | UNIT_ID | string | 3029000005105970 | AAB001 | 市人力社保局 |
| 行政区划 | ADMIN_AREA | string | 330212 | AAB301 | 市人力社保局 |

---

<a name="82"></a>
## 82. 82

**表名**: `DW_SHL_AJNSRXX`

**注意**: 未找到字段信息或字段信息格式不标准

---

<a name="83"></a>
## 83. 83

**表名**: `DW_SHL_QYZXDJXX`

**注意**: 未找到字段信息或字段信息格式不标准

---

<a name="84"></a>
## 84. 84

**表名**: `DW_SHL_XZCFXXGJXF`

**注意**: 未找到字段信息或字段信息格式不标准

---

<a name="85"></a>
## 85. 86

**表名**: `DW_NB_ZG_JRLYXDMXBDCQZ`

**主键**: NO_ID

### 字段信息

| 中文字段名 | 标准化字段名 | 数据类型 | 样例数据 | 源表字段名 |
| --- | --- | --- | --- | --- |
| 登记机构 | djjg |  |  | djjg |
| 编号 | zsgbh |  |  | zsgbh |
| 不动产权证号 | bdcqzh |  |  | bdcqzh |
| 权利人 | qlr |  |  | qlr |
| 权利人身份证件号码 | zjh |  |  | zjh |
| 共有情况 | gyqk |  |  | gyqk |
| 坐落 | zl |  |  | zl |
| 不动产单元号 | bdcdyh |  |  | bdcdyh |
| 权利类型 | qllx |  |  | qllx |
| 权利性质 | qlxz |  |  | qlxz |
| 用途 | yt |  |  | yt |
| 面积 | mj |  |  | mj |
| 使用期限 | syqx |  |  | syqx |
| 权利其他状况 | qlqtzk |  |  | qlqtzk |
| 状态 | op |  |  | op |
| 记录时间 | tong_time |  |  | tong_time |
| tongid | tongid |  |  | tongid |
| 发送时间 | sendtime |  |  | sendtime |
| 登薄时间 | szsj |  |  | szsj |
| 附记 | fj |  |  | fj |
| 表名（中文） | 宁波市不动产权证 |  |  |  |
| 表名（数据库） | DW_NB_ZG_JRLYXDMXBDCQZ |  |  |  |
| 不动产权证号 | bdcqzh |  |  | bdcqzh |
| 权利人 | qlr |  |  | qlr |
| 权利人身份证件号码 | qlrzjh |  |  | qlrzjh |
| 证书工本号 | zsgbh |  |  | zsgbh |
| 登记机构 | djjg |  |  | djjg |
| 共有情况 | gyqk |  |  | gyqk |
| 坐落 | zl |  |  | zl |
| 不动产单元号 | bdcdyh |  |  | bdcdyh |
| 权利类型 | qllx |  |  | qllx |
| 权利性质 | qlxz |  |  | qlxz |
| 用途 | yt |  |  | yt |
| 面积 | mj |  |  | mj |
| 使用期限 | syqx |  |  | syqx |
| 权力其他状况 | qlqtzk |  |  | qlqtzk |
| 附记 | fj |  |  | fj |
| 登记时间 | djsj |  |  | djsj |
| 更新时间 | update_time |  |  |  |
| 标准表主键 | NO_ID |  |  |  |

---

<a name="86"></a>
## 86. 87

**表名**: `v_ods_zj_dlgs_dsc_nb_biz_224_zrr_s_power_violate_steal_new_df`

### 字段信息

| 中文字段名 | 标准化字段名 | 数据类型 | 样例数据 | 源表字段名 |
| --- | --- | --- | --- | --- |
| 表名（中文） | 省回流_电力自然人窃电信息 |  |  |  |
| 表名（数据库） | v_ods_zj_dlgs_dsc_nb_biz_224_zrr_s_power_violate_steal_new_df |  |  |  |
| 户名 | cons_name | string |  | cons_name |
| 不良信息名称 | blxxmc | string |  | blxxmc |
| 统计年月 | state_ym | string |  | state_ym |
| 用电地址 | elec_addr | string |  | elec_addr |
| 窃电金额 | add_amt | string |  | add_amt |
| 户号 | cons_no | string |  | cons_no |
| 窃电时段 | occur_time | string |  | occur_time |
| 窃电量 | add_pq | string |  | add_pq |
| 身份证号 | cert_no | string |  | cert_no |
| 地区代码 | dqdm | string |  | dqdm |

---

<a name="87"></a>
## 87. 88

**表名**: `v_stg_nb_csglj_nbsxyfwlyfrrqxx_sbz`

### 字段信息

| 中文字段名 | 标准化字段名 | 数据类型 | 样例数据 | 源表字段名 |
| --- | --- | --- | --- | --- |
| 表名（中文） | 宁波市用气用户基本信息（法人） |  |  |  |
| 表名（数据库） | v_stg_nb_csglj_nbsxyfwlyfrrqxx_sbz |  |  |  |

---

<a name="88"></a>
## 88. 89

**表名**: `v_stg_nb_jyj_nbsslswlyfrysxx`

### 字段信息

| 中文字段名 | 标准化字段名 | 数据类型 | 样例数据 | 源表字段名 |
| --- | --- | --- | --- | --- |
| 表名（中文） | 宁波市用水用户基本信息（法人） |  |  |  |
| 表名（数据库） | v_stg_nb_jyj_nbsslswlyfrysxx |  |  |  |

---

<a name="89"></a>
## 89. 93

**表名**: `DW_SHL_QYHJXWXYPJXX`

**主键**: KEY

### 字段信息

| 中文字段名 | 标准化字段名 | 数据类型 | 样例数据 | 源表字段名 | 来源 |
| --- | --- | --- | --- | --- | --- |
| 地区名称 | REGN_NM | string |  | AREANAME | 市生态环境局 |
| 主体名称 | MAIN_NM | string |  | QYMC | 市生态环境局 |
| 统一社会信用代码 | UNI_SOCIAL_CRD_CD | string |  | TYSHXYDM | 市生态环境局 |
| 评价等级 | CMNT_LVEL | string |  | PJDJ | 市生态环境局 |
| 发布时间 | PUB_TM | string |  | PJSJ | 市生态环境局 |
| 主键 | KEY | string |  | UNIQUEID | 市生态环境局 |
| 评价批次 | CMNT_BATCH | string |  | PJPC | 市生态环境局 |
| 评价机构 | CMNT_ORG | string |  | PJDW | 市生态环境局 |
| 评价机构统一社会信用代码 | CMNT_ORG_UNI_SOCIAL_CRD_CD | string |  | PJDWTYDM | 市生态环境局 |
| 评价名称 | CMNT_NM | string |  | PJMC | 市生态环境局 |
| 有效期限 | VALID_DT | datetime |  | YXQX | 市生态环境局 |
| 评价分值 | CMNT_SCORE | int |  | PJFZ | 市生态环境局 |

---

<a name="90"></a>
## 90. 94

**表名**: `DYBM`

**主键**: DFGZID

### 字段信息

| 中文字段名 | 标准化字段名 | 数据类型 | 样例数据 | 源表字段名 | 来源 |
| --- | --- | --- | --- | --- | --- |
| 主键 | ZJ | string |  | STOREID | 宁波市信访局 |
| 操作时间 | CZSJ | TIMESTAMP |  | OPPTIME | 宁波市信访局 |
| 信访件ID | XFJID | string |  | RELATEDDOCSTOREID | 宁波市信访局 |
| 直接回复表主键ID | ZJHFID | string |  | ZJHFID | 宁波市信访局 |
| 补充答复内容 | BCDFNR | string |  | BCDFNR | 宁波市信访局 |
| 标记 | BJ | string |  | ISOLD | 宁波市信访局 |
| 补充答复附件名 | BCDFFJM | string |  | BCDFFJ | 宁波市信访局 |
| 补充答复人 | BCDFR | string |  | BCDFR | 宁波市信访局 |
| 对应表名 | DYBM | string |  | RELATEDDOCTYPEID | 宁波市信访局 |
| 补充答复人ID | BCDFRID | string |  | BCDFRID | 宁波市信访局 |
| 补充答复单位 | BCDFDW | string |  | BCDFDW | 宁波市信访局 |
| 补充答复单位ID | BCDFDWID | string |  | BCDFDWID | 宁波市信访局 |
| 补充答复单位代码 | BCDFDWDM | string |  | BCDFDWDM | 宁波市信访局 |
| 排序号 | PXH | int |  | ORDERNUM | 宁波市信访局 |
| 告知复查复核权力 | GZFCFHQL | int |  | GZFCFHQL | 宁波市信访局 |
| 答复意见书编号 | DFYJSBH | string |  | DFYJSBH | 宁波市信访局 |
| 答复告知回复记录主键 | DFGZID | string |  | DFGZID | 宁波市信访局 |
| 隐藏行ID | YCHID | string |  | _SHADOW_ROWID | 宁波市信访局 |

---

<a name="91"></a>
## 91. 95

**表名**: `DW_NB_XFLYDFGZHFXX`

**主键**: ZJID

### 字段信息

| 中文字段名 | 标准化字段名 | 数据类型 | 样例数据 | 源表字段名 | 来源 |
| --- | --- | --- | --- | --- | --- |
| 主键ID | ZJID | string |  | STOREID | 宁波市信访局 |
| 信访事项ID | XFSXID | string |  | RELATEDDOCSTOREID | 宁波市信访局 |
| 操作时间 | CZSJ | datetime |  | OPPTIME | 宁波市信访局 |
| 类型 | LX | string |  | LX | 宁波市信访局 |
| 文种 | WZ | string |  | WZ | 宁波市信访局 |
| 处理单位ID | CLDWID | string |  | CLDWDM | 宁波市信访局 |
| 信访件ID | XFJID | string |  | XFJSTOREID | 宁波市信访局 |
| 上传扫描文件附件内容 | SCSMWJFJNR | string |  | WJ | 宁波市信访局 |
| 意见书编号 | YJSBH | string |  | YJSBH | 宁波市信访局 |
| 处理日期 | CLRQ | datetime |  | CLRQ | 宁波市信访局 |
| 处理单位 | CLDW | string |  | CLDW | 宁波市信访局 |
| 信访人姓名 | XFRXM | string |  | XFRXM | 宁波市信访局 |
| 信访人ID | XFRID | string |  | XFRID | 宁波市信访局 |
| 文件内容 | WJLR | string |  | FILECONT | 宁波市信访局 |
| 信访人意见 | XFRYJ | string |  | XFRYJ | 宁波市信访局 |
| 送达方式 | SDFS | string |  | SDFS | 宁波市信访局 |
| 送达人 | SDR | string |  | SDR | 宁波市信访局 |
| 送达时间 | SDSJ | datetime |  | SDSJ | 宁波市信访局 |
| 签收标志 | QSBZ | string |  | QSBZ | 宁波市信访局 |
| 办理部门 | BLBM | string |  | BLBM | 宁波市信访局 |
| 经办人 | JBR | string |  | JBR | 宁波市信访局 |
| 经办人联系电话 | JBRLXDH | string |  | JBRLXDH | 宁波市信访局 |
| 送达人联系电话 | SDRLXDH | string |  | SDRLXDH | 宁波市信访局 |
| 区别意见书类型 | QBYJSLX | string |  | TYPE | 宁波市信访局 |
| 单位落款 | DWLK | string |  | DWLK | 宁波市信访局 |
| 文书编号 | WSBH | string |  | WSBH | 宁波市信访局 |
| 新老数据标志 | XLSJBZ | string |  | ISOLD | 宁波市信访局 |
| 补充答复的办理情况 | BCDFBLQK | string |  | BCBLQK | 宁波市信访局 |
| 隐藏行ID | YCHID | string |  | _SHADOW_ROWID | 宁波市信访局 |
| 是否立案 | SFLA | string |  | ISCASE | 宁波市信访局 |
| 是否检查 | SFJC | string |  | ISCHECK | 宁波市信访局 |

---

<a name="92"></a>
## 92. 96

**表名**: `DW_NB_XFLYDHYDFXX`

**主键**: ZJID

### 字段信息

| 中文字段名 | 标准化字段名 | 数据类型 | 样例数据 | 源表字段名 | 来源 |
| --- | --- | --- | --- | --- | --- |
| 主键ID | ZJID | string |  | STOREID | 宁波市信访局 |
| 来电编号 | LDBH | string |  | XFJBH | 宁波市信访局 |
| 呼入类型 | HRLX | string |  | HRLX | 宁波市信访局 |
| 来电形式 | XFXS | string |  | XFXS | 宁波市信访局 |
| 登记人ID | DJRID | string |  | DJRID | 宁波市信访局 |
| 工号 | GH | string |  | GH | 宁波市信访局 |
| 登记人姓名 | DJR | string |  | DJR | 宁波市信访局 |
| 登记单位ID | DJDWID | string |  | DJDWID | 宁波市信访局 |
| 登记单位 | DJDW | string |  | DJDW | 宁波市信访局 |
| 登记部门ID | DJBMID | string |  | DJBMID | 宁波市信访局 |
| 登记部门 | DJBM | string |  | DJBM | 宁波市信访局 |
| 呼入时间 | DJSJ | datetime |  | DJSJ | 宁波市信访局 |
| 信访件ID | XFJID | string |  | XFJID | 宁波市信访局 |
| 姓名 | XM | string |  | XM | 宁波市信访局 |
| 问题属地代码 | WTSD | string |  | WTSD | 宁波市信访局 |
| 性别 | XB | string |  | XB | 宁波市信访局 |
| 常住地址代码 | CZDZDM | string |  | CZDZDM | 宁波市信访局 |
| 常住地址 | CZDZ | string |  | CZDZ | 宁波市信访局 |
| 户口所在地代码 | HKSZDDM | string |  | HKSZDDM | 宁波市信访局 |
| 户口所在地 | HKSZD | string |  | HKSZD | 宁波市信访局 |
| 来电目的 | XFMD | string |  | XFMD | 宁波市信访局 |
| 内容分类 | NRFL | string |  | NRFL | 宁波市信访局 |
| 信访日期 | XFRQ | string |  | XFRQ | 宁波市信访局 |
| 优先级 | YXJ | string |  | YXJ | 宁波市信访局 |
| 限办时间 | XBSJ | datetime |  | XBSJ | 宁波市信访局 |
| 是否特殊人员 | TSRYBZ | string |  | TSRYBZ | 宁波市信访局 |
| 全国初次信访标志 | QGCCXFBZ | string |  | QGCCXFBZ | 宁波市信访局 |
| 是否信访件 | SFXFJ | string |  | SFXFJ | 宁波市信访局 |
| 是否公开 | SFGK | string |  | SFGK | 宁波市信访局 |
| 是否关联电话录音 | SFGLDHLY | string |  | SFGLDHLY | 宁波市信访局 |
| 反映内容 | FYNR | string |  | FYNR | 宁波市信访局 |
| 相关附件名 | XGFJ | string |  | XGFJ | 宁波市信访局 |
| 处理结果 | CLQK | string |  | CLQK | 宁波市信访局 |
| 处理状态 | XFJCLZT | string |  | XFJCLZT | 宁波市信访局 |
| 受理单位 | SLDW | string |  | SLDW | 宁波市信访局 |
| 重件关连 | CJGL | string |  | CJGL | 宁波市信访局 |
| 操作时间 | CZSJ | datetime |  | OPPTIME | 宁波市信访局 |
| 工作单位 | GZDW | string |  | GZDW | 宁波市信访局 |
| 职业 | ZY | string |  | ZY | 宁波市信访局 |
| 证件类型 | ZJLX | string |  | ZJLX | 宁波市信访局 |
| 证件号码 | ZJHM | string |  | ZJHM | 宁波市信访局 |
| 标题 | BT | string |  | BT | 宁波市信访局 |
| 来电状态 | LDZT | string |  | LDZT | 宁波市信访局 |
| 经办人ID | JBRID | string |  | JBRID | 宁波市信访局 |
| 新老数据标志 | XLSJBZ | string |  | ISOLD | 宁波市信访局 |
| 联系电话 | LXDH | string |  | LXDH | 宁波市信访局 |
| 是否匿名 | NMBZ | string |  | NMBZ | 宁波市信访局 |
| 查询码 | CXM | string |  | CXM | 宁波市信访局 |
| 行政区划 | XZQH | string |  | XZQH | 宁波市信访局 |
| 简易程序 | JJCD | string |  | JJCD | 宁波市信访局 |
| 来电号码 | LDHM | string |  | LDHM | 宁波市信访局 |
| 是否保密 | SFBM | string |  | ISSECRET | 宁波市信访局 |
| 回访标志 | HFBZ | string |  | HFBZ | 宁波市信访局 |
| 被呼叫号码 | BHJHM | string |  | BHJHM | 宁波市信访局 |
| 厅局代码 | TJDM | string |  | TJDM | 宁波市信访局 |
| 保密人ID | BMRID | string |  | BMRID | 宁波市信访局 |
| 转送受理单位 | ZSSLDW | string |  | ZSSLDW | 宁波市信访局 |
| 转送受理人 | ZSSLR | string |  | ZSSLR | 宁波市信访局 |
| 当前办理人ID | DQBLR | string |  | SDR | 宁波市信访局 |
| 解锁时间 | JSSJ | datetime |  | JSSJ | 宁波市信访局 |
| 答复人姓名 | DFRXM | string |  | DFRXM | 宁波市信访局 |
| 答复人ID | DFRID | string |  | DFRID | 宁波市信访局 |
| 答复时间 | DFSJ | datetime |  | DFSJ | 宁波市信访局 |
| 所属网站 | SSWZ | string |  | SSWZ | 宁波市信访局 |
| 录音文件路径 | LYWJLJ | string |  | RECORDFILE | 宁波市信访局 |
| 录音文件归档目录 | LYWJGDML | string |  | RECORDFILEPATH | 宁波市信访局 |
| 录音文件名 | LYWJM | string |  | RECORDFILENAME | 宁波市信访局 |
| 锁定人姓名 | SDRXM | string |  | SDRXM | 宁波市信访局 |
| 行业内容分类 | HYNRFL | string |  | HYNRFL | 宁波市信访局 |
| 答复单位代码 | DFDWDM | string |  | DFDWDM | 宁波市信访局 |
| 热点问题 | RDWT | string |  | RDWT | 宁波市信访局 |
| 附件名 | FJM | string |  | FJ | 宁波市信访局 |
| 隐藏行ID | YCHID | string |  | _SHADOW_ROWID | 宁波市信访局 |

---

<a name="93"></a>
## 93. 97

**表名**: `DW_NB_XFLYHSDHXX`

**主键**: ZJBH

### 字段信息

| 中文字段名 | 标准化字段名 | 数据类型 | 样例数据 | 源表字段名 | 来源 |
| --- | --- | --- | --- | --- | --- |
| 主键编号 | ZJBH | string |  | STOREID | 宁波市信访局 |
| 登记人编号 | DJRBH | string |  | DJRID | 宁波市信访局 |
| 登记人 | DJR | string |  | DJR | 宁波市信访局 |
| 登记部门编号 | DJBMBH | string |  | DJBMID | 宁波市信访局 |
| 登记部门 | DJBM | string |  | DJBM | 宁波市信访局 |
| 登记单位编号 | DJDWBH | string |  | DJDWID | 宁波市信访局 |
| 登记单位 | DJDW | string |  | DJDW | 宁波市信访局 |
| 通话内容 | THLR | string |  | NR | 宁波市信访局 |
| 信访件编号 | XFJBH | string |  | XFJID | 宁波市信访局 |
| 附件名 | FJM | string |  | FJ | 宁波市信访局 |
| 对应评价表编号 | DYPJBBH | string |  | RELATEDDOCSTOREID | 宁波市信访局 |
| 核实时间 | HSSJ | string |  | BLSJ | 宁波市信访局 |
| 是否通过 | SFTG | string |  | SFTG | 宁波市信访局 |
| 是否理解件 | SFLJJ | string |  | SFLJJ | 宁波市信访局 |
| 是否属实 | SFSS | string |  | SFSS | 宁波市信访局 |
| 诉求是否合理 | SQSFHL | string |  | SQSFHL | 宁波市信访局 |
| 信访原因 | XFYY | string |  | XFYY | 宁波市信访局 |
| 理解件说明 | LJJSM | string |  | LJJSM | 宁波市信访局 |

---

<a name="94"></a>
## 94. 98

**表名**: `DW_NB_XFLYHSSDXX`

**主键**: ZJID

### 字段信息

| 中文字段名 | 标准化字段名 | 数据类型 | 样例数据 | 源表字段名 | 来源 |
| --- | --- | --- | --- | --- | --- |
| 主键ID | ZJID | string |  | STOREID | 宁波市信访局 |
| 登记人ID | DJRID | string |  | DJRID | 宁波市信访局 |
| 登记人 | DJR | string |  | DJR | 宁波市信访局 |
| 登记部门ID | DJBMID | string |  | DJBMID | 宁波市信访局 |
| 登记部门 | DJBM | string |  | DJBM | 宁波市信访局 |
| 登记单位ID | DJDWID | string |  | DJDWID | 宁波市信访局 |
| 登记单位 | DJDW | string |  | DJDW | 宁波市信访局 |
| 督办内容 | DBLR | string |  | NR | 宁波市信访局 |
| 信访件ID | XFJID | string |  | XFJID | 宁波市信访局 |
| 实地督办的属实情况 | SSQK | string |  | SSQK | 宁波市信访局 |
| 实地督办的审核意见 | SHYJ | string |  | SHYJ | 宁波市信访局 |
| 实地督办的落实情况 | LSQK | string |  | LSQK | 宁波市信访局 |
| 实地督办的督办意见 | DBYJ | string |  | DBYJ | 宁波市信访局 |
| 实地核实情况 | SDHSQK | string |  | SFTG | 宁波市信访局 |
| 附件名 | FJM | string |  | FJ | 宁波市信访局 |
| 对应307评价表ID | DYPJBID | string |  | RELATEDDOCSTOREID | 宁波市信访局 |
| 是否理解件 | SFLJJ | string |  | SFLJJ | 宁波市信访局 |
| 是否属实 | SFSS | string |  | SFSS | 宁波市信访局 |
| 诉求是否合理 | SQSFHL | string |  | SQSFHL | 宁波市信访局 |
| 信访原因 | XFYY | string |  | XFYY | 宁波市信访局 |
| 理解件说明 | LJJSM | string |  | LJJSM | 宁波市信访局 |

---

<a name="95"></a>
## 95. 99

**表名**: `DW_NB_XFLYHSWLXX`

**主键**: ZJID

### 字段信息

| 中文字段名 | 标准化字段名 | 数据类型 | 样例数据 | 源表字段名 | 来源 |
| --- | --- | --- | --- | --- | --- |
| 主键ID | ZJID | string |  | STOREID | 宁波市信访局 |
| 登记人ID | DJRID | string |  | DJRID | 宁波市信访局 |
| 登记人 | DJR | string |  | DJR | 宁波市信访局 |
| 登记部门ID | DJBMID | string |  | DJBMID | 宁波市信访局 |
| 登记部门 | DJBM | string |  | DJBM | 宁波市信访局 |
| 登记单位ID | DJDWID | string |  | DJDWID | 宁波市信访局 |
| 登记单位 | DJDW | string |  | DJDW | 宁波市信访局 |
| 督办内容 | DBLR | string |  | NR | 宁波市信访局 |
| 信访件ID | XFJID | string |  | XFJID | 宁波市信访局 |
| 实地核实情况 | SFTG | string |  | SFTG | 宁波市信访局 |
| 附件名 | FJM | string |  | FJ | 宁波市信访局 |
| 对应307评价表ID | DYPJBID | string |  | RELATEDDOCSTOREID | 宁波市信访局 |
| 办理时间 | BLSJ | string |  | BLSJ | 宁波市信访局 |
| 是否理解件 | SFLJJ | string |  | SFLJJ | 宁波市信访局 |
| 是否属实 | SFSS | string |  | SFSS | 宁波市信访局 |
| 诉求是否合理 | SQSFHL | string |  | SQSFHL | 宁波市信访局 |
| 信访原因 | XFYY | string |  | XFYY | 宁波市信访局 |
| 理解件说明 | LJJSM | string |  | LJJSM | 宁波市信访局 |

---

<a name="96"></a>
## 96. 100

**表名**: `DW_NB_XFLYHFXX`

**主键**: ZJID

### 字段信息

| 中文字段名 | 标准化字段名 | 数据类型 | 样例数据 | 源表字段名 | 来源 |
| --- | --- | --- | --- | --- | --- |
| 主键 | ZJ | string |  | STOREID | 宁波市信访局 |
| 操作时间 | CZSJ | datetime |  | OPPTIME | 宁波市信访局 |
| 信访件ID | XFJID | string |  | RELATEDDOCSTOREID | 宁波市信访局 |
| 扬言内容 | YYNR | string |  | YYNR | 宁波市信访局 |
| 回访备注内容 | HFBZNR | string |  | HFBZNR | 宁波市信访局 |
| 新老数据标志 | XLSJBZ | string |  | ISOLD | 宁波市信访局 |
| 标志 | BZ | string |  | MARK | 宁波市信访局 |
| 回访人员 | HFRY | string |  | HFRY | 宁波市信访局 |
| 回访单位 | HFDW | string |  | HFDW | 宁波市信访局 |
| 回访录音文件名 | HFLYWJ | string |  | HFLYWJ | 宁波市信访局 |
| 回访人员名字 | HFRYMZ | string |  | HFRYMZ | 宁波市信访局 |
| 回访附件名 | HFFJ | string |  | HFFJ | 宁波市信访局 |
| 回访方式 | HFFS | string |  | HFFS | 宁波市信访局 |
| 307主键ID | ZJID | string |  | MYDSTOREID | 宁波市信访局 |
| 最近回访 | ZJHF | string |  | ZJHF | 宁波市信访局 |
| 回访情况 | HFQK | string |  | HFQK | 宁波市信访局 |
| 数据来源 | SJLY | string |  | HFJLLY | 宁波市信访局 |
| 无法回访标志 | WFHFBZ | string |  | WFHFBZ | 宁波市信访局 |

---

<a name="97"></a>
## 97. 101

**表名**: `DW_NB_XFLYWDFDHXX`

**主键**: ZJID

### 字段信息

| 中文字段名 | 标准化字段名 | 数据类型 | 样例数据 | 源表字段名 | 来源 |
| --- | --- | --- | --- | --- | --- |
| 主键ID | ZJID | string |  | STOREID110 | 宁波市信访局 |
| 来电编号 | LDBH | string |  | XFJBH | 宁波市信访局 |
| 来电形式 | LDXS | string |  | XFXS | 宁波市信访局 |
| 登记人ID | DJRID | string |  | DJRID | 宁波市信访局 |
| 工号 | GH | string |  | GH | 宁波市信访局 |
| 登记人姓名 | DJR | string |  | DJR | 宁波市信访局 |
| 登记单位ID | DJDWID | string |  | DJDWID | 宁波市信访局 |
| 登记单位 | DJDW | string |  | DJDW | 宁波市信访局 |
| 登记部门ID | DJBMID | string |  | DJBMID | 宁波市信访局 |
| 登记部门 | DJBM | string |  | DJBM | 宁波市信访局 |
| 呼入时间 | HRSJ | string |  | DJSJ | 宁波市信访局 |
| 信访件ID | XFJID | string |  | XFJID | 宁波市信访局 |
| 姓名 | XM | string |  | XM | 宁波市信访局 |
| 问题属地代码 | WTSD | string |  | WTSD | 宁波市信访局 |
| 性别 | XB | string |  | XB | 宁波市信访局 |
| 常住地址代码 | CZDZDM | string |  | CZDZDM | 宁波市信访局 |
| 常住地址 | CZDZ | string |  | CZDZ | 宁波市信访局 |
| 户口所在地代码 | HKSZDDM | string |  | HKSZDDM | 宁波市信访局 |
| 户口所在地 | HKSZD | string |  | HKSZD | 宁波市信访局 |
| 来电目的 | XFMD | string |  | XFMD | 宁波市信访局 |
| 内容分类 | NRFL | string |  | NRFL | 宁波市信访局 |
| 信访日期 | XFRQ | string |  | XFRQ | 宁波市信访局 |
| 反映内容 | FYNR | string |  | FYNR | 宁波市信访局 |
| 相关附件名 | XGFJ | string |  | XGFJ | 宁波市信访局 |
| 处理结果 | CLQK | string |  | CLQK | 宁波市信访局 |
| 处理状态 | XFJCLZT | string |  | XFJCLZT | 宁波市信访局 |
| 工作单位 | GZDW | string |  | GZDW | 宁波市信访局 |
| 职业 | ZY | string |  | ZY | 宁波市信访局 |
| 证件类型 | ZJLX | string |  | ZJLX | 宁波市信访局 |
| 证件号码 | ZJHM | string |  | ZJHM | 宁波市信访局 |
| 标题 | BT | string |  | BT | 宁波市信访局 |
| 来电状态 | LDZT | string |  | LDZT | 宁波市信访局 |
| 经办人ID | JBRID | string |  | JBRID | 宁波市信访局 |
| 联系电话 | LXDH | string |  | LXDH | 宁波市信访局 |
| 是否匿名 | NMBZ | string |  | NMBZ | 宁波市信访局 |
| 行政区划 | XZQH | string |  | XZQH | 宁波市信访局 |
| 紧急程度 | JJCD | string |  | JJCD | 宁波市信访局 |
| 来电号码 | LDHM | string |  | LDHM | 宁波市信访局 |
| 是否保密 | SFBM | string |  | ISSECRET | 宁波市信访局 |
| 答复人姓名 | DFRXM | string |  | DFRXM | 宁波市信访局 |
| 答复人ID | DFRID | string |  | DFRID | 宁波市信访局 |
| 答复时间 | DFSJ | string |  | DFSJ | 宁波市信访局 |
| 行业内容分类 | HYNRFL | string |  | HYNRFL | 宁波市信访局 |
| 答复单位代码 | DFDWDM | string |  | DFDWDM | 宁波市信访局 |
| 热点问题 | RDWT | string |  | RDWT | 宁波市信访局 |
| 附件名 | FJM | string |  | FJ | 宁波市信访局 |

---

<a name="98"></a>
## 98. 102

**表名**: `DW_NB_XFLYXFJXX`

**主键**: ZJBH

### 字段信息

| 中文字段名 | 标准化字段名 | 数据类型 | 样例数据 | 源表字段名 | 来源 |
| --- | --- | --- | --- | --- | --- |
| 主键编号 | ZJBH | string |  | STOREID | 宁波市信访局 |
| 关联信访事项编号 | GLXFSXBH | string |  | RELATEDDOCSTOREID | 宁波市信访局 |
| 操作时间 | CZSJ | datetime |  | OPPTIME | 宁波市信访局 |
| 标题 | BT | string |  | BT | 宁波市信访局 |
| 信访件编号 | XFJBH | string |  | XFJBH | 宁波市信访局 |
| 信访形式 | XFXS | string |  | XFXS | 宁波市信访局 |
| 本次主信访人编号 | XFRID | string |  | XFRID | 宁波市信访局 |
| 主信访人地址代码 | XFRDZDM | string |  | XFRDZDM | 宁波市信访局 |
| 受信人 | SXR | string |  | SXR | 宁波市信访局 |
| 受信人初次信访标志 | SXRCCXFBZ | string |  | SXRCCXFBZ | 宁波市信访局 |
| 查询码状态 | CXMZT | string |  | CXMZT | 宁波市信访局 |
| 查询码告知日期 | CXMGZRQ | datetime |  | CXMGZRQ | 宁波市信访局 |
| 查询码告知机构 | CXMGZJG | string |  | CXMGZJG | 宁波市信访局 |
| 登记部门编号 | DJBMID | string |  | DJBMID | 宁波市信访局 |
| 登记单位编号 | DJDWID | string |  | DJDWID | 宁波市信访局 |
| 相关附件名 | XGFJ | string |  | XGFJ | 宁波市信访局 |
| 登记机构初次信访标志 | DJJGCCXFBZ | string |  | BJGCCXFBZ | 宁波市信访局 |
| 全国初次信访标志 | QGCCXFBZ | string |  | QGCCXFBZ | 宁波市信访局 |
| 全国信访形式初次信访标志 | QGXFXSCCXFBZ | string |  | QGXFXSCCXFBZ | 宁波市信访局 |
| 登记机构信访形式初次信访标志 | DJJGXFXSCCXFBZ | string |  | BJGXFXSCCXFBZ | 宁波市信访局 |
| 评价情况 | PJQK | string |  | PJQK | 宁波市信访局 |
| 概况 | GK | string |  | GK | 宁波市信访局 |
| 人数 | RS | string |  | RS | 宁波市信访局 |
| 查询码 | CXM | string |  | CXM | 宁波市信访局 |
| 信访件状态 | XFJZT | string |  | XFJCLZT | 宁波市信访局 |
| 涉及人数 | SJRS | string |  | SJRS | 宁波市信访局 |
| 信访日期 | XFRQ | datetime |  | XFRQ | 宁波市信访局 |
| 群体意愿标志 | QTYYBZ | string |  | QTYYBZ | 宁波市信访局 |
| 初次来源 | CCLY | string |  | CCLY | 宁波市信访局 |
| 登记时间 | DJSJ | datetime |  | DJSJ | 宁波市信访局 |
| 登记人编号 | DJRID | string |  | DJRID | 宁波市信访局 |
| 越级标志 | YJBZ | string |  | YJBZ | 宁波市信访局 |
| 联名信或集体访 | JTXFBZ | string |  | JTXFBZ | 宁波市信访局 |
| 接谈人编号 | JTRXMID | string |  | JTRXMID | 宁波市信访局 |
| 接谈人部门编号 | JTRBMID | string |  | JTRBMID | 宁波市信访局 |
| 接谈人单位编号 | JTRDWID | string |  | JTRDWID | 宁波市信访局 |
| 来信形式 | LXXS | string |  | LXXS | 宁波市信访局 |
| 紧急标志 | JJBZ | string |  | JJBZ | 宁波市信访局 |
| 匿名标志 | NMBZ | string |  | NMBZ | 宁波市信访局 |
| 受理机构编号 | SLJGID | string |  | SLJGID | 宁波市信访局 |
| 是否进行终结备案 | SFJY | string |  | SFJY | 宁波市信访局 |
| 网站地址 | WZDZ | string |  | WZDZ | 宁波市信访局 |
| 是否公开 | SFGK | string |  | SFGK | 宁波市信访局 |
| 最后一次办理时间 | BLSJ | datetime |  | BLSJ | 宁波市信访局 |
| 最后一次办理方式 | BLFS | string |  | BLFS | 宁波市信访局 |
| 最后一次办理去向 | QXMC | string |  | QXMC | 宁波市信访局 |
| 最后一次去向 | QX | string |  | QX | 宁波市信访局 |
| 信访事项被反映人级别 | XFSXBFYRJB | string |  | XFSXBFYRJB | 宁波市信访局 |
| 信访事项信访目的 | XFSXXFMD | string |  | XFMD | 宁波市信访局 |
| 问题属地代码编号 | WTSDDM | string |  | WTSDDM | 宁波市信访局 |
| 信访事项密级 | MJ | string |  | MJ | 宁波市信访局 |
| 信访人诉求 | XFRSQ | string |  | XFRSQ | 宁波市信访局 |
| 扬言标志 | YYBZ | string |  | YYBZ | 宁波市信访局 |
| 批示记录 | PSJL | string |  | PSJL | 宁波市信访局 |
| 催办记录 | CBJL | string |  | CBJL | 宁波市信访局 |
| 办结标志 | BJBZ | string |  | BJBZ | 宁波市信访局 |
| 办结时间 | BJSJ | datetime |  | BJSJ | 宁波市信访局 |
| 网上来源 | WSLY | string |  | WSLY | 宁波市信访局 |
| 限办时间 | XBSJ | datetime |  | XBSJ | 宁波市信访局 |
| 处理情况 | CLQK | string |  | CLQK | 宁波市信访局 |
| 复查情况 | FCQK | string |  | FCQK | 宁波市信访局 |
| 复核情况 | FHQK | string |  | FHQK | 宁波市信访局 |
| 问题属地行政区划 | WTSDXZQHDM | string |  | WTSDXZQHDM | 宁波市信访局 |
| 问题属地直属级别 | WTSDZSJB | string |  | WTSDZSJB | 宁波市信访局 |
| 问题属地直属单位 | WTSDZSDWDM | string |  | WTSDZSDWDM | 宁波市信访局 |
| 是否移交转督办 | SFYJ | string |  | SFYJ | 宁波市信访局 |
| 督查登记标志 | DCDJBZ | string |  | DCDJBZ | 宁波市信访局 |
| 是否法院已受理 | SFFYYSL | string |  | SFFYYSL | 宁波市信访局 |
| 是否已经行政复议 | SFYJXZFY | string |  | SFYJXZFY | 宁波市信访局 |
| 是否仲裁机构已受理 | SFZCJGYSL | string |  | SFZCJGYSL | 宁波市信访局 |
| 是否有复查复核意见书 | SFYYFCFHYJS | string |  | SFYYFCFHYJS | 宁波市信访局 |
| 是否有进京访风险 | JJFFXBZ | string |  | JJFFXBZ | 宁波市信访局 |
| 是否其他行为 | ZSRLXWBZ | string |  | ZSRLXWBZ | 宁波市信访局 |
| 是否有不良影响 | QFBJSBZ | string |  | QFBJSBZ | 宁波市信访局 |
| 登记部门 | DJBM | string |  | DJBM | 宁波市信访局 |
| 登记单位 | DJDW | string |  | DJDW | 宁波市信访局 |
| 登记人姓名 | DJR | string |  | DJR | 宁波市信访局 |
| 接谈人姓名 | JTRXM | string |  | JTRXM | 宁波市信访局 |
| 接谈人部门 | JTRBM | string |  | JTRBM | 宁波市信访局 |
| 接谈人单位 | JTRDW | string |  | JTRDW | 宁波市信访局 |
| 问题属地名称 | WTSD | string |  | WTSD | 宁波市信访局 |
| 是否公开互联网 | ISGKHLW | string |  | ISGKHLW | 宁波市信访局 |
| 登记单位代码 | DJDWDM | string |  | DJDWDM | 宁波市信访局 |
| 作出受理意见日期 | ZCSLYJRQ | datetime |  | ZCSLYJRQ | 宁波市信访局 |
| 作出处理意见日期 | ZCCLYJRQ | datetime |  | ZCCLYJRQ | 宁波市信访局 |
| 督办状态 | DBZT | string |  | DBZT | 宁波市信访局 |
| 转交责任单位日期 | ZJZRDWRQ | datetime |  | ZJZRDWRQ | 宁波市信访局 |
| 实体受理标志 | STSLBZ | string |  | STSLBZ | 宁波市信访局 |
| 回访标志 | HFBZ | string |  | HFBZ | 宁波市信访局 |
| 涉法涉诉标志 | SFSSBZ | string |  | SFSSBZ | 宁波市信访局 |
| 首次信访标志 | SCXFBZ | string |  | SCXFBZ | 宁波市信访局 |
| 存在问题 | CZWT | string |  | CZWT | 宁波市信访局 |
| 数据来源 | SJLY | string |  | SJLY | 宁波市信访局 |
| 报送标志 | BSBZ | string |  | BSBZ | 宁波市信访局 |
| 是否信访件 | SFXFJ | string |  | SFXFJ | 宁波市信访局 |
| 是否超期 | SFCQ | string |  | SFCQ | 宁波市信访局 |
| 新老数据标志 | ISOLD | string |  | ISOLD | 宁波市信访局 |
| 抽查标志 | CCBZ | string |  | CCBZ | 宁波市信访局 |
| 国家数据交换标记 | GJBJ | string |  | GJBJ | 宁波市信访局 |
| 备注 | BZ | string |  | BZ | 宁波市信访局 |
| 新增积案标志 | JABZ | string |  | JABZ | 宁波市信访局 |
| 积案结案标志 | JAJABZ | string |  | JAJABZ | 宁波市信访局 |
| 办理程序 | JJCD | string |  | JJCD | 宁波市信访局 |
| 是否保密 | ISSECRET | string |  | ISSECRET | 宁波市信访局 |
| 国家登记时间 | GJDJSJ | datetime |  | GJDJSJ | 宁波市信访局 |
| 合并件编号 | HBJBH | string |  | HBJBH | 宁波市信访局 |
| 催办状态 | CBZT | string |  | CBZT | 宁波市信访局 |
| 办公系统内导厅局代码 | TJDM | string |  | TJDM | 宁波市信访局 |
| 涉及地区标志 | SJDQBZ | string |  | SJDQBZ | 宁波市信访局 |
| 信访部门评价状态 | XFBMPJZT | string |  | XFBMPJZT | 宁波市信访局 |
| 责任单位评价状态 | ZRDWPJZT | string |  | ZRDWPJZT | 宁波市信访局 |
| 保密人编号2 | BMRID2 | string |  | BMRID2 | 宁波市信访局 |
| 保密人编号 | BMRID | string |  | BMRID | 宁波市信访局 |
| 是否可再评价 | SFKZPJ | string |  | SFKZPJ | 宁波市信访局 |
| 核查状态 | HCZT | string |  | HCZT | 宁波市信访局 |
| 核实标志 | HSBZ | string |  | HSBZ | 宁波市信访局 |
| 流转单位 | LZDW | string |  | LZDW | 宁波市信访局 |
| 信访人姓名 | XM | string |  | XM | 宁波市信访局 |
| 性别 | XB | string |  | XB | 宁波市信访局 |
| 民族 | MZ | string |  | MZ | 宁波市信访局 |
| 地址 | DZ | string |  | DZ | 宁波市信访局 |
| 地址代码 | DZDM | string |  | DZDM | 宁波市信访局 |
| 证件号码 | ZJHM | string |  | ZJHM | 宁波市信访局 |
| 证件类型 | ZJLX | string |  | ZJLX | 宁波市信访局 |
| 手机号码 | SJHM | string |  | SJHM | 宁波市信访局 |
| 内容分类 | NRFL | string |  | NRFL | 宁波市信访局 |
| 产生信访原因 | CSXFYY | string |  | CSXFYY | 宁波市信访局 |
| 三跨三分离标志 | SKSFLBZ | string |  | SKSFLBZ | 宁波市信访局 |
| 热点问题 | RDWT | string |  | RDWT | 宁波市信访局 |
| 时间戳 | SJC | datetime |  | TIMESTAMP | 宁波市信访局 |
| 证件类型1 | ZJLX1 | string |  | ZJLX1 | 宁波市信访局 |
| 证件号码1 | ZJHM1 | string |  | ZJHM1 | 宁波市信访局 |
| 手机号码1 | SJHM1 | string |  | SJHM1 | 宁波市信访局 |
| 是否有过抄送记录 | SFCS | string |  | SFCS | 宁波市信访局 |
| 行业内容分类 | HYNRFL | string |  | HYNRFL | 宁波市信访局 |
| 是否归档 | SFGD | string |  | SFGD | 宁波市信访局 |
| 是否依法分类处理 | SFYFFLCL | string |  | SFYFFLCL | 宁波市信访局 |
| 办理方式节点 | BLFSJD | string |  | BLFSJD | 宁波市信访局 |
| 隐藏行编号 | YCHBH | string |  | _SHADOW_ROWID | 宁波市信访局 |
| 限期答复时间 | XQDFSJ | datetime |  | XQDF | 宁波市信访局 |

---

<a name="99"></a>
## 99. 103

**表名**: `DW_NB_XFLYXFRXXX`

**主键**: IDZJ

### 字段信息

| 中文字段名 | 标准化字段名 | 数据类型 | 样例数据 | 源表字段名 | 来源 |
| --- | --- | --- | --- | --- | --- |
| ID主键 | IDZJ | string |  | STOREID | 宁波市信访局 |
| 信访人编号 | XFRBM | string |  | XFRBM | 宁波市信访局 |
| 出生日期 | CSRQ | datetime |  | CSRQ | 宁波市信访局 |
| 手机号码 | SJHM | string |  | SJHM | 宁波市信访局 |
| 联系电话 | LXDH | string |  | LXDH | 宁波市信访局 |
| 性别 | XB | string |  | XB | 宁波市信访局 |
| 户口所在地 | HKSZD | string |  | HKSZD | 宁波市信访局 |
| 工作单位 | GZDW | string |  | GZDW | 宁波市信访局 |
| 电子邮件 | DZYJ | string |  | DZYJ | 宁波市信访局 |
| 职业 | ZY | string |  | ZY | 宁波市信访局 |
| 地址 | DZ | string |  | DZ | 宁波市信访局 |
| 常住地址代码 | CZDZDM | string |  | CZDZDM | 宁波市信访局 |
| 姓名 | XM | string |  | XM | 宁波市信访局 |
| 通讯地址 | TXDZ | string |  | TXDZ | 宁波市信访局 |
| 证件类型 | ZJLX | string |  | ZJLX | 宁波市信访局 |
| 民族 | MZ | string |  | MZ | 宁波市信访局 |
| 证件号码 | ZJHM | string |  | ZJHM | 宁波市信访局 |
| 户口所在地代码 | HKSZDDM | string |  | HKSZDDM | 宁波市信访局 |
| 地址代码 | DZDM | string |  | DZDM | 宁波市信访局 |
| 邮政编码 | YZBM | string |  | YZBM | 宁波市信访局 |
| 常住地址 | CZDZ | string |  | CZDZ | 宁波市信访局 |
| 政治身份 | ZZSF | string |  | ZZSF | 宁波市信访局 |
| 通讯地址代码 | TXDZDM | string |  | TXDZDM | 宁波市信访局 |
| 国籍或港澳台居民身份 | GJHGATJMSF | string |  | XFRGJHGATJMSF | 宁波市信访局 |
| 重点人员标志 | ZDRYBZ | string |  | ZDRYBZ | 宁波市信访局 |

---

<a name="100"></a>
## 100. 104

**表名**: `DW_NB_XFLYXJDBXX`

**主键**: ZJID

### 字段信息

| 中文字段名 | 标准化字段名 | 数据类型 | 样例数据 | 源表字段名 | 来源 |
| --- | --- | --- | --- | --- | --- |
| 主键ID | ZJID | string |  | STOREID | 宁波市信访局 |
| 信访件ID | XFJID | string |  | RELATEDDOCSTOREID | 宁波市信访局 |
| 核实编号 | HCBH | string |  | HCBH | 宁波市信访局 |
| 核实单状态 | HCDZT | string |  | HCDZT | 宁波市信访局 |
| 核实人 | HCR | string |  | HCR | 宁波市信访局 |
| 核实日期 | HCRQ | datetime |  | HCRQ | 宁波市信访局 |
| 核实部门ID | HCBMID | string |  | HCBMID | 宁波市信访局 |
| 核实部门 | HCBM | string |  | HCBM | 宁波市信访局 |
| 核实主题 | HCBT | string |  | HCBT | 宁波市信访局 |
| 核实人ID | HCRID | string |  | HCRID | 宁波市信访局 |
| 是否立项 | SFHC | string |  | SFHC | 宁波市信访局 |
| 核实单位 | HCDW | string |  | HCDW | 宁波市信访局 |
| 核实单位ID | HCDWID | string |  | HCDWID | 宁波市信访局 |
| 最后一次办理方式 | BLFS | string |  | BLFS | 宁波市信访局 |
| 最后一次办理时间 | BLSJ | datetime |  | BLSJ | 宁波市信访局 |
| 核实单位代码 | HCDWDM | string |  | HCDWDM | 宁波市信访局 |
| 核实内容 | HSNR | string |  | HSNR | 宁波市信访局 |

---

<a name="101"></a>
## 101. 105

**表名**: `DW_SHL_XFJXX`

### 字段信息

| 中文字段名 | 标准化字段名 | 数据类型 | 样例数据 | 源表字段名 | 来源 |
| --- | --- | --- | --- | --- | --- |
| 信访件ID | XFJID | string |  | STOREID | 宁波市信访局 |
| 关联信访事项ID | GLXFSXID | string |  | RELATEDDOCSTOREID | 宁波市信访局 |
| 标题 | BT | string |  | BT | 宁波市信访局 |
| 信访件编号 | XFJBH | string |  | XFJBH | 宁波市信访局 |
| 信访形式 | XFXS | string |  | XFXS | 宁波市信访局 |
| 本次主信访人ID | BCZXFRID | string |  | XFRID | 宁波市信访局 |
| 主信访人地址代码 | ZXFRDZDM | string |  | XFRDZDM | 宁波市信访局 |
| 受信人 | SXR | string |  | SXR | 宁波市信访局 |
| 登记部门ID | DJBMID | string |  | DJBMID | 宁波市信访局 |
| 登记单位ID | DJDWID | string |  | DJDWID | 宁波市信访局 |
| 相关附件 | XGFJ | string |  | XGFJ | 宁波市信访局 |
| 概况 | GK | string |  | GK | 宁波市信访局 |
| 人数 | RS | string |  | RS | 宁波市信访局 |
| 信访件状态 | XFJZT | string |  | XFJCLZT | 宁波市信访局 |
| 涉及人数 | SJRS | string |  | SJRS | 宁波市信访局 |
| 信访日期 | XFRQ | string |  | XFRQ | 宁波市信访局 |
| 登记时间 | DJSJ | string |  | DJSJ | 宁波市信访局 |
| 登记人ID | DJRID | string |  | DJRID | 宁波市信访局 |
| 越级标志 | YJBZ | string |  | YJBZ | 宁波市信访局 |
| 联名信或集体访 | LMXHJTF | string |  | JTXFBZ | 宁波市信访局 |
| 匿名标志 | NMBZ | string |  | NMBZ | 宁波市信访局 |
| 受理机构ID | SLJGID | string |  | SLJGID | 宁波市信访局 |
| 是否公开 | SFGK | string |  | SFGK | 宁波市信访局 |
| 信访事项信访目的 | XFSXXFMD | string |  | XFMD | 宁波市信访局 |
| 信访事项问题属地代码ID | XFSXWTSDDMID | string |  | WTSDDM | 宁波市信访局 |
| 信访人诉求 | XFRSQ | string |  | XFRSQ | 宁波市信访局 |
| 扬言标志 | YYBZ | string |  | YYBZ | 宁波市信访局 |
| 办结标志 | BJBZ | string |  | BJBZ | 宁波市信访局 |
| 办结时间 | BJSJ | string |  | BJSJ | 宁波市信访局 |
| 限办时间 | XBSJ | string |  | XBSJ | 宁波市信访局 |
| 登记部门 | DJBM | string |  | DJBM | 宁波市信访局 |
| 登记单位 | DJDW | string |  | DJDW | 宁波市信访局 |
| 登记人姓名 | DJRXM | string |  | DJR | 宁波市信访局 |
| 问题属地名称 | WTSDMC | string |  | WTSD | 宁波市信访局 |
| 登记单位代码 | DJDWDM | string |  | DJDWDM | 宁波市信访局 |
| 涉法涉诉标志 | SFSSBZ | string |  | SFSSBZ | 宁波市信访局 |
| 首次信访标志 | SCXFBZ | string |  | SCXFBZ | 宁波市信访局 |
| 备注 | BZ | string |  | BZ | 宁波市信访局 |
| 积案标志 | JABZ | string |  | JABZ | 宁波市信访局 |
| 办理程序 | JJCD | string |  | JJCD | 宁波市信访局 |
| 是否保密 | SFBM | string |  | ISSECRET | 宁波市信访局 |
| 涉及地区标志 | SJDQBZ | string |  | SJDQBZ | 宁波市信访局 |
| 信访部门评价状态 | XFBMPJZT | string |  | XFBMPJZT | 宁波市信访局 |
| 责任单位评价状态 | ZRDWPJZT | string |  | ZRDWPJZT | 宁波市信访局 |
| 行业内容分类 | HYNRFL | string |  | HYNRFL | 宁波市信访局 |
| 是否依法分类处理 | SFYFFLCL | string |  | SFYFFLCL | 宁波市信访局 |

---

<a name="102"></a>
## 102. 106

**表名**: `DW_SHL_XFRXX`

**主键**: IDZJ

### 字段信息

| 中文字段名 | 标准化字段名 | 数据类型 | 样例数据 | 源表字段名 | 来源 |
| --- | --- | --- | --- | --- | --- |
| ID主键 | IDZJ | string |  | STOREID | 宁波市信访局 |
| 民族 | MZ | string |  | MZ | 宁波市信访局 |
| 证件号码 | ZJHM | string |  | ZJHM | 宁波市信访局 |
| 户口所在地代码 | HKSZDDM | string |  | HKSZDDM | 宁波市信访局 |
| 地址代码 | DZDM | string |  | DZDM | 宁波市信访局 |
| 邮政编码 | YZBM | string |  | YZBM | 宁波市信访局 |
| 常住地址 | CZDZ | string |  | CZDZ | 宁波市信访局 |
| 政治身份 | ZZSF | string |  | ZZSF | 宁波市信访局 |
| 通讯地址代码 | TXDZDM | string |  | TXDZDM | 宁波市信访局 |
| 信访人国籍或港澳台居民身份 | XFRGJHGATJMSF | string |  | XFRGJHGATJMSF | 宁波市信访局 |
| 证件类型 | ZJLX | string |  | ZJLX | 宁波市信访局 |
| 通讯地址 | TXDZ | string |  | TXDZ | 宁波市信访局 |
| 信访人编号 | XFRBM | string |  | XFRBM | 宁波市信访局 |
| 出生日期 | CSRQ | string |  | CSRQ | 宁波市信访局 |
| 手机号码 | SJHM | string |  | SJHM | 宁波市信访局 |
| 联系电话 | LXDH | string |  | LXDH | 宁波市信访局 |
| 性别 | XB | string |  | XB | 宁波市信访局 |
| 户口所在地 | HKSZD | string |  | HKSZD | 宁波市信访局 |
| 工作单位 | GZDW | string |  | GZDW | 宁波市信访局 |
| 电子邮件 | DZYJ | string |  | DZYJ | 宁波市信访局 |
| 职业 | ZY | string |  | ZY | 宁波市信访局 |
| 地址 | DZ | string |  | DZ | 宁波市信访局 |
| 常住地址代码 | CZDZDM | string |  | CZDZDM | 宁波市信访局 |
| 姓名 | XM | string |  | XM | 宁波市信访局 |

---

<a name="103"></a>
## 103. 107

**表名**: `DSC_SYDEP_TABL`

**主键**: DSC_HASH_UNIQUUE

### 字段信息

| 中文字段名 | 标准化字段名 | 数据类型 | 样例数据 | 源表字段名 |
| --- | --- | --- | --- | --- |
| ETL处理时间戳 | ETL_PROC_DT |  |  | ETL_PROC_DT |
| etl加载作业名 | ETL_JOB_NM |  |  | ETL_JOB_NM |
| etl上游表 | ETL_SRC_TABLE |  |  | ETL_SRC_TABLE |
| etl来源部门编码 | ETL_SRC_ORG_CD |  |  | ETL_SRC_ORG_CD |
| 主键 | ID |  |  | ID |
| 证件类型 | IDENT_TYPE_CD |  |  | IDENT_TYPE_CD |
| 证件号码 | IDENT_NO |  |  | IDENT_NO |
| 姓名 | NM |  |  | NM |
| 民族 | ETHNIC_CD |  |  | ETHNIC_CD |
| 国籍 | NATIONALITY_CD |  |  | NATIONALITY_CD |
| 婚姻状况 | MARITAL_STATUS_CD |  |  | MARITAL_STATUS_CD |
| 最高学历 | EDU_DEGREE_CD |  |  | EDU_DEGREE_CD |
| 性别 | GENDER_CD |  |  | GENDER_CD |
| 出生日期 | BIRTH_DT |  |  | BIRTH_DT |
| 手机号码 | PHONE_NUM |  |  | PHONE_NUM |
| 户籍地省市区代码 | DOMIC_COUNTY_CD |  |  | DOMIC_COUNTY_CD |
| 户籍地省市区县 | DOMIC_COUNTY |  |  | DOMIC_COUNTY |
| 户籍地派出所名称 | DOMIC_POLICE_STATION |  |  | DOMIC_POLICE_STATION |
| 户籍地派出所代码 | DOMIC_POLICE_STATION_CD |  |  | DOMIC_POLICE_STATION_CD |
| 户籍地乡镇街道代码 | DOMIC_TOWN_CD |  |  | DOMIC_TOWN_CD |
| 户籍地乡镇街道 | DOMIC_TOWN |  |  | DOMIC_TOWN |
| 户籍地街路巷代码 | DOMIC_STREET_CD |  |  | DOMIC_STREET_CD |
| 户籍地街路巷 | DOMIC_STREET |  |  | DOMIC_STREET |
| 户籍地居委会代码 | DOMIC_COMMITTEE_CD |  |  | DOMIC_COMMITTEE_CD |
| 户籍地居委会 | DOMIC_COMMITTEE |  |  | DOMIC_COMMITTEE |
| 户籍地址 | DOMIC_ADDR |  |  | DOMIC_ADDR |
| 居住的省市区县代码 | RESIDT_COUNTY_CD |  |  | RESIDT_COUNTY_CD |
| 居住地省市区县 | RESIDT_COUNTY |  |  | RESIDT_COUNTY |
| 居住地派出所代码 | RESIDT_POLICE_STATION_CD |  |  | RESIDT_POLICE_STATION_CD |
| 居住地派出所 | RESIDT_POLICE_STATION |  |  | RESIDT_POLICE_STATION |
| 居住地乡镇街道代码 | RESIDT_TOWN_CD |  |  | RESIDT_TOWN_CD |
| 居住地乡镇街道 | RESIDT_TOWN |  |  | RESIDT_TOWN |
| 居住地街路巷代码 | RESIDT_STREET_CD |  |  | RESIDT_STREET_CD |
| 居住地街路巷 | RESIDT_STREET |  |  | RESIDT_STREET |
| 居住地居委会代码 | RESIDT_COMMITTEE_CD |  |  | RESIDT_COMMITTEE_CD |
| 居住地居委会 | RESIDT_COMMITTEE |  |  | RESIDT_COMMITTEE |
| 居住地址 | RESIDT_ADDR |  |  | RESIDT_ADDR |
| 备注 | REMARK |  |  | REMARK |
| 死亡标识 | DEATH_FLAG |  |  | DEATH_FLAG |
| 地市行政区划融合 | AREA_CODE_REFLOW |  |  | AREA_CODE_REFLOW |
| 日期分区 | DT |  |  | DT |
| 数源单位代码 | DSC_SYDEP_CODE |  |  | DSC_SYDEP_CODE |
| 数源单位 | DSC_SYDEP |  |  | DSC_SYDEP |
| 数据所属系统名称 | DSC_SYDEP_SYS |  |  | DSC_SYDEP_SYS |
| 数源单位表名 | DSC_SYDEP_TABL |  |  | DSC_SYDEP_TABL |
| 唯一自增序列号 | DSC_BIZ_RECORD_ID |  |  | DSC_BIZ_RECORD_ID |
| 操作表示 | DSC_BIZ_OPERATION  |  |  | DSC_BIZ_OPERATION  |
| 源表数据同步时间 | DSC_BIZ_TIMESTAMP |  |  | DSC_BIZ_TIMESTAMP |
| 数据来源表 | DSC_DATASR_TABLENAME |  |  | DSC_DATASR_TABLENAME |
| 业务主键 | DSC_HASH_UNIQUUE |  |  | DSC_HASH_UNIQUUE |
| 清洗时间 | DSC_CLEAN_TIMESTAMP |  |  | DSC_CLEAN_TIMESTAMP |
| 行政区划代码 | DSC_CITY_XZQHDM |  |  | DSC_CITY_XZQHDM |
| etl处理时间 | ETL_CLSJ |  |  | ETL_CLSJ |

---

<a name="104"></a>
## 104. 108

**表名**: `v_ods_zj_sscjgj_dsc_dd041_hz_e_baseinfo_fr_delta_gt_old_nb_df`

**注意**: 未找到字段信息或字段信息格式不标准

---

<a name="105"></a>
## 105. 109

**表名**: `v_ods_zj_sjtyst_dsc_nb_biz_032_jdcwxjyyhbaxx_df`

### 字段信息

| 中文字段名 | 标准化字段名 | 数据类型 | 样例数据 | 源表字段名 |
| --- | --- | --- | --- | --- |
| ID | id | BIGINT/整型I |  | id |
| 业户名称 | name | VARCHAR/字符串型C |  | name |
| 所在地市 | szds | VARCHAR/字符串型C |  | szds |
| 地市所在县 | dsszx | CHAR/字符串型C |  | dsszx |
| 经营类型 | busi_mode | VARCHAR/字符串型C |  | busi_mode |
| 经济类型 | econ_type | INT/整型I |  | econ_type |
| 负责人姓名 | agent_name | VARCHAR/字符串型C |  | agent_name |
| 负责人手机 | agent_tel | VARCHAR/字符串型C |  | agent_tel |
| 备案机关 | organ_code | VARCHAR/字符串型C |  | organ_code |
| 统一社会信用代码 | tyshxydm | VARCHAR/字符串型C |  | tyshxydm |
| 经营范围 | jyfw | VARCHAR/字符串型C |  | jyfw |
| 备案日期 | first_print_date | DATETIME/日期时间型T |  | first_print_date |
| 备注 | memo | VARCHAR/字符串型C |  | memo |
| 配备设施 | pbss | VARCHAR/字符串型C |  | pbss |
| 备案证号 | bazh | VARCHAR/字符串型C |  | bazh |
| 业户电话 | tel | VARCHAR/字符串型C |  | tel |
| 法人证件类型 | card_type | INT/整型I |  | card_type |
| 经办人姓名 | dealer | VARCHAR/字符串型C |  | dealer |
| 区划备注 | division_memo | VARCHAR/字符串型C |  | division_memo |
| 工商执照发证时间 | biz_pridate | DATETIME/日期时间型T |  | biz_pridate |
| 注册地址 | zcdz | VARCHAR/字符串型C |  | zcdz |
| 办公地址 | bgdz | VARCHAR/字符串型C |  | bgdz |
| 法定代表人证件号 | repres_id | VARCHAR/字符串型C |  | repres_id |
| 经办人手机 | dealer_mobile | VARCHAR/字符串型C |  | dealer_mobile |
| 业户状态 | status | INT/整型I |  | status |
| 更新时间 | upd_date | DATETIME/日期时间型T |  | upd_date |

---

<a name="106"></a>
## 106. 111

**表名**: `v_stg_nb_sfgw_nbszdtzxmxx`

### 字段信息

| 中文字段名 | 标准化字段名 | 数据类型 | 样例数据 | 源表字段名 |
| --- | --- | --- | --- | --- |
| 项目名称 | XMMC | CHAR/字符串型C |  | XMMC |
| 建设地点 | JSDQ | CHAR/字符串型C |  | JSDQ |
| 总投资 | ZTZ | DECIMAL/数值型N |  | ZTZ |
| 项目时间 | YEAR | YEAR/日期型D |  | YEAR |
| 入库时间 | CREATETIME | DATETIME/日期时间型T |  | CREATETIME |
| 项目概况 | JSGM | VARCHAR/字符串型C |  | JSGM |
| 编号 | ID | INT/整型I |  | ID |

---

<a name="107"></a>
## 107. 110

**表名**: `v_stg_nb_rsj_sbjyly_cxjmylbzdyxsryxx`

### 字段信息

| 中文字段名 | 标准化字段名 | 数据类型 | 样例数据 | 源表字段名 |
| --- | --- | --- | --- | --- |
| 人员应付计划项目明细ID | AAZ219 | INT/整型I |  | AAZ219 |
| 人员应付计划事件ID | AAZ220 | INT/整型I |  | AAZ220 |
| 待遇项目名称 | AAA037 | VARCHAR/字符串型C |  | AAA037 |
| 费款所属期 | AAE002 | INT/整型I |  | AAE002 |
| 发放金额 | AAE019 | DOUBLE/双精度型B |  | AAE019 |
| 行政区划 | aab301 | VARCHAR/字符串型C |  | aab301 |
| 姓名 | aac003 | VARCHAR/字符串型C |  | aac003 |
| 身份证号 | aac002 | VARCHAR/字符串型C |  | aac002 |
| 对应费款所属期 | aae003 | INT/整型I |  | aae003 |

---

<a name="108"></a>
## 108. 112

**表名**: `v_stg_nb_sfgw_nbsfgwndzdxmmlxx`

**主键**: ID

### 字段信息

| 中文字段名 | 标准化字段名 | 数据类型 | 样例数据 | 源表字段名 |
| --- | --- | --- | --- | --- |
| 项目名称 | XMMC | VARCHAR/字符串型C |  | XMMC |
| 年度 | ND | VARCHAR/字符串型C |  | ND |
| 主键 | ID | INT/整型I |  | ID |
| 备注 | BZ | VARCHAR/字符串型C |  | BZ |

---

<a name="109"></a>
## 109. 113

**表名**: `v_ods_zj_sfzggw_dsc_nb_biz_019_tzxm_approval_form_info_df`

### 字段信息

| 中文字段名 | 标准化字段名 | 数据类型 | 样例数据 | 源表字段名 |
| --- | --- | --- | --- | --- |
| 办件编号 | approval_itemid | VARCHAR/字符串型C |  | approval_itemid |
| 项目代码 | project_code | VARCHAR/字符串型C |  | project_code |
| 属地行政区划代码 | division_code | VARCHAR/字符串型C |  | division_code |
| 事项名称 | item_name | VARCHAR/字符串型C |  | item_name |
| 审批部门 | dept_name | VARCHAR/字符串型C |  | dept_name |
| 审批表单 | approval_form_info | TEXT/长文本text |  | approval_form_info |

---

<a name="110"></a>
## 110. 114

**表名**: `v_ods_zj_sfzggw_dsc_nb_biz_019_fssr_swsb_sl_df`

### 字段信息

| 中文字段名 | 标准化字段名 | 数据类型 | 样例数据 | 源表字段名 |
| --- | --- | --- | --- | --- |
| 审批事项办件号 | uuid | VARCHAR/字符串型C |  | uuid |
| 社会信用代码 | shxydm | VARCHAR/字符串型C |  | shxydm |
| 缴费人名称 | jfrmc | VARCHAR/字符串型C |  | jfrmc |
| 项目名称 | xmmc | VARCHAR/字符串型C |  | xmmc |
| 审批文号 | spwh | VARCHAR/字符串型C |  | spwh |
| 项目计划开工时间 | xmjhkgsj | DATE/日期型D |  | xmjhkgsj |
| 项目审批层级 | xmspcj | VARCHAR/字符串型C |  | xmspcj |
| 征收项目代码 | zsxmdm | VARCHAR/字符串型C |  | zsxmdm |
| 征收项目 | zsxm | VARCHAR/字符串型C |  | zsxm |
| 核定缴费金额 | hdjfje | DOUBLE/双精度型B |  | hdjfje |
| 联系人 | lxr | VARCHAR/字符串型C |  | lxr |
| 联系方式 | lxfs | VARCHAR/字符串型C |  | lxfs |
| 所在市 | szs | VARCHAR/字符串型C |  | szs |
| 导入单位 | drdw | VARCHAR/字符串型C |  | drdw |
| 缴费人类型 | jfrlx | CHAR/字符串型C |  | jfrlx |
| 行政区划代码 | xzqhdm | VARCHAR/字符串型C |  | xzqhdm |
| 街道乡镇 | jdxz | VARCHAR/字符串型C |  | jdxz |
| 更新结果 | gxjg | VARCHAR/字符串型C |  | gxjg |
| 数据同步时间 | sjtbsj | DATETIME/日期时间型T |  | sjtbsj |

---

<a name="111"></a>
## 111. 115

**表名**: `v_ods_zj_sfzggw_dsc_nb_biz_019_tzxm_approve_cert_info_df`

### 字段信息

| 中文字段名 | 标准化字段名 | 数据类型 | 样例数据 | 源表字段名 |
| --- | --- | --- | --- | --- |
| 信息ID | approval_id | VARCHAR/字符串型C |  | approval_id |
| 办件编号 | approval_itemid | VARCHAR/字符串型C |  | approval_itemid |
| 证照名称 | approval_cert_name | VARCHAR/字符串型C |  | approval_cert_name |
| 证照内容 | approval_cert_info | TEXT/长文本text |  | approval_cert_info |
| 审批事项名称 | approval_item_name | VARCHAR/字符串型C |  | approval_item_name |
| 有效标识 | validity_flag | VARCHAR/字符串型C |  | validity_flag |

---

<a name="112"></a>
## 112. 116

**表名**: `省回流_在线平台-投资项目基本信息`

### 字段信息

| 中文字段名 | 标准化字段名 | 数据类型 | 样例数据 | 源表字段名 |
| --- | --- | --- | --- | --- |
| 项目代码 | project_code | VARCHAR/字符串型C |  | project_code |
| 项目名称 | project_name | VARCHAR/字符串型C |  | project_name |
| 项目所属行政区划代码 | division_code | VARCHAR/字符串型C |  | division_code |
| 项目类型 | project_type | VARCHAR/字符串型C |  | project_type |
| 建设性质 | project_nature | VARCHAR/字符串型C |  | project_nature |
| 拟开工时间 | start_year | VARCHAR/字符串型C |  | start_year |
| 拟建成时间 | end_year | VARCHAR/字符串型C |  | end_year |
| 总投资额 | total_money | DECIMAL/数值型N |  | total_money |
| 建设地点区划代码 | place_code | VARCHAR/字符串型C |  | place_code |
| 建设地点详情 | place_code_detail | VARCHAR/字符串型C |  | place_code_detail |
| 国标行业 | industry | VARCHAR/字符串型C |  | industry |
| 国标行业名称 | industry_name | VARCHAR/字符串型C |  | industry_name |
| 建设规模及内容 | scale_content | VARCHAR/字符串型C |  | scale_content |
| 总用地面积 | land_area | DECIMAL/数值型N |  | land_area |
| 总建筑面积 | built_area | DECIMAL/数值型N |  | built_area |
| 项目单位名称 | enterprise_name | VARCHAR/字符串型C |  | enterprise_name |
| 证照类型 | lerep_certtype | VARCHAR/字符串型C |  | lerep_certtype |
| 证照编号 | lerep_certno | VARCHAR/字符串型C |  | lerep_certno |
| 项目负责人 | principal_name | VARCHAR/字符串型C |  | principal_name |
| 负责人电话 | principal_tel | VARCHAR/字符串型C |  | principal_tel |
| 项目联系人 | contact_name | VARCHAR/字符串型C |  | contact_name |
| 联系人电话 | contact_tel | VARCHAR/字符串型C |  | contact_tel |
| 是否为子项目 | is_child_project | VARCHAR/字符串型C |  | is_child_project |
| 赋码时间 | apply_date | VARCHAR/字符串型C |  | apply_date |
| 有效标识 | validity_flag | VARCHAR/字符串型C |  | validity_flag |
| 固定资产投资 | fixedmoney | DECIMAL/数值型N |  | fixedmoney |
| 土建工程费 | civil_fund | DECIMAL/数值型N |  | civil_fund |
| 设备购置费 | device_fund | DECIMAL/数值型N |  | device_fund |
| 安装工程费 | instal_fund | DECIMAL/数值型N |  | instal_fund |
| 工程建设其他费用 | project_other_fund | DECIMAL/数值型N |  | project_other_fund |
| 预备费 | prepare_fund | DECIMAL/数值型N |  | prepare_fund |
| 建设期利息 | buildinterest_fund | DECIMAL/数值型N |  | buildinterest_fund |
| 铺底流动资金 | pavage_fund | DECIMAL/数值型N |  | pavage_fund |
| 自有资金 | equity_fund | DECIMAL/数值型N |  | equity_fund |
| 财政性资金 | gov_invest_fund | DECIMAL/数值型N |  | gov_invest_fund |
| 银行贷款 | bank_loan_fund | DECIMAL/数值型N |  | bank_loan_fund |
| 其他资金 | other_fund | DECIMAL/数值型N |  | other_fund |
| 新增建设用地 | buildingarea | VARCHAR/字符串型C |  | buildingarea |
| 地上建筑面积 | groundbuildingarea | VARCHAR/字符串型C |  | groundbuildingarea |
| 地下建筑面积 | undergroundbuildingarea | VARCHAR/字符串型C |  | undergroundbuildingarea |
| 关联主项目 | parent_project_code | VARCHAR/字符串型C |  | parent_project_code |
| 项目属性 | project_attributes | VARCHAR/字符串型C |  | project_attributes |
| 审核类型 | audit_type | VARCHAR/字符串型C |  | audit_type |
| 是否外资项目 | is_foreign | VARCHAR/字符串型C |  | is_foreign |
| 土地出让合同电子监管号 | landcontractno | VARCHAR/字符串型C |  | landcontractno |
| 操作状态（多表合一） | clean_status | VARCHAR/字符串型C |  | clean_status |

---

<a name="113"></a>
## 113. 117

**表名**: `省回流_在线平台-投资项目办件申报材料信息`

**主键**: APPLY_DOC_ID

### 字段信息

| 中文字段名 | 标准化字段名 | 数据类型 | 样例数据 | 源表字段名 |
| --- | --- | --- | --- | --- |
| 申请材料表主键 | APPLY_DOC_ID | VARCHAR/字符串型C |  | APPLY_DOC_ID |
| 项目代码 | PROJECT_CODE | VARCHAR/字符串型C |  | PROJECT_CODE |
| 办件编号 | APPROVAL_ITEMID | VARCHAR/字符串型C |  | APPROVAL_ITEMID |
| 材料名称 | APPLY_TITLE | VARCHAR/字符串型C |  | APPLY_TITLE |
| 文件名称 | FILE_NAME | VARCHAR/字符串型C |  | FILE_NAME |
| 有效标识 | VALIDITY_FLAG | VARCHAR/字符串型C |  | VALIDITY_FLAG |
| 批文附件地址 | FILE_PATH | VARCHAR/字符串型C |  | FILE_PATH |

---

<a name="114"></a>
## 114. 118

**表名**: `省回流_在线平台-投资项目办件环节信息`

### 字段信息

| 中文字段名 | 标准化字段名 | 数据类型 | 样例数据 | 源表字段名 | 字段描述 |
| --- | --- | --- | --- | --- | --- |
| 办理环节信息ID | APPROVAL_PROCESSID | VARCHAR/字符串型C |  | APPROVAL_PROCESSID | 办理环节信息的唯一标识。 |
| 办件编号 | APPROVAL_ITEMID | VARCHAR/字符串型C |  | APPROVAL_ITEMID | 办件信息唯一标识。 |
| 项目代码 | PROJECT_CODE | VARCHAR/字符串型C |  | PROJECT_CODE |  |
| 办理处（科）室 | HANDLE_DEPT_NAME | VARCHAR/字符串型C |  | HANDLE_DEPT_NAME | 办理处（科）室。 |
| 办理状态 | HANDLE_STATE | VARCHAR/字符串型C |  | HANDLE_STATE | 待受理、 退办、 受理、 不予受理、许可办结、不予许可办结、暂停、注销、废止。 |
| 办理意见 | HANDLE_OPINION | VARCHAR/字符串型C |  | HANDLE_OPINION | 办理意见说明，例如：受理意见、批复意见等。 |
| 特别程序类型 | SPECIAL_TYPE | VARCHAR/字符串型C |  | SPECIAL_TYPE | 暂停状态需填，否则为空。类型包括：补齐材料、补正材料、委托评估、集中办理、专家评审、实地核查、技术审查、委托测量、批准延期、征求意见、验收组评审、海域使用论证、公示、其他种类、听证、异议处理 |
| 办理时间 | HANDLE_DATE | DATETIME/日期时间型T |  | HANDLE_DATE | 格式为：yyyy-mm-dd hh24:mi:ss |
| 有效标识 | VALIDITY_FLAG | VARCHAR/字符串型C |  | VALIDITY_FLAG | 数据有效标识：0无效；1有效。 |

---

<a name="115"></a>
## 115. 130

**表名**: `dw_nb_xsxx`

### 字段信息

| 中文字段名 | 标准化字段名 | 数据类型 | 样例数据 | 源表字段名 |
| --- | --- | --- | --- | --- |
| 学生ID | XSID | VARCHAR/字符串型C |  | XSID |
| 学生姓名 | XSXM | VARCHAR/字符串型C |  | XSXM |
| 身份证件类型 教育部标准代码 | SFZJLX | VARCHAR/字符串型C |  | SFZJLX |
| 身份证件号 | SFZJH | VARCHAR/字符串型C |  | SFZJH |
| 学号 | GRBSM | VARCHAR/字符串型C |  | GRBSM |
| 地区编码 | DQBM | VARCHAR/字符串型C |  | DQBM |
| 地区名称 | DQMC | VARCHAR/字符串型C |  | DQMC |
| 学校标识码 | XXBSM | VARCHAR/字符串型C |  | XXBSM |
| 学校名称 | XXMC | VARCHAR/字符串型C |  | XXMC |
| 年级码 | NJM | VARCHAR/字符串型C |  | NJM |
| 年级名称 | NJMC | VARCHAR/字符串型C |  | NJMC |
| 班级名称 | BJMC | VARCHAR/字符串型C |  | BJMC |
| 专业 | ZY | VARCHAR/字符串型C |  | ZY |
| 学制 | XZ | FLOAT/浮点型F |  | XZ |
| 状态 | XSZT | VARCHAR/字符串型C |  | XSZT |
| 入学年月 | RXNY | VARCHAR/字符串型C |  | RXNY |
| 政治面貌 | ZZMM | VARCHAR/字符串型C |  | ZZMM |
| 学段/层次 | XD | VARCHAR/字符串型C |  | XD |
| 业务系统更新时间 | biztime | DATETIME/日期时间型T |  | biztime |
| 数据同步更新时间 | loadtime | DATETIME/日期时间型T |  | loadtime |
| 时间戳 | tnsvalue | VARCHAR/字符串型C |  | tnsvalue |
| 民族 | mz | VARCHAR/字符串型C |  | mz |

---

<a name="116"></a>
## 116. 131

**表名**: `dw_nb_zzxsxx`

**注意**: 未找到字段信息或字段信息格式不标准

---

<a name="117"></a>
## 117. 132

**表名**: `dw_nb_xqxsxx`

**注意**: 未找到字段信息或字段信息格式不标准

---

<a name="118"></a>
## 118. 133

**表名**: `dw_nb_gxxsxx`

**注意**: 未找到字段信息或字段信息格式不标准

---

<a name="119"></a>
## 119. 134

**表名**: `dw_nb_zxxxsxx`

**注意**: 未找到字段信息或字段信息格式不标准

---

<a name="120"></a>
## 120. 135

**表名**: `dw_nb_xxxx`

**注意**: 未找到字段信息或字段信息格式不标准

---

<a name="121"></a>
## 121. 136

**表名**: `dw_nb_yeyyqxx`

**注意**: 未找到字段信息或字段信息格式不标准

---

<a name="122"></a>
## 122. 137

**表名**: `dw_nb_yeyzyyershzxx`

**注意**: 未找到字段信息或字段信息格式不标准

---

<a name="123"></a>
## 123. 138

**表名**: `dw_nb_jsxx`

**注意**: 未找到字段信息或字段信息格式不标准

---

<a name="124"></a>
## 124. 139

**表名**: `v_ods_dsc_nb_ads_share_jgxw_punish_decision_info_s_d_df`

**注意**: 未找到字段信息或字段信息格式不标准

---

<a name="125"></a>
## 125. 140

**表名**: `v_stg_nb_jtysj_t_jtw_m_qyzzzs_1`

**注意**: 未找到字段信息或字段信息格式不标准

---

<a name="126"></a>
## 126. 141

**表名**: `v_stg_nb_kjj_t_kjj_m_sgczkjxzxqy_1`

**主键**: SERIAL_ID

### 字段信息

| 中文字段名 | 标准化字段名 | 数据类型 | 样例数据 | 源表字段名 |
| --- | --- | --- | --- | --- |
| 主键 | SERIAL_ID | VARCHAR/字符串型C |  | SERIAL_ID |
| 企业名称 | UNIT_NAME | VARCHAR/字符串型C |  | UNIT_NAME |
| 统一信用代码 | CREDIT_CODE | VARCHAR/字符串型C |  | CREDIT_CODE |
| 认定年度 | APPROVED_YEAR | VARCHAR/字符串型C |  | APPROVED_YEAR |
| 级别 | LEVEL | VARCHAR/字符串型C |  | LEVEL |
| 证书编号 | CERTIFICATE_NUMBER | VARCHAR/字符串型C |  | CERTIFICATE_NUMBER |
| 有效期止 | CERTIFICATE_PERIOD_TO | VARCHAR/字符串型C |  | CERTIFICATE_PERIOD_TO |
| 记录创建日期 | CREATE_TIME | VARCHAR/字符串型C |  | CREATE_TIME |
| 记录更新日期 | UPDATE_TIME | VARCHAR/字符串型C |  | UPDATE_TIME |
| 同步时间 | TONG_TIME |  |  | TONG_TIME |
| 操作标识 | CZBS |  |  | CZBS |

---

<a name="127"></a>
## 127. 142

**表名**: `v_stg_nb_JYJ_nbsslswlyqypjxx_df`

**注意**: 未找到字段信息或字段信息格式不标准

---

<a name="128"></a>
## 128. 143

**表名**: `v_ods_e_im_ippldgalt_df`

**主键**: PLEID

### 字段信息

| 中文字段名 | 标准化字段名 | 数据类型 | 样例数据 | 源表字段名 |
| --- | --- | --- | --- | --- |
| 业务主键 | PLEID | VARCHAR/字符串型C |  | PLEID |
| 主体身份代码 | PRIPID | VARCHAR/字符串型C |  | PRIPID |
| 统一社会信用代码 | UNISCID | VARCHAR/字符串型C |  | UNISCID |
| 知识产权登记证号 | TMREGNO | VARCHAR/字符串型C |  | TMREGNO |
| 名称 | TMNAME | VARCHAR/字符串型C |  | TMNAME |
| 种类 | KINDS | VARCHAR/字符串型C |  | KINDS |
| 出质人名称 | PLEDGOR | VARCHAR/字符串型C |  | PLEDGOR |
| 质权人名称 | IMPORG | VARCHAR/字符串型C |  | IMPORG |
| 状态 | TYPE | VARCHAR/字符串型C |  | TYPE |
| 公式日期 | PUBLICDATE |  |  | PUBLICDATE |
| 操作标识 | CD_OPERATION |  |  | CD_OPERATION |
| 该数据记录写入前置库时间 | CD_TIMESC |  |  | CD_TIMESC |

---
