USE [erp_hmg]
GO
/****** Object:  StoredProcedure [dbo].[sp_gerar_log_atividades_criterio_turmadisciplina]    Script Date: 12/02/2020 15:40:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/**********************************************************************************************************************************
*                                                 [SP_GERAR_LOG_ATIVIDADES_CRITERIO_TURMADISCIPLINA]                                              *
*                                                                                                                                 *
*  PROCEDURE QUE GERA O LOG DA TABELA ACADEMICO_GRUPOAULA -                                                                       *
*  ### IMPLEMENTADO APENAS PARA DELECAO, INSERCAO ###                                                                             *
*                                                                                                                                 *
*                                                                                                                                 *
* BANCO_SISTEMA : EDUCAT                                                                                                          *
* CRIADO POR    : WEMERSON BITTORI MADURO                                                                         DATA:01/11/2019 *
* ALTERADO POR  : WEMERSON BITTORI MADURO                                                                         DATA:01/11/2019 *
**********************************************************************************************************************************/
-- exec sp_gerar_log_atividades_criterio_turmadisciplina @atributos_log, @observacao, @history_change_reason, @history_type, @history_user_id, @criterio_turmadisciplina_id
CREATE     procedure [dbo].[sp_gerar_log_atividades_criterio_turmadisciplina] 
        @atributos_log nvarchar(max), @observacao nvarchar(max), @history_change_reason  nvarchar(200), 
        @history_type varchar(2), @history_user_id int, @criterio_turmadisciplina_id int as 

	 
			insert log_atividades_criterio_turmadisciplina (atributos_log, observacao, history_date , history_change_reason, history_type, history_user_id, 
			       id, turma_disciplina_id, criterio_id, atributos, criado_em, criado_por, atualizado_em, atualizado_por, professor_id, 
				   data_ativividades_configuradas, max_atividades, termino_janela_lancamento, inicio_janela_lancamento )

			select atributos_log = @atributos_log, observacao = @observacao, history_date = GETDATE(), history_change_reason = @history_change_reason, 
			       history_type = @history_type, history_user_id = @history_user_id, 
			       id, turma_disciplina_id, criterio_id, atributos, criado_em, criado_por, atualizado_em, atualizado_por, professor_id, 
				   data_ativividades_configuradas, max_atividades, termino_janela_lancamento, inicio_janela_lancamento

 from atividades_criterio_turmadisciplina where id = @criterio_turmadisciplina_id
	 

	
GO
