/****** Object:  View [dbo].[correcoes_analise2019]    Script Date: 04/10/2019 10:16:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[correcoes_analise2019] as select * from correcoes_analise where id_corretor_A in (select user_id from usuarios_hierarquia_usuarios where hierarquia_id > 400) or id_correcao_B in (select user_id from usuarios_hierarquia_usuarios where id > 400)
GO
