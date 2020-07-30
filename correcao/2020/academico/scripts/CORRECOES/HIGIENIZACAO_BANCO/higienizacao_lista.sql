WITH CTE_DUPLICIDADE_TURMA_DISCIPLINA AS (
		 select aluno.nome, tda.aluno_id, turma.nome AS TURMA_NOME, disc.nome DISCIPLINA_NOME, count(1) AS QTD
		from academico_turmadisciplinaaluno tda Join academico_turmadisciplina    td on (td.id = tda.turma_disciplina_id)
		                                        join academico_turma           turma on (turma.id = td.turma_id)
		                                        join academico_disciplina      disc  on (disc.id = td.disciplina_id)
		                                        join academico_aluno           aluno on (aluno.id = tda.aluno_id)
												--WHERE DISC.NOME = 'INTERNATO DE MEDICINA DE URGÊNCIA'
		group by aluno.nome, tda.aluno_id, turma.nome, disc.nome
		having count(1) > 1
)

	,  CTE_TURMADISCIPLINA AS (
        SELECT tda.turma_disciplina_id, tda.aluno_id, cte.nome, 
		       tur.id as turma_id, tur.nome as turma_nome, 
			   dis.id as disciplina_id, dis.nome as disciplina_nome, 
		       cra.curriculo_id, 
		       disc_pertence_curriculo_ativo = case when cgd.curriculo_id is null then 'NAO' ELSE 'SIM' END
		FROM academico_turmadisciplinaaluno tda Join academico_turmadisciplina                 tds on (tds.id               = tda.turma_disciplina_id)
		                                                 join academico_turma                  tur on (tur.id                = tds.turma_id)
		                                                 join academico_disciplina             dis on (dis.id                = tds.disciplina_id)
														 join curriculos_aluno                 cra on (cra.aluno_id        = tda.aluno_id and 
														                                               cra.status_id       = 13)
														 join CTE_DUPLICIDADE_TURMA_DISCIPLINA cte on (cte.aluno_id        = tda.aluno_id and 
														                                               cte.turma_nome      = tur.nome and 
																									   cte.disciplina_nome = dis.nome)
													left join vw_curriculo_grade_disciplina    cgd on (cgd.curriculo_id    = cra.curriculo_id and 
													                                                   cgd.disciplina_id   = dis.id)
) 
		SELECT  TDA.TURMADISCIPLINA_ID, tda.turma_id, tda.turma_nome, tda.disciplina_id, tda.disciplina_nome, 
		        tda.aluno_id, tda.aluno_nome, tda.curso_id, tda.curso_nome
			--	into tmp_higienizacao_alunos_afetados
		  from vw_curso_turma_disciplina_aluno TDA 
		WHERE EXISTS (SELECT 1 FROM CTE_TURMADISCIPLINA CTE WHERE CTE.turma_disciplina_id = TDA.turmaDisciplina_id) AND 
		      TDA.ALUNO_ID IS NOT NULL AND 
			  TDA.disciplina_nome = 'INTERNATO DE MEDICINA DE URGÊNCIA'