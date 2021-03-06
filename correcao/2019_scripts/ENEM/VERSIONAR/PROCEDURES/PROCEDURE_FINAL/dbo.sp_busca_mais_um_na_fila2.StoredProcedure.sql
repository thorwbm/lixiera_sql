/****** Object:  StoredProcedure [dbo].[sp_busca_mais_um_na_fila2]    Script Date: 26/11/2019 18:12:04 ******/
DROP PROCEDURE [dbo].[sp_busca_mais_um_na_fila2]
GO
/****** Object:  StoredProcedure [dbo].[sp_busca_mais_um_na_fila2]    Script Date: 26/11/2019 18:12:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_busca_mais_um_na_fila2]
	@AVALIADOR_ID int,
	@ID_PROJETO int,
	@ID_GRUPO_CORRETOR bigint,
	@CORRECAO_ID int OUTPUT

	as

     DECLARE @ID bigint
     DECLARE @CO_BARRA_REDACAO varchar(50)
     DECLARE @LINK_IMAGEM_RECORTADA varchar(500)
     DECLARE @LINK_IMAGEM_ORIGINAL varchar(500)
     DECLARE @ID_PERFIL bigint
     DECLARE @REDACAO_ID int

	 DECLARE @FILAPESSOAL_ID INT -- CIRACAO_LOG

	 SET NOCOUNT ON;

     SET @CORRECAO_ID = 0

			BEGIN TRY
		BEGIN TRANSACTION

               SELECT TOP 1
                      @ID = id,
                      @CO_BARRA_REDACAO = co_barra_redacao,
                      @REDACAO_ID = redacao_id
               FROM
			          correcoes_fila2 WITH (UPDLOCK, READPAST)
               WHERE
			         id_projeto = @ID_PROJETO  and
					 (corrigido_por IS NULL or CORRIGIDO_POR NOT LIKE '%,' + CONVERT(varchar(20), @AVALIADOR_ID) + ',%') AND
                      CASE
                           WHEN @ID_GRUPO_CORRETOR = 2 THEN 2
                           WHEN @ID_GRUPO_CORRETOR = 1 THEN 3
                           WHEN @ID_GRUPO_CORRETOR IS NULL THEN 3
                      END > ISNULL(id_grupo_corretor, 0)
               ORDER BY id

               IF (@@ROWCOUNT = 0)
					BEGIN
						IF NOT EXISTS (SELECT 1
										FROM correcoes_fila2 WITH (UPDLOCK, READPAST)
									   WHERE id = @ID AND
									         id_projeto = @ID_PROJETO)
							BEGIN
								 SET @CORRECAO_ID = 0

							END
					END
				ELSE
					BEGIN

						-- ****** DANDO CARGA NA TABELA CORRECOES_CORRECAO E RECUPERANDO O ID DA CORRECAO *********
						-- ***** BUSCANDO AS INFORMACOES DA REDACAO ******
						SELECT
								@LINK_IMAGEM_RECORTADA = LINK_IMAGEM_RECORTADA,
								@LINK_IMAGEM_ORIGINAL = LINK_IMAGEM_ORIGINAL
						FROM correcoes_redacao crd with (nolock)
						WHERE crd.id = @REDACAO_ID

						/***** INSERINDO NA TABELA CORRECOES_CORRECAO   *****/
						INSERT INTO correcoes_correcao (data_inicio, link_imagem_recortada, link_imagem_original,
						id_status, id_tipo_correcao, co_barra_redacao, id_corretor, id_projeto, redacao_id)
								SELECT
									dbo.getlocaldate(),
									@LINK_IMAGEM_RECORTADA,
									@LINK_IMAGEM_ORIGINAL,
									1,
									2,
									co_barra_redacao,
									@AVALIADOR_ID,
									ID_PROJETO,
                                    @REDACAO_ID
								FROM correcoes_fila2 cor with (nolock)
								WHERE id = @ID
						/****** RECUPERANDO O ID DA TABELA CORRECOES_CORRECAO   *****/
						select @CORRECAO_ID = SCOPE_IDENTITY()
							
						-- LOG CORRECAO UPDATE 
							EXEC SP_INSERE_LOG_CORRECAO @CORRECAO_ID, @ID_PROJETO, NULL, '+'
						-- LOG CORRECAO UPDATE FIM 


						/****** FIM DANDO CARGA NA TABELA CORRECAO_REDACAO E RECUPERANDO O ID DA CORRECAO *********/
						/****** INSERIR NA LISTA PESSOAL   *****/
						INSERT INTO correcoes_filapessoal (corrigido_por, id_grupo_corretor, atual, id_tipo_correcao, id_corretor, id_correcao, co_barra_redacao, id_projeto, redacao_id)
								VALUES (DBO.FN_COR_CORRETOR_REDACAO(@CO_BARRA_REDACAO), @ID_GRUPO_CORRETOR, 1, 2, @AVALIADOR_ID, @CORRECAO_ID, @CO_BARRA_REDACAO, @ID_PROJETO, @REDACAO_ID)
						SET @FILAPESSOAL_ID = SCOPE_IDENTITY()
							
					-- CRIACAO LOG
						EXEC SP_INSERE_LOG_FILAPESSOAL @FILAPESSOAL_ID, @ID_PROJETO, @AVALIADOR_ID, '+'
					-- CRIACAO LOG 


						/******* DELETAR O REGISTRO NA FILA 2   *****/					
						
					-- CRIACAO LOG 
						EXEC SP_INSERE_LOG_FILA2 @ID, @ID_PROJETO, @AVALIADOR_ID,'-'
					-- CRIACAO LOG - FIM 

						DELETE FROM correcoes_fila2
						WHERE id = @id
					END
				COMMIT
			END TRY
			BEGIN CATCH
				print error_message()
				ROLLBACK
			END CATCH

        SET NOCOUNT OFF;

	RETURN

GO
