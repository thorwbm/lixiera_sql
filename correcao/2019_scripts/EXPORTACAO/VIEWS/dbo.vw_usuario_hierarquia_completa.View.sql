/****** Object:  View [dbo].[vw_usuario_hierarquia_completa]    Script Date: 04/10/2019 10:16:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE    view [dbo].[vw_usuario_hierarquia_completa] as
select a.usuario_id, a.nome, [time].id as time_id, polo.id as polo_id, fgv.id as fgv_id, geral.id as geral_id,
       [time].descricao as time_descricao, polo.descricao as polo_descricao, fgv.descricao as fgv_descricao, geral.descricao as geral_descricao,
       [time].indice as time_indice, polo.indice as polo_indice, fgv.indice as fgv_indice, geral.indice as geral_indice
  from usuarios_pessoa a with (nolock)
       inner join usuarios_hierarquia_usuarios b with (nolock) on b.user_id = a.usuario_id
       inner join usuarios_hierarquia as [time] with (nolock) on [time].id = b.hierarquia_id
       inner join usuarios_hierarquia as polo with (nolock) on polo.id = [time].id_hierarquia_usuario_pai
       inner join usuarios_hierarquia as fgv with (nolock) on fgv.id = polo.id_hierarquia_usuario_pai
       inner join usuarios_hierarquia as geral with (nolock) on geral.id = fgv.id_hierarquia_usuario_pai

GO
