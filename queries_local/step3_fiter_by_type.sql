-- 从CSV文件导入行业类型数据到industry_types表
LOAD DATA INFILE 'industry_codes/cross_types.csv'
INTO TABLE cross_types
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(indv_nm, type);
