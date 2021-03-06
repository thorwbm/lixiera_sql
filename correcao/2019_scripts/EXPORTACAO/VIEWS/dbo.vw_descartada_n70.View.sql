/****** Object:  View [dbo].[vw_descartada_n70]    Script Date: 04/10/2019 10:16:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   view [dbo].[vw_descartada_n70] as  
select  aud.co_barra_redacao,   
        cor.id_tipo_correcao,  
  descartada = case when (isnull(aud.nota_final  ,0) = isnull(cor.nota_final  ,0) and   
                          isnull(aud.competencia1,0) = isnull(cor.competencia1,0) and  
                          isnull(aud.competencia2,0) = isnull(cor.competencia2,0) and  
                          isnull(aud.competencia3,0) = isnull(cor.competencia3,0) and  
                          isnull(aud.competencia4,0) = isnull(cor.competencia4,0) and  
                          isnull(aud.competencia5,0) = isnull(cor.competencia5,0) and  
                          aud.id_correcao_situacao = cor.id_correcao_situacao) then 0 else 1 end  
  from correcoes_correcao aud with (nolock) join correcoes_correcao cor with (nolock) on (aud.co_barra_redacao = cor.co_barra_redacao and   
                                                                                          aud.id_tipo_correcao = 7 ) 
GO
