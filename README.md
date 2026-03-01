# 🚖 Ride-Sharing SQL Analytics — Hyderabad

![PostgreSQL](https://img.shields.io/badge/postgresql-%23316192.svg?style=for-the-badge&logo=postgresql&logoColor=white)   ![pgAdmin](https://img.shields.io/badge/pgAdmin%204-336791?style=for-the-badge&logo=postgresql&logoColor=white)   ![SQL](https://img.shields.io/badge/SQL-%23FF6B35.svg?style=for-the-badge&logo=databricks&logoColor=white)   ![Status](https://img.shields.io/badge/Status-Complete-brightgreen?style=for-the-badge)

> SQL-based analytics project on a Hyderabad ride-sharing dataset — identifying why a profitable system still bleeds money.

---

## 📌 Problem Statement

A ride-sharing platform is generating revenue but also generating losses — in the same locations, at the same hours, through the same drivers.

**The question:** Is this random inefficiency or a structural problem?

---

## 🎯 Objective

- Measure operational and financial performance
- Pinpoint where and when losses occur
- Identify which drivers are profitable and which aren't
- Derive decisions that fix the root cause, not the symptoms

---

## 📊 Key Metrics Snapshot

| Metric | Value |
|---|---|
| Completed Trips | 76,717 / 85,791 |
| Completion Rate | **89.42%** |
| Total Revenue | ₹23,894,958 |
| Total Cost | ₹18,451,514 |
| **Total Profit** | **₹5,443,444** |
| Avg Revenue / Trip | ₹311.47 |
| **Avg Profit / Trip** | **₹70.95** |

---

## 💡 Key Insights

- **Margins are razor-thin** — ₹70.95 profit on ₹311.47 revenue. Any inefficiency hits the bottom line immediately.
- **Revenue is concentrated** — HITEC City, Gachibowli, and Madhapur drive the majority of total revenue. The system is over-dependent on the IT corridor.
- **Airport is a premium outlier** — Shamshabad Airport averages ₹982/trip (3× the system average). It behaves like a different business entirely.
- **Peak hours = peak losses** — 17:00–20:00 generates the most revenue *and* the most losses. Demand spikes outpace supply every evening.
- **Same zones, same problem** — The top revenue locations are also the top loss locations. Growth and inefficiency are happening in the same place.
- **Driver performance is wildly uneven** — Top drivers average ₹400+/trip; bottom performers fall under ₹200. This isn't bad luck — it's behavior.
- **Losses follow a pattern** — Concentrated across specific drivers, specific hours, specific locations. That's a system problem, not an outlier problem.
- **The system is reactive** — Demand patterns are predictable (commute hours, evening peaks), yet the platform responds after the spike, not before it.

---

## ✅ Recommendations

- **Surge pricing at peak hours** — Apply dynamic pricing from 17:00–20:00 to protect margins during high-demand windows
- **Dedicated airport supply** — Assign a fixed driver pool to Shamshabad routes; the revenue per trip justifies it
- **Pre-position drivers** — Use historical patterns to place drivers in HITEC City / Gachibowli *before* the evening rush, not during it
- **Driver performance tiers** — Score drivers by profit-per-trip and route high-value trips to top performers
- **Fix the 10% leakage** — 9,074 incomplete trips = direct revenue loss; investigate cancellation patterns by zone and hour

---

## 🧠 System-Level Conclusion

The system doesn't have a demand problem — it has a **synchronization problem**. Revenue and losses coexist in the same locations, hours, and driver pool because supply is never where it needs to be, when it needs to be there. Fixing this doesn't require more trips. It requires smarter positioning, tiered pricing, and treating the airport as a separate premium segment.

---

## 🔭 Future Scope

- Route-level P&L — profit by origin-destination pair
- Demand forecasting — predict hourly trip volume by zone
- Driver clustering — segment drivers by behavioral patterns
- Pricing elasticity — find the surge ceiling before trips drop off

---

## 📁 Project Structure

```
ride-sharing-sql-analytics/
│   README.md
│
├───data
│       drivers.csv
│       locations.csv
│       payments.csv
│       riders.csv
│       trips.csv
│
├───output
│       results.txt
│       run_all.sql
│
└───sql
        01_schema.sql
        02_load_data.sql
        03_basic_metrics.sql
        04_revenue_analysis.sql
        05_driver_analysis.sql
        06_time_analysis.sql
        07_profit_loss.sql
```

---

*Built by [Aditya Chirra](https://github.com/AdityaChirra)*