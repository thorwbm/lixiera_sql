/****** Object:  StoredProcedure [dbo].[sp_insere_discrepancia_na_fila]    Script Date: 24/11/2019 21:41:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_insere_discrepancia_na_fila] @CO_BARRA_REDACAO varchar(100), @REDACAO_ID int, @ID_ANALISE int, @FILA int
AS
    DECLARE @ID INT 
	DECLARE @ID_PROJETO INT 

	SELECT @ID_PROJETO = ID_PROJETO FROM correcoes_analise WHERE ID = @ID_ANALISE


	IF (@FILA = 3)
	BEGIN
		INSERT INTO CORRECOES_FILA3 (CORRIGIDO_POR, id_projeto, co_barra_redacao, redacao_id)
			SELECT DISTINCT
				DBO.fn_cor_corretor_redacao(CO_BARRA_REDACAO),
				id_projeto,
				co_barra_redacao,
				redacao_id
			FROM correcoes_correcao FIL3 WITH (NOLOCK)
			WHERE redacao_id = @REDACAO_ID
			AND NOT EXISTS (SELECT
					1
				FROM correcoes_fila3 FILX
				WHERE FILX.id_projeto = FIL3.id_projeto
				AND FILX.redacao_id = FIL3.redacao_id)
			AND NOT EXISTS (SELECT TOP 1
					1
				FROM CORRECOES_CORRECAO CORX
				WHERE CORX.redacao_id = FIL3.redacao_id
				AND CORX.id_tipo_correcao = 3
				AND CORX.id_projeto = FIL3.id_projeto)

		-- CRIACAO LOG 
		SET @ID = SCOPE_IDENTITY()

		-- CRIACAO LOG 
			EXEC SP_INSERE_LOG_FILA3 @ID, @ID_PROJETO, NULL, '+'
		-- CRIACAO LOG - FIM  

		UPDATE correcoes_analise
		SET FILA = 3
		WHERE ID = @ID_ANALISE
		
		-- CRIACAO LOG 
		EXEC SP_INSERIR_LOG_ANALISE @ID_ANALISE, @ID_PROJETO, NULL, '~'
		-- CRIACAO LOG - FIM

	END
	ELSE
	IF (@FILA = 4)
	BEGIN
		INSERT INTO CORRECOES_FILA4 (CORRIGIDO_POR, id_projeto, co_barra_redacao, redacao_id)
			SELECT DISTINCT
				DBO.fn_cor_corretor_redacao(CO_BARRA_REDACAO),
				id_projeto,
				co_barra_redacao,
				redacao_id
			FROM correcoes_correcao FIL4 WITH (NOLOCK)
			WHERE redacao_id = @REDACAO_ID
			AND NOT EXISTS (SELECT
					1
				FROM correcoes_fila4 FILX
				WHERE FILX.id_projeto = FIL4.id_projeto
				AND FILX.redacao_id = FIL4.redacao_id)
			AND NOT EXISTS (SELECT TOP 1
					1
				FROM CORRECOES_CORRECAO CORX
				WHERE CORX.redacao_id = FIL4.redacao_id
				AND CORX.id_tipo_correcao = 4
				AND CORX.id_projeto = FIL4.id_projeto)	

		-- CRIACAO LOG 
			EXEC SP_INSERE_LOG_FILA4 @ID, @ID_PROJETO, NULL, '+'
		-- CRIACAO LOG - FIM  


		UPDATE correcoes_analise
		SET FILA = 4
		WHERE ID = @ID_ANALISE
		
		-- CRIACAO LOG 
		EXEC SP_INSERIR_LOG_ANALISE @ID_ANALISE, @ID_PROJETO, NULL, '~'
		-- CRIACAO LOG - FIM
	END
GO
