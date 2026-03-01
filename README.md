# 🚖 Ride-Sharing SQL Analytics — Hyderabad

![PostgreSQL](https://img.shields.io/badge/PostgreSQL-4169E1?style=for-the-badge&logo=postgresql&logoColor=white)
![SQL](https://img.shields.io/badge/SQL-Analytics-orange?style=for-the-badge&logo=databricks&logoColor=white)
![GitHub](https://img.shields.io/badge/GitHub-AdityaChirra-181717?style=for-the-badge&logo=github&logoColor=white)
![Status](https://img.shields.io/badge/Status-Complete-brightgreen?style=for-the-badge)
![Domain](https://img.shields.io/badge/Domain-Ride--Sharing-blueviolet?style=for-the-badge)
![City](https://img.shields.io/badge/City-Hyderabad-red?style=for-the-badge&logo=googlemaps&logoColor=white)

> End-to-end SQL analytics project on a Hyderabad ride-sharing dataset. Explores operational efficiency, revenue patterns, driver performance, and loss concentration to surface actionable business insights.

---

## 📌 Problem Statement

Ride-sharing platforms in urban markets often operate on thin margins, where small inefficiencies in supply-demand synchronization can erode profitability at scale. This project investigates a Hyderabad ride-sharing dataset to answer a core question:

**Why does the system simultaneously generate high revenue and high losses — and what can be done about it?**

---

## 🎯 Objective

- Quantify operational performance across trips, revenue, cost, and profit
- Identify geographic and temporal patterns driving revenue and losses
- Profile driver-level efficiency and performance disparity
- Diagnose structural inefficiencies in supply-demand alignment
- Produce actionable recommendations for operational improvement

---

## 🗂️ Dataset Overview

The dataset simulates a real-world ride-sharing operation in Hyderabad, covering:

| Dimension | Details |
|---|---|
| **Total Trips** | 85,791 |
| **Locations** | HITEC City, Gachibowli, Madhapur, Shamshabad Airport, Banjara Hills, Secunderabad, Jubilee Hills, Kukatpally, LB Nagar, Ameerpet |
| **Fields** | Trip ID, driver name, pickup/drop location, trip status, revenue, cost, timestamp |
| **Trip Statuses** | Completed, Cancelled, No-show |

---

## 📊 Key Metrics Snapshot

| Metric | Value |
|---|---|
| Total Trips | 85,791 |
| Completed Trips | 76,717 |
| **Completion Rate** | **89.42%** |
| Total Revenue | ₹23,894,958 |
| Average Revenue per Trip | ₹311.47 |
| Total Cost | ₹18,451,514 |
| Average Cost per Trip | ₹240.51 |
| **Total Profit** | **₹5,443,444** |
| **Average Profit per Trip** | **₹70.95** |

---

## 🔍 Analysis

The analysis is structured across five SQL modules:

### `01_schema_setup.sql`
Defines the database schema — tables for trips, drivers, and locations — and loads the raw dataset.

### `02_data_exploration.sql`
Initial scans for data quality: null checks, distinct value counts, trip status distribution, and date range validation.

### `03_basic_metrics.sql`
Computes consolidated financial KPIs using CTEs — total and average revenue, cost, and profit across all completed trips.

```sql
-- Consolidated financial metrics via CTE
WITH financial_summary AS (
    SELECT
        SUM(revenue)         AS total_revenue,
        AVG(revenue)         AS avg_revenue,
        SUM(cost)            AS total_cost,
        AVG(cost)            AS avg_cost,
        SUM(revenue - cost)  AS total_profit,
        AVG(revenue - cost)  AS avg_profit
    FROM trips
    WHERE status = 'completed'
)
SELECT * FROM financial_summary;
```

### `04_revenue_analysis.sql`
Breaks down revenue by pickup location, drop location (with contribution %), and individual driver. Identifies top revenue zones and high-value routes.

```sql
-- Revenue contribution by drop location
SELECT
    drop_location AS location,
    SUM(revenue) AS total_revenue,
    AVG(revenue) AS avg_revenue,
    ROUND(SUM(revenue) * 100.0 / SUM(SUM(revenue)) OVER (), 2) AS location_contribution_percent
FROM trips
WHERE status = 'completed'
GROUP BY drop_location
ORDER BY total_revenue DESC;
```

### `05_loss_analysis.sql`
Surfaces loss-making trips by driver, location, and hour of day. Identifies structural loss concentration vs. random variance.

```sql
-- Hourly loss concentration
SELECT
    EXTRACT(HOUR FROM trip_time) AS hour,
    COUNT(*) AS total_trips,
    SUM(CASE WHEN revenue < cost THEN 1 ELSE 0 END) AS loss_trips,
    SUM(CASE WHEN revenue < cost THEN cost - revenue ELSE 0 END) AS total_loss
FROM trips
WHERE status = 'completed'
GROUP BY hour
ORDER BY total_loss DESC;
```

---

## 💡 Key Insights

### 1. Strong Volume, Thin Margins
The system completes 89.42% of trips but generates only ₹70.95 average profit per trip against ₹311.47 revenue. This volume-driven model means minor inefficiencies cascade into significant P&L impact.

### 2. Revenue Is Geographically Concentrated
Three zones — **HITEC City (₹4.26M), Gachibowli (₹3.86M), and Madhapur (₹3.64M)** — account for the majority of total revenue. The system is structurally dependent on IT corridor demand.

### 3. Shamshabad Airport Is a Premium Segment
Average drop-side revenue at the airport is **₹982 per trip** — more than 3× the system average. This segment behaves distinctly from urban rides and warrants dedicated pricing and supply strategy.

### 4. Peak Hours Drive Both Revenue and Losses
Evening hours (17:00–20:00) generate the highest revenue but also the highest total losses. Demand spikes outpace driver availability, creating simultaneous high-revenue and high-loss windows.

### 5. High-Demand Zones Also Lead in Losses
HITEC City, Gachibowli, and Madhapur — the top revenue generators — also contribute the most to losses. The same dimensions that drive growth are where inefficiency is most costly.

### 6. Driver Performance Is Highly Uneven
Top drivers achieve average revenue per trip well above ₹400, while underperformers fall below ₹200. This gap reflects differences in routing decisions, trip acceptance, and operational behavior — not just luck.

### 7. Losses Are Structural, Not Random
Loss concentration clusters around specific drivers, specific hours (17:00–23:00), and specific locations. This points to systemic design gaps rather than isolated anomalies.

### 8. The System Is Reactive, Not Predictive
Clear temporal demand cycles (morning commute, evening peak) exist, yet losses spike during these known windows. The system responds to demand after it materializes rather than anticipating and pre-positioning supply.

---

## ✅ Recommendations

**1. Dynamic Surge Pricing During Peak Windows**
Implement time-aware pricing between 17:00–20:00 to convert high-demand volume into higher margins and deter low-value trips during capacity-constrained periods.

**2. Dedicated Airport Supply Pool**
Create a ring-fenced driver cohort for Shamshabad Airport routes. At ₹982 average trip value, optimizing availability and turnaround at this node has outsized revenue impact.

**3. Predictive Driver Positioning**
Use historical trip patterns to pre-position drivers in HITEC City, Gachibowli, and Madhapur before peak hours — not during them. Shift from reactive dispatch to scheduled supply deployment.

**4. Driver Performance Tiers**
Introduce performance scoring based on revenue per trip, completion rate, and loss rate. Use this to route high-value trips preferentially and identify drivers who need coaching or reassignment.

**5. Loss-Trigger Monitoring**
Build real-time alerts for trips likely to generate losses (based on route, time, and driver profile) so dispatch logic can intervene before acceptance.

**6. Unfulfilled Demand Analysis**
The 10.58% incomplete trip rate represents direct revenue leakage. Investigate cancellation and no-show patterns by location and hour to close this gap.

---

## 🧠 System-Level Conclusion

The ride-sharing system demonstrates strong demand and revenue potential, but suffers from structural inefficiencies driven by poor synchronization of supply, demand, and pricing. The result is a paradox: **the same locations, hours, and drivers that generate the most revenue also generate the most losses.** Growth is occurring, but it is not optimized. The path to profitability is not more volume — it is smarter supply alignment, predictive positioning, and premium segment capture.

---

## 🔭 Future Scope

- **Route-Level Profitability:** Analyze revenue and cost by origin-destination pair to identify high-margin corridors and eliminate subsidized routes
- **Time Series Forecasting:** Build demand prediction models on hourly trip data to power proactive driver positioning
- **Driver Segmentation:** Cluster drivers by behavioral patterns (trip acceptance, detour rate, cancellation behavior) to enable differentiated management strategies
- **Geospatial Heatmaps:** Visualize pickup density, loss zones, and idle driver clusters to guide real-time dispatch decisions
- **Churn & Retention Analysis:** Track driver retention rates by performance tier and identify early signals of driver dropout
- **Pricing Elasticity Modeling:** Measure the effect of surge multipliers on trip completion rates to find the optimal pricing ceiling

---

## 🛠️ Tools Used

![PostgreSQL](https://img.shields.io/badge/postgresql-%23316192.svg?style=for-the-badge&logo=postgresql&logoColor=white)   ![pgAdmin](https://img.shields.io/badge/pgAdmin%204-336791?style=for-the-badge&logo=postgresql&logoColor=white)   ![SQL](https://img.shields.io/badge/SQL-%23FF6B35.svg?style=for-the-badge&logo=databricks&logoColor=white)

- **pgAdmin 4** is used as the IDE for writing and executing SQL queries.
- **PostgreSQL** is used as the database engine for storing, querying, and analysing the ride-sharing data.
- **SQL** is the core analytical language — leveraging CTEs, window functions, aggregations, and subqueries throughout the analysis.

---

## 📁 Project Structure

```
ride-sharing-sql-analytics/
├── sql/
│   ├── 01_schema_setup.sql        # Table definitions and data load
│   ├── 02_data_exploration.sql    # Quality checks and distribution scans
│   ├── 03_basic_metrics.sql       # Financial KPIs (revenue, cost, profit)
│   ├── 04_revenue_analysis.sql    # Revenue by location and driver
│   └── 05_loss_analysis.sql       # Loss concentration by driver, time, zone
├── output/
│   └── results.txt                # Raw query outputs
└── README.md
```

---

*Built by [Aditya Chirra](https://github.com/AdityaChirra) · Hyderabad Ride-Sharing Analytics*