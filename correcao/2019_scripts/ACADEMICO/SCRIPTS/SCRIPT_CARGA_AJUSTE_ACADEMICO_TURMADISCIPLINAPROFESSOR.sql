if object_id('tempdb..#temp') is not null drop table #temp

-- **** MONTAR UMA TABELA TEMPORARIA COM OS REGISTROS A SEREM INSERIDOS ****
select distinct atributos = null, tipo_id = 1, aul.professor_id, aul.turma_disciplina_id, 
                criado_em = getdate(), criado_por = null, atualizado_em = getdate(), atualizado_por = null 
  into #temp
  from academico_aula aul left join academico_turmadisciplinaprofessor tdp on (tdp.turma_disciplina_id = aul.turma_disciplina_id and 
                                                                               tdp.professor_id        = aul.professor_id)
where tdp.id is null and 
      not exists(select 1 from academico_turmadisciplinaprofessor tdpx 
	              where tdpx.turma_disciplina_id = aul.turma_disciplina_id and 
				        tdpx.professor_id        = aul.professor_id)

-- **** INSERIR NA TABELA DESTINO ****
insert into academico_turmadisciplinaprofessor (atributos, tipo_id, professor_id, turma_disciplina_id, criado_em, criado_por, atualizado_em, atualizado_por)
select * from #temp

-- **** INSERIR NA TABELA DE LOG DA TABELA DESTINO COM BASE NA TABELA ORIGINAL ****
insert LOG_ACADEMICO_TURMADISCIPLINAPROFESSOR (atributos_log, observacao, history_date, history_change_reason, history_type, history_user_id, 
				                               id, atributos, tipo_id, professor_id, turma_disciplina_id, criado_em, criado_por, atualizado_em, atualizado_por )
select atributos_log = null, observacao = null, history_date = GETDATE(), history_change_reason = null, history_type = '+', history_user_id = null, 
				                               tdp.id, tdp.atributos, tdp.tipo_id, tdp.professor_id, tdp.turma_disciplina_id, tdp.criado_em, tdp.criado_por, tdp.atualizado_em, 
											   tdp.atualizado_por
  from #temp tem join academico_turmadisciplinaprofessor tdp on (tem.turma_disciplina_id = tdp.turma_disciplina_id and 
                                                                 tem.professor_id        = tdp.professor_id)
 where not exists (select 1 from log_academico_turmadisciplinaprofessor tdpx
                    where tdpx.turma_disciplina_id = tdp.turma_disciplina_id and 
					      tdpx.professor_id        = tdp.professor_id and 
						  tdpx.history_type = '+')