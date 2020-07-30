create view VW_CON_CONTRATO_CURRICULO_CURSO_ALUNO as 
with	cte_rematricula as (
select distinct  student_id collate database_default  as aluno_ra from rem_prd..onboarding_enrollment e
                    join rem_prd..onboarding_onboarding o
                        on e.onboarding_id = o.id
                    join rem_prd..onboarding_termyear t
                        on t.id = o.term_year_id
                    where t.[current] = 1 and status_id = 6
)

			select  cap.curriculo_id,cap.curriculo_nome, cap.curso_id, cap.curso_nome, 
			        cap.aluno_id, cap.aluno_Nome, con.data_matricula, con.vigente, 
					eta.id as etapa_ano_id, eta.ano, eta.periodo,
					cap.curriculo_aluno_status_id, cap.curriculo_aluno_status_nome,
					tpc.id as tipo_contrato_id, tpc.descricao as tipo_contrato_descricao
			  from cte_rematricula rem join vw_Curriculo_aluno_pessoa cap on (cap.aluno_ra = rem.aluno_ra)
			                      left join contratos_contrato        con on (con.aluno_id = cap.aluno_id and
									                                          con.curriculo_id = cap.curriculo_id)
								  left join contratos_tipocontrato    tpc on (tpc.id = con.tipo_id)
								  left join academico_etapaano        eta on (eta.id = con.etapa_ano_id)

order by 2,4,6