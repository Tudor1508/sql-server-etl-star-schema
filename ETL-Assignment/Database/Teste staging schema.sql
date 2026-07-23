USE ETL_Assignment;
GO

SELECT
    'stg.Timesheets' AS table_name,
    COUNT(*) AS row_count
FROM stg.Timesheets

UNION ALL

SELECT
    'stg.Absences',
    COUNT(*)
FROM stg.Absences

UNION ALL

SELECT
    'stg.TrainingAttendance',
    COUNT(*)
FROM stg.TrainingAttendance

UNION ALL

SELECT
    'stg.EmployeeMaster',
    COUNT(*)
FROM stg.EmployeeMaster

UNION ALL

SELECT
    'stg.DUExamSchedule',
    COUNT(*)
FROM stg.DUExamSchedule;
GO

SELECT
    training_id,
    training_name,
    COUNT(*) AS participants,
    MIN(attendance_minutes) AS minimum_minutes,
    MAX(attendance_minutes) AS maximum_minutes,
    AVG(CAST(attendance_minutes AS DECIMAL(10,2)))
        AS average_minutes
FROM stg.TrainingAttendance
GROUP BY
    training_id,
    training_name
ORDER BY training_id;
GO

SELECT
    employee_id,
    full_name,
    grade,
    discipline,
    line_manager,
    delivery_unit,
    valid_from,
    valid_to,
    is_current
FROM stg.EmployeeMaster
ORDER BY
    employee_id,
    valid_from;
GO

SELECT
    employee_id,
    SUM
    (
        CASE
            WHEN is_current = 1 THEN 1
            ELSE 0
        END
    ) AS current_versions
FROM stg.EmployeeMaster
GROUP BY employee_id
HAVING SUM
(
    CASE
        WHEN is_current = 1 THEN 1
        ELSE 0
    END
) <> 1;
GO

SELECT DISTINCT
    training.employee_name
FROM src.TrainingAttendance AS training

LEFT JOIN stg.EmployeeMaster AS employee
    ON UPPER(TRIM(employee.full_name))
     = UPPER(TRIM(training.employee_name))
   AND employee.is_current = 1

WHERE employee.employee_id IS NULL;
GO

SELECT *
FROM stg.Timesheets
ORDER BY employee_id, work_date;

SELECT TOP (20) *
FROM stg.Absences
ORDER BY employee_id, absence_date;