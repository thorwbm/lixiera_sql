/****** Object:  StoredProcedure [dbo].[sp_busca_mais_um_na_fila4]    Script Date: 26/11/2019 08:33:15 ******/
DROP PROCEDURE [dbo].[sp_busca_mais_um_na_fila4]
GO
/****** Object:  StoredProcedure [dbo].[sp_busca_mais_um_na_fila4]    Script Date: 26/11/2019 08:33:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_busca_mais_um_na_fila4]
	@AVALIADOR_ID int,
	@ID_PROJETO int,
	@ID_GRUPO_CORRETOR int,
	@CORRECAO_ID int output

	as

     DECLARE @ID bigint
     DECLARE @CO_BARRA_REDACAO varchar(50)
     DECLARE @LINK_IMAGEM_RECORTADA varchar(500)
     DECLARE @LINK_IMAGEM_ORIGINAL varchar(500)
     DECLARE @ID_PERFIL bigint
     DECLARE @REDACAO_ID int
     DECLARE @USA_CONSISTENCIA_AUDITORIA int
	 
	 DECLARE @FILAPESSOAL_ID INT -- LOG CORRECAO

	 SET NOCOUNT ON;

     SET @CORRECAO_ID = 0
	 
	 SELECT @USA_CONSISTENCIA_AUDITORIA = ativo FROM core_feature where codigo = 'checar_consistencia_auditoria'

          BEGIN TRY
			BEGIN TRANSACTION

               SELECT TOP 1
                    @ID = id,
                    @CO_BARRA_REDACAO = co_barra_redacao,
                    @REDACAO_ID = redacao_id
               FROM correcoes_fila4 WITH (UPDLOCK, READPAST)
               WHERE
			         consistido = 1 and
					 (consistido_auditoria = 1 OR @USA_CONSISTENCIA_AUDITORIA = 0)  and
			         id_projeto = @ID_PROJETO  and
					 (corrigido_por IS NULL or CORRIGIDO_POR NOT LIKE '%,' + CONVERT(varchar(20), @AVALIADOR_ID) + ',%')
               ORDER BY id;

               IF @@ROWCOUNT = 0
				   BEGIN
						IF NOT EXISTS (SELECT  1
							 FROM correcoes_fila4 WITH (UPDLOCK, READPAST)
							 WHERE id = @ID)
						BEGIN
							SET @CORRECAO_ID = 0
						END

				   END
               ELSE
				   BEGIN

						/****** DANDO CARGA NA TABELA CORRECOES_CORRECAO E RECUPERANDO O ID DA CORRECAO *********/
						/***** BUSCANDO AS INFORMACOES DA REDACAO ******/
						SELECT
							 @LINK_IMAGEM_RECORTADA = LINK_IMAGEM_RECORTADA,
							 @LINK_IMAGEM_ORIGINAL = LINK_IMAGEM_ORIGINAL,
							 @ID_PROJETO = id_projeto
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
								  4,
								  co_barra_redacao,
								  @AVALIADOR_ID,
								  @ID_PROJETO,
                                  @REDACAO_ID
							 FROM correcoes_fila4 cor with (nolock)
							 WHERE id = @ID


						/****** RECUPERANDO O ID DA TABELA CORRECOES_CORRECAO   *****/
						select @CORRECAO_ID = SCOPE_IDENTITY()
						-- LOG CORRECAO UPDATE 
							EXEC SP_INSERE_LOG_CORRECAO @CORRECAO_ID, @ID_PROJETO, NULL, '+'
						-- LOG CORRECAO UPDATE FIM 
						
						/****** FIM DANDO CARGA NA TABELA CORRECAO_REDACAO E RECUPERANDO O ID DA CORRECAO *********/

						/****** INSERIR NA LISTA PESSOAL  *****/
						/****** SELECT * FROM correcoes_filapessoal ******/

						INSERT INTO correcoes_filapessoal (corrigido_por, id_grupo_corretor, atual, id_tipo_correcao, id_corretor, id_correcao, co_barra_redacao, id_projeto, redacao_id)
							 VALUES (DBO.FN_COR_CORRETOR_REDACAO(@CO_BARRA_REDACAO), @ID_GRUPO_CORRETOR, 1, 4, @AVALIADOR_ID, @CORRECAO_ID, @CO_BARRA_REDACAO, @ID_PROJETO, @REDACAO_ID)
							 
							SET @FILAPESSOAL_ID = SCOPE_IDENTITY()
							
							-- CRIACAO LOG
								EXEC SP_INSERE_LOG_FILAPESSOAL @FILAPESSOAL_ID,@ID_PROJETO, @AVALIADOR_ID, '+'
							-- CRIACAO LOG 

						/***** DELETAR O REGISTRO NA FILA 4   *****/
						-- CRIACAO LOG 
							EXEC SP_INSERE_LOG_FILA4 @ID, @ID_PROJETO, NULL, '-'
						-- CRIACAO LOG - FIM 
						DELETE FROM correcoes_fila4
						WHERE consistido = 1 and
					          (consistido_auditoria = 1 OR @USA_CONSISTENCIA_AUDITORIA = 0)  and
			                  id_projeto = @ID_PROJETO and 
					          id = @id

				   END
		COMMIT
     END TRY
     BEGIN CATCH
          ROLLBACK
     END CATCH

	 SET NOCOUNT OFF;
 RETURN

GO
