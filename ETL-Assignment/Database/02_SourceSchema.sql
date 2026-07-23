USE ETL_Assignment;
GO

/* =========================================================
   TRAINING ATTENDANCE
   Cele două fișiere vor fi încărcate în același tabel.
   ========================================================= */

DROP TABLE IF EXISTS src.TrainingAttendance;
GO

CREATE TABLE src.TrainingAttendance
(
    training_id     VARCHAR(20)  NULL,
    employee_name   VARCHAR(150) NULL,
    join_datetime   DATETIME2(0) NULL,
    leave_datetime  DATETIME2(0) NULL
);
GO


/* =========================================================
   EMPLOYEE MASTER CU ISTORIC
   Același employee_id poate avea mai multe înregistrări.
   ========================================================= */

DROP TABLE IF EXISTS src.EmployeeMaster;
GO

CREATE TABLE src.EmployeeMaster
(
    employee_id     INT          NULL,
    full_name       VARCHAR(150) NULL,
    grade           VARCHAR(50)  NULL,
    discipline      VARCHAR(100) NULL,
    line_manager    VARCHAR(150) NULL,
    delivery_unit   VARCHAR(100) NULL,
    role_start_date DATE         NULL
);
GO

CREATE TABLE src.Timesheets
(
    employee_id  INT,
    work_date    DATE,
    project_name VARCHAR(100),
    hours_worked DECIMAL(4,2)
);
GO

CREATE TABLE src.Absences
(
    employee_id  INT,
    absence_date DATE,
    absence_type VARCHAR(50)
);
GO

CREATE TABLE src.DUExamSchedule_Raw
(
    employee_id INT
);
GO