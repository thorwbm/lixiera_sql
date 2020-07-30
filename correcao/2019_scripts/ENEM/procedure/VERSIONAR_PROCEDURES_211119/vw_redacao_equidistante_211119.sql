/****** Object:  View [dbo].[vw_redacao_equidistante]    Script Date: 22/11/2019 15:33:53 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/****** Object:  View [dbo].[vw_redacao_equidistante]    Script Date: 19/11/2019 15:37:54 ******/

ALTER    view [dbo].[vw_redacao_equidistante] as 
select cor3.redacao_id, 
       cor3.id_projeto, 
       cor3.nota_final as nota_final3, 
       cor2.nota_final as nota_final2, 
	   cor1.nota_final as nota_final1 
  from correcoes_correcao cor3 join correcoes_correcao cor2 on (cor3.redacao_id = cor2.redacao_id and 
                                                                cor3.id_projeto = cor2.id_projeto and 
																cor3.id_tipo_correcao = 3 and
																cor2.id_tipo_correcao = 2)
                               join correcoes_correcao cor1 on (cor3.redacao_id = cor1.redacao_id and 
							                                    cor3.id_projeto = cor1.id_projeto and
																cor1.id_tipo_correcao = 1)
where abs(cor1.nota_final - cor3.nota_final) = abs(cor2.nota_final - cor3.nota_final) and 
      cor3.id_correcao_situacao = 1 and 
	  cor2.id_correcao_situacao = 1 and 
	  cor1.id_correcao_situacao = 1 AND 
	  
	  ABS(cor3.competencia1 - COR1.competencia1) <= 2 AND 
	  ABS(cor3.competencia2 - COR1.competencia2) <= 2 AND 
	  ABS(cor3.competencia3 - COR1.competencia3) <= 2 AND 
	  ABS(cor3.competencia4 - COR1.competencia4) <= 2 AND 
	  ABS(cor3.competencia5 - COR1.competencia5) <= 2 AND 
	  
	  ABS(cor3.competencia1 - COR2.competencia1) <= 2 AND 
	  ABS(cor3.competencia2 - COR2.competencia2) <= 2 AND 
	  ABS(cor3.competencia3 - COR2.competencia3) <= 2 AND 
	  ABS(cor3.competencia4 - COR2.competencia4) <= 2 AND 
	  ABS(cor3.competencia5 - COR2.competencia5) <= 2  


GO


