# 🛣️ Smart Toll & Traffic Monitoring System  
**Project Owner:** Mutinda Collins Mumo  
**ID Number:** 27842  
**Institution:** AUCA (Adventist University of Central Africa)  
**PDB Name:** WED_27842_Collins_smarttoll_db  

---

## Phase V: Table Implementation & Data Verification  

### 📌 Overview
This phase marks the transition from design to physical implementation. It confirms that the relational schema defined in Phase III has been successfully deployed to the Oracle 19c Pluggable Database. The focus is on establishing **Structural Integrity**, enforcing **Business Constraints**, and validating **Referential Integrity** through realistic sample data.

---

### ✅ Completed Tasks checklist
The following milestones have been achieved and verified:
* [x] **Schema Deployment:** Created all **5 core entities** (`VEHICLES`, `TOLL_GATES`, `TOLL_LOGS`, `VEHICLE_FINE`, `PAYMENTS`).
* [x] **Constraint Enforcement:** Applied Primary Keys (PK), Foreign Keys (FK), Check Constraints, and Unique Constraints to maintain data validity.
* [x] **Data Population:** Inserted realistic sample datasets to simulate live traffic and violations.
* [x] **Query Testing:** Executed complex queries (JOINS, Aggregations, Subqueries) to test data retrieval performance.
* [x] **Integrity Audit:** Verified that no orphan records exist and all relationships are valid.

---

## 📊 Validation Summary

### 1️⃣ Structural Validation
Confirmed the existence and correct configuration of all schema objects:
* **`VEHICLES`**: Successfully created with Unique Plate constraint.
* **`TOLL_GATES`**: Successfully created with Location and Lane Count.
* **`TOLL_LOGS`**: Successfully created with Timestamp precision.
* **`VEHICLE_FINE`**: Successfully created with Status constraints ('PAID'/'UNPAID').
* **`PAYMENTS`**: Successfully created with Financial precision.

### 2️⃣ Data Quality & Integrity
* **Row Count Verification:** All tables contain the expected number of seed rows.
* **Referential Integrity:**
    * Every toll log entry links to a valid Vehicle and Gate.
    * Every fine is associated with an existing Vehicle ID.
    * Every payment record references a valid Vehicle.
* **Constraint Testing:**
    * Mandatory fields do not accept `NULL` values.
    * Duplicate plate numbers were rejected by the `UNIQUE` constraint.

---

## 🧪 Test Execution Report

The following SQL patterns were executed to stress-test the schema:

### 🔗 JOIN Operations
* **Objective:** Link Vehicles to their Activity.
* **Query Type:** `INNER JOIN` between `VEHICLES` and `TOLL_LOGS`.
* **Result:** Successfully retrieved comprehensive passage history for specific cars.

### 📈 Aggregation & Grouping
* **Objective:** Calculate Financial Totals.
* **Query Type:** `SUM(amount)` grouped by `gate_id` and `payment_type`.
* **Result:** Accurate calculation of Total Toll Revenue vs. Total Fine Revenue.

### 🔍 Complex Filtering (Subqueries)
* **Objective:** Identify High-Risk Drivers.
* **Query Type:** Subquery filtering vehicles with `COUNT(fine_id) > 2`.
* **Result:** Correctly identified habitual offenders.

---

### 📝 Conclusion
This phase confirms that the database **structure, constraints, and data integrity** are correctly implemented. The schema is now stable, populated, and ready for the implementation of PL/SQL automation (Phase VI) and Business Intelligence layers.