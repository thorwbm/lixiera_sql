WITH CTE_DUPLICIDADE_TURMA_DISCIPLINA AS (
		 select turma_nome, disciplina_nome 
			from vw_curso_turma_disciplina
			group by turma_nome, disciplina_nome
			having count(turma_disciplina_id) > 1
)

	,  CTE_TURMADISCIPLINAID AS (
		SELECT TDS.ID AS TURMADISCIPLINA_ID, 
		       TDS.turma_id, TDS.disciplina_id
		  FROM CTE_DUPLICIDADE_TURMA_DISCIPLINA CTE LEFT JOIN ACADEMICO_TURMA      TUR ON (TUR.NOME = CTE.turma_nome)
		                                            LEFT JOIN ACADEMICO_DISCIPLINA DIS ON (DIS.NOME = CTE.disciplina_nome)
													LEFT JOIN ACADEMICO_TURMADISCIPLINA TDS ON (TUR.ID = TDS.turma_id AND 
													                                       DIS.ID = TDS.disciplina_id)
)

		SELECT CTE.*, TDA.aluno_id, TDA.aluno_nome, TDA.turma_nome, TDA.disciplina_nome
		  into tmp_higienizacao_alunos_afetados
		  FROM CTE_TURMADISCIPLINAID CTE LEFT JOIN vw_curso_turma_disciplina_aluno TDA ON (CTE.TURMADISCIPLINA_ID = TDA.turmaDisciplina_id)

      --  DROP TABLE tmp_higienizacao_alunos_afetados

	  SELECT DISTINCT turma_nome FROM tmp_higienizacao_alunos_afetados

	  SELECT NOME
	  FROM ACADEMICO_TURMA
	  GROUP BY NOME HAVING COUNT(1) > 1

	  SELECT * FROM ACADEMICO_TURMA WHERE NOME = 'INTERNATO DE SAÚDE MENTAL- 5MABP03-CICLO 1- RAUL SOARES- C- 08:00-12:00'

	  SELECT * FROM ACADEMICO_TURMADISCIPLINA WHERE ID IN (722,817)


SELECT * FROM VW_TABELA_COLUNA WHERE COLUNA = 'TURMA_ID'

SELECT * FROM materiais_didaticos_publicacao_turma WHERE TURMA_ID IN (722,817)


SELECT DISTINCT * FROM tmp_higienizacao_alunos_afetados WHERE TURMA_NOME IS NULL 