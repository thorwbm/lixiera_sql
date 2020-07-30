BEGIN TRAN;
WITH CTE_PLANOS_DET AS (  
   SELECT DISTINCT  curriculum, NOME, [data vencimento] AS DT_VENCIMENTO
     FROM planos_de_pagamento_detalhados DET 
	 WHERE NOT EXISTS (SELECT curriculum, NAME, due_date, pla.* 
	                     FROM onboarding_onboarding ONB JOIN  onboarding_financeplan PLA ON(ONB.ID = PLA.onboarding_id)
                        WHERE ONB.curriculum = DET.curriculum AND 
						      PLA.NAME       = DET.nome       AND
							  PLA.due_date   = DET.[data vencimento]) 
)
--- SELECT * FROM onboarding_financeplan

INSERT INTO onboarding_financeplan (NAME, VALUE, DUE_DATE, installments, GUARANTORS, installment_value, [order], message, for_fies,removed,onboarding_id)
SELECT --PLA.*,
       PLA.NAME, PLA.VALUE, DUE_DATE = DET.DT_VENCIMENTO, PLA.installments, PLA.GUARANTORS, PLA.installment_value, PLA.[order], PLA.[MESSAGE], PLA.FOR_FIES, PLA.REMOVED, PLA.ONBOARDING_ID

FROM  onboarding_onboarding ONB JOIN CTE_PLANOS_DET DET ON (ONB.CURRICULUM =DET.CURRICULUM)
                                JOIN  onboarding_financeplan PLA ON(ONB.ID = PLA.onboarding_id AND 
										                            PLA.NAME = DET.NOME)
 WHERE NOT EXISTS (SELECT 1
                     FROM onboarding_onboarding ONBX JOIN onboarding_financeplan PLAX ON (ONBX.ID = PLAX.onboarding_id)
					WHERE ONBX.ID = ONB.ID AND 
					      PLAX.due_date = DET.DT_VENCIMENTO AND 
						  PLAX.name = PLA.NAME)


-- COMMIT
-- ROLLBACK 