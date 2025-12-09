# 🛣️ Smart Toll & Traffic Monitoring System  
**Project Owner:** Mutinda Collins Mumo  
**ID Number:** 27842  
**Institution:** AUCA (Adventist University of Central Africa)  
**PDB Name:** WED_27842_Collins_smarttoll_db  
**Schema:** TOLL_OWNER  

---

## Phase VII: Triggers, Restriction Function & Auditing  

### 📌 Overview
Phase 7 introduces the **Security and Governance Layer** of the application. It focuses on maintaining data integrity through enforced business rules and accountability through strict auditing.

By implementing database triggers and stored functions, the system ensures that:
1.  Operations occur only during authorized windows.
2.  All critical data changes are logged permanently.
3.  Complex transactional logic is handled automatically.

### ✅ Key Components Developed
* [x] **Infrastructure:** Created `HOLIDAYS` and `AUDIT_LOG` tables.
* [x] **Business Logic:** Implemented the `is_operation_allowed` restriction function.
* [x] **Access Control:** Deployed `BEFORE INSERT/UPDATE/DELETE` triggers to enforce time-based restrictions.
* [x] **Monitoring:** Implemented a **Compound Trigger** for traffic volume analysis.
* [x] **Auditing:** Deployed an automated **Audit Trigger** to track all changes to the `VEHICLES` registry.

---

## 1️⃣ Restriction Infrastructure

### **Holiday Table**
* **Purpose:** Stores a calendar of national holidays.
* **Function:** Acts as a reference point for the restriction logic; operations are automatically blocked if the current date matches an entry in this table.

### **Restriction Function**


* **Logic:** A Boolean function (`is_operation_allowed`) that serves as the central "Gatekeeper" for the database.
* **Rules:**
    * Detects the current day using `TO_CHAR(SYSDATE, 'DY')`.
    * Returns `FALSE` on **Weekends (Sat/Sun)** or **Holidays**.
    * Returns `TRUE` only on normal working days.
* **Usage:** Called dynamically inside triggers to prevent unauthorized `INSERT`, `UPDATE`, or `DELETE` operations.

---

## 2️⃣ Auditing Infrastructure

### **Audit Table**
* **Purpose:** A secure, immutable log of all DML operations.
* **Schema:**
    * `Table_Name`, `Operation` (INS/UPD/DEL), `User`, `Timestamp`.
    * `Old_Values` (Pre-change data) and `New_Values` (Post-change data).
* **Significance:** Ensures full accountability and security compliance for government toll data.

### **Audit Trigger (`trg_vehicle_audit`)**
* **Type:** `AFTER ROW` Trigger.
* **Target:** `VEHICLES` table.
* **Behavior:**
    * **INSERT:** Logs the new vehicle details.
    * **UPDATE:** Logs both the old data (e.g., previous owner) and the new data.
    * **DELETE:** Logs the details of the removed vehicle.
* **Outcome:** Satisfies mandatory activity tracking requirements.

---

## 3️⃣ Operational Triggers

### **Security Triggers (Time-Based Enforcement)**
These triggers utilize the `Restriction Function` to enforce business rules:

1.  **`trg_vehicle_insert_control` (BEFORE INSERT):**
    * Prevents new vehicle registrations outside of working hours.
    * Raises `ORA-20050` if attempted on a Weekend/Holiday.

2.  **`trg_vehiclefine_update_control` (BEFORE UPDATE):**
    * Locks down fine records on restricted days to protect financial integrity.

3.  **`trg_payments_delete_control` (BEFORE DELETE):**
    * Strictly prohibits the deletion of financial transaction records at any time, ensuring an accurate audit trail.

### **Compound Trigger (`trg_toll_logs_compound`)**
* **Purpose:** Advanced monitoring of traffic activity.
* **Mechanism:** Combines `BEFORE STATEMENT`, `BEFORE EACH ROW`, and `AFTER STATEMENT` timing points.
* **Function:** Counts the exact number of rows inserted, updated, or deleted during a batch operation and outputs a summary via `DBMS_OUTPUT`.

---

## 4️⃣ Testing & Validation


A comprehensive test suite executed to validate security measures:

* **Restriction Test:**
    * Attempted to insert a vehicle on a restricted day.
    * **Result:** System correctly raised an error and blocked the transaction.
* **Audit Test:**
    * Performed DML operations (Insert/Update) on `VEHICLES`.
    * **Result:** Queried `AUDIT_LOG` and confirmed accurate capture of User, Time, Old Values, and New Values.
* **Compound Trigger Test:**
    * Performed batch updates on `TOLL_LOGS`.
    * **Result:** Confirmed correct row counts were printed to the console.

---

### 📝 Conclusion
Phase 7 ensures the Smart Toll & Traffic Monitoring System is **secure, compliant, and auditable**. By moving enforcement logic into the database layer via Triggers and Functions, the system guarantees that business rules cannot be bypassed by external applications.