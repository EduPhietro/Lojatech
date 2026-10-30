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

SELECT * FROM produtos p  
	WHERE p.estoque  < 20 AND p.preco_unitario  > 200.0;


SELECT * FROM clientes c
	WHERE c.cidade IN ('Belém', 'Santarém');

SELECT * FROM pedidos p 
	WHERE p.status  IN ('ABERTO', 'PAGO');


SELECT * FROM clientes c 
	WHERE  c.telefone  IS NULL;
	
SELECT * FROM produtos p 
	WHERE p.categoria  <> 'Monitores';



SELECT * FROM clientes c
	WHERE c.email  LIKE   '%@email.com';



SELECT *, 
	CASE
		WHEN preco_unitario < 100.00 THEN 'Barato'
		WHEN preco_unitario >100.00 AND p.preco_unitario < 500.00 THEN 'Médio'
		WHEN preco_unitario > 500 THEN 'Caro'
	END AS classificacao_preco
FROM produtos p;





UPDATE   produtos 
	SET 
		preco_unitario = 95.00
	WHERE id_produto = 2;


UPDATE   produtos 
	SET 
		preco_unitario = preco_unitario * 1.1
	WHERE categoria = 'Periférico'
	RETURNING *;


UPDATE   produtos 
	SET 
		estoque = estoque - 5
	WHERE id_produto  = 3
	RETURNING *;


UPDATE pedidos 	
	SET
		status = 'PAGO'
	WHERE id_pedido = 2
	RETURNING *;


UPDATE clientes
	SET cidade  = 'Ananideua'
	WHERE nome  = 'Diego Alves'
	RETURNING *;

DELETE  FROM itens_pedido  
	WHERE id_produto  IN (
		SELECT p.id_produto  FROM produtos p 
		WHERE p.nome_produto = 'SSD 1 TB'
);

DELETE  FROM pedidos   
	WHERE status  = 'CANCELADO';

DELETE FROM clientes
WHERE id_cliente = 2
  AND (
      SELECT COUNT(*)
      FROM pedidos p 
      WHERE p.id_cliente = clientes.id_cliente
  ) = 0;

SELECT 
    p.id_pedido, 
    p.data_pedido, 
    c.nome
FROM pedidos p 
LEFT JOIN clientes c 
    ON p.id_cliente = c.id_cliente;

WITH total_por_produto AS (
    SELECT
        id_produto, 
        SUM(quantidade) AS quantidade_total
    FROM itens_pedido ip 
    GROUP BY id_produto 
)
SELECT 
    p.nome_produto,
    p.preco_unitario,
    COALESCE(tpp.quantidade_total, 0) AS quantidade_vendida_total
FROM produtos p  
LEFT JOIN total_por_produto tpp 
    ON p.id_produto = tpp.id_produto;

SELECT 
    c.nome,
    prod.nome_produto
FROM itens_pedido ip
LEFT JOIN pedidos p 
    ON p.id_pedido = ip.id_pedido
LEFT JOIN clientes c 
    ON p.id_cliente = c.id_cliente
LEFT JOIN produtos prod 
    ON ip.id_produto = prod.id_produto
WHERE c.nome = 'Ana Souza';

WITH valor_total AS (
    SELECT
        ip.id_pedido,
        SUM(p.preco_unitario * ip.quantidade) AS valor_total
    FROM itens_pedido ip 
    LEFT JOIN produtos p 
        ON ip.id_produto = p.id_produto 
    GROUP BY ip.id_pedido
)
SELECT 
    c.nome,
    p.id_pedido,
    COALESCE(tv.valor_total, 0) AS valor_total  
FROM pedidos p 
LEFT JOIN valor_total tv 
    ON p.id_pedido = tv.id_pedido
LEFT JOIN clientes c 
    ON p.id_cliente = c.id_cliente;

WITH produtos_distintos AS (
    SELECT DISTINCT 
        ip.id_produto 
    FROM itens_pedido ip
)
SELECT  
    p.id_produto,
    p.nome_produto
FROM produtos p
LEFT JOIN produtos_distintos pd 
    ON pd.id_produto = p.id_produto 
WHERE pd.id_produto IS NULL;

SELECT 
    c.nome,
    p.id_pedido,
    prod.nome_produto,
    COALESCE(prod.preco_unitario * ip.quantidade, 0) AS valor_total  
FROM itens_pedido ip
LEFT JOIN pedidos p 
    ON ip.id_pedido = p.id_pedido
LEFT JOIN clientes c 
    ON p.id_cliente = c.id_cliente
LEFT JOIN produtos prod 
    ON ip.id_produto = prod.id_produto;


SELECT * FROM pedidos ped 
    WHERE ped.id_pedido  IN (
        SELECT ip.id_pedido  FROM itens_pedido ip 
            INNER JOIN pedidos p ON ip.id_pedido  = p.id_pedido 
            INNER  JOIN produtos prod ON ip.id_produto  = prod.id_produto 
            
            
        WHERE prod.categoria  ='Armazenamento'
    );

SELECT COUNT(*) AS quantidade_clientes FROM clientes;

SELECT COUNT(*) AS produtos_cadastrados FROM produtos p;


SELECT AVG(preco_unitario) AS preco_medio FROM produtos p;


SELECT MIN(preco_unitario) AS preco_barato FROM produtos p;

SELECT MAX(preco_unitario) AS preco_caro FROM produtos p;

SELECT SUM(estoque) AS soma_estoque FROM produtos p;


SELECT
    p.id_produto,
    p.nome_produto,
    ip.id_item,
    ip.preco_unitario,
    ip.quantidade,
    (ip.preco_unitario * ip.quantidade) AS total_pago
FROM itens_pedido ip

INNER JOIN produtos p ON ip.id_produto = p.id_produto;

SELECT c.id_cliente, c.nome, COUNT(p) AS total_pedidos FROM pedidos p
LEFT JOIN clientes c ON p.id_cliente = c.id_cliente
GROUP BY  c.id_cliente
ORDER BY id_cliente;

SELECT p.categoria, COUNT(p) AS qtd_produtos FROM produtos p

GROUP BY p.categoria;

SELECT c.id_cliente,
       c.nome,
       ip.id_pedido,
       AVG(COALESCE(ip.preco_unitario,0.0)) AS valor_medio
FROM itens_pedido ip

         LEFT JOIN
     pedidos p ON p.id_pedido = ip.id_pedido
        JOIN clientes  c ON p.id_cliente = c.id_cliente

GROUP BY
    ip.id_pedido, c.id_cliente, c.nome;

SELECT COUNT(p) AS quantidade_pago FROM pedidos p
WHERE
    p.status = 'PAGO';


SELECT MAX(p.preco_unitario) AS preco_max,
       MIN(p.preco_unitario) AS preco_min,
       AVG(p.preco_unitario) AS preco_medio
FROM produtos p;
