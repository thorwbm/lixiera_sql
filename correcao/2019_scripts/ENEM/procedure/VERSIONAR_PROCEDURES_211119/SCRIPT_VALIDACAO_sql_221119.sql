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
	SELECT RED.ID, COR1.id, COR2.id, RED.id_projeto, ANA.CONCLUSAO_ANALISE, RED.*
	  FROM CORRECOES_REDACAO RED JOIN CORRECOES_CORRECAO COR1 ON (RED.ID = COR1.REDACAO_ID AND COR1.id_tipo_correcao = 1)
	                                    JOIN CORRECOES_CORRECAO COR2 ON (RED.ID = COR2.REDACAO_ID AND COR2.id_tipo_correcao = 2)
	                                    JOIN CORRECOES_CORRECAO COR3 ON (RED.ID = COR3.REDACAO_ID AND COR3.id_tipo_correcao = 3)
										JOIN correcoes_analise ANA ON (ANA.id_correcao_B = COR3.id )
	WHERE ANA.CONCLUSAO_ANALISE <=2

	     AND RED.ID = 270176
		 
	SELECT * FROM CORRECOES_CORRECAO WHERE REDACAO_ID = 270418
	SELECT * FROM CORRECOES_REDACAO WHERE ID = 270418
	SELECT * FROM VW_FILAS_DA_REDACAO WHERE REDACAO_ID = 270418
*/

-- select redacao_id, id, id_projeto, * from correcoes_ANALISE where id_tipo_correcao_B = 3 AND REDACAO_ID = 270418


DECLARE @REDACAO_ID INT, @ID_CORRECAO INT, @TIPO_GRAVACAO INT,	@ID_PROJETO INT, @STATUS INT
	SET @REDACAO_ID = 271160
	SET @ID_CORRECAO = 1102  
	SET @ID_PROJETO = 4
	SET @TIPO_GRAVACAO = 4
	SET @STATUS = 0 -- (1 - OK / 0 - PROBLEMA) 


-- VALIDAR SE AS COMPETENCIAS ESTAO CORRETAS
-- ******* VALIDACAO DAS CORRECOES  *******
SELECT  @STATUS = COUNT(DISTINCT 1)
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
PRINT 'VALIDACAO 1'
PRINT @STATUS 
--########################################################################################################
/*** TESTAR SE A REDACAO POSSUI STATUS DE CONCLUIDA E SE ENCONTRA ABERTA EM ALGUMA FILA DE CORRECAO OU COM CORRECAO AINDA EM ABERTO ***/
IF( @STATUS = 1)
    BEGIN
		SELECT  @STATUS = COUNT(distinct 1) 
		  FROM correcoes_redacao RED WITH(NOLOCK) LEFT JOIN correcoes_correcao      COR WITH(NOLOCK) ON (RED.id = COR.redacao_id AND 
		                                                                                                 RED.id_projeto = COR.id_projeto)
		                                          LEFT JOIN VW_FILAS_DA_REDACAO     FIL WITH(NOLOCK) ON (RED.id = FIL.REDACAO_ID AND 
												                                                         RED.id_projeto = FIL.ID_PROJETO)

		 WHERE RED.id          = @REDACAO_ID AND 
		       RED.id_projeto  = @ID_PROJETO AND              
			   ((RED.id_status = 4           AND       -- CASO EXISTA FINALIZACAO NA REDACAO (STATUS = 4 E DATA) E AINDA ASSIM EXISTA REGISTRO EM FILAS OU CORRECAO ABERTA <> 3
	             RED.data_termino IS NOT NULL AND      -- CASO EXISTA FINALIZACAO NA REDACAO (STATUS = 4 E DATA) E AINDA ASSIM EXISTA REGISTRO EM FILAS OU CORRECAO ABERTA <> 3
			      (COR.id  IS NOT NULL   OR  		   -- CASO EXISTA FINALIZACAO NA REDACAO (STATUS = 4 E DATA) E AINDA ASSIM EXISTA REGISTRO EM FILAS OU CORRECAO ABERTA <> 3
				   FIL.fila IS not NULL) )  
				)
	END
PRINT 'VALIDACAO 2'
print @status
---##################################################################################################
IF(@TIPO_GRAVACAO = 1 AND @STATUS = 1) -- QUANDO FOR COMPARACAO DE 1 COM 2 
	BEGIN
		SELECT @STATUS = COUNT(DISTINCT 1)
		  FROM correcoes_analise ANA WITH(NOLOCK) JOIN correcoes_conclusao_analise CCA  WITH(NOLOCK) ON (ANA.conclusao_analise = CCA.id)
		                                          JOIN correcoes_redacao           RED  WITH(NOLOCK) ON (ANA.redacao_id        = RED.ID AND 
												                                                         ANA.id_projeto        = RED.id_projeto)
											 LEFT JOIN correcoes_fila3             FIL3 WITH(NOLOCK) ON (FIL3.redacao_id       = ANA.redacao_id and 
											                                                             FIL3.id_projeto       = ANA.id_projeto)
											 LEFT JOIN CORRECOES_FILA4             FIL4 WITH(NOLOCK) ON (FIL4.redacao_id       = ANA.redacao_id and 
											                                                             FIL4.id_projeto       = ANA.id_projeto)
											 LEFT JOIN CORRECOES_CORRECAO          COR  WITH(NOLOCK) ON (COR.redacao_id       = ANA.redacao_id AND 
											                                                             COR.id_projeto       = ANA.id_projeto AND 
																										 COR.id_tipo_correcao IN (3,4,7))
		  WHERE ANA.redacao_id     = @REDACAO_ID   AND
		        ANA.id_projeto     = @ID_PROJETO   AND 
				ANA.id_tipo_correcao_B = 2         AND 
				(ANA.id_correcao_A = @ID_CORRECAO   OR 
		         ANA.id_correcao_B = @ID_CORRECAO) AND
				((CCA.discrepou = 0                AND     -- ** SE NAO DISCREPAR {
				  RED.id_status = 4                AND     -- O STATUS DA REDACAO TEM QUE SER 4             AJUSTE - AINDA NAO ESTA SENDO GRAVADO O STATUS E A DATA DE CONCLUSAO 
				  RED.data_termino IS NOT NULL     AND     -- A DATA DE CONCLUSAO DEVERA ESTAR PREENCHIDA   AJUSTE - AINDA NAO ESTA SENDO GRAVADO O STATUS E A DATA DE CONCLUSAO
				  FIL3.ID IS NULL                  AND     -- NAO PODE TER REGISTRO NA FILA 3
				  FIL4.ID IS NULL                  AND     -- NAO PODE TER REGSITRO NA FILA 4
				  COR.id IS NULL                           -- NAO PODE TER REGISTRO DE CORRECAO DE QUARTA }
				  ) 
		        )
    END
PRINT 'VALIDACAO 3'
print @status
---##################################################################################################


--&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
---#################################################################################################
/*
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
	PRINT 'VALIDACAO 4'
print @status */

--&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
---##################################################################################################
 
/****  QUANDO FOR COMPARACAO DE  2 COM 3 e a TERCEIRA FOR ABSOLUTA ***/
IF(@TIPO_GRAVACAO =3 AND @STATUS = 1) -- QUANDO FOR COMPARACAO DE 2 COM 3  
	BEGIN
		select @STATUS = COUNT (distinct 1)
		  FROM vw_analise_terceira_finalizadas ANA left join VW_FILAS_DA_REDACAO     fil on (ANA.ID = fil.REDACAO_ID and ANA.id_projeto = fil.ID_PROJETO)
		                                           left join vw_redacao_equidistante equ on (ANA.ID = equ.redacao_id and ANA.id_projeto = equ.id_projeto)
		 WHERE ANA.id            = @REDACAO_ID   AND 
		       ANA.id_projeto    = @ID_PROJETO   AND 
			   isnull(fil.fila,0) = 0       and
			   isnull(equ.redacao_id,0) = 0 AND

			   ( (ANA.SITUACAO1 = 1 AND 
			      ANA.comp11 IS not NULL AND 
			      ANA.comp12 IS not NULL AND 
			      ANA.comp13 IS not NULL AND 
			      ANA.comp14 IS not NULL AND 
			      ANA.comp15 IS not NULL) OR  
			     (ANA.SITUACAO1 <> 1 AND 
			      ANA.comp11 IS NULL AND 
			      ANA.comp12 IS NULL AND 
			      ANA.comp13 IS NULL AND 
			      ANA.comp14 IS NULL AND 
			      ANA.comp15 IS NULL)
			   )AND
			   ( (ANA.SITUACAO2 = 1 AND 
			      ANA.comp21 IS not NULL AND 
			      ANA.comp22 IS not NULL AND 
			      ANA.comp23 IS not NULL AND 
			      ANA.comp24 IS not NULL AND 
			      ANA.comp25 IS not NULL) OR  
			     (ANA.SITUACAO2 <> 1 AND 
			      ANA.comp21 IS NULL AND 
			      ANA.comp22 IS NULL AND 
			      ANA.comp23 IS NULL AND 
			      ANA.comp24 IS NULL AND 
			      ANA.comp25 IS NULL)
			   )AND
			   ( (ANA.SITUACAO3 = 1 AND 
			      ANA.comp31 IS not NULL AND 
			      ANA.comp32 IS not NULL AND 
			      ANA.comp33 IS not NULL AND 
			      ANA.comp34 IS not NULL AND 
			      ANA.comp35 IS not NULL) OR  
			     (ANA.SITUACAO3 <> 1 AND 
			      ANA.comp31 IS NULL AND 
			      ANA.comp32 IS NULL AND 
			      ANA.comp33 IS NULL AND 
			      ANA.comp34 IS  NULL AND 
			      ANA.comp35 IS NULL)
			   ) 
	END
PRINT 'VALIDACAO 5'
PRINT @STATUS 

 
/****  QUANDO FOR ANALISE 4 ABSOLUTA ***/
IF(@TIPO_GRAVACAO = 4 AND @STATUS = 1) -- QUANDO FOR TIPO 4
	BEGIN
		SELECT  @STATUS = COUNT (distinct 1)
		  FROM correcoes_redacao RED JOIN correcoes_correcao  COR4 ON (RED.ID = COR4.REDACAO_ID AND RED.ID_PROJETO = COR4.ID_PROJETO AND COR4.id_tipo_correcao = 4)
		                        LEFT JOIN correcoes_correcao  AUD  ON (RED.id = AUD.redacao_id AND RED.id_projeto = AUD.id_projeto AND AUD.id_tipo_correcao = 7)
								LEFT JOIN VW_FILAS_DA_REDACAO FIL  ON (RED.ID = FIL.REDACAO_ID AND RED.id_projeto = FIL.ID_PROJETO)

		WHERE RED.id = 271160        AND 
		      RED.id_projeto = 4     AND 
			  AUD.id IS NULL         AND 
			  ISNULL(FIL.FILA,0) = 0 AND 
			  ()


SELECT * FROM VW_FILAS_DA_REDACAO WHERE REDACAO_ID = 270396

	END

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

