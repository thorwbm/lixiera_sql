
ALTER   PROCEDURE [dbo].[sp_insere_discrepancia_na_fila]
	@CO_BARRA_REDACAO VARCHAR(100),
	@REDACAO_ID INT,
	@ID_ANALISE INT,
	@FILA INT
	AS
		IF(@FILA = 3)
			BEGIN
				INSERT INTO CORRECOES_FILA3 (CORRIGIDO_POR, id_projeto, co_barra_redacao, redacao_id)
				SELECT distinct DBO.fn_cor_corretor_redacao_por_id(redacao_id), id_projeto,co_barra_redacao, redacao_id
				  FROM correcoes_correcao FIL3 WITH (NOLOCK)
				 WHERE redacao_id = @REDACAO_ID AND
					   NOT EXISTS (SELECT 1  FROM correcoes_fila3 FILX WITH (NOLOCK)
									WHERE FILX.id_projeto = FIL3.id_projeto AND
										  FILX.redacao_id = FIL3.redacao_id) and
					   NOT EXISTS (SELECT TOP 1 1 FROM CORRECOES_CORRECAO CORX WITH (NOLOCK)
					                WHERE CORX.redacao_id = FIL3.redacao_id AND
									      CORX.id_tipo_correcao = 3         AND
										  CORX.id_projeto = FIL3.id_projeto)


				UPDATE correcoes_analise SET FILA = 3 WHERE ID = @ID_ANALISE
			END
		ELSE IF(@FILA = 4)
			BEGIN
				INSERT INTO CORRECOES_FILA4 (CORRIGIDO_POR, id_projeto, co_barra_redacao, redacao_id)
				SELECT distinct DBO.fn_cor_corretor_redacao_por_id(redacao_id), id_projeto,co_barra_redacao,redacao_id
				  FROM correcoes_correcao FIL4 WITH (NOLOCK)
				 WHERE redacao_id = @REDACAO_ID AND
					   NOT EXISTS (SELECT 1  FROM correcoes_fila4 FILX WITH (NOLOCK)
									WHERE FILX.id_projeto = FIL4.id_projeto AND
										  FILX.redacao_id = FIL4.redacao_id)and
					   NOT EXISTS (SELECT TOP 1 1 FROM CORRECOES_CORRECAO CORX WITH (NOLOCK)
					                WHERE CORX.redacao_id = FIL4.redacao_id AND
									      CORX.id_tipo_correcao = 4         AND
										  CORX.id_projeto = FIL4.id_projeto)

				UPDATE correcoes_analise SET FILA = 4 WHERE ID = @ID_ANALISE
			END

