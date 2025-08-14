-- MySQL dump 10.13  Distrib 8.0.43, for Win64 (x86_64)
--
-- Host: localhost    Database: cul_comp
-- ------------------------------------------------------
-- Server version	8.0.43

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `dw_nb_hywlqyxyxx`
--

DROP TABLE IF EXISTS `dw_nb_hywlqyxyxx`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dw_nb_hywlqyxyxx` (
  `UNI_SOCIAL_CRD_CD` varchar(50) NOT NULL COMMENT '统一社会信用代码',
  `CREDIT_CMNT_NM` varchar(100) DEFAULT NULL COMMENT '信用评价名称',
  `CMNT_RESULT` varchar(50) DEFAULT NULL COMMENT '评价结果',
  `CMNT_ORG` varchar(100) DEFAULT NULL COMMENT '评价机构',
  `ASSESS_DT` date DEFAULT NULL COMMENT '评价日期',
  PRIMARY KEY (`UNI_SOCIAL_CRD_CD`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='信用评价信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dw_nb_hywlqyxyxx`
--

LOCK TABLES `dw_nb_hywlqyxyxx` WRITE;
/*!40000 ALTER TABLE `dw_nb_hywlqyxyxx` DISABLE KEYS */;
INSERT INTO `dw_nb_hywlqyxyxx` VALUES ('91330203674737244W','企业信用评价','A级','宁波市市场监督管理局','2023-06-15'),('91330203674737245A','企业信用评价','B级','宁波市市场监督管理局','2023-06-15'),('91330203674737246B','企业信用评价','A级','宁波市市场监督管理局','2023-06-15'),('91330203674737247C','企业信用评价','B级','宁波市市场监督管理局','2023-06-15'),('91330203674737248D','企业信用评价','A级','宁波市市场监督管理局','2023-06-15'),('91330203674737249E','企业信用评价','B级','宁波市市场监督管理局','2023-06-15'),('91330203674737250F','企业信用评价','A级','宁波市市场监督管理局','2023-06-15'),('91330203674737251G','企业信用评价','B级','宁波市市场监督管理局','2023-06-15'),('91330203674737252H','企业信用评价','A级','宁波市市场监督管理局','2023-06-15'),('91330203674737253I','企业信用评价','A级','宁波市市场监督管理局','2023-06-15'),('91330203674737254J','企业信用评价','B级','宁波市市场监督管理局','2023-06-15'),('91330203674737255K','企业信用评价','A级','宁波市市场监督管理局','2023-06-15'),('91330203674737256L','企业信用评价','A级','宁波市市场监督管理局','2023-06-15'),('91330203674737257M','企业信用评价','B级','宁波市市场监督管理局','2023-06-15'),('91330203674737258N','企业信用评价','A级','宁波市市场监督管理局','2023-06-15'),('91330203674737259O','企业信用评价','B级','宁波市市场监督管理局','2023-06-15'),('91330203674737260P','企业信用评价','A级','宁波市市场监督管理局','2023-06-15'),('91330203674737261Q','企业信用评价','B级','宁波市市场监督管理局','2023-06-15'),('91330203674737262R','企业信用评价','A级','宁波市市场监督管理局','2023-06-15'),('91330203674737263S','企业信用评价','B级','宁波市市场监督管理局','2023-06-15'),('91330203674737264T','企业信用评价','A级','宁波市市场监督管理局','2023-06-15'),('91330203674737265U','企业信用评价','A级','宁波市市场监督管理局','2023-06-15'),('91330203674737266V','企业信用评价','B级','宁波市市场监督管理局','2023-06-15'),('91330203674737267W','企业信用评价','A级','宁波市市场监督管理局','2023-06-15'),('91330203674737268X','企业信用评价','A级','宁波市市场监督管理局','2023-06-15'),('91330203674737269Y','企业信用评价','C级','宁波市市场监督管理局','2023-06-15'),('91330203674737270Z','企业信用评价','B级','宁波市市场监督管理局','2023-06-15'),('91330203674737271A','企业信用评价','A级','宁波市市场监督管理局','2023-06-15'),('91330203674737272B','企业信用评价','B级','宁波市市场监督管理局','2023-06-15'),('91330203674737273C','企业信用评价','A级','宁波市市场监督管理局','2023-06-15'),('91330203674737274D','企业信用评价','C级','宁波市市场监督管理局','2023-06-15'),('91330203674737275E','企业信用评价','A级','宁波市市场监督管理局','2023-06-15'),('91330203674737276F','企业信用评价','A级','宁波市市场监督管理局','2023-06-15'),('91330203674737277G','企业信用评价','B级','宁波市市场监督管理局','2023-06-15'),('91330203674737278H','企业信用评价','A级','宁波市市场监督管理局','2023-06-15'),('91330203674737279I','企业信用评价','A级','宁波市市场监督管理局','2023-06-15'),('91330203674737280J','企业信用评价','A级','宁波市市场监督管理局','2023-06-15'),('91330203674737281K','企业信用评价','B级','宁波市市场监督管理局','2023-06-15'),('91330203674737282L','企业信用评价','A级','宁波市市场监督管理局','2023-06-15'),('91330203674737283M','企业信用评价','B级','宁波市市场监督管理局','2023-06-15'),('91330203674737284N','企业信用评价','A级','宁波市市场监督管理局','2023-06-15'),('91330203674737285O','企业信用评价','A级','宁波市市场监督管理局','2023-06-15'),('91330203674737286P','企业信用评价','B级','宁波市市场监督管理局','2023-06-15'),('91330203674737287Q','企业信用评价','C级','宁波市市场监督管理局','2023-06-15'),('91330203674737288R','企业信用评价','A级','宁波市市场监督管理局','2023-06-15'),('91330203674737289S','企业信用评价','A级','宁波市市场监督管理局','2023-06-15'),('91330203674737290T','企业信用评价','A级','宁波市市场监督管理局','2023-06-15'),('91330203674737291U','企业信用评价','B级','宁波市市场监督管理局','2023-06-15'),('91330203674737292V','企业信用评价','C级','宁波市市场监督管理局','2023-06-15'),('91330203674737293W','企业信用评价','A级','宁波市市场监督管理局','2023-06-15');
/*!40000 ALTER TABLE `dw_nb_hywlqyxyxx` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dw_nb_kj_sgczkjxzxqy`
--

DROP TABLE IF EXISTS `dw_nb_kj_sgczkjxzxqy`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dw_nb_kj_sgczkjxzxqy` (
  `UNI_SOCIAL_CRD_CD` varchar(50) NOT NULL COMMENT '统一社会信用代码',
  `CONGNIZ_TEAR` int DEFAULT NULL COMMENT '认定年份',
  `CONGNIZ_ORG` varchar(100) DEFAULT NULL COMMENT '认定机构',
  PRIMARY KEY (`UNI_SOCIAL_CRD_CD`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='科技型小微企业信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dw_nb_kj_sgczkjxzxqy`
--

LOCK TABLES `dw_nb_kj_sgczkjxzxqy` WRITE;
/*!40000 ALTER TABLE `dw_nb_kj_sgczkjxzxqy` DISABLE KEYS */;
INSERT INTO `dw_nb_kj_sgczkjxzxqy` VALUES ('91330203674737247C',2023,'宁波市海曙区科技局'),('91330203674737248D',2022,'宁波市海曙区科技局'),('91330203674737256L',2023,'宁波市北仑区科技局'),('91330203674737258N',2021,'宁波市北仑区科技局'),('91330203674737274D',2022,'宁波市科技局'),('91330203674737275E',2023,'余姚市科技局'),('91330203674737276F',2021,'余姚市科技局'),('91330203674737277G',2023,'余姚市科技局'),('91330203674737278H',2022,'余姚市科技局'),('91330203674737284N',2023,'宁海县科技局'),('91330203674737286P',2022,'宁海县科技局'),('91330203674737288R',2023,'宁海县科技局'),('91330203674737290T',2021,'象山县科技局'),('91330203674737292V',2023,'象山县科技局'),('91330203674737293W',2022,'象山县科技局');
/*!40000 ALTER TABLE `dw_nb_kj_sgczkjxzxqy` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dw_nb_rlsb_cbgryjsybxfhdxx`
--

DROP TABLE IF EXISTS `dw_nb_rlsb_cbgryjsybxfhdxx`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dw_nb_rlsb_cbgryjsybxfhdxx` (
  `UNI_SOCIAL_CRD_CD` varchar(50) NOT NULL COMMENT '统一社会信用代码',
  `INSUR_TYPE` varchar(50) DEFAULT NULL COMMENT '险种类型',
  `PAY_MONS` int DEFAULT NULL COMMENT '缴费月数',
  `PER_PAY_BASE` decimal(10,2) DEFAULT NULL COMMENT '个人缴费基数',
  `PAY_AMT` decimal(10,2) DEFAULT NULL COMMENT '缴费金额',
  `CORP_PAY_AMT` decimal(10,2) DEFAULT NULL COMMENT '单位缴费金额',
  `PER_PAY_AMT` decimal(10,2) DEFAULT NULL COMMENT '个人缴费金额',
  `FEE_PERIOD` varchar(10) DEFAULT NULL COMMENT '缴费期间',
  PRIMARY KEY (`UNI_SOCIAL_CRD_CD`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='社保缴费明细表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dw_nb_rlsb_cbgryjsybxfhdxx`
--

LOCK TABLES `dw_nb_rlsb_cbgryjsybxfhdxx` WRITE;
/*!40000 ALTER TABLE `dw_nb_rlsb_cbgryjsybxfhdxx` DISABLE KEYS */;
/*!40000 ALTER TABLE `dw_nb_rlsb_cbgryjsybxfhdxx` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dw_nb_rlsb_sbjylyshbxjbxx`
--

DROP TABLE IF EXISTS `dw_nb_rlsb_sbjylyshbxjbxx`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dw_nb_rlsb_sbjylyshbxjbxx` (
  `UNI_SOCIAL_CRD_CD` varchar(50) NOT NULL COMMENT '统一社会信用代码',
  `PENS_NUM` int DEFAULT NULL COMMENT '养老保险人数',
  `MEDIC_NUM` int DEFAULT NULL COMMENT '医疗保险人数',
  `UNEMPLOY_NUM` int DEFAULT NULL COMMENT '失业保险人数',
  `INJURY_NUM` int DEFAULT NULL COMMENT '工伤保险人数',
  `MATERNI_NUM` int DEFAULT NULL COMMENT '生育保险人数',
  `PENS_PAY_YM` varchar(10) DEFAULT NULL COMMENT '养老保险缴费年月',
  `MEDIC_PAY_YM` varchar(10) DEFAULT NULL COMMENT '医疗保险缴费年月',
  PRIMARY KEY (`UNI_SOCIAL_CRD_CD`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='社保信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dw_nb_rlsb_sbjylyshbxjbxx`
--

LOCK TABLES `dw_nb_rlsb_sbjylyshbxjbxx` WRITE;
/*!40000 ALTER TABLE `dw_nb_rlsb_sbjylyshbxjbxx` DISABLE KEYS */;
/*!40000 ALTER TABLE `dw_nb_rlsb_sbjylyshbxjbxx` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dw_nb_scjdgl_dwtgbzdbxx`
--

DROP TABLE IF EXISTS `dw_nb_scjdgl_dwtgbzdbxx`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dw_nb_scjdgl_dwtgbzdbxx` (
  `UNI_SOCIAL_CRD_CD` varchar(50) NOT NULL COMMENT '统一社会信用代码',
  `EXTERNAL_GUA` varchar(10) DEFAULT NULL COMMENT '对外担保标识',
  `CREDITOR` varchar(200) DEFAULT NULL COMMENT '债权人',
  `DEBTOR` varchar(200) DEFAULT NULL COMMENT '债务人',
  `MAJOR_CREDIT_AMT` decimal(15,2) DEFAULT NULL COMMENT '担保金额',
  `PERIOD_FROM` date DEFAULT NULL COMMENT '担保起始日期',
  `PERIOD_TO` date DEFAULT NULL COMMENT '担保截止日期',
  PRIMARY KEY (`UNI_SOCIAL_CRD_CD`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='对外担保信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dw_nb_scjdgl_dwtgbzdbxx`
--

LOCK TABLES `dw_nb_scjdgl_dwtgbzdbxx` WRITE;
/*!40000 ALTER TABLE `dw_nb_scjdgl_dwtgbzdbxx` DISABLE KEYS */;
INSERT INTO `dw_nb_scjdgl_dwtgbzdbxx` VALUES ('91330203674737244W','是','宁波银行','宁波江北旅游开发有限公司',1000000.00,'2023-01-01','2024-12-31'),('91330203674737246B','是','中国银行','宁波镇海体育健身有限公司',500000.00,'2023-03-01','2024-02-28'),('91330203674737248D','是','工商银行','余姚影视制作有限公司',800000.00,'2023-06-01','2024-05-31'),('91330203674737250F','是','建设银行','慈溪温泉度假有限公司',1500000.00,'2023-02-01','2024-01-31'),('91330203674737252H','是','农业银行','宁海民宿客栈有限公司',600000.00,'2023-04-01','2024-03-31'),('91330203674737254J','是','交通银行','象山主题公园有限公司',1200000.00,'2023-05-01','2024-04-30'),('91330203674737256L','是','招商银行','宁波海曙广告设计有限公司',400000.00,'2023-07-01','2024-06-30'),('91330203674737258N','是','浦发银行','宁波北仑健身俱乐部有限公司',700000.00,'2023-08-01','2024-07-31'),('91330203674737260P','是','中信银行','宁波镇海保健服务有限公司',300000.00,'2023-09-01','2024-08-31'),('91330203674737262R','是','光大银行','宁波鄞州会展服务有限公司',900000.00,'2023-10-01','2024-09-30'),('91330203674737264T','是','华夏银行','宁波奉化工艺品有限公司',200000.00,'2023-11-01','2024-10-31'),('91330203674737266V','是','民生银行','余姚动漫制作有限公司',1100000.00,'2023-12-01','2024-11-30'),('91330203674737268X','是','兴业银行','慈溪度假酒店有限公司',1300000.00,'2024-01-01','2024-12-31'),('91330203674737270Z','是','平安银行','宁海乡村旅游有限公司',800000.00,'2024-02-01','2025-01-31'),('91330203674737272B','是','广发银行','象山海洋旅游有限公司',1000000.00,'2024-03-01','2025-02-28');
/*!40000 ALTER TABLE `dw_nb_scjdgl_dwtgbzdbxx` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dw_nb_scjdgl_gqbg`
--

DROP TABLE IF EXISTS `dw_nb_scjdgl_gqbg`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dw_nb_scjdgl_gqbg` (
  `UNI_SOCIAL_CRD_CD` varchar(50) NOT NULL COMMENT '统一社会信用代码',
  `ALT_DT` date DEFAULT NULL COMMENT '股权变更日期',
  `INV` varchar(100) DEFAULT NULL COMMENT '投资人姓名',
  `TRANSAMPR_BF` decimal(5,2) DEFAULT NULL COMMENT '变更前股权比例',
  `TRANSAMPR_AF` decimal(5,2) DEFAULT NULL COMMENT '变更后股权比例',
  PRIMARY KEY (`UNI_SOCIAL_CRD_CD`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='股权变更信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dw_nb_scjdgl_gqbg`
--

LOCK TABLES `dw_nb_scjdgl_gqbg` WRITE;
/*!40000 ALTER TABLE `dw_nb_scjdgl_gqbg` DISABLE KEYS */;
INSERT INTO `dw_nb_scjdgl_gqbg` VALUES ('91330203674737244W','2023-05-20','宁波投资集团',60.00,80.00),('91330203674737246B','2023-08-15','浙江文化投资有限公司',40.00,60.00),('91330203674737248D','2023-11-10','宁波影视投资有限公司',50.00,70.00),('91330203674737250F','2023-06-25','浙江酒店投资集团',55.00,75.00),('91330203674737252H','2023-09-18','宁波餐饮投资有限公司',45.00,65.00),('91330203674737254J','2023-12-05','浙江娱乐投资有限公司',40.00,60.00),('91330203674737256L','2023-07-30','宁波体育投资有限公司',50.00,70.00),('91330203674737258N','2023-10-12','浙江健身投资集团',35.00,55.00),('91330203674737260P','2023-04-15','宁波保健投资有限公司',60.00,80.00),('91330203674737262R','2023-08-28','浙江瑜伽投资有限公司',40.00,60.00),('91330203674737264T','2023-11-20','宁波会展投资有限公司',50.00,70.00),('91330203674737266V','2023-06-10','浙江展览投资集团',45.00,65.00),('91330203674737268X','2023-09-25','宁波文化传播投资有限公司',55.00,75.00),('91330203674737270Z','2023-12-18','浙江艺术品投资有限公司',40.00,60.00),('91330203674737272B','2023-07-05','宁波传统工艺投资有限公司',50.00,70.00),('91330203674737274D','2023-10-30','浙江影视投资集团',45.00,65.00),('91330203674737276F','2023-05-12','宁波游戏投资有限公司',55.00,75.00),('91330203674737278H','2023-08-22','浙江文化科技投资有限公司',40.00,60.00),('91330203674737280J','2023-11-15','宁波度假投资集团',50.00,70.00),('91330203674737282L','2023-06-28','浙江温泉投资有限公司',45.00,65.00),('91330203674737284N','2023-09-08','宁波民宿投资有限公司',55.00,75.00),('91330203674737286P','2023-12-25','浙江生态旅游投资集团',40.00,60.00),('91330203674737288R','2023-07-18','宁波森林旅游投资有限公司',50.00,70.00),('91330203674737290T','2023-10-05','浙江海洋旅游投资有限公司',45.00,65.00),('91330203674737292V','2023-05-30','宁波渔家乐投资集团',55.00,75.00);
/*!40000 ALTER TABLE `dw_nb_scjdgl_gqbg` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dw_nb_scjdgl_qynbwzhwdxx`
--

DROP TABLE IF EXISTS `dw_nb_scjdgl_qynbwzhwdxx`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dw_nb_scjdgl_qynbwzhwdxx` (
  `UNI_SOCIAL_CRD_CD` varchar(50) NOT NULL COMMENT '统一社会信用代码',
  `WEB_ID` varchar(50) DEFAULT NULL COMMENT '网站标识',
  `WEB_STORE_NM` varchar(200) DEFAULT NULL COMMENT '网站（网店）名称',
  `WEB_STORE_URL` varchar(500) DEFAULT NULL COMMENT '网站（网店）网址',
  `WEB_STORE_TYPE` varchar(50) DEFAULT NULL COMMENT '网站类型',
  `ECOM_TYPE` varchar(50) DEFAULT NULL COMMENT '电商类型',
  PRIMARY KEY (`UNI_SOCIAL_CRD_CD`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='网站网店信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dw_nb_scjdgl_qynbwzhwdxx`
--

LOCK TABLES `dw_nb_scjdgl_qynbwzhwdxx` WRITE;
/*!40000 ALTER TABLE `dw_nb_scjdgl_qynbwzhwdxx` DISABLE KEYS */;
INSERT INTO `dw_nb_scjdgl_qynbwzhwdxx` VALUES ('91330203674737244W','WEB001','宁波海曙文化传媒官网','http://www.nbwhcm.com','企业官网','B2B'),('91330203674737245A','WEB002','宁波海曙广告设计官网','http://www.nbggsj.com','企业官网','B2B'),('91330203674737246B','WEB003','宁波海曙会展服务官网','http://www.nbhzfw.com','企业官网','B2B'),('91330203674737247C','WEB004','宁波海曙数字媒体官网','http://www.nbszmt.com','企业官网','B2B'),('91330203674737248D','WEB005','宁波海曙影视制作官网','http://www.nbyszz.com','企业官网','B2B'),('91330203674737249E','WEB006','宁波江北旅游网店','http://www.nbly.com','网店','B2C'),('91330203674737250F','WEB007','宁波江北酒店管理官网','http://www.nbjdgl.com','企业官网','B2B'),('91330203674737251G','WEB008','宁波江北旅行社官网','http://www.nblxs.com','企业官网','B2B'),('91330203674737252H','WEB009','宁波江北餐饮服务官网','http://www.nbcyfw.com','企业官网','B2B'),('91330203674737253I','WEB010','宁波江北景区管理官网','http://www.nbjqgl.com','企业官网','B2B'),('91330203674737254J','WEB011','北仑娱乐休闲平台','http://www.blentertainment.com','平台网站','O2O'),('91330203674737255K','WEB012','北仑健身俱乐部官网','http://www.bljsjlb.com','企业官网','B2C'),('91330203674737256L','WEB013','北仑体育产业官网','http://www.bltycy.com','企业官网','B2B'),('91330203674737257M','WEB014','北仑KTV娱乐官网','http://www.blktv.com','企业官网','B2C'),('91330203674737258N','WEB015','北仑游泳馆官网','http://www.blyyg.com','企业官网','B2C'),('91330203674737259O','WEB016','镇海体育健身官网','http://www.zhsports.com','企业官网','B2C'),('91330203674737260P','WEB017','镇海保健服务官网','http://www.zhbjfw.com','企业官网','B2C'),('91330203674737261Q','WEB018','镇海运动培训官网','http://www.zhydpx.com','企业官网','B2C'),('91330203674737262R','WEB019','镇海瑜伽馆官网','http://www.zhyjg.com','企业官网','B2C'),('91330203674737263S','WEB020','镇海武术培训官网','http://www.zhwspx.com','企业官网','B2C'),('91330203674737264T','WEB021','鄞州会展服务网','http://www.yzhzfw.com','企业官网','B2B'),('91330203674737265U','WEB022','鄞州会议中心官网','http://www.yzhyzx.com','企业官网','B2B'),('91330203674737266V','WEB023','鄞州展览策划官网','http://www.yzzlch.com','企业官网','B2B'),('91330203674737267W','WEB024','鄞州商务服务官网','http://www.yzswfw.com','企业官网','B2B'),('91330203674737268X','WEB025','鄞州文化传播官网','http://www.yzwhcb.com','企业官网','B2B'),('91330203674737269Y','WEB026','奉化工艺品网店','http://www.fhgyp.com','网店','B2C'),('91330203674737270Z','WEB027','奉化艺术品官网','http://www.fhysp.com','企业官网','B2B'),('91330203674737271A','WEB028','奉化文化创意官网','http://www.fhwhcy.com','企业官网','B2B'),('91330203674737272B','WEB029','奉化传统工艺官网','http://www.fhctgy.com','企业官网','B2B'),('91330203674737273C','WEB030','奉化文创产品官网','http://www.fhwccp.com','企业官网','B2B'),('91330203674737274D','WEB031','余姚影视制作官网','http://www.yyyszz.com','企业官网','B2B'),('91330203674737275E','WEB032','余姚动漫制作官网','http://www.yydmzz.com','企业官网','B2B'),('91330203674737276F','WEB033','余姚游戏开发官网','http://www.yyyxkf.com','企业官网','B2B'),('91330203674737277G','WEB034','余姚数字媒体官网','http://www.yyszmt.com','企业官网','B2B'),('91330203674737278H','WEB035','余姚文化科技官网','http://www.yywhkj.com','企业官网','B2B'),('91330203674737279I','WEB036','慈溪温泉度假官网','http://www.cxwqdj.com','企业官网','B2B'),('91330203674737280J','WEB037','慈溪度假酒店官网','http://www.cxdjjd.com','企业官网','B2B'),('91330203674737281K','WEB038','慈溪休闲娱乐官网','http://www.cxxyyl.com','企业官网','B2B'),('91330203674737282L','WEB039','慈溪温泉养生官网','http://www.cxwqys.com','企业官网','B2B'),('91330203674737283M','WEB040','慈溪文化休闲官网','http://www.cxwhxx.com','企业官网','B2B'),('91330203674737284N','WEB041','宁海民宿客栈官网','http://www.nhmzkz.com','企业官网','B2B'),('91330203674737285O','WEB042','宁海乡村旅游官网','http://www.nhxclv.com','企业官网','B2B'),('91330203674737286P','WEB043','宁海生态旅游官网','http://www.nhstlv.com','企业官网','B2B'),('91330203674737287Q','WEB044','宁海农家乐官网','http://www.nhnjl.com','企业官网','B2B'),('91330203674737288R','WEB045','宁海森林旅游官网','http://www.nhslv.com','企业官网','B2B'),('91330203674737289S','WEB046','象山主题公园官网','http://www.xsztgy.com','企业官网','B2B'),('91330203674737290T','WEB047','象山海洋旅游官网','http://www.xshylv.com','企业官网','B2B'),('91330203674737291U','WEB048','象山海岛度假官网','http://www.xshddj.com','企业官网','B2B'),('91330203674737292V','WEB049','象山渔家乐官网','http://www.xsyjl.com','企业官网','B2B'),('91330203674737293W','WEB050','象山滨海娱乐官网','http://www.xsbhyl.com','企业官网','B2B');
/*!40000 ALTER TABLE `dw_nb_scjdgl_qynbwzhwdxx` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dw_nb_scjdgl_qynbzcxx`
--

DROP TABLE IF EXISTS `dw_nb_scjdgl_qynbzcxx`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dw_nb_scjdgl_qynbzcxx` (
  `UNI_SOCIAL_CRD_CD` varchar(50) NOT NULL COMMENT '统一社会信用代码',
  `ANNUAL_YEAR` int DEFAULT NULL COMMENT '年报年度',
  `ASSET_ZMT` decimal(15,2) DEFAULT NULL COMMENT '资产总额',
  `DEBT_AMT` decimal(15,2) DEFAULT NULL COMMENT '负债总额',
  `OWNER_EQUITY_TOATAL` decimal(15,2) DEFAULT NULL COMMENT '所有者权益',
  `OPT_INCOME_TOTAL` decimal(15,2) DEFAULT NULL COMMENT '营业总收入',
  `PROFIT_TOTAL` decimal(15,2) DEFAULT NULL COMMENT '利润总额',
  `NET_PROFIT` decimal(15,2) DEFAULT NULL COMMENT '净利润',
  `TAX_TOTAL` decimal(15,2) DEFAULT NULL COMMENT '纳税总额',
  PRIMARY KEY (`UNI_SOCIAL_CRD_CD`),
  KEY `idx_year` (`ANNUAL_YEAR`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='企业年报资产信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dw_nb_scjdgl_qynbzcxx`
--

LOCK TABLES `dw_nb_scjdgl_qynbzcxx` WRITE;
/*!40000 ALTER TABLE `dw_nb_scjdgl_qynbzcxx` DISABLE KEYS */;
INSERT INTO `dw_nb_scjdgl_qynbzcxx` VALUES ('91330203674737244W',2023,5000000.00,2000000.00,3000000.00,8000000.00,1200000.00,900000.00,400000.00),('91330203674737245A',2023,3000000.00,1200000.00,1800000.00,5000000.00,800000.00,600000.00,250000.00),('91330203674737246B',2023,8000000.00,3200000.00,4800000.00,12000000.00,1800000.00,1350000.00,600000.00),('91330203674737247C',2023,2000000.00,800000.00,1200000.00,3000000.00,500000.00,375000.00,150000.00),('91330203674737248D',2023,6000000.00,2400000.00,3600000.00,9000000.00,1350000.00,1012500.00,450000.00),('91330203674737249E',2023,3000000.00,1200000.00,1800000.00,5000000.00,800000.00,600000.00,250000.00),('91330203674737250F',2023,15000000.00,6000000.00,9000000.00,20000000.00,3000000.00,2250000.00,1000000.00),('91330203674737251G',2023,5000000.00,2000000.00,3000000.00,8000000.00,1200000.00,900000.00,400000.00),('91330203674737252H',2023,8000000.00,3200000.00,4800000.00,12000000.00,1800000.00,1350000.00,600000.00),('91330203674737253I',2023,12000000.00,4800000.00,7200000.00,18000000.00,2700000.00,2025000.00,900000.00),('91330203674737254J',2023,8000000.00,3200000.00,4800000.00,12000000.00,1800000.00,1350000.00,600000.00),('91330203674737255K',2023,4000000.00,1600000.00,2400000.00,6000000.00,900000.00,675000.00,300000.00),('91330203674737256L',2023,10000000.00,4000000.00,6000000.00,15000000.00,2250000.00,1687500.00,750000.00),('91330203674737257M',2023,6000000.00,2400000.00,3600000.00,9000000.00,1350000.00,1012500.00,450000.00),('91330203674737258N',2023,15000000.00,6000000.00,9000000.00,20000000.00,3000000.00,2250000.00,1000000.00),('91330203674737259O',2023,2000000.00,800000.00,1200000.00,3000000.00,500000.00,375000.00,150000.00),('91330203674737260P',2023,3000000.00,1200000.00,1800000.00,5000000.00,800000.00,600000.00,250000.00),('91330203674737261Q',2023,5000000.00,2000000.00,3000000.00,8000000.00,1200000.00,900000.00,400000.00),('91330203674737262R',2023,4000000.00,1600000.00,2400000.00,6000000.00,900000.00,675000.00,300000.00),('91330203674737263S',2023,3000000.00,1200000.00,1800000.00,5000000.00,800000.00,600000.00,250000.00),('91330203674737264T',2023,6000000.00,2400000.00,3600000.00,9000000.00,1350000.00,1012500.00,450000.00),('91330203674737265U',2023,8000000.00,3200000.00,4800000.00,12000000.00,1800000.00,1350000.00,600000.00),('91330203674737266V',2023,5000000.00,2000000.00,3000000.00,8000000.00,1200000.00,900000.00,400000.00),('91330203674737267W',2023,4000000.00,1600000.00,2400000.00,6000000.00,900000.00,675000.00,300000.00),('91330203674737268X',2023,7000000.00,2800000.00,4200000.00,10000000.00,1500000.00,1125000.00,500000.00),('91330203674737269Y',2023,1500000.00,600000.00,900000.00,2000000.00,300000.00,225000.00,100000.00),('91330203674737270Z',2023,3000000.00,1200000.00,1800000.00,5000000.00,800000.00,600000.00,250000.00),('91330203674737271A',2023,5000000.00,2000000.00,3000000.00,8000000.00,1200000.00,900000.00,400000.00),('91330203674737272B',2023,2000000.00,800000.00,1200000.00,3000000.00,500000.00,375000.00,150000.00),('91330203674737273C',2023,4000000.00,1600000.00,2400000.00,6000000.00,900000.00,675000.00,300000.00),('91330203674737274D',2023,10000000.00,4000000.00,6000000.00,15000000.00,2250000.00,1687500.00,750000.00),('91330203674737275E',2023,8000000.00,3200000.00,4800000.00,12000000.00,1800000.00,1350000.00,600000.00),('91330203674737276F',2023,12000000.00,4800000.00,7200000.00,18000000.00,2700000.00,2025000.00,900000.00),('91330203674737277G',2023,6000000.00,2400000.00,3600000.00,9000000.00,1350000.00,1012500.00,450000.00),('91330203674737278H',2023,9000000.00,3600000.00,5400000.00,14000000.00,2100000.00,1575000.00,700000.00),('91330203674737279I',2023,20000000.00,8000000.00,12000000.00,30000000.00,4500000.00,3375000.00,1500000.00),('91330203674737280J',2023,15000000.00,6000000.00,9000000.00,20000000.00,3000000.00,2250000.00,1000000.00),('91330203674737281K',2023,8000000.00,3200000.00,4800000.00,12000000.00,1800000.00,1350000.00,600000.00),('91330203674737282L',2023,12000000.00,4800000.00,7200000.00,18000000.00,2700000.00,2025000.00,900000.00),('91330203674737283M',2023,6000000.00,2400000.00,3600000.00,9000000.00,1350000.00,1012500.00,450000.00),('91330203674737284N',2023,4000000.00,1600000.00,2400000.00,6000000.00,900000.00,675000.00,300000.00),('91330203674737285O',2023,8000000.00,3200000.00,4800000.00,12000000.00,1800000.00,1350000.00,600000.00),('91330203674737286P',2023,5000000.00,2000000.00,3000000.00,8000000.00,1200000.00,900000.00,400000.00),('91330203674737287Q',2023,3000000.00,1200000.00,1800000.00,5000000.00,800000.00,600000.00,250000.00),('91330203674737288R',2023,6000000.00,2400000.00,3600000.00,9000000.00,1350000.00,1012500.00,450000.00),('91330203674737289S',2023,15000000.00,6000000.00,9000000.00,25000000.00,3750000.00,2812500.00,1250000.00),('91330203674737290T',2023,10000000.00,4000000.00,6000000.00,15000000.00,2250000.00,1687500.00,750000.00),('91330203674737291U',2023,12000000.00,4800000.00,7200000.00,18000000.00,2700000.00,2025000.00,900000.00),('91330203674737292V',2023,8000000.00,3200000.00,4800000.00,12000000.00,1800000.00,1350000.00,600000.00),('91330203674737293W',2023,9000000.00,3600000.00,5400000.00,14000000.00,2100000.00,1575000.00,700000.00);
/*!40000 ALTER TABLE `dw_nb_scjdgl_qynbzcxx` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dw_nb_scjdgl_xzcfgsxx`
--

DROP TABLE IF EXISTS `dw_nb_scjdgl_xzcfgsxx`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dw_nb_scjdgl_xzcfgsxx` (
  `UNI_SOCIAL_CRD_CD` varchar(50) NOT NULL COMMENT '统一社会信用代码',
  `ADMIN_PUNISH_DOC` varchar(100) DEFAULT NULL COMMENT '行政处罚决定书文号',
  `PUNISH_REA` varchar(500) DEFAULT NULL COMMENT '处罚事由',
  `PUNISH_DT` date DEFAULT NULL COMMENT '处罚日期',
  `PUNISH_RESULT` varchar(200) DEFAULT NULL COMMENT '处罚结果',
  PRIMARY KEY (`UNI_SOCIAL_CRD_CD`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='行政处罚信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dw_nb_scjdgl_xzcfgsxx`
--

LOCK TABLES `dw_nb_scjdgl_xzcfgsxx` WRITE;
/*!40000 ALTER TABLE `dw_nb_scjdgl_xzcfgsxx` DISABLE KEYS */;
/*!40000 ALTER TABLE `dw_nb_scjdgl_xzcfgsxx` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dw_nb_scjdgl_xzxk`
--

DROP TABLE IF EXISTS `dw_nb_scjdgl_xzxk`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dw_nb_scjdgl_xzxk` (
  `UNI_SOCIAL_CRD_CD` varchar(50) NOT NULL COMMENT '统一社会信用代码',
  `LIC_NO` varchar(100) DEFAULT NULL COMMENT '许可证号',
  `LIC_NM` varchar(200) DEFAULT NULL COMMENT '许可证名称',
  `LIC_ANTH` varchar(100) DEFAULT NULL COMMENT '发证机关',
  `VAL_FROM` date DEFAULT NULL COMMENT '有效期起',
  `VAL_TO` date DEFAULT NULL COMMENT '有效期止',
  PRIMARY KEY (`UNI_SOCIAL_CRD_CD`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='行政许可信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dw_nb_scjdgl_xzxk`
--

LOCK TABLES `dw_nb_scjdgl_xzxk` WRITE;
/*!40000 ALTER TABLE `dw_nb_scjdgl_xzxk` DISABLE KEYS */;
/*!40000 ALTER TABLE `dw_nb_scjdgl_xzxk` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dw_nb_sw_sbjnxx`
--

DROP TABLE IF EXISTS `dw_nb_sw_sbjnxx`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dw_nb_sw_sbjnxx` (
  `UNI_SOCIAL_CRD_CD` varchar(50) NOT NULL COMMENT '统一社会信用代码',
  `PAID_AMT` decimal(15,2) DEFAULT NULL COMMENT '实缴金额',
  `COLL_ITEM` varchar(200) DEFAULT NULL COMMENT '征收项目',
  `PERIOD_FROM` date DEFAULT NULL COMMENT '征收期间起',
  `PERIOD_TO` date DEFAULT NULL COMMENT '征收期间止',
  PRIMARY KEY (`UNI_SOCIAL_CRD_CD`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='纳税信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dw_nb_sw_sbjnxx`
--

LOCK TABLES `dw_nb_sw_sbjnxx` WRITE;
/*!40000 ALTER TABLE `dw_nb_sw_sbjnxx` DISABLE KEYS */;
/*!40000 ALTER TABLE `dw_nb_sw_sbjnxx` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dw_nb_sw_xypjxxa`
--

DROP TABLE IF EXISTS `dw_nb_sw_xypjxxa`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dw_nb_sw_xypjxxa` (
  `UNI_SOCIAL_CRD_CD` varchar(50) NOT NULL COMMENT '统一社会信用代码',
  `TAX_CREDI_LEVEL` varchar(10) DEFAULT NULL COMMENT '纳税信用等级',
  `EVAL_ORG` varchar(100) DEFAULT NULL COMMENT '评价机构',
  `EVAL_DT` date DEFAULT NULL COMMENT '评价日期',
  PRIMARY KEY (`UNI_SOCIAL_CRD_CD`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='A级纳税人信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dw_nb_sw_xypjxxa`
--

LOCK TABLES `dw_nb_sw_xypjxxa` WRITE;
/*!40000 ALTER TABLE `dw_nb_sw_xypjxxa` DISABLE KEYS */;
/*!40000 ALTER TABLE `dw_nb_sw_xypjxxa` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dw_nb_swbgxx`
--

DROP TABLE IF EXISTS `dw_nb_swbgxx`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dw_nb_swbgxx` (
  `UNI_SOCIAL_CRD_CD` varchar(50) NOT NULL COMMENT '统一社会信用代码',
  `CHAN_DT` date DEFAULT NULL COMMENT '变更日期',
  `CHAN_PROJECT` varchar(100) DEFAULT NULL COMMENT '变更项目',
  `CHAN_BEF_TEXT` text COMMENT '变更前内容',
  `CHAN_AFT_TEXT` text COMMENT '变更后内容',
  PRIMARY KEY (`UNI_SOCIAL_CRD_CD`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='企业变更信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dw_nb_swbgxx`
--

LOCK TABLES `dw_nb_swbgxx` WRITE;
/*!40000 ALTER TABLE `dw_nb_swbgxx` DISABLE KEYS */;
/*!40000 ALTER TABLE `dw_nb_swbgxx` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dw_shl_qywlxsxcpxx`
--

DROP TABLE IF EXISTS `dw_shl_qywlxsxcpxx`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dw_shl_qywlxsxcpxx` (
  `UNI_SOCIAL_CRD_CD` varchar(50) NOT NULL COMMENT '统一社会信用代码',
  `EXECUTE_COURT` varchar(100) DEFAULT NULL COMMENT '执行法院',
  `EXECUTE_AMT` decimal(15,2) DEFAULT NULL COMMENT '执行金额',
  `NOT_EXECUTE_AMT` decimal(15,2) DEFAULT NULL COMMENT '未执行金额',
  `FILING_DT` date DEFAULT NULL COMMENT '立案日期',
  PRIMARY KEY (`UNI_SOCIAL_CRD_CD`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='失信被执行人信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dw_shl_qywlxsxcpxx`
--

LOCK TABLES `dw_shl_qywlxsxcpxx` WRITE;
/*!40000 ALTER TABLE `dw_shl_qywlxsxcpxx` DISABLE KEYS */;
INSERT INTO `dw_shl_qywlxsxcpxx` VALUES ('91330203674737247C','宁波市海曙区人民法院',40000.00,40000.00,'2023-06-20'),('91330203674737258N','宁波市北仑区人民法院',60000.00,60000.00,'2023-07-25'),('91330203674737262R','宁波市镇海区人民法院',35000.00,35000.00,'2023-08-30'),('91330203674737266V','宁波市鄞州区人民法院',45000.00,45000.00,'2023-09-05'),('91330203674737269Y','宁波市海曙区人民法院',50000.00,50000.00,'2023-02-15'),('91330203674737270Z','宁波市奉化区人民法院',25000.00,25000.00,'2023-10-10'),('91330203674737274D','余姚市人民法院',100000.00,80000.00,'2023-04-20'),('91330203674737276F','余姚市人民法院',120000.00,100000.00,'2023-11-15'),('91330203674737287Q','宁海县人民法院',30000.00,30000.00,'2023-03-10'),('91330203674737292V','象山县人民法院',80000.00,60000.00,'2023-05-15');
/*!40000 ALTER TABLE `dw_shl_qywlxsxcpxx` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dw_zj_scjdgl_fddbrxx`
--

DROP TABLE IF EXISTS `dw_zj_scjdgl_fddbrxx`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dw_zj_scjdgl_fddbrxx` (
  `UNI_SOCIAL_CRD_CD` varchar(50) NOT NULL COMMENT '统一社会信用代码',
  `NM` varchar(50) DEFAULT NULL COMMENT '姓名',
  `CER_NO` varchar(20) DEFAULT NULL COMMENT '身份证件号码',
  `TEL_NUM` varchar(20) DEFAULT NULL COMMENT '固定电话',
  `MOBTEL` varchar(20) DEFAULT NULL COMMENT '移动电话',
  `EMAIL` varchar(100) DEFAULT NULL COMMENT '电子邮箱',
  `POSITION_CN` varchar(50) DEFAULT NULL COMMENT '职务（中文名称）',
  `LEREP_SIGN` tinyint DEFAULT NULL COMMENT '法定代表人标志',
  PRIMARY KEY (`UNI_SOCIAL_CRD_CD`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='法定代表人信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dw_zj_scjdgl_fddbrxx`
--

LOCK TABLES `dw_zj_scjdgl_fddbrxx` WRITE;
/*!40000 ALTER TABLE `dw_zj_scjdgl_fddbrxx` DISABLE KEYS */;
INSERT INTO `dw_zj_scjdgl_fddbrxx` VALUES ('91330203674737244W','张伟','330203198501011234','0574-87212345','13800138001','zhangwei@company.com','法定代表人',1),('91330203674737245A','李明','330203198502021345','0574-87212346','13800138002','liming@company.com','法定代表人',1),('91330203674737246B','王强','330203198503032456','0574-87212347','13800138003','wangqiang@company.com','法定代表人',1),('91330203674737247C','陈华','330203198504043567','0574-87212348','13800138004','chenhua@company.com','法定代表人',1),('91330203674737248D','刘杰','330203198505054678','0574-87212349','13800138005','liujie@company.com','法定代表人',1),('91330203674737249E','赵磊','330205198506065789','0574-87212350','13800138006','zhaolei@company.com','法定代表人',1),('91330203674737250F','孙敏','330205198507076890','0574-87212351','13800138007','sunmin@company.com','法定代表人',1),('91330203674737251G','周静','330205198508087901','0574-87212352','13800138008','zhoujing@company.com','法定代表人',1),('91330203674737252H','吴丽','330205198509098012','0574-87212353','13800138009','wuli@company.com','法定代表人',1),('91330203674737253I','王勇','330205198510109123','0574-87212354','13800138010','wangyong@company.com','法定代表人',1),('91330203674737254J','陈军','330206198511110234','0574-87212355','13800138011','chenjun@company.com','法定代表人',1),('91330203674737255K','刘斌','330206198512121345','0574-87212356','13800138012','liubin@company.com','法定代表人',1),('91330203674737256L','赵刚','330206198601012456','0574-87212357','13800138013','zhaogang@company.com','法定代表人',1),('91330203674737257M','孙浩','330206198602022567','0574-87212358','13800138014','sunhao@company.com','法定代表人',1),('91330203674737258N','周涛','330206198603032678','0574-87212359','13800138015','zhoutao@company.com','法定代表人',1),('91330203674737259O','吴斌','330211198604042789','0574-87212360','13800138016','wubin@company.com','法定代表人',1),('91330203674737260P','徐强','330211198605052890','0574-87212361','13800138017','xuqiang@company.com','法定代表人',1),('91330203674737261Q','朱磊','330211198606062901','0574-87212362','13800138018','zhulei@company.com','法定代表人',1),('91330203674737262R','胡杰','330211198607072012','0574-87212363','13800138019','hujie@company.com','法定代表人',1),('91330203674737263S','郭敏','330211198608082123','0574-87212364','13800138020','guomin@company.com','法定代表人',1),('91330203674737264T','何静','330212198609092234','0574-87212365','13800138021','hejing@company.com','法定代表人',1),('91330203674737265U','马丽','330212198610102345','0574-87212366','13800138022','mali@company.com','法定代表人',1),('91330203674737266V','罗华','330212198611112456','0574-87212367','13800138023','luohua@company.com','法定代表人',1),('91330203674737267W','梁伟','330212198612122567','0574-87212368','13800138024','liangwei@company.com','法定代表人',1),('91330203674737268X','宋强','330212198701012678','0574-87212369','13800138025','songqiang@company.com','法定代表人',1),('91330203674737269Y','唐杰','330213198702022789','0574-87212370','13800138026','tangjie@company.com','法定代表人',1),('91330203674737270Z','韩磊','330213198703032890','0574-87212371','13800138027','hanlei@company.com','法定代表人',1),('91330203674737271A','冯敏','330213198704042901','0574-87212372','13800138028','fengmin@company.com','法定代表人',1),('91330203674737272B','于静','330213198705053012','0574-87212373','13800138029','yujing@company.com','法定代表人',1),('91330203674737273C','董丽','330213198706063123','0574-87212374','13800138030','dongli@company.com','法定代表人',1),('91330203674737274D','萧华','330281198707073234','0574-87212375','13800138031','xiaohua@company.com','法定代表人',1),('91330203674737275E','程伟','330281198708083345','0574-87212376','13800138032','chengwei@company.com','法定代表人',1),('91330203674737276F','曹强','330281198709093456','0574-87212377','13800138033','caoqiang@company.com','法定代表人',1),('91330203674737277G','袁杰','330281198710103567','0574-87212378','13800138034','yuanjie@company.com','法定代表人',1),('91330203674737278H','潘磊','330281198711113678','0574-87212379','13800138035','panlei@company.com','法定代表人',1),('91330203674737279I','姜敏','330282198712123789','0574-87212380','13800138036','jiangmin@company.com','法定代表人',1),('91330203674737280J','魏静','330282198801012890','0574-87212381','13800138037','weijing@company.com','法定代表人',1),('91330203674737281K','蒋丽','330282198802022901','0574-87212382','13800138038','jiangli@company.com','法定代表人',1),('91330203674737282L','韦华','330282198803033012','0574-87212383','13800138039','weihua@company.com','法定代表人',1),('91330203674737283M','傅伟','330282198804043123','0574-87212384','13800138040','fuwei@company.com','法定代表人',1),('91330203674737284N','沈强','330226198805053234','0574-87212385','13800138041','shenqiang@company.com','法定代表人',1),('91330203674737285O','卢杰','330226198806063345','0574-87212386','13800138042','lujie@company.com','法定代表人',1),('91330203674737286P','姚磊','330226198807073456','0574-87212387','13800138043','yaolei@company.com','法定代表人',1),('91330203674737287Q','钟敏','330226198808083567','0574-87212388','13800138044','zhongmin@company.com','法定代表人',1),('91330203674737288R','汪静','330226198809093678','0574-87212389','13800138045','wangjing@company.com','法定代表人',1),('91330203674737289S','田丽','330225198810103789','0574-87212390','13800138046','tianli@company.com','法定代表人',1),('91330203674737290T','任华','330225198811113890','0574-87212391','13800138047','renhua@company.com','法定代表人',1),('91330203674737291U','武伟','330225198812123901','0574-87212392','13800138048','wuwei@company.com','法定代表人',1),('91330203674737292V','段强','330225198901013012','0574-87212393','13800138049','duanqiang@company.com','法定代表人',1),('91330203674737293W','白杰','330225198902023123','0574-87212394','13800138050','baijie@company.com','法定代表人',1);
/*!40000 ALTER TABLE `dw_zj_scjdgl_fddbrxx` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dw_zj_scjdgl_jyycmlxx`
--

DROP TABLE IF EXISTS `dw_zj_scjdgl_jyycmlxx`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dw_zj_scjdgl_jyycmlxx` (
  `UNI_SOCIAL_CRD_CD` varchar(50) NOT NULL COMMENT '统一社会信用代码',
  `INCLU_REASON` varchar(200) DEFAULT NULL COMMENT '列入经营异常名录原因',
  `INCLU_DT` date DEFAULT NULL COMMENT '列入日期',
  `REMEXCPRES_CN` varchar(200) DEFAULT NULL COMMENT '移出经营异常名录原因',
  `REMOVE_DT` date DEFAULT NULL COMMENT '移出日期',
  PRIMARY KEY (`UNI_SOCIAL_CRD_CD`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='经营异常名录信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dw_zj_scjdgl_jyycmlxx`
--

LOCK TABLES `dw_zj_scjdgl_jyycmlxx` WRITE;
/*!40000 ALTER TABLE `dw_zj_scjdgl_jyycmlxx` DISABLE KEYS */;
INSERT INTO `dw_zj_scjdgl_jyycmlxx` VALUES ('91330203674737244W','未按规定期限公示年度报告','2023-04-10','补报年度报告，移出异常名录','2023-08-15'),('91330203674737250F','通过登记的住所或者经营场所无法联系的','2023-05-20','企业恢复正常经营，移出异常名录','2023-09-25'),('91330203674737256L','未按规定期限公示年度报告','2023-06-15','补报年度报告，移出异常名录','2023-10-30'),('91330203674737269Y','通过登记的住所或者经营场所无法联系的','2023-01-15','企业恢复正常经营，移出异常名录','2023-06-20'),('91330203674737274D','未按规定期限公示年度报告','2022-12-10','补报年度报告，移出异常名录','2023-03-15'),('91330203674737278H','通过登记的住所或者经营场所无法联系的','2023-07-08','企业恢复正常经营，移出异常名录','2023-11-20'),('91330203674737287Q','通过登记的住所或者经营场所无法联系的','2023-02-20','企业恢复正常经营，移出异常名录','2023-07-15'),('91330203674737292V','未按规定期限公示年度报告','2023-03-05','补报年度报告，移出异常名录','2023-06-10');
/*!40000 ALTER TABLE `dw_zj_scjdgl_jyycmlxx` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dw_zj_scjdgl_scztxx`
--

DROP TABLE IF EXISTS `dw_zj_scjdgl_scztxx`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dw_zj_scjdgl_scztxx` (
  `UNI_SOCIAL_CRD_CD` varchar(50) NOT NULL COMMENT '统一社会信用代码',
  `COMP_NM` varchar(200) NOT NULL COMMENT '企业名称',
  `REG_ORG` varchar(100) DEFAULT NULL COMMENT '登记机关',
  `COMP_TYPE` varchar(100) DEFAULT NULL COMMENT '企业类型',
  `ADDR` varchar(500) DEFAULT NULL COMMENT '地址',
  `LEGAL_REPRE` varchar(50) DEFAULT NULL COMMENT '法定代表人',
  `INDV_NM` varchar(20) DEFAULT NULL COMMENT '行业代码',
  `OPT_SCOP` text COMMENT '经营范围',
  `APPR_DT` date DEFAULT NULL COMMENT '核准日期',
  `EST_DT` date DEFAULT NULL COMMENT '成立日期',
  `DOMDI_STRICT` varchar(50) DEFAULT NULL COMMENT '住所所在地行政区划',
  `OPT_STRICT` varchar(50) DEFAULT NULL COMMENT '生产经营地所在行政区划',
  `REG_CAPT` decimal(15,2) DEFAULT NULL COMMENT '注册资本',
  `REG_STATE` varchar(20) DEFAULT NULL COMMENT '登记状态',
  PRIMARY KEY (`UNI_SOCIAL_CRD_CD`),
  KEY `idx_industry_code` (`INDV_NM`),
  KEY `idx_area` (`DOMDI_STRICT`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='市场主体信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dw_zj_scjdgl_scztxx`
--

LOCK TABLES `dw_zj_scjdgl_scztxx` WRITE;
/*!40000 ALTER TABLE `dw_zj_scjdgl_scztxx` DISABLE KEYS */;
INSERT INTO `dw_zj_scjdgl_scztxx` VALUES ('91330203674737244W','宁波海曙文化传媒有限公司','宁波市海曙区市场监督管理局','有限责任公司(自然人投资或控股)','浙江省宁波市海曙区联丰路182号','张伟','5221','文化服务；广告服务；会展服务。(依法须经批准的项目，经相关部门批准后方可开展经营活动)','2020-06-18','2008-06-16','海曙区','海曙区',500000.00,'开业'),('91330203674737245A','宁波海曙广告设计有限公司','宁波市海曙区市场监督管理局','有限责任公司(自然人独资)','浙江省宁波市海曙区中山西路123号','李明','5221','广告设计；平面设计；品牌策划。(依法须经批准的项目，经相关部门批准后方可开展经营活动)','2019-08-15','2016-03-20','海曙区','海曙区',300000.00,'开业'),('91330203674737246B','宁波海曙会展服务有限公司','宁波市海曙区市场监督管理局','股份有限公司(非上市)','浙江省宁波市海曙区解放南路456号','王强','5221','会展服务；会议服务；展览策划。(依法须经批准的项目，经相关部门批准后方可开展经营活动)','2021-12-10','2019-11-25','海曙区','海曙区',800000.00,'开业'),('91330203674737247C','宁波海曙数字媒体有限公司','宁波市海曙区市场监督管理局','个人独资企业','浙江省宁波市海曙区药行街789号','陈华','5221','数字媒体；网络营销；内容创作。(依法须经批准的项目，经相关部门批准后方可开展经营活动)','2022-01-20','2020-05-12','海曙区','海曙区',200000.00,'开业'),('91330203674737248D','宁波海曙影视制作有限公司','宁波市海曙区市场监督管理局','合伙企业','浙江省宁波市海曙区开明街321号','刘杰','5221','影视制作；视频拍摄；后期制作。(依法须经批准的项目，经相关部门批准后方可开展经营活动)','2023-04-08','2021-09-30','海曙区','海曙区',600000.00,'开业'),('91330203674737249E','宁波江北旅游开发有限公司','宁波市江北区市场监督管理局','有限责任公司(自然人独资)','浙江省宁波市江北区中马路123号','李强','5222','旅游服务；酒店管理；餐饮服务。(依法须经批准的项目，经相关部门批准后方可开展经营活动)','2019-03-15','2015-08-20','江北区','江北区',300000.00,'开业'),('91330203674737250F','宁波江北酒店管理有限公司','宁波市江北区市场监督管理局','有限责任公司(自然人投资或控股)','浙江省宁波市江北区大庆南路456号','赵磊','5222','酒店管理；住宿服务；餐饮服务。(依法须经批准的项目，经相关部门批准后方可开展经营活动)','2020-07-25','2018-12-18','江北区','江北区',1500000.00,'开业'),('91330203674737251G','宁波江北旅行社有限公司','宁波市江北区市场监督管理局','外商投资企业','浙江省宁波市江北区人民路987号','孙敏','5222','旅行社业务；旅游咨询；票务代理。(依法须经批准的项目，经相关部门批准后方可开展经营活动)','2021-10-12','2019-03-08','江北区','江北区',500000.00,'开业'),('91330203674737252H','宁波江北餐饮服务有限公司','宁波市江北区市场监督管理局','国有企业','浙江省宁波市江北区槐树路147号','周静','5222','餐饮服务；食品销售；外卖配送。(依法须经批准的项目，经相关部门批准后方可开展经营活动)','2020-11-30','2018-06-22','江北区','江北区',800000.00,'开业'),('91330203674737253I','宁波江北景区管理有限公司','宁波市江北区市场监督管理局','有限责任公司(自然人投资或控股)','浙江省宁波市江北区外马路258号','吴丽','5222','景区管理；旅游服务；文化展示。(依法须经批准的项目，经相关部门批准后方可开展经营活动)','2023-02-14','2021-04-05','江北区','江北区',1200000.00,'开业'),('91330203674737254J','宁波北仑娱乐休闲有限公司','宁波市北仑区市场监督管理局','股份有限公司(非上市)','浙江省宁波市北仑区新碶街道456号','王勇','5223','娱乐服务；休闲服务；健身服务。(依法须经批准的项目，经相关部门批准后方可开展经营活动)','2021-12-10','2019-11-25','北仑区','北仑区',800000.00,'开业'),('91330203674737255K','宁波北仑健身俱乐部有限公司','宁波市北仑区市场监督管理局','个人独资企业','浙江省宁波市北仑区大碶街道789号','陈军','5223','健身服务；体育培训；健康咨询。(依法须经批准的项目，经相关部门批准后方可开展经营活动)','2022-01-20','2020-05-12','北仑区','北仑区',400000.00,'开业'),('91330203674737256L','宁波北仑体育产业有限公司','宁波市北仑区市场监督管理局','合伙企业','浙江省宁波市北仑区小港街道321号','刘杰','5223','体育产业；运动器材；体育培训。(依法须经批准的项目，经相关部门批准后方可开展经营活动)','2023-04-08','2021-09-30','北仑区','北仑区',1000000.00,'开业'),('91330203674737257M','宁波北仑KTV娱乐有限公司','宁波市北仑区市场监督管理局','有限责任公司(自然人独资)','浙江省宁波市北仑区柴桥街道654号','赵磊','5223','KTV娱乐；餐饮服务；休闲服务。(依法须经批准的项目，经相关部门批准后方可开展经营活动)','2022-07-25','2020-12-18','北仑区','北仑区',600000.00,'开业'),('91330203674737258N','宁波北仑游泳馆有限公司','宁波市北仑区市场监督管理局','外商投资企业','浙江省宁波市北仑区霞浦街道987号','孙敏','5223','游泳服务；体育培训；健身服务。(依法须经批准的项目，经相关部门批准后方可开展经营活动)','2021-10-12','2019-03-08','北仑区','北仑区',1500000.00,'开业'),('91330203674737259O','宁波镇海体育健身有限公司','宁波市镇海区市场监督管理局','个人独资企业','浙江省宁波市镇海区招宝山街道789号','陈军','5224','体育服务；健身服务；保健服务。(依法须经批准的项目，经相关部门批准后方可开展经营活动)','2022-01-20','2020-05-12','镇海区','镇海区',200000.00,'开业'),('91330203674737260P','宁波镇海保健服务有限公司','宁波市镇海区市场监督管理局','合伙企业','浙江省宁波市镇海区蛟川街道321号','刘杰','5224','保健服务；按摩服务；健康咨询。(依法须经批准的项目，经相关部门批准后方可开展经营活动)','2023-04-08','2021-09-30','镇海区','镇海区',300000.00,'开业'),('91330203674737261Q','宁波镇海运动培训有限公司','宁波市镇海区市场监督管理局','有限责任公司(自然人独资)','浙江省宁波市镇海区骆驼街道654号','赵磊','5224','运动培训；体育器材；健身指导。(依法须经批准的项目，经相关部门批准后方可开展经营活动)','2022-07-25','2020-12-18','镇海区','镇海区',500000.00,'开业'),('91330203674737262R','宁波镇海瑜伽馆有限公司','宁波市镇海区市场监督管理局','外商投资企业','浙江省宁波市镇海区庄市街道987号','孙敏','5224','瑜伽服务；健身培训；健康管理。(依法须经批准的项目，经相关部门批准后方可开展经营活动)','2021-10-12','2019-03-08','镇海区','镇海区',400000.00,'开业'),('91330203674737263S','宁波镇海武术培训有限公司','宁波市镇海区市场监督管理局','国有企业','浙江省宁波市镇海区澥浦街道147号','周静','5224','武术培训；体育教育；文化传承。(依法须经批准的项目，经相关部门批准后方可开展经营活动)','2020-11-30','2018-06-22','镇海区','镇海区',300000.00,'开业'),('91330203674737264T','宁波鄞州会展服务有限公司','宁波市鄞州区市场监督管理局','合伙企业','浙江省宁波市鄞州区中河街道321号','刘杰','5225','会展服务；会议服务；展览服务。(依法须经批准的项目，经相关部门批准后方可开展经营活动)','2023-04-08','2021-09-30','鄞州区','鄞州区',600000.00,'开业'),('91330203674737265U','宁波鄞州会议中心有限公司','宁波市鄞州区市场监督管理局','有限责任公司(自然人独资)','浙江省宁波市鄞州区钟公庙街道654号','赵磊','5225','会议服务；展览服务；商务服务。(依法须经批准的项目，经相关部门批准后方可开展经营活动)','2022-07-25','2020-12-18','鄞州区','鄞州区',800000.00,'开业'),('91330203674737266V','宁波鄞州展览策划有限公司','宁波市鄞州区市场监督管理局','外商投资企业','浙江省宁波市鄞州区下应街道987号','孙敏','5225','展览策划；活动组织；文化传播。(依法须经批准的项目，经相关部门批准后方可开展经营活动)','2021-10-12','2019-03-08','鄞州区','鄞州区',500000.00,'开业'),('91330203674737267W','宁波鄞州商务服务有限公司','宁波市鄞州区市场监督管理局','国有企业','浙江省宁波市鄞州区潘火街道147号','周静','5225','商务服务；会议接待；展览展示。(依法须经批准的项目，经相关部门批准后方可开展经营活动)','2020-11-30','2018-06-22','鄞州区','鄞州区',400000.00,'开业'),('91330203674737268X','宁波鄞州文化传播有限公司','宁波市鄞州区市场监督管理局','有限责任公司(自然人投资或控股)','浙江省宁波市鄞州区邱隘街道258号','吴丽','5225','文化传播；活动策划；媒体服务。(依法须经批准的项目，经相关部门批准后方可开展经营活动)','2023-02-14','2021-04-05','鄞州区','鄞州区',700000.00,'开业'),('91330203674737269Y','宁波奉化工艺品有限公司','宁波市奉化区市场监督管理局','个体工商户','浙江省宁波市奉化区锦屏街道654号','赵磊','5226','工艺品制作；艺术品销售；文化创意。(依法须经批准的项目，经相关部门批准后方可开展经营活动)','2022-07-25','2020-12-18','奉化区','奉化区',150000.00,'开业'),('91330203674737270Z','宁波奉化艺术品有限公司','宁波市奉化区市场监督管理局','外商投资企业','浙江省宁波市奉化区岳林街道987号','孙敏','5226','艺术品销售；文化收藏；展览展示。(依法须经批准的项目，经相关部门批准后方可开展经营活动)','2021-10-12','2019-03-08','奉化区','奉化区',300000.00,'开业'),('91330203674737271A','宁波奉化文化创意有限公司','宁波市奉化区市场监督管理局','国有企业','浙江省宁波市奉化区溪口街道147号','周静','5226','文化创意；设计服务；艺术创作。(依法须经批准的项目，经相关部门批准后方可开展经营活动)','2020-11-30','2018-06-22','奉化区','奉化区',500000.00,'开业'),('91330203674737272B','宁波奉化传统工艺有限公司','宁波市奉化区市场监督管理局','有限责任公司(自然人投资或控股)','浙江省宁波市奉化区莼湖街道258号','吴丽','5226','传统工艺；手工制作；文化传承。(依法须经批准的项目，经相关部门批准后方可开展经营活动)','2023-02-14','2021-04-05','奉化区','奉化区',200000.00,'开业'),('91330203674737273C','宁波奉化文创产品有限公司','宁波市奉化区市场监督管理局','股份有限公司(非上市)','浙江省宁波市奉化区尚田街道369号','徐艳','5226','文创产品；礼品制作；文化用品。(依法须经批准的项目，经相关部门批准后方可开展经营活动)','2022-08-03','2020-01-15','奉化区','奉化区',400000.00,'开业'),('91330203674737274D','余姚影视制作有限公司','余姚市市场监督管理局','外商投资企业','浙江省余姚市阳明街道987号','孙敏','5227','影视制作；动漫制作；游戏开发。(依法须经批准的项目，经相关部门批准后方可开展经营活动)','2021-10-12','2018-03-08','余姚市','余姚市',1000000.00,'开业'),('91330203674737275E','余姚动漫制作有限公司','余姚市市场监督管理局','国有企业','浙江省余姚市兰江街道147号','周静','5227','动漫制作；动画设计；数字内容。(依法须经批准的项目，经相关部门批准后方可开展经营活动)','2020-11-30','2017-06-22','余姚市','余姚市',800000.00,'开业'),('91330203674737276F','余姚游戏开发有限公司','余姚市市场监督管理局','有限责任公司(自然人投资或控股)','浙江省余姚市梨洲街道258号','吴丽','5227','游戏开发；软件开发；数字娱乐。(依法须经批准的项目，经相关部门批准后方可开展经营活动)','2023-02-14','2021-04-05','余姚市','余姚市',1200000.00,'开业'),('91330203674737277G','余姚数字媒体有限公司','余姚市市场监督管理局','股份有限公司(非上市)','浙江省余姚市凤山街道369号','徐艳','5227','数字媒体；网络技术；内容制作。(依法须经批准的项目，经相关部门批准后方可开展经营活动)','2022-08-03','2020-01-15','余姚市','余姚市',600000.00,'开业'),('91330203674737278H','余姚文化科技有限公司','余姚市市场监督管理局','个人独资企业','浙江省余姚市低塘街道456号','张伟','5227','文化科技；数字创意；技术开发。(依法须经批准的项目，经相关部门批准后方可开展经营活动)','2020-06-18','2008-06-16','余姚市','余姚市',900000.00,'开业'),('91330203674737279I','慈溪温泉度假有限公司','慈溪市市场监督管理局','国有企业','浙江省慈溪市浒山街道147号','周静','5229','温泉度假；酒店管理；休闲服务。(依法须经批准的项目，经相关部门批准后方可开展经营活动)','2020-11-30','2017-06-22','慈溪市','慈溪市',2000000.00,'开业'),('91330203674737280J','慈溪度假酒店有限公司','慈溪市市场监督管理局','有限责任公司(自然人投资或控股)','浙江省慈溪市古塘街道258号','吴丽','5229','度假酒店；住宿服务；餐饮服务。(依法须经批准的项目，经相关部门批准后方可开展经营活动)','2023-02-14','2021-04-05','慈溪市','慈溪市',1500000.00,'开业'),('91330203674737281K','慈溪休闲娱乐有限公司','慈溪市市场监督管理局','股份有限公司(非上市)','浙江省慈溪市白沙路街道369号','徐艳','5229','休闲娱乐；健身服务；文化服务。(依法须经批准的项目，经相关部门批准后方可开展经营活动)','2022-08-03','2020-01-15','慈溪市','慈溪市',800000.00,'开业'),('91330203674737282L','慈溪温泉养生有限公司','慈溪市市场监督管理局','个人独资企业','浙江省慈溪市宗汉街道456号','张伟','5229','温泉养生；健康服务；休闲度假。(依法须经批准的项目，经相关部门批准后方可开展经营活动)','2020-06-18','2008-06-16','慈溪市','慈溪市',1200000.00,'开业'),('91330203674737283M','慈溪文化休闲有限公司','慈溪市市场监督管理局','合伙企业','浙江省慈溪市坎墩街道789号','李明','5229','文化休闲；娱乐服务；餐饮服务。(依法须经批准的项目，经相关部门批准后方可开展经营活动)','2019-08-15','2016-03-20','慈溪市','慈溪市',600000.00,'开业'),('91330203674737284N','宁海民宿客栈有限公司','宁海县市场监督管理局','有限责任公司(自然人投资或控股)','浙江省宁海县跃龙街道258号','吴丽','5231','民宿客栈；旅游服务；餐饮服务。(依法须经批准的项目，经相关部门批准后方可开展经营活动)','2023-02-14','2021-04-05','宁海县','宁海县',400000.00,'开业'),('91330203674737285O','宁海乡村旅游有限公司','宁海县市场监督管理局','股份有限公司(非上市)','浙江省宁海县桃源街道369号','徐艳','5231','乡村旅游；农业观光；生态旅游。(依法须经批准的项目，经相关部门批准后方可开展经营活动)','2022-08-03','2020-01-15','宁海县','宁海县',800000.00,'开业'),('91330203674737286P','宁海生态旅游有限公司','宁海县市场监督管理局','个人独资企业','浙江省宁海县梅林街道456号','张伟','5231','生态旅游；自然保护；观光服务。(依法须经批准的项目，经相关部门批准后方可开展经营活动)','2020-06-18','2008-06-16','宁海县','宁海县',500000.00,'开业'),('91330203674737287Q','宁海农家乐有限公司','宁海县市场监督管理局','合伙企业','浙江省宁海县桥头胡街道789号','李明','5231','农家乐；餐饮服务；住宿服务。(依法须经批准的项目，经相关部门批准后方可开展经营活动)','2019-08-15','2016-03-20','宁海县','宁海县',300000.00,'开业'),('91330203674737288R','宁海森林旅游有限公司','宁海县市场监督管理局','外商投资企业','浙江省宁海县深甽街道987号','王强','5231','森林旅游；户外运动；生态体验。(依法须经批准的项目，经相关部门批准后方可开展经营活动)','2021-12-10','2019-11-25','宁海县','宁海县',600000.00,'开业'),('91330203674737289S','象山主题公园有限公司','象山县市场监督管理局','股份有限公司(非上市)','浙江省象山县丹东街道369号','徐艳','5232','主题公园；娱乐服务；旅游服务。(依法须经批准的项目，经相关部门批准后方可开展经营活动)','2022-08-03','2020-01-15','象山县','象山县',1500000.00,'开业'),('91330203674737290T','象山海洋旅游有限公司','象山县市场监督管理局','个人独资企业','浙江省象山县丹西街道456号','张伟','5232','海洋旅游；海上观光；渔业体验。(依法须经批准的项目，经相关部门批准后方可开展经营活动)','2020-06-18','2008-06-16','象山县','象山县',1000000.00,'开业'),('91330203674737291U','象山海岛度假有限公司','象山县市场监督管理局','合伙企业','浙江省象山县爵溪街道789号','李明','5232','海岛度假；休闲服务；餐饮服务。(依法须经批准的项目，经相关部门批准后方可开展经营活动)','2019-08-15','2016-03-20','象山县','象山县',1200000.00,'开业'),('91330203674737292V','象山渔家乐有限公司','象山县市场监督管理局','外商投资企业','浙江省象山县石浦街道987号','王强','5232','渔家乐；海鲜餐饮；住宿服务。(依法须经批准的项目，经相关部门批准后方可开展经营活动)','2021-12-10','2019-11-25','象山县','象山县',800000.00,'开业'),('91330203674737293W','象山滨海娱乐有限公司','象山县市场监督管理局','国有企业','浙江省象山县西周街道147号','陈华','5232','滨海娱乐；水上运动；休闲服务。(依法须经批准的项目，经相关部门批准后方可开展经营活动)','2022-01-20','2020-05-12','象山县','象山县',900000.00,'开业');
/*!40000 ALTER TABLE `dw_zj_scjdgl_scztxx` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dw_zj_scjdgl_yzwfsx`
--

DROP TABLE IF EXISTS `dw_zj_scjdgl_yzwfsx`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dw_zj_scjdgl_yzwfsx` (
  `UNI_SOCIAL_CRD_CD` varchar(50) NOT NULL COMMENT '统一社会信用代码',
  `SERILL_REA` varchar(200) DEFAULT NULL COMMENT '列入严重违法失信企业名单原因',
  `ABN_TM` date DEFAULT NULL COMMENT '列入日期',
  `REM_EXCPRES_REA` varchar(200) DEFAULT NULL COMMENT '移出严重违法失信企业名单原因',
  `REM_DT` date DEFAULT NULL COMMENT '移出日期',
  PRIMARY KEY (`UNI_SOCIAL_CRD_CD`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='严重违法失信企业名单表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dw_zj_scjdgl_yzwfsx`
--

LOCK TABLES `dw_zj_scjdgl_yzwfsx` WRITE;
/*!40000 ALTER TABLE `dw_zj_scjdgl_yzwfsx` DISABLE KEYS */;
INSERT INTO `dw_zj_scjdgl_yzwfsx` VALUES ('91330203674737256L','生产销售假冒伪劣产品','2023-09-12',NULL,NULL),('91330203674737263S','非法集资，扰乱金融秩序','2023-04-25',NULL,NULL),('91330203674737269Y','虚假宣传，欺骗消费者','2023-05-15',NULL,NULL),('91330203674737278H','环境污染，拒不整改','2023-11-08',NULL,NULL),('91330203674737285O','商业欺诈，合同诈骗','2023-07-30',NULL,NULL),('91330203674737287Q','恶意拖欠员工工资，拒不支付劳动报酬','2023-08-20',NULL,NULL),('91330203674737292V','偷税漏税，拒不补缴税款','2023-06-10',NULL,NULL);
/*!40000 ALTER TABLE `dw_zj_scjdgl_yzwfsx` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `enriched_cultural_tourism`
--

DROP TABLE IF EXISTS `enriched_cultural_tourism`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `enriched_cultural_tourism` (
  `social_credit_code` varchar(50) NOT NULL COMMENT '统一社会信用代码',
  `company_name` varchar(200) DEFAULT NULL COMMENT '企业名称',
  `reg_authority` varchar(100) DEFAULT NULL COMMENT '登记机关',
  `company_type` varchar(100) DEFAULT NULL COMMENT '企业类型',
  `address` varchar(500) DEFAULT NULL COMMENT '地址',
  `legal_rep` varchar(50) DEFAULT NULL COMMENT '法定代表人',
  `industry_code` varchar(20) DEFAULT NULL COMMENT '行业代码',
  `business_scope` text COMMENT '经营范围',
  `approval_date` date DEFAULT NULL COMMENT '核准日期',
  `establishment_date` date DEFAULT NULL COMMENT '成立日期',
  `domicile_district_code` varchar(50) DEFAULT NULL COMMENT '所在区县',
  `business_district_code` varchar(50) DEFAULT NULL COMMENT '区县市',
  `legal_rep_name` varchar(50) DEFAULT NULL COMMENT '法定代表人姓名',
  `id_card_number` varchar(20) DEFAULT NULL COMMENT '身份证号码',
  `fixed_phone` varchar(20) DEFAULT NULL COMMENT '固定电话',
  `mobile_phone` varchar(20) DEFAULT NULL COMMENT '移动电话',
  `email` varchar(100) DEFAULT NULL COMMENT '电子邮箱',
  `position_title` varchar(50) DEFAULT NULL COMMENT '职务',
  `has_business_abnormal` tinyint DEFAULT '0' COMMENT '是否有经营异常',
  `abnormal_reason` varchar(200) DEFAULT NULL COMMENT '异常原因',
  `abnormal_include_date` date DEFAULT NULL COMMENT '列入日期',
  `removal_reason` varchar(200) DEFAULT NULL COMMENT '移出原因',
  `abnormal_removal_date` date DEFAULT NULL COMMENT '移出日期',
  `has_serious_violation` tinyint DEFAULT '0' COMMENT '是否严重违法失信',
  `violation_reason` varchar(200) DEFAULT NULL COMMENT '违法原因',
  `violation_include_date` date DEFAULT NULL COMMENT '列入日期',
  `violation_removal_reason` varchar(200) DEFAULT NULL COMMENT '移出原因',
  `violation_removal_date` date DEFAULT NULL COMMENT '移出日期',
  `has_website_shop` tinyint DEFAULT '0' COMMENT '是否有网站网店',
  `website_shop_name` varchar(200) DEFAULT NULL COMMENT '网站网店名称',
  `website_shop_url` varchar(500) DEFAULT NULL COMMENT '网站网店网址',
  `website_type` varchar(50) DEFAULT NULL COMMENT '网站类型',
  `ecommerce_type` varchar(50) DEFAULT NULL COMMENT '电商类型',
  `has_equity_change` tinyint DEFAULT '0' COMMENT '是否有股权变更',
  `equity_change_date` date DEFAULT NULL COMMENT '变更日期',
  `investor_name` varchar(100) DEFAULT NULL COMMENT '投资人姓名',
  `equity_before` decimal(5,2) DEFAULT NULL COMMENT '变更前股权比例',
  `equity_after` decimal(5,2) DEFAULT NULL COMMENT '变更后股权比例',
  `report_year` int DEFAULT NULL COMMENT '年报年度',
  `total_assets` decimal(15,2) DEFAULT NULL COMMENT '资产总额',
  `total_liabilities` decimal(15,2) DEFAULT NULL COMMENT '负债总额',
  `owner_equity` decimal(15,2) DEFAULT NULL COMMENT '所有者权益',
  `total_revenue` decimal(15,2) DEFAULT NULL COMMENT '营业总收入',
  `total_profit` decimal(15,2) DEFAULT NULL COMMENT '利润总额',
  `net_profit` decimal(15,2) DEFAULT NULL COMMENT '净利润',
  `total_tax` decimal(15,2) DEFAULT NULL COMMENT '纳税总额',
  `has_external_guarantee` tinyint DEFAULT '0' COMMENT '是否有对外担保',
  `creditor` varchar(200) DEFAULT NULL COMMENT '债权人',
  `debtor` varchar(200) DEFAULT NULL COMMENT '债务人',
  `guarantee_amount` decimal(15,2) DEFAULT NULL COMMENT '担保金额',
  `guarantee_start_date` date DEFAULT NULL COMMENT '担保起始日期',
  `guarantee_end_date` date DEFAULT NULL COMMENT '担保截止日期',
  `is_tech_small_enterprise` tinyint DEFAULT '0' COMMENT '是否科技型小微企业',
  `recognition_organization` varchar(100) DEFAULT NULL COMMENT '认定机构',
  `recognition_year` int DEFAULT NULL COMMENT '认定年份',
  `is_dishonest_person` tinyint DEFAULT '0' COMMENT '是否失信被执行人',
  `execute_court` varchar(100) DEFAULT NULL COMMENT '执行法院',
  `execute_amount` decimal(15,2) DEFAULT NULL COMMENT '执行金额',
  `not_execute_amount` decimal(15,2) DEFAULT NULL COMMENT '未执行金额',
  `filing_date` date DEFAULT NULL COMMENT '立案日期',
  `credit_evaluation_name` varchar(100) DEFAULT NULL COMMENT '信用评价名称',
  `evaluation_result` varchar(50) DEFAULT NULL COMMENT '评价结果',
  `evaluation_organization` varchar(100) DEFAULT NULL COMMENT '评价机构',
  `evaluation_date` date DEFAULT NULL COMMENT '评价日期',
  `change_date` date DEFAULT NULL COMMENT '变更日期',
  `change_project` varchar(100) DEFAULT NULL COMMENT '变更项目',
  `change_before` text COMMENT '变更前内容',
  `change_after` text COMMENT '变更后内容',
  `total_tax_amount` decimal(15,2) DEFAULT NULL COMMENT '实缴金额',
  `tax_items` varchar(200) DEFAULT NULL COMMENT '征收项目',
  `tax_period_start` date DEFAULT NULL COMMENT '征收期间起',
  `tax_period_end` date DEFAULT NULL COMMENT '征收期间止',
  `is_grade_a_taxpayer` tinyint DEFAULT '0' COMMENT '是否A级纳税人',
  `evaluation_department` varchar(100) DEFAULT NULL COMMENT '评价机构',
  `evaluation_date_tax` date DEFAULT NULL COMMENT '评价日期',
  `tax_credit_level` varchar(10) DEFAULT NULL COMMENT '纳税信用等级',
  `pension_count` int DEFAULT NULL COMMENT '养老保险人数',
  `medical_count` int DEFAULT NULL COMMENT '医疗保险人数',
  `unemployment_count` int DEFAULT NULL COMMENT '失业保险人数',
  `injury_count` int DEFAULT NULL COMMENT '工伤保险人数',
  `maternity_count` int DEFAULT NULL COMMENT '生育保险人数',
  `pension_pay_date` varchar(10) DEFAULT NULL COMMENT '养老保险缴费年月',
  `medical_pay_date` varchar(10) DEFAULT NULL COMMENT '医疗保险缴费年月',
  `insurance_type` varchar(50) DEFAULT NULL COMMENT '险种类型',
  `payment_months` int DEFAULT NULL COMMENT '缴费月数',
  `personal_payment_base` decimal(10,2) DEFAULT NULL COMMENT '个人缴费基数',
  `payment_amount` decimal(10,2) DEFAULT NULL COMMENT '缴费金额',
  `corporate_payment_amount` decimal(10,2) DEFAULT NULL COMMENT '单位缴费金额',
  `personal_payment_amount_detail` decimal(10,2) DEFAULT NULL COMMENT '个人缴费金额',
  `fee_period` varchar(10) DEFAULT NULL COMMENT '缴费期间',
  `has_penalty` tinyint DEFAULT '0' COMMENT '是否有行政处罚',
  `penalty_document` varchar(100) DEFAULT NULL COMMENT '行政处罚决定书文号',
  `penalty_reason` varchar(500) DEFAULT NULL COMMENT '处罚事由',
  `penalty_date` date DEFAULT NULL COMMENT '处罚日期',
  `penalty_result` varchar(200) DEFAULT NULL COMMENT '处罚结果',
  `has_license` tinyint DEFAULT '0' COMMENT '是否有行政许可',
  `license_number` varchar(100) DEFAULT NULL COMMENT '许可证号',
  `license_name` varchar(200) DEFAULT NULL COMMENT '许可证名称',
  `license_authority` varchar(100) DEFAULT NULL COMMENT '发证机关',
  `valid_from` date DEFAULT NULL COMMENT '有效期起',
  `valid_to` date DEFAULT NULL COMMENT '有效期止',
  PRIMARY KEY (`social_credit_code`),
  KEY `idx_industry_code` (`industry_code`),
  KEY `idx_area` (`domicile_district_code`),
  KEY `idx_company_type` (`company_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='文旅企业完整信息表（Step2结果）';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `enriched_cultural_tourism`
--

LOCK TABLES `enriched_cultural_tourism` WRITE;
/*!40000 ALTER TABLE `enriched_cultural_tourism` DISABLE KEYS */;
/*!40000 ALTER TABLE `enriched_cultural_tourism` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-08-10 14:10:04
