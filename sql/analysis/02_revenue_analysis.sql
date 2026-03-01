-- ============================================================
-- FILE: 04_revenue_analysis.sql
-- PURPOSE: Revenue Distribution & Drivers
-- ============================================================

-- In this section, we analyze where revenue is being generated.

-- Instead of looking at total revenue, we break it down by:
-- - Location
-- - Time
-- - Drivers

-- This helps answer:
-- 1. Which areas generate the most revenue?
-- 2. Is revenue concentrated in a few locations?
-- 3. Which drivers contribute most to revenue?
-- 4. When (time) is revenue highest?

-- These insights help in:
-- - Identifying high-value markets
-- - Allocating drivers efficiently
-- - Planning expansion strategies

-- Key idea:
-- Revenue is not evenly distributed — we want to find the "heavy contributors"

-- ============================================================
-- REVENUE BY PICKUP LOCATION
-- ============================================================

select l.area_name as location,
sum(t.fare_amount) as total_revenue,
ROUND(AVG(t.fare_amount),2) AS avg_revenue
from trips t
join locations l
on t.pickup_location=l.location_id 
where t.trip_status='completed'
group by l.location_id, l.area_name
order by total_revenue desc;


-- ============================================================
-- REVENUE BY DROP LOCATION
-- ============================================================

select l.area_name as location,
sum(t.fare_amount) as total_revenue,
ROUND(AVG(t.fare_amount),2) AS avg_revenue,
round(sum(t.fare_amount)*100.0/sum(sum(t.fare_amount)) over(),2) as location_contribution_percent
from trips t
join locations l
on t.drop_location=l.location_id 
where t.trip_status='completed'
group by l.location_id, l.area_name
order by total_revenue desc;


-- ============================================================
-- REVENUE BY DRIVER
-- ============================================================

select d.driver_name as driver_name,
sum(t.fare_amount) as total_revenue,
ROUND(AVG(t.fare_amount),2) AS avg_revenue
from trips t
join drivers d
on t.driver_id = d.driver_id
where t.trip_status='completed'
group by d.driver_id, d.driver_name
order by total_revenue desc;


-- ============================================================
-- REVENUE BY HOUR (TIME-BASED ANALYSIS)
-- ============================================================

select EXTRACT(HOUR FROM trip_time) as hour_window,
sum(fare_amount) as total_revenue
from trips 
where trip_status='completed'
group by 1
order by total_revenue desc;