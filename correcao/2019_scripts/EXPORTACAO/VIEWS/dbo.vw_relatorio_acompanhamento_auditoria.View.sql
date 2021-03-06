/****** Object:  View [dbo].[vw_relatorio_acompanhamento_auditoria]    Script Date: 04/10/2019 10:16:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   view [dbo].[vw_relatorio_acompanhamento_auditoria] as
select usuario_id, nome as auditor, hierarquia_id, '.1.3.' as indice, data,
       isnull(nota_maxima, 0) as nota_maxima,
       isnull(pd, 0) as pd, isnull(ddh, 0) as ddh, isnull(situacao_esdruxula, 0) as situacao_esdruxula, 
       isnull(nota_maxima, 0) + isnull(pd, 0) + isnull(ddh, 0) + isnull(situacao_esdruxula, 0) as total
  from (
    select usuario_id, nome, hierarquia_id, indice, data, [1] as nota_maxima, [2] as pd, [3] as ddh, [4] as situacao_esdruxula from (
        select a.usuario_id, a.nome, d.id as hierarquia_id, d.indice, convert(date, b.data_termino) as data, b.tipo_auditoria_id, count(*) as correcoes
        from usuarios_pessoa a, correcoes_correcao b, usuarios_hierarquia_usuarios c, usuarios_hierarquia d
        where b.id_corretor = a.usuario_id
    and c.user_id = a.usuario_id
    and c.hierarquia_id = d.id
        and b.id_status = 3
        and b.id_tipo_correcao = 7
        group by a.usuario_id, a.nome, d.id, d.indice, convert(date, b.data_termino), b.tipo_auditoria_id
    ) z pivot (sum(correcoes) for tipo_auditoria_id in ([1], [2], [3], [4]) ) z
) w
GO
