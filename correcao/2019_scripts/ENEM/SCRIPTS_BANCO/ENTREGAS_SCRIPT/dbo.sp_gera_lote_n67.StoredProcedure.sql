/****** Object:  StoredProcedure [dbo].[sp_gera_lote_n67]    Script Date: 26/12/2019 13:14:39 ******/
DROP PROCEDURE IF EXISTS [dbo].[sp_gera_lote_n67]
GO
/****** Object:  StoredProcedure [dbo].[sp_gera_lote_n67]    Script Date: 26/12/2019 13:14:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE      PROCEDURE [dbo].[sp_gera_lote_n67]
as
begin

	declare @sql        nvarchar(max)
	declare @sql_insert nvarchar(max)

	declare @admin_user_id int
	declare @lote_id       int

	declare @pcd_surdez char(1) = '8'
	declare @pcd_dislexia char(1) = '11'

	declare @data_char char(8) = format(dbo.getlocaldate(), 'yyyyMMdd')
	
	declare @prefixo varchar(50) = 'REDACAO_REFERENCIA'
    declare @tipo int = 7
    declare @interface int = 3
	
	--Copia os dados mais atualizados da correção
	-- exec sp_copia_dados -- movido para a procedure 
	
	--select * from inep_lotetipo
	--select * from inep_lotestatus
	--select * from inep_loteINTERFACE

	-- TESTAR SE O LOTE ESTA PENDENTE DE LIBERACAO (STATUS) E É DO TIPO AVULSO (TIPO) 
	if exists(select top 1 1 from inep_lote where convert(date, criado_em) = convert(date, dbo.getlocaldate()) and tipo_id = @tipo and status_id = 1) begin
		delete from inep_n67 where lote_id in (select id from inep_lote where convert(date, criado_em) = convert(date, dbo.getlocaldate()) and tipo_id = @tipo)
        delete from inep_lote where convert(date, criado_em) = convert(date, dbo.getlocaldate()) and tipo_id = @tipo  AND interface_id = @interface
	end

	insert into inep_lote (nome, status_id, criado_em, tipo_id, interface_id) values (@prefixo + '_' + @data_char + '_' + convert(varchar(10),@tipo), 1, dbo.getlocaldate(), @tipo, @interface)
	set @lote_id = @@IDENTITY
	
	set @sql ='
		SELECT  
	           LOTE_ID = 0, 
			   CRIADO_EM = DBO.GETLOCALDATE(),
			   PROJETO_ID = OUR.id_projeto,
			   our.redacao_id, 
			   our.id                 as redacaoouro_id, 
			   CO_PROJETO             = pro.codigo,
			   TP_ORIGEM              = ' + char(39) + 'F' + char(39) + ',
			   NU_CPF                 = ' + char(39) + '33820018883' + char(39) + ',       
			   CO_PROVA_OURO          = OUR.ID,   
			   TP_REFERENCIA          = OUR.id_redacaotipo,
			   DT_COMPLETA            = CONVERT(VARCHAR(19),right(' + CHAR(39) + '0' + CHAR(39) + '+ convert(varchar(2),day(ISNULL(our.DATA_CRIACAO,' + CHAR(39) + '2019-11-27' + CHAR(39) + '))),2) + ' + CHAR(39) + '/' + CHAR(39) + ' + right(' + CHAR(39) + '0' + CHAR(39) + '+convert(varchar(2),month(ISNULL(our.DATA_CRIACAO,' + CHAR(39) + '2019-11-27' + CHAR(39) + ' ))),2) + ' + CHAR(39) + '/' + CHAR(39) + ' + convert(varchar(4),year(ISNULL(our.DATA_CRIACAO,' + CHAR(39) + '2019-11-27' + CHAR(39) + ' ))) + ' + CHAR(39) + ' ' + CHAR(39) + ' + CONVERT(VARCHAR(30),ISNULL(our.DATA_CRIACAO,' + CHAR(39) + '2019-11-27' + CHAR(39) + ' ),(114))),
			   CO_SITUACAO_REDACAO    = OUR.id_correcao_situacao,
			   VL_RESULTADO_AVALIADOR = OUR.nota_final,
			   VL_NOTA_COMPETENCIA_1  = OUR.nota_competencia1,
			   VL_NOTA_COMPETENCIA_2  = OUR.NOTA_competencia2,
			   VL_NOTA_COMPETENCIA_3  = OUR.NOTA_competencia3,
			   VL_NOTA_COMPETENCIA_4  = OUR.NOTA_competencia4,
			   VL_NOTA_COMPETENCIA_5  = OUR.NOTA_competencia5,
			   CO_ORIGEM_REDACAO      = our.id_origem,
			   CO_JUSTIFICATIVA       = NULL, 
			   IN_FERE_DH             = CASE WHEN OUR.ID_competencia5 = -1 THEN 1 
											 WHEN OUR.ID_competencia5 =  0 THEN 0 ELSE NULL END
			   INTO #TMP_REDOURO
			   FROM [' + @data_char + '].CORRECOES_REDACAOOURO OUR JOIN [' + @data_char + '].projeto_projeto PRO ON (OUR.id_projeto = PRO.ID)

	create index ix__TMP_REDOURO__redacao_id on #TMP_REDOURO(redacao_id)
	create index ix__TMP_REDOURO__redacaoouro_id on #TMP_REDOURO(redacaoouro_id)

	insert into inep_n67 ( LOTE_ID, REDACAO_ID, REDACAOOURO_ID, PROJETO_ID, CRIADO_EM, CO_PROJETO, TP_ORIGEM, NU_CPF, CO_PROVA_OURO, TP_REFERENCIA, 
                          DT_COMPLETA, CO_SITUACAO_REDACAO, VL_RESULTADO_AVALIADOR, VL_NOTA_COMPETENCIA_1, VL_NOTA_COMPETENCIA_2, VL_NOTA_COMPETENCIA_3, 
                          VL_NOTA_COMPETENCIA_4, VL_NOTA_COMPETENCIA_5, CO_ORIGEM_REDACAO, CO_JUSTIFICATIVA, IN_FERE_DH, status_id)
		 select lote_id = ' + convert(varchar(10), @lote_id) + ', REDACAO_ID, REDACAOOURO_ID, PROJETO_ID, CRIADO_EM, CO_PROJETO, TP_ORIGEM, NU_CPF, CO_PROVA_OURO, TP_REFERENCIA, 
                          DT_COMPLETA, CO_SITUACAO_REDACAO, VL_RESULTADO_AVALIADOR, VL_NOTA_COMPETENCIA_1, VL_NOTA_COMPETENCIA_2, VL_NOTA_COMPETENCIA_3, 
                          VL_NOTA_COMPETENCIA_4, VL_NOTA_COMPETENCIA_5, CO_ORIGEM_REDACAO, CO_JUSTIFICATIVA, IN_FERE_DH, status_id = 0
	  from #TMP_REDOURO tmp
	  where not exists(select top 1 1 from inep_n67 n67 join inep_lote lote on (n67.redacaoouro_id = tmp.redacaoouro_id and 
	                                                                            n67.redacao_id     = tmp.redacaO_id     and 
																				N67.CO_PROVA_OURO  = TMP.CO_PROVA_OURO  AND 
																				N67.CO_PROJETO     = TMP.CO_PROJETO     AND
	                                                                            lote.id = n67.lote_id and lote.status_id in (4, 2))
						 WHERE N67.CO_SITUACAO_REDACAO <> TMP.CO_SITUACAO_REDACAO OR 
						       N67.VL_RESULTADO_AVALIADOR <> TMP.VL_RESULTADO_AVALIADOR OR 
							   N67.VL_NOTA_COMPETENCIA_1  <> TMP.VL_NOTA_COMPETENCIA_1  OR 
							   N67.VL_NOTA_COMPETENCIA_2  <> TMP.VL_NOTA_COMPETENCIA_2  OR 
							   N67.VL_NOTA_COMPETENCIA_3  <> TMP.VL_NOTA_COMPETENCIA_3  OR 
							   N67.VL_NOTA_COMPETENCIA_4  <> TMP.VL_NOTA_COMPETENCIA_4  OR 
							   N67.VL_NOTA_COMPETENCIA_5  <> TMP.VL_NOTA_COMPETENCIA_5  
					  )
	'
	EXEC (@sql)

end

GO
