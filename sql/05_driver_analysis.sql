-- ============================================================
-- FILE: 05_driver_analysis.sql
-- PURPOSE: Driver Performance & Efficiency Analysis
-- ============================================================

-- In this section, we evaluate driver performance across multiple dimensions.

-- Drivers are a core supply-side component of the business.
-- Their efficiency directly impacts revenue, cost, and customer experience.

-- We aim to answer:
-- 1. Which drivers generate the most revenue?
-- 2. Which drivers complete the most trips?
-- 3. Who are the most efficient drivers (high output with fewer trips)?
-- 4. Are top drivers consistently better, or just high volume?

-- This analysis helps:
-- - Identify top-performing drivers
-- - Detect underperforming drivers
-- - Support incentive and retention strategies

-- Key idea:
-- High revenue ≠ high efficiency

-- -cte
-- ============================================================
-- DRIVER PERFORMANCE BASE (CTE)
-- ============================================================

-- ============================================================
-- DRIVER WORKLOAD (TRIPS COMPLETED)
-- ============================================================

with driver_details as(
select d.driver_name as ride_driver_name,
count(t.trip_id) as num_of_trips,
sum(t.fare_amount) as total_revenue,
sum(t.fare_amount-t.cost_amount) as total_profit,
round(avg(t.fare_amount-t.cost_amount),2) as avg_profit,
rank() over(order by sum(t.fare_amount-t.cost_amount) desc) as profit_rank_driver,
rank() over(order by sum(t.fare_amount) desc) as revenue_rank_driver,
rank() over(order by sum(t.fare_amount-t.cost_amount)/count(t.trip_id) desc) as profit_per_trip_rank,
SUM(t.fare_amount) * 100.0 / SUM(SUM(t.fare_amount)) OVER () AS revenue_contribution,
SUM(t.fare_amount-t.cost_amount) * 100.0 / SUM(SUM(t.fare_amount-t.cost_amount)) OVER () AS profit_contribution
from trips t
join drivers d
on t.driver_id=d.driver_id
where t.trip_status='completed'
group by d.driver_id,d.driver_name
)
select ride_driver_name,num_of_trips,round((total_profit/num_of_trips),2) as avg_prof_trip
from driver_details
order by 2 desc;


-- ============================================================
-- DRIVER REVENUE RANKING
-- ============================================================

with driver_details as(
select d.driver_name as ride_driver_name,
count(t.trip_id) as num_of_trips,
sum(t.fare_amount) as total_revenue,
sum(t.fare_amount-t.cost_amount) as total_profit,
round(avg(t.fare_amount-t.cost_amount),2) as avg_profit,
rank() over(order by sum(t.fare_amount-t.cost_amount) desc) as profit_rank_driver,
rank() over(order by sum(t.fare_amount) desc) as revenue_rank_driver,
rank() over(order by sum(t.fare_amount-t.cost_amount)/count(t.trip_id) desc) as profit_per_trip_rank,
SUM(t.fare_amount) * 100.0 / SUM(SUM(t.fare_amount)) OVER () AS revenue_contribution,
SUM(t.fare_amount-t.cost_amount) * 100.0 / SUM(SUM(t.fare_amount-t.cost_amount)) OVER () AS profit_contribution
from trips t
join drivers d
on t.driver_id=d.driver_id
where t.trip_status='completed'
group by d.driver_id,d.driver_name
)
select ride_driver_name,total_revenue,revenue_rank_driver,revenue_contribution
from driver_details
order by 2 desc;


-- ============================================================
-- DRIVER PROFIT RANKING
-- ============================================================

with driver_details as(
select d.driver_name as ride_driver_name,
count(t.trip_id) as num_of_trips,
sum(t.fare_amount) as total_revenue,
sum(t.fare_amount-t.cost_amount) as total_profit,
round(avg(t.fare_amount-t.cost_amount),2) as avg_profit,
rank() over(order by sum(t.fare_amount-t.cost_amount) desc) as profit_rank_driver,
rank() over(order by sum(t.fare_amount) desc) as revenue_rank_driver,
rank() over(order by sum(t.fare_amount-t.cost_amount)/count(t.trip_id) desc) as profit_per_trip_rank,
SUM(t.fare_amount) * 100.0 / SUM(SUM(t.fare_amount)) OVER () AS revenue_contribution,
SUM(t.fare_amount-t.cost_amount) * 100.0 / SUM(SUM(t.fare_amount-t.cost_amount)) OVER () AS profit_contribution
from trips t
join drivers d
on t.driver_id=d.driver_id
where t.trip_status='completed'
group by d.driver_id,d.driver_name
)
select ride_driver_name,total_profit,profit_rank_driver,profit_contribution
from driver_details
order by 2 desc;


-- ============================================================
-- DRIVER EFFICIENCY (PROFIT PER TRIP)
-- ============================================================

with driver_details as(
select d.driver_name as ride_driver_name,
count(t.trip_id) as num_of_trips,
sum(t.fare_amount) as total_revenue,
sum(t.fare_amount-t.cost_amount) as total_profit,
round(avg(t.fare_amount-t.cost_amount),2) as avg_profit,
rank() over(order by sum(t.fare_amount-t.cost_amount) desc) as profit_rank_driver,
rank() over(order by sum(t.fare_amount) desc) as revenue_rank_driver,
rank() over(order by sum(t.fare_amount-t.cost_amount)/count(t.trip_id) desc) as profit_per_trip_rank,
SUM(t.fare_amount) * 100.0 / SUM(SUM(t.fare_amount)) OVER () AS revenue_contribution,
SUM(t.fare_amount-t.cost_amount) * 100.0 / SUM(SUM(t.fare_amount-t.cost_amount)) OVER () AS profit_contribution
from trips t
join drivers d
on t.driver_id=d.driver_id
where t.trip_status='completed'
group by d.driver_id,d.driver_name
)
select ride_driver_name,round((total_profit/num_of_trips),2) as profit_per_trip
from driver_details
order by 2 desc;


-- ============================================================
-- HIGH VALUE DRIVERS (AVG PROFIT BASED RANK)
-- ============================================================

with driver_details as(
select d.driver_name as ride_driver_name,
count(t.trip_id) as num_of_trips,
sum(t.fare_amount) as total_revenue,
sum(t.fare_amount-t.cost_amount) as total_profit,
round(avg(t.fare_amount-t.cost_amount),2) as avg_profit,
rank() over(order by sum(t.fare_amount-t.cost_amount) desc) as profit_rank_driver,
rank() over(order by sum(t.fare_amount) desc) as revenue_rank_driver,
rank() over(order by sum(t.fare_amount-t.cost_amount)/count(t.trip_id) desc) as profit_per_trip_rank,
SUM(t.fare_amount) * 100.0 / SUM(SUM(t.fare_amount)) OVER () AS revenue_contribution,
SUM(t.fare_amount-t.cost_amount) * 100.0 / SUM(SUM(t.fare_amount-t.cost_amount)) OVER () AS profit_contribution
from trips t
join drivers d
on t.driver_id=d.driver_id
where t.trip_status='completed'
group by d.driver_id,d.driver_name
)
select ride_driver_name,avg_profit,profit_per_trip_rank
from driver_details
order by 2 desc;