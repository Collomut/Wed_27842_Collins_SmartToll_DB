##Triggers

##1. No deleting on weekends

create or replace TRIGGER trg_payments_delete_control
BEFORE DELETE ON payments
FOR EACH ROW
BEGIN
    IF is_operation_allowed = FALSE THEN
        RAISE_APPLICATION_ERROR(-20052, 'DELETE blocked: Weekend/Holiday operations not allowed.');
    END IF;
END;

##2. Recording operations (Compound Trigger)

create or replace TRIGGER trg_toll_logs_compound
FOR INSERT OR UPDATE OR DELETE ON toll_logs
COMPOUND TRIGGER

    v_count_insert NUMBER := 0;
    v_count_update NUMBER := 0;
    v_count_delete NUMBER := 0;
BEFORE STATEMENT IS
BEGIN
    DBMS_OUTPUT.PUT_LINE('Starting compound trigger on TOLL_LOGS');
END BEFORE STATEMENT;
BEFORE EACH ROW IS
BEGIN
    IF INSERTING THEN
        v_count_insert := v_count_insert + 1;
    ELSIF UPDATING THEN
        v_count_update := v_count_update + 1;
    ELSIF DELETING THEN
        v_count_delete := v_count_delete + 1;
    END IF;
END BEFORE EACH ROW;
AFTER STATEMENT IS
BEGIN
    DBMS_OUTPUT.PUT_LINE('Inserted: ' || v_count_insert);
    DBMS_OUTPUT.PUT_LINE('Updated : ' || v_count_update);
    DBMS_OUTPUT.PUT_LINE('Deleted : ' || v_count_delete);
END AFTER STATEMENT;
END trg_toll_logs_compound;

##3.Audit vehicle details

create or replace TRIGGER trg_vehicle_audit
AFTER INSERT OR UPDATE OR DELETE ON vehicles
FOR EACH ROW
BEGIN
    IF INSERTING THEN
        INSERT INTO audit_log(table_name, operation, changed_by, new_data)
        VALUES('VEHICLES', 'INSERT', USER, 'Plate='||:NEW.plate_number||', Owner='||:NEW.owner_name);

    ELSIF UPDATING THEN
        INSERT INTO audit_log(table_name, operation, changed_by, old_data, new_data)
        VALUES('VEHICLES', 'UPDATE', USER,
               'Old Owner='||:OLD.owner_name,
               'New Owner='||:NEW.owner_name);

    ELSIF DELETING THEN
        INSERT INTO audit_log(table_name, operation, changed_by, old_data)
        VALUES('VEHICLES', 'DELETE', USER,
               'Plate='||:OLD.plate_number||', Owner='||:OLD.owner_name);
    END IF;
END;

##4.Insertion control on weekends

create or replace TRIGGER trg_vehicle_insert_control
BEFORE INSERT ON vehicles
FOR EACH ROW
BEGIN
    IF is_operation_allowed = FALSE THEN
        RAISE_APPLICATION_ERROR(-20050, 'INSERT blocked: Weekend/Holiday operations are not allowed.');
    END IF;
END;

##5.Vehicle updation on weekends 

create or replace TRIGGER trg_vehiclefine_update_control
BEFORE UPDATE ON vehicle_fine
FOR EACH ROW
BEGIN
    IF is_operation_allowed = FALSE THEN
        RAISE_APPLICATION_ERROR(-20051, 'UPDATE blocked: Weekend/Holiday operations not allowed.');
    END IF;
END;


