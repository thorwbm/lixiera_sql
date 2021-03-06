/****** Object:  View [dbo].[vw_total_ocorrencias_pendentes]    Script Date: 04/10/2019 10:16:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[vw_total_ocorrencias_pendentes]
as
select b.id, polo.descricao as polo, time.descricao as time, b.last_name as nome, total from (
select usuario_responsavel_id, count(*) as total from ocorrencias_ocorrencia a
where status_id = 1
group by usuario_responsavel_id
) a
join auth_user b on a.usuario_responsavel_id = b.id
left outer join usuarios_hierarquia_usuarios c on c.user_id = b.id
left outer join usuarios_hierarquia time on c.hierarquia_id = time.id
left outer join usuarios_hierarquia polo on time.id_hierarquia_usuario_pai = polo.id
GO
