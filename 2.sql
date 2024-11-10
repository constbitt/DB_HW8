--Disable all triggers on the EMPLOYEES, JOBS, and JOB_HISTORY 
ALTER TABLE employees DISABLE TRIGGER ALL;
ALTER TABLE jobs DISABLE TRIGGER ALL;
ALTER TABLE job_history DISABLE TRIGGER ALL;

CREATE OR REPLACE PROCEDURE add_job_hist(
    p_employee_id INT,
    p_new_job_id VARCHAR
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_min_salary NUMERIC;
    v_prev_job_id VARCHAR;
    v_hire_date DATE;
BEGIN
    SELECT job_id, hire_date
    INTO v_prev_job_id, v_hire_date
    FROM employees
    WHERE employee_id = p_employee_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Employee with ID % does not exist', p_employee_id;
    END IF;

    SELECT min_salary INTO v_min_salary
    FROM jobs
    WHERE job_id = p_new_job_id;

    INSERT INTO job_history (employee_id, job_id, start_date, end_date)
    VALUES (p_employee_id, v_prev_job_id, v_hire_date, CURRENT_DATE);

    UPDATE employees
    SET job_id = p_new_job_id,
        hire_date = CURRENT_DATE,
        salary = v_min_salary + 500
    WHERE employee_id = p_employee_id;
END;
$$;

--Execute the procedure with employee ID 106 and job ID 'SY_ANAL' as parameters
CALL add_job_hist(106, 'SY_ANAL');

--Query the JOB_HISTORY and EMPLOYEES tables to view your changes for employee 106, 
--and then commit the changes
SELECT * FROM job_history WHERE employee_id = 106;
SELECT * FROM employees WHERE employee_id = 106;

COMMIT;

--Reenable the triggers on the EMPLOYEES, JOBS, and JOB_HISTORY tables
ALTER TABLE employees ENABLE TRIGGER ALL;
ALTER TABLE jobs ENABLE TRIGGER ALL;
ALTER TABLE job_history ENABLE TRIGGER ALL;
