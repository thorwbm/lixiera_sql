--- AS NOTAS DAS COMPETENCIAS NOS GABARITOS ESTAVAM CALCULADAS EM 40 PONTOS E DEVERIA SER 50, MAS A NOTA FINAL ESTAVA CORRETA 


SELECT * FROM correcoes_analise
/*BEGIN TRAN 
 update correcoes_analise set 
                nota_competencia1_B = competencia1_B * 50,
                nota_competencia2_B = competencia2_B * 50, 
                nota_competencia3_B = competencia3_B * 50, 
                nota_competencia4_B = competencia4_B * 50 */
WHERE id_projeto = 1 AND 
      id_correcao_situacao_B = 1  

	--  COMMIT 

SELECT * FROM correcoes_analise
BEGIN TRAN 
 update correcoes_analise set 
                diferenca_competencia1 = ABS(nota_competencia1_B - NOTA_COMPETENCIA1_A),
                DIFERENCA_COMPETENCIA2 = ABS(NOTA_COMPETENCIA2_B - NOTA_COMPETENCIA2_A), 
                DIFERENCA_COMPETENCIA3 = ABS(NOTA_COMPETENCIA3_B - NOTA_COMPETENCIA3_A), 
                DIFERENCA_COMPETENCIA4 = ABS(NOTA_COMPETENCIA4_B - NOTA_COMPETENCIA4_A) 
WHERE id_projeto = 1 AND 
      id_correcao_situacao_B = 1  


	--  COMMIT 