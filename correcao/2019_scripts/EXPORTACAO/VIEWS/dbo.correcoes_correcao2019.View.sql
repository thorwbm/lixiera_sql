/****** Object:  View [dbo].[correcoes_correcao2019]    Script Date: 04/10/2019 10:16:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[correcoes_correcao2019] as select * from correcoes_correcao where id_corretor in (select user_id from usuarios_hierarquia_usuarios where hierarquia_id > 400)
GO
