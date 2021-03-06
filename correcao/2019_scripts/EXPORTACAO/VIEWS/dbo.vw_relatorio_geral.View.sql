/****** Object:  View [dbo].[vw_relatorio_geral]    Script Date: 04/10/2019 10:16:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE   VIEW [dbo].[vw_relatorio_geral]
AS
     SELECT 1 AS id,
            hierarquia_id,
            descricao,
            id_hierarquia_usuario_pai,
            id_tipo_hierarquia_usuario,
            indice,
            data,
            notas_aproveitadas,
            total_corrigidas,
            tempo_medio,
            dsp,
            media_dia
     FROM
     (
         SELECT a.polo_id AS hierarquia_id,
                a.polo_descricao AS descricao,
                g.id_hierarquia_usuario_pai,
                g.id_tipo_hierarquia_usuario,
                a.polo_indice AS indice,
                Convert(Date, b.data_termino) AS data,
                Sum((CASE
                         WHEN f.aproveitamento = 1
                         THEN 1
                         ELSE 0
                     END)) AS notas_aproveitadas,
                Count(DISTINCT b.id) AS total_corrigidas,
                Avg(b.tempo_em_correcao) AS tempo_medio,
                Avg(d.dsp) AS dsp,
                Round(Count(*) / DateDiff(day, e.data_inicio, dbo.getlocaldate()), 2) AS media_dia
         FROM vw_usuario_hierarquia_completa a WITH(NOLOCK)
              INNER JOIN correcoes_correcao b WITH(NOLOCK)
                       ON b.id_corretor = a.usuario_id
                          AND b.id_status = 3
              INNER JOIN usuarios_hierarquia c WITH(NOLOCK)
                       ON c.id = a.time_id
              INNER JOIN usuarios_hierarquia g WITH(NOLOCK)
                       ON g.id = a.polo_id
              INNER JOIN projeto_projeto e WITH(NOLOCK)
                       ON e.id = b.id_projeto
              LEFT OUTER JOIN correcoes_analise f WITH(NOLOCK)
                       ON f.id_correcao_A = b.id
                          AND f.id_tipo_correcao_b = 3
              LEFT OUTER JOIN correcoes_corretor_indicadores d WITH(NOLOCK)
                       ON d.usuario_id = b.id_corretor
                          AND d.data_calculo =
         (
             SELECT Max(data_calculo)
             FROM correcoes_corretor_indicadores z WITH(NOLOCK)
             WHERE z.usuario_id = b.id_corretor
         )
         GROUP BY a.polo_id,
                  a.polo_descricao,
                  g.id_hierarquia_usuario_pai,
                  g.id_tipo_hierarquia_usuario,
                  a.polo_indice,
                  Convert(Date, b.data_termino),
                  e.data_inicio
     ) f;

GO
