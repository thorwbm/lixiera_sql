/****** Object:  StoredProcedure [dbo].[sp_busca_mais_um_na_fila1]    Script Date: 26/11/2019 18:12:04 ******/
DROP PROCEDURE [dbo].[sp_busca_mais_um_na_fila1]
GO
/****** Object:  StoredProcedure [dbo].[sp_busca_mais_um_na_fila1]    Script Date: 26/11/2019 18:12:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [dbo].[sp_busca_mais_um_na_fila1]    Script Date: 10/09/2019 20:29:00 ******/
CREATE   PROCEDURE [dbo].[sp_busca_mais_um_na_fila1]
	@AVALIADOR_ID int,
	@ID_PROJETO int,
	@ID_GRUPO_CORRETOR bigint,
	@CORRECAO_ID int output

	as

     DECLARE @ID bigint
     DECLARE @CO_BARRA_REDACAO varchar(50)
     DECLARE @LINK_IMAGEM_RECORTADA varchar(500)
     DECLARE @LINK_IMAGEM_ORIGINAL varchar(500)
     DECLARE @ID_PERFIL bigint
	 DECLARE @ROWS INT
	 DECLARE @REDACAO_ID INT

	 DECLARE @FILAPESSOAL_ID INT -- CRIACAO LOG
	 DECLARE @FILA2_ID INT       -- CRIACAO LOG

	 SET NOCOUNT ON;


     SET @CORRECAO_ID = 0


		BEGIN TRANSACTION

			BEGIN TRY

               SELECT TOP 1
                      @ID = id,
                      @CO_BARRA_REDACAO = co_barra_redacao,
                      @REDACAO_ID = redacao_id
               FROM
			          correcoes_fila1 WITH (UPDLOCK, READPAST)
               WHERE
			         id_projeto = @ID_PROJETO  and
					 (corrigido_por IS NULL or CORRIGIDO_POR NOT LIKE '%,' + CONVERT(varchar(20), @AVALIADOR_ID) + ',%') AND
                      CASE
                           WHEN @ID_GRUPO_CORRETOR = 2 THEN 2
                           WHEN @ID_GRUPO_CORRETOR = 1 THEN 3
                           WHEN @ID_GRUPO_CORRETOR IS NULL THEN 3
                      END > ISNULL(id_grupo_corretor, 0)
               ORDER BY id;
			SET @ROWS = @@ROWCOUNT

               IF (@ROWS = 0)
					BEGIN
						IF NOT EXISTS (SELECT 1
										FROM correcoes_fila1 WITH (UPDLOCK, READPAST)
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
						  FROM  correcoes_redacao crd with (nolock)
						 WHERE  crd.id = @REDACAO_ID

						/***** INSERINDO NA TABELA CORRECOES_CORRECAO   *****/

						INSERT INTO correcoes_correcao (data_inicio, link_imagem_recortada, link_imagem_original,
						id_status, id_tipo_correcao, co_barra_redacao, id_corretor, id_projeto, redacao_id)
								SELECT
									dbo.getlocaldate(),
									@LINK_IMAGEM_RECORTADA,
									@LINK_IMAGEM_ORIGINAL,
									1,
									1,
									co_barra_redacao,
									@AVALIADOR_ID,
									ID_PROJETO,
                                    @REDACAO_ID
								FROM correcoes_fila1 cor with (nolock)
								WHERE id = @ID
						/****** RECUPERANDO O ID DA TABELA CORRECOES_CORRECAO   *****/
						SET @CORRECAO_ID = SCOPE_IDENTITY()
						
						-- LOG CORRECAO UPDATE 
					    	EXEC SP_INSERE_LOG_CORRECAO @CORRECAO_ID, @ID_PROJETO, NULL, '+'
						-- LOG CORRECAO UPDATE FIM 

						/**** INSERIR NA LISTA 2				 *****/
						if(exists(select 1 from projeto_projeto where id = @ID_PROJETO and fila_prioritaria >=2))
							begin
								INSERT INTO correcoes_fila2 (corrigido_por, id_grupo_corretor, id_correcao, co_barra_redacao, id_projeto, redacao_id)
										SELECT
											DBO.FN_COR_CORRETOR_REDACAO(co_barra_redacao),
											@ID_GRUPO_CORRETOR,
											@CORRECAO_ID,
											co_barra_redacao,
											@ID_PROJETO,
                                            @REDACAO_ID
										FROM correcoes_fila1 fl1 with (nolock)
									   WHERE id = @ID AND
									         not exists (select top 1 1 from correcoes_correcao corx
											              where corx.redacao_id = fl1.redacao_id and
																corx.id_tipo_correcao = 2)
									 SET @FILA2_ID =  SCOPE_IDENTITY()
									-- CRIACAO LOG 
										EXEC SP_INSERE_LOG_FILA2 @FILA2_ID, @ID_PROJETO, @AVALIADOR_ID,'+'
									-- CRIACAO LOG - FIM 


							end

						/****** FIM DANDO CARGA NA TABELA CORRECAO_FILAPESSOAL E RECUPERANDO O ID DA CORRECAO *********/
						/****** INSERIR NA LISTA PESSOAL   *****/
						INSERT INTO correcoes_filapessoal (corrigido_por, id_grupo_corretor, atual, id_tipo_correcao, id_corretor, id_correcao, co_barra_redacao, id_projeto, redacao_id)
								VALUES (DBO.FN_COR_CORRETOR_REDACAO_POR_ID(@REDACAO_ID), @ID_GRUPO_CORRETOR, 1, 1, @AVALIADOR_ID, @CORRECAO_ID, @CO_BARRA_REDACAO, @ID_PROJETO, @REDACAO_ID)
                         SET @FILAPESSOAL_ID = SCOPE_IDENTITY()
						 
						-- CRIACAO LOG
							EXEC SP_INSERE_LOG_FILAPESSOAL @FILAPESSOAL_ID,@ID_PROJETO, @AVALIADOR_ID, '+'
						-- CRIACAO LOG 

						/******* DELETAR O REGISTRO NA FILA 1   *****/						
						
					-- CRIACAO LOG 
						EXEC SP_INSERE_LOG_FILA1 @ID, @ID_PROJETO, @AVALIADOR_ID,'-'
					-- CRIACAO LOG - FIM 

						DELETE FROM correcoes_fila1
						WHERE id = @id
					END
				COMMIT
			END TRY
			BEGIN CATCH

				ROLLBACK
			END CATCH

        SET NOCOUNT OFF;

	RETURN

GO
