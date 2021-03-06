/****** Object:  View [20191223].[vw_corretor_suspensao_desligamento]    Script Date: 26/12/2019 13:14:39 ******/
DROP VIEW IF EXISTS [20191223].[vw_corretor_suspensao_desligamento]
GO
/****** Object:  View [20191223].[vw_corretor_suspensao_desligamento]    Script Date: 26/12/2019 13:14:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

		create   view [20191223].[vw_corretor_suspensao_desligamento] as 
with cte_corretor_suspensao as (
		select  corretor_id, count(1) as qtd_suspensao, max(sus.criado_em) as data_suspensao
		  from [20191223].status_corretor_trocastatus tro left join [20191223].CORRECOES_SUSPENSAO sus on (tro.corretor_id = sus.id_corretor)
		  where status_atual_id = 3
		  group by corretor_id 
)

    , cte_corretor_motivo_suspensao as (
		select tro.corretor_id, tro.motivo_id
		  from  [20191223].status_corretor_trocastatus tro left join [20191223].CORRECOES_SUSPENSAO sus on (tro.corretor_id = sus.id_corretor)
		                                                             left join cte_corretor_suspensao cte on (cte.corretor_id = tro.corretor_id)
		 where status_atual_id = 3 and 
		       sus.criado_em = cte.data_suspensao
)

	, cte_corretor_desligamento as (
		select  corretor_id,  max(sus.criado_em) as data_desligamento
		  from [20191223].status_corretor_trocastatus tro left join [20191223].CORRECOES_SUSPENSAO sus on (tro.corretor_id = sus.id_corretor)
		  where status_atual_id = 4
		  group by corretor_id
)

    , cte_corretor_motivo_desligamento as (
		select tro.corretor_id, tro.motivo_id 
		  from  [20191223].status_corretor_trocastatus tro left join [20191223].CORRECOES_SUSPENSAO sus on (tro.corretor_id = sus.id_corretor)
		                                                             left join cte_corretor_suspensao cte on (cte.corretor_id = tro.corretor_id)
		 where status_atual_id = 4 and 
		       sus.criado_em = cte.data_suspensao
)

		select distinct cor.id as corretor_id, sus.data_suspensao, sus.qtd_suspensao, msu.motivo_id as motivo_id_suspensao, 
		        dsl.data_desligamento, mds.motivo_id as motivo_id_desligamento
		  from [20191223].correcoes_corretor cor left join cte_corretor_suspensao           sus on (cor.id = sus.corretor_id)
									                       left join cte_corretor_motivo_suspensao    msu on (cor.id = msu.corretor_id)
		                                                   left join cte_corretor_desligamento        dsl on (cor.id = dsl.corretor_id)
									                       left join cte_corretor_motivo_desligamento mds on (cor.id = mds.corretor_id)
GO
