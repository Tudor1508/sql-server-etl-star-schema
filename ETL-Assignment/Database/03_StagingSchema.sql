-- =========================================================
-- 03_StagingSchema.sql
-- RESPONSABIL: Membrul 1 - Database Architect
--
-- SCOP:
-- Creeaza tabelele din schema stg.
-- Datele sunt curatate minimal si contin metadate de ingestie.
--
-- OBSERVATII:
-- - Training Attendance contine durata participarii calculata.
-- - Employee Master contine intervale istorice.
-- - DU Exam Schedule este transformat din matrice in randuri.
-- =========================================================

USE ETL_Assignment;
GO

IF SCHEMA_ID('stg') IS NULL
BEGIN
    EXEC ('CREATE SCHEMA stg');
END;
GO


/* =========================================================
   1. TIMESHEETS
   ========================================================= */

DROP TABLE IF EXISTS stg.Timesheets;
GO

CREATE TABLE stg.Timesheets
(
    staging_id         INT IDENTITY(1,1) PRIMARY KEY,
    employee_id        INT NOT NULL,
    work_date          DATE NOT NULL,
    project_name       VARCHAR(100) NULL,
    hours_worked       DECIMAL(4,2) NULL,

    dataset_name       VARCHAR(50) NOT NULL
        DEFAULT 'timesheets',

    process_timestamp  DATETIME2(0) NOT NULL
        DEFAULT SYSDATETIME()
);
GO


/* =========================================================
   2. ABSENCES
   ========================================================= */

DROP TABLE IF EXISTS stg.Absences;
GO

CREATE TABLE stg.Absences
(
    staging_id         INT IDENTITY(1,1) PRIMARY KEY,
    employee_id        INT NOT NULL,
    absence_date       DATE NOT NULL,
    absence_type       VARCHAR(50) NULL,

    dataset_name       VARCHAR(50) NOT NULL
        DEFAULT 'absences',

    process_timestamp  DATETIME2(0) NOT NULL
        DEFAULT SYSDATETIME()
);
GO


/* =========================================================
   3. TRAINING ATTENDANCE
   ========================================================= */

DROP TABLE IF EXISTS stg.TrainingAttendance;
GO

CREATE TABLE stg.TrainingAttendance
(
    staging_id         INT IDENTITY(1,1) PRIMARY KEY,

    employee_id        INT NOT NULL,
    training_id        VARCHAR(20) NOT NULL,
    training_name      VARCHAR(150) NULL,
    training_date      DATE NOT NULL,

    join_datetime      DATETIME2(0) NOT NULL,
    leave_datetime     DATETIME2(0) NOT NULL,

    attendance_minutes INT NOT NULL,
    attendance_hours   DECIMAL(6,2) NOT NULL,

    dataset_name       VARCHAR(50) NOT NULL
        DEFAULT 'training_attendance',

    process_timestamp  DATETIME2(0) NOT NULL
        DEFAULT SYSDATETIME()
);
GO


/* =========================================================
   4. EMPLOYEE MASTER HISTORY
   ========================================================= */

DROP TABLE IF EXISTS stg.EmployeeMaster;
GO

CREATE TABLE stg.EmployeeMaster
(
    staging_id         INT IDENTITY(1,1) PRIMARY KEY,

    employee_id        INT NOT NULL,
    full_name          VARCHAR(150) NULL,
    grade              VARCHAR(50) NULL,
    discipline         VARCHAR(100) NULL,
    line_manager       VARCHAR(150) NULL,
    delivery_unit      VARCHAR(100) NULL,

    valid_from         DATE NOT NULL,
    valid_to           DATE NULL,
    is_current         BIT NOT NULL,

    dataset_name       VARCHAR(50) NOT NULL
        DEFAULT 'employee_master',

    process_timestamp  DATETIME2(0) NOT NULL
        DEFAULT SYSDATETIME()
);
GO


/* =========================================================
   5. DU EXAM SCHEDULE
   ========================================================= */

DROP TABLE IF EXISTS stg.DUExamSchedule;
GO

CREATE TABLE stg.DUExamSchedule
(
    staging_id         INT IDENTITY(1,1) PRIMARY KEY,

    employee_id        INT NOT NULL,
    activity_date      DATE NOT NULL,
    activity_code      VARCHAR(50) NOT NULL,

    dataset_name       VARCHAR(50) NOT NULL
        DEFAULT 'du_exam_schedule',

    process_timestamp  DATETIME2(0) NOT NULL
        DEFAULT SYSDATETIME()
);
GO