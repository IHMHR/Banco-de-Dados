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

CREATE OR ALTER FUNCTION Automovel.validarAno (@ano INT)
RETURNS BIT
WITH SCHEMABINDING
AS
	BEGIN
		RETURN CASE
			       WHEN LEN(@ano) <> 4 THEN 0
			       WHEN @ano < 1600 THEN 0
			       WHEN @ano > CAST(DATEPART(YEAR, GETDATE()) AS INT) + 1 THEN 0
			       WHEN @ano <= CAST(DATEPART(YEAR, GETDATE()) AS INT) + 1 THEN 1
			       ELSE 0
		       END;
	END;
GO

IF EXISTS(SELECT 1 FROM sys.tables WHERE name = N'marca')
BEGIN
	DROP TABLE Automovel.marca;
END

CREATE TABLE Automovel.marca (
idmarca INT IDENTITY NOT NULL,
marca VARCHAR(50) NOT NULL,

CONSTRAINT pk_marca PRIMARY KEY CLUSTERED (idmarca),
CONSTRAINT marca_unica UNIQUE NONCLUSTERED (marca)
) ON [PRIMARY];

IF EXISTS(SELECT 1 FROM sys.tables WHERE name = N'modelo')
BEGIN
	DROP TABLE Automovel.modelo;
END

CREATE TABLE Automovel.modelo (
idmodelo INT IDENTITY NOT NULL,
modelo VARCHAR(50) NOT NULL,
marca_idmarca INT NOT NULL,

CONSTRAINT pk_modelo PRIMARY KEY CLUSTERED (idmodelo),
CONSTRAINT modelo_unico UNIQUE NONCLUSTERED (modelo),
CONSTRAINT fk_marca_modelo FOREIGN KEY (marca_idmarca) REFERENCES Automovel.marca(idmarca)
) ON [PRIMARY];

IF EXISTS(SELECT 1 FROM sys.tables WHERE name = N'veiculo')
BEGIN
	DROP TABLE Automovel.veiculo;
END

CREATE TABLE Automovel.veiculo (
idveiculo INT IDENTITY NOT NULL,
chassi VARCHAR(50) NOT NULL,
placa CHAR(7) NOT NULL,
ano_fabricacao INT NOT NULL,
valor DECIMAL(10,2) NOT NULL,
marca_idmarca INT NOT NULL

CONSTRAINT pk_veiculo PRIMARY KEY CLUSTERED (idveiculo),
CONSTRAINT fk_marca FOREIGN KEY (marca_idmarca) REFERENCES Automovel.marca(idmarca),
CONSTRAINT chassi_unico UNIQUE NONCLUSTERED (chassi),
CONSTRAINT placa_unica UNIQUE NONCLUSTERED (placa),
CONSTRAINT validar_ano CHECK (Automovel.validarAno(ano_fabricacao) = 1)
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
CONSTRAINT loja_unica UNIQUE NONCLUSTERED (loja),
CONSTRAINT fk_endereco_loja FOREIGN KEY (endereco_idendereco) REFERENCES Localidade.endereco(idendereco)
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

CONSTRAINT pk_pagamento PRIMARY KEY CLUSTERED (idpagamento)
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

SET NOCOUNT ON;
INSERT Automovel.marca (marca) VALUES ('FIAT'),('Honda'),('Renault'),('Peugeot'),('Ferrari'),('BMW'),('Chevrolet'),('Volkswagen');

INSERT Automovel.modelo (modelo, marca_idmarca) VALUES ('Palio', 1),('City', 2),('Celta', 7),('S10', 7),('Gol', 8),('Clio', 3),('Novo Uno', 1);

INSERT Automovel.veiculo (chassi, placa, ano_fabricacao, valor, marca_idmarca)
VALUES ('1234567890', 'PLA1234', 1996, 19999.99, 2), ('0987654321', 'PLA9876', 2017, 35000.00, 5),
('1029384756', 'CAR0007', 2007, 8500.00, 1), ('4783920156', 'ABC1234', 2010, 15000.00, 6),
('4321567098', 'ZZZ9999', 1870, 120000.00, 3), ('42702490244', 'LUC6666', 1966, 66600.00, 4);

INSERT Automovel.opcionais (opcionais) VALUES ('DVD Player'),('Banco de Couro'),('Alarme'),('Vidro Elétrico'),('Som MP3'),('Kit Primeiros Socorros'),('Ar Condicionado');

INSERT Automovel.veiculos_has_opcionais (veiculo_idveiculo, opcionais_idopcionais)
VALUES (1, 1),(1, 2),(2, 1),(3, 1),(3, 4),(5, 1),(5, 2),(5, 3),(5, 4),(6, 1),(6, 4);

INSERT Localidade.estado (estado, uf) VALUES ('Minas Gerais', 'MG'),('Goias', 'GO'),('São Paulo', 'SP'),('Rio de Janeiro', 'RJ'),('Mato Grosso', 'MT'),('Bahia', 'BA'),('Santa Catarina', 'SC'),('Alagoas', 'AL');

INSERT Localidade.cidade (cidade, estado_idestado) VALUES ('Betim', 1),('Belo Horizonte', 1),('São Paulo', 3),('Rio de Janeiro', 4),('Salvador', 6),('Buriti Alegre', 2),('Cajuru', 3),('Maceió', 8),('Feira de Santana', 6);

INSERT Localidade.endereco (cep, logradouro, numero, bairro, cidade_idcidade) 
VALUES ('30840760', 'Rua dos Securitários', 115, 'Alípio de Melo', 2),
('32600140', 'Avenida Nossa Senhora do Carmo', 543, 'Centro', 1),
('01310200', 'Avenida Paulista', 1578, 'Bela Vista', 3),
('57036010', 'Rua Doutor Aristeu Lopes', 0, 'Jatiúca', 8),
('44003276', 'Rua Comandante Almiro', 46, 'Serraria Brasil', 9),
('20540005', 'Rua Barão de Mesquista', 141, 'Tijuca', 4);

INSERT Comercio.loja (loja, endereco_idendereco) VALUES ('Matriz', 1),('Filial 01', 2),('Filial 02', 3),('Filial RJ', 6),('Filial Nova', 5);

INSERT Comercio.vendedor (nome, loja_idloja) 
VALUES ('Igor Henrique Martinelli de Heredia Ramos', 1),
('Silvia Salim', 1),
('Ana Paula Oliveira', 2),
('Felipe Silveira dos Santos', 3),
('Jean Carlos Silva', 3),
('Marta Bruna Nogueira', 4);

INSERT Comercio.forma_pagamento (forma_pagamento) VALUES ('Dinheiro'),('Cartão de Crédito'),('Cartão de Débito'),('Cheque'),('Vale Alimentação'),('Empréstimo Bancário');

INSERT Comercio.pagamento (sequencia, valor, quantidade) VALUES (1, 1000.00, 1),(2, 500.00, 5),(3, 100.00, 10),
(1, 1000.00, 5),(2, 500.00, 1),(3, 350.00, 24);
