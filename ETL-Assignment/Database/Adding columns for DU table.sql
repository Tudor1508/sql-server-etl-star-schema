-- =========================================================
-- Add_DUExamSchedule_Columns.sql
-- =========================================================

USE ETL_Assignment;
GO

IF COL_LENGTH('src.DUExamSchedule_Raw', '2026-07-01') IS NULL
BEGIN
    ALTER TABLE src.DUExamSchedule_Raw
    ADD [2026-07-01] VARCHAR(20) NULL;
END;
GO

IF COL_LENGTH('src.DUExamSchedule_Raw', '2026-07-02') IS NULL
BEGIN
    ALTER TABLE src.DUExamSchedule_Raw
    ADD [2026-07-02] VARCHAR(20) NULL;
END;
GO

IF COL_LENGTH('src.DUExamSchedule_Raw', '2026-07-03') IS NULL
BEGIN
    ALTER TABLE src.DUExamSchedule_Raw
    ADD [2026-07-03] VARCHAR(20) NULL;
END;
GO

IF COL_LENGTH('src.DUExamSchedule_Raw', '2026-07-06') IS NULL
BEGIN
    ALTER TABLE src.DUExamSchedule_Raw
    ADD [2026-07-06] VARCHAR(20) NULL;
END;
GO

IF COL_LENGTH('src.DUExamSchedule_Raw', '2026-07-07') IS NULL
BEGIN
    ALTER TABLE src.DUExamSchedule_Raw
    ADD [2026-07-07] VARCHAR(20) NULL;
END;
GO

IF COL_LENGTH('src.DUExamSchedule_Raw', '2026-07-08') IS NULL
BEGIN
    ALTER TABLE src.DUExamSchedule_Raw
    ADD [2026-07-08] VARCHAR(20) NULL;
END;
GO

IF COL_LENGTH('src.DUExamSchedule_Raw', '2026-07-09') IS NULL
BEGIN
    ALTER TABLE src.DUExamSchedule_Raw
    ADD [2026-07-09] VARCHAR(20) NULL;
END;
GO

IF COL_LENGTH('src.DUExamSchedule_Raw', '2026-07-10') IS NULL
BEGIN
    ALTER TABLE src.DUExamSchedule_Raw
    ADD [2026-07-10] VARCHAR(20) NULL;
END;
GO

IF COL_LENGTH('src.DUExamSchedule_Raw', '2026-07-13') IS NULL
BEGIN
    ALTER TABLE src.DUExamSchedule_Raw
    ADD [2026-07-13] VARCHAR(20) NULL;
END;
GO

IF COL_LENGTH('src.DUExamSchedule_Raw', '2026-07-14') IS NULL
BEGIN
    ALTER TABLE src.DUExamSchedule_Raw
    ADD [2026-07-14] VARCHAR(20) NULL;
END;
GO

IF COL_LENGTH('src.DUExamSchedule_Raw', '2026-07-15') IS NULL
BEGIN
    ALTER TABLE src.DUExamSchedule_Raw
    ADD [2026-07-15] VARCHAR(20) NULL;
END;
GO

IF COL_LENGTH('src.DUExamSchedule_Raw', '2026-07-16') IS NULL
BEGIN
    ALTER TABLE src.DUExamSchedule_Raw
    ADD [2026-07-16] VARCHAR(20) NULL;
END;
GO

IF COL_LENGTH('src.DUExamSchedule_Raw', '2026-07-17') IS NULL
BEGIN
    ALTER TABLE src.DUExamSchedule_Raw
    ADD [2026-07-17] VARCHAR(20) NULL;
END;
GO

IF COL_LENGTH('src.DUExamSchedule_Raw', '2026-07-20') IS NULL
BEGIN
    ALTER TABLE src.DUExamSchedule_Raw
    ADD [2026-07-20] VARCHAR(20) NULL;
END;
GO

IF COL_LENGTH('src.DUExamSchedule_Raw', '2026-07-21') IS NULL
BEGIN
    ALTER TABLE src.DUExamSchedule_Raw
    ADD [2026-07-21] VARCHAR(20) NULL;
END;
GO

IF COL_LENGTH('src.DUExamSchedule_Raw', '2026-07-22') IS NULL
BEGIN
    ALTER TABLE src.DUExamSchedule_Raw
    ADD [2026-07-22] VARCHAR(20) NULL;
END;
GO

IF COL_LENGTH('src.DUExamSchedule_Raw', '2026-07-23') IS NULL
BEGIN
    ALTER TABLE src.DUExamSchedule_Raw
    ADD [2026-07-23] VARCHAR(20) NULL;
END;
GO

IF COL_LENGTH('src.DUExamSchedule_Raw', '2026-07-24') IS NULL
BEGIN
    ALTER TABLE src.DUExamSchedule_Raw
    ADD [2026-07-24] VARCHAR(20) NULL;
END;
GO

IF COL_LENGTH('src.DUExamSchedule_Raw', '2026-07-27') IS NULL
BEGIN
    ALTER TABLE src.DUExamSchedule_Raw
    ADD [2026-07-27] VARCHAR(20) NULL;
END;
GO

IF COL_LENGTH('src.DUExamSchedule_Raw', '2026-07-28') IS NULL
BEGIN
    ALTER TABLE src.DUExamSchedule_Raw
    ADD [2026-07-28] VARCHAR(20) NULL;
END;
GO

IF COL_LENGTH('src.DUExamSchedule_Raw', '2026-07-29') IS NULL
BEGIN
    ALTER TABLE src.DUExamSchedule_Raw
    ADD [2026-07-29] VARCHAR(20) NULL;
END;
GO

IF COL_LENGTH('src.DUExamSchedule_Raw', '2026-07-30') IS NULL
BEGIN
    ALTER TABLE src.DUExamSchedule_Raw
    ADD [2026-07-30] VARCHAR(20) NULL;
END;
GO

IF COL_LENGTH('src.DUExamSchedule_Raw', '2026-07-31') IS NULL
BEGIN
    ALTER TABLE src.DUExamSchedule_Raw
    ADD [2026-07-31] VARCHAR(20) NULL;
END;
GO

SELECT
    c.column_id,
    c.name AS column_name,
    TYPE_NAME(c.user_type_id) AS data_type,
    c.max_length
FROM sys.columns c
WHERE c.object_id = OBJECT_ID('src.DUExamSchedule_Raw')
ORDER BY c.column_id;
GO