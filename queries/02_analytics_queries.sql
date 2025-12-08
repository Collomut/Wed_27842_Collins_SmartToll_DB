---------------------------------------------------------
-- 02_analytics_queries.sql
-- Analytical queries for traffic and revenue analysis
---------------------------------------------------------

-- 1. Top most used toll gates
SELECT tg.location, COUNT(*) AS total_passes
FROM toll_logs tl
JOIN toll_gates tg ON tl.gate_id = tg.gate_id
GROUP BY tg.location
ORDER BY total_passes DESC;

-- 2. Daily traffic count
SELECT TRUNC(entry_time) AS day, COUNT(*) AS total_vehicles
FROM toll_logs
GROUP BY TRUNC(entry_time)
ORDER BY day DESC;

-- 3. Revenue collected per day
SELECT TRUNC(payment_date) AS day, SUM(amount) AS revenue
FROM payments
GROUP BY TRUNC(payment_date)
ORDER BY day DESC;

-- 4. Vehicles with highest fines
SELECT v.plate_number, SUM(fine_amount) AS total_fines
FROM vehicle_fine f
JOIN vehicles v ON v.vehicle_id = f.vehicle_id
GROUP BY v.plate_number
ORDER BY total_fines DESC;

-- 5. Peak hours analysis
SELECT TO_CHAR(entry_time, 'HH24') AS hour, COUNT(*) AS traffic_count
FROM toll_logs
GROUP BY TO_CHAR(entry_time, 'HH24')
ORDER BY traffic_count DESC;

-- 6. Monthly fine totals
SELECT EXTRACT(YEAR FROM violation_date) AS year,
       EXTRACT(MONTH FROM violation_date) AS month,
       SUM(fine_amount) AS total_fines
FROM vehicle_fine
GROUP BY EXTRACT(YEAR FROM violation_date), EXTRACT(MONTH FROM violation_date)
ORDER BY year, month;

