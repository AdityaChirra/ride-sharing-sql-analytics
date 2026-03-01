-- ============================================================
-- FILE: 03_basic_metrics.sql
-- PURPOSE: Business Health Overview
-- ============================================================

-- This section provides a high-level overview of the ride-sharing business.

-- Before diving into detailed analysis, it is essential to understand:
-- - The scale of operations
-- - The efficiency of trip completion
-- - The overall financial performance

-- We aim to answer the following core business questions:

-- 1. How many total trips are being generated in the system?
-- 2. What percentage of trips are successfully completed?
-- 3. How much revenue is being generated from completed trips?
-- 4. What are the total operational costs?
-- 5. Is the business profitable overall?
-- 6. What is the average value (revenue, cost, profit) per trip?

-- Business Context:
-- Not all trips generate revenue. Only completed trips contribute to revenue,
-- while cancelled or incomplete trips may still incur costs.

-- Therefore, completion rate becomes a critical operational metric,
-- directly impacting revenue and profitability.

-- Key Insight Direction:
-- - A low completion rate may indicate operational inefficiencies
-- - High costs relative to revenue may signal poor unit economics
-- - Positive profit confirms a viable business model

-- This section establishes the foundation for deeper analysis in:
-- - Revenue distribution
-- - Driver performance
-- - Time-based demand patterns
-- - Profit leakage analysis

-- ============================================================
-- OVERALL TRIPS & COMPLETION RATE
-- ============================================================

select
count(*) as total_trips,
sum(case when trip_status='completed' then 1 else 0 end) as  total_completed_trips,
round(sum(case when trip_status='completed' then 1 else 0 end) * 100.0 /count(*),2)as completion_rate
from trips;


-- ============================================================
-- REVENUE METRICS (COMPLETED TRIPS)
-- ============================================================

select 
sum(fare_amount) as total_revenue,
round(avg(fare_amount),2) as average_revenue
from trips
where trip_status='completed';


-- ============================================================
-- COST METRICS (COMPLETED TRIPS)
-- ============================================================

select sum(cost_amount) as total_cost,
round(avg(cost_amount),2) as average_cost
from trips
where trip_status='completed';


-- ============================================================
-- PROFIT METRICS (COMPLETED TRIPS)
-- ============================================================

select sum(fare_amount-cost_amount) as total_profit,
round(avg(fare_amount-cost_amount),2) as average_profit
from trips
where trip_status='completed';


-- ============================================================
-- TOTAL TRIPS (RAW COUNT)
-- ============================================================

select count(*) as total_trips
from trips;


-- ============================================================
-- CONSOLIDATED FINANCIAL METRICS (CTE APPROACH)
-- ============================================================

WITH completed_trips AS (
    SELECT *
    FROM trips
    WHERE trip_status = 'completed'
)

SELECT 
    
	-- REVENUE METRICS (COMPLETED TRIPS) 
	SUM(fare_amount) AS total_revenue,
    ROUND(AVG(fare_amount), 2) AS avg_revenue,
    
	-- COST METRICS (COMPLETED TRIPS)
    SUM(cost_amount) AS total_cost,
    ROUND(AVG(cost_amount), 2) AS avg_cost,
    
	-- PROFIT METRICS (COMPLETED TRIPS)
    SUM(fare_amount - cost_amount) AS total_profit,
    ROUND(AVG(fare_amount - cost_amount), 2) AS avg_profit

FROM completed_trips;