USE ETL_Assignment;
GO

TRUNCATE TABLE src.Timesheets;
GO

BULK INSERT src.Timesheets
FROM '/var/opt/mssql/import/Timesheets.csv'
WITH
(
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDQUOTE = '"',
    FIELDTERMINATOR = ';',
    ROWTERMINATOR = '0x0a',
    CODEPAGE = 'RAW',
    TABLOCK
);
GO

SELECT COUNT(*) AS ImportedRows
FROM src.Timesheets;
GO

TRUNCATE TABLE src.TrainingAttendance;
GO

BULK INSERT src.TrainingAttendance
FROM '/var/opt/mssql/import/Training_Attendance_TRN001_SQL_Fundamentals.csv'
WITH
(
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDQUOTE = '"',
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    CODEPAGE = 'RAW',
    TABLOCK
);
GO

BULK INSERT src.TrainingAttendance
FROM '/var/opt/mssql/import/Training_Attendance_TRN002_Azure_Data_Factory_Fundamentals.csv'
WITH
(
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDQUOTE = '"',
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    CODEPAGE = 'RAW',
    TABLOCK
);
GO

SELECT
    training_id,
    COUNT(*) AS Attendance
FROM src.TrainingAttendance
GROUP BY training_id;
GO

TRUNCATE TABLE src.Absences;
GO

BULK INSERT src.Absences
FROM '/var/opt/mssql/import/Absences_Absences.csv'
WITH
(
    FORMAT='CSV',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK
);
GO

TRUNCATE TABLE src.EmployeeMaster;
GO

BULK INSERT src.EmployeeMaster
FROM '/var/opt/mssql/import/Employee_Master_Data_EmployeeMaster.csv'
WITH
(
    FORMAT='CSV',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK
);
GO

TRUNCATE TABLE src.DUExamSchedule_Raw;
GO

BULK INSERT src.DUExamSchedule_Raw
FROM '/var/opt/mssql/import/DU_Exam_Absence_Schedule_Schedule_Matrix.csv'
WITH
(
    FORMAT='CSV',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK
);
GO

SELECT 'Timesheets' AS TableName, COUNT(*) AS RowsLoaded
FROM src.Timesheets

UNION ALL

SELECT 'Absences', COUNT(*)
FROM src.Absences

UNION ALL

SELECT 'TrainingAttendance', COUNT(*)
FROM src.TrainingAttendance

UNION ALL

SELECT 'EmployeeMaster', COUNT(*)
FROM src.EmployeeMaster

UNION ALL

SELECT 'DUExamSchedule_Raw', COUNT(*)
FROM src.DUExamSchedule_Raw;
GO

SELECT TOP (10) *
FROM src.Timesheets
ORDER BY employee_id, work_date;

SELECT TOP (10) *
FROM src.TrainingAttendance
ORDER BY training_id, employee_name;

SELECT TOP (20) *
FROM src.EmployeeMaster
ORDER BY employee_id, role_start_date;

