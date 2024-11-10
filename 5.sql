--a
CREATE OR REPLACE FUNCTION get_job_count(
    p_employee_id INT
)
RETURNS INT AS $$
DECLARE
    v_job_count INT;
    v_current_job_id VARCHAR;
BEGIN
    SELECT job_id
    INTO v_current_job_id
    FROM employees
    WHERE employee_id = p_employee_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Employee with ID % does not exist', p_employee_id;
    END IF;

    CREATE TEMP TABLE temp_jobs AS
    SELECT DISTINCT job_id
    FROM job_history
    WHERE employee_id = p_employee_id
    UNION
    SELECT DISTINCT job_id
    FROM employees
    WHERE employee_id = p_employee_id AND job_id != v_current_job_id;

    SELECT COUNT(*)
    INTO v_job_count
    FROM temp_jobs;

    DROP TABLE temp_jobs;

    RETURN v_job_count;
END;
$$ LANGUAGE plpgsql;

--b
SELECT get_job_count(176);
