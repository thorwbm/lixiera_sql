/****** Object:  View [dbo].[vw_correcao_correcoes]    Script Date: 04/10/2019 10:16:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_correcao_correcoes]
AS
SELECT        TOP (100) PERCENT dbo.correcoes_correcao.id, dbo.correcoes_correcao.data_inicio, dbo.correcoes_correcao.data_termino, dbo.correcoes_correcao.correcao, dbo.correcoes_correcao.link_imagem_recortada, 
                         dbo.correcoes_correcao.link_imagem_original, dbo.correcoes_correcao.nota_final, dbo.correcoes_correcao.competencia1, dbo.correcoes_correcao.competencia2, dbo.correcoes_correcao.competencia3, 
                         dbo.correcoes_correcao.competencia4, dbo.correcoes_correcao.competencia5, dbo.correcoes_correcao.nota_competencia1, dbo.correcoes_correcao.nota_competencia2, dbo.correcoes_correcao.nota_competencia3, 
                         dbo.correcoes_correcao.nota_competencia4, dbo.correcoes_correcao.nota_competencia5, dbo.correcoes_correcao.id_auxiliar1, dbo.correcoes_correcao.id_auxiliar2, dbo.correcoes_correcao.id_correcao_situacao, 
                         dbo.correcoes_situacao.descricao, dbo.correcoes_correcao.id_corretor, dbo.correcoes_correcao.id_status, dbo.correcoes_status.descricao AS status_correcao, dbo.correcoes_correcao.id_tipo_correcao, 
                         dbo.correcoes_tipo.descricao AS tipo_correcao, dbo.correcoes_correcao.id_projeto, dbo.projeto_projeto.descricao AS Projeto, dbo.correcoes_correcao.co_barra_redacao, dbo.correcoes_corretor.id AS IdCorretor, 
                         dbo.correcoes_corretor.id_grupo, dbo.correcoes_grupocorretor.grupo, dbo.correcoes_grupocorretor.proficiencia, dbo.auth_user.username, dbo.auth_user.first_name, dbo.auth_user.last_name
FROM            dbo.correcoes_corretor INNER JOIN
                         dbo.correcoes_grupocorretor ON dbo.correcoes_corretor.id_grupo = dbo.correcoes_grupocorretor.id INNER JOIN
                         dbo.auth_user ON dbo.correcoes_corretor.id = dbo.auth_user.id RIGHT OUTER JOIN
                         dbo.correcoes_correcao ON dbo.correcoes_corretor.id = dbo.correcoes_correcao.id_corretor LEFT OUTER JOIN
                         dbo.projeto_projeto ON dbo.correcoes_correcao.id_projeto = dbo.projeto_projeto.id LEFT OUTER JOIN
                         dbo.correcoes_tipo ON dbo.correcoes_correcao.id_tipo_correcao = dbo.correcoes_tipo.id LEFT OUTER JOIN
                         dbo.correcoes_situacao ON dbo.correcoes_correcao.id_correcao_situacao = dbo.correcoes_situacao.id LEFT OUTER JOIN
                         dbo.correcoes_status ON dbo.correcoes_correcao.id_status = dbo.correcoes_status.id
GO
