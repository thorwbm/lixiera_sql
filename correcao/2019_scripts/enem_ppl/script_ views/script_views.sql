/****** Object:  View [dbo].[vw_corretor_suspensao_desligamento]    Script Date: 06/01/2020 10:26:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

		create or alter    view [dbo].[vw_corretor_suspensao_desligamento] as 
with cte_corretor_suspensao as (
		select   pes.cpf, count(DISTINCT TRO.ID) as qtd_suspensao, max(COR.history_date) as data_suspensao
		  from status_corretor_trocastatus tro join usuarios_pessoa        pes on (tro.corretor_id = pes.usuario_id)		  
		                                                       left join log_correcoes_corretor COR ON (TRO.corretor_id = COR.ID)
		  where status_atual_id = 3
		       AND  COR.observacao =   '{' +  CHAR(39) + 'status'+  CHAR(39) +': {'+  CHAR(39) +'antigo'+  CHAR(39) + ': 1, '+  CHAR(39) +'novo'+  CHAR(39) +': 3}}'
		  group by pes.cpf 
)

    , cte_corretor_motivo_suspensao as (
		select DISTINCT pes.cpf, tro.motivo_id
		  from  status_corretor_trocastatus tro join usuarios_pessoa     pes on (tro.corretor_id = pes.usuario_id)
		                                                        left join CORRECOES_SUSPENSAO sus on (tro.corretor_id = sus.id_corretor)
		                                                        left join cte_corretor_suspensao                   cte on (cte.cpf = pes.cpf)
		 where status_atual_id = 3 and 		       
		       CAST(sus.criado_em AS DATE)  = CAST(cte.data_suspensao AS DATE)
)

	, cte_corretor_desligamento as (
		  select  pes.cpf,  max(COR.history_date) as data_desligamento
		    from  status_corretor_trocastatus tro join usuarios_pessoa        pes on (tro.corretor_id = pes.usuario_id)
			                                                           JOIN log_correcoes_corretor COR ON (TRO.corretor_id = COR.ID)
		  where status_atual_id = 4 AND       
		  (COR.observacao =  '{' + CHAR(39) + 'status' + CHAR(39) + ': {' + CHAR(39) + 'antigo' + CHAR(39) +  ': 1, '  + CHAR(39) + 'novo' + CHAR(39) + ': 4}}' OR 
		   COR.observacao =  '{' + CHAR(39) + 'status' + CHAR(39) + ': {' + CHAR(39) + 'antigo' + CHAR(39) +  ': 3, '  + CHAR(39) + 'novo' + CHAR(39) + ': 4}}')
		  group by pes.cpf
)

    , cte_corretor_motivo_desligamento as (
		select pes.cpf, motivo_id
		  from  status_corretor_trocastatus tro join usuarios_pessoa pes on (tro.corretor_id = pes.usuario_id)
		  where tro.id = (select max(trox.id)
		                    from status_corretor_trocastatus trox join usuarios_pessoa pesx on (trox.corretor_id = pesx.usuario_id)
		                   where status_atual_id = 4 and pesx.cpf = pes.cpf)
)

		select distinct pes.cpf, sus.data_suspensao, sus.qtd_suspensao, msu.motivo_id as motivo_id_suspensao, 
		        dsl.data_desligamento, mds.motivo_id as motivo_id_desligamento
		  from correcoes_corretor cor join usuarios_pessoa pes on (cor.id = pes.usuario_id)
		                                                   left join cte_corretor_suspensao           sus on (pes.cpf = sus.cpf)
									                       left join cte_corretor_motivo_suspensao    msu on (pes.cpf = msu.cpf)
		                                                   left join cte_corretor_desligamento        dsl on (pes.cpf = dsl.cpf)
									                       left join cte_corretor_motivo_desligamento mds on (pes.cpf = mds.cpf)


GO
/****** Object:  View [dbo].[VW_N65_DADOS_AVALIADORES_REDACAO_ENEM]    Script Date: 06/01/2020 10:26:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create or alter    VIEW [dbo].[VW_N65_DADOS_AVALIADORES_REDACAO_ENEM] AS   
select   
 LOTE_ID = 0, 
 CRIADO_EM = DBO.getlocaldate(),
 CORRETOR_ID         = COR.ID, 
 PROJETO_ID          = PRO.ID, 
 CO_PROJETO          = pro.codigo,  
 TP_ORIGEM           = 'F',  
 NU_CPF              = PES.CPF,  
 NO_CORRETOR         = PES.NOME, 
 NO_MAE_CORRETOR     = TMP.nome_mae,				  --  ########################################
 DT_NASCIMENTO       = TMP.data_nascimento,				  --  ########################################
 TP_SEXO             = TMP.sexo,						  --  ########################################
 NO_LOGRADOURO       = TMP.Logradouro,						  --  ########################################
 DS_COMPLEMENTO      = TMP.Complemento,					  --  ########################################
 NO_BAIRRO           = TMP.Bairro,							  --  ########################################
 NO_MUNICIPIO        = TMP.Município,				  --  ########################################
 NU_CEP              = TMP.CEP,							  --  ########################################
 CO_MUNICIPIO        = TMP.co_municipio,
 SG_UF               = TMP.UF,					  --  ########################################
 NU_TEL_RESIDENCIAL  = tmp.tel_res,		  --  ########################################
 NU_TEL_CELULAR      = tmp.celular,			  --  ########################################
 TX_EMAIL            = tmp.email,						  --  ########################################
 TP_TITULACAO        = TMP.co_titulacao,                              --  ########################################
 TP_FUNCAO           = CASE WHEN PES.usuario_id IN (SELECT USER_ID FROM auth_user_user_permissions WHERE permission_id = 320) THEN 5
                            WHEN GRO.ID = 26 THEN 1 
                            WHEN GRO.ID = 34 THEN 2
                            WHEN GRO.ID = 25 THEN 3 
                            WHEN GRO.ID IN (30,29,27) THEN 4
                            ELSE NULL END , 
 NU_SUSPENSAO        = csd.qtd_suspensao,
 CO_MOTIVO_SUSPENSAO = csd.motivo_id_suspensao , 
 DT_SUSPENSAO        = csd.data_suspensao,
 CO_MOTIVO_EXCLUSAO  = csd.motivo_id_desligamento,
 DT_EXCLUSAO         = csd.data_desligamento
  from usuarios_pessoa pes           join projeto_projeto_usuarios           ppu  on (pes.usuario_id = ppu.USER_ID)  
                                     JOIN auth_user_groups                   USG  ON (USG.user_id = PES.usuario_id)
									 join auth_group                         GRO  ON (GRO.id      = USG.group_id)
                                     join projeto_projeto                    pro  on (pro.id = ppu.projeto_id)
									 JOIN CORRECOES_CORRETOR                 COR  ON (COR.ID = PES.USUARIO_ID )
							    LEFT JOIN tmp_n65                            TMP  ON (TMP.cpf = PES.CPF)		 
								LEFT JOIN vw_corretor_suspensao_desligamento csd  ON (csd.CPF = PES.cpf)
GO
/****** Object:  View [dbo].[vw_entregas_n59]    Script Date: 06/01/2020 10:26:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create or alter  view [dbo].[vw_entregas_n59] as
select lote.nome as lote, lote.data_liberacao, lote.tipo_id,
n59.id, n59.redacao_id, n59.lote_id, n59.projeto_id, n59.criado_em, n59.data_inicio, n59.data_termino, n59.tp_origem, n59.co_inscricao, n59.co_etapa, n59.sg_uf_prova, n59.nu_conceito_max_competencia1, n59.nu_conceito_max_competencia2, n59.nu_conceito_max_competencia3, n59.nu_conceito_max_competencia4, n59.nu_conceito_max_competencia5, n59.co_tipo_avaliacao, n59.link_imagem_recortada, n59.nu_cpf_av1, n59.dt_inicio_av1, n59.dt_fim_av1, n59.nu_tempo_av1, n59.id_lote_av1, n59.co_situacao_redacao_av1, n59.sg_situacao_redacao_av1, n59.nu_nota_av1, n59.nu_nota_comp1_av1, n59.nu_nota_comp2_av1, n59.nu_nota_comp3_av1, n59.nu_nota_comp4_av1, n59.nu_nota_comp5_av1, n59.in_fere_dh_av1, n59.nu_cpf_av2, n59.dt_inicio_av2, n59.dt_fim_av2, n59.nu_tempo_av2, n59.id_lote_av2, n59.co_situacao_redacao_av2, n59.sg_situacao_redacao_av2, n59.nu_nota_av2, n59.nu_nota_comp1_av2, n59.nu_nota_comp2_av2, n59.nu_nota_comp3_av2, n59.nu_nota_comp4_av2, n59.nu_nota_comp5_av2, n59.in_fere_dh_av2, n59.nu_cpf_av3, n59.dt_inicio_av3, n59.dt_fim_av3, n59.nu_tempo_av3, n59.id_lote_av3, n59.co_situacao_redacao_av3, n59.sg_situacao_redacao_av3, n59.nu_nota_av3, n59.nu_nota_comp1_av3, n59.nu_nota_comp2_av3, n59.nu_nota_comp3_av3, n59.nu_nota_comp4_av3, n59.nu_nota_comp5_av3, n59.in_fere_dh_av3, n59.nu_cpf_av4, n59.dt_inicio_av4, n59.dt_fim_av4, n59.nu_tempo_av4, n59.id_lote_av4, n59.co_situacao_redacao_av4, n59.sg_situacao_redacao_av4, n59.nu_nota_av4, n59.nu_nota_comp1_av4, n59.nu_nota_comp2_av4, n59.nu_nota_comp3_av4, n59.nu_nota_comp4_av4, n59.nu_nota_comp5_av4, n59.in_fere_dh_av4, n59.nu_nota_media_comp1 as nu_nota_comp1_final, n59.nu_nota_media_comp2 as nu_nota_comp2_final, n59.nu_nota_media_comp3 as nu_nota_comp3_final, n59.nu_nota_media_comp4 as nu_nota_comp4_final, n59.nu_nota_media_comp5 as nu_nota_comp5_final, n59.co_situacao_redacao_final, n59.nu_nota_final, n59.in_fere_dh, n59.co_justificativa, n59.nu_cpf_auditor, n59.in_divulgacao, n59.co_projeto
  from inep_n59 n59 join inep_lote lote on lote.id = n59.lote_id
 where lote.status_id = 2
GO
/****** Object:  View [dbo].[vw_entregas_realizadas_n59]    Script Date: 06/01/2020 10:26:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create or alter  view [dbo].[vw_entregas_realizadas_n59] as
select lote.nome as lote, lote.data_liberacao, lote.tipo_id,
n59.id, n59.redacao_id, n59.lote_id, n59.projeto_id, n59.criado_em, n59.data_inicio, n59.data_termino, n59.tp_origem, n59.co_inscricao, n59.co_etapa, n59.sg_uf_prova, n59.nu_conceito_max_competencia1, n59.nu_conceito_max_competencia2, n59.nu_conceito_max_competencia3, n59.nu_conceito_max_competencia4, n59.nu_conceito_max_competencia5, n59.co_tipo_avaliacao, n59.link_imagem_recortada, n59.nu_cpf_av1, n59.dt_inicio_av1, n59.dt_fim_av1, n59.nu_tempo_av1, n59.id_lote_av1, n59.co_situacao_redacao_av1, n59.sg_situacao_redacao_av1, n59.nu_nota_av1, n59.nu_nota_comp1_av1, n59.nu_nota_comp2_av1, n59.nu_nota_comp3_av1, n59.nu_nota_comp4_av1, n59.nu_nota_comp5_av1, n59.in_fere_dh_av1, n59.nu_cpf_av2, n59.dt_inicio_av2, n59.dt_fim_av2, n59.nu_tempo_av2, n59.id_lote_av2, n59.co_situacao_redacao_av2, n59.sg_situacao_redacao_av2, n59.nu_nota_av2, n59.nu_nota_comp1_av2, n59.nu_nota_comp2_av2, n59.nu_nota_comp3_av2, n59.nu_nota_comp4_av2, n59.nu_nota_comp5_av2, n59.in_fere_dh_av2, n59.nu_cpf_av3, n59.dt_inicio_av3, n59.dt_fim_av3, n59.nu_tempo_av3, n59.id_lote_av3, n59.co_situacao_redacao_av3, n59.sg_situacao_redacao_av3, n59.nu_nota_av3, n59.nu_nota_comp1_av3, n59.nu_nota_comp2_av3, n59.nu_nota_comp3_av3, n59.nu_nota_comp4_av3, n59.nu_nota_comp5_av3, n59.in_fere_dh_av3, n59.nu_cpf_av4, n59.dt_inicio_av4, n59.dt_fim_av4, n59.nu_tempo_av4, n59.id_lote_av4, n59.co_situacao_redacao_av4, n59.sg_situacao_redacao_av4, n59.nu_nota_av4, n59.nu_nota_comp1_av4, n59.nu_nota_comp2_av4, n59.nu_nota_comp3_av4, n59.nu_nota_comp4_av4, n59.nu_nota_comp5_av4, n59.in_fere_dh_av4, n59.nu_nota_media_comp1 as nu_nota_comp1_final, n59.nu_nota_media_comp2 as nu_nota_comp2_final, n59.nu_nota_media_comp3 as nu_nota_comp3_final, n59.nu_nota_media_comp4 as nu_nota_comp4_final, n59.nu_nota_media_comp5 as nu_nota_comp5_final, n59.co_situacao_redacao_final, n59.nu_nota_final, n59.in_fere_dh, n59.co_justificativa, n59.nu_cpf_auditor, n59.in_divulgacao, n59.co_projeto
  from inep_n59 n59 join inep_lote lote on lote.id = n59.lote_id and lote.status_id = 4 and substituido_por is null
GO
/****** Object:  View [dbo].[vw_entregas_n59_consolidado]    Script Date: 06/01/2020 10:26:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create or alter  view [dbo].[vw_entregas_n59_consolidado] as
select * from vw_entregas_realizadas_n59 where tipo_id not in (10,11)
union all
select * from vw_entregas_n59 where tipo_id not in (10,11)
GO
/****** Object:  View [dbo].[vw_descartada_n70]    Script Date: 06/01/2020 10:26:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create or alter     view [dbo].[vw_descartada_n70] as    
select  aud.redacao_id,     
        cor.id_tipo_correcao,    
  descartada = case when (isnull(aud.nota_final  ,0) = isnull(cor.nota_final  ,0) and     
                          isnull(aud.competencia1,0) = isnull(cor.competencia1,0) and    
                          isnull(aud.competencia2,0) = isnull(cor.competencia2,0) and    
                          isnull(aud.competencia3,0) = isnull(cor.competencia3,0) and    
                          isnull(aud.competencia4,0) = isnull(cor.competencia4,0) and    
                          isnull(aud.competencia5,0) = isnull(cor.competencia5,0) and    
                          aud.id_correcao_situacao = cor.id_correcao_situacao) then 0 else 1 end    
  from correcoes_correcao aud join correcoes_correcao cor on (aud.redacao_id = cor.redacao_id and     
                                                              aud.id_tipo_correcao = 7 ) 
GO
/****** Object:  View [dbo].[VW_N70_AVALIACOES_REDACOES_DESCARTADAS]    Script Date: 06/01/2020 10:26:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


create or alter    view [dbo].[VW_N70_AVALIACOES_REDACOES_DESCARTADAS] as 
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

  from correcoes_correcao cor join correcoes_correcao      aud on (cor.redacao_id = aud.redacao_id and 
                                                                           aud.id_tipo_correcao = 7)
							  JOIN CORRECOES_REDACAO       RED  ON (RED.ID = AUD.redacao_id and 
							                                      RED.cancelado = 0)
							  JOIN inep_N02                N02  ON (N02.CO_INSCRICAO     = RED.co_inscricao)
							  JOIN usuarios_pessoa         PES  ON (PES.usuario_id       = AUD.id_corretor)
							  join correcoes_tipoauditoria tpa  on (tpa.id               = aud.tipo_auditoria_id)
							  join vw_descartada_n70       vw   on (vw.redacao_id  = cor.redacao_id and 
							                                                   vw.id_tipo_correcao  = cor.id_tipo_correcao)



GO
/****** Object:  View [dbo].[vw_conferencia_nota_avaliador]    Script Date: 06/01/2020 10:26:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create or alter  view [dbo].[vw_conferencia_nota_avaliador] as 
WITH CTE_AVALIADOR_1 AS (
		SELECT REDACAO_ID, LOTE_ID, ERRO = 1 
		  FROM INEP_N59 INE 
		  WHERE (nu_cpf_av1           IS NULL AND 
					(nu_nota_comp1_av1       IS NOT NULL OR 
					 nu_nota_comp2_av1       IS NOT NULL OR 
					 nu_nota_comp3_av1       IS NOT NULL OR 
					 nu_nota_comp4_av1       IS NOT NULL OR 
					 nu_nota_comp5_av1       IS NOT NULL OR 
					 dt_inicio_av1           IS NOT NULL OR 
					 dt_fim_av1              IS NOT NULL OR
					 nu_tempo_av1            IS NOT NULL OR 
					 co_situacao_redacao_av1 IS NOT NULL) 
				) OR 
				(nu_cpf_av1           IS NOT NULL AND 
					(nu_nota_comp1_av1       IS NULL OR 
					 nu_nota_comp2_av1       IS NULL OR 
					 nu_nota_comp3_av1       IS NULL OR 
					 nu_nota_comp4_av1       IS NULL OR 
					 nu_nota_comp5_av1       IS NULL OR 
					 dt_inicio_av1           IS NULL OR 
					 dt_fim_av1              IS NULL OR
					 nu_tempo_av1            IS NULL OR 
					 co_situacao_redacao_av1 IS NULL)
				)
)

	,CTE_AVALIADOR_2 AS (
		SELECT REDACAO_ID, LOTE_ID, ERRO = 2  
		  FROM INEP_N59 INE  
		  WHERE (           nu_cpf_av2 IS NULL AND 
					(nu_nota_comp1_av2 IS NOT NULL OR 
					 nu_nota_comp2_av2 IS NOT NULL OR 
					 nu_nota_comp3_av2 IS NOT NULL OR 
					 nu_nota_comp4_av2 IS NOT NULL OR 
					 nu_nota_comp5_av2 IS NOT NULL OR 
					     dt_inicio_av2 IS NOT NULL OR 
					        dt_fim_av2 IS NOT NULL OR
					      nu_tempo_av2 IS NOT NULL OR 
			   co_situacao_redacao_av2 IS NOT NULL) 
				) OR 
				(           nu_cpf_av2 IS NOT NULL AND 
					(nu_nota_comp1_av2 IS NULL OR 
					 nu_nota_comp2_av2 IS NULL OR 
					 nu_nota_comp3_av2 IS NULL OR 
					 nu_nota_comp4_av2 IS NULL OR 
					 nu_nota_comp5_av2 IS NULL OR 
					     dt_inicio_av2 IS NULL OR 
					        dt_fim_av2 IS NULL OR
					      nu_tempo_av2 IS NULL OR 
			   co_situacao_redacao_av2 IS NULL)
				)
)

	,CTE_AVALIADOR_3 AS (
		SELECT REDACAO_ID, LOTE_ID, ERRO = 3  
		  FROM INEP_N59 INE 
		  WHERE (           nu_cpf_av3 IS NULL AND 
					(nu_nota_comp1_av3 IS NOT NULL OR 
					 nu_nota_comp2_av3 IS NOT NULL OR 
					 nu_nota_comp3_av3 IS NOT NULL OR 
					 nu_nota_comp4_av3 IS NOT NULL OR 
					 nu_nota_comp5_av3 IS NOT NULL OR 
					     dt_inicio_av3 IS NOT NULL OR 
					        dt_fim_av3 IS NOT NULL OR
					      nu_tempo_av3 IS NOT NULL OR 
			   co_situacao_redacao_av3 IS NOT NULL) 
				) OR 
				(           nu_cpf_av3 IS NOT NULL AND 
					(nu_nota_comp1_av3 IS NULL OR 
					 nu_nota_comp2_av3 IS NULL OR 
					 nu_nota_comp3_av3 IS NULL OR 
					 nu_nota_comp4_av3 IS NULL OR 
					 nu_nota_comp5_av3 IS NULL OR 
					     dt_inicio_av3 IS NULL OR 
					        dt_fim_av3 IS NULL OR
					      nu_tempo_av3 IS NULL OR 
			   co_situacao_redacao_av3 IS NULL)
				)
)

	,CTE_AVALIADOR_4 AS (
		SELECT REDACAO_ID, LOTE_ID, ERRO = 4  
		  FROM INEP_N59 INE 
		  WHERE (           nu_cpf_av4 IS NULL AND 
					(nu_nota_comp1_av4 IS NOT NULL OR 
					 nu_nota_comp2_av4 IS NOT NULL OR 
					 nu_nota_comp3_av4 IS NOT NULL OR 
					 nu_nota_comp4_av4 IS NOT NULL OR 
					 nu_nota_comp5_av4 IS NOT NULL OR 
					     dt_inicio_av4 IS NOT NULL OR 
					        dt_fim_av4 IS NOT NULL OR
					      nu_tempo_av4 IS NOT NULL OR 
			   co_situacao_redacao_av4 IS NOT NULL) 
				) OR 
				(           nu_cpf_av4 IS NOT NULL AND 
					(nu_nota_comp1_av4 IS NULL OR 
					 nu_nota_comp2_av4 IS NULL OR 
					 nu_nota_comp3_av4 IS NULL OR 
					 nu_nota_comp4_av4 IS NULL OR 
					 nu_nota_comp5_av4 IS NULL OR 
					     dt_inicio_av4 IS NULL OR 
					        dt_fim_av4 IS NULL OR
					      nu_tempo_av4 IS NULL OR 
			   co_situacao_redacao_av4 IS NULL)
				)
)

	SELECT * FROM CTE_AVALIADOR_1
	UNION 
	SELECT * FROM CTE_AVALIADOR_2
	UNION 
	SELECT * FROM CTE_AVALIADOR_3
	UNION 
	SELECT * FROM CTE_AVALIADOR_4



	
GO
/****** Object:  View [dbo].[vw_entregas_n59_br]    Script Date: 06/01/2020 10:26:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


GO
/****** Object:  View [dbo].[vw_entregas_n65]    Script Date: 06/01/2020 10:26:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create or alter    view [dbo].[vw_entregas_n65] as
select lot.nome as lote, lot.data_liberacao, n65.ID, n65.LOTE_ID, n65.CRIADO_EM, n65.CO_PROJETO, n65.TP_ORIGEM, n65.NU_CPF, n65.NO_CORRETOR, n65.NO_MAE_CORRETOR, 
       DT_NASCIMENTO = CONVERT(VARCHAR(19),right('0'+ convert(varchar(2),day(ISNULL(n65.DT_NASCIMENTO,'1901-01-01'))),2) + '/' + right('0'+convert(varchar(2),month(ISNULL(n65.DT_NASCIMENTO,'1901-01-01' ))),2) + '/' + convert(varchar(4),year(ISNULL(n65.DT_NASCIMENTO,'1901-01-01' )))),				  
	   n65.TP_SEXO, n65.NO_LOGRADOURO, n65.DS_COMPLEMENTO, n65.NO_BAIRRO, n65.NO_MUNICIPIO, n65.NU_CEP, 
	   n65.CO_MUNICIPIO, n65.SG_UF, n65.NU_TEL_RESIDENCIAL, n65.NU_TEL_CELULAR, n65.TX_EMAIL, n65.TP_TITULACAO, n65.TP_FUNCAO, 
	   n65.NU_SUSPENSAO, n65.CO_MOTIVO_SUSPENSAO, 
	   DT_SUSPENSAO = CONVERT(VARCHAR(19),right('0'+ convert(varchar(2),day(n65.DT_SUSPENSAO)),2) + '/' + right('0'+convert(varchar(2),month(n65.DT_SUSPENSAO)),2) + '/' + convert(varchar(4),year(n65.DT_SUSPENSAO))),
	   n65.CO_MOTIVO_EXCLUSAO, 
	   DT_EXCLUSAO = CONVERT(VARCHAR(19),right('0'+ convert(varchar(2),day(n65.DT_EXCLUSAO)),2) + '/' + right('0'+convert(varchar(2),month(n65.DT_EXCLUSAO)),2) + '/' + convert(varchar(4),year(n65.DT_EXCLUSAO)))

from INEP_N65 n65 join inep_lote lot on (n65.LOTE_ID = lot.id)
where lot.status_id = 2 
GO
/****** Object:  View [dbo].[vw_entregas_n67]    Script Date: 06/01/2020 10:26:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create or alter    view [dbo].[vw_entregas_n67] as
select  lot.nome as lote, lot.data_liberacao, N67.id, N67.LOTE_ID, N67.REDACAO_ID, N67.REDACAOOURO_ID, N67.PROJETO_ID, N67.CRIADO_EM, N67.CO_PROJETO, N67.TP_ORIGEM,
        N67.NU_CPF, N67.CO_PROVA_OURO, N67.TP_REFERENCIA, N67.DT_COMPLETA, N67.CO_SITUACAO_REDACAO, N67.VL_RESULTADO_AVALIADOR, 
		N67.VL_NOTA_COMPETENCIA_1, N67.VL_NOTA_COMPETENCIA_2, N67.VL_NOTA_COMPETENCIA_3, N67.VL_NOTA_COMPETENCIA_4, N67.VL_NOTA_COMPETENCIA_5, 
		N67.CO_ORIGEM_REDACAO, N67.CO_JUSTIFICATIVA, N67.IN_FERE_DH, N67.status_id

from INEP_N67 n67 join inep_lote lot on (n67.LOTE_ID = lot.id)
where lot.status_id = 2 



GO
/****** Object:  View [dbo].[vw_entregas_n68]    Script Date: 06/01/2020 10:26:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


create or alter      view [dbo].[vw_entregas_n68] as
select  lot.nome as lote, lot.data_liberacao,  n68.ID, n68.LOTE_ID, n68.PROJETO_ID, n68.CRIADO_EM, n68.CORRECAO_ID, n68.REDACAO_ID, n68.CORRETOR_ID, 
        n68.CO_PROJETO, n68.TP_ORIGEM, n68.CO_PROVA_OURO, n68.NU_CPF, n68.TP_REFERENCIA, 
		DT_INICIO = CONVERT(VARCHAR(19),right('0'+ convert(varchar(2),day(n68.DT_INICIO)),2) + '/' + right('0'+convert(varchar(2),month(n68.DT_INICIO)),2) + '/' + convert(varchar(4),year(n68.DT_INICIO)) + ' ' + CONVERT(VARCHAR(30),n68.DT_INICIO,(114))),
	    DT_FIM    = CONVERT(VARCHAR(19),right('0'+ convert(varchar(2),day(n68.DT_FIM)),2) + '/' + right('0'+convert(varchar(2),month(n68.DT_FIM)),2) + '/' + convert(varchar(4),year(n68.DT_FIM)) + ' ' + CONVERT(VARCHAR(30),n68.DT_FIM,(114))), 
		n68.CO_SITUACAO_REDACAO, n68.NU_NOTA_REDACAO, 
		n68.NU_NOTA_COMP1_REDACAO, n68.NU_NOTA_COMP2_REDACAO, n68.NU_NOTA_COMP3_REDACAO, n68.NU_NOTA_COMP4_REDACAO, n68.NU_NOTA_COMP5_REDACAO, n68.CO_JUSTIFICATIVA, 
		n68.status_id

from INEP_N68 n68 join inep_lote lot on (n68.LOTE_ID = lot.id)

where lot.status_id = 2 

GO
/****** Object:  View [dbo].[vw_entregas_n69]    Script Date: 06/01/2020 10:26:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


create or alter      view [dbo].[vw_entregas_n69] as
select  lot.nome as lote, lot.data_liberacao,  n69.ID, n69.LOTE_ID, n69.PROJETO_ID, n69.USUARIO_ID, n69.CRIADO_EM, n69.CO_PROJETO, n69.TP_ORIGEM, 
        n69.NU_CPF, n69.DT_AVALIACAO, n69.NU_INDICE_DESEMPENHO, n69.NU_LOTE, n69.status_id


from INEP_N69 n69 join inep_lote lot on (n69.LOTE_ID = lot.id)
where lot.status_id = 2 

GO
/****** Object:  View [dbo].[vw_entregas_n70]    Script Date: 06/01/2020 10:26:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



create or alter       view [dbo].[vw_entregas_n70] as
select  lot.nome as lote, lot.data_liberacao, n70.ID, n70.LOTE_ID, n70.CRIADO_EM, n70.REDACAO_ID, n70.CORRECAO_ID, n70.CO_PROJETO, n70.CO_INSCRICAO, 
        n70.SIGLA_UF, n70.NU_CPF, n70.TP_TIPO_CORRECAO, n70.IN_DESCARTADA, n70.NU_CORRECAO, n70.CO_SITUACAO_REDACAO, n70.NU_NOTA_REDACAO, 
		n70.NU_NOTA_COMP1_REDACAO, n70.NU_NOTA_COMP2_REDACAO, n70.NU_NOTA_COMP3_REDACAO, n70.NU_NOTA_COMP4_REDACAO, n70.NU_NOTA_COMP5_REDACAO, n70.status_id

from INEP_N70 n70 join inep_lote lot on (n70.LOTE_ID = lot.id)
where lot.status_id = 2 




GO
/****** Object:  View [dbo].[vw_lotes]    Script Date: 06/01/2020 10:26:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create or alter    view [dbo].[vw_lotes] as 
select lote.id as lote_id, lote.nome as lote, interface.nome as interface, data_liberacao, lote.tipo_id
  from inep_lote lote join inep_loteinterface interface on interface.id = lote.interface_id
 where lote.status_id = 2
GO
/****** Object:  View [dbo].[vw_n59]    Script Date: 06/01/2020 10:26:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create or alter  view [dbo].[vw_n59] as
select lote.nome as lote, lote.data_liberacao, lote.data_entrega, n59.*
  from inep_n59 n59 join inep_lote lote on lote.id = n59.lote_id
GO
/****** Object:  View [dbo].[vw_n59_2]    Script Date: 06/01/2020 10:26:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create or alter  view [dbo].[vw_n59_2] as
select 
CO_PROJETO,
TP_ORIGEM,
CO_INSCRICAO,
CO_ETAPA,
SG_UF_PROVA,
convert(int, NU_CONCEITO_MAX_COMPETENCIA1) as NU_CONCEITO_MAX_COMPETENCIA1,
convert(int, NU_CONCEITO_MAX_COMPETENCIA2) as NU_CONCEITO_MAX_COMPETENCIA2,
convert(int, NU_CONCEITO_MAX_COMPETENCIA3) as NU_CONCEITO_MAX_COMPETENCIA3,
convert(int, NU_CONCEITO_MAX_COMPETENCIA4) as NU_CONCEITO_MAX_COMPETENCIA4,
convert(int, NU_CONCEITO_MAX_COMPETENCIA5) as NU_CONCEITO_MAX_COMPETENCIA5,
CO_TIPO_AVALIACAO,
NU_CPF_AV1,
format(DT_INICIO_AV1, 'dd/MM/yyyy HH:mm:ss') as DT_INICIO_AV1,
format(DT_FIM_AV1, 'dd/MM/yyyy HH:mm:ss') as DT_FIM_AV1,
NU_TEMPO_AV1,
ID_LOTE_AV1,
CO_SITUACAO_REDACAO_AV1,
NU_NOTA_AV1,
convert(numeric(5,2), NU_NOTA_COMP1_AV1) as NU_NOTA_COMP1_AV1,
convert(numeric(5,2), NU_NOTA_COMP2_AV1) as NU_NOTA_COMP2_AV1,
convert(numeric(5,2), NU_NOTA_COMP3_AV1) as NU_NOTA_COMP3_AV1,
convert(numeric(5,2), NU_NOTA_COMP4_AV1) as NU_NOTA_COMP4_AV1,
case CO_ETAPA when 1 then null else convert(numeric(5,2), NU_NOTA_COMP5_AV1) end as NU_NOTA_COMP5_AV1,
IN_FERE_DH_AV1,
NU_CPF_AV2,
format(DT_INICIO_AV2, 'dd/MM/yyyy HH:mm:ss') as DT_INICIO_AV2,
format(DT_FIM_AV2, 'dd/MM/yyyy HH:mm:ss') as DT_FIM_AV2,
NU_TEMPO_AV2,
ID_LOTE_AV2,
CO_SITUACAO_REDACAO_AV2,
NU_NOTA_AV2,
convert(numeric(5,2), NU_NOTA_COMP1_AV2) as NU_NOTA_COMP1_AV2,
convert(numeric(5,2), NU_NOTA_COMP2_AV2) as NU_NOTA_COMP2_AV2,
convert(numeric(5,2), NU_NOTA_COMP3_AV2) as NU_NOTA_COMP3_AV2,
convert(numeric(5,2), NU_NOTA_COMP4_AV2) as NU_NOTA_COMP4_AV2,
case CO_ETAPA when 1 then null else convert(numeric(5,2), NU_NOTA_COMP5_AV2) end as NU_NOTA_COMP5_AV2,
IN_FERE_DH_AV2,
NU_CPF_AV3,
format(DT_INICIO_AV3, 'dd/MM/yyyy HH:mm:ss') as DT_INICIO_AV3,
format(DT_FIM_AV3, 'dd/MM/yyyy HH:mm:ss') as DT_FIM_AV3,
NU_TEMPO_AV3,
ID_LOTE_AV3,
CO_SITUACAO_REDACAO_AV3,
NU_NOTA_AV3,
convert(numeric(5,2), NU_NOTA_COMP1_AV3) as NU_NOTA_COMP1_AV3,
convert(numeric(5,2), NU_NOTA_COMP2_AV3) as NU_NOTA_COMP2_AV3,
convert(numeric(5,2), NU_NOTA_COMP3_AV3) as NU_NOTA_COMP3_AV3,
convert(numeric(5,2), NU_NOTA_COMP4_AV3) as NU_NOTA_COMP4_AV3,
case CO_ETAPA when 1 then null else convert(numeric(5,2), NU_NOTA_COMP5_AV3) end as NU_NOTA_COMP5_AV3,
IN_FERE_DH_AV3,
NU_CPF_AV4,
format(DT_INICIO_AV4, 'dd/MM/yyyy HH:mm:ss') as DT_INICIO_AV4,
format(DT_FIM_AV4, 'dd/MM/yyyy HH:mm:ss') as DT_FIM_AV4,
NU_TEMPO_AV4,
ID_LOTE_AV4,
CO_SITUACAO_REDACAO_AV4,
NU_NOTA_AV4,
convert(numeric(5,2), NU_NOTA_COMP1_AV4) as NU_NOTA_COMP1_AV4,
convert(numeric(5,2), NU_NOTA_COMP2_AV4) as NU_NOTA_COMP2_AV4,
convert(numeric(5,2), NU_NOTA_COMP3_AV4) as NU_NOTA_COMP3_AV4,
convert(numeric(5,2), NU_NOTA_COMP4_AV4) as NU_NOTA_COMP4_AV4,
case CO_ETAPA when 1 then null else convert(numeric(5,2), NU_NOTA_COMP5_AV4) end as NU_NOTA_COMP5_AV4,
IN_FERE_DH_AV4,
CO_SITUACAO_REDACAO_FINAL,
convert(numeric(5,2), NU_NOTA_MEDIA_COMP1) as NU_NOTA_MEDIA_COMP1,
convert(numeric(5,2), NU_NOTA_MEDIA_COMP2) as NU_NOTA_MEDIA_COMP2,
convert(numeric(5,2), NU_NOTA_MEDIA_COMP3) as NU_NOTA_MEDIA_COMP3,
convert(numeric(5,2), NU_NOTA_MEDIA_COMP4) as NU_NOTA_MEDIA_COMP4,
convert(numeric(5,2), NU_NOTA_MEDIA_COMP5) as NU_NOTA_MEDIA_COMP5,
NU_NOTA_FINAL,
IN_FERE_DH,
CO_JUSTIFICATIVA,
NU_CPF_AUDITOR,
IN_DIVULGACAO
from inep_n59
GO
/****** Object:  View [dbo].[VW_N67_REDACAO_REFERENCIA_BANCA]    Script Date: 06/01/2020 10:26:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

 create or alter    VIEW [dbo].[VW_N67_REDACAO_REFERENCIA_BANCA] AS 
SELECT 
   LOTE_ID = 0,  
   our.redacao_id, 
   our.id                 as redacaoouro_id, 
   CO_PROJETO             = pro.codigo,
   CRIADO_EM              = DBO.GETLOCALDATE(),
   TP_ORIGEM              = 'F',
   NU_CPF                 = '33820018883',       
   CO_PROVA_OURO          = OUR.ID,   
   TP_REFERENCIA          = OUR.id_redacaotipo,
   DT_COMPLETA            = ISNULL(our.DATA_CRIACAO,'2019-11-27'),
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
   FROM CORRECOES_REDACAOOURO OUR JOIN projeto_projeto PRO ON (OUR.id_projeto = PRO.ID)


GO
/****** Object:  View [dbo].[VW_N68_REDACAO_REFERENCIA_AVALIADORES]    Script Date: 06/01/2020 10:26:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 create or alter     VIEW [dbo].[VW_N68_REDACAO_REFERENCIA_AVALIADORES] AS 
SELECT 
   LOTE_ID = 0, 
   PROJETO_ID = PRO.ID, 
   CRIADO_EM  = DBO.GETLOCALDATE(), 
   CORRECAO_ID           = COR.ID,
   REDACAO_ID            = RED.ID,
   CORRETOR_ID           = COR.id_corretor,
   CO_PROJETO            = PRO.CODIGO,
   TP_ORIGEM             = 'F',
   CO_PROVA_OURO         = ROU.id,
   NU_CPF                = pes.cpf,
   TP_REFERENCIA         = rou.id_redacaotipo,
   DT_INICIO             = COR.data_inicio,
   DT_FIM                = COR.data_termino,
   CO_SITUACAO_REDACAO   = COR.id_correcao_situacao,
   NU_NOTA_REDACAO       = COR.nota_final,
   NU_NOTA_COMP1_REDACAO = COR.nota_competencia1,
   NU_NOTA_COMP2_REDACAO = COR.nota_competencia2,
   NU_NOTA_COMP3_REDACAO = COR.nota_competencia3,
   NU_NOTA_COMP4_REDACAO = COR.nota_competencia4,
   NU_NOTA_COMP5_REDACAO = COR.nota_competencia5,
   CO_JUSTIFICATIVA      = NULL
                  
  FROM CORRECOES_REDACAO RED join correcoes_redacaoouro rou on (rou.id = red.id_redacaoouro)
                             JOIN projeto_projeto       PRO ON (PRO.ID = RED.id_projeto)
                             JOIN CORRECOES_CORRECAO    COR ON (RED.ID = COR.REDACAO_ID)
                             JOIN usuarios_pessoa       pes ON (COR.id_corretor = pes.usuario_id)
WHERE  
      cor.id_status = 3
GO
/****** Object:  View [dbo].[VW_N69_DESEMPENHO_DIARIO_AVALIADORES]    Script Date: 06/01/2020 10:26:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create or alter    VIEW [dbo].[VW_N69_DESEMPENHO_DIARIO_AVALIADORES] AS 
select  
   ID                   = 0,
   LOTE_ID              = 0,
   PROJETO_ID           = PRO.ID, 
   USUARIO_ID           = PES.USUARIO_ID, 
   CRIADO_EM            = DBO.GETLOCALDATE(),
   CO_PROJETO           = PRO.codigo,
   TP_ORIGEM            = 'F',
   NU_CPF               = pes.cpf,
   DT_AVALIACAO         = IND.DATA_CALCULO,
   NU_INDICE_DESEMPENHO = IND.DSP,
   LOTE                 = NULL
from correcoes_corretor_indicadores ind JOIN projeto_projeto    PRO ON (PRO.ID = IND.projeto_id) 
                                        JOIN usuarios_pessoa    pes on (ind.usuario_id = pes.usuario_id)
GO
/****** Object:  View [dbo].[vw_progresso_comparacao_n59]    Script Date: 06/01/2020 10:26:50 ******/

/****** Object:  View [dbo].[vw_rebuild_indices]    Script Date: 06/01/2020 10:26:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create or alter  view [dbo].[vw_rebuild_indices] as
select 'alter index ' + dbindexes.[name] + ' on ' + dbtables.[name] + ' reorganize' as reorg,
       'alter index ' + dbindexes.[name] + ' on ' + dbtables.[name] + ' rebuild with (fillfactor=80, online=on)' as rebuild,
	   indexstats.avg_fragmentation_in_percent
--select count(1)
FROM sys.dm_db_index_physical_stats (DB_ID(), NULL, NULL, NULL, NULL) AS indexstats
INNER JOIN sys.tables dbtables on dbtables.[object_id] = indexstats.[object_id]
INNER JOIN sys.schemas dbschemas on dbtables.[schema_id] = dbschemas.[schema_id]
INNER JOIN sys.indexes AS dbindexes ON dbindexes.[object_id] = indexstats.[object_id]
AND indexstats.index_id = dbindexes.index_id
WHERE 1 = 1 
and indexstats.database_id = DB_ID()
and indexstats.avg_fragmentation_in_percent > 10
--and dbindexes.fill_factor = 10
GO
/****** Object:  View [dbo].[vw_redacao_equidistante]    Script Date: 06/01/2020 10:26:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*****************************************************************************************************************
*                                           [VW_REDACAO_EQUIDISTANTE]                                            *
*                                                                                                                *
*  VIEW QUE RELACIONA TODAS AS REDACOES QUE SAO EQUIDISTANTES                                                    *
*                                                                                                                *
*                                                                                                                *
* BANCO_SISTEMA : ENEM                                                                                           *
* CRIADO POR    : WEMERSON BITTORI MADURO                                                        DATA:23/11/2019 *
* ALTERADO POR  : WEMERSON BITTORI MADURO                                                        DATA:23/11/2019 *
******************************************************************************************************************/

create or alter    view [dbo].[vw_redacao_equidistante] as 
select cor3.redacao_id, 
       cor3.id_projeto, 
       cor3.nota_final as nota_final3, 
       cor2.nota_final as nota_final2, 
	   cor1.nota_final as nota_final1 
  from correcoes_correcao cor3 join correcoes_correcao cor2 on (cor3.redacao_id = cor2.redacao_id and 
                                                                cor3.id_projeto = cor2.id_projeto and 
																cor3.id_tipo_correcao = 3 and
																cor2.id_tipo_correcao = 2)
                               join correcoes_correcao cor1 on (cor3.redacao_id = cor1.redacao_id and 
							                                    cor3.id_projeto = cor1.id_projeto and
																cor1.id_tipo_correcao = 1)
where abs(cor1.nota_final - cor3.nota_final) = abs(cor2.nota_final - cor3.nota_final) and 
      cor3.id_correcao_situacao = 1 and 
	  cor2.id_correcao_situacao = 1 and 
	  cor1.id_correcao_situacao = 1 AND 
	  
	  ABS(cor3.competencia1 - COR1.competencia1) <= 2 AND 
	  ABS(cor3.competencia2 - COR1.competencia2) <= 2 AND 
	  ABS(cor3.competencia3 - COR1.competencia3) <= 2 AND 
	  ABS(cor3.competencia4 - COR1.competencia4) <= 2 AND 
	  ABS(cor3.competencia5 - COR1.competencia5) <= 2 AND 
	  
	  ABS(cor3.competencia1 - COR2.competencia1) <= 2 AND 
	  ABS(cor3.competencia2 - COR2.competencia2) <= 2 AND 
	  ABS(cor3.competencia3 - COR2.competencia3) <= 2 AND 
	  ABS(cor3.competencia4 - COR2.competencia4) <= 2 AND 
	  ABS(cor3.competencia5 - COR2.competencia5) <= 2  


GO
/****** Object:  View [dbo].[vw_util_current_queries]    Script Date: 06/01/2020 10:26:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--##############################################################################################################################################
create or alter    view [dbo].[vw_util_current_queries] as
SELECT
    RIGHT('00' + CAST(DATEDIFF(SECOND, COALESCE(B.start_time, A.login_time), DBO.GETLOCALDATE()) / 86400 AS VARCHAR), 2) + ' ' + 
    RIGHT('00' + CAST((DATEDIFF(SECOND, COALESCE(B.start_time, A.login_time), DBO.GETLOCALDATE()) / 3600) % 24 AS VARCHAR), 2) + ':' + 
    RIGHT('00' + CAST((DATEDIFF(SECOND, COALESCE(B.start_time, A.login_time), DBO.GETLOCALDATE()) / 60) % 60 AS VARCHAR), 2) + ':' + 
    RIGHT('00' + CAST(DATEDIFF(SECOND, COALESCE(B.start_time, A.login_time), DBO.GETLOCALDATE()) % 60 AS VARCHAR), 2) + '.' + 
    RIGHT('000' + CAST(DATEDIFF(SECOND, COALESCE(B.start_time, A.login_time), DBO.GETLOCALDATE()) AS VARCHAR), 3) 
    AS Duration,
    A.session_id AS session_id,
    B.command,
    CAST('<?query --' + CHAR(10) + (
        SELECT TOP 1 SUBSTRING(X.[text], B.statement_start_offset / 2 + 1, ((CASE
                                                                          WHEN B.statement_end_offset = -1 THEN (LEN(CONVERT(NVARCHAR(MAX), X.[text])) * 2)
                                                                          ELSE B.statement_end_offset
                                                                      END
                                                                     ) - B.statement_start_offset
                                                                    ) / 2 + 1
                     )
    ) + CHAR(10) + '--?>' AS XML) AS sql_text,
    CAST('<?query --' + CHAR(10) + X.[text] + CHAR(10) + '--?>' AS XML) AS sql_command,
    A.login_name,
    '(' + CAST(COALESCE(E.wait_duration_ms, B.wait_time) AS VARCHAR(20)) + 'ms)' + COALESCE(E.wait_type, B.wait_type) + COALESCE((CASE 
        WHEN COALESCE(E.wait_type, B.wait_type) LIKE 'PAGEIOLATCH%' THEN ':' + DB_NAME(LEFT(E.resource_description, CHARINDEX(':', E.resource_description) - 1)) + ':' + SUBSTRING(E.resource_description, CHARINDEX(':', E.resource_description) + 1, 999)
        WHEN COALESCE(E.wait_type, B.wait_type) = 'OLEDB' THEN '[' + REPLACE(REPLACE(E.resource_description, ' (SPID=', ':'), ')', '') + ']'
        ELSE ''
    END), '') AS wait_info,
    COALESCE(B.cpu_time, 0) AS CPU,
    COALESCE(F.tempdb_allocations, 0) AS tempdb_allocations,
    COALESCE((CASE WHEN F.tempdb_allocations > F.tempdb_current THEN F.tempdb_allocations - F.tempdb_current ELSE 0 END), 0) AS tempdb_current,
    COALESCE(B.logical_reads, 0) AS reads,
    COALESCE(B.writes, 0) AS writes,
    COALESCE(B.reads, 0) AS physical_reads,
    COALESCE(B.granted_query_memory, 0) AS used_memory,
    NULLIF(B.blocking_session_id, 0) AS blocking_session_id,
    COALESCE(G.blocked_session_count, 0) AS blocked_session_count,
    'KILL ' + CAST(A.session_id AS VARCHAR(10)) AS kill_command,
    (CASE 
        WHEN B.[deadlock_priority] <= -5 THEN 'Low'
        WHEN B.[deadlock_priority] > -5 AND B.[deadlock_priority] < 5 AND B.[deadlock_priority] < 5 THEN 'Normal'
        WHEN B.[deadlock_priority] >= 5 THEN 'High'
    END) + ' (' + CAST(B.[deadlock_priority] AS VARCHAR(3)) + ')' AS [deadlock_priority],
    B.row_count,
    B.open_transaction_count,
    (CASE B.transaction_isolation_level
        WHEN 0 THEN 'Unspecified' 
        WHEN 1 THEN 'ReadUncommitted' 
        WHEN 2 THEN 'ReadCommitted' 
        WHEN 3 THEN 'Repeatable' 
        WHEN 4 THEN 'Serializable' 
        WHEN 5 THEN 'Snapshot'
    END) AS transaction_isolation_level,
    A.[status],
    NULLIF(B.percent_complete, 0) AS percent_complete,
    A.[host_name],
    COALESCE(DB_NAME(CAST(B.database_id AS VARCHAR)), 'master') AS [database_name],
    A.[program_name],
    H.[name] AS resource_governor_group,
    COALESCE(B.start_time, A.last_request_end_time) AS start_time,
    A.login_time,
    COALESCE(B.request_id, 0) AS request_id,
    W.query_plan
FROM
    sys.dm_exec_sessions AS A WITH (NOLOCK)
    LEFT JOIN sys.dm_exec_requests AS B WITH (NOLOCK) ON A.session_id = B.session_id
    JOIN sys.dm_exec_connections AS C WITH (NOLOCK) ON A.session_id = C.session_id AND A.endpoint_id = C.endpoint_id
    LEFT JOIN (
        SELECT
            session_id, 
            wait_type,
            wait_duration_ms,
            resource_description,
            ROW_NUMBER() OVER(PARTITION BY session_id ORDER BY (CASE WHEN wait_type LIKE 'PAGEIO%' THEN 0 ELSE 1 END), wait_duration_ms) AS Ranking
        FROM 
            sys.dm_os_waiting_tasks
    ) E ON A.session_id = E.session_id AND E.Ranking = 1
    LEFT JOIN (
        SELECT
            session_id,
            request_id,
            SUM(internal_objects_alloc_page_count + user_objects_alloc_page_count) AS tempdb_allocations,
            SUM(internal_objects_dealloc_page_count + user_objects_dealloc_page_count) AS tempdb_current
        FROM
            sys.dm_db_task_space_usage
        GROUP BY
            session_id,
            request_id
    ) F ON B.session_id = F.session_id AND B.request_id = F.request_id
    LEFT JOIN (
        SELECT 
            blocking_session_id,
            COUNT(*) AS blocked_session_count
        FROM 
            sys.dm_exec_requests
        WHERE 
            blocking_session_id != 0
        GROUP BY
            blocking_session_id
    ) G ON A.session_id = G.blocking_session_id
    OUTER APPLY sys.dm_exec_sql_text(COALESCE(B.[sql_handle], C.most_recent_sql_handle)) AS X
    OUTER APPLY sys.dm_exec_query_plan(B.[plan_handle]) AS W
    LEFT JOIN sys.dm_resource_governor_workload_groups H ON A.group_id = H.group_id
WHERE
    A.session_id > 50
    AND A.session_id <> @@SPID
    AND (A.[status] != 'sleeping' OR (A.[status] = 'sleeping' AND B.open_transaction_count > 0))

GO
/****** Object:  View [dbo].[VW_VALIDACAO_AUDITORIA]    Script Date: 06/01/2020 10:26:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create or alter    VIEW [dbo].[VW_VALIDACAO_AUDITORIA] AS 
WITH CTE_VALIDACAO_AUDITORIA AS (
		SELECT RED.ID AS REDACAO_ID, TPA.descricao AS TIPO_AUDITORIA, RED.id_projeto AS PROJETO_ID, 
			   COR1.ID AS CORRECAO1, 
			   COR2.ID AS CORRECAO2, 
			   COR3.ID AS CORRECAO3, 
			   COR4.ID AS CORRECAO4, 
			   COR5.ID AS CORRECAO5, 
			   COR6.ID AS CORRECAO6, 
			   COR7.ID AS CORRECAO7,
	   
			   CASE WHEN ISNULL(COR1.NOTA_FINAL,0) = 1000 THEN 1 ELSE 0 END  AS NOTA_FINAL_1, 
			   CASE WHEN ISNULL(COR2.NOTA_FINAL,0) = 1000 THEN 1 ELSE 0 END  AS NOTA_FINAL_2, 
			   CASE WHEN ISNULL(COR3.NOTA_FINAL,0) = 1000 THEN 1 ELSE 0 END  AS NOTA_FINAL_3, 
			   CASE WHEN ISNULL(COR4.NOTA_FINAL,0) = 1000 THEN 1 ELSE 0 END  AS NOTA_FINAL_4, 
			   CASE WHEN ISNULL(COR5.NOTA_FINAL,0) = 1000 THEN 1 ELSE 0 END  AS NOTA_FINAL_5, 
			   CASE WHEN ISNULL(COR6.NOTA_FINAL,0) = 1000 THEN 1 ELSE 0 END  AS NOTA_FINAL_6, 
			   CASE WHEN ISNULL(COR7.NOTA_FINAL,0) = 1000 THEN 1 ELSE 0 END  AS NOTA_FINAL_7,
	   
			   CASE WHEN COR1.competencia5 = -1 THEN 'DDH' ELSE 'NORMAL' END AS DDH_1, 
			   CASE WHEN COR2.competencia5 = -1 THEN 'DDH' ELSE 'NORMAL' END AS DDH_2, 
			   CASE WHEN COR3.competencia5 = -1 THEN 'DDH' ELSE 'NORMAL' END AS DDH_3, 
			   CASE WHEN COR4.competencia5 = -1 THEN 'DDH' ELSE 'NORMAL' END AS DDH_4, 
			   CASE WHEN COR5.competencia5 = -1 THEN 'DDH' ELSE 'NORMAL' END AS DDH_5, 
			   CASE WHEN COR6.competencia5 = -1 THEN 'DDH' ELSE 'NORMAL' END AS DDH_6, 
			   CASE WHEN COR7.competencia5 = -1 THEN 'DDH' ELSE 'NORMAL' END AS DDH_7,
	   
			   CASE WHEN COR1.id_correcao_situacao = 9 THEN 'PD' ELSE 'NORMAL' END AS PD_1, 
			   CASE WHEN COR2.id_correcao_situacao = 9 THEN 'PD' ELSE 'NORMAL' END AS PD_2, 
			   CASE WHEN COR3.id_correcao_situacao = 9 THEN 'PD' ELSE 'NORMAL' END AS PD_3, 
			   CASE WHEN COR4.id_correcao_situacao = 9 THEN 'PD' ELSE 'NORMAL' END AS PD_4, 
			   CASE WHEN COR5.id_correcao_situacao = 9 THEN 'PD' ELSE 'NORMAL' END AS PD_5, 
			   CASE WHEN COR6.id_correcao_situacao = 9 THEN 'PD' ELSE 'NORMAL' END AS PD_6, 
			   CASE WHEN COR7.id_correcao_situacao = 9 THEN 'PD' ELSE 'NORMAL' END AS PD_7

		  FROM CORRECOES_REDACAO RED                   JOIN CORRECOES_CORRECAO      COR7  ON (RED.ID = COR7.REDACAO_ID AND COR7.ID_TIPO_CORRECAO = 7 AND COR7.id_status = 3)
		                                               JOIN CORRECOES_CORRECAO      COR1  ON (RED.ID = COR1.REDACAO_ID AND COR1.ID_TIPO_CORRECAO = 1 AND COR1.id_status = 3)
												       JOIN CORRECOES_CORRECAO      COR2  ON (RED.ID = COR2.REDACAO_ID AND COR2.ID_TIPO_CORRECAO = 2 AND COR2.id_status = 3)
													   JOIN CORRECOES_TIPOAUDITORIA TPA   ON (TPA.ID = COR7.tipo_auditoria_id)
												  LEFT JOIN CORRECOES_CORRECAO      COR3  ON (RED.ID = COR3.REDACAO_ID AND COR3.ID_TIPO_CORRECAO = 3 AND COR3.id_status = 3)
												  LEFT JOIN CORRECOES_CORRECAO      COR4  ON (RED.ID = COR4.REDACAO_ID AND COR4.ID_TIPO_CORRECAO = 4 AND COR4.id_status = 3)
												  LEFT JOIN CORRECOES_CORRECAO      COR5  ON (RED.ID = COR5.REDACAO_ID AND COR5.ID_TIPO_CORRECAO = 5 AND COR5.id_status = 3)
												  LEFT JOIN CORRECOES_CORRECAO      COR6  ON (RED.ID = COR6.REDACAO_ID AND COR6.ID_TIPO_CORRECAO = 6 AND COR6.id_status = 3)
)

	SELECT REDACAO_ID, PROJETO_ID, TIPO_AUDITORIA 
	  FROM CTE_VALIDACAO_AUDITORIA 
	  WHERE (TIPO_AUDITORIA = 'N. MÁXIMA' AND 
				 (	(NOTA_FINAL_1 = 0  AND NOTA_FINAL_2 = 0  AND NOTA_FINAL_3 = 0  AND NOTA_FINAL_4 = 0) AND
				    (NOTA_FINAL_1 = 0  AND NOTA_FINAL_2 = 0  AND NOTA_FINAL_3 = 1  AND NOTA_FINAL_4 = 0) AND  
				    (NOTA_FINAL_1 = 0  AND NOTA_FINAL_2 = 1  AND NOTA_FINAL_3 = 0  AND NOTA_FINAL_4 = 0) AND  
				    (NOTA_FINAL_1 = 0  AND NOTA_FINAL_2 = 1  AND NOTA_FINAL_3 = 1  AND NOTA_FINAL_4 = 1) AND   
				    (NOTA_FINAL_1 = 1  AND NOTA_FINAL_2 = 0  AND NOTA_FINAL_3 = 0  AND NOTA_FINAL_4 = 1) AND  
				    (NOTA_FINAL_1 = 1  AND NOTA_FINAL_2 = 0  AND NOTA_FINAL_3 = 1  AND NOTA_FINAL_4 = 0) AND  
				    (NOTA_FINAL_1 = 1  AND NOTA_FINAL_2 = 1  AND NOTA_FINAL_3 = 0  AND NOTA_FINAL_4 = 1) AND  
				    (NOTA_FINAL_1 = 1  AND NOTA_FINAL_2 = 1  AND NOTA_FINAL_3 = 1  AND NOTA_FINAL_4 = 0) AND  
				    (NOTA_FINAL_1 = 1  AND NOTA_FINAL_2 = 1  AND NOTA_FINAL_3 = 1  AND NOTA_FINAL_4 = 1)   
				)	 
	        )  OR 
			(TIPO_AUDITORIA = 'PD' AND 
				NOT (	(PD_1 = 'NORMAL' AND PD_2 = 'NORMAL' AND PD_3 = 'NORMAL' AND PD_4 = 'PD'    ) OR 
				        (PD_1 = 'NORMAL' AND PD_2 = 'NORMAL' AND PD_3 = 'PD'     AND PD_4 = 'NORMAL') OR   
				        (PD_1 = 'NORMAL' AND PD_2 = 'PD'     AND PD_3 = 'NORMAL' AND PD_4 = 'NORMAL') OR    
				        (PD_1 = 'PD'     AND PD_2 = 'NORMAL' AND PD_3 = 'NORMAL' AND PD_4 = 'NORMAL') OR   
				        (PD_1 = 'PD'     AND PD_2 = 'PD'     AND PD_3 = 'NORMAL' AND PD_4 = 'NORMAL')				     
				)
			) OR 
			(TIPO_AUDITORIA = 'DDH' AND 
				NOT	(	(DDH_1 = 'NORMAL' AND DDH_2 = 'NORMAL' AND DDH_3 = 'NORMAL' AND DDH_4 = 'DDH') OR 
				        (DDH_1 = 'NORMAL' AND DDH_2 = 'NORMAL' AND DDH_3 = 'DDH'    AND DDH_4 = 'NORMAL') OR   
				        (DDH_1 = 'NORMAL' AND DDH_2 = 'DDH'    AND DDH_3 = 'NORMAL' AND DDH_4 = 'NORMAL') OR    
				        (DDH_1 = 'DDH'    AND DDH_2 = 'NORMAL' AND DDH_3 = 'NORMAL' AND DDH_4 = 'NORMAL') OR   
				        (DDH_1 = 'DDH'    AND DDH_2 = 'DDH'    AND DDH_3 = 'NORMAL' AND DDH_4 = 'NORMAL')				     
				)
			)


GO
