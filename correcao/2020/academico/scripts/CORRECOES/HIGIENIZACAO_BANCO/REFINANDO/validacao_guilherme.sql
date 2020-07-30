with cte_aluno_turma_disciplina as (
			select alu.id as aluno_id, alu.nome as aluno_nome,  
				   cur.id as curso_id, cur.nome as curso_nome, 
				   tur.id as turma_id, tur.nome as turma_nome, 
				   dis.id as disciplina_id, dis.nome as disciplina_nome, 
				   tds.id as turma_disciplina_id, 
				   tda.id as turma_disciplina_aluno_id, 
				   gra.id as grade_id, gra.nome as grade_nome, 
				   crc.id as curriculo_id, crc.nome as curriculo_nome
			 from academico_aluno alu join academico_turmadisciplinaaluno tda on (alu.id = tda.aluno_id)
									  join academico_turmadisciplina      tds on (tds.id = tda.turma_disciplina_id)
									  join academico_turma                tur on (tur.id = tds.turma_id)
									  join curriculos_grade               gra on (gra.id = tur.grade_id)
									  join curriculos_curriculo           crc on (crc.id = gra.curriculo_id)
									  join academico_disciplina           dis on (dis.id = tds.disciplina_id)
									  join academico_curso                cur on (cur.id = tur.curso_id)  
)

	,	cte_aula_qtd as (	
			select cte.aluno_id, cte.turma_disciplina_id, count(aul.id) as qtd_aula
			  from cte_aluno_turma_disciplina cte join academico_turmadisciplina tds on (tds.id = cte.turma_disciplina_id)
			                                      join academico_turma           tur on (tur.id = tds.turma_id)
												  join curriculos_grade          gra on (gra.id = tur.grade_id)
												  join academico_etapa           etp on (etp.id = gra.etapa_id)												  
			                                 left join academico_aula aul on (aul.turma_disciplina_id = cte.turma_disciplina_id)
			 group by cte.aluno_id, cte.turma_disciplina_id			 
)

	,	cte_frequencia_presenca as (
			select fre.aluno_id, aul.turma_disciplina_id, count(fre.id) as qtd_presenca
			  from academico_frequenciadiaria fre join academico_aula            aul on (aul.id = fre.aula_id)
			where presente = 1
			group by fre.aluno_id, aul.turma_disciplina_id
)

	,	cte_frequencia_falta as (
			select fre.aluno_id, aul.turma_disciplina_id, count(fre.id) as qtd_falta
			  from academico_frequenciadiaria fre join academico_aula            aul on (aul.id = fre.aula_id)
			where presente = 0
			group by fre.aluno_id, aul.turma_disciplina_id
)
	,	cte_criterio_nota as (
			select aaa.aluno_id, act.turma_disciplina_id, cri.nome as criterio_nome, aaa.nota as aluno_nota
			  from atividades_atividade_aluno aaa join atividades_atividade    ati on (ati.id = aaa.atividade_id)
                                      join atividades_criterio_turmadisciplina act on (act.id = ati.criterio_turma_disciplina_id)
									  join atividades_criterio                 cri on (cri.id = act.criterio_id)
									  join academico_turmadisciplina           tds on (tds.id = act.turma_disciplina_id)
)


			select atd.*, aul.qtd_aula as aulas, isnull(fal.qtd_falta,0) as faltas, isnull(pre.qtd_presenca,0) as presenca,
			       ctn.criterio_nome, ctn.aluno_nota
			  from cte_aluno_turma_disciplina atd left join cte_criterio_nota       ctn on (ctn.aluno_id            = atd.aluno_id and 
			                                                                                ctn.turma_disciplina_id = atd.turma_disciplina_id)
			                                      left join cte_aula_qtd            aul on (aul.turma_disciplina_id = atd.turma_disciplina_id and 
			                                                                                aul.aluno_id            = atd.aluno_id)
												  left join cte_frequencia_falta    fal on (fal.aluno_id            = atd.aluno_id and 
												                                            fal.turma_disciplina_id = atd.turma_disciplina_id)
												  left join cte_frequencia_presenca pre on (pre.aluno_id            = atd.aluno_id and 
												                                            pre.turma_disciplina_id = atd.turma_disciplina_id)


where atd.aluno_id = 41565 and 
      atd.disciplina_nome = 'INTERNATO DE SAÚDE DO IDOSO'
 order by turma_disciplina_aluno_id

--	  select  aluno_id, disciplina_nome, * from tmp_alunos_afetados_higienizacao_tds

select * from vw_criterios_duplicados
