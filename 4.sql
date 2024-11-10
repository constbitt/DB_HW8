
--a
CREATE OR REPLACE FUNCTION get_years_service(
    p_employee_id INT
)
RETURNS INT AS $$
DECLARE
    v_hire_date DATE;
    v_years_of_service INT;
BEGIN
    SELECT hire_date
    INTO v_hire_date
    FROM employees
    WHERE employee_id = p_employee_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Employee with ID % does not exist', p_employee_id;
    END IF;

    v_years_of_service := EXTRACT(YEAR FROM AGE(CURRENT_DATE, v_hire_date));

    RETURN v_years_of_service;
END;
$$ LANGUAGE plpgsql;

--b
DO $$ 
BEGIN
    RAISE NOTICE 'Years of Service for Employee 999: %', get_years_service(999);
END $$;

--c
DO $$ 
BEGIN
    RAISE NOTICE 'Years of Service for Employee 106: %', get_years_service(106);
END $$;

--d
SELECT * FROM employees WHERE employee_id = 106;
SELECT * FROM job_history WHERE employee_id = 106;
