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

IF EXISTS(SELECT 1 FROM sys.schemas WHERE name = 'lab01')
BEGIN
	DROP SCHEMA lab01;
END
GO 

CREATE SCHEMA lab01;
GO

IF EXISTS(SELECT 1 FROM sys.tables WHERE name = 'titulacao')
BEGIN
	DROP TABLE lab01.titulacao;
END

CREATE TABLE lab01.titulacao (
id_titulacao SMALLINT NOT NULL,
nom_titulacao VARCHAR(50) NOT NULL,

CONSTRAINT pk_titulacao PRIMARY KEY CLUSTERED (id_titulacao),
CONSTRAINT titulacao_unica UNIQUE NONCLUSTERED (nom_titulacao)
);

IF EXISTS(SELECT 1 FROM sys.tables WHERE name = 'professor')
BEGIN
	DROP TABLE lab01.professor;
END

CREATE TABLE lab01.professor (
id_prof INT NOT NULL,
nom_prof VARCHAR(100) NOT NULL,
id_titulacao SMALLINT NOT NULL,

CONSTRAINT pk_professor PRIMARY KEY CLUSTERED (id_prof),
CONSTRAINT nome_unico UNIQUE NONCLUSTERED (nom_prof),
CONSTRAINT fk_prof_titulacao FOREIGN KEY (id_titulacao) REFERENCES lab01.titulacao(id_titulacao)
);

IF EXISTS(SELECT 1 FROM sys.tables WHERE name = 'departamento')
BEGIN
	DROP TABLE lab01.departamento;
END

CREATE TABLE lab01.departamento (
id_depto SMALLINT NOT NULL,
nom_depto VARCHAR(100) NOT NULL,
id_prof INT NOT NULL,

CONSTRAINT pk_depto PRIMARY KEY CLUSTERED (id_depto),
CONSTRAINT depto_unico UNIQUE NONCLUSTERED (nom_depto),
CONSTRAINT fk_depto_professor FOREIGN KEY (id_prof) REFERENCES lab01.professor(id_prof)
);

IF EXISTS(SELECT 1 FROM sys.tables WHERE name = 'curso')
BEGIN
	DROP TABLE lab01.curso;
END

CREATE TABLE lab01.curso (
id_curso SMALLINT NOT NULL,
nom_curso VARCHAR(100) NOT NULL,
id_depto SMALLINT NOT NULL,

CONSTRAINT pk_curso PRIMARY KEY CLUSTERED (id_curso),
CONSTRAINT nome_curso_unico UNIQUE NONCLUSTERED (nom_curso),
CONSTRAINT fk_depto_curso FOREIGN KEY (id_depto) REFERENCES lab01.departamento(id_depto)
);

IF EXISTS(SELECT 1 FROM sys.tables WHERE name = 'bolsista')
BEGIN
	DROP TABLE lab01.bolsista;
END

CREATE TABLE lab01.bolsista (
id_bolsista INT NOT NULL,
nom_bolsista VARCHAR(100) NOT NULL,
id_curso SMALLINT NOT NULL,
dsc_email VARCHAR(50),
num_telefone VARCHAR(25) NOT NULL,
sex_bolsista CHAR(1) NOT NULL,

CONSTRAINT pk_bolsista PRIMARY KEY CLUSTERED (id_bolsista),
CONSTRAINT nome_bolsista_unico UNIQUE NONCLUSTERED (nom_bolsista),
CONSTRAINT fk_curso_bolsista FOREIGN KEY (id_curso) REFERENCES lab01.curso(id_curso),
CONSTRAINT valida_sexo CHECK (sex_bolsista IN ('M', 'F'))
);

IF EXISTS(SELECT 1 FROM sys.tables WHERE name = 'projeto')
BEGIN
	DROP TABLE lab01.projeto;
END

CREATE TABLE lab01.projeto (
id_projeto SMALLINT NOT NULL IDENTITY(1,1),
nom_projeto VARCHAR(100) NOT NULL,
dsc_projeto VARCHAR(MAX),
dat_inicio SMALLDATETIME NOT NULL DEFAULT GETDATE(),
dat_fim SMALLDATETIME,
val_orcamento NUMERIC(7,2) NOT NULL,
id_prof INT NOT NULL,

CONSTRAINT pk_projeto PRIMARY KEY CLUSTERED (id_projeto),
CONSTRAINT nome_projeto_unico UNIQUE NONCLUSTERED (nom_projeto),
CONSTRAINT fk_prof_projeto FOREIGN KEY (id_prof) REFERENCES lab01.professor(id_prof),
CONSTRAINT valida_data CHECK (dat_inicio <= dat_fim)
);

IF EXISTS(SELECT 1 FROM sys.tables WHERE name = 'equipe')
BEGIN
	DROP TABLE lab01.equipe;
END

CREATE TABLE lab01.equipe (
id_projeto SMALLINT NOT NULL,
id_bolsista INT NOT NULL,
val_bolsa NUMERIC(7,2) NOT NULL,

CONSTRAINT pk_equipe PRIMARY KEY CLUSTERED (id_projeto, id_bolsista),
CONSTRAINT fk_projeto_equipe FOREIGN KEY (id_projeto) REFERENCES lab01.projeto(id_projeto),
CONSTRAINT fk_bolsista_equipe FOREIGN KEY (id_bolsista) REFERENCES lab01.bolsista(id_bolsista)
);

ALTER TABLE lab01.professor
ADD sex_prof CHAR(1) NOT NULL;

ALTER TABLE lab01.professor
ADD CONSTRAINT valida_sexo_professor CHECK(sex_prof IN ('M', 'F'));

IF EXISTS(SELECT 1 FROM sys.tables WHERE name = 'area_conhecimento')
BEGIN
	DROP TABLE lab01.area_conhecimento;
END

CREATE TABLE lab01.area_conhecimento (
id_area_conhecimento SMALLINT NOT NULL,
dsc_area_conhecimento VARCHAR(100) NOT NULL,

CONSTRAINT pk_area_conhecimento PRIMARY KEY CLUSTERED (id_area_conhecimento),
CONSTRAINT area_conhecimento_unico UNIQUE NONCLUSTERED (dsc_area_conhecimento)
);

ALTER TABLE lab01.curso
ADD id_area_conhecimento SMALLINT;

ALTER TABLE lab01.curso
ADD CONSTRAINT fk_area_curso FOREIGN KEY (id_area_conhecimento) REFERENCES lab01.area_conhecimento(id_area_conhecimento);
