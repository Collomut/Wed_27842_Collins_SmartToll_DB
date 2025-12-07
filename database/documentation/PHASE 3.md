Phase III 
Logical Database Design
Data Dictionary

Below is the structured data dictionary covering all entities:

Vehicles Table ;
vehicle_id — NUMBER — PK — Unique vehicle identifier
plate_number — VARCHAR2(20) — UNIQUE — Official license plate
owner_name — VARCHAR2(100) — NOT NULL — Registered owner
vehicle_type_id — NUMBER — FK → Vehicle_Type.vehicle_type_id
registration_date — DATE — Vehicle registration date

 Toll_Gates;
gate_id — NUMBER — PK
location — NUMBER
road_name — VARCHAR2(100)
lane_count — NUMBER

 Toll_Logs;
log_id — NUMBER — PK
vehicle_id — NUMBER — FK → Vehicles.vehicle_id
gate_id — NUMBER — FK → Toll_Gates.gate_id
entry_time — TIMESTAMP
exit_time — TIMESTAMP
payment_status — VARCHAR2(20)

 Vehicle_Fines;
fine_id — NUMBER — PK
vehicle_id — NUMBER — FK → Vehicles.vehicle_id
violation_type_id — NUMBER — FK → Violation_Type.violation_type_id
fine_amount — NUMBER
violation_date — DATE
fine_status — VARCHAR2(20)

Payments;
payment_id — NUMBER — PK
vehicle_id — NUMBER — FK → Vehicles.vehicle_id
log_id — NUMBER — FK → Toll_Logs.log_id
payment_method_id — NUMBER — FK → Payment_Method.payment_method_id
amount — NUMBER
payment_date — DATE
reference_no — VARCHAR2(50) UNIQUE

BI Considerations
To support the analytical requirements of the Smart Toll & Traffic Monitoring System specifically peak-hour analysis, revenue reporting, and enforcement tracking the database utilizes a Dimensional Model (Star Schema). This structure optimizes query performance for reporting rather than transaction processing.

Fact Tables (Metrics)

1.FACT_TOLL_PASSAGE: The primary transactional fact table recording every vehicle passage.Records  one row per vehicle passage event.
Metrics: Toll_Amount, Passage_Duration_Seconds, Vehicle_Count.
Foreign Keys: Links to DIM_DATE, DIM_TIME, DIM_GATE, DIM_VEHICLE.


2.FACT_VIOLATION_INCIDENT: A secondary fact table dedicated to enforcement analysis.Records one row per issued fine.
Metrics: Fine_Amount, Violation_Count.

Dimension Tables (Context)

1.DIM_VEHICLE: Stores descriptive attributes such as License Plate, Vehicle Class  and Owner Type.
2.DIM_TOLL_GATE: Describes gate infrastructure, including Location Name, Region, and Number of Lanes.
3.DIM_PAYMENT_METHOD: Categorizes transactions by type .
4.DIM_VIOLATION_TYPE: Standardizes enforcement codes .
5.DIM_DATE & DIM_TIME : Derived temporal dimensions that enable granular analysis. DIM_TIME includes specific flags such as Is_Peak_Hour to support traffic congestion reporting.

 Strategy for Slowly Changing Dimensions (SCD)
To maintain accurate historical reporting, the system implements Slowly Changing Dimensions  for critical entities where attributes change over time.
Scenario: If a Toll Gate updates its tariff or a vehicle changes ownership, historical reports must still reflect the original price or owner at the time of the transaction.

- The DIM_TOLL_GATE and DIM_VEHICLE tables include three audit columns:


Valid_From_Date: The start date of the attribute's validity.
Valid_To_Date: The end date (NULL for current records).
Is_Current_Flag: A boolean indicator (1 for active, 0 for history).


 This ensures that revenue reports from previous years remain accurate even if pricing structures change today.

 Aggregation Levels & Performance

To ensure dashboard responsiveness for high-volume data, the BI layer utilizes pre-aggregated summary tables at two distinct stages:

- Hourly Gate Performance: Aggregated by Date, Hour, and Gate ID.
This Supports the Peak-hour traffic analysis dashboard, allowing managers to visualize congestion trends without querying millions of raw passage logs.
-Monthly Revenue Summary: Aggregated by Month and Payment Method.
 Supports Revenue & Violation Reports for executive decision-making, providing instant access to financial totals.

Audit Trails 
To ensure accountability and trace the origin of every record, a strict auditing policy is applied to the data warehousing process.

ETL Audit Columns: Every table in the BI layer includes standard lineage columns:
Source_System_ID: Identifies the origin.
Load_Timestamp: The exact time the record was committed to the warehouse.
ETL_Batch_ID: Links the record to a specific data load execution log.

Control Table (ETL_JOB_LOG): A centralized table tracks the success or failure of data load jobs, ensuring that any "Read failures" or system errors are flagged for IT review before impacting reports.


Assumptions

• Each vehicle can pass multiple gates per day.
• A toll log may exist before a payment is completed.
• A payment always corresponds to one toll log.
• Gate locations follow a hierarchical geographic structure.
• Fine types are predefined and controlled by authorities.

