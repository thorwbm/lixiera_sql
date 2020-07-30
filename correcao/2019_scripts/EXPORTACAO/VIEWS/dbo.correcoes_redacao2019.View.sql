/****** Object:  View [dbo].[correcoes_redacao2019]    Script Date: 04/10/2019 10:16:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[correcoes_redacao2019] as
select * from correcoes_redacao where co_barra_redacao like '%EVT%' or link_imagem_recortada like '%evento_teste2%'
union
select * from correcoes_redacao red where exists (select top 1 1 from correcoes_correcao corr join auth_user us on us.id = corr.id_corretor where red.id = corr.redacao_id and us.username in (
'02801198528',
'05075837522',
'03918462560',
'99311925500',
'50934015520',
'79357652515'
))
GO
