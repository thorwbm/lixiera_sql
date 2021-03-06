/****** Object:  View [20191223].[vw_descartada_n70]    Script Date: 26/12/2019 13:14:39 ******/
DROP VIEW IF EXISTS [20191223].[vw_descartada_n70]
GO
/****** Object:  View [20191223].[vw_descartada_n70]    Script Date: 26/12/2019 13:14:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


	create   view [20191223].[vw_descartada_n70] as    
		select  aud.redacao_id,     
				cor.id_tipo_correcao,    
		  descartada = case when (isnull(aud.nota_final  ,0) = isnull(cor.nota_final  ,0) and     
								  isnull(aud.competencia1,0) = isnull(cor.competencia1,0) and    
								  isnull(aud.competencia2,0) = isnull(cor.competencia2,0) and    
								  isnull(aud.competencia3,0) = isnull(cor.competencia3,0) and    
								  isnull(aud.competencia4,0) = isnull(cor.competencia4,0) and    
								  isnull(aud.competencia5,0) = isnull(cor.competencia5,0) and    
								  aud.id_correcao_situacao = cor.id_correcao_situacao) then 0 else 1 end    
		  from [20191223].correcoes_correcao aud join [20191223].correcoes_correcao cor on (aud.redacao_id = cor.redacao_id and     
																	                                            aud.id_tipo_correcao = 7 ) 
	
GO
