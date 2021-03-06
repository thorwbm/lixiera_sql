/****** Object:  View [dbo].[vw_prova_analise_cordgeral]    Script Date: 04/10/2019 10:16:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_prova_analise_cordgeral]
AS
SELECT DISTINCT 
                         r.id AS mascara, r.link_imagem_recortada, CASE WHEN r.link_imagem_recortada LIKE 'result/1810401_G%' THEN 'CESGRANRIO' WHEN r.link_imagem_recortada LIKE 'result/1810401_F%' THEN 'FGV' END AS empresa, 
                         r.co_inscricao, r.co_barra_redacao AS codigo_barra_redacao
FROM            dbo.ocorrencias_ocorrencia AS oc INNER JOIN
                         dbo.correcoes_correcao AS cc ON cc.id = oc.correcao_id INNER JOIN
                         dbo.correcoes_redacao AS r ON r.co_barra_redacao = cc.co_barra_redacao
WHERE        (oc.status_id = 11)
GO
