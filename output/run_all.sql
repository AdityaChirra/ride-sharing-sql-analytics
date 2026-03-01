\pset format aligned
\pset border 2
\pset pager off

\o E:/adi_codes/projects/sql/output/results.txt

SELECT '========== 03_basic_metrics ==========';
\! cmd /c type "E:\adi_codes\projects\sql\sql\03_basic_metrics.sql"
\i E:/adi_codes/projects/sql/sql/03_basic_metrics.sql

SELECT '========== 04_revenue_analysis ==========';
\! cmd /c type "E:\adi_codes\projects\sql\sql\04_revenue_analysis.sql"
\i E:/adi_codes/projects/sql/sql/04_revenue_analysis.sql

SELECT '========== 05_driver_analysis ==========';
\! cmd /c type "E:\adi_codes\projects\sql\sql\05_driver_analysis.sql"
\i E:/adi_codes/projects/sql/sql/05_driver_analysis.sql

SELECT '========== 06_time_analysis ==========';
\! cmd /c type "E:\adi_codes\projects\sql\sql\06_time_analysis.sql"
\i E:/adi_codes/projects/sql/sql/06_time_analysis.sql

SELECT '========== 07_profit_loss ==========';
\! cmd /c type "E:\adi_codes\projects\sql\sql\07_profit_loss.sql"
\i E:/adi_codes/projects/sql/sql/07_profit_loss.sql

\o