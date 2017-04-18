USE master;
GO

IF EXISTS(SELECT 1 FROM sys.databases WHERE name = 'banco_dados_aula')
BEGIN
    ALTER DATABASE banco_dados_aula SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE banco_dados_aula;
END

CREATE DATABASE banco_dados_aula CONTAINMENT = NONE
ON (NAME = 'bancoDadosAula', FILENAME = 'C:\Users\IHMHR\Documents\SQL Databases\BD 1\bancoDadosAula.mdf', SIZE = 100MB, MAXSIZE = 1024MB, FILEGROWTH = 25MB)
LOG ON (NAME = 'bancoDadosAulaLog', FILENAME = 'C:\Users\IHMHR\Documents\SQL Databases\BD 1\bancoDadosAula.ldf', SIZE = 10MB, MAXSIZE = 512MB, FILEGROWTH = 15MB)
COLLATE Latin1_General_CS_AS;
GO