with	cte_rematricula as (
select distinct  student_id collate database_default  as aluno_ra from rem_prd..onboarding_enrollment e
                    join rem_prd..onboarding_onboarding o
                        on e.onboarding_id = o.id
                    join rem_prd..onboarding_termyear t
                        on t.id = o.term_year_id
                    where t.[current] = 1 and status_id = 6
)

--select * from cte_rematricula
	   select distinct tda.aluno_id -- tda.status_matricula_disciplina_id,* 
	 --  update tda set tda.status_matricula_disciplina_id = 14
	   from academico_turmadisciplinaaluno tda  
				          join tmp_carga_turmadisciplinaaluno_enturmacao_thor tho on (tho.id = tda.id)
					 left join vw_Curriculo_aluno_pessoa cra on (cra.curriculo_aluno_id = tda.curriculo_aluno_id and 
					                                             cra.curriculo_aluno_status_id = 13)
					 left join cte_rematricula           cte on (cte.aluno_ra = cra.aluno_ra)
	  where cte.aluno_ra is null and
	        tda.criado_por = 11717 and 
			tda.status_matricula_disciplina_id = 1