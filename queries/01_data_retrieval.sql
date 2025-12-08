---------------------------------------------------------
-- 01_data_retrieval.sql
-- Basic data fetching queries for Smart Toll System
---------------------------------------------------------

-- 1. List all vehicles
SELECT * FROM vehicles ORDER BY vehicle_id;

-- 2. List all toll gates
SELECT * FROM toll_gates ORDER BY gate_id;

-- 3. Get toll logs (detailed)
SELECT * FROM toll_logs ORDER BY entry_time DESC;

-- 4. Get all fines
SELECT * FROM vehicle_fine ORDER BY violation_date DESC;

-- 5. Retrieve all payments
SELECT * FROM payments ORDER BY payment_date DESC;

-- 6. Get vehicle profile by plate number
SELECT * 
FROM vehicles
WHERE plate_number = 'RANDOM_PLATE';

-- 7. Get vehicle full history (basic)
SELECT * 
FROM toll_logs 
WHERE vehicle_id = (SELECT vehicle_id FROM vehicles WHERE plate_number='TST001A');

