/****** Object:  View [dbo].[vw_cor_avalia_discrepancia_divergencia_correcao_1_3]    Script Date: 04/10/2019 10:16:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   view [dbo].[vw_cor_avalia_discrepancia_divergencia_correcao_1_3] as
select red.id, red.co_barra_redacao, red.id_projeto, cor1.id_corretor as id_corretor1, cor3.id_corretor as id_corretor2, cor1.id as correcao1, cor3.id as correcao2,
       cor1.id_correcao_situacao as situacao1, cor3.id_correcao_situacao as situacao2,
       abs(cor1.nota_final -   cor3.nota_final) as notaTotal,
       abs(cor1.nota_competencia1 - cor3.nota_competencia1) as competencia1,
       abs(cor1.nota_competencia2 - cor3.nota_competencia2) as competencia2,
       abs(cor1.nota_competencia3 - cor3.nota_competencia3) as competencia3,
       abs(cor1.nota_competencia4 - cor3.nota_competencia4) as competencia4,
       abs(cor1.nota_competencia5 - cor3.nota_competencia5) as competencia5,
       case when abs(isnull(cor1.id_correcao_situacao, 0) - isnull(cor3.id_correcao_situacao, 0)) > 0 then 'SIM' else 'NÃO' end as divergenciaSituacao
  from correcoes_redacao red
       inner join correcoes_correcao cor1 on cor1.redacao_id = red.id and cor1.id_tipo_correcao = 1 and cor1.id_status = 3
       inner join correcoes_correcao cor3 on cor3.redacao_id = red.id and cor3.id_tipo_correcao = 3 and cor3.id_status = 3
 where red.id_redacaoouro is null

GO
