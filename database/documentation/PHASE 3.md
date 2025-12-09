# 🛣️ Smart Toll & Traffic Monitoring System  
**Project Owner:** Mutinda Collins Mumo  
**ID Number:** 27842  
**Institution:** AUCA 

## Phase III: Logical Database Design  
### 📚 Data Dictionary

The following structured data dictionary covers all entities in the system, reflecting the implemented Oracle 19c schema.

---

### **1. Vehicles Table**
*Registry of all government-registered vehicles.*
| Column | Data Type | Key / Constraint | Description |
|--------|-----------|------------------|-------------|
| vehicle_id | NUMBER | PK | Unique vehicle identifier (Auto-increment) |
| plate_number | VARCHAR2(20) | UNIQUE | Official license plate |
| owner_name | VARCHAR2(100) | NOT NULL | Registered owner |
| vehicle_type | VARCHAR2(30) | CHECK | Class (Sedan, SUV, Truck, etc.) |
| registration_date | DATE | DEFAULT SYSDATE | Date of vehicle registration |

---

### **2. Toll_Gates Table**
*Configuration of physical toll stations.*
| Column | Data Type | Key / Constraint | Description |
|--------|-----------|------------------|-------------|
| gate_id | NUMBER | PK | Unique toll gate identifier |
| location | VARCHAR2(100) | NOT NULL | Geographic location name |
| road_name | VARCHAR2(50) | NOT NULL | Road where gate is located |
| lane_count | NUMBER | CHECK (>0) | Number of lanes at the gate |

---

### **3. Toll_Logs Table**
*Transactional record of every vehicle passage.*
| Column | Data Type | Key / Constraint | Description |
|--------|-----------|------------------|-------------|
| log_id | NUMBER | PK | Unique log record |
| vehicle_id | NUMBER | FK → Vehicles.vehicle_id | Vehicle reference |
| gate_id | NUMBER | FK → Toll_Gates.gate_id | Toll gate reference |
| entry_time | DATE | DEFAULT SYSDATE | Timestamp of entry |
| exit_time | DATE |  | Timestamp of exit (NULL if blocked) |
| payment_status | VARCHAR2(20) | CHECK | 'PAID', 'UNPAID', or 'PENDING' |

---

### **4. Vehicle_Fine Table**
*Records of traffic violations and debt.*
| Column | Data Type | Key / Constraint | Description |
|--------|-----------|------------------|-------------|
| fine_id | NUMBER | PK | Unique fine identifier |
| vehicle_id | NUMBER | FK → Vehicles.vehicle_id | Vehicle reference |
| fine_amount | NUMBER(10,2) | CHECK (>=0) | Monetary value of the fine |
| violation_type | VARCHAR2(100) | NOT NULL | Type (e.g., Speeding, Expired Insurance) |
| violation_date | DATE | DEFAULT SYSDATE | Date of violation |
| fine_status | VARCHAR2(20) | CHECK | 'PAID', 'UNPAID', 'WAIVED' |

---

### **5. Payments Table**
*Financial ledger for audit and revenue tracking.*
| Column | Data Type | Key / Constraint | Description |
|--------|-----------|------------------|-------------|
| payment_id | NUMBER | PK | Unique payment identifier |
| vehicle_id | NUMBER | FK → Vehicles.vehicle_id | Vehicle reference |
| amount | NUMBER(10,2) | CHECK (>=0) | Amount paid |
| payment_type | VARCHAR2(20) | CHECK | 'TOLL' or 'FINE' |
| payment_date | DATE | DEFAULT SYSDATE | Payment timestamp |
| reference_no | VARCHAR2(50) | UNIQUE | External payment reference (Mobile Money/Bank) |

---

## 📊 BI Considerations

To optimize query performance for reporting rather than transactions, the system utilizes a **Logical Dimensional Model (Star Schema)** concepts implemented via Materialized Views.

### Fact Tables (Logical)
1. **FACT_TOLL_PASSAGE** – derived from `TOLL_LOGS`.  
   - **Metrics:** Toll_Amount, Passage_Duration, Vehicle_Count  
   - **Grain:** One row per vehicle passage.

2. **FACT_VIOLATION_INCIDENT** – derived from `VEHICLE_FINE`.  
   - **Metrics:** Fine_Amount, Violation_Count  
   - **Grain:** One row per violation issued.

### Dimension Tables (Logical)
- **DIM_VEHICLE:** Attributes like License Plate, Vehicle Class, Owner Type.  
- **DIM_TOLL_GATE:** Attributes like Location, Region, Lane Capacity.  
- **DIM_TIME:** Temporal attributes (Hour, Day, Month) including `Is_Peak_Hour` flags for traffic analysis.  

---

### ⚡ Performance Strategy

- **Materialized Views:** Used to pre-aggregate heavy queries (e.g., `MV_HOURLY_TRAFFIC_STATS`) to ensure the dashboard loads instantly without stressing the operational tables.
- **Indexing:** B-Tree indexes applied to `plate_number`, `entry_time`, and Foreign Keys to speed up search and join operations.