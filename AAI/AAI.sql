USE [master];
GO

CREATE DATABASE [AAI];
GO

USE [AAI];
GO

CREATE SCHEMA [Automovel];
GO

CREATE SCHEMA [Localidade];
GO

CREATE SCHEMA [Comercio];
GO

IF EXISTS(SELECT 1 FROM sys.tables WHERE name = N'modelo')
BEGIN
	DROP TABLE Automovel.modelo;
END

CREATE TABLE Automovel.modelo (
idmodelo INT NOT NULL,
modelo VARCHAR(50) NOT NULL,

CONSTRAINT pk_modelo PRIMARY KEY CLUSTERED (idmodelo),
CONSTRAINT modelo_unico UNIQUE NONCLUSTERED (modelo)
) ON [PRIMARY];


IF EXISTS(SELECT 1 FROM sys.tables WHERE name = N'marca')
BEGIN
	DROP TABLE Automovel.marca;
END

CREATE TABLE Automovel.marca (
idmarca INT NOT NULL,
marca VARCHAR(50) NOT NULL,
modelo_idmodelo INT NOT NULL,

CONSTRAINT pk_marca PRIMARY KEY CLUSTERED (idmarca),
CONSTRAINT fk_modelo FOREIGN KEY (modelo_idmodelo) REFERENCES Automovel.modelo(idmodelo),
CONSTRAINT marca_unica UNIQUE NONCLUSTERED (marca)
) ON [PRIMARY];

IF EXISTS(SELECT 1 FROM sys.tables WHERE name = N'veiculo')
BEGIN
	DROP TABLE Automovel.veiculo;
END

CREATE TABLE Automovel.veiculo (
idveiculo INT NOT NULL,
chassi VARCHAR(50) NOT NULL,
placa CHAR(7) NOT NULL,
ano_fabricacao DATE NOT NULL,
valor DECIMAL(10,2) NOT NULL,
marca_idmarca INT NOT NULL

CONSTRAINT pk_veiculo PRIMARY KEY CLUSTERED (idveiculo),
CONSTRAINT fk_marca FOREIGN KEY (marca_idmarca) REFERENCES Automovel.marca(idmarca),
CONSTRAINT chassi_unico UNIQUE NONCLUSTERED (chassi),
CONSTRAINT placa_unica UNIQUE NONCLUSTERED (placa)
) ON [PRIMARY];

IF EXISTS(SELECT 1 FROM sys.tables WHERE name = N'opcionais')
BEGIN
	DROP TABLE Automovel.opcionais;
END

CREATE TABLE Automovel.opcionais (
idopcionais INT NOT NULL,
opcionais VARCHAR(50) NOT NULL

CONSTRAINT pk_opcionais PRIMARY KEY CLUSTERED (idopcionais)
CONSTRAINT opcionais_unico UNIQUE NONCLUSTERED (opcionais)
) ON [PRIMARY];

IF EXISTS(SELECT 1 FROM sys.tables WHERE name = N'veiculos_has_opcionais')
BEGIN
	DROP TABLE Automovel.veiculos_has_opcionais;
END

CREATE TABLE Automovel.veiculos_has_opcionais (
idveiculos_has_opcionais INT NOT NULL,
veiculo_idveiculo INT NOT NULL,
opcionais_idopcionais INT NOT NULL,

CONSTRAINT fk_veiculo FOREIGN KEY (veiculo_idveiculo) REFERENCES Automovel.veiculo(idveiculo),
CONSTRAINT fk_opcionais FOREIGN KEY (opcionais_idopcionais) REFERENCES Automovel.opcionais(idopcionais),
CONSTRAINT opcionais_por_veiculo UNIQUE NONCLUSTERED (veiculo_idveiculo, opcionais_idopcionais)
) ON [PRIMARY];

IF EXISTS(SELECT 1 FROM sys.tables WHERE name = N'estado')
BEGIN
	DROP TABLE Localidade.estado;
END

CREATE TABLE Localidade.estado (
idestado INT NOT NULL,
estado VARCHAR(25) NOT NULL,
uf CHAR(2) NOT NULL,

CONSTRAINT pk_estado PRIMARY KEY CLUSTERED (idestado),
CONSTRAINT estado_unico UNIQUE NONCLUSTERED (estado),
CONSTRAINT uf_unico UNIQUE NONCLUSTERED (uf)
) ON [PRIMARY];

IF EXISTS(SELECT 1 FROM sys.tables WHERE name = N'cidade')
BEGIN
	DROP TABLE Automovel.cidade;
END

CREATE TABLE Automovel.cidade (
idcidade INT NOT NULL,
cidade VARCHAR(50) NOT NULL,

CONSTRAINT pk_cidade PRIMARY KEY CLUSTERED (idcidade),
) ON [PRIMARY];