# 🛣️ Smart Toll & Traffic Monitoring System  
**Project Owner:** Mutinda Collins Mumo  
**ID Number:** 27842  
**Institution:** AUCA (Adventist University of Central Africa)  
**PDB Name:** WED_27842_Collins_smarttoll_db  
**Schema:** TOLL_OWNER  

---

## Phase VIII: Views, Reports & Materialized Views  

### 📌 Overview
Phase 8 shifts the focus from transactional processing (OLTP) to **Analytical Processing (OLAP)**. By implementing a layer of Database Views and Reporting Scripts, this phase transforms raw data into actionable insights.

These objects abstract complex SQL joins and aggregations, allowing administrators and government authorities to monitor toll activity, traffic patterns, and revenue collection efficiently without writing complex queries.

### ✅ Key Components Developed
* [x] **Analytical Layer:** Implemented **8 SQL Views** to simplify data access.
* [x] **Reporting Suite:** Developed **6 Prebuilt Reporting Queries** for common business questions.
* [x] **Verification:** Executed a comprehensive test script (`21_phase8_test.sql`) to validate data accuracy and aggregation logic.

---

## 1️⃣ Implemented Views (Virtual Tables)

The following views were created to present data in a user-friendly format, hiding the complexity of underlying table joins:

| View Name | Description | Key Tables Joined |
| :--- | :--- | :--- |
| **`vw_vehicle_profile`** | **360-Degree Vehicle View:** Consolidates vehicle details with their total debt and violation history. | `VEHICLES`, `VEHICLE_FINE` |
| **`vw_toll_activity`** | **Complete Log History:** detailed record of every entry/exit, including gate location and payment status. | `TOLL_LOGS`, `VEHICLES`, `TOLL_GATES` |
| **`vw_daily_traffic_summary`** | **Traffic Trends:** Aggregates vehicle counts by date to identify busy days. | `TOLL_LOGS` |
| **`vw_violation_summary`** | **Risk Analysis:** Summarizes total violations and fine amounts per vehicle. | `VEHICLE_FINE`, `VEHICLES` |
| **`vw_payments_summary`** | **Revenue Overview:** Aggregates total revenue collected, split by Toll vs. Fine payments. | `PAYMENTS` |
| **`vw_gate_usage`** | **Infrastructure Load:** Ranks toll gates by traffic volume to identify bottlenecks. | `TOLL_GATES`, `TOLL_LOGS` |
| **`vw_unpaid_fines`** | **Enforcement List:** Filters and displays only vehicles with outstanding debt. | `VEHICLE_FINE` (Where Status = 'UNPAID') |
| **`vw_revenue_full`** | **Audit Trail:** A detailed list of all financial transactions with reference numbers. | `PAYMENTS`, `VEHICLES` |

---

## 2️⃣ Reporting Suite

Using the views above, the following analytical reports can now be generated instantly:

1.  **Daily Traffic Report:**
    * *Purpose:* Monitors daily throughput to assist in staff scheduling.
    * *Source:* `vw_daily_traffic_summary`.
2.  **Gate Usage Report:**
    * *Purpose:* Identifies the most and least utilized gates for maintenance planning.
    * *Source:* `vw_gate_usage`.
3.  **Violation Summaries:**
    * *Purpose:* Provides a leaderboard of "High Risk" vehicles for police enforcement.
    * *Source:* `vw_violation_summary`.
4.  **Total Revenue Report:**
    * *Purpose:* Financial reconciliation tool for auditing daily collections.
    * *Source:* `vw_payments_summary`.
5.  **Vehicle History Report:**
    * *Purpose:* Customer service tool to show a driver their entire movement history.
    * *Source:* `vw_vehicle_profile` joined with `vw_toll_activity`.

---

## 3️⃣ Testing & Verification
**File:** `21_phase8_test.sql`

A robust test suite was executed to ensure the views return accurate data:

* **Correctness:** Verified that `vw_unpaid_fines` correctly excludes paid citations.
* **Aggregation:** Confirmed that `vw_revenue_full` totals match the sum of the `PAYMENTS` table.
* **Performance:** Validated that views load efficiently even with simulated high-volume data.

---

### 📝 Conclusion
Phase 8 ensures the system supports **advanced analytical reporting**. By decoupling the reporting logic from the physical tables, the system allows for safer, faster, and more insightful decision-making by Ministry of Transport officials.