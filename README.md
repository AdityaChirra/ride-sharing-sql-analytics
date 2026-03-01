<div align="center">

  <h1>🚖 Ride-Sharing Business Analysis</h1>
  <p>End-to-end SQL analysis of a ride-sharing platform — covering revenue, driver performance, demand patterns, and profitability.</p>

  ![PostgreSQL](https://img.shields.io/badge/PostgreSQL-15-blue?style=flat-square&logo=postgresql)
  ![Status](https://img.shields.io/badge/status-complete-success?style=flat-square)
  ![Files](https://img.shields.io/badge/SQL%20files-7-orange?style=flat-square)

</div>

---

## 📌 Project Overview

This project simulates a business analyst role at a ride-sharing company. Using a PostgreSQL database, I analyzed operational and financial data across four areas:

- **Business Health** — completion rate, revenue, profitability
- **Revenue Distribution** — where and when money is being made
- **Driver Performance** — top drivers vs. most efficient drivers
- **Profit & Loss** — where the business is losing money

The goal was to think like an analyst, not just write queries — so each file starts with the business questions before any SQL.

---

## 🗂️ Project Structure

```
ride-sharing-sql-analytics/
│
├── data/
│   ├── drivers.csv
│   ├── locations.csv
│   ├── payments.csv
│   ├── riders.csv
│   └── trips.csv
│
├── sql/
│   ├── 01_schema.sql            # Table definitions and relationships
│   ├── 02_load_data.sql         # Data import via COPY
│   ├── 03_basic_metrics.sql     # Business health overview
│   ├── 04_revenue_analysis.sql  # Revenue by location, driver, and hour
│   ├── 05_driver_analysis.sql   # Driver performance and efficiency rankings
│   ├── 06_time_analysis.sql     # Demand and profitability by time of day
│   └── 07_profit_loss.sql       # Loss identification by trip, driver, and location
│
└── README.md
```

---

## 🗄️ Database Schema

| Table       | Description                                              |
|-------------|----------------------------------------------------------|
| `trips`     | Core fact table — fare, cost, status, time, locations    |
| `drivers`   | Driver profiles with ratings and join dates              |
| `riders`    | Rider profiles with city and signup date                 |
| `locations` | Pickup/drop area names mapped to cities                  |
| `payments`  | Payment method per trip                                  |

`trips` links to `drivers`, `riders`, and `locations` via foreign keys. `payments` links back to `trips`.

---

## 📊 Analysis Breakdown

### 1. Basic Metrics — `03_basic_metrics.sql`

Establishes the financial baseline before any deep-dive.

**Questions answered:**
- What is the overall trip completion rate?
- What is total revenue, cost, and profit from completed trips?
- What are the average financial metrics per trip?

A CTE filters for completed trips once and gets reused across all the financial metrics — avoids repeating the same WHERE clause everywhere.

```sql
WITH completed_trips AS (
    SELECT * FROM trips WHERE trip_status = 'completed'
)
SELECT
    SUM(fare_amount)                          AS total_revenue,
    SUM(cost_amount)                          AS total_cost,
    SUM(fare_amount - cost_amount)            AS total_profit,
    ROUND(AVG(fare_amount - cost_amount), 2)  AS avg_profit
FROM completed_trips;
```

---

### 2. Revenue Analysis — `04_revenue_analysis.sql`

Breaks down revenue by location, driver, and hour to find where the most value is generated.

**Questions answered:**
- Which areas generate the most revenue?
- Which drivers are the top contributors?
- What time of day drives peak revenue?

Window function used to get each location's % contribution to total revenue.

```sql
SELECT
    l.area_name,
    SUM(t.fare_amount) AS total_revenue,
    ROUND(
        SUM(t.fare_amount) * 100.0 / SUM(SUM(t.fare_amount)) OVER(), 2
    ) AS location_contribution_percent
FROM trips t
JOIN locations l ON t.drop_location = l.location_id
WHERE t.trip_status = 'completed'
GROUP BY l.location_id, l.area_name
ORDER BY total_revenue DESC;
```

---

### 3. Driver Analysis — `05_driver_analysis.sql`

Ranks every driver by revenue, profit, and efficiency. The main finding here is that high revenue doesn't always mean high efficiency.

**Questions answered:**
- Which drivers rank highest by revenue vs. profit?
- Who delivers the best profit per trip?
- What % of total revenue/profit does each driver contribute?

A single CTE computes all driver-level aggregations with multiple RANK() window functions at once — each SELECT after that just slices it differently.

```sql
WITH driver_details AS (
    SELECT
        d.driver_name,
        COUNT(t.trip_id)                                               AS num_of_trips,
        SUM(t.fare_amount)                                             AS total_revenue,
        SUM(t.fare_amount - t.cost_amount)                             AS total_profit,
        RANK() OVER (ORDER BY SUM(t.fare_amount) DESC)                 AS revenue_rank,
        RANK() OVER (ORDER BY SUM(t.fare_amount - t.cost_amount) DESC) AS profit_rank,
        SUM(t.fare_amount) * 100.0 / SUM(SUM(t.fare_amount)) OVER ()  AS revenue_contribution
    FROM trips t
    JOIN drivers d ON t.driver_id = d.driver_id
    WHERE t.trip_status = 'completed'
    GROUP BY d.driver_id, d.driver_name
)
SELECT driver_name, total_revenue, revenue_rank, revenue_contribution
FROM driver_details
ORDER BY total_revenue DESC;
```

---

### 4. Time Analysis — `06_time_analysis.sql`

Looks at how revenue, demand, and completion rate shift by hour — useful for finding peak windows and problem slots.

**Questions answered:**
- Which hours drive the highest revenue and profit?
- When is demand highest?
- Does completion rate drop at specific hours?

Two CTEs — one for completed trips, one for all trips — joined on hour_window to calculate hourly completion rate.

```sql
WITH time_details AS (
    SELECT EXTRACT(HOUR FROM trip_time) AS hour_window,
           COUNT(trip_id) AS completed_trips,
           SUM(fare_amount - cost_amount) AS total_profit
    FROM trips WHERE trip_status = 'completed'
    GROUP BY 1
),
total_trips AS (
    SELECT EXTRACT(HOUR FROM trip_time) AS hour_window,
           COUNT(*) AS all_trips
    FROM trips GROUP BY 1
)
SELECT
    td.hour_window,
    ROUND(td.completed_trips * 100.0 / tt.all_trips, 2) AS completion_rate
FROM time_details td
JOIN total_trips tt ON td.hour_window = tt.hour_window
ORDER BY completion_rate DESC;
```

---

### 5. Profit & Loss — `07_profit_loss.sql`

Tracks down where the business is losing money — by trip, driver, location, and hour.

**Questions answered:**
- Which trips are loss-making?
- What is the total loss and loss rate?
- Which drivers and locations contribute most to losses?
- Are losses clustered in specific hours?

A base CTE isolates all loss-making trips once; everything downstream references it.

```sql
WITH loss_details AS (
    SELECT trip_id, driver_id, pickup_location,
           cost_amount - fare_amount AS loss_amount
    FROM trips
    WHERE fare_amount < cost_amount AND trip_status = 'completed'
)
SELECT d.driver_name, SUM(ld.loss_amount) AS total_loss
FROM loss_details ld
JOIN drivers d ON ld.driver_id = d.driver_id
GROUP BY d.driver_id, d.driver_name
ORDER BY total_loss DESC;
```

---

## 🎯 Why This Project Stands Out

- CTE pipelines instead of one-off queries
- Business questions first, then SQL
- Covers both performance and losses, not just revenue
- Mirrors real analyst workflows

---

## 🔍 Key Insights

> All values in ₹. Dataset: 85,791 trips across Hyderabad.

- **Completion rate is 89.42%** — 76,717 trips completed out of 85,791, generating ₹2.39 crore total at ₹311 average per trip
- **Top 3 drop locations (HITEC City, Gachibowli, Shamshabad Airport) account for ~40% of revenue** — heavy concentration in the tech corridor and airport route
- **Shamshabad Airport average fare is ₹982/trip**, about 3× the city average — high value per trip even at lower volumes
- **Evening hours (5–8 PM) are the peak window**, but 5 PM also has the lowest completion rate of the bunch (88%) — probably driver supply not keeping up with demand
- **12.09% of completed trips are loss-making**, with losses heaviest in the same evening hours — pricing may not be keeping up with costs during peak time
- **HITEC City and Gachibowli top both revenue and total losses** — high volume cuts both ways

---

## 🛠️ SQL Skills Demonstrated

| Skill                  | Used In                                     |
|------------------------|---------------------------------------------|
| CTEs (`WITH`)          | Files 03, 05, 06, 07                        |
| Window Functions       | `RANK()`, `SUM() OVER()` — Files 04, 05     |
| Multi-table JOINs      | Files 04, 05, 06, 07                        |
| Aggregations           | `SUM`, `AVG`, `COUNT`, `ROUND` — all files  |
| CASE statements        | Completion rate, loss rate — Files 03, 07   |
| `EXTRACT` / date funcs | Hourly analysis — Files 04, 06, 07          |
| Subquery logic         | Contribution % via window over aggregation  |
| Schema design          | Foreign keys, normalization — File 01       |

---

## ⚙️ How to Run

**Requirements:** PostgreSQL 15+, pgAdmin or any SQL client (DBeaver, TablePlus, psql CLI)

1. Clone the repo:
   ```bash
   git clone https://github.com/adihofd/ride-sharing-sql-analytics.git
   cd ride-sharing-sql-analytics
   ```

2. Create the database and run the schema:
   ```sql
   CREATE DATABASE ride_sharing;
   \i sql/01_schema.sql
   ```

3. Update file paths in `02_load_data.sql` to match your local `data/` folder, then:
   ```sql
   \i sql/02_load_data.sql
   ```

4. Run analysis files in order:
   ```sql
   \i sql/03_basic_metrics.sql
   \i sql/04_revenue_analysis.sql
   -- and so on
   ```

> Note: The `COPY` command requires CSV files to be accessible from the PostgreSQL server. Update paths before running.

---

## 📬 Contact

**Aditya Chirra** · [adityachirra8@gmail.com](mailto:adityachirra8@gmail.com) · [LinkedIn](https://www.linkedin.com/in/aditya-chirra-5baa07364/) · [GitHub](https://github.com/adihofd)

---

<div align="center">
  <sub>Built by <a href="https://github.com/adihofd">Aditya Chirra</a> · SQL Portfolio Project</sub>
</div>