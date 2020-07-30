declare @origem int, @destino int 
set @origem  = 5111 
set @destino = 10304


 begin tran 
 -- ****** academico_turmadisciplinaprofessor ****
	 insert into academico_turmadisciplinaprofessor (atributos,atualizado_em,atualizado_por,criado_em,criado_por,professor_id,tipo_id,turma_disciplina_id)
		select atributos,atualizado_em = getdate(),atualizado_por = 2136,criado_em = getdate(),criado_por = 2136,professor_id,tipo_id,turma_disciplina_id = @destino
		  from academico_turmadisciplinaprofessor tdp
		 where turma_disciplina_id = @origem and 
		       not exists (select 1 from academico_turmadisciplinaprofessor tdpx 
						    where tdp.professor_id = tdpx.professor_id and 
							      tdpx.turma_disciplina_id = @destino)

	 delete from academico_turmadisciplinaprofessor 
	  where turma_disciplina_id = @origem
 -- ****** academico_turmadisciplinaprofessor fim ****

 -- ****** aulas_agendamento ****
	   update agd set agd.turma_disciplina_id = @destino, agd.atualizado_em = getdate(), agd.atualizado_por = 2136
	   from aulas_agendamento agd
	   where turma_disciplina_id = @origem and 
	         not exists (select 1 from aulas_agendamento aux
			                      where aux.turma_disciplina_id = @destino and 
										aux.agendamento_id = aux.agendamento_id) 		
		-- ***** deletar o que ficou de resto *****
		delete from aulas_agendamento where turma_disciplina_id = @origem
 -- ****** aulas_agendamento fim ****

 -- ****** materiais_didaticos_publicacao_turmadisciplina ****
	   update dpt set dpt.turma_disciplina_id = @destino, dpt.atualizado_em = getdate(), dpt.atualizado_por = 2136
	   from materiais_didaticos_publicacao_turmadisciplina dpt
	   where turma_disciplina_id = @origem and 
	         not exists (select 1 from materiais_didaticos_publicacao_turmadisciplina aux
			                      where aux.turma_disciplina_id = @destino and 
										aux.publicacao_id = dpt.publicacao_id) 		
		-- ***** deletar o que ficou de resto *****
		delete from materiais_didaticos_publicacao_turmadisciplina where turma_disciplina_id = @origem
 -- ****** materiais_didaticos_publicacao_turmadisciplina fim ****

 -- ****** aulas_agendamento ****
	   update dpt set dpt.turma_disciplina_id = @destino, dpt.atualizado_em = getdate(), dpt.atualizado_por = 2136
	   from aulas_agendamento dpt
	   where turma_disciplina_id = @origem and 
	         not exists (select 1 from aulas_agendamento aux
			                      where aux.turma_disciplina_id = @destino and 
										aux.agendamento_id = dpt.agendamento_id) 		
		-- ***** deletar o que ficou de resto *****
		delete from aulas_agendamento where turma_disciplina_id = @origem
 -- ****** aulas_agendamento fim ****

 -- ****** atividades_protocolosegundachamadaprova ****
	   update dpt set dpt.turma_disciplina_id = @destino, dpt.atualizado_em = getdate(), dpt.atualizado_por = 2136
	   from atividades_protocolosegundachamadaprova dpt
	   where turma_disciplina_id = @origem and 
	         not exists (select 1 from atividades_protocolosegundachamadaprova aux
			                      where aux.turma_disciplina_id = @destino and 
										aux.protocolo_id = dpt.protocolo_id) 		
		-- ***** deletar o que ficou de resto *****
		delete from atividades_protocolosegundachamadaprova where turma_disciplina_id = @origem
 -- ****** atividades_protocolosegundachamadaprova fim ****

 -- ****** atividades_criterio_turmadisciplina ****
	   update dpt set dpt.turma_disciplina_id = @destino, dpt.atualizado_em = getdate(), dpt.atualizado_por = 2136
	   from atividades_criterio_turmadisciplina dpt
	   where turma_disciplina_id = @origem and 
	         not exists (select 1 from atividades_criterio_turmadisciplina aux
			                      where aux.turma_disciplina_id = @destino and 
										aux.criterio_id = dpt.criterio_id) 		
		-- ***** deletar o que ficou de resto *****
		delete from atividades_criterio_turmadisciplina where turma_disciplina_id = @origem
 -- ****** atividades_criterio_turmadisciplina fim ****

 -- ****** frequencias_excecaofrequenciaforaprazo ****
	   update dpt set dpt.turma_disciplina_id = @destino, dpt.atualizado_em = getdate(), dpt.atualizado_por = 2136
	   from frequencias_excecaofrequenciaforaprazo dpt
	   where turma_disciplina_id = @origem and 
	         not exists (select 1 from frequencias_excecaofrequenciaforaprazo aux
			                      where aux.turma_disciplina_id = @destino and 
										aux.protocolo_frequencia_fora_prazo_id = dpt.protocolo_frequencia_fora_prazo_id) 		
		-- ***** deletar o que ficou de resto *****
		delete from frequencias_excecaofrequenciaforaprazo where turma_disciplina_id = @origem
 -- ****** frequencias_excecaofrequenciaforaprazo fim ****

 -- ****** frequencias_protocolofrequenciaforaprazo ****
	   update dpt set dpt.turma_disciplina_id = @destino, dpt.atualizado_em = getdate(), dpt.atualizado_por = 2136
	   from frequencias_protocolofrequenciaforaprazo dpt
	   where turma_disciplina_id = @origem and 
	         not exists (select 1 from frequencias_protocolofrequenciaforaprazo aux
			                      where aux.turma_disciplina_id = @destino and 
										aux.protocolo_id = dpt.protocolo_id) 		
		-- ***** deletar o que ficou de resto *****
		delete from frequencias_protocolofrequenciaforaprazo where turma_disciplina_id = @origem
 -- ****** frequencias_protocolofrequenciaforaprazo fim ****

 -- ****** academico_complementacaocargahoraria ****
	   update dpt set dpt.turma_disciplina_id = @destino, dpt.atualizado_em = getdate(), dpt.atualizado_por = 2136
	   from academico_complementacaocargahoraria dpt
	   where turma_disciplina_id = @origem and 
	         not exists (select 1 from academico_complementacaocargahoraria aux
			                      where aux.turma_disciplina_id = @destino and 
										aux.aluno_id = dpt.aluno_id) 		
		-- ***** deletar o que ficou de resto *****
		delete from academico_complementacaocargahoraria where turma_disciplina_id = @origem
 -- ****** academico_complementacaocargahoraria fim ****

 -- ****** aulas_pendentes ****
	   update dpt set dpt.turma_disciplina_id = @destino
	     from aulas_pendentes dpt
	   where turma_disciplina_id = @origem and 
	         not exists (select 1 from aulas_pendentes aux
			                      where aux.turma_disciplina_id = @destino and 
								        aux.professor_id = dpt.professor_id ) 		
		-- ***** deletar o que ficou de resto *****
		delete from aulas_pendentes where turma_disciplina_id = @origem
 -- ****** aulas_pendentes fim ****

 -- ****** frequencias_revisao ****
	   update dpt set dpt.turma_disciplina_id = @destino, dpt.atualizado_em = getdate(), dpt.atualizado_por = 2136
	   from frequencias_revisao dpt
	   where turma_disciplina_id = @origem and 
	         not exists (select 1 from frequencias_revisao aux
			                      where aux.turma_disciplina_id = @destino and 
								        aux.professor_id = dpt.professor_id and 
										aux.aluno_id  = dpt.aluno_id) 		
		-- ***** deletar o que ficou de resto *****
		delete from frequencias_revisao where turma_disciplina_id = @origem
 -- ****** frequencias_revisao fim ****

 -- ****** academico_aula ****
	   update dpt set dpt.turma_disciplina_id = @destino, dpt.atualizado_em = getdate(), dpt.atualizado_por = 2136
	   from academico_aula dpt
	   where turma_disciplina_id = @origem and 
	         not exists (select 1 from academico_aula aux
			                      where aux.turma_disciplina_id = @destino and 
								        aux.professor_id = dpt.professor_id and 
										aux.data_inicio  = dpt.data_inicio  ) 		
		-- ***** deletar o que ficou de resto *****
		delete from academico_aula where turma_disciplina_id = @origem 
 -- ****** academico_aula fim ****

 -- ****** academico_turmadisciplinaaluno ****
       -- ****** atualizar o que existe *****
	   update dpt set dpt.turma_disciplina_id = @destino, dpt.atualizado_em = getdate(), dpt.atualizado_por = 2136
	   from academico_turmadisciplinaaluno dpt
	   where turma_disciplina_id = @origem and 
	         not exists (select 1 from academico_turmadisciplinaaluno aux
			                      where aux.turma_disciplina_id = @destino and 
								        aux.aluno_id = dpt.aluno_id)		
		-- ***** deletar o que ficou de resto *****
		delete from academico_turmadisciplinaaluno where turma_disciplina_id = @origem 
 -- ****** academico_turmadisciplinaaluno fim ****


 -- ****** academico_turmadisciplina ****
        -- **** apagar a turmadisciplina 
		DELETE FROM ACADEMICO_TURMADISCIPLINA WHERE ID = @ORIGEM
 -- ****** academico_turmadisciplina FIM ****



-- commit 
-- rollback 

 --    select  dbo.fn_retorna_colunas_tabela('aulas_agendamento')
--     select * from vw_tabela_coluna where coluna = 'turmadisciplinaaluno_id'






