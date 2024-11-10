--a
CREATE OR REPLACE PROCEDURE new_job(
    p_job_id VARCHAR,
    p_job_title VARCHAR,
    p_min_salary NUMERIC
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_max_salary NUMERIC;
BEGIN
    v_max_salary := p_min_salary * 2;
    INSERT INTO jobs (job_id, job_title, min_salary, max_salary)
    VALUES (p_job_id, p_job_title, p_min_salary, v_max_salary);
END;
$$;

--b
CALL new_job('SY_ANAL', 'System Analyst', 6000);
