/**********************************************************************************************************************************
*                                                 [SP_GERAR_LOG_ACADEMICO_AULA]                                                   *
*                                                                                                                                 *
*  PROCEDURE QUE GERA O LOG DA TABELA ACADEMICO_AULA - ### IMPLEMENTADO APENAS PARA DELECAO ###                                   *
*                                                                                                                                 *
*                                                                                                                                 *
* BANCO_SISTEMA : EDUCAT                                                                                                          *
* CRIADO POR    : WEMERSON BITTORI MADURO                                                                         DATA:01/11/2019 *
* ALTERADO POR  : WEMERSON BITTORI MADURO                                                                         DATA:01/11/2019 *
**********************************************************************************************************************************/

create or ALTER   procedure [dbo].[sp_gerar_log_academico_aula] 
        @atributos_log nvarchar(max), @observacao nvarchar(max), @history_change_reason  nvarchar(200), 
        @history_type varchar(2), @history_user_id int, @aula_id int as 

	if(@history_type = '-')
		begin 
			insert LOG_ACADEMICO_AULA (atributos_log , observacao, history_date, history_change_reason, history_type, history_user_id, 
				   id, atributos, criado_em, atualizado_em, data_inicio, data_termino, duracao, conteudo, data_envio_frequencia, 
				   agendamento_id, criado_por, professor_id, status_id, turma_disciplina_id, atualizado_por, 
				   user_envio_frequencia_id, sala_id, metodologia_id, plano, tipo_id, grupo_id, data_envio_conteudo, user_envio_conteudo_id
				   )
			select top 1 
			       atributos_log = @atributos_log, observacao = @observacao, history_date = GETDATE(), history_change_reason = @history_change_reason, 
				   history_type = @history_type, history_user_id = @history_user_id, 
				   id, atributos, criado_em, atualizado_em, data_inicio, data_termino, duracao, conteudo, data_envio_frequencia, 
				   agendamento_id, criado_por, professor_id, status_id, turma_disciplina_id, atualizado_por, 
				   user_envio_frequencia_id, sala_id, metodologia_id, plano, tipo_id, grupo_id, data_envio_conteudo, user_envio_conteudo_id

			      
			 from academico_aula where id = @aula_id
		end 
