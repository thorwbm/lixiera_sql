/*
SELECT ID,id_correcao_situacao,id_projeto,nota_final, nota_competencia1,* FROM correcoes_CORRECAO 
WHERE id_correcao_situacao > 1 AND 
      ID_PROJETO = 1    
	  AND COMPETENCIA5 = -1 
*/

/*CREATE PROCEDURE SP_COR_VALIDAR_CORRECAO 
                 @REDACAO_ID INT, @ID_CORRECAO INT, @TIPO_GRAVACAO INT,	@ID_PROJETO INT 
AS 
*/

									/***********************************
											TIPOS DE GRAVACAO 

										1-(COMPARACAO 1,2) 
										2-(COMPARACAO 1,3) 
										3-(COMPARACAO 2-3) 
										4-(COMPARACAO 3-4)
										5-(COMPARACAO 5 E OURO) 
										6-(COMPARACAO 6-MODA) 
										7-(COMPAFRACAO 7-ABSOLUTA)
									************************************/

/*
-1		2074937	409859
-1		 285770	442814
114206	2147
14311	2822
14464	3514

*/

-- select redacao_id, id, id_projeto, * from correcoes_correcao where id_tipo_correcao = 3


DECLARE @REDACAO_ID INT, @ID_CORRECAO INT, @TIPO_GRAVACAO INT,	@ID_PROJETO INT, @STATUS INT
	SET @REDACAO_ID = 273516
	SET @ID_CORRECAO = 1416  
	SET @ID_PROJETO = 4
	SET @TIPO_GRAVACAO = 2
	SET @STATUS = 0 -- (1 - OK / 0 - PROBLEMA) 


-- VALIDAR SE AS COMPETENCIAS ESTAO CORRETAS
-- ******* VALIDACAO DAS CORRECOES  *******
SELECT  @STATUS = COUNT(1)
      -- COR.nota_final , (COR.nota_competencia1 + COR.nota_competencia2 + COR.nota_competencia3 + COR.nota_competencia4 + CASE WHEN PRO.etapa_ensino_id = 2 THEN COR.nota_competencia5 ELSE 0 END ),* 
FROM correcoes_correcao COR WITH(NOLOCK) JOIN projeto_projeto PRO WITH(NOLOCK) ON (COR.id_projeto = PRO.ID)
WHERE COR.id         = @ID_CORRECAO  AND  
      COR.id_projeto = @ID_PROJETO   AND 
	  COR.id_status  = 3             AND

	  ((COR.id_correcao_situacao > 1 AND      -- VALINDANDO PREENCHIMENTO DAS COMPETENCIAS
	    COR.competencia1 IS NULL     AND      -- VALINDANDO PREENCHIMENTO DAS COMPETENCIAS
	    COR.competencia2 IS NULL     AND 	  -- VALINDANDO PREENCHIMENTO DAS COMPETENCIAS
	    COR.competencia3 IS NULL     AND	  -- VALINDANDO PREENCHIMENTO DAS COMPETENCIAS
	    COR.competencia4 IS NULL     AND 	  -- VALINDANDO PREENCHIMENTO DAS COMPETENCIAS
	    COR.competencia5 IS NULL)     OR	  -- VALINDANDO PREENCHIMENTO DAS COMPETENCIAS
	   (COR.id_correcao_situacao = 1 AND	  -- VALINDANDO PREENCHIMENTO DAS COMPETENCIAS
	    COR.competencia1 IS NOT NULL AND	  -- VALINDANDO PREENCHIMENTO DAS COMPETENCIAS
      	COR.competencia2 IS NOT NULL AND	  -- VALINDANDO PREENCHIMENTO DAS COMPETENCIAS
		COR.competencia3 IS NOT NULL AND	  -- VALINDANDO PREENCHIMENTO DAS COMPETENCIAS
		COR.competencia4 IS NOT NULL AND	  -- VALINDANDO PREENCHIMENTO DAS COMPETENCIAS
		((COR.competencia5 IS NOT NULL AND 	    -- VALINDANDO PREENCHIMENTO DAS COMPETENCIAS - DEPENDE DO TIPO DO PROCESSO EF OU EM
		  PRO.etapa_ensino_id = 2        )  OR	-- VALINDANDO PREENCHIMENTO DAS COMPETENCIAS - DEPENDE DO TIPO DO PROCESSO EF OU EM
		 (ISNULL(COR.competencia5,-1) = -1 AND  -- VALINDANDO PREENCHIMENTO DAS COMPETENCIAS - DEPENDE DO TIPO DO PROCESSO EF OU EM
		  PRO.etapa_ensino_id = 1)))  )    AND  -- VALINDANDO PREENCHIMENTO DAS COMPETENCIAS - DEPENDE DO TIPO DO PROCESSO EF OU EM

	  ((COR.id_correcao_situacao > 1 AND COR.nota_final = 0) OR  -- SITUACAO DIFERENTE DE NORMAL A NOTA FINAL TEM QUE SER ZERO
	   (COR.id_correcao_situacao = 1 AND 
	    COR.nota_final = (COR.nota_competencia1 + COR.nota_competencia2 + COR.nota_competencia3 + COR.nota_competencia4 + 
		                  CASE WHEN PRO.etapa_ensino_id = 2 THEN COR.nota_competencia5 ELSE 0 END ))) AND -- SITUACAO NORMAL A SOMA DAS COMPETENCIAS TEM QUE SER IGUAL A NOTA TOTAL 
	
	(ISNULL(competencia1,0) * PRO.peso_competencia = nota_competencia1 AND -- VALIDAR SE O CALCULO DA NOTA POR COMPETENCIA ESTA CORRETO 
	 ISNULL(competencia2,0) * PRO.peso_competencia = nota_competencia2 AND -- VALIDAR SE O CALCULO DA NOTA POR COMPETENCIA ESTA CORRETO 
	 ISNULL(competencia3,0) * PRO.peso_competencia = nota_competencia3 AND -- VALIDAR SE O CALCULO DA NOTA POR COMPETENCIA ESTA CORRETO 
	 ISNULL(competencia4,0) * PRO.peso_competencia = nota_competencia4 AND -- VALIDAR SE O CALCULO DA NOTA POR COMPETENCIA ESTA CORRETO 
	 CASE WHEN COMPETENCIA5 = -1 THEN 0 ELSE ISNULL(competencia5,0) END *  -- VALIDAR SE O CALCULO DA NOTA POR COMPETENCIA ESTA CORRETO 
	            PRO.peso_competencia = ISNULL(nota_competencia5,0))        -- VALIDAR SE O CALCULO DA NOTA POR COMPETENCIA ESTA CORRETO 
PRINT @STATUS 
--########################################################################################################
/*** TESTAR SE A REDACAO POSSUI STATUS DE CONCLUIDA E SE ENCONTRA ABERTA EM ALGUMA FILA DE CORRECAO OU COM CORRECAO AINDA EM ABERTO ***/
IF( @STATUS = 1)
    BEGIN
		SELECT *-- @STATUS = COUNT (distinct 1) 
		  FROM correcoes_redacao RED WITH(NOLOCK) LEFT JOIN correcoes_correcao      COR WITH(NOLOCK) ON (RED.id = COR.redacao_id)
		                                          LEFT JOIN correcoes_tipo          CRT WITH(NOLOCK) ON (CRT.id = COR.id_tipo_correcao)
												  LEFT JOIN correcoes_fila1         FIL1 WITH(NOLOCK) ON (RED.id = FIL1.redacao_id)
												  LEFT JOIN correcoes_fila2         FIL2 WITH(NOLOCK) ON (RED.id = FIL2.redacao_id)
												  LEFT JOIN correcoes_fila3         FIL3 WITH(NOLOCK) ON (RED.id = FIL3.redacao_id)
												  LEFT JOIN correcoes_fila4         FIL4 WITH(NOLOCK) ON (RED.id = FIL4.redacao_id)
												  LEFT JOIN correcoes_filaAUDITORIA FILA WITH(NOLOCK) ON (RED.id = FILA.redacao_id)
												  LEFT JOIN correcoes_filaOURO      FILO WITH(NOLOCK) ON (RED.id = FILO.redacao_id)
												  LEFT JOIN correcoes_filapessoal   FILP WITH(NOLOCK) ON (RED.id = FILP.redacao_id)

		 WHERE RED.id = @REDACAO_ID AND 
		       RED.id_projeto = @ID_PROJETO AND              
			   ((RED.id_status  = 4 AND 			       -- CASO EXISTA FINALIZACAO NA REDACAO (STATUS = 4 E DATA) E AINDA ASSIM EXISTA REGISTRO EM FILAS OU CORRECAO ABERTA <> 3
			     -- RED.DATA_CONCLUSAO IS NULL AND      -- CASO EXISTA FINALIZACAO NA REDACAO (STATUS = 4 E DATA) E AINDA ASSIM EXISTA REGISTRO EM FILAS OU CORRECAO ABERTA <> 3
			      (COR.id  IS NULL    OR  			   -- CASO EXISTA FINALIZACAO NA REDACAO (STATUS = 4 E DATA) E AINDA ASSIM EXISTA REGISTRO EM FILAS OU CORRECAO ABERTA <> 3
				   FIL1.id IS NULL    OR 			   -- CASO EXISTA FINALIZACAO NA REDACAO (STATUS = 4 E DATA) E AINDA ASSIM EXISTA REGISTRO EM FILAS OU CORRECAO ABERTA <> 3
				   FIL2.id IS NULL    OR 			   -- CASO EXISTA FINALIZACAO NA REDACAO (STATUS = 4 E DATA) E AINDA ASSIM EXISTA REGISTRO EM FILAS OU CORRECAO ABERTA <> 3
				   FIL3.id IS NULL    OR 			   -- CASO EXISTA FINALIZACAO NA REDACAO (STATUS = 4 E DATA) E AINDA ASSIM EXISTA REGISTRO EM FILAS OU CORRECAO ABERTA <> 3
				   FIL4.id IS NULL    OR 			   -- CASO EXISTA FINALIZACAO NA REDACAO (STATUS = 4 E DATA) E AINDA ASSIM EXISTA REGISTRO EM FILAS OU CORRECAO ABERTA <> 3
				   FILA.id IS NULL    OR			       -- CASO EXISTA FINALIZACAO NA REDACAO (STATUS = 4 E DATA) E AINDA ASSIM EXISTA REGISTRO EM FILAS OU CORRECAO ABERTA <> 3
				   FILO.id IS NULL    OR			       -- CASO EXISTA FINALIZACAO NA REDACAO (STATUS = 4 E DATA) E AINDA ASSIM EXISTA REGISTRO EM FILAS OU CORRECAO ABERTA <> 3
				   FILP.id IS NULL    OR
				   COR.id_status <> 3) ) OR 			   -- CASO EXISTA FINALIZACAO NA REDACAO (STATUS = 4 E DATA) E AINDA ASSIM EXISTA REGISTRO EM FILAS OU CORRECAO ABERTA <> 3
	            (RED.id_status  <> 4 AND 			   
			     -- RED.DATA_CONCLUSAO IS NULL AND     
			      (FIL1.id IS NOT NULL    OR 			   
				   FIL2.id IS NOT NULL    OR 			   
				   FIL3.id IS NOT NULL    OR 			   
				   FIL4.id IS NOT NULL    OR 			   
				   FILA.id IS NOT NULL    OR			   
				   FILO.id IS NOT NULL    OR			   
				   FILP.id IS NOT NULL    or 
				   COR.id_status <> 3  ) )
				)
	END

print @status
---##################################################################################################
IF(@TIPO_GRAVACAO = 1 AND @STATUS = 1) -- QUANDO FOR COMPARACAO DE 1 COM 2 
	BEGIN
		SELECT @STATUS = COUNT(1)
		  FROM correcoes_analise ANA WITH(NOLOCK) JOIN correcoes_conclusao_analise CCA  WITH(NOLOCK) ON (ANA.conclusao_analise = CCA.id)
		                                          JOIN correcoes_redacao           RED  WITH(NOLOCK) ON (ANA.redacao_id        = RED.ID AND 
												                                                         ANA.id_projeto        = RED.id_projeto)
											 LEFT JOIN correcoes_fila3             FIL3 WITH(NOLOCK) ON (FIL3.redacao_id       = ANA.redacao_id and 
											                                                             FIL3.id_projeto       = ANA.id_projeto)
											 LEFT JOIN CORRECOES_CORRECAO          COR3 WITH(NOLOCK) ON (COR3.redacao_id       = ANA.redacao_id AND 
											                                                             COR3.id_projeto       = ANA.id_projeto AND 
																										 COR3.id_tipo_correcao = 3)
											 LEFT JOIN CORRECOES_FILA4             FIL4 WITH(NOLOCK) ON (FIL4.redacao_id       = ANA.redacao_id and 
											                                                             FIL4.id_projeto       = ANA.id_projeto)
											 LEFT JOIN CORRECOES_CORRECAO          COR4 WITH(NOLOCK) ON (COR4.redacao_id       = ANA.redacao_id AND 
											                                                             COR4.id_projeto       = ANA.id_projeto AND 
																										 COR4.id_tipo_correcao = 4)
		  WHERE ANA.redacao_id     = @REDACAO_ID   AND
		        ANA.id_projeto     = @ID_PROJETO   AND 
				ANA.id_tipo_correcao_B = 2         AND 
				(ANA.id_correcao_A = @ID_CORRECAO   OR 
		         ANA.id_correcao_B = @ID_CORRECAO) AND
				((CCA.discrepou = 0              AND     -- ** SE NAO DISCREPAR {
				  ISNULL(RED.id_status,4) = 4    AND     -- O STATUS DA REDACAO TEM QUE SER 4             AJUSTE - AINDA NAO ESTA SENDO GRAVADO O STATUS E A DATA DE CONCLUSAO 
				  RED.DATA_CONCLUSAO IS NOT NULL AND     -- A DATA DE CONCLUSAO DEVERA ESTAR PREENCHIDA   AJUSTE - AINDA NAO ESTA SENDO GRAVADO O STATUS E A DATA DE CONCLUSAO
				  FIL3.ID IS NULL                AND     -- NAO PODE TER REGISTRO NA FILA 3
				  COR3.ID IS NULL                AND     -- NAO PODE TER REGISTRO DE CORRECAO DE TERCEIRA 
				  FIL4.ID IS NULL                AND     -- NAO PODE TER REGSITRO NA FILA 4
				  COR4.id IS NULL                        -- NAO PODE TER REGISTRO DE CORRECAO DE QUARTA }
				  ) OR 
				 (CCA.discrepou = 1                AND     -- * SE DISCREPOU {
				  ISNULL(RED.id_status,3) IN (2,3) AND     -- O STATUS DA REDACAO TEM QUE SER 2 OU 3        AJUSTE - AINDA NAO ESTA SENDO GRAVADO O STATUS E A DATA DE CONCLUSAO
		/*        RED.DATA_CONCLUSAO IS NULL*/			   -- A DATA DE CONCLUSAO DEVERA ESTAR NULA         AJUSTE - AINDA NAO ESTA SENDO GRAVADO O STATUS E A DATA DE CONCLUSAO
		          (FIL3.ID IS NOT NULL              OR     -- DEVERA TER SIDO GERADO UM REGISTRO EM ALGUMA DESTAS TABELAS 
				   COR3.ID IS NOT NULL              OR     -- DEVERA TER SIDO GERADO UM REGISTRO EM ALGUMA DESTAS TABELAS 
				   FIL4.ID IS NOT NULL              OR     -- DEVERA TER SIDO GERADO UM REGISTRO EM ALGUMA DESTAS TABELAS 
				   COR4.id IS NOT NULL)                    -- DEVERA TER SIDO GERADO UM REGISTRO EM ALGUMA DESTAS TABELAS 
				  ) 
		        )
    END
print @status
---##################################################################################################

--   select id_projeto,redacao_id,id_correcao_b, id_tipo_correcao_A,  id_tipo_correcao_b, * from correcoes_analise where redacao_id =20506 and id_correcao_A = 16367
--   select top 1000 redacao_id, id, id_projeto, * from correcoes_CORRECAO cor
--   where id_tipo_correcao = 2 and id_correcao_situacao <> 1 and exists (select 1 from correcoes_analise ana where ana.id_correcao_A  = cor.id and ana.id_tipo_correcao_B = 3  )

/****  QUANDO FOR COMPARACAO DE  1 COM 3 e a TERCEIRA FOR ABSOLUTA ***/
IF(@TIPO_GRAVACAO =2 AND @STATUS = 1) -- QUANDO FOR COMPARACAO DE 1 COM 3  
	BEGIN
	 
		SELECT  @STATUS = COUNT (distinct 1)
		  FROM CORRECOES_ANALISE ANA WITH(NOLOCK) JOIN projeto_projeto PRO WITH(NOLOCK) ON (ana.id_projeto = PRO.ID)
		                                          JOIN correcoes_conclusao_analise CCA  WITH(NOLOCK) ON (ANA.conclusao_analise = CCA.id)
		                                          JOIN correcoes_redacao           RED  WITH(NOLOCK) ON (ANA.redacao_id        = RED.ID AND 
												                                                         ANA.id_projeto        = RED.id_projeto)
											      JOIN correcoes_CORRECAO          COR1 WITH(NOLOCK) ON (COR1.redacao_id       = ANA.redacao_id AND 
												                                                         COR1.id               = ANA.id_correcao_A and 
												                                                         COR1.id_projeto       = ANA.id_projeto)
												 JOIN VW_FILAS_DA_REDACAO            FIL WITH(NOLOCK) ON (FIL.REDACAO_ID = ANA.redacao_id AND 
												                                                        FIL.id_projeto = ANA.id_projeto)
	     WHERE ANA.redacao_id    = @REDACAO_ID  AND 
		       ANA.id_projeto    = @ID_PROJETO  AND 
			   ANA.id_correcao_b = @ID_CORRECAO AND  
			   FIL.FILA          = 0            AND 
		       ANA.id_tipo_correcao_A = 1       AND 
		       ANA.id_tipo_correcao_B = 3       AND 
			   (EXISTS (select 1 from correcoes_tipo where id = 3 and flag_soberano = 1 ) AND 
					(
						(COR1.id_correcao_situacao = 1 AND	  -- VALINDANDO PREENCHIMENTO DAS COMPETENCIAS
						 COR1.competencia1 IS NOT NULL AND	  -- VALINDANDO PREENCHIMENTO DAS COMPETENCIAS
      					 COR1.competencia2 IS NOT NULL AND	  -- VALINDANDO PREENCHIMENTO DAS COMPETENCIAS
						 COR1.competencia3 IS NOT NULL AND	  -- VALINDANDO PREENCHIMENTO DAS COMPETENCIAS
						 COR1.competencia4 IS NOT NULL AND	  -- VALINDANDO PREENCHIMENTO DAS COMPETENCIAS
		                (	(COR1.competencia5 IS NOT NULL AND -- VALINDANDO PREENCHIMENTO DAS COMPETENCIAS - DEPENDE DO TIPO DO PROCESSO EF OU EM
				 			 PRO.etapa_ensino_id = 2        
							)  OR	-- VALINDANDO PREENCHIMENTO DAS COMPETENCIAS - DEPENDE DO TIPO DO PROCESSO EF OU EM
				 			(ISNULL(COR1.competencia5,-1) = -1 AND  -- VALINDANDO PREENCHIMENTO DAS COMPETENCIAS - DEPENDE DO TIPO DO PROCESSO EF OU EM
				 	         PRO.etapa_ensino_id = 1)              -- VALINDANDO PREENCHIMENTO DAS COMPETENCIAS - DEPENDE DO TIPO DO PROCESSO EF OU EM
							)
						)or         -- VALINDANDO PREENCHIMENTO DAS COMPETENCIAS - DEPENDE DO TIPO DO PROCESSO EF OU EM 
						(COR1.id_correcao_situacao <> 1 AND -- VALINDANDO PREENCHIMENTO DAS COMPETENCIAS
						 COR1.competencia1 IS NULL AND	  -- VALINDANDO PREENCHIMENTO DAS COMPETENCIAS
      					 COR1.competencia2 IS NULL AND	  -- VALINDANDO PREENCHIMENTO DAS COMPETENCIAS
						 COR1.competencia3 IS NULL AND	  -- VALINDANDO PREENCHIMENTO DAS COMPETENCIAS
						 COR1.competencia4 IS NULL AND    -- VALINDANDO PREENCHIMENTO DAS COMPETENCIAS
						 COR1.competencia5 IS NULL 
						)
					)         
			    )	
	END 
print @status
---##################################################################################################
 
/****  QUANDO FOR COMPARACAO DE  2 COM 3 e a TERCEIRA FOR ABSOLUTA ***/
IF(@TIPO_GRAVACAO =3 AND @STATUS = 1) -- QUANDO FOR COMPARACAO DE 2 COM 3  
	BEGIN
		SELECT  @STATUS = COUNT (distinct 1)
		  FROM CORRECOES_ANALISE ANA WITH(NOLOCK) JOIN projeto_projeto PRO WITH(NOLOCK) ON (ana.id_projeto = PRO.ID)
		                                          JOIN correcoes_conclusao_analise CCA  WITH(NOLOCK) ON (ANA.conclusao_analise  = CCA.id)
		                                          JOIN correcoes_redacao           RED  WITH(NOLOCK) ON (ANA.redacao_id         = RED.ID AND 
												                                                         ANA.id_projeto         = RED.id_projeto)
											      JOIN correcoes_CORRECAO          COR2 WITH(NOLOCK) ON (COR2.redacao_id        = ANA.redacao_id AND 
												                                                         COR2.id                = ANA.id_correcao_A AND 
												                                                         COR2.id_projeto        = ANA.id_projeto)
												  JOIN correcoes_CORRECAO          COR1 WITH(NOLOCK) ON (COR1.redacao_id        = ANA.redacao_id AND 
												                                                         COR1.id                = ANA.id_correcao_A AND 
																										 COR1.id_projeto        = ANA.id_projeto)
	     WHERE ANA.redacao_id    = @REDACAO_ID  AND 
		       ANA.id_projeto    = @ID_PROJETO  AND 
			   ANA.id_correcao_b = @ID_CORRECAO AND 
		       ANA.id_tipo_correcao_A = 2       AND 
		       ANA.id_tipo_correcao_B = 3       AND 
			   (EXISTS (select 1 from correcoes_tipo where id = 3 and flag_soberano = 1 ) AND 
					(COR2.id = ANA.id_correcao_A    AND 
						(COR2.id_correcao_situacao = 1 AND	  -- VALINDANDO PREENCHIMENTO DAS COMPETENCIAS
						 COR2.competencia1 IS NOT NULL AND	  -- VALINDANDO PREENCHIMENTO DAS COMPETENCIAS
      					 COR2.competencia2 IS NOT NULL AND	  -- VALINDANDO PREENCHIMENTO DAS COMPETENCIAS
						 COR2.competencia3 IS NOT NULL AND	  -- VALINDANDO PREENCHIMENTO DAS COMPETENCIAS
						 COR2.competencia4 IS NOT NULL AND	  -- VALINDANDO PREENCHIMENTO DAS COMPETENCIAS
							(	(COR2.competencia5 IS NOT NULL     AND  -- VALINDANDO PREENCHIMENTO DAS COMPETENCIAS - DEPENDE DO TIPO DO PROCESSO EF OU EM
				 					PRO.etapa_ensino_id = 2  	)  OR	-- VALINDANDO PREENCHIMENTO DAS COMPETENCIAS - DEPENDE DO TIPO DO PROCESSO EF OU EM
				 				(ISNULL(COR2.competencia5,-1) = -1 AND  -- VALINDANDO PREENCHIMENTO DAS COMPETENCIAS - DEPENDE DO TIPO DO PROCESSO EF OU EM
				 				 PRO.etapa_ensino_id = 1
								)
							)
					)    or         -- VALINDANDO PREENCHIMENTO DAS COMPETENCIAS - DEPENDE DO TIPO DO PROCESSO EF OU EM 
				    (COR2.id_correcao_situacao <> 1  AND -- VALINDANDO PREENCHIMENTO DAS COMPETENCIAS
				     COR2.competencia1 IS NULL AND	  -- VALINDANDO PREENCHIMENTO DAS COMPETENCIAS
      			     COR2.competencia2 IS NULL AND	  -- VALINDANDO PREENCHIMENTO DAS COMPETENCIAS
				     COR2.competencia3 IS NULL AND	  -- VALINDANDO PREENCHIMENTO DAS COMPETENCIAS
				     COR2.competencia4 IS NULL AND    -- VALINDANDO PREENCHIMENTO DAS COMPETENCIAS
				     COR2.competencia5 IS NULL 
					)
				)
			)
	END

PRINT @STATUS 

--SELECT * FROM correcoes_fila3 WHERE redacao_id = 711

/*

SELECT  ANA1.ID
  FROM correcoes_analise ANA1 WITH(NOLOCK) JOIN correcoes_redacao RED ON (RED.id = ANA1.redacao_id)
                                               -- JOIN CORRECOES_ANALISE ANA2 WITH(NOLOCK) ON (ANA1.redacao_id = ANA2.redacao_id           --      AND 
                                                                                       /* ANA1.id_projeto = ANA2.id_projeto                 AND 
																						ANA1.id_correcao_B = ANA2.id_correcao_B           AND 
																						ANA1.id_tipo_correcao_B = ANA2.id_tipo_correcao_B AND 
																						ANA1.id_tipo_correcao_A = 1                       AND
																						ANA2.id_tipo_correcao_A = 2*/--)
WHERE RED.ID = 1364604 AND 
      ANA1.id_correcao_B = 1564549 AND 
	  ANA1.id_tipo_correcao_B = 3


	  select * from projeto_projeto 

	  */