-- ============================================================
-- FILE: 07_profit_loss.sql
-- PURPOSE: Profitability & Loss Analysis
-- ============================================================

-- This section focuses on identifying loss-making operations
-- and understanding where the business is losing money.

-- While previous sections focused on revenue and performance,
-- this section highlights inefficiencies and financial leakages.

-- Core Business Questions:
-- 1. Which individual trips are loss-making?
-- 2. What is the total financial loss incurred?
-- 3. What percentage of trips are unprofitable?
-- 4. Which drivers contribute most to losses?
-- 5. Which locations generate the highest losses?
-- 6. Are losses concentrated in specific time windows?

-- Business Relevance:
-- - Helps reduce unnecessary costs
-- - Identifies inefficient drivers or regions
-- - Supports pricing and operational improvements

-- Key Insight Direction:
-- A business can generate high revenue but still fail
-- if losses are not controlled effectively.

-- ============================================================
-- LOSS-MAKING TRIPS (BASE CTE)
-- ============================================================

-- ============================================================
-- INDIVIDUAL LOSS-MAKING TRIPS
-- ============================================================

with loss_details as(
select 
trip_id,
driver_id,
pickup_location,
cost_amount - fare_amount as loss_amount
from trips
where fare_amount < cost_amount
and trip_status='completed'
)
select trip_id,loss_amount
from loss_details
order by trip_id;


-- ============================================================
-- TOTAL LOSS (OVERALL)
-- ============================================================

with loss_details as(
select 
trip_id,
driver_id,
pickup_location,
cost_amount - fare_amount as loss_amount
from trips
where fare_amount < cost_amount
and trip_status='completed'
)
select sum(loss_amount) as total_loss
from loss_details;


-- ============================================================
-- LOSS RATE (% OF UNPROFITABLE TRIPS)
-- ============================================================

select 
round(
count(case when fare_amount < cost_amount then 1 end) * 100.0 / count(*), 2
) as loss_rate
from trips
where trip_status='completed';


-- ============================================================
-- LOSS BY DRIVER (IDENTIFY HIGH-RISK DRIVERS)
-- ============================================================

with loss_details as(
select 
trip_id,
driver_id,
pickup_location,
cost_amount - fare_amount as loss_amount
from trips
where fare_amount < cost_amount
and trip_status='completed'
)
select d.driver_name,sum(ld.loss_amount) as total_loss
from loss_details ld
join drivers d
on ld.driver_id=d.driver_id
group by d.driver_id,d.driver_name
order by total_loss desc;


-- ============================================================
-- LOSS BY LOCATION (GEOGRAPHIC INEFFICIENCY)
-- ============================================================

with loss_details as(
select 
trip_id,
driver_id,
pickup_location,
cost_amount - fare_amount as loss_amount
from trips
where fare_amount < cost_amount
and trip_status='completed'
)
select l.area_name,sum(ld.loss_amount) as total_loss
from loss_details ld
join locations l
on ld.pickup_location=l.location_id
group by l.location_id,l.area_name
order by total_loss desc;


-- ============================================================
-- LOSS BY TIME (TEMPORAL INEFFICIENCY)
-- ============================================================

with loss_details as(
select 
trip_id,
driver_id,
pickup_location,
cost_amount - fare_amount as loss_amount
from trips
where fare_amount < cost_amount
and trip_status='completed'
)
select extract(hour from trip_time) as hour_window,
sum(ld.loss_amount) as total_loss
from loss_details ld
join trips t
on ld.trip_id=t.trip_id
group by hour_window
order by total_loss desc;