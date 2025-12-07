# 🛣️ Smart Toll & Traffic Monitoring System  
**Project Owner:** Mutinda Collins Mumo  
**ID Number:** 27842  
**Institution:** University of Rwanda  

## Phase III: Logical Database Design  
### 📚 Data Dictionary

The following structured data dictionary covers all entities in the system:

---

### **Vehicles Table**
| Column | Data Type | Key / Constraint | Description |
|--------|-----------|-----------------|-------------|
| vehicle_id | NUMBER | PK | Unique vehicle identifier |
| plate_number | VARCHAR2(20) | UNIQUE | Official license plate |
| owner_name | VARCHAR2(100) | NOT NULL | Registered owner |
| vehicle_type_id | NUMBER | FK → Vehicle_Type.vehicle_type_id | Vehicle type reference |
| registration_date | DATE |  | Vehicle registration date |

---

### **Toll_Gates Table**
| Column | Data Type | Key / Constraint | Description |
|--------|-----------|-----------------|-------------|
| gate_id | NUMBER | PK | Unique toll gate identifier |
| location | NUMBER |  | Geographic location ID |
| road_name | VARCHAR2(100) |  | Road where gate is located |
| lane_count | NUMBER |  | Number of lanes at the gate |

---

### **Toll_Logs Table**
| Column | Data Type | Key / Constraint | Description |
|--------|-----------|-----------------|-------------|
| log_id | NUMBER | PK | Unique log record |
| vehicle_id | NUMBER | FK → Vehicles.vehicle_id | Vehicle reference |
| gate_id | NUMBER | FK → Toll_Gates.gate_id | Toll gate reference |
| entry_time | TIMESTAMP |  | Timestamp of entry |
| exit_time | TIMESTAMP |  | Timestamp of exit |
| payment_status | VARCHAR2(20) |  | Payment completion status |

---

### **Vehicle_Fines Table**
| Column | Data Type | Key / Constraint | Description |
|--------|-----------|-----------------|-------------|
| fine_id | NUMBER | PK | Unique fine identifier |
| vehicle_id | NUMBER | FK → Vehicles.vehicle_id | Vehicle reference |
| violation_type_id | NUMBER | FK → Violation_Type.violation_type_id | Violation type |
| fine_amount | NUMBER |  | Fine amount |
| violation_date | DATE |  | Date of violation |
| fine_status | VARCHAR2(20) |  | Paid / Pending |

---

### **Payments Table**
| Column | Data Type | Key / Constraint | Description |
|--------|-----------|-----------------|-------------|
| payment_id | NUMBER | PK | Unique payment identifier |
| vehicle_id | NUMBER | FK → Vehicles.vehicle_id | Vehicle reference |
| log_id | NUMBER | FK → Toll_Logs.log_id | Toll log reference |
| payment_method_id | NUMBER | FK → Payment_Method.payment_method_id | Payment method |
| amount | NUMBER |  | Amount paid |
| payment_date | DATE |  | Payment timestamp |
| reference_no | VARCHAR2(50) | UNIQUE | Payment reference number |

---

## 📊 BI Considerations

The database supports **analytical reporting** using a **Dimensional Model (Star Schema)** to optimize query performance for reporting rather than transactions.

### Fact Tables
1. **FACT_TOLL_PASSAGE** – Records each vehicle passage.  
   - Metrics: Toll_Amount, Passage_Duration_Seconds, Vehicle_Count  
   - FKs: DIM_DATE, DIM_TIME, DIM_GATE, DIM_VEHICLE  

2. **FACT_VIOLATION_INCIDENT** – Records each issued fine.  
   - Metrics: Fine_Amount, Violation_Count  

### Dimension Tables
- **DIM_VEHICLE:** License Plate, Vehicle Class, Owner Type  
- **DIM_TOLL_GATE:** Gate Location, Region, Number of Lanes  
- **DIM_PAYMENT_METHOD:** Categorizes transaction types  
- **DIM_VIOLATION_TYPE:** Standardized enforcement codes  
- **DIM_DATE & DIM_TIME:** Temporal dimensions; DIM_TIME includes `Is_Peak_Hour` for traffic analysis  

---

### 🕒 Slowly Changing Dimensions (SCD)

Critical entities maintain **historical accuracy**:  

- **DIM_TOLL_GATE** & **DIM_VEHICLE** include audit columns:  
  - `Valid_From_Date` – Start of attribute validity  
  - `Valid_To_Date` – End of attribute validity (NULL for current)  
  - `Is_Current_Flag` – 1 for current, 0 for historical  

This ensures reports reflect historical prices or ownership accurately.  

---

### ⚡ Aggregation Levels & Performance

Pre-aggregated tables improve **dashboard responsiveness**:

- **Hourly Gate Performance:** Aggregated by Date, Hour, Gate ID – for peak-hour traffic analysis  
- **Monthly Revenue Summary:** Aggregated by Month, Payment Method – for financial repor
