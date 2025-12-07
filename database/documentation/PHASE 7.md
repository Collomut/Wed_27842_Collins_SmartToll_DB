Phase 7 – Triggers, Restriction Function & Auditing
Student: Mutinda Collins Mumo
ID: 27842
Project: Smart Toll & Traffic Monitoring System
PDB: WED_27842_Collins_smarttoll_db
Schema: TOLL_OWNER

The created objects include:
A holiday table
An audit table
A restriction function
BEFORE INSERT / UPDATE / DELETE triggers
A compound trigger
An audit trigger
Testing scripts

These objects ensure the system is secure, controlled, and properly monitored for changes.

1.Holiday Table 
A table holding all national holidays,Used for blocking operations on restricted days.

2.Audit Table 
Captures ALL insert/update/delete operations stores:
Table name
Operation performed
User
Timestamp
Old values
New values

Used for accountability and security checks.

3. Restriction Function (13_restriction_function.sql)
A function that returns:
FALSE on weekends or holidays
TRUE on normal working days

Used inside authorization triggers to prevent unauthorized data modification.
Logic:

Detects Saturday/Sunday using TO_CHAR(SYSDATE, 'DY')
Checks current date against HOLIDAYS table
Prevents INSERT, UPDATE, DELETE when not allowed

This ensures government toll data is only modified on approved days.

 Implemented Triggers

1. BEFORE INSERT Trigger 
trg_vehicle_insert_control
Prevents new vehicle registration during weekends or holidays.
Key Rules:
Uses is_operation_allowed function
Block with RAISE_APPLICATION_ERROR(-20050)

Ensures data entry follows official working days.

2. BEFORE UPDATE Trigger
trg_vehiclefine_update_control
Prevents modifying fine records on restricted days.
Protects financial integrity of government revenue records.

3. BEFORE DELETE Trigger 
trg_payments_delete_control
Prevents deleting financial transactions.
No payment can ever be removed
Deletion attempts raise an error

 COMPOUND Trigger on Toll Logs
trg_toll_logs_compound
This  trigger showcases:
BEFORE STATEMENT actions
BEFORE EACH ROW actions
AFTER STATEMENT action

Purpose:
Counts how many rows were inserted, updated, or deleted
Prints a summary using DBMS_OUTPUT
Helps monitor traffic activity changes

 Audit Trigger 
trg_vehicle_audit
Automatically logs:
INSERT - stores new data
UPDATE -stores old + new values
DELETE - stores deleted values

Records are written to AUDIT_LOG table.
This satisfies the mandatory requirement of tracking activity on a table.

 Testing (16_phase7_test.sql)
Testing included:
Insert Test
Attempts to insert a vehicle and checks if:
Allowed on weekdays
Blocked on weekends/holidays

 Audit Test
Selecting from AUDIT_LOG confirms:
Inserts,Updates,Deletes are captured correctly.

 Compound Trigger Test
Updating toll_logs:
Shows row counts in DBMS_OUTPUT


