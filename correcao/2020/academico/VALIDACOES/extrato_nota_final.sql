--select * from vw_acd_extrato_notas
--create or alter view vw_acd_extrato_notas as 
with cte_notas as ( -- 13503
select curso.nome as curso, cur.nome as curriculo, aluno.nome as aluno, disc.nome as disciplina, etapa.nome as etapa_atual_aluno, 
status.nome as StatusCurricular, statusdisc.nome as SituacaoDisciplina, round(sum(ativalu.nota),0) as nota,
ca.id as curriculo_aluno_id, disc.id as disciplina_id, grade.id as grade_id, cur.id as curriculo_id,
gequ.curriculo_id as curriculo_id_equ,
turma.id as turma_id, tda.id as turma_disciplina_aluno_id, td.id as turma_disciplina_id

from curriculos_aluno                    ca
join curriculos_curriculo                cur        on (cur.id = ca.curriculo_id)
join academico_curso                     curso      on (curso.id = cur.curso_id)
join academico_aluno                     aluno      on (aluno.id = ca.aluno_id)
join academico_turmadisciplinaaluno      tda        on (tda.curriculo_aluno_id = ca.id and tda.aluno_id = ca.aluno_id)
join academico_turmadisciplina           td         on (td.id = tda.turma_disciplina_id)
join academico_turma                     turma      on (turma.id = td.turma_id)
join academico_disciplina                disc       on (disc.id = td.disciplina_id)
join atividades_criterio_turmadisciplina actd       on (actd.turma_disciplina_id = td.id)
join atividades_criterio                 crit       on (crit.id = actd.criterio_id)
join atividades_atividade                ativ       on (ativ.criterio_turma_disciplina_id = actd.id)
join atividades_atividade_aluno          ativalu    on (ativalu.atividade_id = ativ.id and ativalu.aluno_id = aluno.id)
join curriculos_grade                    grade      on (grade.id = ca.grade_id)
join academico_etapa                     etapa      on (etapa.id = grade.etapa_id)
join curriculos_statusaluno              status     on (status.id = ca.status_id)
join academico_statusmatriculadisciplina statusdisc on (statusdisc.id = tda.status_matricula_disciplina_id)
join curriculos_grade                    gequ       on (gequ.id = turma.grade_id)

where year(turma.inicio_vigencia) = 2020
  and month(turma.inicio_vigencia) < 6
  and ca.status_id = 13 and ativ.recuperacao = 0
group by curso.nome, cur.nome, aluno.nome, disc.nome, etapa.nome, status.nome, statusdisc.nome,ca.id, disc.id,
         grade.id, cur.id, gequ.curriculo_id, turma.id, tda.id, td.id 

)
,
cte_recuperacao as (
select round(ativalu.nota,0) as nota_recuperacao,
       case when round(ativalu.nota,0) >= 60 then 60 else round(ativalu.nota,0) end as nota_final_recuperacao,
       ca.id as curriculo_aluno_id, disc.id as disciplina_id, gequ.curriculo_id as curriculo_id_equ
  from curriculos_aluno ca
                           join curriculos_curriculo                cur        on cur.id = ca.curriculo_id
                           join academico_curso                     curso      on curso.id = cur.curso_id
                           join academico_aluno                     aluno      on aluno.id = ca.aluno_id
                           join academico_turmadisciplinaaluno      tda        on tda.curriculo_aluno_id = ca.id and tda.aluno_id = ca.aluno_id
                           join academico_turmadisciplina           td         on td.id = tda.turma_disciplina_id
                           join academico_turma                     turma      on turma.id = td.turma_id
                           join academico_disciplina                disc       on disc.id = td.disciplina_id
                           join atividades_criterio_turmadisciplina actd       on actd.turma_disciplina_id = td.id
                           join atividades_criterio                 crit       on crit.id = actd.criterio_id
                           join atividades_atividade                ativ       on ativ.criterio_turma_disciplina_id = actd.id
                           join atividades_atividade_aluno          ativalu    on ativalu.atividade_id = ativ.id and ativalu.aluno_id = aluno.id
                           join curriculos_grade                    grade      on grade.id = ca.grade_id
                           join academico_etapa                     etapa      on etapa.id = grade.etapa_id
                           join curriculos_statusaluno              status     on status.id = ca.status_id
                           join academico_statusmatriculadisciplina statusdisc on statusdisc.id = tda.status_matricula_disciplina_id
                           join curriculos_grade                    gequ       on gequ.id = turma.grade_id
where year(turma.inicio_vigencia) = 2020
  and month(turma.inicio_vigencia) < 6
  and ativ.recuperacao = 1
) 


select curso_nome, curriculo_nome, aluno, disciplina, SituacaoDisciplina, StatusCurricular, nota_pura as nota_final, 
       nota_recuperacao, nota_final_recuperacao, nota_historico  

     from (
			select distinct nta.aluno, equ.disciplina, equ.disciplina_equivalente ,nta.SituacaoDisciplina, nta.StatusCurricular,
				   nta.nota as nota_pura, isnull(rec.nota_final_recuperacao, nta.nota) as NOTA_FINAL,   rec.nota_recuperacao, rec.nota_final_recuperacao,
			       dsc.nota as nota_historico, nta.curriculo as curriculo_nome, nta.curso as curso_nome
			  from cte_notas nta 
								 join vw_gradedisciplinaequivalente  equ on (equ.curriculo_equivalente_id = nta.curriculo_id_equ and
																			 equ.disciplina_equivalente_id = nta.disciplina_id)
								 join curriculos_disciplinaconcluida dsc on (dsc.curriculo_aluno_id = nta.curriculo_aluno_id and
																			 dsc.disciplina_id = equ.disciplina_id)
  
							left join cte_recuperacao                rec on (nta.curriculo_aluno_id = rec.curriculo_aluno_id and
																			 nta.disciplina_id = equ.disciplina_id) 
			WHERE  
				  isnull(rec.nota_final_recuperacao, nta.nota) = dsc.nota and
				  nta.curriculo_id <> nta.curriculo_id_equ

			union 

			select distinct nta.aluno, nta.disciplina, disciplina_equivalente = null, nta.SituacaoDisciplina, nta.StatusCurricular,
				   nta.nota as nota_pura, isnull(rec.nota_final_recuperacao, nta.nota) as NOTA_FINAL,   rec.nota_recuperacao, rec.nota_final_recuperacao,
			       dsc.nota as nota_historico,nta.curriculo as curriculo_nome, nta.curso as curso_nome
			  from cte_notas nta join curriculos_disciplinaconcluida dsc on (dsc.curriculo_aluno_id = nta.curriculo_aluno_id and
																			 dsc.disciplina_id = nta.disciplina_id)
  
							left join cte_recuperacao                rec on (nta.curriculo_aluno_id = rec.curriculo_aluno_id and
																			 nta.disciplina_id      = rec.disciplina_id) 
			WHERE  
				 isnull(rec.nota_final_recuperacao, nta.nota) = dsc.nota and 
				  nta.curriculo_id = nta.curriculo_id_equ
			) as tab 
			     
			
			  select * from vw_acd_extrato_notas   
			where aluno = 'YURI CASTELO BRANCO TANURE CAMPOS'


		