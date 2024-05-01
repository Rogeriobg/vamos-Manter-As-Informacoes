
USE loja;

CREATE TABLE Usuario (
  UsuarioID INT IDENTITY(1,1) PRIMARY KEY,
  Login VARCHAR(50) NULL,
  Senha VARCHAR(50) NULL
);

CREATE TABLE Pessoa (
  PessoaID INT IDENTITY(1,1) PRIMARY KEY,
  Nome VARCHAR(100) NULL,
  Tipo CHAR(1) NULL,
  Logradouro VARCHAR(100) NULL,
  Cidade VARCHAR(100) NULL,
  Estado VARCHAR(2) NULL,
  Telefone VARCHAR(14) NULL,
  Email VARCHAR(100) NULL
);

CREATE TABLE PessoaFisica (
  PessoaID INT NOT NULL,
  Pessoa_PessoaID INT NOT NULL,
  CPF CHAR(11) NULL,
  PRIMARY KEY(PessoaID),
  FOREIGN KEY (Pessoa_PessoaID) REFERENCES Pessoa(PessoaID)
);


CREATE TABLE PessoaJuridica (
  PessoaID INT NOT NULL,
  Pessoa_PessoaID INT NOT NULL,
  CNPJ CHAR(14) NULL,
  PRIMARY KEY(PessoaID),
  FOREIGN KEY (Pessoa_PessoaID) REFERENCES Pessoa(PessoaID)
);

CREATE TABLE Produto (
  ProdutoID INT IDENTITY(1,1) PRIMARY KEY,
  Nome VARCHAR(100) NULL,
  Quantidade INT NULL,
  PrecoVenda DECIMAL(10,2) NULL
);



CREATE TABLE Movimento (
    MovimentoID INT PRIMARY KEY,
	UsuarioID INT,
    Tipo CHAR(1), -- 'E' para compra, 'S' para venda
    PessoaID INT, 
    ProdutoID INT,
    Quantidade INT,
    PrecoUnitario DECIMAL(10,2),
    FOREIGN KEY (PessoaID) REFERENCES Pessoa(PessoaID),
    FOREIGN KEY (ProdutoID) REFERENCES Produto(ProdutoID)
 
);

-- 2° PROCEDIMENTO 

-- INSERINDO OS USUARIOS
INSERT INTO Usuario (UsuarioID, Login, Senha)
VALUES (1, 'op1', 'op2'),
(2, 'op2', 'op2'),
(3, 'op3', 'op3');

SELECT * FROM Usuario;

--INSERÇÃO DOS DADOS COMUNS NA TABELA  PESSOA 
INSERT INTO Pessoa (PessoaID, Nome, Tipo, Logradouro, Cidade, Estado, Telefone, Email)

VALUES ('7', 'Joao', 'F', 'Rua 12,casa 3. Quitanda', 'Riacho do Sul', 'PA', '1111-1111','joao@riacho.com'),
      ('15', 'JJC', 'F', 'Rua 11,Centro', 'Riacho do Norte', 'PA', '1212-1212','jjc@riacho.com'),
      ('16', 'JJC2', 'F', 'Rua 11,Centro B', 'Riacho do Norte', 'PA', '1313-1313','jjc2@riacho.com'),
      ('17', 'JJC3', 'J', 'Rua 11,Centro c', 'Riacho do Norte', 'PA', '1414-1414','jjc4@riacho.com'),
      ('18', 'JJC4', 'J', 'Rua 11,Centro D', 'Riacho do Norte', 'PA', '1515-1515','jjc5@riacho.com'); 
       

SELECT * FROM Pessoa;

--INSERÇÃO DOS DADOS DE CPF E CNPJ DE PESSOA FÍSICA E JURÍDICA
INSERT INTO PessoaFisica (PessoaID, Pessoa_PessoaID, CPF)
VALUES (7, '7', '11111111111'),
(15, '15', '22222222222'),
(16, '16', '33333333333');

INSERT INTO PessoaJuridica (PessoaID, Pessoa_PessoaID, CNPJ)
VALUES ('17', '17', '44444444444444'),
('18', '18', '55555555555555');

SELECT * FROM PessoaJuridica

SELECT * FROM PessoaFisica;

-- INSERÇÃO DE PRODUTOS
SET IDENTITY_INSERT Produto ON;
INSERT INTO Produto (ProdutoID, Nome, Quantidade, PrecoVenda)
VALUES ('1', 'Banana', '100', '5.00'),
       ('3', 'Laranja', '500', '2.00'),
	   ('4', 'Manga', '800', '4.00');

	   SELECT * FROM Produto;


	   --INSERÇÃO DOS DADOS DE MOVIMENTO DENOMINANDO S COMO SAÍDA E E COMO ENTRADA
	INSERT INTO Movimento (MovimentoID, UsuarioID, Tipo, PessoaID, ProdutoID, Quantidade, PrecoUnitario)
    VALUES 
    (1, 1, 'S', 7, 1, 20, 4.00),
    (4, 1, 'S', 7, 3, 15, 2.00),
    (5, 2, 'S', 7, 3, 10, 3.00),
    (7, 1, 'E', 15, 3, 15, 5.00),
    (8, 1, 'E', 15, 4, 20, 4.00);

	 SELECT * FROM Movimento;

	 --DADOS COMPLETOS DE PESSOA FÍSICA
	 SELECT 
    p.PessoaID,
    p.Nome,
    p.Logradouro,
    p.Cidade,
    p.Estado,
    p.Telefone,
    p.Email,
    pf.CPF
FROM 
    Pessoa p
JOIN 
    PessoaFisica pf ON p.PessoaID = pf.PessoaID;

	--DADOS COMPLETOS DE PESSOA JURIDICA
	SELECT 
    p.PessoaID,
    p.Nome,
    p.Logradouro,
    p.Cidade,
    p.Estado,
    p.Telefone,
    p.Email,
    pj.CNPJ
FROM 
    Pessoa p
JOIN 
    PessoaJuridica pj ON p.PessoaID = pj.PessoaID;

	-- DADOS COMPLETOS DE PESSOA FÍSICA E JURÍDICA
SELECT 
    p.PessoaID,
    p.Nome,
    p.Logradouro,
    p.Cidade,
    p.Estado,
    p.Telefone,
    p.Email,
    pf.CPF AS Identificador
FROM 
    Pessoa p
JOIN 
    PessoaFisica pf ON p.PessoaID = pf.PessoaID

UNION ALL

SELECT 
    p.PessoaID,
    p.Nome,
    p.Logradouro,
    p.Cidade,
    p.Estado,
    p.Telefone,
    p.Email,
    pj.CNPJ AS Identificador
FROM 
    Pessoa p
JOIN 
    PessoaJuridica pj ON p.PessoaID = pj.PessoaID;

	--MOVIMENTAÇÃO DE ENTRADA COM PRODUTO, FORNECEDOR, QUANTIDADE, PREÇO UNITÁRIO E VALOR TOTAL 
SELECT 
    m.MovimentoID,
    u.UsuarioID,
    pr.Nome AS Produto,
    p.Nome AS Fornecedor,
    m.Quantidade,
    m.PrecoUnitario,
    m.Quantidade * m.PrecoUnitario AS ValorTotal
FROM 
    Movimento m
JOIN 
    Produto pr ON m.ProdutoID = pr.ProdutoID
JOIN 
    Pessoa p ON m.PessoaID = p.PessoaID
JOIN
    Usuario u ON m.UsuarioID = u.UsuarioID
WHERE 
    m.Tipo = 'E'; 

	--MOVIMENTAÇÃO DE SAÍDA COM PRODUTO, COMPRADOR , QUANTIDADE, PREÇO UNITÁRIO E VALOR TOTAL 
	SELECT 
    m.MovimentoID,
    u.UsuarioID,
    pr.Nome AS Produto,
    p.Nome AS Comprador,
    m.Quantidade,
    m.PrecoUnitario,
    m.Quantidade * m.PrecoUnitario AS ValorTotal
FROM 
    Movimento m
JOIN 
    Produto pr ON m.ProdutoID = pr.ProdutoID
JOIN 
    Pessoa p ON m.PessoaID = p.PessoaID
JOIN
    Usuario u ON m.UsuarioID = u.UsuarioID
WHERE 
    m.Tipo = 'S';


	--Valor total das entradas agrupadas por produto
	SELECT 
    pr.Nome AS Produto,
    SUM(m.Quantidade * m.PrecoUnitario) AS ValorTotalEntradas
FROM 
    Movimento m
JOIN 
    Produto pr ON m.ProdutoID = pr.ProdutoID
WHERE 
    m.Tipo = 'E' 
GROUP BY 
    pr.Nome;

	--Valor total das saídas agrupadas por produto
	SELECT 
    pr.Nome AS Produto,
    SUM(m.Quantidade * m.PrecoUnitario) AS ValorTotalSaidas
FROM 
    Movimento m
JOIN 
    Produto pr ON m.ProdutoID = pr.ProdutoID
WHERE 
    m.Tipo = 'S' 
GROUP BY 
    pr.Nome;

	--Operadores que não efetuaram movimentações de entrada (compra).
	SELECT 
    U.UsuarioID,
    U.Login,
    U.Senha
FROM 
    Usuario U
WHERE 
    U.UsuarioID NOT IN (
        SELECT DISTINCT
            M.UsuarioID
        FROM 
            Movimento M
        WHERE 
            M.Tipo = 'E' 
    );

	--Valor total de entrada, agrupado por operador.
	SELECT
    M.UsuarioID,
    U.Login,
    SUM(M.Quantidade * M.PrecoUnitario) AS ValorTotalEntrada
FROM
    Movimento M
JOIN
    Usuario U ON M.UsuarioID = U.UsuarioID
WHERE
    M.Tipo = 'E' 
GROUP BY
    M.UsuarioID,
    U.Login;

	--Valor total de saída, agrupado por operador.
	SELECT
    M.UsuarioID,
    U.Login,
    SUM(M.Quantidade * M.PrecoUnitario) AS ValorTotalSaida
FROM
    Movimento M
JOIN
    Usuario U ON M.UsuarioID = U.UsuarioID
WHERE
    M.Tipo = 'S' 
GROUP BY
    M.UsuarioID,
    U.Login;


	--Valor médio de venda por produto, utilizando média ponderada
	SELECT
    ProdutoID,
    AVG(PrecoUnitario) AS ValorMedioVenda
FROM
    Movimento
WHERE
    Tipo = 'S' 
GROUP BY
    ProdutoID;