/****** Object:  View [dbo].[vw_relatorio_geral_por_time]    Script Date: 04/10/2019 10:16:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_relatorio_geral_por_time] AS
     SELECT
        usuario_hierarquia.polo_id,
        usuario_hierarquia.polo_descricao,
        usuario_hierarquia.time_id,
        usuario_hierarquia.time_descricao,
        nome as avaliador,
        usuario_hierarquia.usuario_id,
        usuario_hierarquia.indice,
        nr_corrigidas,
        nr_aproveitadas,
        nr_discrepantes,
        tempo_medio,
        corretor.dsp,
        aproveitamento.data
    FROM (
        SELECT
            polo_id,
            polo_descricao,
            time_id,
            time_descricao,
            nome,
            usuario_id,
            time_indice as indice
        FROM vw_usuario_hierarquia_completa
    ) usuario_hierarquia
    RIGHT JOIN (
        SELECT
            usuario_id,
            SUM(nr_corrigidas) as nr_corrigidas,
            SUM(nr_aproveitadas) as nr_aproveitadas,
            SUM(nr_discrepantes) as nr_discrepantes,
            data
        FROM vw_aproveitamento_notas_time
        GROUP BY usuario_id, data) aproveitamento
    ON aproveitamento.usuario_id = usuario_hierarquia.usuario_id
    LEFT JOIN (
        SELECT
            id_corretor,
            AVG(tempo_em_correcao) as tempo_medio
        FROM correcoes_correcao2019
        GROUP BY id_corretor) tempo_medio
    ON tempo_medio.id_corretor = usuario_hierarquia.usuario_id
    LEFT JOIN correcoes_corretor corretor ON usuario_hierarquia.usuario_id = corretor.id

GO
