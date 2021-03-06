/****** Object:  StoredProcedure [dbo].[sp_busca_mais_um_na_fila1_teste]    Script Date: 04/10/2019 10:14:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[sp_busca_mais_um_na_fila1_teste]
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

print 'passou 9.1: ' + convert(varchar(100), dbo.getlocaldate())
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
print 'passou 9.2: ' + convert(varchar(100), dbo.getlocaldate())
			SET @ROWS = @@ROWCOUNT

               IF (@ROWS = 0)
					BEGIN
print 'passou 9.3: ' + convert(varchar(100), dbo.getlocaldate())
						IF NOT EXISTS (SELECT 1
										FROM correcoes_fila1 WITH (UPDLOCK, READPAST)
									   WHERE id = @ID AND
									         id_projeto = @ID_PROJETO)
							BEGIN
								 SET @CORRECAO_ID = 0

							END
print 'passou 9.4: ' + convert(varchar(100), dbo.getlocaldate())
					END
				ELSE
					BEGIN

						-- ****** DANDO CARGA NA TABELA CORRECOES_CORRECAO E RECUPERANDO O ID DA CORRECAO *********
						-- ***** BUSCANDO AS INFORMACOES DA REDACAO ******
print 'passou 9.5: ' + convert(varchar(100), dbo.getlocaldate())
						SELECT
								@LINK_IMAGEM_RECORTADA = LINK_IMAGEM_RECORTADA,
								@LINK_IMAGEM_ORIGINAL = LINK_IMAGEM_ORIGINAL
						  FROM  correcoes_redacao crd with (nolock)
						 WHERE  crd.id = @REDACAO_ID
print 'passou 9.6: ' + convert(varchar(100), dbo.getlocaldate())

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
print 'passou 9.7: ' + convert(varchar(100), dbo.getlocaldate())

						/****** RECUPERANDO O ID DA TABELA CORRECOES_CORRECAO   *****/
						select @CORRECAO_ID = SCOPE_IDENTITY()

						/**** INSERIR NA LISTA 2				 *****/
						if(exists(select 1 from projeto_projeto where id = @ID_PROJETO and fila_prioritaria >=2))
							begin
print 'passou 9.8: ' + convert(varchar(100), dbo.getlocaldate())
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

print 'passou 9.9: ' + convert(varchar(100), dbo.getlocaldate())
							end

						/****** FIM DANDO CARGA NA TABELA CORRECAO_FILAPESSOAL E RECUPERANDO O ID DA CORRECAO *********/
						/****** INSERIR NA LISTA PESSOAL   *****/
						INSERT INTO correcoes_filapessoal (corrigido_por, id_grupo_corretor, atual, id_tipo_correcao, id_corretor, id_correcao, co_barra_redacao, id_projeto, redacao_id)
								VALUES (DBO.FN_COR_CORRETOR_REDACAO_POR_ID(@REDACAO_ID), @ID_GRUPO_CORRETOR, 1, 1, @AVALIADOR_ID, @CORRECAO_ID, @CO_BARRA_REDACAO, @ID_PROJETO, @REDACAO_ID)
print 'passou 9.10: ' + convert(varchar(100), dbo.getlocaldate())

						/******* DELETAR O REGISTRO NA FILA 1   *****/
						DELETE FROM correcoes_fila1
						WHERE id = @id
print 'passou 9.11: ' + convert(varchar(100), dbo.getlocaldate())
					END
				COMMIT
			END TRY
			BEGIN CATCH

				ROLLBACK
			END CATCH

        SET NOCOUNT OFF;

	RETURN

GO
