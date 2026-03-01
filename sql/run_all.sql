\pset format aligned
\pset border 2
\pset pager off

-- Output file (UPDATED PATH)
\o E:/adi_codes/projects/sql/outputs/results.txt

-- ================= SETUP =================
SELECT '========== SETUP: schema =========='; 
\! cmd /c type "E:\adi_codes\projects\sql\sql\setup\01_schema.sql"
\i E:/adi_codes/projects/sql/sql/setup/01_schema.sql

SELECT '========== SETUP: load_data =========='; 
\! cmd /c type "E:\adi_codes\projects\sql\sql\setup\02_load_data.sql"
\i E:/adi_codes/projects/sql/sql/setup/02_load_data.sql


-- ================= ANALYSIS =================

SELECT '========== 01_basic_metrics =========='; 
\! cmd /c type "E:\adi_codes\projects\sql\sql\analysis\01_basic_metrics.sql"
\i E:/adi_codes/projects/sql/sql/analysis/01_basic_metrics.sql

SELECT '========== 02_revenue_analysis =========='; 
\! cmd /c type "E:\adi_codes\projects\sql\sql\analysis\02_revenue_analysis.sql"
\i E:/adi_codes/projects/sql/sql/analysis/02_revenue_analysis.sql

SELECT '========== 03_driver_analysis =========='; 
\! cmd /c type "E:\adi_codes\projects\sql\sql\analysis\03_driver_analysis.sql"
\i E:/adi_codes/projects/sql/sql/analysis/03_driver_analysis.sql

SELECT '========== 04_time_analysis =========='; 
\! cmd /c type "E:\adi_codes\projects\sql\sql\analysis\04_time_analysis.sql"
\i E:/adi_codes/projects/sql/sql/analysis/04_time_analysis.sql

SELECT '========== 05_profit_loss =========='; 
\! cmd /c type "E:\adi_codes\projects\sql\sql\analysis\05_profit_loss.sql"
\i E:/adi_codes/projects/sql/sql/analysis/05_profit_loss.sql

\o