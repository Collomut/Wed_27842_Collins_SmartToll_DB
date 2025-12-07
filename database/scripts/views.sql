## VIEWS

##1. Daily Traffic Summary

CREATE OR REPLACE VIEW vw_daily_traffic_summary AS
SELECT 
    TRUNC(entry_time) AS traffic_date,
    COUNT(*) AS total_entries
FROM toll_logs
GROUP BY TRUNC(entry_time);

##2. Full Vehicle Profile

CREATE OR REPLACE VIEW vw_vehicle_profile AS
SELECT 
    v.vehicle_id,
    v.plate_number,
    v.owner_name,
    v.vehicle_type,
    v.registration_date,
    (SELECT NVL(SUM(fine_amount),0)
     FROM vehicle_fine f
     WHERE f.vehicle_id = v.vehicle_id AND f.fine_status = 'UNPAID') AS unpaid_fines,
    (SELECT NVL(SUM(amount),0)
     FROM payments p
     WHERE p.vehicle_id = v.vehicle_id AND p.payment_type = 'TOLL') AS total_toll_paid
FROM vehicles v;

##3.Toll Logs with gate and vehicle Info

CREATE OR REPLACE VIEW vw_toll_activity AS
SELECT 
    tl.log_id,
    v.plate_number,
    g.location AS gate_location,
    g.road_name,
    tl.entry_time,
    tl.exit_time,
    tl.payment_status
FROM toll_logs tl
JOIN vehicles v ON tl.vehicle_id = v.vehicle_id
JOIN toll_gates g ON tl.gate_id = g.gate_id;

##4. Violations Summary

CREATE OR REPLACE VIEW vw_violation_summary AS
SELECT 
    v.vehicle_id,
    v.plate_number,
    COUNT(f.fine_id) AS total_violations,
    NVL(SUM(f.fine_amount),0) AS total_fine_amount
FROM vehicles v
LEFT JOIN vehicle_fine f ON v.vehicle_id = f.vehicle_id
GROUP BY v.vehicle_id, v.plate_number;

##5. Payments Summary

CREATE OR REPLACE VIEW vw_payments_summary AS
SELECT 
    vehicle_id,
    SUM(CASE WHEN payment_type = 'TOLL' THEN amount END) AS toll_revenue,
    SUM(CASE WHEN payment_type = 'FINE' THEN amount END) AS fine_revenue,
    SUM(amount) AS total_revenue
FROM payments
GROUP BY vehicle_id;

##6. Most used Tolls

CREATE OR REPLACE VIEW vw_gate_usage AS
SELECT 
    g.gate_id,
    g.location,
    COUNT(tl.log_id) AS total_passages
FROM toll_logs tl
JOIN toll_gates g ON tl.gate_id = g.gate_id
GROUP BY g.gate_id, g.location
ORDER BY total_passages DESC;

##7.Unpaid Fines 

CREATE OR REPLACE VIEW vw_unpaid_fines AS
SELECT 
    v.plate_number,
    f.fine_amount,
    f.violation_type,
    f.violation_date
FROM vehicle_fine f
JOIN vehicles v ON f.vehicle_id = v.vehicle_id
WHERE f.fine_status = 'UNPAID';

##8.Full Revenue View

CREATE OR REPLACE VIEW vw_revenue_full AS
SELECT
    p.payment_id,
    v.plate_number,
    p.amount,
    p.payment_type,
    p.payment_date,
    p.reference_no
FROM payments p
JOIN vehicles v ON p.vehicle_id = v.vehicle_id;




