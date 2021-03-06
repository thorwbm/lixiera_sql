/****** Object:  View [dbo].[vw_usuario_perfil]    Script Date: 04/10/2019 10:16:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_usuario_perfil]
AS
SELECT        a.usuario_id, a.nome, time.id AS time_id, polo.id AS polo_id, fgv.id AS fgv_id, geral.id AS geral_id, time.descricao AS time_descricao, polo.descricao AS polo_descricao, fgv.descricao AS fgv_descricao, 
                         geral.descricao AS geral_descricao, time.indice AS time_indice, polo.indice AS polo_indice, fgv.indice AS fgv_indice, geral.indice AS geral_indice, dbo.auth_group.name
FROM            dbo.auth_group INNER JOIN
                         dbo.auth_user_groups ON dbo.auth_group.id = dbo.auth_user_groups.group_id RIGHT OUTER JOIN
                         dbo.usuarios_pessoa AS a INNER JOIN
                         dbo.usuarios_hierarquia_usuarios AS b ON b.user_id = a.usuario_id INNER JOIN
                         dbo.usuarios_hierarquia AS time ON time.id = b.hierarquia_id INNER JOIN
                         dbo.usuarios_hierarquia AS polo ON polo.id = time.id_hierarquia_usuario_pai INNER JOIN
                         dbo.usuarios_hierarquia AS fgv ON fgv.id = polo.id_hierarquia_usuario_pai INNER JOIN
                         dbo.usuarios_hierarquia AS geral ON geral.id = fgv.id_hierarquia_usuario_pai ON dbo.auth_user_groups.user_id = a.id
GO
