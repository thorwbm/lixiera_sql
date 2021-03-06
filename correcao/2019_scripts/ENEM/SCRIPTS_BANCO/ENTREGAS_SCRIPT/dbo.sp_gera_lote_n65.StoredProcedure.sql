/****** Object:  StoredProcedure [dbo].[sp_gera_lote_n65]    Script Date: 26/12/2019 13:14:39 ******/
DROP PROCEDURE IF EXISTS [dbo].[sp_gera_lote_n65]
GO
/****** Object:  StoredProcedure [dbo].[sp_gera_lote_n65]    Script Date: 26/12/2019 13:14:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE    PROCEDURE [dbo].[sp_gera_lote_n65]
as
begin

	declare @sql        nvarchar(max)	
    declare @sql1       nvarchar(max)
	declare @sql_insert nvarchar(max)

	declare @admin_user_id int
	declare @lote_id       int

	declare @pcd_surdez char(1) = '8'
	declare @pcd_dislexia char(1) = '11'

	declare @data_char char(8) = format(dbo.getlocaldate(), 'yyyyMMdd')
	
	declare @prefixo varchar(50) = 'AVALIADORES'
    declare @tipo int = 6
    declare @interface int = 2
	
	--Copia os dados mais atualizados da correção
	-- exec sp_copia_dados -- movido para a procedure 
	
	--select * from inep_lotetipo
	--select * from inep_lotestatus
	--select * from inep_lote where convert(date, criado_em) = convert(date, dbo.getlocaldate()) and tipo_id = @tipo_12 and status_id = 1

	-- TESTAR SE O LOTE ESTA PENDENTE DE LIBERACAO (STATUS) E É DO TIPO AVULSO (TIPO) 
	if exists(select top 1 1 from inep_lote where convert(date, criado_em) = convert(date, dbo.getlocaldate()) and tipo_id = @tipo and status_id = 1) begin
		delete from inep_n65 where lote_id in (select id from inep_lote where convert(date, criado_em) = convert(date, dbo.getlocaldate()) and tipo_id = @tipo)
        delete from inep_lote where convert(date, criado_em) = convert(date, dbo.getlocaldate()) and tipo_id = @tipo  and interface_id = @interface
	end

	insert into inep_lote (nome, status_id, criado_em, tipo_id, interface_id) values (@prefixo + '_' + @data_char + '_' + convert(varchar(10),@tipo), 1, dbo.getlocaldate(), @tipo, @interface)
	set @lote_id = @@IDENTITY

	--****************************************************************************************
	DECLARE @SQL_VIEW VARCHAR(MAX) 
	SET @SQL_VIEW = N'
		create OR ALTER view [' + @data_char + '].[vw_corretor_suspensao_desligamento] as 
with cte_corretor_suspensao as (
		select   pes.cpf, count(DISTINCT TRO.ID) as qtd_suspensao, max(COR.history_date) as data_suspensao
		  from [' + @data_char + '].status_corretor_trocastatus tro join [' + @data_char + '].usuarios_pessoa        pes on (tro.corretor_id = pes.usuario_id)		  
		                                                       left join [' + @data_char + '].log_correcoes_corretor COR ON (TRO.corretor_id = COR.ID)
		  where status_atual_id = 3
		       AND  COR.observacao =   ''{'' +  CHAR(39) + ''status''+  CHAR(39) +'': {''+  CHAR(39) +''antigo''+  CHAR(39) + '': 1, ''+  CHAR(39) +''novo''+  CHAR(39) +'': 3}}''
		  group by pes.cpf 
)

    , cte_corretor_motivo_suspensao as (
		select DISTINCT pes.cpf, tro.motivo_id
		  from  [' + @data_char + '].status_corretor_trocastatus tro join [' + @data_char + '].usuarios_pessoa     pes on (tro.corretor_id = pes.usuario_id)
		                                                        left join [' + @data_char + '].CORRECOES_SUSPENSAO sus on (tro.corretor_id = sus.id_corretor)
		                                                        left join cte_corretor_suspensao                   cte on (cte.cpf = pes.cpf)
		 where status_atual_id = 3 and 		       
		       CAST(sus.criado_em AS DATE)  = CAST(cte.data_suspensao AS DATE)
)

	, cte_corretor_desligamento as (
		  select  pes.cpf,  max(COR.history_date) as data_desligamento
		    from  [' + @data_char + '].status_corretor_trocastatus tro join [' + @data_char + '].usuarios_pessoa        pes on (tro.corretor_id = pes.usuario_id)
			                                                           JOIN [' + @data_char + '].log_correcoes_corretor COR ON (TRO.corretor_id = COR.ID)
		  where status_atual_id = 4 AND       
		  (COR.observacao =  ''{'' + CHAR(39) + ''status'' + CHAR(39) + '': {'' + CHAR(39) + ''antigo'' + CHAR(39) +  '': 1, ''  + CHAR(39) + ''novo'' + CHAR(39) + '': 4}}'' OR 
		   COR.observacao =  ''{'' + CHAR(39) + ''status'' + CHAR(39) + '': {'' + CHAR(39) + ''antigo'' + CHAR(39) +  '': 3, ''  + CHAR(39) + ''novo'' + CHAR(39) + '': 4}}'')
		  group by pes.cpf
)

    , cte_corretor_motivo_desligamento as (
		select pes.cpf, motivo_id
		  from  [' + @data_char + '].status_corretor_trocastatus tro join [' + @data_char + '].usuarios_pessoa pes on (tro.corretor_id = pes.usuario_id)
		  where tro.id = (select max(trox.id)
		                    from [' + @data_char + '].status_corretor_trocastatus trox join [' + @data_char + '].usuarios_pessoa pesx on (trox.corretor_id = pesx.usuario_id)
		                   where status_atual_id = 4 and pesx.cpf = pes.cpf)
)

		select distinct pes.cpf, sus.data_suspensao, sus.qtd_suspensao, msu.motivo_id as motivo_id_suspensao, 
		        dsl.data_desligamento, mds.motivo_id as motivo_id_desligamento
		  from [' + @data_char + '].correcoes_corretor cor join [' + @data_char + '].usuarios_pessoa pes on (cor.id = pes.usuario_id)
		                                                   left join cte_corretor_suspensao           sus on (pes.cpf = sus.cpf)
									                       left join cte_corretor_motivo_suspensao    msu on (pes.cpf = msu.cpf)
		                                                   left join cte_corretor_desligamento        dsl on (pes.cpf = dsl.cpf)
									                       left join cte_corretor_motivo_desligamento mds on (pes.cpf = mds.cpf)'
EXEC (@SQL_VIEW)
	--****************************************************************************************

	set @sql ='
	select   
            LOTE_ID = 0, 
		    CRIADO_EM = DBO.getlocaldate(),
		    CO_PROJETO          = pro.codigo,
            TP_ORIGEM           = ' + char(39) + 'F' + char(39) +',  
            NU_CPF              = PES.CPF,  
            NO_CORRETOR         = PES.NOME, 
            NO_MAE_CORRETOR     = TMP.nome_mae,				  
            DT_NASCIMENTO       = CONVERT(VARCHAR(19),right(' + CHAR(39) + '0' + CHAR(39) + '+ convert(varchar(2),day(ISNULL(TMP.data_nascimento,' + CHAR(39) + '2019-11-27' + CHAR(39) + '))),2) + ' + CHAR(39) + '/' + CHAR(39) + ' + right(' + CHAR(39) + '0' + CHAR(39) + '+convert(varchar(2),month(ISNULL(TMP.data_nascimento,' + CHAR(39) + '2019-11-27' + CHAR(39) + ' ))),2) + ' + CHAR(39) + '/' + CHAR(39) + ' + convert(varchar(4),year(ISNULL(TMP.data_nascimento,' + CHAR(39) + '2019-11-27' + CHAR(39) + ' )))),				  
            TP_SEXO             = TMP.sexo,						  
            NO_LOGRADOURO       = TMP.Logradouro,						  
            DS_COMPLEMENTO      = TMP.Complemento,					  
            NO_BAIRRO           = TMP.Bairro,							  
            NO_MUNICIPIO        = TMP.Município,				  
            NU_CEP              = TMP.CEP,							  
            CO_MUNICIPIO        = TMP.CO_MUNICIPIO,
            SG_UF               = TMP.UF,					  
            NU_TEL_RESIDENCIAL  = tmp.tel_res,		  
            NU_TEL_CELULAR      = tmp.celular,			  
            TX_EMAIL            = tmp.email,						  
            TP_TITULACAO        = TMP.CO_TITULACAO,                              
            TP_FUNCAO           = CASE WHEN PES.usuario_id IN (SELECT USER_ID FROM auth_user_user_permissions WHERE permission_id = 320) THEN 5
                                       WHEN GRO.ID = 26 THEN 1 
                                       WHEN GRO.ID = 34 THEN 2
                                       WHEN GRO.ID = 25 THEN 3 
                                       WHEN GRO.ID IN (30,29,27) THEN 4
                                       ELSE NULL END , 
            NU_SUSPENSAO        = csd.qtd_suspensao,
            CO_MOTIVO_SUSPENSAO = csd.motivo_id_suspensao , 
            DT_SUSPENSAO        = case when csd.data_suspensao is not null then  CONVERT(VARCHAR(19),right(' + CHAR(39) + '0' + CHAR(39) + '+ convert(varchar(2),day(ISNULL(csd.data_suspensao,' + CHAR(39) + '2019-11-27' + CHAR(39) + '))),2) + ' + CHAR(39) + '/' + CHAR(39) + ' + right(' + CHAR(39) + '0' + CHAR(39) + '+convert(varchar(2),month(ISNULL(csd.data_suspensao,' + CHAR(39) + '2019-11-27' + CHAR(39) + ' ))),2) + ' + CHAR(39) + '/' + CHAR(39) + ' + convert(varchar(4),year(ISNULL(csd.data_suspensao,' + CHAR(39) + '2019-11-27' + CHAR(39) + ' ))) + ' + CHAR(39) + ' ' + CHAR(39) + ' + CONVERT(VARCHAR(30),ISNULL(csd.data_suspensao,' + CHAR(39) + '2019-11-27' + CHAR(39) + ' ),(114))) else null end,
            CO_MOTIVO_EXCLUSAO  = csd.motivo_id_desligamento,
            DT_EXCLUSAO         = case when csd.data_desligamento is not null then  CONVERT(VARCHAR(19),right(' + CHAR(39) + '0' + CHAR(39) + '+ convert(varchar(2),day(ISNULL(csd.data_desligamento,' + CHAR(39) + '2019-11-27' + CHAR(39) + '))),2) + ' + CHAR(39) + '/' + CHAR(39) + ' + right(' + CHAR(39) + '0' + CHAR(39) + '+convert(varchar(2),month(ISNULL(csd.data_desligamento,' + CHAR(39) + '2019-11-27' + CHAR(39) + ' ))),2) + ' + CHAR(39) + '/' + CHAR(39) + ' + convert(varchar(4),year(ISNULL(csd.data_desligamento,' + CHAR(39) + '2019-11-27' + CHAR(39) + ' ))) + ' + CHAR(39) + ' ' + CHAR(39) + ' + CONVERT(VARCHAR(30),ISNULL(csd.data_desligamento,' + CHAR(39) + '2019-11-27' + CHAR(39) + ' ),(114)))  else null end

			into #tmp_avaliador 
             from [' + @data_char + '].usuarios_pessoa pes join [' + @data_char + '].projeto_projeto_usuarios           ppu  on (pes.usuario_id  = ppu.USER_ID)  
                                                           JOIN [' + @data_char + '].auth_user_groups                   USG  ON (USG.user_id     = PES.usuario_id)
            									           join [' + @data_char + '].auth_group                         GRO  ON (GRO.id          = USG.group_id)
                                                           join [' + @data_char + '].projeto_projeto                    pro  on (pro.id          = ppu.projeto_id)
            									           JOIN [' + @data_char + '].CORRECOES_CORRETOR                 COR  ON (COR.ID          = PES.USUARIO_ID )
            							              LEFT JOIN tmp_n65                                                 TMP  ON (TMP.cpf         = PES.CPF)		 
            							              LEFT JOIN [' + @data_char + '].vw_corretor_suspensao_desligamento csd  ON (csd.CPF         = PES.CPF)

	create index ix__tmp_avaliador__NU_CPF on #tmp_avaliador(NU_CPF)'

	set @sql1 =N'
	insert into inep_n65 (LOTE_ID, CRIADO_EM,  CO_PROJETO, TP_ORIGEM, NU_CPF, NO_CORRETOR, NO_MAE_CORRETOR, 
                          DT_NASCIMENTO, TP_SEXO, NO_LOGRADOURO, DS_COMPLEMENTO, NO_BAIRRO, NO_MUNICIPIO, NU_CEP, CO_MUNICIPIO, 
		                  SG_UF, NU_TEL_RESIDENCIAL, NU_TEL_CELULAR, TX_EMAIL, TP_TITULACAO, TP_FUNCAO, NU_SUSPENSAO, CO_MOTIVO_SUSPENSAO, 
		                  DT_SUSPENSAO, CO_MOTIVO_EXCLUSAO, DT_EXCLUSAO, status_id)
		 select distinct LOTE_ID = ' + convert(varchar(10), @lote_id) + ', CRIADO_EM,  CO_PROJETO, TP_ORIGEM, NU_CPF, NO_CORRETOR, NO_MAE_CORRETOR, 
                DT_NASCIMENTO, TP_SEXO, NO_LOGRADOURO, DS_COMPLEMENTO, NO_BAIRRO, NO_MUNICIPIO, NU_CEP, CO_MUNICIPIO, 
		        SG_UF, NU_TEL_RESIDENCIAL, NU_TEL_CELULAR, TX_EMAIL, TP_TITULACAO, TP_FUNCAO, NU_SUSPENSAO, CO_MOTIVO_SUSPENSAO, 
		        DT_SUSPENSAO, CO_MOTIVO_EXCLUSAO, DT_EXCLUSAO, status_id = 0
	  from #tmp_avaliador tmp
	  where TP_TITULACAO is not null and 
	        not exists(select top 1 1 from inep_n65 n65 join inep_lote lote on (n65.NU_CPF = tmp.NU_CPF and 
			                                                                    n65.co_projeto = tmp.co_projeto and 
																				n65.tp_funcao  = tmp.tp_funcao  and 
                                                                                lote.id = n65.lote_id and lote.status_id in (4, 2))
				         where  
											(isnull(N65.NU_SUSPENSAO       ,0)            <> isnull(TMP.NU_SUSPENSAO,0)           	OR 
											 isnull(N65.CO_MOTIVO_SUSPENSAO,0)            <> isnull(TMP.CO_MOTIVO_SUSPENSAO,0)      OR      
											 isnull(N65.DT_SUSPENSAO       ,' + CHAR(39) + '2000-01-01' + CHAR(39) + ') <> isnull(TMP.DT_SUSPENSAO,' + CHAR(39) + '2000-01-01' + CHAR(39) + ')	OR 
											 isnull(N65.CO_MOTIVO_EXCLUSAO ,0)            <> isnull(TMP.CO_MOTIVO_EXCLUSAO ,0)      OR      
											 isnull(N65.DT_EXCLUSAO        ,' + CHAR(39) + '2000-01-01' + CHAR(39) + ') <> isnull(TMP.DT_EXCLUSAO ,' + CHAR(39) + '2000-01-01' + CHAR(39) + ')
                                            )
									   )																
																		
	'
	EXEC (@sql + @SQL1)

end
GO
