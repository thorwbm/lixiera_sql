USE [correcao_redacao_regular_replica]
GO

/****** Object:  View [dbo].[vw_relatorio_aproveitamento_notas_por_polo]    Script Date: 19/11/2018 16:39:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vw_relatorio_aproveitamento_notas_por_polo]
as
SELECT
    ROW_NUMBER()
    OVER (
    ORDER BY
        hierarquia_id) AS id,
    q.polo_id,
    q.polo_descricao,
    q.time_id AS hierarquia_id,
    q.time_descricao AS descricao,
    u.id_hierarquia_usuario_pai,
    u.id_tipo_hierarquia_usuario,
    q.time_indice AS indice,
    u.data,
    isnull(u.redacoes_corrigidas, 0) as redacoes_corrigidas,
    isnull(u.notas_aproveitadas,0) as notas_aproveitadas,
    isnull(u.nao_discrepou,0) as nao_discrepou,
    isnull(u.discrepou,0) as discrepou
FROM
    vw_hierarquia_completa q
    LEFT OUTER JOIN (
        SELECT
            polo_id,
            polo_descricao,
            hierarquia_id,
            descricao,
            id_hierarquia_usuario_pai,
            id_tipo_hierarquia_usuario,
            indice,
            data,
            sum(redacoes_corrigidas) AS redacoes_corrigidas,
            sum(notas_aproveitadas) AS notas_aproveitadas,
            sum(nao_discrepou) AS nao_discrepou,
            sum(discrepou) AS discrepou
        FROM (
            SELECT
                polo_id,
                polo_descricao,
                hierarquia_id,
                descricao,
                id_hierarquia_usuario_pai,
                id_tipo_hierarquia_usuario,
                indice,
                data,
                sum(redacoes_corrigidas) AS redacoes_corrigidas,
                notas_aproveitadas,
                sum(nao_discrepou) AS nao_discrepou,
                sum(discrepou) AS discrepou
            FROM (
                SELECT
                    e.polo_id,
                    e.polo_descricao,
                    c.id AS hierarquia_id,
                    c.descricao,
                    c.id_hierarquia_usuario_pai,
                    c.id_tipo_hierarquia_usuario,
                    c.indice,
                    convert(date, d.data_termino) AS data,
                    count(*) AS redacoes_corrigidas,
--                     sum(convert(int, ISNULL(1, 0))) AS notas_aproveitadas,
				  sum(CASE a.aproveitamento WHEN 1 then 1 else 0 end) as notas_aproveitadas,
				  sum(CASE a.aproveitamento WHEN 0 then 1 else 0 end) as notas_nao_aproveitadas,
                    sum(( CASE WHEN a.conclusao_analise IN (0, 1, 2) THEN
                                1
                            ELSE
                                0
END)) AS nao_discrepou,
sum(( CASE WHEN a.conclusao_analise IN (3, 4, 5) THEN
            1
        ELSE
            0
END)) AS discrepou
FROM
    correcoes_analise a,
    usuarios_hierarquia_usuarios b,
    usuarios_hierarquia c,
    correcoes_correcao d,
    vw_usuario_hierarquia_completa e
WHERE
    a.id_corretor_A = b.user_id
    AND b.hierarquia_id = c.id
    AND ((a.id_tipo_correcao_B = 1)
    OR  (a.id_tipo_correcao_B = 2))
    AND d.id = a.id_correcao_A
    AND e.usuario_id = b.user_id
GROUP BY
    e.polo_id,
    e.polo_descricao,
    c.id,
    c.descricao,
    c.id_hierarquia_usuario_pai,
    c.id_tipo_hierarquia_usuario,
    c.indice,
    convert(date, d.data_termino)) z
GROUP BY
    polo_id,
    polo_descricao,
    hierarquia_id,
    descricao,
    id_hierarquia_usuario_pai,
    id_tipo_hierarquia_usuario,
    indice,
    data,
    notas_aproveitadas
UNION ALL
SELECT
    polo_id,
    polo_descricao,
    hierarquia_id,
    descricao,
    id_hierarquia_usuario_pai,
    id_tipo_hierarquia_usuario,
    indice,
    data,
    sum(redacoes_corrigidas) AS redacoes_corrigidas,
    notas_aproveitadas,
    sum(nao_discrepou) AS nao_discrepou,
    sum(discrepou) AS discrepou
FROM (
    SELECT
        e.polo_id,
        e.polo_descricao,
        c.id AS hierarquia_id,
        c.descricao,
        c.id_hierarquia_usuario_pai,
        c.id_tipo_hierarquia_usuario,
        c.indice,
        convert(date, d.data_termino) AS data,
        count(*) AS redacoes_corrigidas,
--         sum(convert(int, ISNULL(1, 0))) AS notas_aproveitadas,
	  sum(CASE a.aproveitamento WHEN 1 then 1 else 0 end) as notas_aproveitadas,
	  sum(CASE a.aproveitamento WHEN 0 then 1 else 0 end) as notas_nao_aproveitadas,
        sum(( CASE WHEN a.conclusao_analise IN (0, 1, 2) THEN
                    1
                ELSE
                    0
END)) AS nao_discrepou,
sum(( CASE WHEN a.conclusao_analise IN (3, 4, 5) THEN
            1
        ELSE
            0
END)) AS discrepou
FROM
    correcoes_analise a,
    usuarios_hierarquia_usuarios b,
    usuarios_hierarquia c,
    correcoes_correcao d,
    vw_usuario_hierarquia_completa e
WHERE
    a.id_corretor_B = b.user_id
    AND b.hierarquia_id = c.id
    AND ((a.id_tipo_correcao_B = 1) OR (a.id_tipo_correcao_B = 2))
    AND d.id = a.id_correcao_B
    AND e.usuario_id = b.user_id
GROUP BY
    e.polo_id,
    e.polo_descricao,
    c.id,
    c.descricao,
    c.id_hierarquia_usuario_pai,
    c.id_tipo_hierarquia_usuario,
    c.indice,
    convert(date, d.data_termino)) z
GROUP BY
    polo_id,
    polo_descricao,
    hierarquia_id,
    descricao,
    id_hierarquia_usuario_pai,
    id_tipo_hierarquia_usuario,
    indice,
    data,
    notas_aproveitadas) w
GROUP BY
    polo_id,
    polo_descricao,
    hierarquia_id,
    descricao,
    id_hierarquia_usuario_pai,
    id_tipo_hierarquia_usuario,
    indice,
    data) u ON u.hierarquia_id = q.time_id
GO


