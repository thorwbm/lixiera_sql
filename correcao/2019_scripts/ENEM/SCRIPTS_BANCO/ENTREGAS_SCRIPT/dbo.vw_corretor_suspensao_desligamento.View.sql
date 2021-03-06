/****** Object:  View [dbo].[vw_corretor_suspensao_desligamento]    Script Date: 26/12/2019 13:14:39 ******/
DROP VIEW IF EXISTS [dbo].[vw_corretor_suspensao_desligamento]
GO
/****** Object:  View [dbo].[vw_corretor_suspensao_desligamento]    Script Date: 26/12/2019 13:14:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

		create   view [dbo].[vw_corretor_suspensao_desligamento] as 
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
