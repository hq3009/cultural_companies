-- 看几张关键源表的真实字段名与类型，核对 tables.md 有没有过时
DESC dw_zj_scjdgl_scztxx;
DESC dw_nb_scjdgl_qynbzcxx;
DESC dw_zj_fzgg_sxbzxrxx;
DESC dw_nb_scjdgl_gqbg;
DESC dw_nb_scjdgl_qynbwzhwdxx;
-- 确认项目下有哪些表（也顺便确认当前连接的确实是 jrsjc_dev）
SHOW TABLES;
-- 最关键：库里到底有没有 2025 年度年报
SELECT annual_year,
    COUNT(*) AS cnt
FROM odps_jrsjc_pod.dw_nb_scjdgl_qynbzcxx
GROUP BY annual_year
ORDER BY annual_year DESC
LIMIT 50;