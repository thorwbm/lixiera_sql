/**********************************************************************************************************************************
*                                                  [SP_BUSCA_MAIS_UM_NA_FILA3]                                                    *
*                                                                                                                                 *
*  PROCEDURE QUE BUSCA NA FILA 3 UMA PROVA PARA O REQUISITANTE, CASO EXISTA ELE CRIA UM REGISTRO NA CORRECOES_CORRECAO, NA FILA   *
*  PESSOAL.                                                                                                                       *
*                                                                                                                                 *
* BANCO_SISTEMA : ENEM                                                                                                            *
* CRIADO POR    : WEMERSON BITTORI MADURO                                                                         DATA:03/10/2019 *
* ALTERADO POR  : WEMERSON BITTORI MADURO                                                                         DATA:03/10/2019 *
**********************************************************************************************************************************/

ALTER procedure [dbo].[sp_busca_mais_um_na_fila3]
	@AVALIADOR_ID int,
	@ID_PROJETO int,
	@ID_GRUPO_CORRETOR int,
	@CORRECAO_ID int output

	as

     DECLARE @ID bigint
     DECLARE @CO_BARRA_REDACAO varchar(50)
     DECLARE @LINK_IMAGEM_RECORTADA varchar(500)
     DECLARE @LINK_IMAGEM_DESENTORTADA varchar(500)
     DECLARE @LINK_IMAGEM_ORIGINAL varchar(500)
     DECLARE @ID_PERFIL bigint
     DECLARE @REDACAO_ID int

	 SET NOCOUNT ON;

     SET @CORRECAO_ID = 0

          BEGIN TRY
          BEGIN TRANSACTION


               SELECT TOP 1
                    @ID = id,
                    @CO_BARRA_REDACAO = co_barra_redacao,
                    @REDACAO_ID = redacao_id
               FROM correcoes_fila3 WITH (UPDLOCK, READPAST)
               WHERE
			         id_projeto = @ID_PROJETO  and
					 (corrigido_por IS NULL or CORRIGIDO_POR NOT LIKE '%,' + CONVERT(varchar(20), @AVALIADOR_ID) + ',%')
               ORDER BY id;

               IF @@ROWCOUNT = 0
				   BEGIN
						IF NOT EXISTS (SELECT  1
							 FROM correcoes_fila3 WITH (UPDLOCK, READPAST)
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
						FROM correcoes_redacao crd WITH(NOLOCK)
						WHERE crd.id = @REDACAO_ID

						/***** INSERINDO NA TABELA CORRECOES_CORRECAO   *****/
						INSERT INTO correcoes_correcao (data_inicio, link_imagem_recortada, link_imagem_original,
						id_status, id_tipo_correcao, co_barra_redacao, id_corretor, id_projeto, redacao_id)
							 SELECT
								  dbo.getlocaldate(),
								  @LINK_IMAGEM_RECORTADA,
								  @LINK_IMAGEM_ORIGINAL,
								  1,
								  3,
								  co_barra_redacao,
								  @AVALIADOR_ID,
								  @ID_PROJETO,
                                  @REDACAO_ID
							 FROM correcoes_fila3 cor WITH(NOLOCK)
							 WHERE id = @ID

						/****** RECUPERANDO O ID DA TABELA CORRECOES_CORRECAO   *****/
						select @CORRECAO_ID = SCOPE_IDENTITY()

						/**** INSERIR NA LISTA 4				 *****/
						/*					
						#############################################################################################################
						   ERRO NAO EXISTE ESTE PASSO
						#############################################################################################################
						if(exists(select top 1 1 from projeto_projeto WITH(NOLOCK) where id = @ID_PROJETO and fila_prioritaria >=4))
							begin
								INSERT INTO correcoes_fila4 (corrigido_por, id_grupo_corretor, id_correcao, co_barra_redacao, id_projeto, redacao_id)
										SELECT
											DBO.FN_COR_CORRETOR_REDACAO(co_barra_redacao),
											@ID_GRUPO_CORRETOR,
											@CORRECAO_ID,
											co_barra_redacao,
											@ID_PROJETO,
                                            @REDACAO_ID
										FROM correcoes_fila3 fl3 with (nolock)
									WHERE id = @ID AND
									         not exists (select top 1 1 from correcoes_correcao corx with (nolock)
											              where corx.redacao_id = fl3.redacao_id and
																corx.id_tipo_correcao = 4)
							end
						#############################################################################################################
						#############################################################################################################
                          */


						/****** FIM DANDO CARGA NA TABELA CORRECAO_REDACAO E RECUPERANDO O ID DA CORRECAO *********/

						/****** INSERIR NA LISTA PESSOAL  *****/
						/****** SELECT * FROM correcoes_filapessoal ******/

						INSERT INTO correcoes_filapessoal (corrigido_por, id_grupo_corretor, atual, id_tipo_correcao, id_corretor, id_correcao, co_barra_redacao, id_projeto, redacao_id)
							 VALUES (DBO.FN_COR_CORRETOR_REDACAO_POR_ID(@REDACAO_ID), @ID_GRUPO_CORRETOR, 1, 3, @AVALIADOR_ID, @CORRECAO_ID, @CO_BARRA_REDACAO, @ID_PROJETO, @REDACAO_ID)

						/***** DELETAR O REGISTRO NA FILA 3   *****/
						DELETE FROM correcoes_fila3
						WHERE id = @id
				   END
		COMMIT
     END TRY
     BEGIN CATCH
          ROLLBACK
     END CATCH

	 SET NOCOUNT OFF;
  RETURN
