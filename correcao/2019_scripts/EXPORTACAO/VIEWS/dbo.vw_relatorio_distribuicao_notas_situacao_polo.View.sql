/****** Object:  View [dbo].[vw_relatorio_distribuicao_notas_situacao_polo]    Script Date: 04/10/2019 10:16:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   VIEW [dbo].[vw_relatorio_distribuicao_notas_situacao_polo]
AS
SELECT ROW_NUMBER()
    OVER (
    ORDER BY
        hierarquia_id) AS id,
        q.polo_id,
        q.polo_descricao,
        q.time_id as hierarquia_id,
        q.time_descricao as descricao,
        q.time_indice as indice,
        u.data,
        ISNULL(u.nr_nm, 0) AS nr_nm,
        ISNULL(u.nr_fea, 0) AS nr_fea,
        ISNULL(u.nr_copia, 0) AS nr_copia,
        ISNULL(u.nr_ft, 0) AS nr_ft,
        ISNULL(u.nr_natt, 0) AS nr_natt,
        ISNULL(u.nr_pd, 0) AS nr_pd,
        ISNULL(u.nr_corrigidas,0) as nr_corrigidas,
        ISNULL(u.nr_situacoes, 0) as nr_situacoes
        FROM vw_hierarquia_completa q LEFT OUTER JOIN(
SELECT
    *, (nr_nm + nr_fea + nr_copia + nr_ft + nr_natt + nr_pd) AS nr_corrigidas, (nr_fea + nr_copia + nr_ft + nr_natt + nr_pd) AS nr_situacoes
FROM (
    SELECT
        polo_id,
        polo_descricao,
        time_id AS hierarquia_id,
        time_descricao AS descricao,
        time_indice AS indice,
        data,
        ISNULL([1], 0) AS nr_nm,
        ISNULL([2], 0) AS nr_fea,
        ISNULL([3], 0) AS nr_copia,
        ISNULL([6], 0) AS nr_ft,
        ISNULL([7], 0) AS nr_natt,
        ISNULL([9], 0) AS nr_pd
    FROM (
        SELECT
            c.polo_id,
            c.polo_descricao,
            c.time_id,
            c.time_descricao,
            c.time_indice,
            a.id_correcao_situacao,
            convert(date, a.data_termino) AS data,
            count(*) AS nr_corrigidas
        FROM
            correcoes_correcao a
        LEFT OUTER JOIN correcoes_situacao b ON a.id_correcao_situacao = b.id
    INNER JOIN vw_usuario_hierarquia_completa c ON c.usuario_id = a.id_corretor
    WHERE
        a.id_status = 3
    GROUP BY
        c.polo_id,
        c.polo_descricao,
        c.time_id,
        c.time_descricao,
        c.time_indice,
        a.id_correcao_situacao,
        convert(date, a.data_termino)) z pivot (sum(nr_corrigidas)
        FOR id_correcao_situacao IN ([1],
            [2],
            [3],
            [6],
            [7],
            [9])) z) y) u ON q.time_id = u.hierarquia_id

GO
