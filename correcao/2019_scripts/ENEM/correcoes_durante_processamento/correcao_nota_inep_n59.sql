SELECT INE.redacao_id, nu_nota_FINAL,nu_nota_media_comp1,	nu_nota_media_comp2,	nu_nota_media_comp3,	nu_nota_media_comp4,	nu_nota_media_comp5,
       NOTA_FINAL = ABS(ANA.NOTA_FINAL_A + ANA.NOTA_FINAL_B) /2, 
       NOTA_COMP1 = ABS(ANA.NOTA_COMPETENCIA1_A + ANA.NOTA_COMPETENCIA1_B) /2, 
       NOTA_COMP2 = ABS(ANA.NOTA_COMPETENCIA2_A + ANA.NOTA_COMPETENCIA2_B) /2, 
       NOTA_COMP3 = ABS(ANA.NOTA_COMPETENCIA3_A + ANA.NOTA_COMPETENCIA3_B) /2, 
       NOTA_COMP4 = ABS(ANA.NOTA_COMPETENCIA4_A + ANA.NOTA_COMPETENCIA4_B) /2, 
       NOTA_COMP5 = ABS(ANA.NOTA_COMPETENCIA5_A + ANA.NOTA_COMPETENCIA5_B) /2, 
	   RED.nota_final, RED.nota_competencia1, RED.nota_competencia2, RED.nota_competencia3, RED.nota_competencia4, RED.nota_competencia5

-- UPDATE INE SET  
--     INE.nu_nota_media_comp1 = ABS(ANA.NOTA_COMPETENCIA1_A + ANA.NOTA_COMPETENCIA1_B) /2,
--     INE.nu_nota_media_comp2 = ABS(ANA.NOTA_COMPETENCIA2_A + ANA.NOTA_COMPETENCIA2_B) /2,
--     INE.nu_nota_media_comp3 = ABS(ANA.NOTA_COMPETENCIA3_A + ANA.NOTA_COMPETENCIA3_B) /2,
--     INE.nu_nota_media_comp4 = ABS(ANA.NOTA_COMPETENCIA4_A + ANA.NOTA_COMPETENCIA4_B) /2,
--     INE.nu_nota_media_comp5 = ABS(ANA.NOTA_COMPETENCIA5_A + ANA.NOTA_COMPETENCIA5_B) /2

FROM INEP_N59 INE JOIN [20191211].CORRECOES_ANALISE ANA ON (INE.REDACAO_ID = ANA.REDACAO_ID AND 
                                                            ANA.APROVEITAMENTO = 1)
				  JOIN CORRECOES_REDACAO            RED ON (RED.ID = INE.REDACAO_ID)
WHERE LOTE_ID = 107 AND 
      INE.nu_nota_final <> RED.nota_final
      INE.redacao_id = 3216920   


select * 

begin tran
   update red   set red.nota_competencia1 = lt107.nu_nota_media_comp1,
                    red.nota_competencia2 = lt107.nu_nota_media_comp2,
                    red.nota_competencia3 = lt107.nu_nota_media_comp3,
                    red.nota_competencia4 = lt107.nu_nota_media_comp4,
                    red.nota_competencia5 = lt107.nu_nota_media_comp5

from inep_n59 lt103 join inep_n59 lt107 on (lt103.redacao_id = lt107.redacao_id and 
                                                     lt103.lote_id = 103 and lt107.lote_id = 107)
					join [20191211].correcoes_redacao red on red.id = lt103.redacao_id

-- commit 
-- rollback 