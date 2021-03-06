/****** Object:  View [dbo].[vw_relatorio_terceira_correcao_polo]    Script Date: 04/10/2019 10:16:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   VIEW [dbo].[vw_relatorio_terceira_correcao_polo] as
SELECT
     q.time_id,
     q.time_descricao,
     q.time_indice AS indice,
	 k.id_hierarquia_usuario_pai,
	 k.id_tipo_hierarquia_usuario,
     u.data,
     q.polo_id,
     q.polo_descricao,
     ISNULL(u.terceiras_corrigidas, 0) as terceiras_corrigidas,
     ISNULL(u.terceiras_aproveitadas, 0) as terceiras_aproveitadas,
     ISNULL(u.foram_quarta, 0) as foram_quarta,
     ISNULL(u.aproveitadas_quarta, 0) as aproveitadas_quarta,
     ISNULL(u.nao_aproveitadas_quarta, 0) as nao_aproveitadas_quarta
FROM vw_hierarquia_completa q
     inner join usuarios_hierarquia k on k.id = q.time_id
	 LEFT OUTER JOIN (

SELECT
    *
FROM (
    SELECT
        a.time_id AS hierarquia_id,
        a.time_descricao AS descricao,
        a.time_indice AS indice,
		a.id_hierarquia_usuario_pai,
		a.id_tipo_hierarquia_usuario,
        data,
        polo_id,
        polo_descricao AS polo,
        count(a.id_correcao) AS terceiras_corrigidas,
        sum(convert(int, ISNULL(a.aproveitamento, 0))) AS terceiras_aproveitadas,
        count(a.quarta_soma) AS foram_quarta,
        sum(( CASE WHEN ISNULL(c.discrepou, 1) = 1 THEN
                    0
                ELSE
                    1
END)) AS aproveitadas_quarta,
sum(( CASE WHEN quarta_soma IS NULL THEN
            0
        ELSE
            ISNULL(convert(int, c.discrepou), 1)
END)) AS nao_aproveitadas_quarta
FROM
    vw_relatorio_terceira_correcao_avaliador a
    LEFT OUTER JOIN correcoes_analise b ON a.id_correcao = b.id_correcao_A
    AND b.id_tipo_correcao_B = 4
    LEFT OUTER JOIN correcoes_conclusao_analise c ON c.id = b.conclusao_analise
GROUP BY
    a.time_id,
    a.time_descricao,
    a.time_indice,
	a.id_hierarquia_usuario_pai,
	a.id_tipo_hierarquia_usuario,
    data,
    polo_id,
    polo_descricao) z) u on q.time_id = u.hierarquia_id

GO
