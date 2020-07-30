/************** TESTAR O TIPO DE GRAVACAO: *****************
*               1-(COMPARACAO 1,2) 						   *
*               2-(COMPARACAO 1,3) 						   *
*               3-(COMPARACAO 2-3) 						   *
*               4-(COMPARACAO 3-4)						   *
*               5-(COMPARACAO 5 E OURO) 				   *
*               6-(COMPARACAO 6-MODA) 					   *
*               7-(COMPAFRACAO 7-ABSOLUTA)				   *
************************************************************/

declare @TIPO_GRACAO INT
DECLARE @REDACAO_ID  INT
DECLARE @ANALISE_ID  INT 
DECLARE @PROJETO_ID  INT 

SET @TIPO_GRACAO = 7
SET @REDACAO_ID = 270242
SET @ANALISE_ID = 70
SET @PROJETO_ID = 4

-- **** CASO A REDACAO SEJA FINALIZADA NA COMPARACAO ENTRE PRIMEIRA E SEGUNDA ****
IF(@TIPO_GRACAO = 1)	
	BEGIN		 
		BEGIN TRAN 
			BEGIN TRY
				update red set red.nota_competencia1 = (nota_competencia1_A + nota_competencia1_B)/2.0,
					   red.nota_competencia2 = (nota_competencia2_A + nota_competencia2_B)/2.0,
					   red.nota_competencia3 = (nota_competencia3_A + nota_competencia3_B)/2.0,
					   red.nota_competencia4 = (nota_competencia4_A + nota_competencia4_B)/2.0,
					   red.nota_competencia5 = (nota_competencia5_A + nota_competencia5_B)/2.0
				  from correcoes_redacao red  join correcoes_analise ana on (red.id = ana.redacao_id AND 
				                                                             RED.id_projeto = ANA.id_projeto)
				 where ana.id_tipo_correcao_B = 2 and conclusao_analise <= 2  and 
					   -- RED.id_status = 4 AND 
					   red.nota_final IS NOT NULL AND 
		 			   ana.id = @ANALISE_ID AND 
					   red.id = @REDACAO_ID AND 
					   red.id_projeto = @PROJETO_ID

				IF EXISTS (SELECT 1 FROM correcoes_redacao RED join VW_FILAS_DA_REDACAO fil on (RED.id = fil.REDACAO_ID and 
			                                                                                RED.id_projeto = fil.ID_PROJETO)
									WHERE RED.id = @REDACAO_ID AND RED.id_projeto = @PROJETO_ID and 
									     ((
									      RED.nota_final <> (ISNULL(RED.nota_competencia1,-1) + ISNULL(RED.nota_competencia2,-1) + ISNULL(RED.nota_competencia3,-1) + ISNULL(RED.nota_competencia4,-1) + 
															 ISNULL(RED.nota_competencia5,-1))) or 
										  (fil.fila <> 0) )
										  )
					BEGIN 
						PRINT 'DIFERENCA ENTRE NOTAFINAL E SOMATORIO COMPETENCIAS'
						ROLLBACK
						update correcoes_redacao set id_status = 3, data_termino = null where ID = @REDACAO_ID 
					END
				ELSE 
					BEGIN
					    PRINT 'DEU TUDO CERTO'
						COMMIT 
					END
			END TRY
			BEGIN CATCH
				PRINT 'ERRO INTERNO'
				ROLLBACK
			END CATCH
	END

-- **** CASO A REDACAO SEJA FINALIZADA NA COMPARACAO ENTRE PRIMEIRA COM TERCEIRA E SEGUNDA COM TERCEIRA
-- **** SERA PASSADO O TIPO_GRAVACAO 3 PARA SELECAO DA CARGA
IF(@TIPO_GRACAO = 3)
	BEGIN
		IF EXISTS (SELECT 1 FROM correcoes_tipo WHERE flag_soberano = 1 AND id = 3) 
			BEGIN -- TESTE SOBERANA
				BEGIN TRAN
					BEGIN TRY						
						update red set red.nota_competencia1 = nota_competencia1_B,
										 red.nota_competencia2 = nota_competencia2_B,
										 red.nota_competencia3 = nota_competencia3_B,
										 red.nota_competencia4 = nota_competencia4_B,
										 red.nota_competencia5 = nota_competencia5_B
						   from correcoes_redacao red  join correcoes_analise ana on (red.id = ana.redacao_id AND
																				      red.id_projeto = ana.id_projeto)
						  where ana.id_tipo_correcao_B = 3 and 
							    red.id = @REDACAO_ID       AND 
							    red.id_projeto = @PROJETO_ID 

						IF EXISTS (SELECT 1 FROM correcoes_redacao RED join VW_FILAS_DA_REDACAO fil on (RED.id = fil.REDACAO_ID and 
			                                                                                RED.id_projeto = fil.ID_PROJETO)
									WHERE RED.id = @REDACAO_ID AND RED.id_projeto = @PROJETO_ID and 
									     ((
									      RED.nota_final <> (ISNULL(RED.nota_competencia1,-1) + ISNULL(RED.nota_competencia2,-1) + ISNULL(RED.nota_competencia3,-1) + ISNULL(RED.nota_competencia4,-1) + 
															 ISNULL(RED.nota_competencia5,-1))) or 
										  (fil.fila <> 0) )
										  )
							BEGIN 
								PRINT 'DIFERENCA ENTRE NOTAFINAL E SOMATORIO COMPETENCIAS - 3'
								ROLLBACK
						        update correcoes_redacao set id_status = 3, data_termino = null where ID = @REDACAO_ID 
							END
						ELSE 
							BEGIN
								PRINT 'DEU TUDO CERTO -3'
								COMMIT 
							END
					END TRY 
					BEGIN CATCH
						PRINT 'ERRO INTERNO - 3'
				        ROLLBACK
					END CATCH
			END -- FIM TESTE SOBERANA
	
		IF EXISTS (SELECT 1 FROM correcoes_tipo WHERE flag_soberano = 0 AND id = 3) 
			BEGIN -- TESTE NAO SOBERANA
				BEGIN TRAN
					BEGIN TRY						
						update red set red.nota_competencia1 = nota_competencia1_B,
									   red.nota_competencia2 = nota_competencia2_B,
									   red.nota_competencia3 = nota_competencia3_B,
									   red.nota_competencia4 = nota_competencia4_B,
									   red.nota_competencia5 = nota_competencia5_B
						   from correcoes_redacao red  join correcoes_analise ana on (red.id = ana.redacao_id AND
																				      red.id_projeto = ana.id_projeto)
						  where ana.id_tipo_correcao_B = 3 and 
							    red.id = @REDACAO_ID       AND 
							    red.id_projeto = @PROJETO_ID 

						IF EXISTS (SELECT 1 FROM correcoes_redacao RED join VW_FILAS_DA_REDACAO fil on (RED.id = fil.REDACAO_ID and 
			                                                                                RED.id_projeto = fil.ID_PROJETO)
									WHERE RED.id = @REDACAO_ID AND RED.id_projeto = @PROJETO_ID and 
									     ((
									      RED.nota_final <> (ISNULL(RED.nota_competencia1,-1) + ISNULL(RED.nota_competencia2,-1) + ISNULL(RED.nota_competencia3,-1) + ISNULL(RED.nota_competencia4,-1) + 
															 ISNULL(RED.nota_competencia5,-1))) or 
										  (fil.fila <> 0) )
										  )
							BEGIN 
								PRINT 'DIFERENCA ENTRE NOTAFINAL E SOMATORIO COMPETENCIAS - 3'
								ROLLBACK
						        update correcoes_redacao set id_status = 3, data_termino = null where ID = @REDACAO_ID 
							END
						ELSE 
							BEGIN
								PRINT 'DEU TUDO CERTO -3'
								COMMIT 
							END
					END TRY 
					BEGIN CATCH
						PRINT 'ERRO INTERNO - 3'
				        ROLLBACK
					END CATCH
			END -- FIM TESTE SOBERANA
		ELSE
			BEGIN -- ELSE TESTE SOBERANA
				BEGIN TRAN
					BEGIN TRY						
						update red set red.nota_competencia1 = nota_competencia1_B,
										 red.nota_competencia2 = nota_competencia2_B,
										 red.nota_competencia3 = nota_competencia3_B,
										 red.nota_competencia4 = nota_competencia4_B,
										 red.nota_competencia5 = nota_competencia5_B
						   from correcoes_redacao red  join correcoes_analise ana on (red.id = ana.redacao_id AND
																				      red.id_projeto = ana.id_projeto)
						  where ana.id_tipo_correcao_B  = 3 and 
						        ana.conclusao_analise  <= 2 AND
							    red.id = @REDACAO_ID        AND 
							    red.id_projeto = @PROJETO_ID 

						IF EXISTS (SELECT 1 FROM correcoes_redacao RED join VW_FILAS_DA_REDACAO fil on (RED.id = fil.REDACAO_ID and 
			                                                                                RED.id_projeto = fil.ID_PROJETO)
									WHERE RED.id = @REDACAO_ID AND RED.id_projeto = @PROJETO_ID and 
									     ((
									      RED.nota_final <> (ISNULL(RED.nota_competencia1,-1) + ISNULL(RED.nota_competencia2,-1) + ISNULL(RED.nota_competencia3,-1) + ISNULL(RED.nota_competencia4,-1) + 
															 ISNULL(RED.nota_competencia5,-1))) or 
										  (fil.fila <> 0) )
										  )
							BEGIN 
								PRINT 'DIFERENCA ENTRE NOTAFINAL E SOMATORIO COMPETENCIAS - 3 NS'
								ROLLBACK
								update correcoes_redacao set id_status = 3, data_termino = null  where ID = @REDACAO_ID 
							END
						ELSE 
							BEGIN
								PRINT 'DEU TUDO CERTO -3 NS'
								COMMIT 
							END
					END TRY 
					BEGIN CATCH
						PRINT 'ERRO INTERNO - 3 NS'
				        ROLLBACK
					END CATCH
			END -- FIM ELSE TESTE SOBERANA
	END 

-- **** CASO A REDACAO SEJA FINALIZADA NA QUARTA
-- **** SERA PASSADO O TIPO_GRAVACAO 4 PARA SELECAO DA CARGA
IF(@TIPO_GRACAO = 4)
	BEGIN
		BEGIN TRAN 
			BEGIN TRY
				update red set red.nota_competencia1 = nota_competencia1_B,
					           red.nota_competencia2 = nota_competencia2_B,
					           red.nota_competencia3 = nota_competencia3_B,
					           red.nota_competencia4 = nota_competencia4_B,
					           red.nota_competencia5 = nota_competencia5_B
				  FROM correcoes_redacao RED JOIN correcoes_analise ANA ON (RED.id = ANA.redacao_id AND 
				                                                            RED.id_projeto = ANA.id_projeto)

				where RED.id         = @REDACAO_ID AND -- @REDACAO_ID and 
				      RED.id_projeto = @PROJETO_ID AND -- @PROJETO_ID and 
					  ANA.id_tipo_correcao_B = 4   and 
					  ANA.id  = @ANALISE_ID

			IF EXISTS (SELECT 1 FROM correcoes_redacao RED join VW_FILAS_DA_REDACAO fil on (RED.id = fil.REDACAO_ID and 
			                                                                                RED.id_projeto = fil.ID_PROJETO)
									WHERE RED.id = @REDACAO_ID AND RED.id_projeto = @PROJETO_ID and 
									     ((
									      RED.nota_final <> (ISNULL(RED.nota_competencia1,-1) + ISNULL(RED.nota_competencia2,-1) + ISNULL(RED.nota_competencia3,-1) + ISNULL(RED.nota_competencia4,-1) + 
															 ISNULL(RED.nota_competencia5,-1)))  or 
										  (fil.fila <> 0) )
										  )
							BEGIN 
								PRINT 'DIFERENCA ENTRE NOTAFINAL E SOMATORIO COMPETENCIAS - 4 NS'
								ROLLBACK
								update correcoes_redacao set id_status = 3, data_termino = null  where ID = @REDACAO_ID 
							END
						ELSE 
							BEGIN
								PRINT 'DEU TUDO CERTO -4 NS'
								COMMIT 
							END
					END TRY 
					BEGIN CATCH
						PRINT 'ERRO INTERNO - 4 NS'
				        ROLLBACK
					END CATCH
	END 

-- **** CASO A REDACAO SEJA FINALIZADA NA AUDITORIA
-- **** SERA PASSADO O TIPO_GRAVACAO 4 PARA SELECAO DA CARGA
IF(@TIPO_GRACAO = 7)
	BEGIN
		BEGIN TRAN 
			BEGIN TRY
				update red set red.nota_competencia1 = ANA.nota_competencia1_A,
					           red.nota_competencia2 = ANA.nota_competencia2_A,
					           red.nota_competencia3 = ANA.nota_competencia3_A,
					           red.nota_competencia4 = ANA.nota_competencia4_A,
					           red.nota_competencia5 = ANA.nota_competencia5_A

				  FROM correcoes_redacao RED JOIN correcoes_analise ANA ON (RED.id = ANA.redacao_id AND 
				                                                            RED.id_projeto = ANA.id_projeto)

				where RED.id                 = @REDACAO_ID AND
				      RED.id_projeto         = @PROJETO_ID AND
					  ANA.id_tipo_correcao_A = 7           AND 
					  ANA.id                 = @ANALISE_ID    

			IF EXISTS (SELECT 1 FROM correcoes_redacao RED join VW_FILAS_DA_REDACAO fil on (RED.id = fil.REDACAO_ID and 
			                                                                                RED.id_projeto = fil.ID_PROJETO)
									WHERE RED.id = @REDACAO_ID AND RED.id_projeto = @PROJETO_ID and 
									     ((
									      RED.nota_final <> (ISNULL(RED.nota_competencia1,-1) + ISNULL(RED.nota_competencia2,-1) + ISNULL(RED.nota_competencia3,-1) + ISNULL(RED.nota_competencia4,-1) + 
															 ISNULL(RED.nota_competencia5,-1))) or 
										  (fil.fila <> 0) )
										  )
							BEGIN 
								PRINT 'DIFERENCA ENTRE NOTAFINAL E SOMATORIO COMPETENCIAS - 7 NS'
								ROLLBACK
								update correcoes_redacao set id_status = 3, data_termino = null  where ID = @REDACAO_ID 
							END
						ELSE 
							BEGIN
								PRINT 'DEU TUDO CERTO -7 NS'
								COMMIT 
							END
					END TRY 
					BEGIN CATCH
						PRINT 'ERRO INTERNO - 7 NS'
				        ROLLBACK
					END CATCH
	END 
