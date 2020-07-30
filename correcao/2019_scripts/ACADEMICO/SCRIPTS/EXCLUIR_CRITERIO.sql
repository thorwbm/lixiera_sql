
declare @criterio_turmadisciplina_id int 
declare @atividade_id int 
declare @lgoreplicacaocriterio_id int 

set @criterio_turmadisciplina_id = 2636
select @atividade_id = id from atividades_atividade where criterio_turma_disciplina_id = @criterio_turmadisciplina_id
select @lgoreplicacaocriterio_id = id from planos_ensino_logreplicacaocriterio where criterio_turma_disciplina_id = @criterio_turmadisciplina_id


begin tran 
	begin try 
		exec sp_gerar_log_planos_ensino_logreplicacaocriterio null, null, null, '-', 2136, @lgoreplicacaocriterio_id
		delete from planos_ensino_logreplicacaocriterio where criterio_turma_disciplina_id = @criterio_turmadisciplina_id

		exec sp_gerar_log_atividades_atividade null, null, null, '-', 2136, @atividade_id
		delete from atividades_atividade where criterio_turma_disciplina_id = @criterio_turmadisciplina_id

		exec sp_gerar_log_atividades_criterio_turmadisciplina null, null, null, '-', 2136, @criterio_turmadisciplina_id
		delete from atividades_criterio_turmadisciplina where id = @criterio_turmadisciplina_id
		 commit 
		 print 'PROCESSO EFETUADO COM SUCESSO'
	end try 
	begin catch
		rollback 
		print 'NAO FOI POSSIVEL EXCLUIR ESTE CRITERIO TURMA DISCIPLINA !!!'
		PRINT ERROR_MESSAGE()

	end catch
		-- rollback 

--select * from planos_ensino_logreplicacaocriterio where criterio_turma_disciplina_id = 4509