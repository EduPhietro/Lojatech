CREATE TABLE IF NOT EXISTS clientes (
	id_cliente INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	nome VARCHAR(100) NOT NULL,
	email VARCHAR(150) NOT NULL UNIQUE,
	telefone VARCHAR(20) NULL,
	data_nascimento DATE NULL,
	cidade VARCHAR(80) NULL, -- Coluna adicionada para o INSERT funcionar
	data_cadastro TIMESTAMP NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS produtos (
	id_produto INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	nome_produto VARCHAR(100) NOT NULL,
	categoria VARCHAR(50) NOT NULL,
	preco_unitario NUMERIC(10,2) NOT NULL CHECK (preco_unitario > 0),
	estoque INT NOT NULL DEFAULT 0 CHECK (estoque >= 0),
	descricao TEXT NULL,
	ativo BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE IF NOT EXISTS pedidos (
	id_pedido INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	id_cliente INT NOT NULL,
	data_pedido TIMESTAMP NOT NULL DEFAULT now(),
	status VARCHAR(20) NOT NULL DEFAULT 'ABERTO' CHECK (status IN ('PAGO','ABERTO','CANCELADO')),
	valor_total NUMERIC(10,2) NOT NULL DEFAULT 0 CHECK (valor_total >=0),
	
	CONSTRAINT pedidos_clientes_fk 
	FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente)
		ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS itens_pedido (
	id_item INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	id_pedido INT NOT NULL,
	id_produto INT NOT NULL,
	quantidade INT NOT NULL CHECK (quantidade > 0),

	CONSTRAINT item_pedido_fk 
	FOREIGN KEY (id_pedido) REFERENCES pedidos(id_pedido) 
		ON DELETE CASCADE,
	
	CONSTRAINT item_produto_fk 
	FOREIGN KEY (id_produto) REFERENCES produtos(id_produto)
		ON DELETE CASCADE
);

-- INSERT Corrigido
INSERT INTO clientes (nome, email, cidade) 
VALUES 
	('Ana Souza', 'ana@gmail.com', 'Belém'),
	('Bruno Lima', 'bruno@gmail.com','Santarém'),
	('Carla Mendes', 'carla@gmail.com','Belém'),
	('Diego Alves', 'diego@gmail.com','Marabá');

/*
DROP TABLE clientes CASCADE;
DROP TABLE produtos CASCADE;
DROP TABLE pedidos CASCADE;
DROP TABLE itens_pedido CASCADE;
*/
