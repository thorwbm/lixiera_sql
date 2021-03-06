/****** Object:  View [dbo].[vw_relatorio_panorama_geral_ocorrencias]    Script Date: 04/10/2019 10:16:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   VIEW [dbo].[vw_relatorio_panorama_geral_ocorrencias] AS
SELECT
    *, (total_ocorrencias - ocorrencias_respondidas) AS ocorrencias_pendentes
FROM (
    SELECT
        c.id AS time_id,
        c.id as hierarquia_id,
        c.descricao AS time_descricao,
        e.id AS polo_id,
        e.descricao AS polo_descricao,
        c.id_usuario_responsavel,
        c.id_hierarquia_usuario_pai,
        c.id_tipo_hierarquia_usuario,
        c.indice,
        convert(date, a.data_termino) AS data,
        count(*) AS total_ocorrencias,
        count(data_resposta) AS ocorrencias_respondidas
    FROM
        correcoes_correcao a,
        usuarios_hierarquia_usuarios b,
        usuarios_hierarquia c,
        ocorrencias_ocorrencia d,
        usuarios_hierarquia e
    WHERE
        a.id_corretor = b.user_id
        AND b.hierarquia_id = c.id
        AND d.correcao_id = a.id
        AND c.id_hierarquia_usuario_pai = e.id
    GROUP BY
        c.id,
        c.descricao,
        c.id_hierarquia_usuario_pai,
        c.id_tipo_hierarquia_usuario,
        c.indice,
        convert(date, a.data_termino),
        c.id_usuario_responsavel,
        e.id,
        e.descricao) z

GO
