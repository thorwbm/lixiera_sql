 --BEGIN TRAN;
 -- COMMIT
 -- ROLLBACK
WITH CTE_DUPLICIDADE_TURMADISCIPLINA AS (
		SELECT TUR.NOME AS TURMA_NOME, DIS.NOME DISCIPLINA_NOME
		  FROM  ACADEMICO_TURMADISCIPLINA TDS JOIN ACADEMICO_TURMA TUR ON (TUR.ID = TDS.turma_id)
											  JOIN ACADEMICO_DISCIPLINA DIS ON (DIS.ID = TDS.disciplina_id)
		  GROUP BY TUR.NOME, DIS.NOME
		  HAVING COUNT(TDS.ID) > 1
  )

	, CTE_DUPLICIDADE AS (
		SELECT TUR.NOME AS TURMA_NOME , DIS.NOME AS DISCIPLINA_NOME,TDS.turma_id, TDS.disciplina_id, TDS.ID AS TURMADISCIPLINA_ID 
		  FROM CTE_DUPLICIDADE_TURMADISCIPLINA CTE JOIN ACADEMICO_TURMA      TUR ON (TUR.NOME = CTE.TURMA_NOME)
												   JOIN ACADEMICO_DISCIPLINA DIS ON (DIS.NOME = CTE.DISCIPLINA_NOME)
												   JOIN academico_turmadisciplina TDS ON (TUR.ID = TDS.turma_id AND 
																						  DIS.ID = TDS.disciplina_id)
)

select * from CTE_DUPLICIDADE
FROM academico_turmadisciplina tds 
 
	SELECT * FROM (	
		SELECT TURMA_DISCIPLINA_ID, 'academico_turmadisciplinaaluno ' as tabela FROM academico_turmadisciplinaaluno UNION 
		SELECT TURMA_DISCIPLINA_ID, 'academico_turmadisciplinaprofessor' as tabela FROM academico_turmadisciplinaprofessor UNION 
		SELECT TURMA_DISCIPLINA_ID, 'academico_grupoaula' as tabela FROM academico_grupoaula UNION 
		SELECT TURMA_DISCIPLINA_ID, 'materiais_didaticos_publicacao_turmadisciplina' as tabela FROM materiais_didaticos_publicacao_turmadisciplina UNION 
		SELECT TURMA_DISCIPLINA_ID, 'aulas_agendamento' as tabela FROM aulas_agendamento UNION 
		SELECT TURMA_DISCIPLINA_ID, 'atividades_protocolosegundachamadaprova' as tabela FROM atividades_protocolosegundachamadaprova UNION 
		SELECT TURMA_DISCIPLINA_ID, 'atividades_criterio_turmadisciplina' as tabela FROM atividades_criterio_turmadisciplina UNION 
		SELECT TURMA_DISCIPLINA_ID, 'frequencias_excecaofrequenciaforaprazo' as tabela FROM frequencias_excecaofrequenciaforaprazo UNION 
		SELECT TURMA_DISCIPLINA_ID, 'frequencias_protocolofrequenciaforaprazo ' as tabela FROM frequencias_protocolofrequenciaforaprazo UNION 
		SELECT TURMA_DISCIPLINA_ID, 'academico_complementacaocargahoraria ' as tabela FROM academico_complementacaocargahoraria UNION 
		SELECT TURMA_DISCIPLINA_ID, 'aulas_pendentes' as tabela FROM aulas_pendentes UNION 
		SELECT TURMA_DISCIPLINA_ID, 'frequencias_revisao' as tabela FROM frequencias_revisao UNION 
		SELECT TURMA_DISCIPLINA_ID, 'academico_aula' as tabela FROM academico_aula ) AS TAB
		WHERE TURMA_DISCIPLINA_ID IS NOT NULL and 
		       turma_disciplina_id in (11356,11357)
		

		
		exec sp_transportar_turmadisciplina_id 12623,5142