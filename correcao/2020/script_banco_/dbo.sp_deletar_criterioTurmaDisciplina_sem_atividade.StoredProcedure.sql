USE [erp_hmg]
GO
/****** Object:  StoredProcedure [dbo].[sp_deletar_criterioTurmaDisciplina_sem_atividade]    Script Date: 09/01/2020 18:38:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/**********************************************************************************************************************************
*                                        SP_DELETAR_CRITERIOTURMADISCIPLINA_SEM_ATIVIDADE                                         *
*                                                                                                                                 *
*  PROCEDURE QUE ESCLUI OS CRITERIOS TURMAS DISCIPLINA QUE NAO POSSUEM ATIVIDADES LANCADAS                                        *
*                                                                                                                                 *
*                                                                                                                                 *
* BANCO_SISTEMA : EDUCAT                                                                                                          *
* CRIADO POR    : WEMERSON BITTORI MADURO                                                                         DATA:02/01/2020 *
* ALTERADO POR  : WEMERSON BITTORI MADURO                                                                         DATA:02/01/2020 *
**********************************************************************************************************************************/

create   procedure [dbo].[sp_deletar_criterioTurmaDisciplina_sem_atividade]  @criterio_turmadisciplina_id int, @usuario_responsavel int as 
declare @atividade_id int 
declare @lgoreplicacaocriterio_id int 

select @atividade_id = id from atividades_atividade where criterio_turma_disciplina_id = @criterio_turmadisciplina_id
select @lgoreplicacaocriterio_id = id from planos_ensino_logreplicacaocriterio where criterio_turma_disciplina_id = @criterio_turmadisciplina_id

begin tran 
	begin try 
		exec sp_gerar_log_planos_ensino_logreplicacaocriterio null, null, null, '-', @usuario_responsavel, @lgoreplicacaocriterio_id
		delete from planos_ensino_logreplicacaocriterio where criterio_turma_disciplina_id = @criterio_turmadisciplina_id

		exec sp_gerar_log_atividades_atividade null, null, null, '-', @usuario_responsavel, @atividade_id
		delete from atividades_atividade where criterio_turma_disciplina_id = @criterio_turmadisciplina_id

		exec sp_gerar_log_atividades_criterio_turmadisciplina null, null, null, '-', @usuario_responsavel, @criterio_turmadisciplina_id
		delete from atividades_criterio_turmadisciplina where id = @criterio_turmadisciplina_id
		 commit 
		 print 'PROCESSO EFETUADO COM SUCESSO !!!  criterio_turmadisciplina_id = ' + convert(varchar(20), @criterio_turmadisciplina_id)
	end try 
	begin catch
		rollback 
		print 'NAO FOI POSSIVEL EXCLUIR ESTE CRITERIO TURMA DISCIPLINA !!!  criterio_turmadisciplina_id = ' + convert(varchar(20), @criterio_turmadisciplina_id)
		PRINT ERROR_MESSAGE()

	end catch
		-- rollback 

--select * from planos_ensino_logreplicacaocriterio where criterio_turma_disciplina_id = 4509
GO
