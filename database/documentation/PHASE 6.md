# 🛣️ Smart Toll & Traffic Monitoring System  
**Project Owner:** Mutinda Collins Mumo  
**ID Number:** 27842  
**Institution:** AUCA (Adventist University of Central Africa)  
**PDB Name:** WED_27842_Collins_smarttoll_db  
**Schema:** TOLL_OWNER  

---

## Phase VI: PL/SQL Development Documentation  

### 📌 Development Overview
This phase focuses on the construction of the **Business Logic Layer** using Oracle PL/SQL. The core functionality of the Smart Toll System—including fine management, toll processing, and automated reporting—is encapsulated within the comprehensive **`TOLL_PKG`** package.

This approach ensures modularity, security, and ease of maintenance by keeping business rules separate from the data storage layer.

### ✅ Key Components Developed
* [x] **PL/SQL Package Architecture:** Complete Specification (`.spec`) and Body (`.body`) implementation.
* [x] **Transactional Procedures:** Logic for `INSERT`, `UPDATE`, and `DELETE` operations on Toll and Fine data.
* [x] **Analytical Functions:** Custom functions for dynamic fee calculation, balance checks, and validation.
* [x] **Advanced Reporting:** Implementation of Explicit Cursors and Window Functions for trend analysis.
* [x] **Testing Framework:** Automated test scripts validating all procedures via `DBMS_OUTPUT`.

---

## 1️⃣ Package Specification (API Definition)
**File:** `06_toll_pkg_spec.sql`  

The specification defines the public API for the application, exposing:
* **10+ Business Functions:** including `get_vehicle_balance`, `calculate_toll_fee`, `validate_plate`.
* **10+ Operational Procedures:** including `record_entry`, `pay_fine`, `settle_debt`.
* **Custom Exceptions:** Error handling definitions for `FINE_NOT_FOUND` or `INSUFFICIENT_FUNDS`.
* **Reporting Interface:** Public procedures for generating daily revenue summaries.

---

## 2️⃣ Package Body (Logic Implementation)
**File:** `07_toll_pkg_body.sql`  

This file contains the compiled executable logic. Key implementations include:
* **Fine Management:** Logic to Add, Pay, and Settle fines, ensuring `VEHICLE_FINE` and `PAYMENTS` tables stay synchronized.
* **Toll Processing:** Automated Entry/Exit logic that validates plates and calculates duration.
* **Dynamic Fee Calculation:** Rules engine that determines cost based on `vehicle_type` (e.g., Truck vs. Sedan).
* **Data Validation:** Regex checks to ensure Plate Numbers follow standard formatting.
* **Error Handling:** Robust `RAISE_APPLICATION_ERROR` calls to prevent invalid data states.

✅ **Status:** Compiled Successfully. Object Status is **VALID**.

---

## 3️⃣ Advanced Reporting (Cursors)
**File:** `08_cursors.sql`  

Iterative reporting logic implemented via cursors:
* **Cursor A (High-Risk Reporting):** `Top Unpaid Vehicles`
    * *Logic:* Aggregates total unpaid fines per vehicle and ranks them via `DBMS_OUTPUT`.
* **Cursor B (Operational Reporting):** `Last 24-Hour Traffic`
    * *Logic:* Joins `TOLL_LOGS` with `VEHICLES` to display a chronological list of recent activity.

---

## 4️⃣ Analytics (Window Functions)
**File:** `09_window_functions.sql`  

SQL-based analytics for complex data questions:
* **`RANK()`**: Used to rank vehicles by total violation count to identify habitual offenders.
* **`LAG()`**: Used to compare current violation dates with previous ones to detect rapid repeat offenses.
* **`OVER(PARTITION BY...)`**: Used to generate running totals of revenue per Gate without collapsing rows.

---

## 5️⃣ Testing & Verification
**File:** `10_test_plsql.sql`  

A comprehensive test suite executed to validate the package:
* **Unit Tests:** Validated individual functions like `get_vehicle_profile`.
* **Integration Tests:**
    * Simulated a full "Gate Cycle" (Entry → Exit → Payment).
    * Verified that paying a fine automatically updates the `PAYMENTS` ledger.
    * Confirmed that invalid plates trigger the correct Exception messages.

---

### 📝 Conclusion
This phase demonstrates a **robust PL/SQL implementation**. By encapsulating business logic within packages and utilizing advanced features like Window Functions and Cursors, the system achieves high performance, data integrity, and analytical depth required for a modern traffic monitoring solution.