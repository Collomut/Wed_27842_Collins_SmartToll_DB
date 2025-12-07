Project Owner : Mutinda Collins Mumo
ID Number : 27842
Smart Toll and Traffic Monitoring System
Project Idea
With growth of the transport sector, there has been an increase in projects to make highways such highways need to be monitored constantly and reports to be generated to the Ministry of transport for planning and maintenance and improvement of Infrastructure. Toll stations are the solutions to these demands.

 The tolls however encounter a lot of problems :-
Time delays by manually entry of vehicle data to the system.
People fail to pay the fines imposed leading to a hold up for the other drivers.
Human error during entering the data.
Lack of proper reporting and analysis of the revenue collected.
Long and Unbearable traffic jam during peak hours.

This project is aimed to solve all these problems and improve user experience by:-
Automating the entering of data to the System.
Creating the total overview of the driver including fines due,incurring toll fees and does not allow the driver to proceed without completion.
Ensuring data collected is correct,accurate and reliable.
Generating full reports at any time of day required that can be used for future analysis.
Logging the times of entry and exit and identifying peak hours and plan for partial closures to reduce traffic 

Database Schema
The Database contains a total of 5 tables for management of the toll stations:-
1.Vehicles- stores information about all the government  registered vehicles.
Fields include :-vehicle_id, plate_number, owner_name, vehicle_type, registration_date)

2.Toll_gates -stores the information of different toll stations in different areas
Fields include:- gate_id, location, road_name, lane_count

3.Toll_logs - It keeps a record on the vehicles that passes through a certain toll.
Fiels include:- log_id, vehicle_id, gate_id, entry_time, exit_time, payment_status.
4.Vehicle_fine-it keeps a record of all the violations done by each and every registered vehicle for reference.
Fields include:-fine_id, vehicle_id, fine_amount, violation_type, violation_date, fine_status.
5.Payments-keeps a record of all paid fines and toll gate payments.
Fields include:-payment_id, vehicle_id, amount, payment_type, payment_date, reference_no.


3.Innovation and Improvement
This project focuses on the use of automation on error prone areas of the transport system,tolls.
Innovations Include:-
Automatic Fine Enforcement -No vehicle can leave without full payment of fines this helps backtrack owned government revenue.
Integrated traffic analysis- Ensures that there is real time traffic monitoring to analyse traffic patterns and aid in congestion management.
Accurate revenue collection- all money collected can be traced back and fines are paid and cases of mismanagement are greatly reduced if not curbed.
The system makes way for integration of IOT like radar cameras  and RFID for enhancements in the future.






