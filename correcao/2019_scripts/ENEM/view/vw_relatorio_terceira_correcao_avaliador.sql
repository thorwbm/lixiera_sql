
/**********************************************************************************************************************************
*                                           [VW_RELATORIO_TERCEIRA_CORRECAO_AVALIADOR]                                            *
*                                                                                                                                 *
*  VIEW QUE RETORNA TODAS AS CORRECOES QUE TIVERAM TERCEIRA E ESTA NAO FOI APROVEITADA                                            *
*                                                                                                                                 *
*                                                                                                                                 *
* BANCO_SISTEMA : ENEM                                                                                                            *
* CRIADO POR    : WEMERSON BITTORI MADURO                                                                         DATA:03/10/2019 *
* ALTERADO POR  : WEMERSON BITTORI MADURO                                                                         DATA:03/10/2019 *
**********************************************************************************************************************************/

ALTER  VIEW [dbo].[vw_relatorio_terceira_correcao_avaliador] as 
SELECT 
    cor.id AS id_correcao,
    cor.id_corretor,
    hic.nome,
    CAST(red.id AS [nvarchar]) AS redacao,
    cor.competencia1 AS terceira_c1,
    cor.competencia2 AS terceira_c2,
    cor.competencia3 AS terceira_c3,
    cor.competencia4 AS terceira_c4,
    cor.competencia5 AS terceira_c5,
    CAST(cor.nota_final AS [int]) AS terceira_soma,
    sit.sigla AS terceira_situacao,
    cor4.competencia1 AS quarta_c1,
    cor4.competencia2 AS quarta_c2,
    cor4.competencia3 AS quarta_c3,
    cor4.competencia4 AS quarta_c4,
    cor4.competencia5 AS quarta_c5,
    CAST(cor4.nota_final AS [int]) AS quarta_soma,
    sit4.sigla AS quarta_situacao,
    cor.data_termino AS data,
    aproveitamento =
                    CASE
                        WHEN ana.conclusao_analise > 2 THEN 0
                        WHEN ana.conclusao_analise >= 0 THEN 1
                        ELSE NULL
                    END,
    hic.time_id,
    hic.polo_id,
    hic.fgv_id,
    hic.geral_id,
    hic.time_descricao,
    hic.polo_descricao,
    hic.fgv_descricao,
    hic.geral_descricao,
    hic.time_indice,
    hic.polo_indice,
    hic.fgv_indice,
    hic.geral_indice,
    red.co_barra_redacao,
    hie.id_hierarquia_usuario_pai,
    hie.id_tipo_hierarquia_usuario
FROM correcoes_correcao cor with(nolock) JOIN correcoes_redacao red with(nolock) ON (cor.redacao_id = red.id)
                          JOIN vw_usuario_hierarquia_completa   hic with(nolock) ON (hic.usuario_id = cor.id_corretor)
                          JOIN correcoes_situacao               sit with(nolock) ON (sit.id = cor.id_correcao_situacao)
                          JOIN usuarios_hierarquia              hie with(nolock) ON (hie.id = hic.time_id)
                     LEFT JOIN correcoes_analise                ana with(nolock) ON (ana.redacao_id = cor.redacao_id AND ana.id_projeto = cor.id_projeto  AND ana.id_tipo_correcao_A = 3 AND ana.id_tipo_correcao_B = 4)
                     LEFT JOIN correcoes_correcao               cor4 with(nolock) ON (cor4.redacao_id = red.id AND cor4.id_tipo_correcao = 4)
                     LEFT JOIN correcoes_situacao               sit4 with(nolock) ON (sit4.id = cor4.id_correcao_situacao)
WHERE cor.id_tipo_correcao = 3
AND cor.id_status = 3  
AND  EXISTS (SELECT TOP 1 1 FROM correcoes_analise  WHERE id_correcao_B = cor.id)
AND (EXISTS (SELECT TOP 1 1 FROM correcoes_correcao WHERE redacao_id    = cor.redacao_id AND id_tipo_correcao = 4) OR 
     EXISTS (SELECT TOP 1 1 FROM correcoes_fila4    WHERE redacao_id    = cor.redacao_id)                          OR 
	 EXISTS (SELECT TOP 1 1 FROM correcoes_correcao WHERE redacao_id    = cor.redacao_id AND id_tipo_correcao = 7) OR 
     EXISTS (SELECT TOP 1 1 FROM correcoes_filaauditoria    WHERE redacao_id    = cor.redacao_id)                          
	 )





