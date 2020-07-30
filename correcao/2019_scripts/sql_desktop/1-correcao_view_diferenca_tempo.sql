/*****************************************************************************************************************
*                      VIEW CALCULA DIFERENCA DE TEMPO DE ABERTURA E FECHAMENTO OCORRENCIA                       *
*                                                                                                                *
*  VIEW QUE CALCULA A DIFERENCA DE DATA DE ABERTURA E FECHAMENTO DE UMA OCORRENCIA DE UMA CORRECAO LEVANDO EM CO *
* TA APENAS A OCRRENCIA PAI NA TABELA OCORRENCIAS_OCORRENCIA                                                     *
*                                                                                                                *
* BANCO_SISTEMA : ENCCEJA                                                                                        *
* CRIADO POR    : WEMERSON BITTORI MADURO                                                        DATA:26/09/2018 *
* ALTERADO POR  : WEMERSON BITTORI MADURO                                                        DATA:26/09/2018 *
******************************************************************************************************************/

alter view VW_TEMPO_TOTAL_OCORRENCIA_POR_CORRECAO_ID as
SELECT correcao_id, id_projeto, SUM(DATEDIFF(minute, data_solicitacao, data_resposta)) AS DIFERENCA  
  FROM dbo.ocorrencias_ocorrencia  
 WHERE (data_resposta IS NOT NULL) AND (data_solicitacao IS NOT NULL)  and 
       isnull(ocorrencia_pai_id, 0) <> id

GROUP BY correcao_id, id_projeto  

