##Functions

##1. Get number of violations

create or replace FUNCTION get_violation_count(p_vehicle_id NUMBER)
RETURN NUMBER
IS
    v_total NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_total
    FROM vehicle_fine
    WHERE vehicle_id = p_vehicle_id;

    RETURN v_total;
END;

##2. Holiday Operations restrictions

CREATE OR REPLACE FUNCTION is_operation_allowed
RETURN BOOLEAN
IS
    v_today DATE := TRUNC(SYSDATE);
    v_day   VARCHAR2(20);
    v_count NUMBER;
BEGIN
    v_day := TO_CHAR(v_today, 'DY', 'NLS_DATE_LANGUAGE=ENGLISH');


    IF v_day IN ('MON', 'TUE', 'WED', 'THU', 'FRI') THEN
        RETURN FALSE; 
    END IF;

    
    SELECT COUNT(*) INTO v_count
    FROM holidays
    WHERE holiday_date = v_today;

    IF v_count > 0 THEN
        RETURN FALSE;
    END IF;

    RETURN TRUE; 
END;
/

##4.Last gate Used by a vehicle 

create or replace FUNCTION last_gate_visited(p_vehicle_id NUMBER)
RETURN VARCHAR2
IS
    v_gate VARCHAR2(100);
BEGIN
    SELECT tg.location
    INTO v_gate
    FROM toll_logs tl
    JOIN toll_gates tg ON tl.gate_id = tg.gate_id
    WHERE tl.vehicle_id = p_vehicle_id
    ORDER BY entry_time DESC
    FETCH FIRST 1 ROW ONLY;

    RETURN v_gate;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 'No record';
END;

##5.Monthly Fine Collection

create or replace FUNCTION monthly_fine_total(p_year NUMBER, p_month NUMBER)
RETURN NUMBER
IS
    v_total NUMBER;
BEGIN
    SELECT NVL(SUM(fine_amount),0)
    INTO v_total
    FROM vehicle_fine
    WHERE EXTRACT(YEAR FROM violation_date) = p_year
      AND EXTRACT(MONTH FROM violation_date) = p_month;

    RETURN v_total;
END;

##6.Total revenue colleted

create or replace FUNCTION total_revenue
RETURN NUMBER
IS
    v_total NUMBER;
BEGIN
    SELECT NVL(SUM(amount),0)
    INTO v_total
    FROM payments;

    RETURN v_total;
END;

##7.validating vehicle details

create or replace FUNCTION vehicle_exists(p_plate VARCHAR2)
RETURN BOOLEAN
IS
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count
    FROM vehicles
    WHERE UPPER(plate_number) = UPPER(p_plate);

    RETURN v_count > 0;
END;

##8.Summary of Vehicle 

create or replace FUNCTION vehicle_summary(p_vehicle_id NUMBER)
RETURN VARCHAR2
IS
    v_plate VARCHAR2(20);
    v_owner VARCHAR2(100);
    v_type VARCHAR2(50);
BEGIN
    SELECT plate_number, owner_name, vehicle_type
    INTO v_plate, v_owner, v_type
    FROM vehicles
    WHERE vehicle_id = p_vehicle_id;

    RETURN 'Plate: '||v_plate||
           ' | Owner: '||v_owner||
           ' | Type: '||v_type;
END;



