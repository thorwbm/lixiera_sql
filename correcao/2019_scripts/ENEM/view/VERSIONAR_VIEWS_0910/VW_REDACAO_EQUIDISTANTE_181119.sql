/****** Object:  View [dbo].[vw_redacao_equidistante]    Script Date: 19/11/2019 15:37:54 ******/

create or alter  view [dbo].[vw_redacao_equidistante] as 
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
	  cor1.id_correcao_situacao = 1 

GO


