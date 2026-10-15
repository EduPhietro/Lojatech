-- ========================================================
-- ATIVIDADE PRÁTICA: LOJATECH
-- ========================================================

-- 3. CRIAÇÃO DO BANCO DE DADOS E TABELAS
CREATE DATABASE lojatech;

-- Tabela de Clientes
CREATE TABLE IF NOT EXISTS clientes ( 
	id_cliente INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	nome VARCHAR(100) NOT NULL,
	email VARCHAR(150) NOT NULL UNIQUE,
	telefone VARCHAR(20) NULL,
	data_nascimento DATE NULL,
	cidade VARCHAR(80) NULL,
	data_cadastro TIMESTAMP NOT NULL DEFAULT now()
);

-- Tabela de Produtos
CREATE TABLE IF NOT EXISTS produtos (
	id_produto INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	nome_produto VARCHAR(100) NOT NULL,
	categoria VARCHAR(50) NOT NULL,
	preco_unitario DECIMAL(10,2) NOT NULL CHECK (preco_unitario > 0),
	estoque INT NOT NULL DEFAULT 0 CHECK (estoque >= 0),
	descricao TEXT NULL,
	ativo BOOLEAN NOT NULL DEFAULT TRUE
);

-- Tabela de Pedidos
CREATE TABLE IF NOT EXISTS pedidos (
	id_pedido INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	id_cliente INT NOT NULL,
	data_pedido TIMESTAMP NOT NULL DEFAULT now(),
	status VARCHAR(20) NOT NULL DEFAULT 'ABERTO' CHECK (status IN ('PAGO','ABERTO','CANCELADO')),
	valor_total DECIMAL(10,2) NOT NULL DEFAULT 0 CHECK (valor_total >=0),
	
	CONSTRAINT pedidos_clientes_fk 
	FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente)
		ON DELETE CASCADE
);

-- Tabela de Itens do Pedido
CREATE TABLE IF NOT EXISTS itens_pedido (
	id_item INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	id_pedido INT NOT NULL,
	id_produto INT NOT NULL,
	quantidade INT NOT NULL CHECK (quantidade > 0),
	preco_unitario DECIMAL(10,2) NOT NULL CHECK (preco_unitario > 0),

	CONSTRAINT item_pedido_fk 
	FOREIGN KEY (id_pedido) REFERENCES pedidos(id_pedido) 
		ON DELETE CASCADE,
	
	CONSTRAINT item_produto_fk 
	FOREIGN KEY (id_produto) REFERENCES produtos(id_produto)
		ON DELETE CASCADE
);

-- ========================================================
-- 4. INSERÇÃO DE DADOS
-- ========================================================

-- Inserindo Clientes
INSERT INTO clientes (nome, email, cidade) 
VALUES 
	('Ana Souza', 'ana@email.com', 'Belém'),
	('Bruno Lima', 'bruno@email.com', 'Santarém'),
	('Carla Mendes', 'carla@email.com', 'Belém'),
	('Diego Alves', 'diego@email.com', 'Marabá');

-- Inserindo Produtos
INSERT INTO produtos (nome_produto, categoria, preco_unitario, estoque)
VALUES 
	('Teclado Mecânico', 'Periféricos', 250.00, 30),
	('Mouse Sem Fio', 'Periféricos', 90.00, 50),
	('Monitor 24"', 'Monitores', 850.00, 15),
	('Headset Gamer', 'Audio', 320.00, 25),
	('SSD 1 TB', 'Armazenamento', 480.00, 40);

-- Inserindo Pedidos
INSERT INTO pedidos (id_cliente, status)
VALUES 
	(1, 'PAGO'),
	(2, 'ABERTO'),
	(3, 'PAGO');

-- Inserindo Itens dos Pedidos
INSERT INTO itens_pedido (id_pedido, id_produto, quantidade, preco_unitario)
VALUES 
	(1, 1, 2, 250.00), -- Pedido 1: 2 Teclados Mecânicos
	(1, 2, 1, 90.00),  -- Pedido 1: 1 Mouse Sem Fio
	(2, 3, 1, 850.00), -- Pedido 2: 1 Monitor 24"
	(2, 4, 2, 320.00), -- Pedido 2: 2 Headsets Gamer
	(3, 5, 3, 480.00); -- Pedido 3: 3 SSDs de 1 TB

-- CONSULTAS COM DQL (Data Query Language)
-- 21) Retorne todos os dados de todos os clientes

SELECT * FROM clientes;

SELECT nome, email, cidade FROM clientes;

SELECT * FROM produtos p 
	WHERE p.categoria    = 'Periférico';


SELECT * FROM produtos p 
	WHERE p.preco_unitario   > 300.00;


SELECT * FROM produtos p 
	WHERE p.estoque    < 20;

SELECT * FROM clientes c
	WHERE c.cidade = 'Belém'
	ORDER BY c.nome ASC;

SELECT * FROM produtos p
	ORDER BY p.preco_unitario DESC
	LIMIT  3;

SELECT * FROM produtos p 
	WHERE p.nome_produto  LIKE '%Mouse%';



SELECT * FROM clientes c   
	WHERE	c.nome     LIKE 'A%'; 
		

SELECT * FROM produtos p 
	WHERE p.categoria    = 'Periférico' 
	OR p.categoria  = 'Áudio';

SELECT * FROM produtos p 
	WHERE  p.preco_unitario  BETWEEN  100.00 AND 500.00;
