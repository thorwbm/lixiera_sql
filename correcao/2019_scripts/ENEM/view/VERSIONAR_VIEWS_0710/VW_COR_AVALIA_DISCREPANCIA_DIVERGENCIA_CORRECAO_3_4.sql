/**********************************************************************************************************************************
*                                     [VW_COR_AVALIA_DISCREPANCIA_DIVERGENCIA_CORRECAO_3_4]                                       *
*                                                                                                                                 *
*  VIEW QUE COMPARA A TERCEIRA CORRECAO COM A QUARTA E TEM COMO COLUNAS AS DIFERENCAS DAS COMPETENCIAS E SITUACAO                 *
*                                                                                                                                 *
*                                                                                                                                 *
* BANCO_SISTEMA : ENEM                                                                                                            *
* CRIADO POR    : WEMERSON BITTORI MADURO                                                                         DATA:03/10/2019 *
* ALTERADO POR  : WEMERSON BITTORI MADURO                                                                         DATA:03/10/2019 *
**********************************************************************************************************************************/

ALTER   view [dbo].[vw_cor_avalia_discrepancia_divergencia_correcao_3_4] as
select red.id, red.co_barra_redacao, red.id_projeto, cor3.id_corretor as id_corretor1, cor4.id_corretor as id_corretor2, cor3.id as correcao1, cor4.id as correcao2,
       cor3.id_correcao_situacao as situacao1, cor4.id_correcao_situacao as situacao2,
       abs(cor3.nota_final -   cor4.nota_final) as notaTotal,
       abs(cor3.competencia1 - cor4.competencia1) as competencia1,
       abs(cor3.competencia2 - cor4.competencia2) as competencia2,
       abs(cor3.competencia3 - cor4.competencia3) as competencia3,
       abs(cor3.competencia4 - cor4.competencia4) as competencia4,
       abs(cor3.competencia5 - cor4.competencia5) as competencia5,
       case when abs(isnull(cor3.id_correcao_situacao, 0) - isnull(cor4.id_correcao_situacao, 0)) > 0 then 'SIM' else 'NÃO' end as divergenciaSituacao
  from correcoes_redacao red WITH(NOLOCK)
       inner join correcoes_correcao cor3 WITH(NOLOCK) on cor3.redacao_id = red.id and cor3.id_tipo_correcao = 3 and cor3.id_status = 3
       inner join correcoes_correcao cor4 WITH(NOLOCK) on cor4.redacao_id = red.id and cor4.id_tipo_correcao = 4 and cor4.id_status = 3
 where red.id_redacaoouro is null

GO


