/****** Object:  View [dbo].[vw_correcoes_usuario]    Script Date: 04/10/2019 10:16:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   VIEW [dbo].[vw_correcoes_usuario] AS
      SELECT
        usuario.id as usuario_id,
        last_name as nome,
        count(correcao.id) AS nr_corrigidas,
        MAX(correcao.data_termino) AS ultima_correcao,
        uh.indice
    FROM auth_user usuario
    LEFT JOIN correcoes_correcao correcao ON correcao.id_corretor = usuario.id
    JOIN usuarios_hierarquia_usuarios uhu on uhu.user_id = usuario.id
    join usuarios_hierarquia uh on uh.id = uhu.hierarquia_id
    where correcao.data_termino is not null
    GROUP BY usuario.id, last_name, uh.indice

GO
