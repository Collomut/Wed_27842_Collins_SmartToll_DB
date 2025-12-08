# 🧠 Smart Toll Management System – Design Decisions  
**Student:** Mutinda Collins  
**Student ID:** 27842  
**Database:** WED_27842_Collins_smarttoll_db  
**Institution:** Adventist University of Central Africa (AUCA)  
**Course:** Database Development with PL/SQL (INSY 8311)  

---

## 📌 1. Purpose of This Document

This document explains the **key technical and architectural decisions** made during the design and implementation of the **Smart Toll Management System**. Each decision was guided by:
- Capstone requirements
- Database best practices
- Security, performance, and scalability needs
- Business Intelligence (BI) readiness

---

## 🏗️ 2. Choice of Architecture: Database-Centric Design

### ✅ Decision:
All business logic was implemented **directly inside the Oracle Database using PL/SQL** instead of an external application layer.

### ✅ Justification:
- Ensures **data integrity at source**
- Provides **high performance through stored execution**
- Enforces **centralized business rules**
- Reduces dependency on external applications
- Meets **INSY 8311 advanced PL/SQL requirements**

---

## 🗃️ 3. Database Normalization (3NF)

### ✅ Decision:
All core tables were normalized to **Third Normal Form (3NF)**.

### ✅ Justification:
- Eliminates data redundancy
- Prevents update anomalies
- Improves storage efficiency
- Enhances long-term maintainability

Example:
- Vehicle owner details stored only in `vehicles`
- Violations and toll logs reference `vehicles` using foreign keys

---

## 🧑‍💼 4. Use of Surrogate Primary Keys

### ✅ Decision:
Auto-generated numeric primary keys were used instead of natural keys.

Example:
- `vehicle_id`, `gate_id`, `log_id`, `payment_id`, `fine_id`

### ✅ Justification:
- Faster indexing and joins
- Prevents business key changes from affecting relationships
- Enhances system scalability

---

## 🔗 5. Foreign Key Enforcement

### ✅ Decision:
Strict referential integrity was enforced using **foreign key constraints**.

### ✅ Justification:
- Prevents orphan records
- Ensures all fines, payments, and logs reference valid vehicles
- Supports accurate BI reporting

---

## ⚙️ 6. Use of PL/SQL Packages

### ✅ Decision:
Core business logic was grouped inside a **single service package (`toll_pkg`)**.

### ✅ Justification:
- Encapsulation of related operations
- Simplified maintenance
- Improved modularity
- Better performance due to shared memory
- Secure access through controlled interfaces

---

## ✅ 7. Use of Functions vs Procedures

| Design Choice | Reason |
|---------------|--------|
| Functions | Used where a return value is required (counts, totals, validation, lookups) |
| Procedures | Used for transactional operations (insert, update, delete, payments, reporting) |

This ensures **clean separation of responsibilities**.

---

## 🛡️ 8. Business Rule Enforcement via Triggers

### ✅ Decision:
Critical business rules were enforced using **BEFORE triggers**.

### Rule Implemented:
Employees **cannot INSERT, UPDATE, or DELETE** on:
- Weekdays (Monday–Friday)
- Public holidays

### ✅ Justification:
- Prevents circumvention of rules
- Works regardless of application layer
- Enforces security at the database level
- Meets **Phase VII restriction requirement**

---

## 🧾 9. Auditing Strategy

### ✅ Decision:
Auditing was implemented using:
- `audit_log` table
- `AFTER INSERT/UPDATE/DELETE` triggers

### ✅ Justification:
- Tracks who changed what and when
- Supports accountability
- Enables forensic investigation
- Enhances compliance with enterprise standards

---

## 🚀 10. Performance Optimization Decisions

### ✅ Indexing
Indexes were created on:
- `vehicles(plate_number)`
- `toll_logs(vehicle_id)`
- `toll_logs(gate_id)`
- `vehicle_fine(vehicle_id)`
- `payments(vehicle_id)`

### ✅ Justification:
- Speeds up joins
- Improves reporting performance
- Optimizes BI analytics queries

---

## 📊 11. BI-Oriented Design Decisions

### ✅ Decision:
Dedicated **analytical views** were created to simplify reporting.

Views include:
- `vw_daily_traffic_summary`
- `vw_gate_usage`
- `vw_violation_summary`
- `vw_payments_summary`
- `vw_revenue_full`

### ✅ Justification:
- Reduces query complexity for analysts
- Improves dashboard performance
- Enables trend and KPI tracking
- Supports executive reporting

---

## 🔐 12. Security & User Separation

### ✅ Decision:
Two main database users were created:
- `toll_admin` – Full DBA privileges
- `toll_owner` – Application schema owner

### ✅ Justification:
- Principle of least privilege
- Prevents accidental system damage
- Supports production-grade deployment model

---

## 🧪 13. Testing Strategy

### ✅ Decision:
A full **SQL-based test suite** was implemented.

### Tests cover:
- Data insertion
- Function validation
- Procedure execution
- Trigger restriction enforcement
- Report generation
- View correctness

### ✅ Justification:
- Ensures system reliability
- Verifies correctness before submission
- Provides proof of implementation

---

## 🗄️ 14. Tablespace Separation Strategy

### ✅ Decision:
Dedicated tablespaces were created:
- `toll_data` – Application data
- `toll_index` – Indexes
- `toll_temp` – Temporary operations

### ✅ Justification:
- Improves performance
- Enhances storage control
- Supports future scalability

---

## ⚖️ 15. Error Handling Strategy

### ✅ Decision:
All critical procedures use:
- Custom exceptions
- `RAISE_APPLICATION_ERROR`
- Structured exception blocks

### ✅ Justification:
- Provides meaningful error messages
- Improves debugging
- Enhances application stability
- Prevents silent failures

---

## ✅ 16. Alignment with AUCA Capstone Requirements

| Capstone Phase | Covered | Evidence |
|---------------|---------|----------|
| Phase IV | ✅ | PDB, tablespaces, users |
| Phase V | ✅ | Tables, indexes, constraints |
| Phase VI | ✅ | Functions, procedures, packages |
| Phase VII | ✅ | Triggers, auditing, restrictions |
| Phase VIII | ✅ | BI views, reports, documentation |

---

## 📌 Conclusion

All design decisions taken in the **Smart Toll Management System** were driven by:
- Industry database best practices
- Security, auditing, and compliance needs
- Performance optimization
- BI readiness
- AUCA capstone technical standards

The system is therefore:
✅ Secure  
✅ Scalable  
✅ Maintainable  
✅ Analytics-ready  
✅ Production-grade  

---

📍 *End of Design Decisions Document*
