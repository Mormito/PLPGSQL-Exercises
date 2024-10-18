--O que foi pedido? Função(codigo_fabricante, estado) V | Retorna a data_venda V | Retorna total de vendas no dia X |
--Retorna total de vendas acumulado para cada data com X fabricante no estado indicado

--count?

CREATE TYPE ex1type AS (cod_fabricante CHAR(2), est_revenda CHAR(2), data_venda DATE, data_compra DATE);

CREATE OR REPLACE FUNCTION ex1(cod fabricante.codigo%TYPE, est revenda.estado%TYPE)
RETURNS SETOF ex1type AS 
$$

BEGIN 

RETURN QUERY 
SELECT fabricante.codigo, revenda.estado, venda.data, automovel.compra
FROM fabricante
JOIN automovel ON fabricante.codigo = automovel.fabricante
JOIN venda ON venda.automovel = automovel.codigo
JOIN revenda ON revenda.codigo = venda.revenda;
WHERE fabricante.codigo = cod AND revenda.estado = est;

END;

$$ LANGUAGE plpgsql;

--pode estar incorreto por enquanto, iremos trabalhar nisso.

-- venda e automovel tem datas que se repetem

--base 2

SELECT revenda.estado, venda.data, automovel.compra
FROM fabricante
JOIN automovel ON fabricante.codigo = automovel.fabricante
JOIN venda ON venda.automovel = automovel.codigo
JOIN revenda ON revenda.codigo = venda.revenda;


 


--base
SELECT fabricante.codigo AS cod_fabricante, revenda.estado, venda.data
FROM fabricante
JOIN automovel ON fabricante.codigo = automovel.fabricante
JOIN venda ON venda.automovel = automovel.codigo
JOIN revenda ON revenda.codigo = venda.revenda;

--base count com where
SELECT fabricante.codigo, revenda.estado, venda.data, automovel.compra,
COUNT(*)
FROM fabricante
JOIN automovel ON fabricante.codigo = automovel.fabricante
JOIN venda ON venda.automovel = automovel.codigo
JOIN revenda ON revenda.codigo = venda.revenda
WHERE revenda.estado = 'SP'
GROUP BY fabricante.codigo, revenda.estado, venda.data;



--gambiarra nao usar
SELECT fabricante.codigo AS fabricante, revenda.estado, venda.data, automovel.compra,
COUNT(*)
FROM fabricante
JOIN automovel ON fabricante.codigo = automovel.fabricante
JOIN venda ON venda.automovel = automovel.codigo
JOIN revenda ON revenda.codigo = venda.revenda
WHERE venda.data = '2010-02-05'
GROUP BY fabricante.codigo, revenda.estado, venda.data, automovel.compra;


---- com chat e ainda ta erradokkkkkkkkkkkkk

CREATE TYPE ex1type AS (
    cod_fabricante CHAR(2),
    est_revenda CHAR(2),
    data_venda DATE,
    data_compra DATE,
    vendas_no_dia INTEGER,
    total_acumulado INTEGER
);

CREATE OR REPLACE FUNCTION ex1(cod fabricante.codigo%TYPE, est revenda.estado%TYPE)
RETURNS SETOF ex1type AS 
$$
BEGIN 

RETURN QUERY 
SELECT 
    fabricante.codigo AS cod_fabricante, 
    revenda.estado AS est_revenda, 
    venda.data AS data_venda,
    automovel.compra AS data_compra,
    COUNT(*) AS vendas_no_dia,
    SUM(COUNT(*)) OVER (ORDER BY venda.data ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS total_acumulado
FROM fabricante
JOIN automovel ON fabricante.codigo = automovel.fabricante
JOIN venda ON venda.automovel = automovel.codigo
JOIN revenda ON revenda.codigo = venda.revenda
WHERE fabricante.codigo = cod AND revenda.estado = est
GROUP BY fabricante.codigo, revenda.estado, venda.data, automovel.compra
ORDER BY venda.data;

END;

$$ LANGUAGE plpgsql;

