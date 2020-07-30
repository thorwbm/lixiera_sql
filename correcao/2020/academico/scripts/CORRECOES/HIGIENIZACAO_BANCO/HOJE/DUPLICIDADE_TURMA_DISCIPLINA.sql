--CREATE OR ALTER VIEW VW_TURMA_DISCIPLINA_DUPLICADA AS 
WITH CTE_DUPLICIDADE_TURMA_DISCIPLINA AS (
		 select  turma.nome AS TURMA_NOME, disc.nome DISCIPLINA_NOME
		from academico_turmadisciplina    td  join academico_turma           turma on (turma.id = td.turma_id)
		                                      join academico_disciplina      disc  on (disc.id = td.disciplina_id)
		group by  turma.nome, disc.nome
		having count(1) > 1
)
	, CTE_OCORRENCIAS_TABELAS AS (
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
    ,  CTE_POSSUI_ALUNO AS (
			SELECT TURMA_DISCIPLINA_ID, QTD = COUNT(1), TABELA = 'academico_turmadisciplinaaluno' FROM academico_turmadisciplinaaluno                                 GROUP BY TURMA_DISCIPLINA_ID
)
	,  CTE_TURMADISCIPLINA AS (
        SELECT DISTINCT tds.id as turma_disciplina_id,
		       tur.id as turma_id, tur.nome as turma_nome, 
			   dis.id as disciplina_id, dis.nome as disciplina_nome, 
		       disc_pertence_curriculo_ativo = case when cgd.curriculo_id is null then 'NAO' ELSE 'SIM' END,
			   TEM_LANCAMENTO = CASE WHEN OCO.TURMA_DISCIPLINA_ID IS NULL THEN 'NAO' ELSE 'SIM'END, 
			   TEM_ALUNO_LANC = CASE WHEN PAL.TURMA_DISCIPLINA_ID IS NULL THEN 'NAO' ELSE 'SIM'END,
			   CGD.curriculo_nome
		FROM  academico_turmadisciplina tds  join academico_turma                  tur on (tur.id              = tds.turma_id)
		                                     join academico_disciplina             dis on (dis.id              = tds.disciplina_id)
											 join CTE_DUPLICIDADE_TURMA_DISCIPLINA cte on (cte.turma_nome      = tur.nome and 
																						   cte.disciplina_nome = dis.nome)
										left join vw_curriculo_grade_disciplina    cgd on (tur.grade_id        = cgd.grade_id and 
													                                       cgd.disciplina_id   = dis.id)
										LEFT JOIN CTE_OCORRENCIAS_TABELAS OCO ON (TDS.id = OCO.turma_disciplina_id)
										LEFT JOIN CTE_POSSUI_ALUNO        PAL ON (TDS.ID = PAL.turma_disciplina_id)
) 
		select * from CTE_TURMADISCIPLINA TDS 
		order by 3,5