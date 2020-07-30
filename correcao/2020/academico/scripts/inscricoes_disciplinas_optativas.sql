with cte_optativa_aprovado_curricular as (
			select cra.aluno_id as aluno_id, sum(dsc.carga_horaria) as carga
			  from curriculos_disciplinaconcluida dsc join academico_exigenciamatriculadisciplina exi on (dsc.exigencia_id = exi.id)
															 join curriculos_aluno                cra on (cra.id = dsc.curriculo_aluno_id)
			where exi.id = 1  and --optativa curricular
				  dsc.status_id = 2
				  group by cra.aluno_id
) 

	,	cte_optativa_reprovado_curricular as (
			select cra.aluno_id as aluno_id, sum(dsc.carga_horaria) as carga
			  from curriculos_disciplinaconcluida dsc join academico_exigenciamatriculadisciplina exi on (dsc.exigencia_id = exi.id)
															 join curriculos_aluno                cra on (cra.id = dsc.curriculo_aluno_id)
			where exi.id = 1  and --optativa curricular
				  dsc.status_id in (9,10)
				  group by cra.aluno_id
) 

	,	cte_optativa_aprovado_excurricular as (
			select cra.aluno_id as aluno_id, sum(dsc.carga_horaria) as carga
			  from curriculos_disciplinaconcluida dsc join academico_exigenciamatriculadisciplina exi on (dsc.exigencia_id = exi.id)
															 join curriculos_aluno                cra on (cra.id = dsc.curriculo_aluno_id)
			where exi.id = 4  and --optativa extracurricular
				  dsc.status_id = 2
				  group by cra.aluno_id
) 

	,	cte_optativa_reprovado_excurricular as (
			select cra.aluno_id as aluno_id, sum(dsc.carga_horaria) as carga
			  from curriculos_disciplinaconcluida dsc join academico_exigenciamatriculadisciplina exi on (dsc.exigencia_id = exi.id)
															 join curriculos_aluno                cra on (cra.id = dsc.curriculo_aluno_id)
			where exi.id = 4  and --optativa extracurricular
				  dsc.status_id in (9,10)
				  group by cra.aluno_id
) 





select ido.disciplina, ido.data_termino_inscricao, ido.nome, ido.ra, ido.data_inscricao, ido.media_geral_aluno,  ido.curriculo_nome,
       isnull(oac.carga,0)  as opt_aprov_curricular, 
       isnull(orec.carga,0) as opt_reprov_curricular, 
       isnull(oae.carga,0)  as opt_aprov_extra_curricular, 
       isnull(oree.carga,0) as opt_reprov_extra_curricular 
  from vw_inscricao_disciplina_optativa ido left join cte_optativa_aprovado_curricular     oac  on (ido.aluno_id = oac.aluno_id)
                                            left join cte_optativa_reprovado_curricular    orec on (ido.aluno_id = orec.aluno_id)
                                            left join cte_optativa_aprovado_excurricular   oae on (ido.aluno_id = oae.aluno_id)
                                            left join cte_optativa_reprovado_excurricular  oree on (ido.aluno_id = oree.aluno_id)

order by data_inscricao
--select * from vw_inscricao_disciplina_optativa