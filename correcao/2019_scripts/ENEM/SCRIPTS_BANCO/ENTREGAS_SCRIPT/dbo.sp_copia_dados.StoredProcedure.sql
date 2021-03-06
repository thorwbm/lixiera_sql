/****** Object:  StoredProcedure [dbo].[sp_copia_dados]    Script Date: 26/12/2019 13:14:39 ******/
DROP PROCEDURE IF EXISTS [dbo].[sp_copia_dados]
GO
/****** Object:  StoredProcedure [dbo].[sp_copia_dados]    Script Date: 26/12/2019 13:14:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   procedure [dbo].[sp_copia_dados] as
begin

	declare @tabela varchar(255)
	declare @data_char char(8) = format(dbo.getlocaldate(), 'yyyyMMdd')
	declare @tabela_completa varchar(255)

	----------------------------------------------------------------------------------------
	--CORRECOES_CORRECAO
	set @tabela = 'correcoes_correcao'
	set @tabela_completa = '[' + @data_char + '].' + @tabela
	exec sp_copia_tabela @tabela, 'id, data_inicio, data_termino, link_imagem_recortada, nota_final, competencia1, competencia2, competencia3, competencia4, competencia5, nota_competencia1, nota_competencia2, nota_competencia3, nota_competencia4, nota_competencia5, tempo_em_correcao, id_correcao_situacao, id_corretor, id_projeto, co_barra_redacao, id_status, tipo_auditoria_id, id_tipo_correcao, redacao_id'

	exec ('create index ix__' + @tabela + '_' + @data_char + '__redacao_id on ' + @tabela_completa + ' (redacao_id)')
	exec ('create index ix__' + @tabela + '_' + @data_char + '__id_corretor on ' + @tabela_completa + ' (id_corretor)')
	exec ('create index ix__' + @tabela + '_' + @data_char + '__id_correcao_situacao on ' + @tabela_completa + ' (id_correcao_situacao)')
	exec ('create index ix__' + @tabela + '_' + @data_char + '__redacao_id__id_projeto__id_tipo_correcao on ' + @tabela_completa + ' (redacao_id, id_projeto, id_tipo_correcao)')
	----------------------------------------------------------------------------------------



	----------------------------------------------------------------------------------------
	--CORRECOES_REDACAO
	set @tabela = 'correcoes_redacao'
	set @tabela_completa = '[' + @data_char + '].' + @tabela
	exec sp_copia_tabela @tabela, '*'

	exec ('create index ix__' + @tabela + '_' + @data_char + '__co_inscricao on ' + @tabela_completa + ' (co_inscricao)' )
	exec ('create index ix__' + @tabela + '_' + @data_char + '__co_barra_redacao on ' + @tabela_completa + ' (co_barra_redacao)' )
	exec ('create index ix__' + @tabela + '_' + @data_char + '__id on ' + @tabela_completa + ' (id)' )
	exec ('create index ix__' + @tabela + '_' + @data_char + '__nota_final on ' + @tabela_completa + ' (nota_final)' )
	exec ('create index ix__' + @tabela + '_' + @data_char + '__cancelado__nota_final on ' + @tabela_completa + ' (cancelado, nota_final)' )
	----------------------------------------------------------------------------------------


	----------------------------------------------------------------------------------------
	--CORRECOES_ANALISE
	set @tabela = 'correcoes_analise'
	set @tabela_completa = '[' + @data_char + '].' + @tabela
	exec sp_copia_tabela @tabela, '*'

	exec ('create index ix__' + @tabela + '_' + @data_char + '__redacao_id on ' + @tabela_completa + ' (redacao_id)' )
	exec ('create index ix__' + @tabela + '_' + @data_char + '__redacao_id__id_tipo_correcao_b__aproveitamento on ' + @tabela_completa + ' (redacao_id, id_tipo_correcao_b, aproveitamento)' )
	----------------------------------------------------------------------------------------


	----------------------------------------------------------------------------------------
	--USUARIOS_PESSOA
	set @tabela = 'usuarios_pessoa'
	set @tabela_completa = '[' + @data_char + '].' + @tabela
	exec sp_copia_tabela @tabela, '*'

	exec ('create index ix__' + @tabela + '_' + @data_char + '__usuario_id on ' + @tabela_completa + ' (usuario_id)' )
	----------------------------------------------------------------------------------------

	----------------------------------------------------------------------------------------
	--PROJETO_PROJETO
	set @tabela = 'projeto_projeto'
	set @tabela_completa = '[' + @data_char + '].' + @tabela
	exec sp_copia_tabela @tabela, '*'

	exec ('create index ix__' + @tabela + '_' + @data_char + '__id on ' + @tabela_completa + ' (id)' )
	----------------------------------------------------------------------------------------
	
	----------------------------------------------------------------------------------------
	--PROJETO_PROJETO_USUARIOS
	set @tabela = 'projeto_projeto_usuarios'
	set @tabela_completa = '[' + @data_char + '].' + @tabela
	exec sp_copia_tabela @tabela, '*'

	exec ('create index ix__' + @tabela + '_' + @data_char + '__id on ' + @tabela_completa + ' (id)' )
	----------------------------------------------------------------------------------------
	
	----------------------------------------------------------------------------------------
	--AUTH_USER_GROUPS
	set @tabela = 'auth_user_groups'
	set @tabela_completa = '[' + @data_char + '].' + @tabela
	exec sp_copia_tabela @tabela, '*'

	exec ('create index ix__' + @tabela + '_' + @data_char + '__id on ' + @tabela_completa + ' (id)' )
	----------------------------------------------------------------------------------------

	----------------------------------------------------------------------------------------
	--AUTH_GROUP
	set @tabela = 'auth_group'
	set @tabela_completa = '[' + @data_char + '].' + @tabela
	exec sp_copia_tabela @tabela, '*'

	exec ('create index ix__' + @tabela + '_' + @data_char + '__id on ' + @tabela_completa + ' (id)' )
	----------------------------------------------------------------------------------------

	----------------------------------------------------------------------------------------
	--CORRECOES_CORRETOR
	set @tabela = 'correcoes_corretor'
	set @tabela_completa = '[' + @data_char + '].' + @tabela
	exec sp_copia_tabela @tabela, '*'

	exec ('create index ix__' + @tabela + '_' + @data_char + '__id on ' + @tabela_completa + ' (id)' )
	----------------------------------------------------------------------------------------

	----------------------------------------------------------------------------------------
	--correcoes_corretor_indicadores
	set @tabela = 'correcoes_corretor_indicadores'
	set @tabela_completa = '[' + @data_char + '].' + @tabela
	exec sp_copia_tabela @tabela, 'id,  dsp, data_calculo, tempo_correcao,   projeto_id, usuario_id'

	exec ('create index ix__' + @tabela + '_' + @data_char + '__id on ' + @tabela_completa + ' (id)' )
	exec ('create index ix__' + @tabela + '_' + @data_char + '__usuario_id on ' + @tabela_completa + ' (usuario_id)')
	----------------------------------------------------------------------------------------

	----------------------------------------------------------------------------------------
	--status_corretor_trocastatus
	--select top 1 * from 
	set @tabela = 'status_corretor_trocastatus'
	set @tabela_completa = '[' + @data_char + '].' + @tabela
	exec sp_copia_tabela @tabela, '*'

	exec ('create index ix__' + @tabela + '_' + @data_char + '___id on ' + @tabela_completa + ' (id)' )
	exec ('create index ix__' + @tabela + '_' + @data_char + '__corretor_id on ' + @tabela_completa + ' (corretor_id)')
	----------------------------------------------------------------------------------------

	----------------------------------------------------------------------------------------
	--CORRECOES_SUSPENSAO
	set @tabela = 'CORRECOES_SUSPENSAO'
	set @tabela_completa = '[' + @data_char + '].' + @tabela
	exec sp_copia_tabela @tabela, '*'

	exec ('create index ix__' + @tabela + '_' + @data_char + '__corretor_id on ' + @tabela_completa + ' (id_corretor)')
	----------------------------------------------------------------------------------------

	----------------------------------------------------------------------------------------
	--CORRECOES_REDACAOOURO
	set @tabela = 'correcoes_redacaoouro'
	set @tabela_completa = '[' + @data_char + '].' + @tabela
	exec sp_copia_tabela @tabela, '*'
	
	exec ('create index ix__' + @tabela + '_' + @data_char + '___id on ' + @tabela_completa + ' (id)')
	exec ('create index ix__' + @tabela + '_' + @data_char + '___redacao_id on ' + @tabela_completa + ' (redacao_id)')
	----------------------------------------------------------------------------------------


end


GO
