USE [erp_hmg]
GO
/****** Object:  StoredProcedure [dbo].[sp_excluir_atividade_complementar]    Script Date: 09/01/2020 18:38:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/**********************************************************************************************************************************
*                                              [SP_EXCLUIR_ATIVIDADE_COMPLEMENTAR]                                                *
*                                                                                                                                 *
*  PROCEDURE QUE APAGA OS LANCAMENTOS FEITOS PELO SISTEMA DE ATIVIDADE COMPLEMENTAR PARA UM ALUNO EM UM CURRICULO                 *
*                                                                                                                                 *
*                                                                                                                                 *
* BANCO_SISTEMA : ATIVIDADE COMPLEMENTAR - EDUCAT                                                                                 *
* CRIADO POR    : WEMERSON BITTORI MADURO                                                                         DATA:20/11/2019 *
* ALTERADO POR  : WEMERSON BITTORI MADURO                                                                         DATA:10/12/2019 *
**********************************************************************************************************************************/

-- EXEC sp_excluir_atividade_complementar '12901375600', 'psicologia'

CREATE   procedure [dbo].[sp_excluir_atividade_complementar] 
    @aluno_cpf varchar(20), @curso_nome varchar(500) as
	
	declare @curriculoalunoid int

	-- **** encontrar o curriculo aluno id do aluno no educat
	select DISTINCT @curriculoalunoid =  CURRICULOALUNO_ID
	  from vw_aluno_curriculo_curso_turma_etapa_discplina 
	 WHERE ALUNO_CPF = @aluno_cpf  AND 
		   STATUSCURRICULO_ID = 13 and 
		   CURSO_NOME = @curso_nome
begin try
	begin tran
		-- **** criar log 
		insert into log_atividades_complementares_atividade
			   (atributos_log, observacao, history_date, history_change_reason, history_type, history_user_id,
				id, criado_em, atualizado_em, atributos, carga_horaria, data_realizacao, observacoes, periodo, ano, criado_por, 
				modalidade_id, curriculo_aluno_id, tipo_id, atualizado_por)
		select atributos_log         = null, 
			   observacao            = null, 
			   history_date          = getdate(), 
			   history_change_reason = null, 
			   history_type          = '-', 
			   history_user_id       = null,
			   id, criado_em, atualizado_em, atributos, carga_horaria, data_realizacao, observacoes, periodo, ano, criado_por, 
			   modalidade_id, curriculo_aluno_id, tipo_id, atualizado_por
		from atividades_complementares_atividade
		where curriculo_aluno_id = @curriculoalunoid and 
			  atributos = 'origem:Sistema Atividade Complementar' and criado_por is null 

		-- **** criar log - fim 

		delete from atividades_complementares_atividade 
		where curriculo_aluno_id = @curriculoalunoid and 
			  atributos = 'origem:Sistema Atividade Complementar' and criado_por is null 
	commit
end try
begin catch
	rollback
end catch 
GO
