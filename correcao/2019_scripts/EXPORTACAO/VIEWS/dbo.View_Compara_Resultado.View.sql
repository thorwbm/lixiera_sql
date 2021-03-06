/****** Object:  View [dbo].[View_Compara_Resultado]    Script Date: 04/10/2019 10:16:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[View_Compara_Resultado]
AS
SELECT        dbo.correcoes_redacao.co_barra_redacao, dbo.correcoes_redacao.co_inscricao, dbo.correcoes_redacao_resultado.nome_inscrito, dbo.correcoes_redacao.nota_final, 
                         dbo.correcoes_redacao_resultado.nota_final AS Nota_Final_Resultado, dbo.correcoes_redacao.id_correcao_situacao, dbo.correcoes_redacao_resultado.conclusao_final_detalhe
FROM            dbo.correcoes_redacao INNER JOIN
                         dbo.correcoes_redacao_resultado ON dbo.correcoes_redacao.co_barra_redacao = dbo.correcoes_redacao_resultado.co_barra_redacao
GO
