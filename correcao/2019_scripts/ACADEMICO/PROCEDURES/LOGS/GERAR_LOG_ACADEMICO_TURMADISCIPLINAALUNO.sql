/**********************************************************************************************************************************
*                                         [SP_GERAR_LOG_ACADEMICO_TURMADISCIPLINAALUNO]                                           *
*                                                                                                                                 *
*  PROCEDURE QUE GERA O LOG DA TABELA ACADEMICO_TURMADISCIPLINAALUNO - ### IMPLEMENTADO APENAS PARA DELECAO ###                   *
*                                                                                                                                 *
*                                                                                                                                 *
* BANCO_SISTEMA : EDUCAT                                                                                                          *
* CRIADO POR    : WEMERSON BITTORI MADURO                                                                         DATA:28/10/2019 *
* ALTERADO POR  : WEMERSON BITTORI MADURO                                                                         DATA:28/10/2019 *
**********************************************************************************************************************************/

create or alter procedure sp_gerar_log_academico_turmadisciplinaaluno 
        @atributos_log nvarchar(max), @observacao nvarchar(max), @history_change_reason  nvarchar(200), 
        @history_type varchar(2), @history_user_id int, @turmadisciplinaaluno_id int as 

	if(@history_type = '-')
		begin 
			insert log_academico_turmadisciplinaaluno (atributos_log, observacao, history_date, history_change_reason, history_type,  history_user_id,
				   id, atributos, criado_em, atualizado_em, aluno_id, criado_por, turma_disciplina_id, atualizado_por, exigencia_matricula_disciplina_id, 
				   tipo_matricula_id, status_matricula_disciplina_id, fechado_em, tentar_fechamento
				   )
			select atributos_log = @atributos_log, observacao = @observacao, history_date = getdate(), history_change_reason = @history_change_reason, 
				   history_type = @history_type,  history_user_id = @history_user_id,
				   id, atributos, criado_em, atualizado_em, aluno_id, criado_por, turma_disciplina_id, atualizado_por, exigencia_matricula_disciplina_id, 
				   tipo_matricula_id, status_matricula_disciplina_id, fechado_em, tentar_fechamento
			 from academico_turmadisciplinaaluno where id = @turmadisciplinaaluno_id
		end 