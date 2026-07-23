
-- =========================================================
-- 01_CreateDatabase.sql
-- RESPONSABIL: Membrul 1 (Database Architect)
-- SCOP: Creeaza baza de date si cele 3 schema-uri principale.
--       Se ruleaza PRIMUL, inaintea oricarui alt script.
-- =========================================================

CREATE DATABASE ETL_Assignment;
GO
USE ETL_Assignment;
GO

-- src    = datele brute, cat mai aproape de cum vin din sursele originale
-- stg    = staging: date curatate/transformate minim, gata de mapat pe star schema
-- dwh    = data warehouse: star schema final (dimensiuni + fapte), pentru rapoarte

CREATE SCHEMA src;
GO
CREATE SCHEMA stg;
GO
CREATE SCHEMA dwh;
GO

-- De aici, Membrul 1 continua cu:
--   02_SourceSchema.sql  -> tabelele "src"
--   03_StagingSchema.sql -> tabelele "stg"
--   04_DWSchema.sql       -> tabelele "dwh" (star schema)