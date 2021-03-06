USE [erp_hmg]
GO
/****** Object:  StoredProcedure [dbo].[sp_gerar_log_academico_turmadisciplinaprofessor]    Script Date: 12/02/2020 15:40:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/**********************************************************************************************************************************
*                                                 [LOG_ACADEMICO_TURMADISCIPLINAPROFESSOR]                                        *
*                                                                                                                                 *
*  PROCEDURE QUE GERA O LOG DA TABELA ACADEMICO_TURMADISCIPLINAPROFESSOR                                                          *
*     - ### IMPLEMENTADO APENAS PARA DELECAO ###                                                                                  *
*     - ### IMPLEMENTADO APENAS PARA INSERCAO ###                                                                                 *
*                                                                                                                                 *
*                                                                                                                                 *
* BANCO_SISTEMA : EDUCAT                                                                                                          *
* CRIADO POR    : WEMERSON BITTORI MADURO                                                                         DATA:07/11/2019 *
* ALTERADO POR  : WEMERSON BITTORI MADURO                                                                         DATA:07/11/2019 *
**********************************************************************************************************************************/

CREATE   procedure [dbo].[sp_gerar_log_academico_turmadisciplinaprofessor] 
        @atributos_log nvarchar(max), @observacao nvarchar(max), @history_change_reason  nvarchar(200), 
        @history_type varchar(2), @history_user_id int, @aula_id int as 

	if(@history_type IN ('-','+'))
		begin 
			insert LOG_ACADEMICO_TURMADISCIPLINAPROFESSOR (atributos_log, observacao, history_date, history_change_reason, 
				   history_type, history_user_id, 
				   id, atributos, tipo_id, professor_id, turma_disciplina_id, criado_em, criado_por, atualizado_em, atualizado_por )
			select top 1 
			       atributos_log = @atributos_log, observacao = @observacao, history_date = GETDATE(), history_change_reason = @history_change_reason, 
				   history_type = @history_type, history_user_id = @history_user_id, 
				   id, atributos, tipo_id, professor_id, turma_disciplina_id, criado_em, criado_por, atualizado_em, atualizado_por	      
			 from log_academico_turmadisciplinaprofessor where id = @aula_id
		end 
GO
