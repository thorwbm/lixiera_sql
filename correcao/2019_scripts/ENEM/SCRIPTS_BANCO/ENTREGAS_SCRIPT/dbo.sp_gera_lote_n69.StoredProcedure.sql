/****** Object:  StoredProcedure [dbo].[sp_gera_lote_n69]    Script Date: 26/12/2019 13:14:39 ******/
DROP PROCEDURE IF EXISTS [dbo].[sp_gera_lote_n69]
GO
/****** Object:  StoredProcedure [dbo].[sp_gera_lote_n69]    Script Date: 26/12/2019 13:14:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE      PROCEDURE [dbo].[sp_gera_lote_n69]
as
begin

	declare @sql        nvarchar(max)
	declare @sql_insert nvarchar(max)

	declare @admin_user_id int
	declare @lote_id       int

	declare @pcd_surdez char(1) = '8'
	declare @pcd_dislexia char(1) = '11'

	declare @data_char char(8) = format(dbo.getlocaldate(), 'yyyyMMdd')
	
	declare @prefixo varchar(50) = 'DESEMPENHO'
    declare @tipo int = 6
    declare @interface int = 5
	
	--Copia os dados mais atualizados da correção
	-- exec sp_copia_dados -- movido para a procedure 
	
	--select * from inep_lotetipo
	--select * from inep_lotestatus
	--select * from inep_loteINTERFACE

	-- TESTAR SE O LOTE ESTA PENDENTE DE LIBERACAO (STATUS) E É DO TIPO AVULSO (TIPO) 
	if exists(select top 1 1 from inep_lote where convert(date, criado_em) = convert(date, dbo.getlocaldate()) and tipo_id = @tipo and status_id = 1) begin
		delete from inep_n69 where lote_id in (select id from inep_lote where convert(date, criado_em) = convert(date, dbo.getlocaldate()) and tipo_id = @tipo)
        delete from inep_lote where convert(date, criado_em) = convert(date, dbo.getlocaldate()) and tipo_id = @tipo and interface_id = @interface
	end

	insert into inep_lote (nome, status_id, criado_em, tipo_id, interface_id) values (@prefixo + '_' + @data_char + '_' + convert(varchar(10),@tipo), 1, dbo.getlocaldate(), @tipo, @interface)
	set @lote_id = @@IDENTITY
	
	set @sql ='
		select  
			   ID                   = 0,
			   LOTE_ID              = 0,
			   PROJETO_ID           = PRO.ID, 
			   USUARIO_ID           = PES.USUARIO_ID, 
			   CRIADO_EM            = DBO.GETLOCALDATE(),
			   CO_PROJETO           = PRO.codigo,
			   TP_ORIGEM            = ' + char(39) + 'F' + char(39) + ',
			   NU_CPF               = pes.cpf,
			   DT_AVALIACAO         = CONVERT(VARCHAR(19),right(' + CHAR(39) + '0' + CHAR(39) + '+ convert(varchar(2),day(ISNULL(IND.DATA_CALCULO,' + CHAR(39) + '2019-11-27' + CHAR(39) + '))),2) + ' + CHAR(39) + '/' + CHAR(39) + ' + right(' + CHAR(39) + '0' + CHAR(39) + '+convert(varchar(2),month(ISNULL(IND.DATA_CALCULO,' + CHAR(39) + '2019-11-27' + CHAR(39) + ' ))),2) + ' + CHAR(39) + '/' + CHAR(39) + ' + convert(varchar(4),year(ISNULL(IND.DATA_CALCULO,' + CHAR(39) + '2019-11-27' + CHAR(39) + ' ))) + ' + CHAR(39) + ' ' + CHAR(39) + ' + CONVERT(VARCHAR(30),ISNULL(IND.DATA_CALCULO,' + CHAR(39) + '2019-11-27' + CHAR(39) + ' ),(114))),
			   NU_INDICE_DESEMPENHO = IND.DSP,
			   NU_LOTE              = NULL
			   INTO #TMP_DSP
			from [' + @data_char + '].correcoes_corretor_indicadores ind JOIN [' + @data_char + '].projeto_projeto    PRO ON (PRO.ID = IND.projeto_id) 
													                     JOIN [' + @data_char + '].usuarios_pessoa    pes on (ind.usuario_id = pes.usuario_id)

	create index ix__TMP_DSP__usuario_id on #TMP_DSP(usuario_id)

	insert into inep_n69 (LOTE_ID, PROJETO_ID, USUARIO_ID, CRIADO_EM, 
	                      CO_PROJETO, TP_ORIGEM, NU_CPF, DT_AVALIACAO, NU_INDICE_DESEMPENHO, NU_LOTE)
		 select lote_id = ' + convert(varchar(10), @lote_id) + ', PROJETO_ID, USUARIO_ID, CRIADO_EM, 
	                      CO_PROJETO, TP_ORIGEM, NU_CPF, DT_AVALIACAO, NU_INDICE_DESEMPENHO, NU_LOTE
	           
	  from #TMP_DSP tmp
	  where not exists(select top 1 1 from inep_n69 n69 join inep_lote lote on (N69.DT_AVALIACAO = TMP.DT_AVALIACAO AND
																				N69.CO_PROJETO   = TMP.CO_PROJETO   AND 
																				N69.NU_CPF       = TMP.NU_CPF       AND 
	                                                                            lote.id = n69.lote_id and lote.status_id in (4, 2))
					     WHERE N69.NU_INDICE_DESEMPENHO <> TMP.NU_INDICE_DESEMPENHO
					   )
	'
	EXEC (@sql)

end
GO
