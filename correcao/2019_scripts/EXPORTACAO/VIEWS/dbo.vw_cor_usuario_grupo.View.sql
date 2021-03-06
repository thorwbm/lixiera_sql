/****** Object:  View [dbo].[vw_cor_usuario_grupo]    Script Date: 04/10/2019 10:16:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[vw_cor_usuario_grupo] as
select id_usuario = usr.id, usr.first_name, usr.last_name, usr.is_superuser, ugr.group_id,
       grupo = gro.name, cor.max_correcoes_dia, grupo_corretor = cor.id_grupo ,
	   cor.pode_corrigir_1, cor.pode_corrigir_2, cor.pode_corrigir_3, cor.status_id
  from auth_user usr join auth_user_groups ugr on (ugr.user_id = usr.id)
                     join auth_group       gro on (gro.id = ugr.group_id)
      join correcoes_corretor cor on (cor.id = usr.id);

GO
