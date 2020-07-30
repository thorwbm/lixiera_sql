/****** Object:  View [dbo].[vw_relatorios_extratocorrecaodiario]    Script Date: 11/02/2020 09:07:13 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE view [dbo].[vw_relatorios_extratocorrecaodiario] as
select data, usuario_id, cpf, nome, perfil,
       sum(enviados) as enviados,
	   sum(enviados_primeira) as enviados_primeira,
	   sum(enviados_segunda) as enviados_segunda,
	   sum(enviados_terceira) as enviados_terceira,
	   sum(enviados_quarta) as enviados_quarta,
	   sum(enviados_ouro) as enviados_ouro,
	   sum(enviados_moda) as enviados_moda,
	   sum(enviados_auditoria) as enviados_auditoria,
	   sum(glosadas) as glosadas
from 
(
select convert(date, cor.data_termino) as data, pes.usuario_id, pes.cpf, pes.nome, g.name as perfil,
       count(1) as enviados,
       count(case when cor.id_tipo_correcao = 1 then 1 else null end) as enviados_primeira,
       count(case when cor.id_tipo_correcao = 2 then 1 else null end) as enviados_segunda,
       count(case when cor.id_tipo_correcao = 3 then 1 else null end) as enviados_terceira,
       count(case when cor.id_tipo_correcao = 4 then 1 else null end) as enviados_quarta,
       count(case when cor.id_tipo_correcao = 5 then 1 else null end) as enviados_ouro,
       count(case when cor.id_tipo_correcao = 6 then 1 else null end) as enviados_moda,
       count(case when cor.id_tipo_correcao = 7 then 1 else null end) as enviados_auditoria,
	   0 as glosadas
  from correcoes_correcao cor
       join usuarios_pessoa pes on pes.usuario_id = cor.id_corretor
	   join auth_user_groups ug on ug.user_id = pes.usuario_id
	   join auth_group g on g.id = ug.group_id
 where cor.data_termino is not null
group by convert(date, cor.data_termino), pes.usuario_id, pes.cpf, pes.nome, g.name
union all
select convert(date, cor.data_termino) as data, pes.usuario_id, pes.cpf, pes.nome, g.name as perfil,
       count(1) as enviados,
       count(case when cor.id_tipo_correcao = 1 then 1 else null end) as enviados_primeira,
       count(case when cor.id_tipo_correcao = 2 then 1 else null end) as enviados_segunda,
       count(case when cor.id_tipo_correcao = 3 then 1 else null end) as enviados_terceira,
       count(case when cor.id_tipo_correcao = 4 then 1 else null end) as enviados_quarta,
       count(case when cor.id_tipo_correcao = 5 then 1 else null end) as enviados_ouro,
       count(case when cor.id_tipo_correcao = 6 then 1 else null end) as enviados_moda,
       count(case when cor.id_tipo_correcao = 7 then 1 else null end) as enviados_auditoria,
	   0 as glosadas
  from correcoes_correcao cor
       join usuarios_pessoa pes on pes.usuario_id = cor.id_auxiliar1
	   join auth_user_groups ug on ug.user_id = pes.usuario_id
	   join auth_group g on g.id = ug.group_id
 where cor.data_termino is not null
group by convert(date, cor.data_termino), pes.usuario_id, pes.cpf, pes.nome, g.name
union all
select convert(date, cor.data_termino) as data, pes.usuario_id, pes.cpf, pes.nome, g.name as perfil, 
       count(1) as enviados,
       count(case when cor.id_tipo_correcao = 1 then 1 else null end) as enviados_primeira,
       count(case when cor.id_tipo_correcao = 2 then 1 else null end) as enviados_segunda,
       count(case when cor.id_tipo_correcao = 3 then 1 else null end) as enviados_terceira,
       count(case when cor.id_tipo_correcao = 4 then 1 else null end) as enviados_quarta,
       count(case when cor.id_tipo_correcao = 5 then 1 else null end) as enviados_ouro,
       count(case when cor.id_tipo_correcao = 6 then 1 else null end) as enviados_moda,
       count(case when cor.id_tipo_correcao = 7 then 1 else null end) as enviados_auditoria,
	   0 as glosadas
  from correcoes_correcao cor
       join usuarios_pessoa pes on pes.usuario_id = cor.id_auxiliar2
	   join auth_user_groups ug on ug.user_id = pes.usuario_id
	   join auth_group g on g.id = ug.group_id
 where cor.data_termino is not null
group by convert(date, cor.data_termino), pes.usuario_id, pes.cpf, pes.nome, g.name
) tab 
group by data, usuario_id, cpf, nome, perfil
GO


