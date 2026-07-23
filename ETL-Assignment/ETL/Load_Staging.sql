-- =========================================================
-- Load_Staging.sql
-- RESPONSABIL: Membrul 2 - ETL Developer
--
-- SCOP:
-- Incarca datele din src in stg.
-- Aplica:
-- - curatare minima;
-- - standardizare valori;
-- - calcul durata training;
-- - calcul intervale istorice Employee Master;
-- - transformare DU Schedule matrice -> randuri.
--
-- DEPENDENTA:
-- Toate tabelele src trebuie sa fie populate.
-- =========================================================

USE ETL_Assignment;
GO

SET NOCOUNT ON;
SET XACT_ABORT ON;
GO

BEGIN TRY

    BEGIN TRANSACTION;


    /* =====================================================
       FULL RELOAD
       ===================================================== */

    TRUNCATE TABLE stg.Timesheets;
    TRUNCATE TABLE stg.Absences;
    TRUNCATE TABLE stg.TrainingAttendance;
    TRUNCATE TABLE stg.EmployeeMaster;
    TRUNCATE TABLE stg.DUExamSchedule;


    /* =====================================================
       1. TIMESHEETS
       ===================================================== */

    INSERT INTO stg.Timesheets
    (
        employee_id,
        work_date,
        project_name,
        hours_worked,
        dataset_name,
        process_timestamp
    )
    SELECT
        employee_id,
        work_date,
        NULLIF(TRIM(project_name), ''),
        hours_worked,
        'timesheets',
        SYSDATETIME()
    FROM src.Timesheets
    WHERE employee_id IS NOT NULL
      AND work_date IS NOT NULL
      AND hours_worked IS NOT NULL
      AND hours_worked BETWEEN 0 AND 24;


    /* =====================================================
       2. ABSENCES
       ===================================================== */

    INSERT INTO stg.Absences
    (
        employee_id,
        absence_date,
        absence_type,
        dataset_name,
        process_timestamp
    )
    SELECT
        employee_id,
        absence_date,

        CASE UPPER(TRIM(absence_type))
            WHEN 'ANNUAL LEAVE'
                THEN 'Annual Leave'

            WHEN 'SICK LEAVE'
                THEN 'Sick Leave'

            WHEN 'PUBLIC HOLIDAY'
                THEN 'Public Holiday'

            WHEN 'UNPAID LEAVE'
                THEN 'Unpaid Leave'

            ELSE NULLIF(TRIM(absence_type), '')
        END,

        'absences',
        SYSDATETIME()
    FROM src.Absences
    WHERE employee_id IS NOT NULL
      AND absence_date IS NOT NULL;


    /* =====================================================
       3. EMPLOYEE MASTER HISTORY

       valid_to este ziua anterioara urmatoarei versiuni.
       Ultima versiune devine is_current = 1.
       ===================================================== */

    ;WITH CleanEmployeeMaster AS
    (
        SELECT DISTINCT
            employee_id,
            NULLIF(TRIM(full_name), '') AS full_name,
            NULLIF(TRIM(grade), '') AS grade,
            NULLIF(TRIM(discipline), '') AS discipline,
            NULLIF(TRIM(line_manager), '') AS line_manager,
            NULLIF(TRIM(delivery_unit), '') AS delivery_unit,
            role_start_date
        FROM src.EmployeeMaster
        WHERE employee_id IS NOT NULL
          AND role_start_date IS NOT NULL
    ),
    EmployeeHistory AS
    (
        SELECT
            employee_id,
            full_name,
            grade,
            discipline,
            line_manager,
            delivery_unit,
            role_start_date,

            LEAD(role_start_date) OVER
            (
                PARTITION BY employee_id
                ORDER BY role_start_date
            ) AS next_role_start_date
        FROM CleanEmployeeMaster
    )
    INSERT INTO stg.EmployeeMaster
    (
        employee_id,
        full_name,
        grade,
        discipline,
        line_manager,
        delivery_unit,
        valid_from,
        valid_to,
        is_current,
        dataset_name,
        process_timestamp
    )
    SELECT
        employee_id,
        full_name,
        grade,
        discipline,
        line_manager,
        delivery_unit,

        role_start_date AS valid_from,

        CASE
            WHEN next_role_start_date IS NULL
                THEN NULL
            ELSE DATEADD
            (
                DAY,
                -1,
                next_role_start_date
            )
        END AS valid_to,

        CASE
            WHEN next_role_start_date IS NULL
                THEN CAST(1 AS BIT)
            ELSE CAST(0 AS BIT)
        END AS is_current,

        'employee_master',
        SYSDATETIME()
    FROM EmployeeHistory;


    /* =====================================================
       4. TRAINING ATTENDANCE

       Legatura cu angajatul se face dupa nume.
       Se foloseste versiunea curenta din Employee Master.
       ===================================================== */

    ;WITH CurrentEmployees AS
    (
        SELECT
            employee_id,
            full_name
        FROM stg.EmployeeMaster
        WHERE is_current = 1
    )
    INSERT INTO stg.TrainingAttendance
    (
        employee_id,
        training_id,
        training_name,
        training_date,
        join_datetime,
        leave_datetime,
        attendance_minutes,
        attendance_hours,
        dataset_name,
        process_timestamp
    )
    SELECT
        employee.employee_id,

        TRIM(training.training_id),

        CASE UPPER(TRIM(training.training_id))
            WHEN 'TRN001'
                THEN 'SQL Fundamentals'

            WHEN 'TRN002'
                THEN 'Azure Data Factory Fundamentals'

            ELSE TRIM(training.training_id)
        END AS training_name,

        CAST(training.join_datetime AS DATE)
            AS training_date,

        training.join_datetime,
        training.leave_datetime,

        DATEDIFF
        (
            MINUTE,
            training.join_datetime,
            training.leave_datetime
        ) AS attendance_minutes,

        CAST
        (
            DATEDIFF
            (
                MINUTE,
                training.join_datetime,
                training.leave_datetime
            ) / 60.0
            AS DECIMAL(6,2)
        ) AS attendance_hours,

        'training_attendance',
        SYSDATETIME()

    FROM src.TrainingAttendance AS training

    INNER JOIN CurrentEmployees AS employee
        ON UPPER(TRIM(employee.full_name))
         = UPPER(TRIM(training.employee_name))

    WHERE training.training_id IS NOT NULL
      AND training.join_datetime IS NOT NULL
      AND training.leave_datetime IS NOT NULL
      AND training.leave_datetime >= training.join_datetime;


    /* =====================================================
       5. DU EXAM SCHEDULE

       Coloanele cu nume de data sunt detectate dinamic.
       Fiecare coloana devine un rand.
       ===================================================== */

    DECLARE @ValuesList NVARCHAR(MAX);
    DECLARE @DynamicSQL NVARCHAR(MAX);

    SELECT
        @ValuesList = STRING_AGG
        (
            CAST
            (
                '('
                + 'CONVERT(DATE, '''
                + c.name
                + ''', 23), '
                + 'NULLIF(TRIM(CONVERT(VARCHAR(50), source_data.'
                + QUOTENAME(c.name)
                + ')), '''')'
                + ')'
                AS NVARCHAR(MAX)
            ),
            ',' + CHAR(10)
        )
        WITHIN GROUP
        (
            ORDER BY c.column_id
        )
    FROM sys.columns AS c
    WHERE c.object_id =
          OBJECT_ID('src.DUExamSchedule_Raw')
      AND c.name <> 'employee_id'
      AND TRY_CONVERT(DATE, c.name, 23) IS NOT NULL;

    IF @ValuesList IS NULL
    BEGIN
        THROW 50001,
              'Nu au fost gasite coloane de tip data in src.DUExamSchedule_Raw.',
              1;
    END;

    SET @DynamicSQL = N'
        INSERT INTO stg.DUExamSchedule
        (
            employee_id,
            activity_date,
            activity_code,
            dataset_name,
            process_timestamp
        )
        SELECT
            source_data.employee_id,
            schedule.activity_date,

            CASE UPPER(schedule.raw_activity_code)
                WHEN ''EXAM''
                    THEN ''Exam''

                WHEN ''ABSENCE''
                    THEN ''Absent''

                WHEN ''PH''
                    THEN ''Public Holiday''

                WHEN ''TRAINING''
                    THEN ''Training''

                WHEN ''TR''
                    THEN ''Training''

                WHEN ''WFH''
                    THEN ''Work From Home''

                ELSE ''Available''
            END AS activity_code,

            ''du_exam_schedule'',
            SYSDATETIME()

        FROM src.DUExamSchedule_Raw AS source_data

        CROSS APPLY
        (
            VALUES
            ' + @ValuesList + N'
        ) AS schedule
        (
            activity_date,
            raw_activity_code
        )

        WHERE source_data.employee_id IS NOT NULL;
    ';

    EXEC sys.sp_executesql @DynamicSQL;


    COMMIT TRANSACTION;

END TRY
BEGIN CATCH

    IF @@TRANCOUNT > 0
    BEGIN
        ROLLBACK TRANSACTION;
    END;

    THROW;

END CATCH;
GO