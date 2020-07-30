with cte_aluno_etapa as (
		select tur.id as turma_id, tur.nome as turma, tur.inicio_vigencia, 
			   gra.id as grade_id, gra.nome as grade, 
			   eta.id as etapa_id, eta.nome as etapa_nome, eta.etapa, 
			   tda.aluno_id, tda.turma_disciplina_id 
		  from academico_turmadisciplinaaluno tda with(nolock) join academico_turmadisciplina trd with(nolock) on (trd.id = tda.turma_disciplina_id)
															   join academico_turma           tur with(nolock) on (tur.id = trd.turma_id)
															   join curriculos_grade          gra with(nolock) on (gra.id = tur.grade_id)
													           join academico_etapa           eta with(nolock) on (eta.id = gra.etapa_id)
) 
    select eta.turma, alu.nome, alu.ra, eta.etapa_nome, eta.etapa , nat.etapa_natural, nat.periodo
	
	  from vw_etapa_natural nat join cte_aluno_etapa eta on (nat.aluno_id = eta.aluno_id and 
	                                                         nat.ano = 2019 )
								join academico_aluno alu on (alu.id = eta.aluno_id)
      where eta.etapa < nat.etapa_natural and 
	        cast(eta.inicio_vigencia as date) > '2019-07-14'





