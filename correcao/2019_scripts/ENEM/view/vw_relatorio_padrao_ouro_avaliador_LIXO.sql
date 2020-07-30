/****** Object:  View [dbo].[vw_relatorio_padrao_ouro_avaliador]    Script Date: 24/09/2019 16:09:44 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER   VIEW [dbo].[vw_relatorio_padrao_ouro_avaliador] AS
    SELECT 1 as id, a.id_correcao_a                            AS id_correcao,
            a.id_corretor_a                            AS id_corretor,
            b.id                                       AS redacao,
            a.competencia1_a                           AS avaliador_c1,
            a.competencia2_a                           AS avaliador_c2,
            a.competencia3_a                           AS avaliador_c3,
            a.competencia4_a                           AS avaliador_c4,
            a.competencia5_a                           AS avaliador_c5,
            CASE WHEN a.competencia5_a = -1 THEN 1 ELSE 0 END AS avaliador_is_ddh,
            a.nota_final_a                             AS nota,
            c.id_competencia1                          AS referencia_c1,
            c.id_competencia2                         as referencia_c2,
            c.id_competencia3                          AS referencia_c3,
            c.id_competencia4                          AS referencia_c4,
            c.id_competencia5                          AS referencia_c5,
            CASE WHEN c.id_competencia5   = -1 THEN 1 ELSE 0 END AS referencia_is_ddh,
            c.nota_final                               AS nota_referencia,
            abs(c.id_competencia1 - a.competencia1_a)  AS diferenca_c1,
            Abs(c.id_competencia2 - a.competencia2_a)  AS diferenca_c2,
            Abs(c.id_competencia3 - a.competencia3_a)  AS diferenca_c3,
            Abs(c.id_competencia4 - a.competencia4_a)  AS diferenca_c4,
            abs(case c.id_competencia5 when -1 then 0 else c.id_competencia5 end - case a.competencia5_a when -1 then 0 else a.competencia5_a end) AS diferenca_c5,

            abs(c.nota_final - a.nota_final_a)    AS nota_diferenca,
            cast(a.data_termino_a AS date)             AS data,
            d.sigla                                    AS avaliador_situacao,
            e.sigla                                    AS referencia_situacao,
            f.discrepou,
            g.time_id,
            g.polo_id,
            g.fgv_id,
            g.geral_id,
            g.time_descricao,
            g.polo_descricao,
            g.fgv_descricao,
            g.geral_descricao,
            g.time_indice,
            g.polo_indice,
            g.fgv_indice,
            g.geral_indice
    FROM   correcoes_analise a,
            correcoes_redacao b,
            correcoes_gabarito c,
            correcoes_situacao d,
            correcoes_situacao e,
            correcoes_conclusao_analise f,
            vw_usuario_hierarquia_completa g
    WHERE  a.id_correcao_b IS NULL
    AND    a.co_barra_redacao = b.co_barra_redacao
    AND    b.id_redacaoouro IS NOT NULL
    AND    c.co_barra_redacao = b.co_barra_redacao
    AND    d.id = a.id_correcao_situacao_a
    AND    c.id_correcao_situacao = e.id
    AND    f.id = a.conclusao_analise
    AND    g.usuario_id = a.id_corretor_a

GO


