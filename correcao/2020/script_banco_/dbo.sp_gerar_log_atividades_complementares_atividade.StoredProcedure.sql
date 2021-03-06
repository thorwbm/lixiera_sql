USE [erp_hmg]
GO
/****** Object:  StoredProcedure [dbo].[sp_gerar_log_atividades_complementares_atividade]    Script Date: 09/01/2020 18:38:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[sp_gerar_log_atividades_complementares_atividade]
      @atividades_complementares_atividade_id int, 
	  @history_type          varchar(1), 
	  @atributos_log         varchar(max),
	  @observacao            varchar(max),
	  @history_change_reason varchar(max),
	  @history_user_id       int

as 

insert into log_atividades_complementares_atividade
       (atributos_log, observacao, history_date, history_change_reason, history_type, history_user_id,
        id, criado_em, atualizado_em, atributos, carga_horaria, data_realizacao, observacoes, periodo, ano, criado_por, 
        modalidade_id, curriculo_aluno_id, tipo_id, atualizado_por)
select atributos_log         = @atributos_log, 
       observacao            = @observacao, 
	   history_date          = getdate(), 
	   history_change_reason = @history_change_reason, 
	   history_type          = @history_type, 
	   history_user_id       = @history_user_id,
       id, criado_em, atualizado_em, atributos, carga_horaria, data_realizacao, observacoes, periodo, ano, criado_por, 
       modalidade_id, curriculo_aluno_id, tipo_id, atualizado_por
from atividades_complementares_atividade
where id = @atividades_complementares_atividade_id 
GO
