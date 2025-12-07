##TOLL PACKAGE 

create or replace PACKAGE toll_pkg AS

  fine_not_found EXCEPTION;
  invalid_plate EXCEPTION;

  FUNCTION get_total_unpaid_fines(p_vehicle_id NUMBER) RETURN NUMBER;
  FUNCTION get_total_paid_fines(p_vehicle_id NUMBER) RETURN NUMBER;
  FUNCTION get_total_toll_payments(p_vehicle_id NUMBER) RETURN NUMBER;
  FUNCTION get_vehicle_balance(p_vehicle_id NUMBER) RETURN NUMBER;
  FUNCTION calculate_toll_fee(p_vehicle_id NUMBER, p_gate_id NUMBER) RETURN NUMBER;
  FUNCTION get_vehicle_profile(p_vehicle_id NUMBER) RETURN VARCHAR2;
  FUNCTION validate_plate(p_plate VARCHAR2) RETURN BOOLEAN;
  FUNCTION get_last_visit_date(p_vehicle_id NUMBER) RETURN DATE;


  PROCEDURE add_vehicle(p_plate VARCHAR2, p_owner VARCHAR2, p_type VARCHAR2);
  PROCEDURE update_vehicle_owner(p_vehicle_id NUMBER, p_new_owner VARCHAR2);
  PROCEDURE record_toll_entry(p_vehicle_id NUMBER, p_gate_id NUMBER);
  PROCEDURE record_toll_exit(p_log_id NUMBER);
  PROCEDURE add_fine(p_vehicle_id NUMBER, p_amount NUMBER, p_violation VARCHAR2);
  PROCEDURE pay_fine(p_fine_id NUMBER, p_reference VARCHAR2);
  PROCEDURE record_payment(p_vehicle_id NUMBER, p_amount NUMBER, p_type VARCHAR2, p_reference VARCHAR2);
  PROCEDURE settle_all_fines(p_vehicle_id NUMBER);


  PROCEDURE generate_daily_revenue_report(p_date DATE);

END toll_pkg;

##TOLL PACKAGE BODY

create or replace PACKAGE BODY toll_pkg AS
  
  PROCEDURE raise_err(p_code NUMBER, p_msg VARCHAR2) IS
  BEGIN
    RAISE_APPLICATION_ERROR(p_code, p_msg);
  END raise_err;

  FUNCTION validate_plate(p_plate VARCHAR2) RETURN BOOLEAN IS
  BEGIN
    RETURN REGEXP_LIKE(UPPER(TRIM(p_plate)), '^[A-Z0-9-]+$');
  END validate_plate;

  FUNCTION get_total_unpaid_fines(p_vehicle_id NUMBER) RETURN NUMBER IS
    v_total NUMBER;
  BEGIN
    SELECT NVL(SUM(fine_amount),0) INTO v_total
    FROM vehicle_fine
    WHERE vehicle_id = p_vehicle_id AND fine_status = 'UNPAID';
    RETURN v_total;
  EXCEPTION WHEN NO_DATA_FOUND THEN RETURN 0;
  END;

  FUNCTION get_total_paid_fines(p_vehicle_id NUMBER) RETURN NUMBER IS
    v_total NUMBER;
  BEGIN
    SELECT NVL(SUM(fine_amount),0) INTO v_total
    FROM vehicle_fine
    WHERE vehicle_id = p_vehicle_id AND fine_status = 'PAID';
    RETURN v_total;
  EXCEPTION WHEN NO_DATA_FOUND THEN RETURN 0; END;

  FUNCTION get_total_toll_payments(p_vehicle_id NUMBER) RETURN NUMBER IS
    v_total NUMBER;
  BEGIN
    SELECT NVL(SUM(amount),0) INTO v_total
    FROM payments
    WHERE vehicle_id = p_vehicle_id AND payment_type = 'TOLL';
    RETURN v_total;
  EXCEPTION WHEN NO_DATA_FOUND THEN RETURN 0; END;

  FUNCTION get_vehicle_balance(p_vehicle_id NUMBER) RETURN NUMBER IS
    v_unpaid NUMBER := 0;
    v_paid_payments NUMBER := 0;
  BEGIN
    v_unpaid := get_total_unpaid_fines(p_vehicle_id);
    v_paid_payments := get_total_toll_payments(p_vehicle_id) + get_total_paid_fines(p_vehicle_id); -- payments may include fine payments too
    RETURN v_unpaid - v_paid_payments;
  END get_vehicle_balance;

  FUNCTION calculate_toll_fee(p_vehicle_id NUMBER, p_gate_id NUMBER) RETURN NUMBER IS
    v_type VARCHAR2(30);
    v_fee NUMBER;
  BEGIN
    SELECT vehicle_type INTO v_type FROM vehicles WHERE vehicle_id = p_vehicle_id;

    CASE v_type
      WHEN 'Motorcycle' THEN v_fee := 50;
      WHEN 'Sedan' THEN v_fee := 150;
      WHEN 'SUV' THEN v_fee := 200;
      WHEN 'Van' THEN v_fee := 220;
      WHEN 'Truck' THEN v_fee := 400;
      WHEN 'Bus' THEN v_fee := 350;
      ELSE v_fee := 150;
    END CASE;

    RETURN v_fee;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      raise_err(-20020, 'Vehicle not found in calculate_toll_fee');
      RETURN NULL;
  END calculate_toll_fee;

  FUNCTION get_vehicle_profile(p_vehicle_id NUMBER) RETURN VARCHAR2 IS
    v_plate VARCHAR2(50);
    v_owner VARCHAR2(200);
    v_type VARCHAR2(30);
  BEGIN
    SELECT plate_number, owner_name, vehicle_type
    INTO v_plate, v_owner, v_type
    FROM vehicles
    WHERE vehicle_id = p_vehicle_id;
    RETURN 'Plate: '||v_plate||' | Owner: '||v_owner||' | Type: '||v_type;
  EXCEPTION WHEN NO_DATA_FOUND THEN
    RETURN 'Vehicle not found';
  END get_vehicle_profile;

  FUNCTION get_last_visit_date(p_vehicle_id NUMBER) RETURN DATE IS
    v_date DATE;
  BEGIN
    SELECT MAX(entry_time) INTO v_date FROM toll_logs WHERE vehicle_id = p_vehicle_id;
    RETURN v_date;
  EXCEPTION WHEN NO_DATA_FOUND THEN RETURN NULL; END;

  PROCEDURE add_vehicle(p_plate VARCHAR2, p_owner VARCHAR2, p_type VARCHAR2) IS
  BEGIN
    IF NOT validate_plate(p_plate) THEN
      RAISE invalid_plate;
    END IF;

    INSERT INTO vehicles(plate_number, owner_name, vehicle_type, registration_date)
    VALUES (UPPER(TRIM(p_plate)), p_owner, p_type, SYSDATE);
  EXCEPTION
    WHEN invalid_plate THEN
      raise_err(-20001, 'Invalid plate number format.');
    WHEN DUP_VAL_ON_INDEX THEN
      raise_err(-20002, 'Plate number already exists.');
    WHEN OTHERS THEN
      raise_err(-20003, 'Error adding vehicle: '||SQLERRM);
  END add_vehicle;

  PROCEDURE update_vehicle_owner(p_vehicle_id NUMBER, p_new_owner VARCHAR2) IS
  BEGIN
    UPDATE vehicles SET owner_name = p_new_owner WHERE vehicle_id = p_vehicle_id;
    IF SQL%ROWCOUNT = 0 THEN
      raise_err(-20004, 'Vehicle ID not found for update.');
    END IF;
  EXCEPTION WHEN OTHERS THEN
    raise_err(-20005, 'Error updating owner: '||SQLERRM);
  END update_vehicle_owner;

  PROCEDURE record_toll_entry(p_vehicle_id NUMBER, p_gate_id NUMBER) IS
  BEGIN
    INSERT INTO toll_logs(vehicle_id, gate_id, entry_time, payment_status)
    VALUES(p_vehicle_id, p_gate_id, SYSTIMESTAMP, 'PENDING');
  EXCEPTION WHEN OTHERS THEN
    raise_err(-20006, 'Error recording toll entry: '||SQLERRM);
  END record_toll_entry;

  PROCEDURE record_toll_exit(p_log_id NUMBER) IS
    v_vehicle_id NUMBER;
    v_fee NUMBER;
    v_ref VARCHAR2(50);
  BEGIN
    SELECT vehicle_id INTO v_vehicle_id FROM toll_logs WHERE log_id = p_log_id;

    v_fee := calculate_toll_fee(v_vehicle_id, NULL);

    UPDATE toll_logs SET exit_time = SYSTIMESTAMP, payment_status = 'PAID'
    WHERE log_id = p_log_id;

    v_ref := 'TOLL-'||TO_CHAR(SYSTIMESTAMP,'YYYYMMDDHH24MISS')||'-'||p_log_id;
    INSERT INTO payments(vehicle_id, amount, payment_type, payment_date, reference_no)
    VALUES(v_vehicle_id, v_fee, 'TOLL', SYSTIMESTAMP, v_ref);
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      raise_err(-20007, 'Toll log not found for record_toll_exit');
    WHEN OTHERS THEN
      raise_err(-20008, 'Error recording toll exit/payment: '||SQLERRM);
  END record_toll_exit;

  PROCEDURE add_fine(p_vehicle_id NUMBER, p_amount NUMBER, p_violation VARCHAR2) IS
    v_new_id NUMBER;
  BEGIN
    INSERT INTO vehicle_fine(vehicle_id, fine_amount, violation_type, violation_date, fine_status)
    VALUES(p_vehicle_id, p_amount, p_violation, SYSTIMESTAMP, 'UNPAID')
    RETURNING fine_id INTO v_new_id;

  EXCEPTION WHEN OTHERS THEN
    raise_err(-20009, 'Error adding fine: '||SQLERRM);
  END add_fine;

  PROCEDURE pay_fine(p_fine_id NUMBER, p_reference VARCHAR2) IS
    v_vehicle_id NUMBER;
  BEGIN
    SELECT vehicle_id INTO v_vehicle_id FROM vehicle_fine WHERE fine_id = p_fine_id;

    UPDATE vehicle_fine SET fine_status = 'PAID' WHERE fine_id = p_fine_id;

    INSERT INTO payments(vehicle_id, amount, payment_type, payment_date, reference_no)
    VALUES(v_vehicle_id,
           (SELECT fine_amount FROM vehicle_fine WHERE fine_id = p_fine_id),
           'FINE',
           SYSTIMESTAMP,
           p_reference);

  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RAISE fine_not_found;
    WHEN OTHERS THEN
      raise_err(-20010, 'Error processing fine payment: '||SQLERRM);
  END pay_fine;

  PROCEDURE record_payment(p_vehicle_id NUMBER, p_amount NUMBER, p_type VARCHAR2, p_reference VARCHAR2) IS
  BEGIN
    IF p_amount < 0 THEN
      raise_err(-20011, 'Payment amount cannot be negative.');
    END IF;
    INSERT INTO payments(vehicle_id, amount, payment_type, payment_date, reference_no)
    VALUES(p_vehicle_id, p_amount, p_type, SYSTIMESTAMP, p_reference);
  EXCEPTION WHEN OTHERS THEN
    raise_err(-20012, 'Error recording payment: '||SQLERRM);
  END record_payment;

  PROCEDURE settle_all_fines(p_vehicle_id NUMBER) IS
    CURSOR c_unpaid IS
      SELECT fine_id, fine_amount FROM vehicle_fine
      WHERE vehicle_id = p_vehicle_id AND fine_status = 'UNPAID';
    v_ref VARCHAR2(50);
  BEGIN
    FOR r IN c_unpaid LOOP
      v_ref := 'FINESETTLE-'||TO_CHAR(SYSTIMESTAMP,'YYYYMMDDHH24MISS')||'-'||r.fine_id;
      UPDATE vehicle_fine SET fine_status = 'PAID' WHERE fine_id = r.fine_id;
      INSERT INTO payments(vehicle_id, amount, payment_type, payment_date, reference_no)
      VALUES(p_vehicle_id, r.fine_amount, 'FINE', SYSTIMESTAMP, v_ref);
    END LOOP;
  EXCEPTION WHEN OTHERS THEN
    raise_err(-20013, 'Error settling fines: '||SQLERRM);
  END settle_all_fines;

  PROCEDURE generate_daily_revenue_report(p_date DATE) IS
    v_start DATE := TRUNC(p_date);
    v_end   DATE := v_start + 1;
    v_total NUMBER;
  BEGIN
    SELECT NVL(SUM(amount),0) INTO v_total
    FROM payments
    WHERE payment_date >= v_start AND payment_date < v_end;
    DBMS_OUTPUT.PUT_LINE('Total revenue for ' || TO_CHAR(v_start,'YYYY-MM-DD') || ': ' || v_total);
  EXCEPTION WHEN OTHERS THEN
    raise_err(-20014, 'Error generating daily report: '||SQLERRM);
  END generate_daily_revenue_report;

END toll_pkg;
