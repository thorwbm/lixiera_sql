/****** Object:  StoredProcedure [dbo].[sp_gera_lote_n68]    Script Date: 26/12/2019 13:14:39 ******/
DROP PROCEDURE IF EXISTS [dbo].[sp_gera_lote_n68]
GO
/****** Object:  StoredProcedure [dbo].[sp_gera_lote_n68]    Script Date: 26/12/2019 13:14:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE      PROCEDURE [dbo].[sp_gera_lote_n68]
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
    declare @interface int = 4
	
	--Copia os dados mais atualizados da correção
	-- exec sp_copia_dados -- movido para a procedure 
	
	--select * from inep_lotetipo
	--select * from inep_lotestatus
	--select * from inep_loteINTERFACE

	-- TESTAR SE O LOTE ESTA PENDENTE DE LIBERACAO (STATUS) E É DO TIPO AVULSO (TIPO) 
	if exists(select top 1 1 from inep_lote where convert(date, criado_em) = convert(date, dbo.getlocaldate()) and tipo_id = @tipo and status_id = 1) begin
		delete  from inep_n68 where lote_id in (select id from inep_lote where convert(date, criado_em) = convert(date, dbo.getlocaldate()) and tipo_id = @tipo)
        delete  from inep_lote where convert(date, criado_em) = convert(date, dbo.getlocaldate()) and tipo_id = @tipo AND interface_id = @interface
	end

	insert into inep_lote (nome, status_id, criado_em, tipo_id, interface_id) values (@prefixo + '_' + @data_char + '_' + convert(varchar(10),@tipo), 1, dbo.getlocaldate(), @tipo, @interface)
	set @lote_id = @@IDENTITY
	
	set @sql ='
		SELECT 
		   LOTE_ID = 0, 
		   PROJETO_ID = PRO.ID, 
		   CRIADO_EM  = DBO.GETLOCALDATE(), 
		   CORRECAO_ID           = COR.ID,
		   REDACAO_ID            = RED.ID,
		   CORRETOR_ID           = COR.id_corretor,
		   CO_PROJETO            = PRO.CODIGO,
		   TP_ORIGEM             = ' + CHAR(39) + 'F'  + CHAR(39) + ',
		   CO_PROVA_OURO         = ROU.id,
		   NU_CPF                = pes.cpf,
		   TP_REFERENCIA         = rou.id_redacaotipo,
		   DT_INICIO             = CONVERT(VARCHAR(19),right(' + CHAR(39) + '0' + CHAR(39) + '+ convert(varchar(2),day(ISNULL(COR.data_inicio,' + CHAR(39) + '2019-11-27' + CHAR(39) + '))),2) + ' + CHAR(39) + '/' + CHAR(39) + ' + right(' + CHAR(39) + '0' + CHAR(39) + '+convert(varchar(2),month(ISNULL(COR.data_inicio,' + CHAR(39) + '2019-11-27' + CHAR(39) + ' ))),2) + ' + CHAR(39) + '/' + CHAR(39) + ' + convert(varchar(4),year(ISNULL(COR.data_inicio,' + CHAR(39) + '2019-11-27' + CHAR(39) + ' ))) + ' + CHAR(39) + ' ' + CHAR(39) + ' + CONVERT(VARCHAR(30),ISNULL(COR.data_inicio,' + CHAR(39) + '2019-11-27' + CHAR(39) + ' ),(114))),
		   DT_FIM                = CONVERT(VARCHAR(19),right(' + CHAR(39) + '0' + CHAR(39) + '+ convert(varchar(2),day(ISNULL(COR.data_termino,' + CHAR(39) + '2019-11-27' + CHAR(39) + '))),2) + ' + CHAR(39) + '/' + CHAR(39) + ' + right(' + CHAR(39) + '0' + CHAR(39) + '+convert(varchar(2),month(ISNULL(COR.data_termino,' + CHAR(39) + '2019-11-27' + CHAR(39) + ' ))),2) + ' + CHAR(39) + '/' + CHAR(39) + ' + convert(varchar(4),year(ISNULL(COR.data_termino,' + CHAR(39) + '2019-11-27' + CHAR(39) + ' ))) + ' + CHAR(39) + ' ' + CHAR(39) + ' + CONVERT(VARCHAR(30),ISNULL(COR.data_termino,' + CHAR(39) + '2019-11-27' + CHAR(39) + ' ),(114))),
		   CO_SITUACAO_REDACAO   = COR.id_correcao_situacao,
		   NU_NOTA_REDACAO       = COR.nota_final,
		   NU_NOTA_COMP1_REDACAO = COR.nota_competencia1,
		   NU_NOTA_COMP2_REDACAO = COR.nota_competencia2,
		   NU_NOTA_COMP3_REDACAO = COR.nota_competencia3,
		   NU_NOTA_COMP4_REDACAO = COR.nota_competencia4,
		   NU_NOTA_COMP5_REDACAO = COR.nota_competencia5,
		   CO_JUSTIFICATIVA      = NULL
             INTO #TMP_REDOURO     
		  FROM [' + @data_char + '].CORRECOES_REDACAO RED join [' + @data_char + '].correcoes_redacaoouro rou on (rou.id = red.id_redacaoouro)
									                      JOIN [' + @data_char + '].projeto_projeto       PRO ON (PRO.ID = RED.id_projeto)
									                      JOIN [' + @data_char + '].CORRECOES_CORRECAO    COR ON (RED.ID = COR.REDACAO_ID)
									                      JOIN [' + @data_char + '].usuarios_pessoa       pes ON (COR.id_corretor = pes.usuario_id)
		WHERE  
			  cor.id_status = 3

	create index ix__TMP_REDOURO__redacao_id on #TMP_REDOURO(redacao_id)
	create index ix__TMP_REDOURO__correcao_id on #TMP_REDOURO(correcao_id)
	create index ix__TMP_REDOURO__corretor_id on #TMP_REDOURO(corretor_id)

	insert into inep_n68 (  LOTE_ID, PROJETO_ID, CRIADO_EM, CORRECAO_ID, REDACAO_ID, CORRETOR_ID, CO_PROJETO, TP_ORIGEM, CO_PROVA_OURO, 
                           NU_CPF, TP_REFERENCIA, DT_INICIO, DT_FIM, CO_SITUACAO_REDACAO, NU_NOTA_REDACAO, NU_NOTA_COMP1_REDACAO, 
                           NU_NOTA_COMP2_REDACAO, NU_NOTA_COMP3_REDACAO, NU_NOTA_COMP4_REDACAO, NU_NOTA_COMP5_REDACAO, CO_JUSTIFICATIVA)
		 select lote_id = ' + convert(varchar(10), @lote_id) + ', PROJETO_ID, CRIADO_EM, CORRECAO_ID, REDACAO_ID, CORRETOR_ID, CO_PROJETO, TP_ORIGEM, CO_PROVA_OURO, 
                           NU_CPF, TP_REFERENCIA, DT_INICIO, DT_FIM, CO_SITUACAO_REDACAO, NU_NOTA_REDACAO, NU_NOTA_COMP1_REDACAO, 
                           NU_NOTA_COMP2_REDACAO, NU_NOTA_COMP3_REDACAO, NU_NOTA_COMP4_REDACAO, NU_NOTA_COMP5_REDACAO, CO_JUSTIFICATIVA 
	           
	  from #TMP_REDOURO tmp
	  where not exists(select top 1 1 from inep_n68 n68 join inep_lote lote on (n68.CO_PROVA_OURO = tmp.CO_PROVA_OURO and 
	                                                                            n68.redacao_id    = tmp.redacao_id    and 
																				N68.NU_CPF        = TMP.NU_CPF        AND 
																				N68.CO_PROJETO    = TMP.CO_PROJETO    AND
	                                                                            lote.id = n68.lote_id and lote.status_id in (4, 2))
						WHERE N68.CO_SITUACAO_REDACAO   <> TMP.CO_SITUACAO_REDACAO   OR 
						      N68.NU_NOTA_REDACAO       <> TMP.NU_NOTA_REDACAO       OR 
							  N68.NU_NOTA_COMP1_REDACAO <> TMP.NU_NOTA_COMP1_REDACAO OR 
							  N68.NU_NOTA_COMP2_REDACAO <> TMP.NU_NOTA_COMP2_REDACAO OR 
							  N68.NU_NOTA_COMP3_REDACAO <> TMP.NU_NOTA_COMP3_REDACAO OR 
							  N68.NU_NOTA_COMP4_REDACAO <> TMP.NU_NOTA_COMP4_REDACAO OR 
							  N68.NU_NOTA_COMP5_REDACAO <> TMP.NU_NOTA_COMP5_REDACAO 
					   )
	'
	EXEC (@sql)

end
GO
