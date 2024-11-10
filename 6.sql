--a
CREATE OR REPLACE FUNCTION check_sal_range_fn()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.min_salary > (SELECT salary FROM employees WHERE job_id = NEW.job_id) THEN
        RAISE EXCEPTION 'New minimum salary is too high for employees with this job ID';
    END IF;
	
    IF NEW.max_salary < (SELECT salary FROM employees WHERE job_id = NEW.job_id) THEN
        RAISE EXCEPTION 'New maximum salary is too low for employees with this job ID';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_sal_range
BEFORE UPDATE OF min_salary, max_salary
ON jobs
FOR EACH ROW
EXECUTE FUNCTION check_sal_range_fn();

--b
SELECT job_id, min_salary, max_salary
FROM jobs
WHERE job_id = 'SY_ANAL';

SELECT employee_id, last_name, salary
FROM employees
WHERE job_id = 'SY_ANAL';

UPDATE jobs
SET min_salary = 5000, max_salary = 7000
WHERE job_id = 'SY_ANAL';

SELECT job_id, min_salary, max_salary
FROM jobs
WHERE job_id = 'SY_ANAL';

--c
UPDATE jobs
SET min_salary = 7000, max_salary = 18000
WHERE job_id = 'SY_ANAL';

-- Сообщение об ошибке указывает на то, что триггер 
-- блокирует обновление, поскольку обнаружил, 
-- что новая минимальная зарплата (7000) выше 
-- зарплаты по крайней мере одного сотрудника 
-- с должностью SY_ANAL.