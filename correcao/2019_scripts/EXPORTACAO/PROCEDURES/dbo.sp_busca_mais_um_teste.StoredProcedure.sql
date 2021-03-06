/****** Object:  StoredProcedure [dbo].[sp_busca_mais_um_teste]    Script Date: 04/10/2019 10:14:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_busca_mais_um_teste]
	@AVALIADOR_ID bigint,
	@ID_PROJETO INT,
	@CORRECAO_ID bigint OUTPUT
AS

SET @CORRECAO_ID = 0

     DECLARE @ID bigint

     DECLARE @ID_GRUPO_CORRETOR bigint
     DECLARE @FILA              bigint
     DECLARE @FILA_SUPERVISOR   int     /*** FILA ONDE O SUPERVISOR IRA BUSCAR CORRECOES A SEREM FEITAS - DENFINIDO POR PROJETO ***/
     DECLARE @FILA_PRIORIDADE   int     /*** A PARTIR DE QUAL FILA SERA INICIADO A BUSCA DE UMA CORRECAO PARA O AVALIADOR SOLICITANTE - DENFINIDO POR PROJETO ***/
     DECLARE @ID_PERFIL         bigint  /*** BUSCAR O PERFIL DE PERMISSAO {SUPERVISOR DE HOMOLOGAÇÃO, SUPERVISOR, AVALIADOR}  ***/
     DECLARE @LIMITE            int     /*** CASO O AVALIADOR SEJA SUPERVISOR O LIMITE E A FILA_SUPERVISOR SENAO SERA A ULTIMA DA LISTA A SER TESTADA  */
	 DECLARE @PODE_CORRIGIR_1   int
	 DECLARE @PODE_CORRIGIR_2   int
	 DECLARE @PODE_CORRIGIR_3   int
	 DECLARE @COMANDO           VARCHAR(2000)
	 DECLARE @QTD_CORRECOES     INT

print 'passou 1: ' + convert(varchar(100), dbo.getlocaldate())
RAISERROR(N'', 0, 1) WITH NOWAIT
     SET NOCOUNT ON;

     SET @CORRECAO_ID   = 0
	 SET @QTD_CORRECOES = 0


	 /********** BUSCAR O PERFIL DO CORRETOR  *****/
     SELECT
            @ID_PERFIL = GROUP_ID,
            @ID_GRUPO_CORRETOR = grupo_corretor,
			@PODE_CORRIGIR_1 = PODE_CORRIGIR_1,
			@PODE_CORRIGIR_2 = PODE_CORRIGIR_2,
			@PODE_CORRIGIR_3 = PODE_CORRIGIR_3
      FROM
		    vw_cor_usuario_grupo with (nolock)
     WHERE
	        ID_USUARIO = @AVALIADOR_ID
print 'passou 2: ' + convert(varchar(100), dbo.getlocaldate())
RAISERROR(N'', 0, 1) WITH NOWAIT


	 /**********                     BUSCAR CONFIGURACOES DO PROJETO                             *****/
     /*******************************************************************************************************
   	   SE O AVALIADOR TIVER O PERFIL DE SUPERVISOR ESTE PODERA CORRIGIR SOMENTE AS REDACOES DA FILA DEFINIDA
   	  *******************************************************************************************************/

     SELECT
            @FILA_SUPERVISOR = FILA_SUPERVISOR,
            @FILA_PRIORIDADE = FILA_PRIORITARIA,
			@FILA   = CASE WHEN @ID_PERFIL = 25 THEN FILA_SUPERVISOR ELSE FILA_PRIORITARIA END,
			@LIMITE = CASE WHEN @ID_PERFIL = 25 THEN FILA_SUPERVISOR ELSE 1                END

     FROM
		    PROJETO_PROJETO with (nolock)
     WHERE
	        ID = @ID_PROJETO

print 'passou 3: ' + convert(varchar(100), dbo.getlocaldate())
RAISERROR(N'', 0, 1) WITH NOWAIT

     /********** BUSCAR SE JA EXISTE ALGUMA CORRECAO NA FILA ATUAL COM ATUAL = 1 PARA O AVALIADOR  *****/
     SELECT TOP 1
            @CORRECAO_ID = id_correcao
     FROM
	        correcoes_filapessoal with (nolock)
     WHERE
	        id_corretor = @AVALIADOR_ID AND
			id_projeto  = @ID_PROJETO
     ORDER BY ATUAL DESC, id
print 'passou 4: ' + convert(varchar(100), dbo.getlocaldate())
RAISERROR(N'', 0, 1) WITH NOWAIT

     IF @@ROWCOUNT = 1
     BEGIN
          UPDATE correcoes_filapessoal
          SET ATUAL = 1
          WHERE
		         id_corretor = @AVALIADOR_ID
                 AND ATUAL = 0
                 AND id_correcao = @CORRECAO_ID
				 AND id_projeto  = @ID_PROJETO
print 'passou 5: ' + convert(varchar(100), dbo.getlocaldate())
RAISERROR(N'', 0, 1) WITH NOWAIT


		  IF (@CORRECAO_ID > 0)
				begin

					insert correcoes_historicocorrecao values (dbo.getlocaldate(), null, @CORRECAO_ID, 1, @AVALIADOR_ID)
				end
print 'passou 6: ' + convert(varchar(100), dbo.getlocaldate())
RAISERROR(N'', 0, 1) WITH NOWAIT

          UPDATE correcoes_correcao
          SET data_inicio = dbo.getlocaldate()
          WHERE  id = @CORRECAO_ID
                 AND data_inicio IS NULL
				 AND id_projeto  = @ID_PROJETO
print 'passou 7: ' + convert(varchar(100), dbo.getlocaldate())
RAISERROR(N'', 0, 1) WITH NOWAIT
     END

print 'passou 4.1: ' + convert(varchar(100), dbo.getlocaldate())
RAISERROR(N'', 0, 1) WITH NOWAIT
	 -- ****** busca na fila ouro
	 if (@CORRECAO_ID = 0)
		begin
print 'passou 4.1.1: ' + convert(varchar(100), dbo.getlocaldate())
RAISERROR(N'', 0, 1) WITH NOWAIT
		    EXEC sp_busca_mais_um_na_filaOuro_teste  @AVALIADOR_ID, @ID_PROJETO, @ID_GRUPO_CORRETOR, @CORRECAO_ID OUTPUT
print 'passou 4.1.2: ' + convert(varchar(100), dbo.getlocaldate())
RAISERROR(N'', 0, 1) WITH NOWAIT
			IF (@CORRECAO_ID > 0)
				begin
					insert correcoes_historicocorrecao values (dbo.getlocaldate(), null, @CORRECAO_ID, 1, @AVALIADOR_ID)
				end
		end
	 -- ****** busca na fila moda
	 if (@CORRECAO_ID = 0)
		begin
print 'passou 4.1.3: ' + convert(varchar(100), dbo.getlocaldate())
RAISERROR(N'', 0, 1) WITH NOWAIT
		    EXEC sp_busca_mais_um_na_filaModa  @AVALIADOR_ID, @ID_PROJETO, @ID_GRUPO_CORRETOR, @CORRECAO_ID OUTPUT
print 'passou 4.1.4: ' + convert(varchar(100), dbo.getlocaldate())
RAISERROR(N'', 0, 1) WITH NOWAIT
			IF (@CORRECAO_ID > 0)
				begin
					insert correcoes_historicocorrecao values (dbo.getlocaldate(), null, @CORRECAO_ID, 1, @AVALIADOR_ID)
				end
		end
print 'passou 4.2: ' + convert(varchar(100), dbo.getlocaldate())
RAISERROR(N'', 0, 1) WITH NOWAIT
	IF(@CORRECAO_ID = 0)
		BEGIN
			--BEGIN TRANSACTION
				--BEGIN TRY
print 'passou 4.3: ' + convert(varchar(100), dbo.getlocaldate())
RAISERROR(N'', 0, 1) WITH NOWAIT
					WHILE (@FILA >= @LIMITE AND @CORRECAO_ID = 0 )
						BEGIN
print 'passou 4.4: ' + convert(varchar(100), dbo.getlocaldate())
RAISERROR(N'', 0, 1) WITH NOWAIT
							IF(@FILA = 1 AND @PODE_CORRIGIR_1 = 1)
								BEGIN
print 'passou 8: ' + convert(varchar(100), dbo.getlocaldate())
RAISERROR(N'', 0, 1) WITH NOWAIT
									EXEC sp_busca_mais_um_na_fila1_teste @AVALIADOR_ID, @ID_PROJETO, @ID_GRUPO_CORRETOR, @CORRECAO_ID OUTPUT
print 'passou 9: ' + convert(varchar(100), dbo.getlocaldate())
RAISERROR(N'', 0, 1) WITH NOWAIT
								END
							ELSE IF (@FILA = 2 AND @PODE_CORRIGIR_2 = 1)
								BEGIN
									EXEC sp_busca_mais_um_na_fila2 @AVALIADOR_ID, @ID_PROJETO, @ID_GRUPO_CORRETOR, @CORRECAO_ID OUTPUT
								END
							ELSE IF (@FILA = 3 AND @PODE_CORRIGIR_3 = 1)
								BEGIN
									EXEC sp_busca_mais_um_na_fila3 @AVALIADOR_ID, @ID_PROJETO, @ID_GRUPO_CORRETOR, @CORRECAO_ID OUTPUT
								END
							ELSE IF (@FILA = 4)
								BEGIN
									EXEC sp_busca_mais_um_na_fila4 @AVALIADOR_ID, @ID_PROJETO, @ID_GRUPO_CORRETOR, @CORRECAO_ID OUTPUT
								END

							set @FILA = @FILA - 1
						END

					IF (@CORRECAO_ID > 0)
						begin
							insert correcoes_historicocorrecao values (dbo.getlocaldate(), null, @CORRECAO_ID, 1, @AVALIADOR_ID)
						end
					--COMMIT TRANSACTION
				--END TRY
				--BEGIN CATCH
				--	SET @CORRECAO_ID = -1

				--END CATCH
		END
    SET NOCOUNT OFF;
RETURN

GO
