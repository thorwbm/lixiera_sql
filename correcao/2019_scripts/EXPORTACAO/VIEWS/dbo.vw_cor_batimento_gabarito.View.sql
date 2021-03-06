/****** Object:  View [dbo].[vw_cor_batimento_gabarito]    Script Date: 04/10/2019 10:16:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[vw_cor_batimento_gabarito] as

select cor.co_barra_redacao,
       cor.redacao_id,
       cor.id_projeto,
       cor.id_corretor,
       cor.id as id_correcao,
	   cor.link_imagem_recortada,
	   cor.link_imagem_original,
	   cor.data_inicio as data_inicio_correcao,
	   cor.data_termino as data_termino_correcao,
       cor.nota_final as nota_final_correcao,
	   cor.id_auxiliar1,
	   cor.id_auxiliar2,
	   cor.id_status,
	   cor.id_tipo_correcao,
       cor.competencia1 as id_competencia1_correcao,
       cor.competencia2 as id_competencia2_correcao,
       cor.competencia3 as id_competencia3_correcao,
       cor.competencia4 as id_competencia4_correcao,
       cor.competencia5 as id_competencia5_correcao,
       cor.nota_competencia1 as nota_competencia1_correcao,
       cor.nota_competencia2 as nota_competencia2_correcao,
       cor.nota_competencia3 as nota_competencia3_correcao,
       cor.nota_competencia4 as nota_competencia4_correcao,
       cor.nota_competencia5 as nota_competencia5_correcao,
       cor.id_correcao_situacao as id_correcao_situacao_correcao,
       gab.nota_final as nota_final_gabarito,
       gab.id_competencia1 as id_competencia1_gabarito,
       gab.id_competencia2 as id_competencia2_gabarito,
       gab.id_competencia3 as id_competencia3_gabarito,
       gab.id_competencia4 as id_competencia4_gabarito,
       gab.id_competencia5 as id_competencia5_gabarito,
       gab.nota_competencia1 as nota_competencia1_gabarito,
       gab.nota_competencia2 as nota_competencia2_gabarito,
       gab.nota_competencia3 as nota_competencia3_gabarito,
       gab.nota_competencia4 as nota_competencia4_gabarito,
       gab.nota_competencia5 as nota_competencia5_gabarito,
       gab.id_correcao_situacao as id_correcao_situacao_gabarito,
	   abs(isnull(cor.nota_final, 0) - isnull(gab.nota_final, 0)) as nota_final_diferenca,
	   abs(isnull(cor.nota_competencia1, 0) - isnull(gab.nota_competencia1, 0)) as competencia1_diferenca,
	   abs(isnull(cor.nota_competencia2, 0) - isnull(gab.nota_competencia2, 0)) as competencia2_diferenca,
	   abs(isnull(cor.nota_competencia3, 0) - isnull(gab.nota_competencia3, 0)) as competencia3_diferenca,
	   abs(isnull(cor.nota_competencia4, 0) - isnull(gab.nota_competencia4, 0)) as competencia4_diferenca,
	   abs(isnull(cor.nota_competencia5, 0) - isnull(gab.nota_competencia5, 0)) as competencia5_diferenca,
	   case when cor.id_correcao_situacao <> gab.id_correcao_situacao then 'SIM' else 'NAO' end as divergencia_situacao
from correcoes_correcao cor with(nolock)
     join correcoes_gabarito gab with(nolock) on cor.redacao_id = gab.redacao_id
where cor.id_status = 3

GO
