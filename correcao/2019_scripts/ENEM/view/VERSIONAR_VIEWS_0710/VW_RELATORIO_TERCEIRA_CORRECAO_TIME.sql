
/**********************************************************************************************************************************
*                                             [VW_RELATORIO_TERCEIRA_CORRECAO_TIME]                                               *
*                                                                                                                                 *
*  VIEW QUE SINTETIZA AS INFORMACOES REFERENTES A CORRECAO DAS TERCEIRAS                                                          *
*                                                                                                                                 *
*                                                                                                                                 *
* BANCO_SISTEMA : ENEM                                                                                                            *
* CRIADO POR    : WEMERSON BITTORI MADURO                                                                         DATA:03/10/2019 *
* ALTERADO POR  : WEMERSON BITTORI MADURO                                                                         DATA:03/10/2019 *
***********************************************************************************************************************************/
ALTER VIEW [dbo].[VW_RELATORIO_TERCEIRA_CORRECAO_TIME]
AS
SELECT
	hc.time_id,
	hc.time_descricao,
	hc.time_indice AS indice,
	hc.usuario_id AS avaliador_id,
	k.id_hierarquia_usuario_pai,
	k.id_tipo_hierarquia_usuario,
	hc.nome AS avaliador_descricao,
	z.data,
	hc.polo_id,
	hc.polo_descricao,
	ISNULL(z.terceiras_corrigidas, 0) AS terceiras_corrigidas,
	ISNULL(z.terceiras_aproveitadas, 0) AS terceiras_aproveitadas,
	ISNULL(z.geraram_quarta, 0) AS geraram_quarta,
	ISNULL(z.aproveitadas_quarta, 0) AS aproveitadas_quarta,
	ISNULL(z.nao_aproveitadas_quarta, 0) AS nao_aproveitadas_quarta,
	ISNULL(z.pode_corrigir_3, 0) AS pode_corrigir_3
FROM vw_usuario_hierarquia_completa hc
INNER JOIN usuarios_hierarquia k
	ON k.id = hc.time_id
LEFT OUTER JOIN (SELECT
		a.time_id AS hierarquia_id,
		a.time_descricao AS descricao,
		a.time_indice AS indice,
		a.id_corretor,
		a.nome,
		CONVERT(date, data) AS data,
		polo_id,
		polo_descricao AS polo,
		COUNT(a.id_correcao) AS terceiras_corrigidas,  
		COUNT(a.id_correcao) - (ISNULL(COUNT(f.id), 0) + ISNULL(COUNT(g.id), 0) + ISNULL(COUNT(k.id), 0) + ISNULL(COUNT(j.id), 0)) AS terceiras_aproveitadas,
		                       (ISNULL(COUNT(f.id), 0) + ISNULL(COUNT(g.id), 0) + ISNULL(COUNT(k.id), 0) + ISNULL(COUNT(j.id), 0)) AS geraram_quarta,
		SUM((CASE WHEN ISNULL(c.discrepou, 1) = 1 THEN 0 ELSE 1	                                   END)) AS aproveitadas_quarta,
		SUM((CASE WHEN quarta_soma IS NULL        THEN 0 ELSE ISNULL(CONVERT(int, c.discrepou), 1) END)) AS nao_aproveitadas_quarta,
		h.pode_corrigir_3
	FROM vw_relatorio_terceira_correcao_avaliador_para_time a WITH(NOLOCK)
	                                     INNER JOIN correcoes_corretor          h WITH(NOLOCK) ON (h.id = a.id_corretor )
	                                LEFT OUTER JOIN correcoes_analise           b WITH(NOLOCK) ON (a.REDACAO_ID  = b.redacao_id    AND
									                                                               a.id_correcao = b.id_correcao_A AND 
									                                                               b.id_tipo_correcao_B = 4	 )
	                                LEFT OUTER JOIN correcoes_conclusao_analise c WITH(NOLOCK) ON (c.id = b.conclusao_analise)
	                                LEFT OUTER JOIN correcoes_fila4             f WITH(NOLOCK) ON (f.redacao_id = a.REDACAO_ID)
	                                LEFT OUTER JOIN correcoes_filaauditoria     k WITH(NOLOCK) ON (k.redacao_id = a.redacao_id)
	                                LEFT OUTER JOIN correcoes_correcao          j WITH(NOLOCK) ON (j.redacao_id = a.REDACAO_ID AND 
									                                                               j.id_tipo_correcao = 7)
	                                LEFT OUTER JOIN correcoes_correcao          g WITH(NOLOCK) ON (g.redacao_id = a.REDACAO_ID		AND 
									                                                               g.id_tipo_correcao = 4)	
	GROUP BY	a.time_id,
				a.time_descricao,
				a.time_indice,
				a.id_corretor,
				a.id_hierarquia_usuario_pai,
				a.id_tipo_hierarquia_usuario,
				a.nome,
				CONVERT(date, data),
				polo_id,
				polo_descricao,
				h.pode_corrigir_3) z
	ON hc.usuario_id = z.id_corretor


