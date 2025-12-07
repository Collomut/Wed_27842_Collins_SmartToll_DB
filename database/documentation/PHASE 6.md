Phase 6 – PL/SQL Development Documentation
Student: Mutinda Collins Mumo
ID: 27842
Project: Smart Toll & Traffic Monitoring System
PDB: WED_27842_Collins_smarttoll_db
Schema: TOLL_OWNER


This included:

A full PL/SQL Package (Specification + Body)
Procedures for inserting, updating, and processing toll & fine data
Functions for calculations, validation, and reporting
Cursors for iterative reports
Window functions for advanced analytics.
Testing scripts using DBMS_OUTPUT

All code was implemented inside the TOLL_PKG package.

2. Completed Deliverables

 Package Specification
File: 06_toll_pkg_spec.sql

Contains declarations for:
1.10+ business logic functions
2.10+ supporting procedures
3.Custom application exceptions
4.Daily revenue reporting procedure


 Package Body
File: 07_toll_pkg_body.sql

Implements:
1.Fine management (add, pay, settle)
2.Toll entry/exit processing
3.Dynamic toll fee calculation
4.Vehicle validation (plate rules)
5.Revenue reporting
6.Error handling with RAISE_APPLICATION_ERROR
7.Utility computations (balances, last visit date)

Package body compiled successfully and is VALID inside the PDB.

3. Cursor-Based Reporting
File: 08_cursors.sql

Two main cursors were created:

1.Top unpaid vehicles
Aggregates total unpaid fines
Displays ranking in DBMS_OUTPUT
2.Last 24-hour traffic
Shows recent toll usage by vehicles
Uses joins with toll_gates and vehicles

These demonstrate use of explicit and implicit cursor loops.

 4. Window Functions
File: 09_window_functions.sql

Includes:
RANK() → Rank vehicles by total fines
LAG() → Detect repeated violations
OVER(PARTITION BY...) → Partition by vehicle

 5. Testing Scripts
File: 10_test_plsql.sql

Includes:
Function testing (get_vehicle_profile, get_total_unpaid_fines,)
Adding and paying fines
Recording toll entries & exits
Verifying payments created automatically
DBMS_OUTPUT screenshots required for verification



