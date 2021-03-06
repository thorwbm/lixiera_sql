/****** Object:  StoredProcedure [dbo].[sp_gera_lote_n70]    Script Date: 26/12/2019 13:14:39 ******/
DROP PROCEDURE IF EXISTS [dbo].[sp_gera_lote_n70]
GO
/****** Object:  StoredProcedure [dbo].[sp_gera_lote_n70]    Script Date: 26/12/2019 13:14:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE      PROCEDURE [dbo].[sp_gera_lote_n70]
as
begin

	declare @sql        nvarchar(max)
	declare @sql_insert nvarchar(max)

	declare @admin_user_id int
	declare @lote_id       int

	declare @pcd_surdez char(1) = '8'
	declare @pcd_dislexia char(1) = '11'

	declare @data_char char(8) = format(dbo.getlocaldate(), 'yyyyMMdd')
	
	declare @prefixo varchar(50) = 'DESCARTADA'
    declare @tipo int = 8
    declare @interface int = 6
	
	--Copia os dados mais atualizados da correção
	-- exec sp_copia_dados -- movido para a procedure 


	--select * from inep_lotetipo
	--select * from inep_lotestatus
	--select * from inep_loteINTERFACE

	-- TESTAR SE O LOTE ESTA PENDENTE DE LIBERACAO (STATUS) E É DO TIPO AVULSO (TIPO) 
	if exists(select top 1 1 from inep_lote where convert(date, criado_em) = convert(date, dbo.getlocaldate()) and tipo_id = @tipo and status_id = 1) begin
		delete from inep_n70 where lote_id in (select id from inep_lote where convert(date, criado_em) = convert(date, dbo.getlocaldate()) and tipo_id = @tipo)
        delete from inep_lote where convert(date, criado_em) = convert(date, dbo.getlocaldate()) and tipo_id = @tipo  and interface_id = @interface
	end

	insert into inep_lote (nome, status_id, criado_em, tipo_id, interface_id) values (@prefixo + '_' + @data_char + '_' + convert(varchar(10),@tipo), 1, dbo.getlocaldate(), @tipo, @interface)
	set @lote_id = @@IDENTITY

	--*****************************************************************************
	DECLARE @SQL_VIEW VARCHAR(MAX)
	SET @SQL_VIEW = N'

	create OR ALTER view [' + @data_char + '].[vw_descartada_n70] as    
		select  aud.redacao_id,     
				cor.id_tipo_correcao,    
		  descartada = case when (isnull(aud.nota_final  ,0) = isnull(cor.nota_final  ,0) and     
								  isnull(aud.competencia1,0) = isnull(cor.competencia1,0) and    
								  isnull(aud.competencia2,0) = isnull(cor.competencia2,0) and    
								  isnull(aud.competencia3,0) = isnull(cor.competencia3,0) and    
								  isnull(aud.competencia4,0) = isnull(cor.competencia4,0) and    
								  isnull(aud.competencia5,0) = isnull(cor.competencia5,0) and    
								  aud.id_correcao_situacao = cor.id_correcao_situacao) then 0 else 1 end    
		  from [' + @data_char + '].correcoes_correcao aud join [' + @data_char + '].correcoes_correcao cor on (aud.redacao_id = cor.redacao_id and     
																	                                            aud.id_tipo_correcao = 7 ) 
	'
	EXEC(@SQL_VIEW)

	--*****************************************************************************
	
	set @sql ='			   
	select
		ID                    = 0, 
		LOTE_ID               = 0, 
		CRIADO_EM             = DBO.GETLOCALDATE(),
		REDACAO_ID            = cor.redacao_id, 
		CORRECAO_ID           = cor.id,
		CO_PROJETO            = N02.CO_PROJETO,
		CO_INSCRICAO          = RED.co_inscricao,
		SIGLA_UF              = N02.SG_UF_PROVA,
		NU_CPF                = PES.cpf, 
		TP_TIPO_CORRECAO      = tpa.co_tipo_auditoria_n70,
		IN_DESCARTADA         = vw.descartada,
		NU_CORRECAO           = CASE WHEN cor.id_tipo_correcao IN (1,2) THEN 1 
								  WHEN cor.id_tipo_correcao = 3      THEN 3 
								  WHEN cor.id_tipo_correcao = 4      THEN 4 
								  WHEN cor.id_tipo_correcao = 7      THEN 5 ELSE 1000 END ,
		CO_SITUACAO_REDACAO   = cor.id_correcao_situacao,
		NU_NOTA_REDACAO	      = cor.nota_final,
		NU_NOTA_COMP1_REDACAO = cor.NOTA_COMPETENCIA1,
		NU_NOTA_COMP2_REDACAO = cor.NOTA_COMPETENCIA2,
		NU_NOTA_COMP3_REDACAO = cor.NOTA_COMPETENCIA3,
		NU_NOTA_COMP4_REDACAO = cor.NOTA_COMPETENCIA4,
		NU_NOTA_COMP5_REDACAO = cor.NOTA_COMPETENCIA5
		INTO #TMP_DESCARTADA
		  from [' + @data_char + '].correcoes_correcao cor join [' + @data_char + '].correcoes_correcao      aud on (cor.redacao_id = aud.redacao_id and 
																				                                     aud.id_tipo_correcao = 7)
									                       JOIN [' + @data_char + '].CORRECOES_REDACAO       RED  ON (RED.ID = AUD.redacao_id and 
									 	                    								                         RED.cancelado = 0)
									                       JOIN                      inep_N02                N02  ON (N02.CO_INSCRICAO     = RED.co_inscricao)
									                       JOIN [' + @data_char + '].usuarios_pessoa         PES  ON (PES.usuario_id       = AUD.id_corretor)
									                       join                      correcoes_tipoauditoria tpa  on (tpa.id               = aud.tipo_auditoria_id)
									                       join [' + @data_char + '].vw_descartada_n70       vw   on (vw.redacao_id  = cor.redacao_id and 
																					                                  vw.id_tipo_correcao  = cor.id_tipo_correcao)

		create index ix__TMP_DESCARTADA__redacao_id on #TMP_DESCARTADA(redacao_id)

	insert into inep_n70 (LOTE_ID, CRIADO_EM, REDACAO_ID, CORRECAO_ID, CO_PROJETO, CO_INSCRICAO, SIGLA_UF, NU_CPF, TP_TIPO_CORRECAO, 
                          IN_DESCARTADA, NU_CORRECAO, CO_SITUACAO_REDACAO, NU_NOTA_REDACAO, NU_NOTA_COMP1_REDACAO, NU_NOTA_COMP2_REDACAO, 
                          NU_NOTA_COMP3_REDACAO, NU_NOTA_COMP4_REDACAO, NU_NOTA_COMP5_REDACAO)
		 select lote_id = ' + convert(varchar(10), @lote_id) + ', CRIADO_EM, REDACAO_ID, CORRECAO_ID, CO_PROJETO, CO_INSCRICAO, SIGLA_UF, NU_CPF, TP_TIPO_CORRECAO, 
                          IN_DESCARTADA, NU_CORRECAO, CO_SITUACAO_REDACAO, NU_NOTA_REDACAO, NU_NOTA_COMP1_REDACAO, NU_NOTA_COMP2_REDACAO, 
                          NU_NOTA_COMP3_REDACAO, NU_NOTA_COMP4_REDACAO, NU_NOTA_COMP5_REDACAO
	  from #TMP_DESCARTADA tmp
	  where not exists(select top 1 1 from inep_n70 n70 join inep_lote lote on (n70.redacao_id = tmp.redacao_id and 
	                                                                            lote.id = n70.lote_id and lote.status_id in (4, 2))
					     WHERE N70.CO_SITUACAO_REDACAO <> TMP.CO_SITUACAO_REDACAO OR 
						       N70.NU_NOTA_REDACAO     <> TMP.NU_NOTA_REDACAO     OR 
							   N70.NU_NOTA_COMP1_REDACAO <> TMP.NU_NOTA_COMP1_REDACAO OR 
							   N70.NU_NOTA_COMP2_REDACAO <> TMP.NU_NOTA_COMP2_REDACAO OR
							   N70.NU_NOTA_COMP3_REDACAO <> TMP.NU_NOTA_COMP3_REDACAO OR
							   N70.NU_NOTA_COMP4_REDACAO <> TMP.NU_NOTA_COMP4_REDACAO OR
							   N70.NU_NOTA_COMP5_REDACAO <> TMP.NU_NOTA_COMP5_REDACAO  
	'
	EXEC (@sql)

end
GO
