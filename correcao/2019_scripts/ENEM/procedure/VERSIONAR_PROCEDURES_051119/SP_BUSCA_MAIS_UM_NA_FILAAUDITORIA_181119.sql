/****** Object:  StoredProcedure [dbo].[SP_BUSCA_MAIS_UM_NA_FILAAUDITORIA]    Script Date: 18/11/2019 08:32:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 ALTER     procedure [dbo].[sp_busca_mais_um_na_filaauditoria]
	@AVALIADOR_ID int,
	@ID_PROJETO int,
	@ID_GRUPO_CORRETOR bigint,
	@TIPO_BUSCA INT,
	@CORRECAO_ID int output

	as

     DECLARE @ID bigint
     DECLARE @CO_BARRA_REDACAO varchar(50)
     DECLARE @LINK_IMAGEM_RECORTADA varchar(500)
     DECLARE @LINK_IMAGEM_ORIGINAL varchar(500)
     DECLARE @ID_PERFIL bigint
	 declare @ROW INT
	 declare @REDACAO_ID INT

	 SET NOCOUNT ON;

     SET @CORRECAO_ID = 0

		BEGIN TRANSACTION

			BEGIN TRY

               SELECT TOP 1
                      @ID = id, @CORRECAO_ID = isnull(id_correcao,0),
                      @CO_BARRA_REDACAO = co_barra_redacao,
                      @REDACAO_ID = redacao_id
               FROM
			          correcoes_filaauditoria WITH (UPDLOCK, READPAST)
               WHERE
			         consistido = 1 and
					 consistido_auditoria = 1 and 
			         id_projeto = @ID_PROJETO  and
					 (id_corretor IS NULL or ID_CORRETOR = @AVALIADOR_ID) and
					 tipo_id = @TIPO_BUSCA

               ORDER BY pendente, id;
			   SET @ROW = @@ROWCOUNT

               IF ( @ROW = 0)
					BEGIN
						IF NOT EXISTS (SELECT 1
										FROM correcoes_filaauditoria WITH (UPDLOCK, READPAST)
									   WHERE id = @ID AND
									         id_projeto = @ID_PROJETO)
							BEGIN
								 SET @CORRECAO_ID = 0

							END
					END
				ELSE
					BEGIN
						IF(@CORRECAO_ID = 0)
							BEGIN
								-- ****** DANDO CARGA NA TABELA CORRECOES_CORRECAO E RECUPERANDO O ID DA CORRECAO *********
								-- ***** BUSCANDO AS INFORMACOES DA REDACAO ******
								SELECT
										@LINK_IMAGEM_RECORTADA = LINK_IMAGEM_RECORTADA,
										@LINK_IMAGEM_ORIGINAL  = LINK_IMAGEM_ORIGINAL
								FROM correcoes_redacao crd with (nolock)
								WHERE crd.id = @REDACAO_ID AND
										CRD.id_projeto = @ID_PROJETO

								/***** INSERINDO NA TABELA CORRECOES_CORRECAO   *****/
								INSERT INTO correcoes_correcao (data_inicio, link_imagem_recortada, link_imagem_original,
								id_status, id_tipo_correcao, co_barra_redacao, id_corretor, id_projeto, tipo_auditoria_id, redacao_id)
										SELECT
											GETDATE(),
											@LINK_IMAGEM_RECORTADA,
											@LINK_IMAGEM_ORIGINAL,
											1,
											7,
											co_barra_redacao,
											@AVALIADOR_ID,
											ID_PROJETO,
											@TIPO_BUSCA,
											@REDACAO_ID
										FROM CORRECOES_FILAAUDITORIA cor with (nolock)
										WHERE consistido = 1 and
					                          consistido_auditoria = 1 and 
											  redacao_id = @REDACAO_ID AND
										      id_projeto = @ID_PROJETO

								/****** RECUPERANDO O ID DA TABELA CORRECOES_CORRECAO   *****/
								SET @CORRECAO_ID = SCOPE_IDENTITY()

							END

						/****** FIM DANDO CARGA NA TABELA CORRECAO_REDACAO E RECUPERANDO O ID DA CORRECAO *********/
						/****** INSERIR NA LISTA PESSOAL   *****/
						INSERT INTO correcoes_filapessoal (corrigido_por, id_grupo_corretor, atual, id_tipo_correcao, id_corretor, id_correcao, co_barra_redacao, id_projeto, redacao_id)
								VALUES (DBO.FN_COR_CORRETOR_REDACAO(@CO_BARRA_REDACAO), @ID_GRUPO_CORRETOR, 1, 7, @AVALIADOR_ID, @CORRECAO_ID, @CO_BARRA_REDACAO, @ID_PROJETO, @REDACAO_ID)

						/******* DELETAR O REGISTRO NA FILA AUDITORIA   *****/
						DELETE FROM CORRECOES_FILAAUDITORIA
						WHERE consistido = 1 and
					          consistido_auditoria = 1 and 
					          id = @id
					END
				COMMIT
			END TRY
			BEGIN CATCH
				print error_message()
				ROLLBACK
			END CATCH

	 SET NOCOUNT OFF;

	RETURN

