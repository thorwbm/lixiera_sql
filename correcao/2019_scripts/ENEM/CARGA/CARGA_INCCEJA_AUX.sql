select DISTINCT NO_INSCRITO,
'INSERT INTO inep_inscricao (nome, co_inscricao, cpf, uf_prova) VALUES ('+ char(39) + NO_INSCRITO + char(39) + ', ' + char(39) + CO_INSCRICAO + char(39) + ', ' + char(39) + NU_CPF + char(39) + ', ' + char(39) + SG_UF_PROVA + char(39) + ')  GO '  from inep_n02

ORDER BY NO_INSCRITO