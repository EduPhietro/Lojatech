-- ========================================================
-- ATIVIDADE PRÁTICA (FIXAÇÃO): LOJATECH
-- Blocos 1 e 2 são teóricos e estão respondidos em atividade.txt.
-- ========================================================


-- ========================================================
-- BLOCO 3. CRIAÇÃO DO BANCO DE DADOS E TABELAS
-- ========================================================

-- 8. Crie o banco de dados chamado lojatech.
CREATE DATABASE lojatech;

-- 9. Crie a tabela clientes com os seguintes campos:
CREATE TABLE IF NOT EXISTS clientes (
	id_cliente INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	nome VARCHAR(100) NOT NULL,
	email VARCHAR(150) NOT NULL UNIQUE,
	telefone VARCHAR(20) NULL,
	data_nascimento DATE NULL,
	cidade VARCHAR(80) NULL,
	data_cadastro TIMESTAMP NOT NULL DEFAULT now()
);

-- 10. Crie a tabela produtos com os seguintes campos:
CREATE TABLE IF NOT EXISTS produtos (
	id_produto INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	nome_produto VARCHAR(100) NOT NULL,
	categoria VARCHAR(50) NOT NULL,
	preco_unitario DECIMAL(10,2) NOT NULL CHECK (preco_unitario > 0),
	estoque INT NOT NULL DEFAULT 0 CHECK (estoque >= 0),
	descricao TEXT NULL,
	ativo BOOLEAN NOT NULL DEFAULT TRUE
);

-- 11. Crie a tabela pedidos com os seguintes campos:
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

-- 12. Crie a tabela itens_pedido com os seguintes campos:
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
-- BLOCO 4. INSERÇÃO DE DADOS
-- ========================================================

-- 15. Insira os seguintes clientes na tabela clientes:
INSERT INTO clientes (nome, email, cidade)
VALUES
	('Ana Souza', 'ana@email.com', 'Belém'),
	('Bruno Lima', 'bruno@email.com', 'Santarém'),
	('Carla Mendes', 'carla@email.com', 'Belém'),
	('Diego Alves', 'diego@email.com', 'Marabá');

-- 16. Insira os seguintes produtos na tabela produtos:
INSERT INTO produtos (nome_produto, categoria, preco_unitario, estoque)
VALUES
	('Teclado Mecânico', 'Periféricos', 250.00, 30),
	('Mouse Sem Fio', 'Periféricos', 90.00, 50),
	('Monitor 24"', 'Monitores', 850.00, 15),
	('Headset Gamer', 'Audio', 320.00, 25),
	('SSD 1 TB', 'Armazenamento', 480.00, 40);

-- 17. Insira três pedidos na tabela pedidos:
INSERT INTO pedidos (id_cliente, status)
VALUES
	(1, 'PAGO'),
	(2, 'ABERTO'),
	(3, 'PAGO');

-- 18. Insira os itens de pedido na tabela itens_pedido:
INSERT INTO itens_pedido (id_pedido, id_produto, quantidade, preco_unitario)
VALUES
	(1, 1, 2, 250.00), -- Pedido 1: 2 Teclados Mecânicos
	(1, 2, 1, 90.00),  -- Pedido 1: 1 Mouse Sem Fio
	(2, 3, 1, 850.00), -- Pedido 2: 1 Monitor 24"
	(2, 4, 2, 320.00), -- Pedido 2: 2 Headsets Gamer
	(3, 5, 3, 480.00); -- Pedido 3: 3 SSDs de 1 TB


-- ========================================================
-- BLOCO 5. CONSULTAS COM SELECT
-- ========================================================

-- 21. Retorne todos os dados de todos os clientes.
SELECT * FROM clientes;

-- 22. Retorne apenas o nome, o e-mail e a cidade dos clientes.
SELECT nome, email, cidade FROM clientes;

-- 23. Retorne todos os produtos da categoria Periféricos.
SELECT * FROM produtos p
	WHERE p.categoria    = 'Periférico';

-- 24. Retorne os produtos com preço maior que R$ 300,00.
SELECT * FROM produtos p
	WHERE p.preco_unitario   > 300.00;

-- 25. Retorne os produtos com estoque menor que 20 unidades.
SELECT * FROM produtos p
	WHERE p.estoque    < 20;

-- 26. Retorne os clientes da cidade de Belém, ordenados alfabeticamente pelo nome.
SELECT * FROM clientes c
	WHERE c.cidade = 'Belém'
	ORDER BY c.nome ASC;

-- 27. Retorne os produtos ordenados do mais caro para o mais barato.
-- Consulta não incluída no script (veja atividade.txt).

-- 28. Retorne os três produtos mais caros.
SELECT * FROM produtos p
	ORDER BY p.preco_unitario DESC
	LIMIT  3;

-- 29. Retorne os produtos cujo nome contenha a palavra Mouse.
SELECT * FROM produtos p
	WHERE p.nome_produto  LIKE '%Mouse%';

-- 30. Retorne os clientes cujo nome comece com a letra A.
SELECT * FROM clientes c
	WHERE	c.nome     LIKE 'A%';

-- 31. Retorne os produtos das categorias Periféricos ou Áudio.
SELECT * FROM produtos p
	WHERE p.categoria    = 'Periférico'
	OR p.categoria  = 'Áudio';

-- 32. Retorne os produtos cujo preço esteja entre R$ 100,00 e R$ 500,00.
SELECT * FROM produtos p
	WHERE  p.preco_unitario  BETWEEN  100.00 AND 500.00;


-- ========================================================
-- BLOCO 6. CONSULTAS CONDICIONAIS
-- ========================================================

-- 33. Retorne os produtos com estoque menor que 20 unidades e preço maior que R$ 200,00.
SELECT * FROM produtos p
	WHERE p.estoque  < 20 AND p.preco_unitario  > 200.0;

-- 34. Retorne os clientes das cidades de Belém ou Santarém.
SELECT * FROM clientes c
	WHERE c.cidade IN ('Belém', 'Santarém');

-- 35. Retorne os pedidos com status ABERTO ou PAGO.
SELECT * FROM pedidos p
	WHERE p.status  IN ('ABERTO', 'PAGO');

-- 36. Retorne os produtos que não pertencem à categoria Monitores.
SELECT * FROM produtos p
	WHERE p.categoria  <> 'Monitores';

-- 37. Retorne os clientes que não possuem telefone cadastrado.
SELECT * FROM clientes c
	WHERE  c.telefone  IS NULL;

-- 38. Retorne os produtos com preço maior que R$ 300,00 e estoque maior que 20 unidades.
-- Consulta não incluída no script (veja atividade.txt).

-- 39. Escreva uma consulta que classifique os produtos como CARO, quando o preço for maior que R$ 500,00; MÉDIO, quando estiver entre R$ 100,00 e R$ 500,00; e BARATO, quando for menor que R$ 100,00.
SELECT *,
	CASE
		WHEN preco_unitario < 100.00 THEN 'Barato'
		WHEN preco_unitario >100.00 AND p.preco_unitario < 500.00 THEN 'Médio'
		WHEN preco_unitario > 500 THEN 'Caro'
	END AS classificacao_preco
FROM produtos p;

-- 40. Retorne os clientes cujo e-mail termine com @email.com.
SELECT * FROM clientes c
	WHERE c.email  LIKE   '%@email.com';


-- ========================================================
-- BLOCO 7. ATUALIZAÇÃO E EXCLUSÃO DE DADOS
-- ========================================================

-- 41. Atualize o preço do produto Mouse Sem Fio para R$ 95,00.
UPDATE   produtos
	SET
		preco_unitario = 95.00
	WHERE id_produto = 2;

-- 42. Aumente em 10% o preço de todos os produtos da categoria Periféricos.
UPDATE   produtos
	SET
		preco_unitario = preco_unitario * 1.1
	WHERE categoria = 'Periférico'
	RETURNING *;

-- 43. Reduza em 5 unidades o estoque do produto Monitor 24".
UPDATE   produtos
	SET
		estoque = estoque - 5
	WHERE id_produto  = 3
	RETURNING *;

-- 44. Atualize o status do pedido 2 para PAGO.
UPDATE pedidos
	SET
		status = 'PAGO'
	WHERE id_pedido = 2
	RETURNING *;

-- 45. Atualize a cidade do cliente Diego Alves para Ananindeua.
UPDATE clientes
	SET cidade  = 'Ananideua'
	WHERE nome  = 'Diego Alves'
	RETURNING *;

-- 46. Exclua o item do pedido 3 referente ao produto SSD 1 TB.
DELETE  FROM itens_pedido
	WHERE id_produto  IN (
		SELECT p.id_produto  FROM produtos p
		WHERE p.nome_produto = 'SSD 1 TB'
);

-- 47. Exclua todos os pedidos com status CANCELADO.
DELETE  FROM pedidos
	WHERE status  = 'CANCELADO';

-- 48. Exclua o cliente de id_cliente = 4, desde que ele não possua pedidos.
DELETE FROM clientes
WHERE id_cliente = 2
  AND (
      SELECT COUNT(*)
      FROM pedidos p
      WHERE p.id_cliente = clientes.id_cliente
  ) = 0;


-- ========================================================
-- BLOCO 8. CONSULTAS ENVOLVENDO DUAS OU MAIS TABELAS
-- ========================================================

-- 51. Retorne o nome do cliente, o número do pedido e a data de cada pedido.
SELECT
    p.id_pedido,
    p.data_pedido,
    c.nome
FROM pedidos p
LEFT JOIN clientes c
    ON p.id_cliente = c.id_cliente;

-- 52. Retorne o nome do produto, a quantidade vendida e o preço unitário de todos os itens de pedidos.
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

-- 53. Retorne o nome do cliente e o nome dos produtos comprados por ele.
-- Consulta não incluída no script (veja atividade.txt).

-- 54. Retorne apenas os pedidos realizados pela cliente Ana Souza.
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

-- 55. Retorne o nome do cliente, o número do pedido e o valor total dos pedidos com status PAGO.
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

-- 56. Retorne os produtos que nunca foram incluídos em nenhum pedido. Utilize LEFT JOIN e filtre os registros sem correspondência.
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

-- 57. Retorne o nome do cliente, o nome do produto e o valor total do item, calculado pela fórmula: valor_item = quantidade * preco_unitario.
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

-- 58. Retorne os pedidos que contêm pelo menos um produto da categoria Armazenamento.
SELECT * FROM pedidos ped
    WHERE ped.id_pedido  IN (
        SELECT ip.id_pedido  FROM itens_pedido ip
            INNER JOIN pedidos p ON ip.id_pedido  = p.id_pedido
            INNER  JOIN produtos prod ON ip.id_produto  = prod.id_produto
        WHERE prod.categoria  ='Armazenamento'
    );


-- ========================================================
-- BLOCO 9. FUNÇÕES DE AGREGAÇÃO
-- ========================================================

-- 60. Retorne a quantidade total de clientes cadastrados.
SELECT COUNT(*) AS quantidade_clientes FROM clientes;

-- 61. Retorne a quantidade total de produtos cadastrados.
SELECT COUNT(*) AS produtos_cadastrados FROM produtos p;

-- 62. Retorne o preço médio dos produtos.
SELECT AVG(preco_unitario) AS preco_medio FROM produtos p;

-- 63. Retorne o preço do produto mais barato.
SELECT MIN(preco_unitario) AS preco_barato FROM produtos p;

-- 64. Retorne o preço do produto mais caro.
SELECT MAX(preco_unitario) AS preco_caro FROM produtos p;

-- 65. Retorne a soma total das unidades em estoque.
SELECT SUM(estoque) AS soma_estoque FROM produtos p;

-- 66. Retorne o valor total de todos os itens vendidos, considerando quantidade * preco_unitario.
SELECT
    p.id_produto,
    p.nome_produto,
    ip.id_item,
    ip.preco_unitario,
    ip.quantidade,
    SUM(ip.preco_unitario * ip.quantidade) AS total_pago
FROM itens_pedido ip
         INNER JOIN produtos p ON ip.id_produto = p.id_produto
GROUP BY  p.id_produto, p.nome_produto,ip.id_item, ip.preco_unitario, ip.quantidade;

-- 67. Retorne a quantidade de pedidos realizados por cada cliente.
SELECT c.id_cliente, c.nome, COUNT(p) AS total_pedidos FROM pedidos p
LEFT JOIN clientes c ON p.id_cliente = c.id_cliente
GROUP BY  c.id_cliente
ORDER BY id_cliente;

-- 68. Retorne a quantidade de produtos por categoria.
SELECT p.categoria, COUNT(p) AS qtd_produtos FROM produtos p
GROUP BY p.categoria;

-- 69. Retorne o valor médio dos itens por pedido.
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

-- 70. Retorne a quantidade de pedidos com status PAGO.
SELECT COUNT(p) AS quantidade_pago FROM pedidos p
WHERE
    p.status = 'PAGO';

-- 71. Retorne o valor máximo, o valor mínimo e o preço médio dos produtos.
SELECT MAX(p.preco_unitario) AS preco_max,
       MIN(p.preco_unitario) AS preco_min,
       AVG(p.preco_unitario) AS preco_medio
FROM produtos p;
