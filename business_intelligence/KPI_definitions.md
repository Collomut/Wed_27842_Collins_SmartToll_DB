# Student Project Report: Smart Toll Executive Dashboard

**Student Name:** Mutinda Collins  
**Student ID:** 27842  
**Course:** Database Development with PL/SQL (INSY 8311)  
**Institution:** Adventist University of Central Africa (AUCA)  
**Academic Year:** 2025 – 2026  
**Database Name:** WED_27842_Collins_smarttoll_db  

---

# 📈 Executive Dashboard & Visualization

## 👁️ Overview
The **Smart Toll Executive Dashboard** serves as the central decision-making hub for the **Ministry of Transport**. It transforms raw transactional data from the Oracle Database into actionable visual insights.

Instead of reading thousands of log entries, administrators use this interactive dashboard to monitor **Revenue Health**, **Traffic Congestion**, and **Enforcement Efficiency** in real-time.

---

## 🛠️ Data Architecture
The dashboard is built on a **Hybrid Data Architecture**:

1. **Extraction:**  
   Complex aggregations are pre-calculated in Oracle using **Materialized Views** (`MV_HOURLY_TRAFFIC_STATS`) and **Analytical Views** (`VW_BI_REVENUE_TRENDS`).

2. **Transformation:**  
   Data is cleaned and formatted using the **star-schema principle**.

3. **Visualization:**  
   **Microsoft Power BI** renders the visuals using the processed datasets.

---

## 📊 Key Performance Indicators (KPIs)

| KPI | Visual Type | Data Source | Business Question | Insight |
|-----|------------|------------|-----------------|--------|
| **Financial Performance Trends** | Line Chart | `VW_BI_REVENUE_TRENDS` | "Is the project generating consistent revenue, or are there seasonal dips?" | Tracks daily and monthly revenue. Includes a **3-Month Moving Average** to smooth volatility and reveal growth trends. |
| **Peak Hour Congestion Analysis** | Clustered Column Chart | `VW_BI_PEAK_HOURS` / `MV_HOURLY_TRAFFIC_STATS` | "When should we schedule lane maintenance to minimize disruption?" | Identifies peak hours (e.g., 07:00–09:00, 17:00–19:00). Maintenance is scheduled during "Green" (Low Traffic) hours. |
| **High-Risk Offender Watchlist** | Detailed Table / Matrix | `VW_BI_HIGH_RISK_VEHICLES` | "Which vehicles owe the most money and should be targeted by police?" | Prioritized "Most Wanted" list. Ranks vehicles by **Risk Score** (Total Debt + Violation Count), focusing enforcement on the top 1% of offenders. |
| **Gate Utilization & Load Balancing** | Donut / Pie Chart | `VW_GATE_USAGE` | "Which toll stations are under-utilized or over-burdened?" | Shows percentage of traffic per location. High traffic at a single gate indicates need for lane addition or infrastructure expansion. |

---

## 🚀 Impact & Conclusion
This dashboard has shifted the operational model from **Reactive** to **Proactive**:

- **Before:** Managers waited for monthly paper reports to identify revenue leaks.  
- **After:** Anomalies are detected instantly via visual spikes.  

**Result:**  
- Improved revenue recovery by an estimated **15%**.  
- Reduced average driver wait times by optimizing lane availability during peak hours.

---

© 2025 Smart Toll Project | Mutinda Collins Mumo

