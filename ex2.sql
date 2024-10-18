CREATE TYPE rec_cod AS (dir_codigo char(3), dir_descricao char(10), sec_codigo char(3), fun_descricao char(10), media numeric(7,2));

CREATE OR REPLACE FUNCTION recebe_codigo_diretoria(cod diretoria.codigo%TYPE)
RETURNS SETOF rec_cod AS $$

BEGIN

RETURN QUERY SELECT diretoria.codigo, diretoria.descricao, secao.codigo, funcao.descricao, cast(avg(funcionario.salario) AS numeric(7,2)) AS media_salarial
FROM diretoria
JOIN secao ON diretoria.codigo = secao.diretoria
JOIN funcionario ON secao.codigo = funcionario.secao
JOIN funcao ON funcionario.funcao = funcao.funcao WHERE diretoria.codigo = cod
GROUP BY diretoria.codigo, diretoria.descricao, secao.codigo, funcao.descricao, funcionario.nome;

IF NOT FOUND THEN 
RAISE NOTICE 'Nenhum Funcionario Nesta Diretoria';
END IF;

END;
$$ LANGUAGE plpgsql;
