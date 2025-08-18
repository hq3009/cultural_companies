-- 创建 cross_type 表，设置 indv_nv 作为主键
CREATE TABLE IF NOT EXISTS cross_type (
    indv_nv VARCHAR(64) PRIMARY KEY,
    cross_type_name VARCHAR(20)
);

-- 读取 cross_type.csv 文件，导入到 cross_type 表
LOAD DATA INFILE 'industry_codes/cross_type.csv'
INTO TABLE cross_type
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
(indv_nv, cross_type_name);


