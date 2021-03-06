/****** Object:  StoredProcedure [dbo].[sp_busca_mais_um_auditoria]    Script Date: 26/11/2019 18:12:04 ******/
DROP PROCEDURE [dbo].[sp_busca_mais_um_auditoria]
GO
/****** Object:  StoredProcedure [dbo].[sp_busca_mais_um_auditoria]    Script Date: 26/11/2019 18:12:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--###########################################################################################


CREATE   PROCEDURE [dbo].[sp_busca_mais_um_auditoria]
	@AVALIADOR_ID bigint,
	@ID_PROJETO INT,
	@TIPO_BUSCA INT,
	@CORRECAO_ID bigint OUTPUT
AS

SET @CORRECAO_ID = 0

     DECLARE @ID bigint
	 DECLARE @ROW INT

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

	 DECLARE @FILAPESSOAL_ID    INT -- CRIACAO LOG
	 DECLARE @HISTORICOCORRECAO_LOG INT -- CRIACAO LOG

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


     /********** BUSCAR SE JA EXISTE ALGUMA CORRECAO NA FILA ATUAL COM ATUAL = 1 PARA O AVALIADOR  *****/
     SELECT TOP 1
            @CORRECAO_ID = PES.id_correcao
     FROM
	        correcoes_filapessoal pes with (nolock) JOIN CORRECOES_CORRECAO COR with (nolock) ON (PES.ID_CORRECAO = COR.ID AND
		                                                                                          PES.id_projeto  = COR.ID_PROJETO)
     WHERE
	        PES.id_corretor = @AVALIADOR_ID AND
			PES.id_projeto  = @ID_PROJETO   AND
			PES.id_tipo_correcao = 7        AND
			COR.TIPO_AUDITORIA_ID = @TIPO_BUSCA
     ORDER BY PES.ATUAL DESC, PES.id
	 SET @ROW =  @@ROWCOUNT

     IF (@ROW = 1)
     BEGIN
          UPDATE correcoes_filapessoal
          SET ATUAL = 1
          WHERE
		         id_corretor = @AVALIADOR_ID
                 AND ATUAL = 0
                 AND id_correcao = @CORRECAO_ID
				 AND id_projeto  = @ID_PROJETO


			-- CRIACAO LOG
			   SELECT @FILAPESSOAL_ID = ID FROM correcoes_filapessoal
			    WHERE id_corretor = @AVALIADOR_ID AND 
                      id_correcao = @CORRECAO_ID AND 
				      id_projeto  = @ID_PROJETO 

				EXEC SP_INSERE_LOG_FILAPESSOAL @FILAPESSOAL_ID, @AVALIADOR_ID,@ID_PROJETO, '~'
			-- CRIACAO LOG 

		  IF (@CORRECAO_ID > 0)
				begin
					insert correcoes_historicocorrecao values (DBO.GETLOCALDATE(), null, @CORRECAO_ID, 1, @AVALIADOR_ID)					
					-- CRIACAO LOG 
					SET @HISTORICOCORRECAO_LOG = SCOPE_IDENTITY()
					EXEC SP_INSERE_LOG_HISTORICOCORRECAO @HISTORICOCORRECAO_LOG, @ID_PROJETO, @AVALIADOR_ID, '+'
					-- CRIACAO LOG - FIM 
				end

          UPDATE correcoes_correcao
          SET data_inicio = DBO.GETLOCALDATE()
          WHERE  id = @CORRECAO_ID
                 AND data_inicio IS NULL
				 AND id_projeto  = @ID_PROJETO
		  
			-- LOG CORRECAO UPDATE 
				EXEC SP_INSERE_LOG_CORRECAO @CORRECAO_ID, @ID_PROJETO, NULL, '~'
			-- LOG CORRECAO UPDATE FIM 
     END

	IF(@CORRECAO_ID = 0)
		BEGIN

			EXEC SP_BUSCA_MAIS_UM_NA_FILAAUDITORIA @AVALIADOR_ID,@ID_PROJETO,@ID_GRUPO_CORRETOR,@TIPO_BUSCA, @CORRECAO_ID output

			IF (@CORRECAO_ID > 0)
				begin
					insert correcoes_historicocorrecao values (DBO.GETLOCALDATE(), null, @CORRECAO_ID, 1, @AVALIADOR_ID)					
					-- CRIACAO LOG 
					SET @HISTORICOCORRECAO_LOG = SCOPE_IDENTITY()
					EXEC SP_INSERE_LOG_HISTORICOCORRECAO @HISTORICOCORRECAO_LOG, @ID_PROJETO, @AVALIADOR_ID, '+'
					-- CRIACAO LOG - FIM 
				end
		END
	 SET NOCOUNT OFF;
RETURN

GO
