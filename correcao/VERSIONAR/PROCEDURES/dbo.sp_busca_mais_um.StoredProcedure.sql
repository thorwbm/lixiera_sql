/****** Object:  StoredProcedure [dbo].[sp_busca_mais_um]    Script Date: 24/11/2019 21:41:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE     PROCEDURE [dbo].[sp_busca_mais_um]
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
	 DECLARE @PODE_CORRIGIR_4   int
	 DECLARE @COMANDO           VARCHAR(2000)
	 DECLARE @QTD_CORRECOES     INT

	 DECLARE @HISTORICOCORRECAO_LOG INT -- CRIACAO LOG
	 DECLARE @FILAPESSOAL_ID        INT -- CIRACAO LOG
	 DECLARE @REDACAO_ID            INT -- CRIACAO LOG 

     SET NOCOUNT ON;

     SET @CORRECAO_ID   = 0
	 SET @QTD_CORRECOES = 0

	 /********** BUSCAR O PERFIL DO CORRETOR  *****/
     SELECT
            @ID_PERFIL = GROUP_ID,
            @ID_GRUPO_CORRETOR = grupo_corretor,
			@PODE_CORRIGIR_1 = PODE_CORRIGIR_1,
			@PODE_CORRIGIR_2 = PODE_CORRIGIR_2,
			@PODE_CORRIGIR_3 = PODE_CORRIGIR_3,
			@PODE_CORRIGIR_4 = PODE_CORRIGIR_4

      FROM
		    vw_cor_usuario_grupo with (nolock)
     WHERE
	        ID_USUARIO = @AVALIADOR_ID


	 /**********                     BUSCAR CONFIGURACOES DO PROJETO                             *****/
     /*******************************************************************************************************
   	   SE O AVALIADOR TIVER O PERFIL DE SUPERVISOR ESTE PODERA CORRIGIR SOMENTE AS REDACOES DA FILA DEFINIDA
   	  *******************************************************************************************************/

     SELECT
            @FILA_SUPERVISOR = FILA_SUPERVISOR,
            @FILA_PRIORIDADE = FILA_PRIORITARIA,
			@FILA   = CASE WHEN @ID_PERFIL in (25,31) THEN FILA_SUPERVISOR ELSE FILA_PRIORITARIA END,
			@LIMITE = CASE WHEN @ID_PERFIL in (25,31) THEN FILA_SUPERVISOR ELSE 1                END

     FROM
		    PROJETO_PROJETO with (nolock)
     WHERE
	        ID = @ID_PROJETO


     /********** BUSCAR SE JA EXISTE ALGUMA CORRECAO NA FILA ATUAL COM ATUAL = 1 PARA O AVALIADOR  *****/
     SELECT TOP 1
            @CORRECAO_ID = id_correcao
     FROM
	        correcoes_filapessoal with (nolock)
     WHERE
	        id_corretor = @AVALIADOR_ID AND
			id_projeto  = @ID_PROJETO
     ORDER BY ATUAL DESC, id
     IF @@ROWCOUNT = 1
     BEGIN
	       
          UPDATE correcoes_filapessoal
          SET ATUAL = 1
          WHERE
		         id_corretor = @AVALIADOR_ID
                 AND ATUAL = 0
                 AND id_correcao = @CORRECAO_ID
				 AND id_projeto  = @ID_PROJETO

			SELECT @FILAPESSOAL_ID = ID FROM correcoes_filapessoal 
			WHERE id_corretor = @AVALIADOR_ID AND 
			      id_correcao = @CORRECAO_ID  AND 
				  id_projeto  = @ID_PROJETO 

            -- CRIACAO LOG
			EXEC SP_INSERE_LOG_FILAPESSOAL @FILAPESSOAL_ID, @AVALIADOR_ID,@ID_PROJETO, '~'
            -- CRIACAO LOG 

		  IF (@CORRECAO_ID > 0)
				begin
					
					insert correcoes_historicocorrecao values (dbo.getlocaldate(), null, @CORRECAO_ID, 1, @AVALIADOR_ID)
					SET @HISTORICOCORRECAO_LOG = SCOPE_IDENTITY()

					-- CRIACAO LOG 
					EXEC SP_INSERE_LOG_HISTORICOCORRECAO @HISTORICOCORRECAO_LOG, @ID_PROJETO, @AVALIADOR_ID, '+'
					-- CRIACAO LOG - FIM 
				end

          UPDATE correcoes_correcao
          SET data_inicio = dbo.getlocaldate()
          WHERE  id = @CORRECAO_ID
                 AND data_inicio IS NULL
				 AND id_projeto  = @ID_PROJETO
		  
			-- LOG CORRECAO UPDATE 
				EXEC SP_INSERE_LOG_CORRECAO @CORRECAO_ID, @ID_PROJETO, NULL, '~'
			-- LOG CORRECAO UPDATE FIM 

     END

	 -- ****** busca na fila ouro
	 if (@CORRECAO_ID = 0)
		begin
		    EXEC sp_busca_mais_um_na_filaOuro  @AVALIADOR_ID, @ID_PROJETO, @ID_GRUPO_CORRETOR, @CORRECAO_ID OUTPUT
			IF (@CORRECAO_ID > 0)
				begin
					insert correcoes_historicocorrecao values (dbo.getlocaldate(), null, @CORRECAO_ID, 1, @AVALIADOR_ID)
					-- CRIACAO LOG 
					SET @HISTORICOCORRECAO_LOG = SCOPE_IDENTITY()
						EXEC SP_INSERE_LOG_HISTORICOCORRECAO @HISTORICOCORRECAO_LOG, @ID_PROJETO, @AVALIADOR_ID, '+'
					-- CRIACAO LOG - FIM 


					-- **** setar data de inicio na tabela de correcoes_redacao  *****
					update red set red.data_inicio = cor.data_inicio, red.id_status = 2
					from correcoes_redacao red join correcoes_correcao cor on (cor.redacao_id = red.id)
					 where cor.id  = @CORRECAO_ID  and 
						   red.data_inicio is null
					-- CRIACAO LOG 
					IF (@@ROWCOUNT > 0)
						BEGIN
							EXEC SP_INSERE_LOG_REDACAO @REDACAO_ID, @ID_PROJETO, NULL, '~'
					    END 
				   -- CRIACAO LOG - FIM
				end
		end
	 -- ****** busca na fila moda
	 if (@CORRECAO_ID = 0)
		begin
		    EXEC sp_busca_mais_um_na_filaModa  @AVALIADOR_ID, @ID_PROJETO, @ID_GRUPO_CORRETOR, @CORRECAO_ID OUTPUT
			IF (@CORRECAO_ID > 0)
				begin
					insert correcoes_historicocorrecao values (dbo.getlocaldate(), null, @CORRECAO_ID, 1, @AVALIADOR_ID)
					-- CRIACAO LOG 
					SET @HISTORICOCORRECAO_LOG = SCOPE_IDENTITY()
						EXEC SP_INSERE_LOG_HISTORICOCORRECAO @HISTORICOCORRECAO_LOG, @ID_PROJETO, @AVALIADOR_ID, '+'
					-- CRIACAO LOG - FIM 

					-- **** setar data de inicio na tabela de correcoes_redacao  ***** 
					update red set red.data_inicio = cor.data_inicio, red.id_status = 2 
					from correcoes_redacao red join correcoes_correcao cor on (cor.redacao_id = red.id)
					 where cor.id  = @CORRECAO_ID  and 
						   red.data_inicio is null

					-- CRIACAO LOG 
					IF (@@ROWCOUNT > 0)
						BEGIN
							EXEC SP_INSERE_LOG_REDACAO @REDACAO_ID, @ID_PROJETO, NULL, '~'
					    END 
				   -- CRIACAO LOG - FIM
				end
		end
		
	IF(@CORRECAO_ID = 0)
		BEGIN
			--BEGIN TRANSACTION
				--BEGIN TRY
					WHILE (@FILA >= @LIMITE AND @CORRECAO_ID = 0 )
						BEGIN
							IF(@FILA = 1 AND @PODE_CORRIGIR_1 = 1)
								BEGIN
									EXEC sp_busca_mais_um_na_fila1 @AVALIADOR_ID, @ID_PROJETO, @ID_GRUPO_CORRETOR, @CORRECAO_ID OUTPUT
									-- **** setar data de inicio na tabela de correcoes_redacao  *****

									update red set red.data_inicio = cor.data_inicio, red.id_status = 2 
									from correcoes_redacao red join correcoes_correcao cor on (cor.redacao_id = red.id)
									 where cor.id  = @CORRECAO_ID  and 
										   red.data_inicio is null

									-- CRIACAO LOG 			
										SELECT @REDACAO_ID = redacao_id FROM CORRECOES_CORRECAO WHERE ID = @CORRECAO_ID						
										EXEC SP_INSERE_LOG_REDACAO @REDACAO_ID, @ID_PROJETO, NULL, '~'									
								   -- CRIACAO LOG - FIM
								END
							ELSE IF (@FILA = 2 AND @PODE_CORRIGIR_2 = 1)
								BEGIN
									EXEC sp_busca_mais_um_na_fila2 @AVALIADOR_ID, @ID_PROJETO, @ID_GRUPO_CORRETOR, @CORRECAO_ID OUTPUT
								END
							ELSE IF (@FILA = 3 AND @PODE_CORRIGIR_3 = 1)
								BEGIN
									EXEC sp_busca_mais_um_na_fila3 @AVALIADOR_ID, @ID_PROJETO, @ID_GRUPO_CORRETOR, @CORRECAO_ID OUTPUT
								END
							ELSE IF (@FILA = 4 AND @PODE_CORRIGIR_4 = 1)
								BEGIN							    
									EXEC sp_busca_mais_um_na_fila4 @AVALIADOR_ID, @ID_PROJETO, @ID_GRUPO_CORRETOR, @CORRECAO_ID OUTPUT
								END

							set @FILA = @FILA - 1
						END

					IF (@CORRECAO_ID > 0)
						begin
							insert correcoes_historicocorrecao values (dbo.getlocaldate(), null, @CORRECAO_ID, 1, @AVALIADOR_ID)
							-- CRIACAO LOG 
								SET @HISTORICOCORRECAO_LOG = SCOPE_IDENTITY()
								EXEC SP_INSERE_LOG_HISTORICOCORRECAO @HISTORICOCORRECAO_LOG, @ID_PROJETO, @AVALIADOR_ID, '+'
							-- CRIACAO LOG - FIM 
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
