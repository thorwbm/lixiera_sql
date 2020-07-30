select ID, redacao_id, id_projeto, id_tipo_correcao_a, id_tipo_correcao_B,id_correcao_situacao_a, id_correcao_situacao_B, id_correcao_B,nota_final_B, conclusao_analise,* 
from correcoes_analise
where id_correcao_B is not null and nota_final_B is null 

select DISTINCT ana.* --situacao_nota_final, ana.nota_final_a,ana.nota_final_B , cor.nota_final,ana.id, cor.id--, anax.* 
 UPDATE ana SET 
         ANA.data_termino_B = COR.data_termino, ANA.competencia1_B = cor.competencia1, ANA.competencia2_B = cor.competencia2, 
		 ANA.competencia3_B = cor.competencia3, ANA.competencia4_B = cor.competencia4, ANA.competencia5_B = cor.competencia5, 
		 ANA.nota_final_B = cor.nota_final, ANA.NOTA_competencia1_B = cor.nota_competencia1, ANA.NOTA_competencia2_B = cor.nota_competencia2, 
		 ANA.NOTA_competencia3_B = cor.nota_competencia3, ANA.NOTA_competencia4_B = cor.nota_competencia4, ANA.NOTA_competencia5_B = cor.nota_competencia5, 
							  ANA.id_status_B= cor.id_status
  from correcoes_analise ana join correcoes_correcao cor on (ana.redacao_id = cor.redacao_id and 
                                                             ana.id_tipo_correcao_B = 2      and
															 ana.id_correcao_B      = cor.id)
							 
						   left join correcoes_analise anax on (anax.redacao_id = ana.redacao_id and
						                                        anax.id_tipo_correcao_B > 2 )

where --ana.redacao_id = 369511 and 
      isnull(ana.nota_final_B,-5) <> cor.nota_final


	  
	  select data_termino_B, competencia1_B, competencia2_B, competencia3_B, competencia4_B, competencia5_B,nota_final_B,
	                          NOTA_competencia1_B, NOTA_competencia2_B, NOTA_competencia3_B, NOTA_competencia4_B, NOTA_competencia5_B, 
							  id_status_B, id_status_A, id_tipo_correcao_B,
							  *
	   from correcoes_analise where id = 61276
	  select DATA_TERMINO, competencia1, competencia2, competencia3, competencia4, competencia5, nota_final,
	                          NOTA_competencia1, NOTA_competencia2, NOTA_competencia3, NOTA_competencia4, NOTA_competencia5, 
							  id_statuS,* 
	   FROM correcoes_CORRECAO where id = 121178



