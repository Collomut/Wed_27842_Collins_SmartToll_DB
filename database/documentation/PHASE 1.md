# 🛣️ Smart Toll and Traffic Monitoring System  
**Project Owner:** Mutinda Collins Mumo  
**ID Number:** 27842  

---

## 💡 Project Idea

With the rapid growth of the transport sector, there is a critical need for constant monitoring of highways and effective reporting to the Ministry of Transport for planning, maintenance, and infrastructure improvement. Toll stations are a pivotal component in achieving these goals.

However, traditional manual toll operations face several challenges:

- ⏱️ Time delays caused by manual entry of vehicle data  
- 💰 Revenue leakage due to uncollected fines and lack of audit trails  
- ❌ Human errors during data entry and debt calculation  
- 📊 Data blindness regarding peak traffic hours and financial trends  
- 🚗 Traffic congestion resulting from slow processing speeds  

This project addresses these issues by transitioning from a manual process to a database-driven automated solution. It aims to:

- 🤖 Automate the entire lifecycle of vehicle detection, debt checking, and payment processing  
- 📝 Provide a 360-degree view of every vehicle, instantly flagging unpaid fines  
- ✅ Ensure integrity and security through automated audit logs and error tracking  
- 📈 Empower decision-makers with Business Intelligence (BI) dashboards for real-time analytics  

---

## 🗄️ Database Schema

The system uses a robust **Oracle 19c Relational Database** organized into two categories:  
**Core Business Entities** and **System Support Logic**.

---

### **1. Core Business Tables**

These tables handle the day-to-day operations of the toll system.

#### **Vehicles (Parent Entity)**
- **Purpose:** Registry of all government-registered vehicles  
- **Fields:** `vehicle_id (PK)`, `plate_number (Unique)`, `owner_name`, `vehicle_type`, `registration_date`

#### **Toll_gates (Parent Entity)**
- **Purpose:** Configuration of physical toll stations  
- **Fields:** `gate_id (PK)`, `location`, `road_name`, `lane_count`

#### **Toll_logs (Transactional Entity)**
- **Purpose:** High-volume table recording every entry/exit event  
- **Fields:** `log_id (PK)`, `vehicle_id (FK)`, `gate_id (FK)`, `entry_time`, `payment_status (Pending/Paid)`

#### **Vehicle_fine (Transactional Entity)**
- **Purpose:** Tracks violation history and debt status  
- **Fields:** `fine_id (PK)`, `vehicle_id (FK)`, `fine_amount`, `violation_type`, `fine_status (Paid/Unpaid)`

#### **Payments (Financial Entity)**
- **Purpose:** Permanent ledger of all financial transactions  
- **Fields:** `payment_id (PK)`, `vehicle_id (FK)`, `amount`, `payment_type (Toll/Fine)`, `reference_no`

---

### **2. System Support & Logic Tables**

#### **Audit_Log**
Automatically tracks critical data changes (e.g., owner transfers) to ensure security compliance and prevent fraud.

#### **Holidays**
Stores specific dates used by system triggers to restrict administrative operations during public holidays.

#### **High_Priority_Alerts**
Captures vehicles with severe violations (Fines > 50,000 RWF) for immediate police action.

#### **System_Error_Logs**
Captures PL/SQL runtime errors, allowing the system to recover gracefully without crashing the gate interface.

---

## ⚙️ Technical Implementation

The "Smart" logic of the system is implemented using **PL/SQL** to ensure speed and security at the database level.

---

### **1. Automation Logic (Packages & Procedures)**

#### **TOLL_SYS_PKG**
A central package encapsulating the core business logic.

- **record_passage**  
  Validates a vehicle’s plate and checks for outstanding debt.  
  If `debt > 0`, the gate is automatically locked.

- **check_debt_status**  
  Calculates the sum of all `UNPAID` fines in real-time.

---

### **2. Security & Compliance (Triggers)**

#### **Audit Triggers (TRG_VEHICLE_AUDIT)**
Automatically records *Old* and *New* values whenever a vehicle’s owner is changed, creating a tamper-proof history.

#### **Operational Constraints**
- **Weekday Maintenance Mode:**  
  Trigger `TRG_PAYMENTS_DELETE_CONTROL` uses `is_operation_allowed`  
  to block administrative deletions on weekdays (Mon–Fri).  
  Maintenance allowed only on weekends.

---

### **3. Business Intelligence & Analytics**

To transition from simple storage to strategic insight, an **OLAP layer** was built.

#### **Materialized Views**
Used to pre-calculate heavy traffic statistics (`MV_HOURLY_TRAFFIC_STATS`) so that dashboards do not slow down live gate operations.

#### **Power BI Dashboard KPIs**
- Revenue Growth Trends (Line Chart)  
- Peak Hour Congestion Analysis (Bar Chart)  
- High-Risk Offender Watchlist (Table)

---

## 🚀 Innovation and Improvements

Key innovations include:

- 🛑 **Automatic Fine Enforcement:** Gate locks instantly if outstanding debt exists  
- 📊 **Integrated Traffic Analysis:** Uses window functions (`RANK`, `AVG`) to detect congestion spikes  
- 💵 **Financial Integrity:** Immutable transaction history via `PAYMENTS` and `AUDIT_LOGS`  
- ⚡ **Performance Optimization:** `BULK COLLECT` and `FORALL` enable high-speed processing of logs  

---

## 🔮 Future Enhancements

- 📡 **IoT Integration:** Connect ANPR cameras directly to PL/SQL API  
- 🚦 **Dynamic Pricing:** AI-powered toll price adjustments based on congestion  
- 📱 **Mobile Application:** Allow drivers to view balances and pay via Mobile Money  
- ☁️ **Cloud Scalability:** Migrate to Oracle Cloud Infrastructure (OCI) for national deployment  

---
