/****** Object:  View [dbo].[vw_correcoes_presas]    Script Date: 04/10/2019 10:16:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[vw_correcoes_presas]
as
select polo.descricao as polo, time.descricao as time, b.last_name, a.id from (
select id, id_corretor from correcoes_correcao where data_termino is null
) a
join auth_user b on a.id_corretor = b.id
join correcoes_corretor d on b.id = d.id
left outer join usuarios_hierarquia_usuarios c on c.user_id = b.id
left outer join usuarios_hierarquia time on c.hierarquia_id = time.id
left outer join usuarios_hierarquia polo on time.id_hierarquia_usuario_pai = polo.id
where d.status_id = 4
GO
