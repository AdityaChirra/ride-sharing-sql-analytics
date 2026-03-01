-- ============================================================
-- FILE: 06_time_analysis.sql
-- PURPOSE: Time-Based Demand & Revenue Analysis
-- ============================================================

-- In this section, we analyze how business performance varies over time.

-- Time is a critical dimension in ride-sharing:
-- Demand, revenue, and efficiency fluctuate throughout the day.

-- We aim to answer:
-- 1. Which hours generate the highest revenue?
-- 2. When is demand (number of trips) highest?
-- 3. Are peak hours also the most profitable?
-- 4. Are there low-performance time windows?

-- These insights help:
-- - Optimize driver allocation
-- - Plan surge pricing strategies
-- - Reduce idle time during low-demand hours

-- Key idea:
-- Time-based patterns reveal operational opportunities.

-- ============================================================
-- TIME AGGREGATION (REVENUE, PROFIT, DEMAND)
-- ============================================================

with time_details as(
select extract(hour from trip_time) as hour_window,
sum(fare_amount) as total_revenue,
sum(fare_amount-cost_amount) as total_profit,
count(trip_id) as total_no_of_trips
from trips
where trip_status='completed'
group by 1
),

-- ============================================================
-- TOTAL TRIPS (FOR COMPLETION RATE CALCULATION)
-- ============================================================

total_trips as
(
select extract(hour from trip_time) as hour_window,
count(*) as uncomp_and_comp_trip
from trips
group by 1
)

-- ============================================================
-- REVENUE & PROFIT BY HOUR
-- ============================================================

select hour_window,total_revenue,total_profit
from time_details
order by 2 desc;

-- ============================================================
-- DEMAND & EFFICIENCY (PROFIT PER TRIP)
-- ============================================================

select hour_window,total_no_of_trips,round((total_profit/total_no_of_trips),2) as avg_profit_per_hour
from time_details
order by 2 desc;

-- ============================================================
-- COMPLETION RATE BY HOUR
-- ============================================================

select td.hour_window,round(td.total_no_of_trips*100.0/tt. uncomp_and_comp_trip,2) as completion_rate
from time_details td
join total_trips tt
on td.hour_window=tt.hour_window
order by 2 desc;