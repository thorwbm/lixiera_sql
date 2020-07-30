CREATE OR ALTER VIEW VW_PRO_TURMA_DISCIPLINA_QUANTIDADE_DISPONIVEL_VAGA AS 
select tds.id as turmadisciplina_id, tds.turma_id, tds.disciplina_id,
       ISNULL(tds.maximo_vagas,0) - COUNT(tda.id) AS VAGA_DISPONIVEL
  from academico_turmadisciplina tds left join academico_turmadisciplinaaluno tda on (tds.id = tda.turma_disciplina_id)
  group by tds.id, tds.maximo_vagas, tds.turma_id, tds.disciplina_id