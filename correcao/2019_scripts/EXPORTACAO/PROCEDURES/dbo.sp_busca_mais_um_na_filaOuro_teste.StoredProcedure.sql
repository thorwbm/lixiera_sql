/****** Object:  StoredProcedure [dbo].[sp_busca_mais_um_na_filaOuro_teste]    Script Date: 04/10/2019 10:14:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* FORMA NOVA DE BUSCAR MAIS UM NA FILA OURO */
CREATE  procedure [dbo].[sp_busca_mais_um_na_filaOuro_teste]
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
	 DECLARE @QTD_CORRECOES INT
	 DECLARE @QTD_CORRECOES_OURO INT
	 DECLARE @QTD_CORRECOES_OURO_DIA INT
	 DECLARE @REDACAO_ID INT


	 DECLARE @ID_FILAOURO INT

	 SET NOCOUNT ON;

     SET @CORRECAO_ID = 0
     SET @QTD_CORRECOES = 0
     SET @CO_BARRA_REDACAO = NULL   
     SET @REDACAO_ID = NULL


		BEGIN TRANSACTION

			BEGIN TRY
print 'passou 4.1.1.1: ' + convert(varchar(100), dbo.getlocaldate())
RAISERROR(N'', 0, 1) WITH NOWAIT
				/* CONTO QUANTAS CORRECOES O AVALIADOR JA FEZ */
				 select @QTD_CORRECOES = count(cor.id)
				   from correcoes_correcao cor WITH (NOLOCK) join correcoes_redacao red WITH (NOLOCK) on cor.redacao_id = red.id
				  where cor.id_corretor = @AVALIADOR_ID and
				  	    cor.id_projeto  = @ID_PROJETO   and
				  	    cor.id_status = 3    and
				  	    red.id_redacaoouro is null
print 'passou 4.1.1.2: ' + convert(varchar(100), dbo.getlocaldate())
RAISERROR(N'', 0, 1) WITH NOWAIT
				/* CONTO QUANTAS CORRECOES OURO O AVALIADOR JA FEZ NO DIA */
                select @QTD_CORRECOES_OURO = count(cor.id)
				   from correcoes_correcao cor
                        join dbo.getlocaldate_table() dt on 1 = 1
                        join correcoes_redacao red on cor.redacao_id = red.id
				  	                              and cor.id_projeto  = @ID_PROJETO
				  	                              and cor.id_status = 3
				  	                              and cor.id_tipo_correcao = 5 --OURO
						                          and CAST(COR.DATA_TERMINO AS DATE) = convert(date, dt.dt)

print 'passou 4.1.1.3: ' + convert(varchar(100), dbo.getlocaldate())
RAISERROR(N'', 0, 1) WITH NOWAIT

				  /* CALCULO A QUANTIDADE DE OURO QUE O USUARIO PODE TER NO DIA COM BASE NA SUA COTA DE CORRECOES*/
                  SELECT @QTD_CORRECOES_OURO_DIA = DIA.CORRECOES/PRO.ouro_frequencia
                    FROM VW_CORRECAO_DIA DIA WITH (NOLOCK)
                         JOIN PROJETO_PROJETO PRO WITH (NOLOCK) ON DIA.id_projeto = PRO.ID
				   WHERE DIA.ID =  @AVALIADOR_ID
				     AND DIA.id_projeto = @ID_PROJETO

print 'passou 4.1.1.4: ' + convert(varchar(100), dbo.getlocaldate())
RAISERROR(N'', 0, 1) WITH NOWAIT

                /* SE A QUANTIDADE DE OUROS CORRIGIDAS FOR MENOR QUE A COTA DO DIA TESTA SE ELA FOI SORTEADA */
                IF(@QTD_CORRECOES_OURO < @QTD_CORRECOES_OURO_DIA)
					BEGIN
print 'passou 4.1.1.5: ' + convert(varchar(100), dbo.getlocaldate())
RAISERROR(N'', 0, 1) WITH NOWAIT
						  select TOP 1 @CO_BARRA_REDACAO =  our.co_barra_redacao, @ID_FILAOURO = our.ID, @REDACAO_ID = red.id
							from correcoes_filaouro OUR
                                 join correcoes_redacao red on (our.redacao_id = red.id)
								 join correcoes_redacaoouro rdo on (rdo.id = red.id_redacaoouro)
						   WHERE OUR.id_corretor = @AVALIADOR_ID AND
				  				 OUR.id_projeto  = @ID_PROJETO   AND
								  rdo.id_redacaotipo = 2 and
								 isnull(OUR.posicao,100000)    <= (@QTD_CORRECOES + 1)
								 ORDER BY POSICAO
print 'passou 4.1.1.6: ' + convert(varchar(100), dbo.getlocaldate())
RAISERROR(N'', 0, 1) WITH NOWAIT

                   END

               IF (@REDACAO_ID IS NULL)
					BEGIN
						SET @CORRECAO_ID = 0
					END
				ELSE
					BEGIN

						-- ****** DANDO CARGA NA TABELA CORRECOES_CORRECAO E RECUPERANDO O ID DA CORRECAO *********
						-- ***** BUSCANDO AS INFORMACOES DA REDACAO ******
print 'passou 4.1.1.7: ' + convert(varchar(100), dbo.getlocaldate())
RAISERROR(N'', 0, 1) WITH NOWAIT
						SELECT
								@LINK_IMAGEM_RECORTADA = LINK_IMAGEM_RECORTADA,
								@LINK_IMAGEM_ORIGINAL = LINK_IMAGEM_ORIGINAL
						FROM correcoes_redacao crd with (nolock)
						WHERE crd.id = @REDACAO_ID
print 'passou 4.1.1.8: ' + convert(varchar(100), dbo.getlocaldate())
RAISERROR(N'', 0, 1) WITH NOWAIT

						/***** INSERINDO NA TABELA CORRECOES_CORRECAO   *****/
						INSERT INTO correcoes_correcao (data_inicio, link_imagem_recortada, link_imagem_original,
						id_status, id_tipo_correcao, co_barra_redacao, id_corretor, id_projeto, redacao_id)
								SELECT
									dbo.getlocaldate(),
									@LINK_IMAGEM_RECORTADA,
									@LINK_IMAGEM_ORIGINAL,
									1,
									5,
									co_barra_redacao,
									id_corretor,
									ID_PROJETO,@REDACAO_ID
								FROM correcoes_filaOuro cor with (nolock)
								WHERE cor.id = @ID_FILAOURO 
print 'passou 4.1.1.9: ' + convert(varchar(100), dbo.getlocaldate())
RAISERROR(N'', 0, 1) WITH NOWAIT

						/****** RECUPERANDO O ID DA TABELA CORRECOES_CORRECAO   *****/
						select @CORRECAO_ID = SCOPE_IDENTITY()

						/****** FIM DANDO CARGA NA TABELA CORRECAO_REDACAO E RECUPERANDO O ID DA CORRECAO *********/
						/****** INSERIR NA LISTA PESSOAL   *****/
						INSERT INTO correcoes_filapessoal (corrigido_por, id_grupo_corretor, atual, id_tipo_correcao, id_corretor, id_correcao, co_barra_redacao, id_projeto, redacao_id)
								VALUES (DBO.FN_COR_CORRETOR_REDACAO(@CO_BARRA_REDACAO), @ID_GRUPO_CORRETOR, 1, 5, @AVALIADOR_ID, @CORRECAO_ID, @CO_BARRA_REDACAO, @ID_PROJETO, @REDACAO_ID)
						/******* DELETAR O REGISTRO NA FILA OURO   *****/
						DELETE FROM correcoes_filaOuro
						WHERE ID = @ID_FILAOURO
print 'passou 4.1.1.10: ' + convert(varchar(100), dbo.getlocaldate())
RAISERROR(N'', 0, 1) WITH NOWAIT

						/*SE FOR A PRIMEIRA OURO DO DIA REDISTRIBUO AS DEMAIS REDACOES OURO */
						IF(@QTD_CORRECOES_OURO = 0)
							BEGIN
								EXEC sp_distribuir_ordem_DIARIO @AVALIADOR_ID, @ID_PROJETO, 2
							END

					END
				COMMIT
			END TRY
			BEGIN CATCH
				print ERROR_MESSAGE ( )
				ROLLBACK
			END CATCH

		SET NOCOUNT OFF;

	RETURN

GO
