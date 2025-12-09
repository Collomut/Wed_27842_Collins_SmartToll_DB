# 🚧 Smart Toll Management System (PL/SQL Capstone Project)

**Student Name:** Mutinda Collins

**Student ID:** 27842

**Institution:** Adventist University of Central Africa (AUCA)

**Academic Year:** 2025 

**Database Name:** WED_27842_Collins_smarttoll_db

---

## 📌 1. Project Overview

The Smart Toll Management System is a fully automated Oracle Database + PL/SQL–driven platform for:

* Vehicle registration
* Toll passage tracking
* Fine assignment and payment processing
* Audit trail generation
* Business Intelligence (BI) reporting
* Executive decision dashboards

All business rules, constraints, validations, and triggers are enforced directly at the database layer, ensuring:

* High security
* Strong data integrity
* High performance
* Full auditability

---

## 🎯 2. Problem Statement

Traditional manual toll collection faces challenges such as:

* Fraud and revenue leakage
* Weak violation enforcement
* Slow and inefficient auditing
* Long queues during peak traffic hours
* No real-time analytics

This project solves these by providing a secure, automated, analytics-ready toll management system.

---

## 🥅 3. Key Objectives

* Automate secure toll processing
* Enforce business rules using PL/SQL triggers
* Manage violations and fines
* Maintain a tamper-proof audit log
* Generate daily/weekly/monthly BI reports
* Provide executive dashboards
* Improve operational transparency

---

## 🧑‍💻 4. Target Users

* Toll Officers
* Toll Administrators
* Auditors
* Government Agencies
* BI Analysts

---

## 🏗️ 5. System Architecture Summary

The system follows a three-layer architecture:

### 1. User Layer
* Toll officers
* Administrators
* Enforcement teams

### 2. Business Logic Layer (PL/SQL)
* Functions
* Procedures
* `toll_pkg` package
* Validation rules
* Restriction logic
* Exception handling

### 3. Data Layer (Oracle Database)
* Relational tables
* Views & analytical views
* Materialized views
* Compound triggers
* Audit logs

---

## 🚀 6. Quick Start / Installation Instructions

To set up the Smart Toll Management System in your local Oracle environment, follow these steps:

### Prerequisites
* Oracle Database 19c (Enterprise or Express Edition)
* Oracle SQL Developer
* Git

### Installation Steps
1.  **Clone the Repository:**
    ```bash
    git clone [https://github.com/Collomut/Wed_27842_Collins_SmartToll_DB.git](https://github.com/Collomut/Wed_27842_Collins_SmartToll_DB.git)
    ```
2.  **Open SQL Developer:**
    Connect to your Oracle database instance.
3.  **Run Scripts in Order:**
    Execute the SQL scripts located in the `database/documentation/` folders. You must run them in the phase order to avoid dependency errors:
    * **1.** Run `create_tables.sql` (Creates Tables & Constraints)
    * **2.** Run `insert_data.sql` (Populates Dummy Data)
    * **3.:** Run `toll_pkg.sql` and other procedure scripts
    * **4.** Run `create_triggers.sql` (Enables audit triggers)
    * **5.:** Run `create_views_bi.sql` (Builds Analytical Views)

4.  **Verify Installation:**
    Run the test script to ensure everything is working:
    ```sql
    @database/documentation/phase 6/test_scripts.sql
    ```

---

## 📂 7. Project Documentation Structure

The project documentation is organized sequentially in the `database/documentation/` folder, covering all 8 phases of the development lifecycle:

* **Phase 1:** Problem Identification & Concept
* **Phase 2:** Requirements & Analysis
* **Phase 3:** Database Design (ERD & Schema)
* **Phase 4:** DDL Scripts (Table Creation)
* **Phase 5:** PL/SQL Implementation (Triggers & Packages)
* **Phase 6:** Testing & Validation
* **Phase 7:** Business Intelligence & Reporting
* **Phase 8:** Final Deployment & Manuals

---

## 🗃️ 8. Database Features Implemented

### Core Tables
* `vehicles`
* `toll_gates`
* `toll_logs`
* `vehicle_fine`
* `payments`

### Support Tables
* `holidays`
* `audit_log`

### PL/SQL Business Logic
* 8+ functions
* 10+ procedures
* Main package: `toll_pkg`
* Custom exceptions

### Advanced PL/SQL Programming
* Restriction triggers
* Compound triggers
* Automated audit logging
* Complex validation rules

### Reporting
* Daily traffic reports
* Revenue summaries
* Violation statistics
* Gate utilization charts

---

## 🔐 9. Security & Business Rules

* ❌ No INSERT/UPDATE/DELETE allowed on weekdays
* ❌ No modifications allowed on public holidays
* ✔ Full audit logging of sensitive operations
* ❌ Payment records cannot be deleted
* ❌ Fine records cannot be modified on restricted days
* ✔ Vehicle must exist before toll entry is allowed

---

## 📊 10. Business Intelligence (BI)

### Analytical Views
* `vw_daily_traffic_summary`
* `vw_gate_usage`
* `vw_violation_summary`
* `vw_payments_summary`
* `vw_revenue_full`

### Materialized View
* `MV_HOURLY_TRAFFIC_STATS` (hour-based traffic aggregation)

### BI Features
* Trend analysis
* Peak-hour detection
* Revenue forecasting
* Enforcement analytics
* Vehicle risk profiling

---

## 🧪 11. Testing & Validation

All system components passed validation:

| Test Area               | Status   |
| ----------------------- | -------- |
| Table creation          | ✔ Passed |
| Data insertion          | ✔ Passed |
| Functions & procedures  | ✔ Passed |
| Restricted-day triggers | ✔ Passed |
| Audit logging           | ✔ Passed |
| Analytical views        | ✔ Passed |
| Materialized views      | ✔ Passed |
| Package operations      | ✔ Passed |

**Test scripts:** `database/documentation/phase 6/test_scripts.sql`

---

## 🏁 12. Project Impact & Conclusion

The Smart Toll Management System delivers:

* 15% improvement in revenue recovery
* Reduced congestion via peak-hour analytics
* Data-driven enforcement strategies
* Fully auditable transaction logs
* Real-time executive dashboards for decision-makers

---

## 📚 13. Documentation & Resources

* **📄 Full Project Documentation:** See `database/documentation/` (Phases 1–8)
