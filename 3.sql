--c
ALTER TABLE employees DISABLE TRIGGER ALL;
ALTER TABLE jobs DISABLE TRIGGER ALL;

--a
CREATE OR REPLACE PROCEDURE upd_jobsal(
    p_job_id VARCHAR,
    p_new_min_salary NUMERIC,
    p_new_max_salary NUMERIC
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM jobs WHERE job_id = p_job_id) THEN
        RAISE EXCEPTION 'Job ID % does not exist', p_job_id;
    END IF;

    IF p_new_max_salary < p_new_min_salary THEN
        RAISE EXCEPTION 'Maximum salary cannot be less than minimum salary';
    END IF;

    UPDATE jobs
    SET min_salary = p_new_min_salary,
        max_salary = p_new_max_salary
    WHERE job_id = p_job_id;
EXCEPTION
    WHEN lock_not_available THEN
        RAISE EXCEPTION 'The row in JOBS table is locked. Please try again later';
END;
$$;


--b
CALL upd_jobsal('SY_ANAL', 7000, 140);

--d
CALL upd_jobsal('SY_ANAL', 7000, 14000);

--e
SELECT * FROM jobs WHERE job_id = 'SY_ANAL';

COMMIT;

--f
ALTER TABLE employees ENABLE TRIGGER ALL;
ALTER TABLE jobs ENABLE TRIGGER ALL;
