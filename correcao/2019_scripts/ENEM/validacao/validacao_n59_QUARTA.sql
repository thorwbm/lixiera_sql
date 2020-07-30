select ine.redacao_id, ine.lote_id, errro = 6 , ine.co_situacao_redacao_final , red.id_redacao_situacao--, COR3.ID, COR2.ID, COR1.ID, ine.nu_nota_final, ine.nu_nota_av1,  ine.nu_nota_av2,  ine.nu_nota_av3, diferenca = ABS(ine.nu_nota_av1- ine.nu_nota_av2)
from [dbo].[inep_n59] ine with(nolock) left join [20191205].[correcoes_redacao]  red  WITH(NOLOCK) ON (red.id = ine.redacao_id)
                                       LEFT JOIN [20191205].[correcoes_correcao] cor1 WITH(NOLOCK) ON (COR1.REDACAO_ID = ine.redacao_id AND 
                                                                                                       COR1.ID_TIPO_CORRECAO = 1 AND 
																									   COR1.ID_STATUS = 3)
									   LEFT JOIN [20191205].[correcoes_correcao] cor2 WITH(NOLOCK) ON (COR2.REDACAO_ID = ine.redacao_id AND 
                                                                                                       COR2.ID_TIPO_CORRECAO = 2 AND 
																									   COR2.ID_STATUS = 3)
									   LEFT JOIN [20191205].[correcoes_correcao] cor3 WITH(NOLOCK) ON (COR3.REDACAO_ID = ine.redacao_id AND 
                                                                                                       COR3.ID_TIPO_CORRECAO = 3 AND 
																									   COR3.ID_STATUS = 3)
									   left join [20191205].[correcoes_correcao] cor4 WITH(NOLOCK) ON (COR4.REDACAO_ID = ine.redacao_id AND 
                                                                                                       COR4.ID_TIPO_CORRECAO = 4)
									   left join [20191205].[correcoes_correcao] corA WITH(NOLOCK) ON (corA.REDACAO_ID = ine.redacao_id AND 
                                                                                                       corA.ID_TIPO_CORRECAO = 7)
									  left join [20191205].[vw_redacao_equidistante] equ  with(nolock) on (equ.redacao_id = ine.redacao_id)

  WHERE  ine.lote_id = 80 and               
         ine.nu_cpf_av3 is not null and 
         ine.nu_cpf_av1 is not null and 
		 ine.nu_cpf_av2 is not null and 
		 ine.nu_cpf_av4 is not null and
		 ine.nu_cpf_auditor is null and 
		  
		 (	( corA.id is not null) or 

		    (ine.nu_nota_final <> red.nota_final) or 
			(ine.nu_nota_comp1_av1 <> cor1.nota_competencia1 or 
			 ine.nu_nota_comp2_av1 <> cor1.nota_competencia2 or 
			 ine.nu_nota_comp3_av1 <> cor1.nota_competencia3 or 
			 ine.nu_nota_comp4_av1 <> cor1.nota_competencia4 or 
			 ine.nu_nota_comp5_av1 <> cor1.nota_competencia5)or 

			(ine.nu_nota_comp1_av2 <> cor2.nota_competencia1 or 
			 ine.nu_nota_comp2_av2 <> cor2.nota_competencia2 or 
			 ine.nu_nota_comp3_av2 <> cor2.nota_competencia3 or 
			 ine.nu_nota_comp4_av2 <> cor2.nota_competencia4 or
			 ine.nu_nota_comp5_av2 <> cor2.nota_competencia5) or
			  
			(ine.nu_nota_comp1_av3 <> cor3.nota_competencia1 or 
			 ine.nu_nota_comp2_av3 <> cor3.nota_competencia2 or 
			 ine.nu_nota_comp3_av3 <> cor3.nota_competencia3 or 
			 ine.nu_nota_comp4_av3 <> cor3.nota_competencia4 or 
			 ine.nu_nota_comp5_av3 <> cor3.nota_competencia5) or  
			  
			(ine.nu_nota_comp1_av4 <> cor4.nota_competencia1 or 
			 ine.nu_nota_comp2_av4 <> cor4.nota_competencia2 or 
			 ine.nu_nota_comp3_av4 <> cor4.nota_competencia3 or 
			 ine.nu_nota_comp4_av4 <> cor4.nota_competencia4 or 
			 ine.nu_nota_comp5_av4 <> cor4.nota_competencia5) or  
			 
			(ine.co_situacao_redacao_final <> red.id_correcao_situacao) OR 
			(ine.nu_nota_final <> COR4.NOTA_FINAL) AND 
			(ine.co_situacao_redacao_final <> COR4.id_correcao_situacao) OR 
			(INE.co_situacao_redacao_final = 1 AND INE.nu_nota_final = 0)
		 )

		 AND 
		 ine.co_situacao_redacao_final not in (4,8)
