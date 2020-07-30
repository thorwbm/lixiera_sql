
--EXEC SP_RECALCULA_ANALISE 98265,1
CREATE OR ALTER PROCEDURE SP_RECALCULA_ANALISE @analise_id INT, @ID_PROJETO INT AS 
 
declare  @redacao_id int, @id_tipo_correcao int , @ID_CORRECAO INT, @RETORNO VARCHAR(500), @PODE_REFAZER INT
	
	-- set @analise_id = 98265
    -- set @ID_PROJETO = 1
	SET @RETORNO = 'NAO FOI POSSIVEL RECALCULAR A ANALISE'
	SET @PODE_REFAZER = 0

	select  @redacao_id = redacao_id , @id_tipo_correcao = id_tipo_correcao_B, 
	        @ID_PROJETO = id_projeto,  @ID_CORRECAO = id_correcao_B	
	from correcoes_analise
	 where id = @analise_id and id_projeto = @ID_PROJETO

	         SELECT @PODE_REFAZER = 1
			   FROM VW_MAIOR_CORRECAO MAI JOIN VW_FILA_MAIS_ALTA ALT ON (MAI.REDACAO_ID = ALT.REDACAO_ID AND 
			                                                             MAI.ID_PROJETO = ALT.ID_PROJETO)  
			 WHERE MAI.REDACAO_ID = @redacao_id AND 
			       MAI.ID_PROJETO = @ID_PROJETO AND 
				   MAI.MAIOR_CORRECAO = @id_tipo_correcao AND
				   ALT.FILA = 0




                IF(@ID_TIPO_CORRECAO IN (1,2) and @PODE_REFAZER = 1) -- **** COMPARACAO PRIMEIRA COM A SEGUNDA
					BEGIN
						BEGIN TRY
							BEGIN TRANSACTION
								DELETE FROM correcoes_analise WHERE redacao_id = @redacao_id AND  id_projeto = @ID_PROJETO AND id_tipo_correcao_B = 2

								EXEC  sp_inserir_analise @ID_CORRECAO,1, @ID_PROJETO, @retorno output	
								SET @RETORNO = 'ANALISE RECALCULADA'						
							COMMIT
						END TRY
						BEGIN CATCH
							ROLLBACK
						END CATCH
												
					END
				ELSE IF(@ID_TIPO_CORRECAO =3  and @PODE_REFAZER = 1) -- **** COMPARARACAO PRIMEIRA COM TERCEIRA E SEGUNDA COM TERCEIRA 
					BEGIN
						BEGIN TRY
							BEGIN TRANSACTION
								DELETE FROM correcoes_analise WHERE redacao_id = @redacao_id AND  id_projeto = @ID_PROJETO AND id_tipo_correcao_B = 3
								                                   

								EXEC  sp_inserir_analise @ID_CORRECAO,2, @ID_PROJETO, @retorno output							
								EXEC  sp_inserir_analise @ID_CORRECAO,3, @ID_PROJETO, @retorno output	
								SET @RETORNO = 'ANALISE RECALCULADA'						
							
							COMMIT
						END TRY
						BEGIN CATCH
							ROLLBACK
						END CATCH
					END
				ELSE IF(@ID_TIPO_CORRECAO =4  and @PODE_REFAZER = 1)
					BEGIN
						BEGIN TRY
							BEGIN TRANSACTION
								DELETE FROM correcoes_analise WHERE redacao_id = @redacao_id AND  id_projeto = @ID_PROJETO  AND id_tipo_correcao_B = 4

								EXEC  sp_inserir_analise @ID_CORRECAO,4, @ID_PROJETO, @retorno output		
								SET @RETORNO = 'ANALISE RECALCULADA'												
							COMMIT
						END TRY
						BEGIN CATCH
							ROLLBACK
						END CATCH
					END
				-- OURO
				ELSE IF(@ID_TIPO_CORRECAO = 5 and @PODE_REFAZER = 1) -- **** CORRECOES DO TIPO OURO 
					BEGIN
						BEGIN TRY
							BEGIN TRANSACTION
								DELETE FROM correcoes_analise WHERE redacao_id = @redacao_id AND  id_projeto = @ID_PROJETO  AND id_tipo_correcao_B = 5

								EXEC  sp_inserir_analise_gabarito @ID_CORRECAO, @ID_PROJETO, @retorno output		
								SET @RETORNO = 'ANALISE RECALCULADA'												
							COMMIT
						END TRY
						BEGIN CATCH
							ROLLBACK
						END CATCH
					END
                -- MODA
				ELSE IF(@ID_TIPO_CORRECAO = 6 and @PODE_REFAZER = 1) -- **** CORRECOES DO TIPO MODA 
					BEGIN
						BEGIN TRY
							BEGIN TRANSACTION
								DELETE FROM correcoes_analise WHERE redacao_id = @redacao_id AND  id_projeto = @ID_PROJETO  AND id_tipo_correcao_B = 6

								EXEC  sp_inserir_analise_gabarito @ID_CORRECAO, @ID_PROJETO, @retorno output			
								SET @RETORNO = 'ANALISE RECALCULADA'											
							COMMIT
						END TRY
						BEGIN CATCH
							ROLLBACK
						END CATCH
					END
                --- AUDITORIA
				ELSE IF(@ID_TIPO_CORRECAO = 7 and @PODE_REFAZER = 1) -- **** CORRECOES DO TIPO AUDITORIA 
					BEGIN
						BEGIN TRY
							BEGIN TRANSACTION
								DELETE FROM correcoes_analise WHERE redacao_id = @redacao_id AND  id_projeto = @ID_PROJETO  AND id_tipo_correcao_B = 7

								EXEC  sp_inserir_analise_auditoria @ID_CORRECAO, @ID_PROJETO, @retorno output	
								SET @RETORNO = 'ANALISE RECALCULADA'						
							COMMIT
						END TRY
						BEGIN CATCH
							ROLLBACK
						END CATCH
					END

		PRINT @RETORNO + ' -> REDACAO ID = ' + CONVERT(VARCHAR(20),@REDACAO_ID) 