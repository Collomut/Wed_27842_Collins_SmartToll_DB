# 📘 Smart Toll Management System – Data Dictionary  
**Student:** Mutinda Collins  
**Student ID:** 27842  
**Database:** WED_27842_Collins_smarttoll_db  
**Institution:** Adventist University of Central Africa (AUCA)  
**Course:** Database Development with PL/SQL (INSY 8311)  

---

## 📌 Purpose of This Document
This data dictionary provides a detailed description of all database tables, columns, data types, constraints, and their functional purpose within the **Smart Toll Management System**. It serves as a technical reference for developers, database administrators, and system auditors.

---

## 🗂️ 1. TABLE: `vehicles`
Stores all registered vehicles using the toll system.

| Column Name       | Data Type        | Constraints                         | Description |
|-------------------|------------------|--------------------------------------|-------------|
| vehicle_id        | NUMBER           | PK, AUTO INCREMENT                  | Unique vehicle identifier |
| plate_number      | VARCHAR2(20)     | NOT NULL, UNIQUE                    | Vehicle registration number |
| owner_name        | VARCHAR2(100)    | NOT NULL                            | Full name of vehicle owner |
| vehicle_type      | VARCHAR2(30)     | CHECK ('Sedan','SUV','Truck','Bus','Motorcycle','Van') | Type of vehicle |
| registration_date | DATE             | DEFAULT SYSDATE                     | Date vehicle was registered |

---

## 🗂️ 2. TABLE: `toll_gates`
Stores all toll gate locations and road details.

| Column Name | Data Type      | Constraints       | Description |
|-------------|----------------|-------------------|-------------|
| gate_id     | NUMBER         | PK, AUTO INCREMENT | Unique gate identifier |
| location    | VARCHAR2(100)  | NOT NULL          | Physical location of the gate |
| road_name   | VARCHAR2(50)   | NOT NULL          | Name of the road |
| lane_count  | NUMBER         | CHECK (> 0)       | Number of toll lanes |

---

## 🗂️ 3. TABLE: `toll_logs`
Records all vehicle entries and exits at toll gates.

| Column Name     | Data Type      | Constraints                           | Description |
|------------------|----------------|----------------------------------------|-------------|
| log_id           | NUMBER         | PK, AUTO INCREMENT                     | Unique toll log record |
| vehicle_id       | NUMBER         | FK → vehicles(vehicle_id), NOT NULL   | Vehicle using the gate |
| gate_id          | NUMBER         | FK → toll_gates(gate_id), NOT NULL    | Gate used |
| entry_time       | DATE           | DEFAULT SYSDATE                        | Time vehicle entered |
| exit_time        | DATE           | NULLABLE                               | Time vehicle exited |
| payment_status   | VARCHAR2(20)   | CHECK ('PAID','UNPAID','PENDING')     | Toll payment status |

---

## 🗂️ 4. TABLE: `vehicle_fine`
Stores all traffic and toll-related violations.

| Column Name     | Data Type      | Constraints                          | Description |
|------------------|----------------|--------------------------------------|-------------|
| fine_id          | NUMBER         | PK, AUTO INCREMENT                  | Unique fine identifier |
| vehicle_id       | NUMBER         | FK → vehicles(vehicle_id), NOT NULL | Vehicle fined |
| fine_amount      | NUMBER(10,2)   | CHECK (>= 0)                        | Amount charged |
| violation_type   | VARCHAR2(100)  | NOT NULL                            | Type of violation |
| violation_date   | DATE           | DEFAULT SYSDATE                     | Date of violation |
| fine_status      | VARCHAR2(20)   | CHECK ('PAID','UNPAID','WAIVED')    | Payment status |

---

## 🗂️ 5. TABLE: `payments`
Stores all toll and fine payments.

| Column Name     | Data Type      | Constraints                          | Description |
|------------------|----------------|--------------------------------------|-------------|
| payment_id       | NUMBER         | PK, AUTO INCREMENT                  | Unique payment record |
| vehicle_id       | NUMBER         | FK → vehicles(vehicle_id), NOT NULL | Vehicle making payment |
| amount           | NUMBER(10,2)   | CHECK (>= 0)                        | Amount paid |
| payment_type     | VARCHAR2(20)   | CHECK ('FINE','TOLL')               | Type of payment |
| payment_date     | DATE           | DEFAULT SYSDATE                     | Date of transaction |
| reference_no     | VARCHAR2(50)   | UNIQUE                              | Payment reference |

---

## 🗂️ 6. TABLE: `holidays`
Stores public holidays used for system operation restrictions.

| Column Name   | Data Type      | Constraints           | Description |
|---------------|----------------|------------------------|-------------|
| holiday_id    | NUMBER         | PK, AUTO INCREMENT    | Unique holiday identifier |
| holiday_name  | VARCHAR2(100)  | NOT NULL              | Name of the holiday |
| holiday_date  | DATE           | UNIQUE, NOT NULL      | Official holiday date |

---

## 🗂️ 7. TABLE: `audit_log`
Tracks all critical database operations for security and accountability.

| Column Name    | Data Type      | Constraints        | Description |
|----------------|----------------|--------------------|-------------|
| audit_id       | NUMBER         | PK, AUTO INCREMENT| Unique audit record |
| table_name     | VARCHAR2(50)   | NOT NULL           | Affected table |
| operation      | VARCHAR2(20)   | NOT NULL           | INSERT, UPDATE, DELETE |
| changed_by     | VARCHAR2(50)   | NOT NULL           | Database user |
| old_data       | VARCHAR2(4000) | NULLABLE           | Previous values |
| new_data       | VARCHAR2(4000) | NULLABLE           | New values |
| change_date    | DATE           | DEFAULT SYSDATE    | Timestamp of change |

---

## 🔗 RELATIONSHIP SUMMARY

- `vehicles` → parent table for:
  - `toll_logs`
  - `vehicle_fine`
  - `payments`
- `toll_gates` → parent table for:
  - `toll_logs`
- `audit_log` → captures changes from:
  - `vehicles`
  - Any future controlled tables

---

## ✅ DATA INTEGRITY RULES

- Every toll log must reference a valid **vehicle and gate**.
- Every fine and payment must belong to a valid **vehicle**.
- No duplicate vehicle plate numbers are allowed.
- No negative values are allowed for **payments or fines**.
- Unauthorized data operations on weekdays and public holidays are restricted.

---

## 🧠 BI & ANALYTICS SUPPORT

This design supports:
- Daily traffic analytics
- Revenue tracking (tolls vs fines)
- Violation trend analysis
- Gate usage optimization
- Compliance auditing through triggers & logs

---

✅ **Document Status:** Complete  
✅ **Normalization:** 3rd Normal Form (3NF)  
✅ **BI Ready:** Yes  
✅ **Security & Audit Ready:** Yes  

---

📌 *End of Data Dictionary*
