WITH CTE_OCORRENCIAS_TABELAS AS (
		SELECT TURMA_DISCIPLINA_ID, QTD = COUNT(1), TABELA = 'academico_turmadisciplinaaluno' FROM academico_turmadisciplinaaluno                                 GROUP BY TURMA_DISCIPLINA_ID UNION 
SELECT TURMA_DISCIPLINA_ID, QTD = COUNT(1), TABELA = 'academico_turmadisciplinaprofessor' FROM academico_turmadisciplinaprofessor						  GROUP BY TURMA_DISCIPLINA_ID UNION 
		SELECT TURMA_DISCIPLINA_ID, QTD = COUNT(1), TABELA = 'academico_grupoaula' FROM academico_grupoaula														  GROUP BY TURMA_DISCIPLINA_ID UNION 
		SELECT TURMA_DISCIPLINA_ID, QTD = COUNT(1), TABELA = 'materiais_didaticos_publicacao_turmadisciplina' FROM materiais_didaticos_publicacao_turmadisciplina GROUP BY TURMA_DISCIPLINA_ID UNION 
		SELECT TURMA_DISCIPLINA_ID, QTD = COUNT(1), TABELA = 'aulas_agendamento' FROM aulas_agendamento															  GROUP BY TURMA_DISCIPLINA_ID UNION 
		SELECT TURMA_DISCIPLINA_ID, QTD = COUNT(1), TABELA = 'atividades_protocolosegundachamadaprova' FROM atividades_protocolosegundachamadaprova				  GROUP BY TURMA_DISCIPLINA_ID UNION 
		SELECT TURMA_DISCIPLINA_ID, QTD = COUNT(1), TABELA = 'atividades_criterio_turmadisciplina' FROM atividades_criterio_turmadisciplina						  GROUP BY TURMA_DISCIPLINA_ID UNION 
		SELECT TURMA_DISCIPLINA_ID, QTD = COUNT(1), TABELA = 'frequencias_excecaofrequenciaforaprazo' FROM frequencias_excecaofrequenciaforaprazo				  GROUP BY TURMA_DISCIPLINA_ID UNION 
		SELECT TURMA_DISCIPLINA_ID, QTD = COUNT(1), TABELA = 'frequencias_protocolofrequenciaforaprazo' FROM frequencias_protocolofrequenciaforaprazo			  GROUP BY TURMA_DISCIPLINA_ID UNION 
		SELECT TURMA_DISCIPLINA_ID, QTD = COUNT(1), TABELA = 'academico_complementacaocargahoraria' FROM academico_complementacaocargahoraria					  GROUP BY TURMA_DISCIPLINA_ID UNION 
		SELECT TURMA_DISCIPLINA_ID, QTD = COUNT(1), TABELA = 'aulas_pendentes' FROM aulas_pendentes																  GROUP BY TURMA_DISCIPLINA_ID UNION 
		SELECT TURMA_DISCIPLINA_ID, QTD = COUNT(1), TABELA = 'frequencias_revisao' FROM frequencias_revisao														  GROUP BY TURMA_DISCIPLINA_ID UNION 
		SELECT TURMA_DISCIPLINA_ID, QTD = COUNT(1), TABELA = 'academico_aula' FROM academico_aula																  GROUP BY TURMA_DISCIPLINA_ID  
)


SELECT * FROM  VW_TURMA_DISCIPLINA_DUPLICADA dup join CTE_OCORRENCIAS_TABELAS cte on (dup.turma_disciplina_id = cte.turma_disciplina_id)
WHERE dup.turma_disciplina_id IN (
11382, 11383, 5111, 10304,5142,12623,9975,9979,10133,10232,10134,10233)
 ORDER BY 3,5

