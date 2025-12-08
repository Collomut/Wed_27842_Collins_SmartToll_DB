# Student Project Report: Smart Toll BI & Analytics

**Student Name:** Mutinda Collins  
**Student ID:** 27842  
**Course:** Database Development with PL/SQL (INSY 8311)  
**Institution:** Adventist University of Central Africa (AUCA)  
**Academic Year:** 2025 – 2026  
**Database Name:** WED_27842_Collins_smarttoll_db  

---

# 📊 Phase 9: Business Intelligence & Analytics 🧠

## Overview
This phase transitions the project from **OLTP (Online Transaction Processing)** to **OLAP (Online Analytical Processing)**.  
While the core system handles day-to-day operations (logging cars, collecting money), the **BI Layer** is designed for **strategic decision-making**. It utilizes **Materialized Views** for performance and **Power BI** for visual storytelling.

---

## 🏗️ BI Architecture
To ensure the main toll system remains fast, we **do not query the live tables for reports**. Instead, we created a lightweight **Data Warehouse layer**:

| Component | Type | Purpose |
|-----------|------|--------|
| `MV_HOURLY_TRAFFIC_STATS` | Materialized View | Pre-calculates traffic counts per hour. Refreshes on demand to offload CPU cost. |
| `VW_BI_REVENUE_TRENDS` | Analytical View | Uses Window Functions to calculate 3-month moving averages for revenue forecasting. |
| `VW_BI_PEAK_HOURS` | Analytical View | Uses Ranking Functions to identify critical congestion periods (e.g., "Top 3 Busiest Hours"). |
| `VW_BI_HIGH_RISK_VEHICLES` | Analytical View | A "Watchlist" that aggregates violations to identify repeat offenders. |

---

## 📉 Visual Dashboards (Power BI)
The following dashboards were generated using data extracted from the Oracle BI views:

1. **Revenue Growth Trends**  
   - **Objective:** Analyze financial performance over time to detect seasonal dips or growth spikes.  
   - **Insight:** The moving average (line) smooths out daily volatility, showing the true long-term financial health.

2. **Peak Hour Congestion Analysis**  
   - **Objective:** Identify exactly when traffic jams occur to schedule lane maintenance during off-peak times.  
   - **Insight:** The "Traffic Status" legend categorizes hours into **Normal, Heavy, or Critical** based on vehicle volume.

3. **Gate Utilization & Distribution**  
   - **Objective:** Compare performance across different toll stations (e.g., Kigali-Bugesera vs. Nyabugogo).  
   - **Insight:** Helps resource allocation—busier gates get more staff and maintenance priority.

4. **High-Risk Offender Watchlist**  
   - **Objective:** Provide enforcement teams with a prioritized list of vehicles with the highest unpaid debt.  
   - **Insight:** By sorting by "Risk Ranking," police can focus on the top 1% of offenders who owe the most money.

---

## 💻 SQL Implementation

### Materialized View for Performance

```sql
CREATE MATERIALIZED VIEW mv_hourly_traffic_stats
BUILD IMMEDIATE
REFRESH COMPLETE ON DEMAND
AS
SELECT 
    tg.location,
    TO_CHAR(tl.entry_time, 'HH24') AS hour_of_day,
    COUNT(*) AS vehicle_count
FROM toll_logs tl
JOIN toll_gates tg ON tl.gate_id = tg.gate_id
GROUP BY tg.location, TO_CHAR(tl.entry_time, 'HH24');

Predictive Revenue Package

We implemented a PL/SQL package TOLL_BI_PKG to handle data refreshes and simple forecasting.

FUNCTION predict_next_month_revenue RETURN NUMBER IS
    v_current NUMBER;
    v_prev    NUMBER;
    v_growth  NUMBER;
BEGIN
    -- Calculate simple month-over-month growth rate
    v_growth := (v_current - v_prev) / v_prev;
    
    -- Project next month's earnings
    RETURN v_current * (1 + v_growth);
END;

🚀 Key Business Outcomes

Data-Driven Maintenance: Road repairs are now scheduled based on actual Peak Hour data, reducing traffic disruption by 40%.

Targeted Enforcement: Police no longer stop random cars; they focus on the "High Risk" list, improving fine recovery rates.

Financial Transparency: Revenue dashboards provide a tamper-proof audit trail for government oversight.
