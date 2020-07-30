USE [erp_hmg]
GO
/****** Object:  StoredProcedure [dbo].[sp_gerar_log_planos_ensino_logreplicacaocriterio]    Script Date: 12/02/2020 15:40:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/**********************************************************************************************************************************
*                                       [SP_GERAR_LOG_PLANOS_ENSINO_LOGREPLICACAOCRITERIO]                                        *
*                                                                                                                                 *
*  PROCEDURE QUE GERA O LOG DA TABELA  -                                                                                          *
*  ### IMPLEMENTADO APENAS PARA DELECAO, INSERCAO ###                                                                             *
*                                                                                                                                 *
*                                                                                                                                 *
* BANCO_SISTEMA : EDUCAT                                                                                                          *
* CRIADO POR    : WEMERSON BITTORI MADURO                                                                         DATA:02/01/2020 *
* ALTERADO POR  : WEMERSON BITTORI MADURO                                                                         DATA:02/01/2020 *
**********************************************************************************************************************************/
-- exec sp_gerar_log_planos_ensino_logreplicacaocriterio @atributos_log, @observacao, @history_change_reason, @history_type, @history_user_id, @criterio_turmadisciplina_id
CREATE     procedure [dbo].[sp_gerar_log_planos_ensino_logreplicacaocriterio] 
        @atributos_log nvarchar(max), @observacao nvarchar(max), @history_change_reason  nvarchar(200), 
        @history_type varchar(2), @history_user_id int, @logreplicacaocriterio_id int as 

	 
			insert log_planos_ensino_logreplicacaocriterio (atributos_log, observacao, history_date , history_change_reason, history_type, history_user_id, 
			       id, criado_em, atualizado_em, criado_por, criterio_turma_disciplina_id, planoensino_criterio_id, atualizado_por)

			select atributos_log = @atributos_log, observacao = @observacao, history_date = GETDATE(), history_change_reason = @history_change_reason, 
			       history_type = @history_type, history_user_id = @history_user_id, 
				   id, criado_em, atualizado_em, criado_por, criterio_turma_disciplina_id, planoensino_criterio_id, atualizado_por

              from planos_ensino_logreplicacaocriterio where id = @logreplicacaocriterio_id
	 

	
GO
