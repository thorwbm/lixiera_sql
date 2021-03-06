/****** Object:  View [dbo].[Vw_Checa_Nota_Redacao_Resultado]    Script Date: 04/10/2019 10:16:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [dbo].[Vw_Checa_Nota_Redacao_Resultado]
AS
SELECT        dbo.correcoes_redacao.co_barra_redacao, dbo.correcoes_redacao.nota_final, dbo.correcoes_redacao_resultado.nota_final_n59, dbo.correcoes_redacao.co_inscricao, 
                         dbo.correcoes_redacao_resultado.nota_final AS Nota_Final_Resultado
FROM            dbo.correcoes_redacao INNER JOIN
                         dbo.correcoes_redacao_resultado ON dbo.correcoes_redacao.co_inscricao = dbo.correcoes_redacao_resultado.co_inscricao
GO
