/**********************************************************************************************************************************
*                                     [VW_COR_AVALIA_DISCREPANCIA_DIVERGENCIA_CORRECAO_2_3]                                       *
*                                                                                                                                 *
*  VIEW QUE COMPARA A SEGUNDA CORRECAO COM A TERCEIRA E TEM COMO COLUNAS AS DIFERENCAS DAS COMPETENCIAS E SITUACAO                *
*                                                                                                                                 *
*                                                                                                                                 *
* BANCO_SISTEMA : ENEM                                                                                                            *
* CRIADO POR    : WEMERSON BITTORI MADURO                                                                         DATA:03/10/2019 *
* ALTERADO POR  : WEMERSON BITTORI MADURO                                                                         DATA:03/10/2019 *
**********************************************************************************************************************************/

ALTER   view [dbo].[vw_cor_avalia_discrepancia_divergencia_correcao_2_3] as
select red.id, red.co_barra_redacao, red.id_projeto, cor2.id_corretor as id_corretor1, cor3.id_corretor as id_corretor2, cor2.id as correcao1, cor3.id as correcao2,
       cor2.id_correcao_situacao as situacao1, cor3.id_correcao_situacao as situacao2,
       abs(cor2.nota_final -   cor3.nota_final) as notaTotal,
       abs(cor2.nota_competencia1 - cor3.nota_competencia1) as competencia1,
       abs(cor2.nota_competencia2 - cor3.nota_competencia2) as competencia2,
       abs(cor2.nota_competencia3 - cor3.nota_competencia3) as competencia3,
       abs(cor2.nota_competencia4 - cor3.nota_competencia4) as competencia4,
       abs(cor2.nota_competencia5 - cor3.nota_competencia5) as competencia5,
       case when abs(isnull(cor2.id_correcao_situacao, 0) - isnull(cor3.id_correcao_situacao, 0)) > 0 then 'SIM' else 'NÃO' end as divergenciaSituacao
  from correcoes_redacao red WITH(NOLOCK)
       inner join correcoes_correcao cor2 WITH(NOLOCK) on cor2.redacao_id = red.id and cor2.id_tipo_correcao = 2 and cor2.id_status = 3
       inner join correcoes_correcao cor3 WITH(NOLOCK) on cor3.redacao_id = red.id and cor3.id_tipo_correcao = 3 and cor3.id_status = 3
 where red.id_redacaoouro is null

GO


