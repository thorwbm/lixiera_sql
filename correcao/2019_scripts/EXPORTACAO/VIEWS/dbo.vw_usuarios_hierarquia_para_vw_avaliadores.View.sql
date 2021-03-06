/****** Object:  View [dbo].[vw_usuarios_hierarquia_para_vw_avaliadores]    Script Date: 04/10/2019 10:16:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[vw_usuarios_hierarquia_para_vw_avaliadores] as 
select a.usuario_id, a.nome, [time].id as time_id, polo.id as polo_id, fgv.id as fgv_id, geral.id as geral_id,
       [time].descricao as time_descricao, polo.descricao as polo_descricao, fgv.descricao as fgv_descricao, geral.descricao as geral_descricao,
       [time].indice as time_indice, polo.indice as polo_indice, fgv.indice as fgv_indice, geral.indice as geral_indice, time.indice as indice
  from usuarios_pessoa a
       inner join usuarios_hierarquia_usuarios b on b.user_id = a.usuario_id
       inner join usuarios_hierarquia as [time] on [time].id = b.hierarquia_id
       inner join usuarios_hierarquia as polo on polo.id = [time].id_hierarquia_usuario_pai
       inner join usuarios_hierarquia as fgv on fgv.id = polo.id_hierarquia_usuario_pai
       inner join usuarios_hierarquia as geral on geral.id = fgv.id_hierarquia_usuario_pai
union
select a.usuario_id, a.nome, responsavel.id as time_id, polo.id as polo_id, fgv.id as fgv_id, geral.id as geral_id,
       responsavel.descricao time_descricao, polo.descricao as polo_descricao, fgv.descricao as fgv_descricao, geral.descricao as geral_descricao,
       null as time_indice, polo.indice as polo_indice, fgv.indice as fgv_indice, geral.indice as geral_indice, polo.indice as indice
  from usuarios_pessoa a
       inner join usuarios_hierarquia_usuarios b on b.user_id = a.usuario_id
       inner join usuarios_hierarquia as polo on polo.id = b.hierarquia_id
       inner join usuarios_hierarquia as fgv on fgv.id = polo.id_hierarquia_usuario_pai
       inner join usuarios_hierarquia as geral on geral.id = fgv.id_hierarquia_usuario_pai
       inner join usuarios_hierarquia as responsavel on responsavel.id_usuario_responsavel = a.usuario_id
 where polo.id_tipo_hierarquia_usuario = 3
union
 select a.usuario_id, a.nome, null as time_id, null as polo_id, fgv.id as fgv_id, geral.id as geral_id,
       null as time_descricao, null as polo_descricao, fgv.descricao as fgv_descricao, geral.descricao as geral_descricao,
       null as time_indice, null as polo_indice, fgv.indice as fgv_indice, geral.indice as geral_indice, fgv.indice as indice
  from usuarios_pessoa a
       inner join usuarios_hierarquia_usuarios b on b.user_id = a.usuario_id
       inner join usuarios_hierarquia as fgv on fgv.id = b.hierarquia_id
       inner join usuarios_hierarquia as geral on geral.id = fgv.id_hierarquia_usuario_pai
 where fgv.id_tipo_hierarquia_usuario = 2
union
 select a.usuario_id, a.nome, null as time_id, responsavel.id as polo_id, null as fgv_id, geral.id as geral_id,
       null as time_descricao, responsavel.descricao as polo_descricao, null as fgv_descricao, geral.descricao as geral_descricao,
       null as time_indice, null as polo_indice, null as fgv_indice, geral.indice as geral_indice, geral.indice as indice
  from usuarios_pessoa a
       inner join usuarios_hierarquia_usuarios b on b.user_id = a.usuario_id
       inner join usuarios_hierarquia as geral on geral.id = b.hierarquia_id
       inner join usuarios_hierarquia as responsavel on responsavel.id_usuario_responsavel = a.usuario_id
 where geral.id_tipo_hierarquia_usuario = 1
GO
