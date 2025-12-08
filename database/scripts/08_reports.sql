##Reports

##1. Daily Traffic Report

SELECT * FROM vw_daily_traffic_summary ORDER BY traffic_date DESC;

##2.Top  most used tolls

SELECT * FROM vw_gate_usage FETCH FIRST 10 ROWS ONLY;

##3. Vehicles with Highest fines

SELECT * FROM vw_violation_summary ORDER BY total_fine_amount DESC;

##4.Total Revenue Collected

SELECT SUM(amount) AS total_revenue FROM payments;

##5.All unpaid Fines

SELECT * FROM vw_unpaid_fines ORDER BY fine_amount DESC;

##6.Full vehicle History

SELECT * FROM vw_toll_activity ORDER BY entry_time DESC;
