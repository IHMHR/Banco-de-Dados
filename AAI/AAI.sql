USE [master];
GO

IF EXISTS(SELECT 1 FROM sys.databases WHERE name = N'AAI')
BEGIN
	ALTER DATABASE [AAI] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE [AAI];
END

CREATE DATABASE [AAI];
GO

ALTER DATABASE [AAI] SET COMPATIBILITY_LEVEL = 100;
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
idmodelo INT IDENTITY NOT NULL,
modelo VARCHAR(50) NOT NULL,

CONSTRAINT pk_modelo PRIMARY KEY CLUSTERED (idmodelo),
CONSTRAINT modelo_unico UNIQUE NONCLUSTERED (modelo)
) ON [PRIMARY];


IF EXISTS(SELECT 1 FROM sys.tables WHERE name = N'marca')
BEGIN
	DROP TABLE Automovel.marca;
END

CREATE TABLE Automovel.marca (
idmarca INT IDENTITY NOT NULL,
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
idveiculo INT IDENTITY NOT NULL,
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
idopcionais INT IDENTITY NOT NULL,
opcionais VARCHAR(50) NOT NULL

CONSTRAINT pk_opcionais PRIMARY KEY CLUSTERED (idopcionais),
CONSTRAINT opcionais_unico UNIQUE NONCLUSTERED (opcionais)
) ON [PRIMARY];

IF EXISTS(SELECT 1 FROM sys.tables WHERE name = N'veiculos_has_opcionais')
BEGIN
	DROP TABLE Automovel.veiculos_has_opcionais;
END

CREATE TABLE Automovel.veiculos_has_opcionais (
idveiculos_has_opcionais INT IDENTITY NOT NULL,
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
idestado INT IDENTITY NOT NULL,
estado VARCHAR(25) NOT NULL,
uf CHAR(2) NOT NULL,

CONSTRAINT pk_estado PRIMARY KEY CLUSTERED (idestado),
CONSTRAINT estado_unico UNIQUE NONCLUSTERED (estado),
CONSTRAINT uf_unico UNIQUE NONCLUSTERED (uf)
) ON [PRIMARY];

IF EXISTS(SELECT 1 FROM sys.tables WHERE name = N'cidade')
BEGIN
	DROP TABLE Localidade.cidade;
END

CREATE TABLE Localidade.cidade (
idcidade INT IDENTITY NOT NULL,
cidade VARCHAR(50) NOT NULL,
estado_idestado INT NOT NULL,

CONSTRAINT pk_cidade PRIMARY KEY CLUSTERED (idcidade),
CONSTRAINT fk_estado_cidade FOREIGN KEY (estado_idestado) REFERENCES Localidade.estado(idestado)
) ON [PRIMARY];

IF EXISTS(SELECT 1 FROM sys.tables WHERE name = N'endereco')
BEGIN
	DROP TABLE Localidade.endereco;
END

CREATE TABLE Localidade.endereco (
idendereco INT IDENTITY NOT NULL,
cep CHAR(8) NOT NULL,
logradouro VARCHAR(50) NOT NULL,
numero INT NOT NULL,
bairro VARCHAR(50) NOT NULL,
cidade_idcidade INT NOT NULL,

CONSTRAINT pk_endereco PRIMARY KEY CLUSTERED (idendereco),
CONSTRAINT fk_cidade FOREIGN KEY (cidade_idcidade) REFERENCES Localidade.cidade(idcidade)
) ON [PRIMARY]

IF EXISTS(SELECT 1 FROM sys.tables WHERE name = N'loja')
BEGIN
	DROP TABLE Comercio.loja;
END

CREATE TABLE Comercio.loja (
idloja INT IDENTITY NOT NULL,
loja VARCHAR(25) NOT NULL,
endereco_idendereco INT NOT NULL,

CONSTRAINT pk_loja PRIMARY KEY CLUSTERED (idloja),
CONSTRAINT loja_unica UNIQUE NONCLUSTERED (loja)
) ON [PRIMARY]

IF EXISTS(SELECT 1 FROM sys.tables WHERE name = N'vendedor')
BEGIN
	DROP TABLE Comercio.vendedor;
END

CREATE TABLE Comercio.vendedor (
idvendedor INT IDENTITY NOT NULL,
nome VARCHAR(100) NOT NULL,
loja_idloja INT NOT NULL,

CONSTRAINT pk_vendedor PRIMARY KEY CLUSTERED (idvendedor),
CONSTRAINT fk_loja_vendedor FOREIGN KEY (loja_idloja) REFERENCES Comercio.loja(idloja)
) ON [PRIMARY]

IF EXISTS(SELECT 1 FROM sys.tables WHERE name = N'forma_pagamento')
BEGIN
	DROP TABLE Comercio.forma_pagamento;
END

CREATE TABLE Comercio.forma_pagamento (
idforma_pagamento INT IDENTITY NOT NULL,
forma_pagamento VARCHAR(50) NOT NULL,

CONSTRAINT pk_forma_pagamento PRIMARY KEY CLUSTERED (idforma_pagamento),
CONSTRAINT forma_pagamento_unica UNIQUE NONCLUSTERED (forma_pagamento)
) ON [PRIMARY]

IF EXISTS(SELECT 1 FROM sys.tables WHERE name = N'pagamento')
BEGIN
	DROP TABLE Comercio.pagamento;
END

CREATE TABLE Comercio.pagamento (
idpagamento INT IDENTITY NOT NULL,
sequencia TINYINT NOT NULL,
valor DECIMAL(12,2) NOT NULL,
quantidade TINYINT NOT NULL,

CONSTRAINT pk_pagamento PRIMARY KEY CLUSTERED (idpagamento),
) ON [PRIMARY]

IF EXISTS(SELECT 1 FROM sys.tables WHERE name = N'item_pagamento')
BEGIN
	DROP TABLE Comercio.item_pagamento;
END

CREATE TABLE Comercio.item_pagamento (
iditem_pagamento INT IDENTITY NOT NULL,
item_pagamento VARCHAR(50) NOT NULL,
forma_pagamento_idforma_pagamento INT NOT NULL,
pagamento_idpagamento INT NOT NULL,

CONSTRAINT pk_item_pagamento PRIMARY KEY CLUSTERED (iditem_pagamento),
CONSTRAINT fk_forma_pagamento FOREIGN KEY (forma_pagamento_idforma_pagamento) REFERENCES Comercio.forma_pagamento(idforma_pagamento),
CONSTRAINT item_pagamento_unico UNIQUE NONCLUSTERED (item_pagamento),
CONSTRAINT fk_pagamento_itens FOREIGN KEY (pagamento_idpagamento) REFERENCES Comercio.pagamento(idpagamento)
) ON [PRIMARY]

IF EXISTS(SELECT 1 FROM sys.tables WHERE name = N'cliente')
BEGIN
	DROP TABLE Comercio.cliente;
END

CREATE TABLE Comercio.cliente (
idcliente INT IDENTITY NOT NULL,
cpf CHAR(11) NOT NULL,
nome VARCHAR(5) NOT NULL,
endereco_idendereco INT NOT NULL,

CONSTRAINT pk_cliente PRIMARY KEY CLUSTERED (idcliente),
CONSTRAINT cpf_unico UNIQUE NONCLUSTERED (cpf),
CONSTRAINT fk_endereco_cliente FOREIGN KEY (endereco_idendereco) REFERENCES Localidade.endereco(idendereco)
) ON [PRIMARY]

IF EXISTS(SELECT 1 FROM sys.tables WHERE name = N'venda')
BEGIN
	DROP TABLE Comercio.venda;
END

CREATE TABLE Comercio.venda (
idvenda INT IDENTITY NOT NULL,
[data] DATETIME2 NOT NULL DEFAULT GETDATE(),
desconto DECIMAL(5,2) NOT NULL DEFAULT 0.0,
cliente_idcliente INT NOT NULL,
veiculo_idveiculo INT NOT NULL,
vendedor_idvendedor INT NOT NULL,
pagamento_idpagamento INT NOT NULL,

CONSTRAINT pk_venda PRIMARY KEY CLUSTERED (idvenda),
CONSTRAINT venda_no_dia CHECK (data >= GETDATE()),
CONSTRAINT fk_cliente_venda FOREIGN KEY (cliente_idcliente) REFERENCES Comercio.cliente(idcliente),
CONSTRAINT fk_veiculo_venda FOREIGN KEY (veiculo_idveiculo) REFERENCES Automovel.veiculo(idveiculo),
CONSTRAINT fk_vendedor_venda FOREIGN KEY (vendedor_idvendedor) REFERENCES Comercio.vendedor(idvendedor),
CONSTRAINT fk_pagemento_venda FOREIGN KEY (pagamento_idpagamento) REFERENCES Comercio.pagamento(idpagamento)
) ON [PRIMARY]