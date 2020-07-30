
CREATE OR ALTER PROCEDURE [dbo].[rebuild_indices] as
begin
    exec sp_foreach_table_azure @command1="ALTER INDEX ALL ON ? REORGANIZE ; "
    exec sp_foreach_table_azure @command1="ALTER INDEX ALL ON ? REBUILD ; "
    exec sp_foreach_table_azure @command1="UPDATE STATISTICS ? ; "
end

GO
/****** Object:  StoredProcedure [dbo].[sp_avalia_aproveitamento]    Script Date: 16/10/2019 10:22:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [dbo].[sp_avalia_aproveitamento]
    @REDACAO_ID INT,
	@ID_PROJETO INT
	AS

DECLARE @CONCLUSAO1 INT
DECLARE @CONCLUSAO2 INT
DECLARE @ID_CORRECAO1 INT
DECLARE @ID_CORRECAO2 INT
DECLARE @APROVEITAMENTO1 INT
DECLARE @APROVEITAMENTO2 INT
DECLARE @DIFERENCA_NOTAFINAL1 FLOAT
DECLARE @DIFERENCA_NOTAFINAL2 FLOAT
DECLARE @ID_ANALISE1 INT
DECLARE @ID_ANALISE2 INT
DECLARE @SITUACAO1 INT
DECLARE @SITUACAO2 INT
DECLARE @SITUACAO3 INT
DECLARE @DIFERENCA_SITUACAO1 INT
DECLARE @DIFERENCA_SITUACAO2 INT

select @CONCLUSAO1 = ANA1.conclusao_analise,
       @CONCLUSAO2 = ANA2.conclusao_analise,
	   @ID_CORRECAO1 = ANA1.id_correcao_A,
	   @ID_CORRECAO2 = ANA2.id_correcao_A,
	   @DIFERENCA_NOTAFINAL1   = ANA1.diferenca_nota_final,
	   @DIFERENCA_NOTAFINAL2   = ANA2.diferenca_nota_final,
	   @ID_ANALISE1  = ANA1.ID,
	   @ID_ANALISE2  = ANA2.ID,
	   @SITUACAO1    = ANA1.id_correcao_situacao_A,
	   @SITUACAO2    = ANA2.ID_CORRECAO_SITUACAO_A,
	   @SITUACAO3    = ANA2.id_correcao_situacao_B,
	   @DIFERENCA_SITUACAO1 = ANA1.diferenca_situacao,
	   @DIFERENCA_SITUACAO2 = ANA2.diferenca_situacao

from correcoes_analise ana1 join correcoes_analise ana2 on (ana1.redacao_id = ana2.redacao_id and
                                                            ana1.id_projeto       = ana2.id_projeto AND
															ANA1.id_tipo_correcao_B = ANA2.id_tipo_correcao_B)
  where ana1.id_tipo_correcao_A = 1 and
        ana2.id_tipo_correcao_A = 2 and
		ana2.id_tipo_correcao_B = 3 AND
		ana2.redacao_id = @REDACAO_ID AND
		ANA1.id_projeto = @ID_PROJETO



	SET @APROVEITAMENTO1 = -1
	SET @APROVEITAMENTO2 = -1

    -- SE A TERCERIA CORRECAO FOR SITUACAO ENTAO UMA DAS DUAS
	-- ANTERIORES DEVERAM SER SITUACAO IGUAL PARA APROVEITAMENTO SENAO DESCARTE AS DUAS ANTERIORES
	IF(@CONCLUSAO1 = 0 AND @CONCLUSAO2 = 0)  --*** CRAVOU
		BEGIN
			SET @APROVEITAMENTO1 = 1
			SET @APROVEITAMENTO2 = 1
        END
	ELSE IF (@CONCLUSAO1 = 0)  --*** APENAS O PRIMEIRO CRAVOU
		BEGIN
			SET @APROVEITAMENTO1 = 1
			SET @APROVEITAMENTO2 = 0
		END
	ELSE IF (@CONCLUSAO2 = 0) --*** APENAS O SEGUNDO CRAVOU
		BEGIN
			SET @APROVEITAMENTO1 = 0
			SET @APROVEITAMENTO2 = 1
		END
	ELSE IF (@CONCLUSAO1 >=3 AND @CONCLUSAO2 >= 3) --*** SE OS DOIS DISCREPARAM
		BEGIN
			SET @APROVEITAMENTO1 = 0
			SET @APROVEITAMENTO2 = 0
		END
	ELSE IF (@CONCLUSAO1 >= 3)  --*** SE APENAS O PRIMEIRO DISCREPOU
		BEGIN
			SET @APROVEITAMENTO1 = 0
			SET @APROVEITAMENTO2 = 1
		END
	ELSE IF (@CONCLUSAO2 >= 3)  --*** SE APENAS O SEGUNDO DISCREPOU
		BEGIN
			SET @APROVEITAMENTO1 = 1
			SET @APROVEITAMENTO2 = 0
		END
	ELSE IF (@DIFERENCA_NOTAFINAL1 > @DIFERENCA_NOTAFINAL2) --*** SE NAO HOUVE DISCREPANCIA E A DIFERENCA1 E MAIOR QUE A DIFERENCA2
		BEGIN
			SET @APROVEITAMENTO1 = 0
			SET @APROVEITAMENTO2 = 1
		END
	ELSE IF (@DIFERENCA_NOTAFINAL1 < @DIFERENCA_NOTAFINAL2) --*** SE NAO HOUVE DISCREPANCIA E A DIFERENCA2 E MAIOR QUE A DIFERENCA1
		BEGIN
			SET @APROVEITAMENTO1 = 1
			SET @APROVEITAMENTO2 = 0
		END
	ELSE IF (@DIFERENCA_NOTAFINAL1 = @DIFERENCA_NOTAFINAL2) --*** SE NAO HOUVE DISCREPANCIA E A DIFERENCA1 E IGUAL QUE A DIFERENCA2
		BEGIN
			SET @APROVEITAMENTO1 = 1
			SET @APROVEITAMENTO2 = 1
		END

	IF(@APROVEITAMENTO1 <> -1 AND @APROVEITAMENTO2 <> -1)
		BEGIN
			UPDATE CORRECOES_ANALISE SET aproveitamento = @APROVEITAMENTO1
			WHERE ID= @ID_ANALISE1 AND
					id_status_B = 3

			UPDATE CORRECOES_ANALISE SET aproveitamento = @APROVEITAMENTO2
			WHERE ID= @ID_ANALISE2 AND
					id_status_B = 3
		END

GO
/****** Object:  StoredProcedure [dbo].[sp_bloqueio]    Script Date: 16/10/2019 10:22:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*****************************************************************************************************************
*                                              PROCEDURE BLOQUEIOS                                               *
*                                                                                                                *
*  PROCEDURE QUE ENCONTRA UM BLOQUEIO MATA SUA OCORRENCIA LIBERANDO O BANCO E GRAVA EM UMA TABELA DE LOG CHAMADA *
*  LOG_BLOQUEIO                                                                                                  *
*                                                                                                                *
* BANCO_SISTEMA : ENCCEJA                                                                                        *
* CRIADO POR    : WEMERSON BITTORI MADURO                                                        DATA:04/09/2018 *
* ALTERADO POR  : WEMERSON BITTORI MADURO                                                        DATA:04/09/2018 *
******************************************************************************************************************/

CREATE OR ALTER PROCEDURE [dbo].[sp_bloqueio] as 

CREATE TABLE #TEMP(
        SPID INT, Status VARCHAR(MAX), LOGIN VARCHAR(MAX), HostName VARCHAR(MAX), BlkBy VARCHAR(MAX),
        DBName VARCHAR(MAX), Command VARCHAR(MAX), CPUTime INT, DiskIO INT, LastBatch VARCHAR(MAX),
        ProgramName VARCHAR(MAX), SPID_1 INT, REQUESTID INT
)

INSERT INTO #TEMP EXEC sp_who2

DECLARE @BLOQUEIO VARCHAR(100)
DECLARE @HOSTNAME VARCHAR(500)
DECLARE @COMANDO VARCHAR(500)
DECLARE @ERRO    VARCHAR(MAX)
DECLARE @BANCO   VARCHAR(1000)
DECLARE @USUARIO VARCHAR(1000)
declare @data    datetime

DECLARE @BLOQUEIO_f VARCHAR(100)
DECLARE @HOSTNAME_f VARCHAR(500)
DECLARE @COMANDO_f VARCHAR(500)
DECLARE @ERRO_f    VARCHAR(MAX)
DECLARE @BANCO_f   VARCHAR(1000)
DECLARE @USUARIO_f VARCHAR(1000)

SELECT @BLOQUEIO = TP.spid, @HOSTNAME = TP.HostName, @BANCO = TP.DBName, @USUARIO = TP.LOGIN FROM #TEMP TP WHERE TP.SPID IN (
select TMP.BlkBy from #TEMP TMP JOIN sys.sysprocesses AUX ON (TMP.SPID = AUX.SPID)
WHERE TMP.BlkBy <> '  .' and aux.waittime >= 10000)
      AND TP.BlkBy = '  .'
	  
	  SELECT @ERRO = EVENT_INFO FROM sys.dm_exec_input_buffer(@bloqueio, 0);

IF(@@ROWCOUNT > 0)
	BEGIN
		set @data = getdate()
		INSERT LOG_BLOQUEIO 
		SELECT @BLOQUEIO, @HOSTNAME, @ERRO,  @data, @BANCO, @USUARIO

	declare cur_loc cursor for 
	select TmP.spid, TmP.HostName, TmP.DBName, tmp.LOGIN 
	from #TEMP TMP 
                 WHERE TMP.BlkBy <> '  .'
				  
	open cur_loc 
		fetch next from cur_loc into @BLOQUEIO_f, @HOSTNAME_f,  @BANCO_f, @USUARIO_f
		while @@FETCH_STATUS = 0
			BEGIN
			   SELECT @ERRO_f = EVENT_INFO FROM sys.dm_exec_input_buffer(@bloqueio_f, 0);

				insert into log_bloqueio_filha values (@bloqueio, @BLOQUEIO_f, @HOSTNAME_f,isnull( @ERRO_f,'*****'),  @data, @BANCO_f, @USUARIO_f)


			fetch next from cur_loc into @BLOQUEIO_f, @HOSTNAME_f, @BANCO_f, @USUARIO_f
			END
		close cur_loc 
	deallocate cur_loc 


		 set @comando = 'kill '+convert(char,@BLOQUEIO)
				   execute (@comando)
	end

DROP TABLE #TEMP
GO
/****** Object:  StoredProcedure [dbo].[sp_busca_mais_um]    Script Date: 16/10/2019 10:22:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [dbo].[sp_busca_mais_um]
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

		  IF (@CORRECAO_ID > 0)
				begin

					insert correcoes_historicocorrecao values (dbo.getlocaldate(), null, @CORRECAO_ID, 1, @AVALIADOR_ID)
				end

          UPDATE correcoes_correcao
          SET data_inicio = dbo.getlocaldate()
          WHERE  id = @CORRECAO_ID
                 AND data_inicio IS NULL
				 AND id_projeto  = @ID_PROJETO
     END

	 -- ****** busca na fila ouro
	 if (@CORRECAO_ID = 0)
		begin
		    EXEC sp_busca_mais_um_na_filaOuro  @AVALIADOR_ID, @ID_PROJETO, @ID_GRUPO_CORRETOR, @CORRECAO_ID OUTPUT
			IF (@CORRECAO_ID > 0)
				begin
					insert correcoes_historicocorrecao values (dbo.getlocaldate(), null, @CORRECAO_ID, 1, @AVALIADOR_ID)
				end
		end
	 -- ****** busca na fila moda
	 if (@CORRECAO_ID = 0)
		begin
		    EXEC sp_busca_mais_um_na_filaModa  @AVALIADOR_ID, @ID_PROJETO, @ID_GRUPO_CORRETOR, @CORRECAO_ID OUTPUT
			IF (@CORRECAO_ID > 0)
				begin
					insert correcoes_historicocorrecao values (dbo.getlocaldate(), null, @CORRECAO_ID, 1, @AVALIADOR_ID)
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
/****** Object:  StoredProcedure [dbo].[sp_busca_mais_um_auditoria]    Script Date: 16/10/2019 10:22:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [dbo].[sp_busca_mais_um_auditoria]
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

		  IF (@CORRECAO_ID > 0)
				begin
					insert correcoes_historicocorrecao values (getdate(), null, @CORRECAO_ID, 1, @AVALIADOR_ID)
				end

          UPDATE correcoes_correcao
          SET data_inicio = GETDATE()
          WHERE  id = @CORRECAO_ID
                 AND data_inicio IS NULL
				 AND id_projeto  = @ID_PROJETO
     END

	IF(@CORRECAO_ID = 0)
		BEGIN

			EXEC SP_BUSCA_MAIS_UM_NA_FILAAUDITORIA @AVALIADOR_ID,@ID_PROJETO,@ID_GRUPO_CORRETOR,@TIPO_BUSCA, @CORRECAO_ID output

			IF (@CORRECAO_ID > 0)
				begin
					insert correcoes_historicocorrecao values (getdate(), null, @CORRECAO_ID, 1, @AVALIADOR_ID)
				end
		END
	 SET NOCOUNT OFF;
RETURN

GO
/****** Object:  StoredProcedure [dbo].[sp_busca_mais_um_na_fila1]    Script Date: 16/10/2019 10:22:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [dbo].[sp_busca_mais_um_na_fila1]    Script Date: 10/09/2019 20:29:00 ******/
CREATE OR ALTER PROCEDURE [dbo].[sp_busca_mais_um_na_fila1]
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
						select @CORRECAO_ID = SCOPE_IDENTITY()

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

							end

						/****** FIM DANDO CARGA NA TABELA CORRECAO_FILAPESSOAL E RECUPERANDO O ID DA CORRECAO *********/
						/****** INSERIR NA LISTA PESSOAL   *****/
						INSERT INTO correcoes_filapessoal (corrigido_por, id_grupo_corretor, atual, id_tipo_correcao, id_corretor, id_correcao, co_barra_redacao, id_projeto, redacao_id)
								VALUES (DBO.FN_COR_CORRETOR_REDACAO_POR_ID(@REDACAO_ID), @ID_GRUPO_CORRETOR, 1, 1, @AVALIADOR_ID, @CORRECAO_ID, @CO_BARRA_REDACAO, @ID_PROJETO, @REDACAO_ID)

						/******* DELETAR O REGISTRO NA FILA 1   *****/
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
/****** Object:  StoredProcedure [dbo].[sp_busca_mais_um_na_fila1_teste]    Script Date: 16/10/2019 10:22:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [dbo].[sp_busca_mais_um_na_fila1_teste]
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
/****** Object:  StoredProcedure [dbo].[sp_busca_mais_um_na_fila2]    Script Date: 16/10/2019 10:22:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [dbo].[sp_busca_mais_um_na_fila2]
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


						/****** FIM DANDO CARGA NA TABELA CORRECAO_REDACAO E RECUPERANDO O ID DA CORRECAO *********/
						/****** INSERIR NA LISTA PESSOAL   *****/
						INSERT INTO correcoes_filapessoal (corrigido_por, id_grupo_corretor, atual, id_tipo_correcao, id_corretor, id_correcao, co_barra_redacao, id_projeto, redacao_id)
								VALUES (DBO.FN_COR_CORRETOR_REDACAO(@CO_BARRA_REDACAO), @ID_GRUPO_CORRETOR, 1, 2, @AVALIADOR_ID, @CORRECAO_ID, @CO_BARRA_REDACAO, @ID_PROJETO, @REDACAO_ID)

						/******* DELETAR O REGISTRO NA FILA 2   *****/
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
/****** Object:  StoredProcedure [dbo].[sp_busca_mais_um_na_fila3]    Script Date: 16/10/2019 10:22:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [dbo].[sp_busca_mais_um_na_fila3]
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
						FROM correcoes_redacao crd
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
							 FROM correcoes_fila3 cor
							 WHERE id = @ID

						/****** RECUPERANDO O ID DA TABELA CORRECOES_CORRECAO   *****/
						select @CORRECAO_ID = SCOPE_IDENTITY()

						/**** INSERIR NA LISTA 4				 *****/
						if(exists(select top 1 1 from projeto_projeto where id = @ID_PROJETO and fila_prioritaria >=4))
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
									         not exists (select top 1 1 from correcoes_correcao corx
											              where corx.redacao_id = fl3.redacao_id and
																corx.id_tipo_correcao = 4)
							end



						/****** FIM DANDO CARGA NA TABELA CORRECAO_REDACAO E RECUPERANDO O ID DA CORRECAO *********/

						/****** INSERIR NA LISTA PESSOAL  *****/
						/****** SELECT * FROM correcoes_filapessoal ******/

						INSERT INTO correcoes_filapessoal (corrigido_por, id_grupo_corretor, atual, id_tipo_correcao, id_corretor, id_correcao, co_barra_redacao, id_projeto, redacao_id)
							 VALUES (DBO.FN_COR_CORRETOR_REDACAO(@CO_BARRA_REDACAO), @ID_GRUPO_CORRETOR, 1, 3, @AVALIADOR_ID, @CORRECAO_ID, @CO_BARRA_REDACAO, @ID_PROJETO, @REDACAO_ID)

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

GO
/****** Object:  StoredProcedure [dbo].[sp_busca_mais_um_na_fila4]    Script Date: 16/10/2019 10:22:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [dbo].[sp_busca_mais_um_na_fila4]
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

	 SET NOCOUNT ON;

     SET @CORRECAO_ID = 0

          BEGIN TRY
			BEGIN TRANSACTION

               SELECT TOP 1
                    @ID = id,
                    @CO_BARRA_REDACAO = co_barra_redacao,
                    @REDACAO_ID = redacao_id
               FROM correcoes_fila4 WITH (UPDLOCK, READPAST)
               WHERE
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


						/****** FIM DANDO CARGA NA TABELA CORRECAO_REDACAO E RECUPERANDO O ID DA CORRECAO *********/

						/****** INSERIR NA LISTA PESSOAL  *****/
						/****** SELECT * FROM correcoes_filapessoal ******/

						INSERT INTO correcoes_filapessoal (corrigido_por, id_grupo_corretor, atual, id_tipo_correcao, id_corretor, id_correcao, co_barra_redacao, id_projeto, redacao_id)
							 VALUES (DBO.FN_COR_CORRETOR_REDACAO(@CO_BARRA_REDACAO), @ID_GRUPO_CORRETOR, 1, 4, @AVALIADOR_ID, @CORRECAO_ID, @CO_BARRA_REDACAO, @ID_PROJETO, @REDACAO_ID)

						/***** DELETAR O REGISTRO NA FILA 4   *****/
						DELETE FROM correcoes_fila4
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
/****** Object:  StoredProcedure [dbo].[sp_busca_mais_um_na_filaauditoria]    Script Date: 16/10/2019 10:22:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 CREATE   OR ALTER procedure [dbo].[sp_busca_mais_um_na_filaauditoria]
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
										WHERE redacao_id = @REDACAO_ID AND
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
/****** Object:  StoredProcedure [dbo].[sp_busca_mais_um_na_filaModa]    Script Date: 16/10/2019 10:22:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [dbo].[sp_busca_mais_um_na_filaModa]
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
	 DECLARE @QTD_CORRECOES_MODA INT
	 DECLARE @QTD_CORRECOES_MODA_DIA INT
	 DECLARE @REDACAO_ID INT

	 DECLARE @ID_FILAOURO INT

	 SET NOCOUNT ON;

     SET @CORRECAO_ID = 0
     SET @QTD_CORRECOES = 0
     SET @REDACAO_ID = NULL

		BEGIN TRANSACTION

			BEGIN TRY
				 select @QTD_CORRECOES = count(cor.id)
				   from correcoes_correcao cor
                        join correcoes_redacao red on cor.redacao_id = red.id
				  where cor.id_corretor = @AVALIADOR_ID and
				  	    cor.id_projeto  = @ID_PROJETO   and
				  	    cor.id_status = 3    and
				  	    red.id_redacaoouro is null

				 select @QTD_CORRECOES_MODA = count(cor.id)
				   from correcoes_correcao cor
                        join correcoes_redacao red on cor.redacao_id = red.id
				  where cor.id_corretor = @AVALIADOR_ID
				  	and cor.id_projeto  = @ID_PROJETO
				  	and cor.id_status = 3
				  	and cor.id_tipo_correcao = 6 --Moda
					and CAST(COR.DATA_TERMINO AS DATE) = CAST(dbo.getlocaldate() AS DATE)


                  /* CALCULO A QUANTIDADE DE MODA QUE O USUARIO PODE TER NO DIA COM BASE NA SUA COTA DE CORRECOES*/
                  SELECT @QTD_CORRECOES_MODA_DIA = DIA.CORRECOES/PRO.ouro_frequencia FROM VW_CORRECAO_DIA DIA WITH (NOLOCK) JOIN PROJETO_PROJETO PRO WITH (NOLOCK) ON (DIA.id_projeto = PRO.ID)
				  WHERE DIA.ID =  @AVALIADOR_ID AND
				        DIA.id_projeto = @ID_PROJETO

			   /* SE A QUANTIDADE DE OUROS CORRIGIDAS FOR MENOR QUE A COTA DO DIA TESTA SE ELA FOI SORTEADA */
                IF(@QTD_CORRECOES_MODA < @QTD_CORRECOES_MODA_DIA)
					BEGIN
						  select TOP 1 @CO_BARRA_REDACAO =  our.co_barra_redacao, @ID_FILAOURO = our.ID, @REDACAO_ID = redacao_id
							from correcoes_filaouro OUR join correcoes_redacao red on (our.co_barra_redacao = red.co_barra_redacao)
														join correcoes_redacaoouro rdo on (rdo.id = red.id_redacaoouro)
						   WHERE OUR.id_corretor = @AVALIADOR_ID AND
				  				 OUR.id_projeto  = @ID_PROJETO   AND
								  rdo.id_redacaotipo = 3 and
								 isnull(OUR.posicao,100000)    <= (@QTD_CORRECOES + 1)
								 ORDER BY POSICAO

                   END



               IF (@REDACAO_ID IS NULL)
					BEGIN
						SET @CORRECAO_ID = 0
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
									6,
									co_barra_redacao,
									id_corretor,
									ID_PROJETO,
                                    @REDACAO_ID
								FROM correcoes_filaOuro cor with (nolock)
								WHERE id = @ID_FILAOURO


						/****** RECUPERANDO O ID DA TABELA CORRECOES_CORRECAO   *****/
						select @CORRECAO_ID = SCOPE_IDENTITY()

						/****** FIM DANDO CARGA NA TABELA CORRECAO_REDACAO E RECUPERANDO O ID DA CORRECAO *********/
						/****** INSERIR NA LISTA PESSOAL   *****/
						INSERT INTO correcoes_filapessoal (corrigido_por, id_grupo_corretor, atual, id_tipo_correcao, id_corretor, id_correcao, co_barra_redacao, id_projeto, redacao_id)
								VALUES (DBO.FN_COR_CORRETOR_REDACAO(@CO_BARRA_REDACAO), @ID_GRUPO_CORRETOR, 1, 6, @AVALIADOR_ID, @CORRECAO_ID, @CO_BARRA_REDACAO, @ID_PROJETO, @REDACAO_ID)

						/******* DELETAR O REGISTRO NA FILA OURO   *****/
						DELETE FROM correcoes_filaOuro
						WHERE ID = @ID_FILAOURO


						/*SE FOR A PRIMEIRA OURO DO DIA REDISTRIBUO AS DEMAIS REDACOES OURO */
						IF(@QTD_CORRECOES_MODA = 0)
							BEGIN
								EXEC sp_distribuir_ordem_DIARIO @AVALIADOR_ID, @ID_PROJETO, 3
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
/****** Object:  StoredProcedure [dbo].[sp_busca_mais_um_na_filaModa_teste]    Script Date: 16/10/2019 10:22:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [dbo].[sp_busca_mais_um_na_filaModa_teste]
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
	 DECLARE @QTD_CORRECOES_MODA INT
	 DECLARE @QTD_CORRECOES_MODA_DIA INT
	 DECLARE @REDACAO_ID INT

	 DECLARE @ID_FILAOURO INT

	 SET NOCOUNT ON;

     SET @CORRECAO_ID = 0
     SET @QTD_CORRECOES = 0
     SET @REDACAO_ID = NULL

		BEGIN TRANSACTION

			BEGIN TRY
print 'passou 4.1.1.1: ' + convert(varchar(100), dbo.getlocaldate())
RAISERROR(N'', 0, 1) WITH NOWAIT
				 select @QTD_CORRECOES = count(cor.id)
				   from correcoes_correcao cor
                        join correcoes_redacao red on cor.redacao_id = red.id
				  where cor.id_corretor = @AVALIADOR_ID and
				  	    cor.id_projeto  = @ID_PROJETO   and
				  	    cor.id_status = 3    and
				  	    red.id_redacaoouro is null
print 'passou 4.1.1.2: ' + convert(varchar(100), dbo.getlocaldate())
RAISERROR(N'', 0, 1) WITH NOWAIT

				 select @QTD_CORRECOES_MODA = count(cor.id)
				   from correcoes_correcao cor
                        join correcoes_redacao red on cor.redacao_id = red.id
				  where cor.id_corretor = @AVALIADOR_ID
				  	and cor.id_projeto  = @ID_PROJETO
				  	and cor.id_status = 3
				  	and cor.id_tipo_correcao = 6 --Moda
					and CAST(COR.DATA_TERMINO AS DATE) = CAST(dbo.getlocaldate() AS DATE)

print 'passou 4.1.1.3: ' + convert(varchar(100), dbo.getlocaldate())
RAISERROR(N'', 0, 1) WITH NOWAIT

                  /* CALCULO A QUANTIDADE DE MODA QUE O USUARIO PODE TER NO DIA COM BASE NA SUA COTA DE CORRECOES*/
                  SELECT @QTD_CORRECOES_MODA_DIA = DIA.CORRECOES/PRO.ouro_frequencia FROM VW_CORRECAO_DIA DIA WITH (NOLOCK) JOIN PROJETO_PROJETO PRO WITH (NOLOCK) ON (DIA.id_projeto = PRO.ID)
				  WHERE DIA.ID =  @AVALIADOR_ID AND
				        DIA.id_projeto = @ID_PROJETO

print 'passou 4.1.1.4: ' + convert(varchar(100), dbo.getlocaldate())
RAISERROR(N'', 0, 1) WITH NOWAIT

			   /* SE A QUANTIDADE DE OUROS CORRIGIDAS FOR MENOR QUE A COTA DO DIA TESTA SE ELA FOI SORTEADA */
                IF(@QTD_CORRECOES_MODA < @QTD_CORRECOES_MODA_DIA)
					BEGIN
print 'passou 4.1.1.5: ' + convert(varchar(100), dbo.getlocaldate())
RAISERROR(N'', 0, 1) WITH NOWAIT
						  select TOP 1 @CO_BARRA_REDACAO =  our.co_barra_redacao, @ID_FILAOURO = our.ID, @REDACAO_ID = redacao_id
							from correcoes_filaouro OUR join correcoes_redacao red on (our.co_barra_redacao = red.co_barra_redacao)
														join correcoes_redacaoouro rdo on (rdo.id = red.id_redacaoouro)
						   WHERE OUR.id_corretor = @AVALIADOR_ID AND
				  				 OUR.id_projeto  = @ID_PROJETO   AND
								  rdo.id_redacaotipo = 3 and
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
									6,
									co_barra_redacao,
									id_corretor,
									ID_PROJETO,
                                    @REDACAO_ID
								FROM correcoes_filaOuro cor with (nolock)
								WHERE id = @ID_FILAOURO
print 'passou 4.1.1.9: ' + convert(varchar(100), dbo.getlocaldate())
RAISERROR(N'', 0, 1) WITH NOWAIT


						/****** RECUPERANDO O ID DA TABELA CORRECOES_CORRECAO   *****/
						select @CORRECAO_ID = SCOPE_IDENTITY()

						/****** FIM DANDO CARGA NA TABELA CORRECAO_REDACAO E RECUPERANDO O ID DA CORRECAO *********/
						/****** INSERIR NA LISTA PESSOAL   *****/
						INSERT INTO correcoes_filapessoal (corrigido_por, id_grupo_corretor, atual, id_tipo_correcao, id_corretor, id_correcao, co_barra_redacao, id_projeto, redacao_id)
								VALUES (DBO.FN_COR_CORRETOR_REDACAO(@CO_BARRA_REDACAO), @ID_GRUPO_CORRETOR, 1, 6, @AVALIADOR_ID, @CORRECAO_ID, @CO_BARRA_REDACAO, @ID_PROJETO, @REDACAO_ID)

						/******* DELETAR O REGISTRO NA FILA OURO   *****/
						DELETE FROM correcoes_filaOuro
						WHERE ID = @ID_FILAOURO


						/*SE FOR A PRIMEIRA OURO DO DIA REDISTRIBUO AS DEMAIS REDACOES OURO */
						IF(@QTD_CORRECOES_MODA = 0)
							BEGIN
								EXEC sp_distribuir_ordem_DIARIO @AVALIADOR_ID, @ID_PROJETO, 3
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
/****** Object:  StoredProcedure [dbo].[sp_busca_mais_um_na_filaOuro]    Script Date: 16/10/2019 10:22:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* FORMA NOVA DE BUSCAR MAIS UM NA FILA OURO */
CREATE  OR ALTER procedure [dbo].[sp_busca_mais_um_na_filaOuro]
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
     DECLARE @DATETIME DATETIME2

     SET @DATETIME = dbo.getlocaldate()


	 DECLARE @ID_FILAOURO INT

	 SET NOCOUNT ON;

     SET @CORRECAO_ID = 0
     SET @QTD_CORRECOES = 0
     SET @CO_BARRA_REDACAO = NULL
     SET @REDACAO_ID = NULL


		BEGIN TRANSACTION

			BEGIN TRY
				/* CONTO QUANTAS CORRECOES O AVALIADOR JA FEZ */
				 select @QTD_CORRECOES = count(cor.id)
				   from correcoes_correcao cor WITH (NOLOCK) join correcoes_redacao red WITH (NOLOCK) on cor.redacao_id = red.id
				  where cor.id_corretor = @AVALIADOR_ID and
				  	    cor.id_projeto  = @ID_PROJETO   and
				  	    cor.id_status = 3    and
				  	    red.id_redacaoouro is null
				/* CONTO QUANTAS CORRECOES OURO O AVALIADOR JA FEZ NO DIA */
                select @QTD_CORRECOES_OURO = count(cor.id)
				   from correcoes_correcao cor
                        join correcoes_redacao red on cor.redacao_id = red.id
				  	                              and cor.id_projeto  = @ID_PROJETO
				  	                              and cor.id_status = 3
				  	                              and cor.id_tipo_correcao = 5 --OURO
						                          and CAST(COR.DATA_TERMINO AS DATE) = convert(date, @DATETIME)


				  /* CALCULO A QUANTIDADE DE OURO QUE O USUARIO PODE TER NO DIA COM BASE NA SUA COTA DE CORRECOES*/
                  SELECT @QTD_CORRECOES_OURO_DIA = DIA.CORRECOES/PRO.ouro_frequencia
                    FROM VW_CORRECAO_DIA DIA WITH (NOLOCK)
                         JOIN PROJETO_PROJETO PRO WITH (NOLOCK) ON DIA.id_projeto = PRO.ID
				   WHERE DIA.ID =  @AVALIADOR_ID
				     AND DIA.id_projeto = @ID_PROJETO


                /* SE A QUANTIDADE DE OUROS CORRIGIDAS FOR MENOR QUE A COTA DO DIA TESTA SE ELA FOI SORTEADA */
                IF(@QTD_CORRECOES_OURO < @QTD_CORRECOES_OURO_DIA)
					BEGIN
						  select TOP 1 @CO_BARRA_REDACAO =  our.co_barra_redacao, @ID_FILAOURO = our.ID, @REDACAO_ID = red.id
							from correcoes_filaouro OUR
                                 join correcoes_redacao red on (our.redacao_id = red.id)
								 join correcoes_redacaoouro rdo on (rdo.id = red.id_redacaoouro)
						   WHERE OUR.id_corretor = @AVALIADOR_ID AND
				  				 OUR.id_projeto  = @ID_PROJETO   AND
								  rdo.id_redacaotipo = 2 and
								 isnull(OUR.posicao,100000)    <= (@QTD_CORRECOES + 1)
								 ORDER BY POSICAO

                   END

               IF (@REDACAO_ID IS NULL)
					BEGIN
						SET @CORRECAO_ID = 0
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
									5,
									co_barra_redacao,
									id_corretor,
									ID_PROJETO,@REDACAO_ID
								FROM correcoes_filaOuro cor with (nolock)
								WHERE cor.id = @ID_FILAOURO

						/****** RECUPERANDO O ID DA TABELA CORRECOES_CORRECAO   *****/
						select @CORRECAO_ID = SCOPE_IDENTITY()

						/****** FIM DANDO CARGA NA TABELA CORRECAO_REDACAO E RECUPERANDO O ID DA CORRECAO *********/
						/****** INSERIR NA LISTA PESSOAL   *****/
						INSERT INTO correcoes_filapessoal (corrigido_por, id_grupo_corretor, atual, id_tipo_correcao, id_corretor, id_correcao, co_barra_redacao, id_projeto, redacao_id)
								VALUES (DBO.FN_COR_CORRETOR_REDACAO(@CO_BARRA_REDACAO), @ID_GRUPO_CORRETOR, 1, 5, @AVALIADOR_ID, @CORRECAO_ID, @CO_BARRA_REDACAO, @ID_PROJETO, @REDACAO_ID)
						/******* DELETAR O REGISTRO NA FILA OURO   *****/
						DELETE FROM correcoes_filaOuro
						WHERE ID = @ID_FILAOURO

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

/****** Object:  StoredProcedure [dbo].[sp_busca_mais_um_teste]    Script Date: 16/10/2019 10:22:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER PROCEDURE [dbo].[sp_busca_mais_um_teste]
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
/****** Object:  StoredProcedure [dbo].[sp_carrega_ouro]    Script Date: 16/10/2019 10:22:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [dbo].[sp_carrega_ouro] 
	@ID_REDACAO INT,
    @ID_CORRETOR INT,
	@ID_PROJETO  INT 
as 

begin try
begin tran

	-- ***** colocar na tabela redacoes ouro as redacoes selecionadas

	insert into correcoes_redacaoouro (link_imagem_recortada, link_imagem_original,nota_final, id_correcao_situacao, 
	                                   co_barra_redacao,co_inscricao,co_formulario,id_prova, id_projeto, id_redacaotipo)
	select link_imagem_recortada, link_imagem_original,nota_final, null, 
	       co_barra_redacao, co_inscricao, co_formulario, id_prova, id_projeto,2 
	 from correcoes_redacao red 
	where not exists (select 1 from correcoes_redacaoouro our 
					   where our.co_barra_redacao = red.co_barra_redacao and 
					   	     our.id_projeto = red.id_projeto and 
					         our.id_redacaotipo = 2) and
	      id_redacaoouro is null and 
		  RED.id_projeto = @ID_PROJETO AND
	      red.id in (@id_redacao)
	order by co_barra_redacao

	DROP TABLE  #tmp_correcoes_redacao
	 -- **** inserir na tabela redacao as redacoes ouro para o candidato 
	 select link_imagem_recortada, link_imagem_original,nota_final, id_correcao_situacao, 
	        co_barra_redacao = '001' + right('000000' +convert(varchar(6),our.id),6) +
							           right('000000' +convert(varchar(6),@ID_CORRETOR),6),
	        co_inscricaon    = '001' + right('000000' +convert(varchar(6),our.id),6) +
							           right('000000' +convert(varchar(6),@ID_CORRETOR),6),
	        co_formulario,id_prova, id_projeto,id 
	  into #tmp_correcoes_redacao
	   from correcoes_redacaoouro OUR 
	     where data_criacao > '2018-12-03 23:00'
	  order by co_barra_redacao

	insert correcoes_redacao (link_imagem_recortada, link_imagem_original, nota_final, id_redacao_situacao,
		   co_barra_redacao, co_inscricao, co_formulario, id_prova, id_projeto, id_redacaoouro)
	select link_imagem_recortada, link_imagem_original, nota_final, 1, 
		   co_barra_redacao, co_inscricao, co_formulario, id_prova, id_projeto,id 
	  from #tmp_correcoes_redacao tmp
	 where not exists (select 1 from correcoes_redacao redx 
	                    where redx.co_barra_redacao = tmp.co_barra_redacao AND
						      REDX.id_projeto = TMP.id_projeto)

	-- **** inserir na tabela filaOURO
	insert correcoes_filaouro (co_barra_redacao, id_corretor, posicao, id_projeto)
	SELECT red.co_barra_redacao,
		   @ID_CORRETOR, null, red.id_projeto
	  FROM CORRECOES_REDACAOouro our join correcoes_redacao red on (red.id_redacaoouro = our.id)
	 where not exists (select * from correcoes_filaouro flox 
						where flox.co_barra_redacao = red.co_barra_redacao and 
							  flox.id_corretor      = @ID_CORRETOR AND 
							  FLOX.id_projeto       = @ID_PROJETO)
 
	--- INSERE NA CORRECOES GABARITO
	insert correcoes_gabarito (nota_final, id_correcao_situacao, id_competencia1, id_competencia2, id_competencia3, id_competencia4, id_competencia5,
		   nota_competencia1, nota_competencia2, nota_competencia3, nota_competencia4, nota_competencia5,
		   co_barra_redacao)
	select  our.nota_final, our.id_correcao_situacao, id_competencia1, id_competencia2, id_competencia3, id_competencia4, id_competencia5,
		   nota_competencia1, nota_competencia2, nota_competencia3, nota_competencia4, nota_competencia5,
		   red.co_barra_redacao
	 frOM CORRECOES_REDACAOouro our join correcoes_redacao red on (red.id_redacaoouro = our.id)
	 where not exists (select 1 from correcoes_gabarito gabx
	                    where gabx.co_barra_redacao = red.co_barra_redacao) and
		   our.id_projeto = 4
		   and data_criacao > '2018-12-03 23:00'

	 exec sp_distribuir_ordem @ID_CORRETOR, @ID_PROJETO, 2

	 commit
end try
begin catch
	print error_message()
	rollback
end catch


SELECT * FROM correcoes_REDACAOouro WHERE id_redacaotipo = 3
GO
/****** Object:  StoredProcedure [dbo].[sp_carrega_ouro2]    Script Date: 16/10/2019 10:22:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   OR ALTER procedure [dbo].[sp_carrega_ouro2] 
    @ID_CORRETOR INT,
	@ID_PROJETO  INT 
as 

begin try
--begin tran


	 -- **** inserir na tabela redacao as redacoes ouro para o candidato 
	 select link_imagem_recortada, link_imagem_original,nota_final, id_correcao_situacao, 
	        co_barra_redacao = '001' + right('000000' +convert(varchar(6),our.id),6) +
							           right('000000' +convert(varchar(6),@ID_CORRETOR),6),
	        co_inscricao    = '001' + right('000000' +convert(varchar(6),our.id),6) +
							           right('000000' +convert(varchar(6),@ID_CORRETOR),6),
	        co_formulario,id_prova, id_projeto,id 
	   into #tmp_correcoes_redacao
	   from correcoes_redacaoouro OUR 
	  order by co_barra_redacao

	insert correcoes_redacao (link_imagem_recortada, link_imagem_original, nota_final, id_redacao_situacao,
		   co_barra_redacao, co_inscricao, co_formulario, id_prova, id_projeto, id_redacaoouro)
	select link_imagem_recortada, link_imagem_original, nota_final, 1, 
		   co_barra_redacao, co_inscricao, co_formulario, id_prova, id_projeto,id 
	  from #tmp_correcoes_redacao tmp
	 where not exists (select 1 from correcoes_redacao redx 
	                    where redx.co_barra_redacao = tmp.co_barra_redacao AND
						      REDX.id_projeto = TMP.id_projeto)

	-- **** inserir na tabela filaOURO
	insert correcoes_filaouro (co_barra_redacao, id_corretor, posicao, id_projeto)
	SELECT co_barra_redacao,
		   @ID_CORRETOR, null, id_projeto
	  FROM #tmp_correcoes_redacao

 
	--- INSERE NA CORRECOES GABARITO
	insert correcoes_gabarito (nota_final, id_correcao_situacao, id_competencia1, id_competencia2, id_competencia3, id_competencia4, id_competencia5,
		   nota_competencia1, nota_competencia2, nota_competencia3, nota_competencia4, nota_competencia5,
		   co_barra_redacao)
	select our.nota_final, our.id_correcao_situacao, our.id_competencia1, our.id_competencia2, our.id_competencia3, our.id_competencia4, our.id_competencia5,
		   our.nota_competencia1, our.nota_competencia2, our.nota_competencia3, our.nota_competencia4, our.nota_competencia5,
		   red.co_barra_redacao
	 frOM CORRECOES_REDACAOouro our join correcoes_redacao red on (red.id_redacaoouro = our.id)
	 where not exists (select 1 from correcoes_gabarito gabx
	                    where gabx.co_barra_redacao = red.co_barra_redacao) and
		   our.id_projeto = @ID_PROJETO
		   

	 exec sp_distribuir_ordem @ID_CORRETOR, @ID_PROJETO, 2

	 --commit
end try
begin catch
	print error_message()
	rollback
end catch
GO
/****** Object:  StoredProcedure [dbo].[sp_carregar_correcoes_corretor_indicadores]    Script Date: 16/10/2019 10:22:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [dbo].[sp_carregar_correcoes_corretor_indicadores] as 
DECLARE @DATA DATE
DECLARE @DATA_ANTERIOR DATE
DECLARE @ID_PROJETO INT

SET @DATA = CAST(GETDATE() AS DATE)

declare abc cursor for 
	select id from projeto_projeto
     where cast(getdate() as date) between cast(data_inicio as date) and cast(data_termino as date)

	open abc 
		fetch next from abc into @ID_PROJETO
		while @@FETCH_STATUS = 0
			BEGIN
				--IF (NOT EXISTS(SELECT * FROM CORRECOES_CORRETOR_INDICADORES WHERE DATA_CALCULO = @DATA))
				--	BEGIN
				--		SET @DATA_ANTERIOR = DATEADD(DAY,-1,@DATA)
				--		EXEC SP_CORRECOES_CORRETOR_INDICADORES @DATA_ANTERIOR, @ID_PROJETO
				--	END
	            SET @DATA_ANTERIOR = DATEADD(DAY,-1,@DATA)
				EXEC SP_CORRECOES_CORRETOR_INDICADORES @DATA_ANTERIOR, @ID_PROJETO

			fetch next from abc into @ID_PROJETO
			END
	close abc 
deallocate abc
GO
/****** Object:  StoredProcedure [dbo].[SP_COMPARAR_TABELAS]    Script Date: 16/10/2019 10:22:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/**********************************************************************************************************************************
*                                                     [SP_COMPARAR_TABELAS]                                                       *
*                                                                                                                                 *
*  PROCEDURE QUE RECEBE O NOME DE DUAS TABELAS E SE ELAS POSSUIREM A MESMA ESTRUTURA SERA COMPARADO CAMPO A CAMPO SE OS DADOS EST *
* AO IGUAIS)                                                                                                                      *
*                                                                                                                                 *
* BANCO_SISTEMA : ENEM                                                                                                            *
* CRIADO POR    : WEMERSON BITTORI MADURO                                                                         DATA:10/10/2019 *
* ALTERADO POR  : WEMERSON BITTORI MADURO                                                                         DATA:10/10/2019 *
**********************************************************************************************************************************/

CREATE OR ALTER PROCEDURE [dbo].[SP_COMPARAR_TABELAS]  
   @TAB1 VARCHAR(100), @TAB2 VARCHAR(100) AS

DECLARE @SQL NVARCHAR(1000)


SET @SQL = 
N'SELECT *, TABELA = ' + CHAR(39) + @TAB1 + CHAR(39) + ' FROM (
SELECT *  FROM ' + @TAB1 + ' 
EXCEPT 
SELECT *  FROM ' + @TAB2 + '
) AS TAB
UNION 
SELECT *, TABELA = ' + CHAR(39) + @TAB2 + CHAR(39) + ' FROM (
SELECT *  FROM ' + @TAB2 + '
EXCEPT 
SELECT *  FROM ' + @TAB1 + '
 ) AS TAB1  ORDER BY 1'

 PRINT @SQL 

 EXEC SP_EXECUTESQL @SQL



GO
/****** Object:  StoredProcedure [dbo].[SP_COMPARAR_TABELAS_CAMPO_A_CAMPO]    Script Date: 16/10/2019 10:22:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/**********************************************************************************************************************************
*                                                     [SP_COMPARAR_TABELAS]                                                       *
*                                                                                                                                 *
*  PROCEDURE QUE RECEBE O NOME DE DUAS TABELAS E SE ELAS POSSUIREM A MESMA ESTRUTURA SERA COMPARADO CAMPO A CAMPO SE OS DADOS EST *
* AO IGUAIS)                                                                                                                      *
*                                                                                                                                 *
* BANCO_SISTEMA : ENEM                                                                                                            *
* CRIADO POR    : WEMERSON BITTORI MADURO                                                                         DATA:10/10/2019 *
* ALTERADO POR  : WEMERSON BITTORI MADURO                                                                         DATA:10/10/2019 *
**********************************************************************************************************************************/
-- EXEC SP_COMPARAR_TABELAS_CAMPO_A_CAMPO usuarios_hierarquia, #TMP
---SELECT * INTO #TMP FROM usuarios_hierarquia

CREATE OR ALTER PROCEDURE [dbo].[SP_COMPARAR_TABELAS_CAMPO_A_CAMPO]  
   @TAB1 VARCHAR(100), @TAB2 VARCHAR(100) AS

DECLARE @SQL NVARCHAR(4000),@CAMPOS_SQL NVARCHAR(4000), @CAMPO VARCHAR(500), @SQL1 VARCHAR(500), @SQL2 VARCHAR(500)

SET @SQL1 = N'SELECT DISTINCT TAB1.*, TABELA = ' + CHAR(39)  + @TAB1 + CHAR(39) + ' FROM ' + @TAB1 + ' AS TAB1 WITH(NOLOCK) LEFT  JOIN ' + @TAB2 + ' AS TAB2 ON ( ' 
SET @SQL2 = N'SELECT DISTINCT TAB2.*, TABELA = ' + CHAR(39)  + @TAB2 + CHAR(39) + ' FROM ' + @TAB1 + ' AS TAB1 WITH(NOLOCK) RIGHT JOIN ' + @TAB2 + ' AS TAB2 ON ( ' 
SET @CAMPOS_SQL = N''
declare abc cursor for 
	SELECT CAMPO = ' isnull(convert(varchar(1000),tab1.'+ COLUMN_NAME + '), ' + CHAR(39) + '-9*X|' + CHAR(39) + ') =' +
	               ' isnull(convert(varchar(1000),tab2.'+ COLUMN_NAME + '), ' + CHAR(39) + '-9*X|' + CHAR(39) + ') and'
      FROM INFORMATION_SCHEMA.COLUMNS
     where TABLE_NAME = @TAB1

	open abc 
		fetch next from abc into @CAMPO
		while @@FETCH_STATUS = 0
			BEGIN
				SET @CAMPOS_SQL = @CAMPOS_SQL + @CAMPO
			fetch next from abc into @CAMPO
			END
	close abc 
deallocate abc 
SET @CAMPOS_SQL = @CAMPOS_SQL + ')'
SET @CAMPOS_SQL = REPLACE(@CAMPOS_SQL, 'AND)',')')


SET @SQL = N'' + @SQL1 + @CAMPOS_SQL + '   ' + @SQL2 + @CAMPOS_SQL  


 EXEC SP_EXECUTESQL @SQL
GO
/****** Object:  StoredProcedure [dbo].[sp_consome_analise_discrepancia]    Script Date: 16/10/2019 10:22:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE OR ALTER PROCEDURE [dbo].[sp_consome_analise_discrepancia] 
as
declare @CODBARRA varchar(100)
declare @ID_ANALISE int
declare @fila int

declare cur_con_ana_dis cursor for 
	select co_barra_redacao,id, id_tipo_correcao_B + 1
	  from correcoes_analise  with (nolock)
     where conclusao_analise > 2 and 
      fila = 0
	open cur_con_ana_dis 
		fetch next from cur_con_ana_dis into @CODBARRA, @ID_ANALISE, @FILA
		while @@FETCH_STATUS = 0
			BEGIN
				EXEC SP_INSERE_DISCREPANCIA_NA_FILA @CODBARRA, @ID_ANALISE, 3


			fetch next from cur_con_ana_dis into  @CODBARRA, @ID_ANALISE, @FILA
			END
	close cur_con_ana_dis 
deallocate cur_con_ana_dis
GO
/****** Object:  StoredProcedure [dbo].[sp_consome_pendencia_analise]    Script Date: 16/10/2019 10:22:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   OR ALTER PROCEDURE [dbo].[sp_consome_pendencia_analise] as
DECLARE @ID               INT
DECLARE @ID_CORRECAO      INT
DECLARE @ID_TIPO_CORRECAO INT
DECLARE @ID_PROJETO       INT
DECLARE @ERRO             VARCHAR(500)
DECLARE @RETORNO          VARCHAR(500)
DECLARE @RETORNO_AUX      VARCHAR(500)
DECLARE @CO_BARRA_REDACAO VARCHAR(50)

/****** INICIO DO CURSOR ******/
declare CRS_ANALISE cursor for
	SELECT id, id_correcao, id_tipo_correcao, id_projeto FROM CORRECOES_PENDENTEANALISE PEN with (nolock)
	 WHERE NOT EXISTS (SELECT 1
	 					FROM CORRECOES_PENDENTEANALISE PENX with (nolock)
	 				   WHERE PENX.ERRO IS NOT NULL AND
	 						 PENX.CO_BARRA_REDACAO = PEN.CO_BARRA_REDACAO)
	  ORDER BY ID

	open CRS_ANALISE
		fetch next from CRS_ANALISE into @id, @ID_CORRECAO, @ID_TIPO_CORRECAO, @ID_PROJETO
		while @@FETCH_STATUS = 0
			BEGIN

				/****************************************************************************************/
				/* CONFORME O TIPO DE CORRECAO E DIRECIONADO PARA UMA COMPARACAO                        */
				/* GRAVACAO 1-(COMPARACAO 1,2) 2-(COMPARACAO 1,3) 3-(COMPARACAO 2-3) 4-(COMPARACAO 3-4) */
				/* GRAVACAO 5-(COMPARACAO 5,gabarito)                                                   */
				/* CASO TIPO GRAVACAO SEJA 1 OU 2 SERA EXECUTADO APENAS A GRVACAO 1                     */
				/* CASO TIPO GRAVACAO SEJA 3 SERA EXECUTADO A GRVACAO 2 E A 3                           */
				/* CASO TIPO GRAVACAO SEJA 4 SERA EXECUTADO A GRVACAO 3 E A 4                           */
				/* CASO TIPO GRAVACAO SEJA 5 SERA EXECUTADO A GRVACAO 5 E A GABARITO                    */
				/* PARA DEMAIS TIPOS AINDA TEMOS QUE TRATAR FUTURAMENTE                                 */
				/****************************************************************************************/
				IF(@ID_TIPO_CORRECAO IN (1,2))
					BEGIN
						EXEC  sp_inserir_analise @ID_CORRECAO,1, @ID_PROJETO, @retorno output
						/*****************************************************************/
						/* SE O RETORNO FOR POSITIVO E DELETADO DA FILA DE PENDENTES     */
						/* CASO CONTRARIO E GRAVADO A MENSAGEM DE ERRO QUE FOI RETORNADA */
						/*****************************************************************/
						IF(@RETORNO in('OK','JÁ EXISTE','NAO EXISTE'))
							BEGIN
								DELETE FROM CORRECOES_PENDENTEANALISE WHERE ID = @ID
							END
						ELSE
							BEGIN
								UPDATE CORRECOES_PENDENTEANALISE SET ERRO = @RETORNO WHERE ID = @ID
							END
					END
				ELSE IF(@ID_TIPO_CORRECAO =3 )
					BEGIN
						BEGIN TRY
							BEGIN TRANSACTION

							EXEC  sp_inserir_analise @ID_CORRECAO,2, @ID_PROJETO, @retorno output
							IF(@RETORNO in('OK','JÁ EXISTE','NAO EXISTE'))
								BEGIN
									DELETE FROM CORRECOES_PENDENTEANALISE WHERE ID = @ID
								END
							ELSE
								BEGIN
									UPDATE CORRECOES_PENDENTEANALISE SET ERRO = @RETORNO WHERE ID = @ID
								END

							EXEC  sp_inserir_analise @ID_CORRECAO,3, @ID_PROJETO, @RETORNO_AUX output
							IF(@RETORNO in('OK','JÁ EXISTE','NAO EXISTE'))
								BEGIN
									DELETE FROM CORRECOES_PENDENTEANALISE WHERE ID = @ID
								END
							ELSE
								BEGIN
									UPDATE CORRECOES_PENDENTEANALISE SET ERRO = @RETORNO + ' **** ' + @RETORNO_AUX
									 WHERE ID = @ID
								END
							COMMIT
						END TRY
						BEGIN CATCH
							ROLLBACK
						END CATCH
					END
				ELSE IF(@ID_TIPO_CORRECAO =4 )
					BEGIN
						BEGIN TRY
							BEGIN TRANSACTION

							EXEC  sp_inserir_analise @ID_CORRECAO,4, @ID_PROJETO, @RETORNO_AUX output
							IF(@RETORNO_AUX in('OK','JÁ EXISTE','NAO EXISTE'))
								BEGIN
									DELETE FROM CORRECOES_PENDENTEANALISE WHERE ID = @ID
								END
							ELSE
								BEGIN
									UPDATE CORRECOES_PENDENTEANALISE SET ERRO = @RETORNO_AUX + ' **** ' + @RETORNO_AUX
									 WHERE ID = @ID
								END
							COMMIT
						END TRY
						BEGIN CATCH
							ROLLBACK
						END CATCH
					END
				-- OURO
				ELSE IF(@ID_TIPO_CORRECAO = 5)
					BEGIN
						BEGIN TRY
							BEGIN TRANSACTION

							EXEC  sp_inserir_analise_gabarito @ID_CORRECAO, @ID_PROJETO, @RETORNO_AUX output
							IF(@RETORNO_AUX in('OK','JÁ EXISTE','NAO EXISTE'))
								BEGIN
									DELETE FROM CORRECOES_PENDENTEANALISE WHERE ID = @ID
								END
							ELSE
								BEGIN
									UPDATE CORRECOES_PENDENTEANALISE SET ERRO = @RETORNO_AUX + ' **** ' + @RETORNO_AUX
									 WHERE ID = @ID
								END
							COMMIT
						END TRY
						BEGIN CATCH
							ROLLBACK
						END CATCH
					END
                -- MODA
				ELSE IF(@ID_TIPO_CORRECAO = 6)
					BEGIN
						BEGIN TRY
							BEGIN TRANSACTION

							EXEC  sp_inserir_analise_gabarito @ID_CORRECAO, @ID_PROJETO, @RETORNO_AUX output
							IF(@RETORNO_AUX in('OK','JÁ EXISTE','NAO EXISTE'))
								BEGIN
									DELETE FROM CORRECOES_PENDENTEANALISE WHERE ID = @ID
								END
							ELSE
								BEGIN
									UPDATE CORRECOES_PENDENTEANALISE SET ERRO = @RETORNO_AUX + ' **** ' + @RETORNO_AUX
									 WHERE ID = @ID
								END
							COMMIT
						END TRY
						BEGIN CATCH
							ROLLBACK
						END CATCH
					END
                --- AUDITORIA
				ELSE IF(@ID_TIPO_CORRECAO = 7)
					BEGIN
--						BEGIN TRY
--							BEGIN TRAN TIPO7

							EXEC  sp_inserir_analise_auditoria @ID_CORRECAO, @ID_PROJETO, @RETORNO_AUX output
							IF(@RETORNO_AUX in('OK','JÁ EXISTE','NAO EXISTE'))
								BEGIN
									DELETE FROM CORRECOES_PENDENTEANALISE WHERE ID = @ID
								END
							ELSE
								BEGIN

									UPDATE CORRECOES_PENDENTEANALISE SET ERRO = @RETORNO_AUX + ' **** ' + @RETORNO_AUX
									 WHERE ID = @ID
								END
							COMMIT TRAN TIPO7
--						END TRY
--						BEGIN CATCH
--							ROLLBACK TRAN TIPO7
--						END CATCH
					END

			fetch next from CRS_ANALISE into @ID, @ID_CORRECAO, @ID_TIPO_CORRECAO, @ID_PROJETO
			END
	close CRS_ANALISE
deallocate CRS_ANALISE

GO
/****** Object:  StoredProcedure [dbo].[sp_consome_pendencia_analise_gabarito]    Script Date: 16/10/2019 10:22:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  OR ALTER PROCEDURE [dbo].[sp_consome_pendencia_analise_gabarito] as

DECLARE @ID               INT
DECLARE @ID_CORRECAO      INT
DECLARE @ID_TIPO_CORRECAO INT
DECLARE @ID_PROJETO       INT
DECLARE @ERRO             VARCHAR(500)
DECLARE @RETORNO          VARCHAR(500)
DECLARE @CO_BARRA_REDACAO VARCHAR(50)

/****** INICIO DO CURSOR ******/
declare CRS_ANALISE cursor for
	SELECT id, erro, id_correcao, co_barra_redacao,id_tipo_correcao, id_projeto
	  FROM CORRECOES_PENDENTEANALISE PEN
	 WHERE NOT EXISTS (SELECT 1
	 					FROM CORRECOES_PENDENTEANALISE PENX
	 				   WHERE PENX.ERRO IS NOT NULL AND
	 						 PENX.CO_BARRA_REDACAO = PEN.CO_BARRA_REDACAO)
	  ORDER BY ID

	open CRS_ANALISE
		fetch next from CRS_ANALISE into @ID, @ERRO, @ID_CORRECAO, @CO_BARRA_REDACAO,  @ID_TIPO_CORRECAO, @ID_PROJETO
		while @@FETCH_STATUS = 0
			BEGIN
				IF(@ID_TIPO_CORRECAO IN (1,2))
					BEGIN
						EXEC  sp_inserir_analise_gabarito @ID_CORRECAO, @ID_PROJETO, @retorno output
						/*****************************************************************/
						/* SE O RETORNO FOR POSITIVO E DELETADO DA FILA DE PENDENTES     */
						/* CASO CONTRARIO E GRAVADO A MENSAGEM DE ERRO QUE FOI RETORNADA */
						/*****************************************************************/
						IF(@RETORNO in('OK','JÁ EXISTE'))
							BEGIN
								DELETE FROM CORRECOES_PENDENTEANALISE WHERE ID = @ID
							END
						ELSE
							BEGIN
								UPDATE CORRECOES_PENDENTEANALISE SET ERRO = @RETORNO WHERE ID = @ID
							END
					END


			fetch next from CRS_ANALISE into @ID, @ERRO, @ID_CORRECAO, @CO_BARRA_REDACAO, @ID_TIPO_CORRECAO, @ID_PROJETO
			END
	close CRS_ANALISE
deallocate CRS_ANALISE

GO
/****** Object:  StoredProcedure [dbo].[sp_consome_pendencia_analise_gabarito_preteste]    Script Date: 16/10/2019 10:22:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   OR ALTER PROCEDURE [dbo].[sp_consome_pendencia_analise_gabarito_preteste] as

DECLARE @ID               INT
DECLARE @ID_CORRECAO      INT
DECLARE @ID_TIPO_CORRECAO INT
DECLARE @ID_PROJETO       INT
DECLARE @ERRO             VARCHAR(500)
DECLARE @RETORNO          VARCHAR(500)
DECLARE @CO_BARRA_REDACAO VARCHAR(50)
DECLARE @REDACAO_ID       INT

/****** INICIO DO CURSOR ******/
declare CRS_ANALISE cursor for
    SELECT id, erro, id_correcao, co_barra_redacao,id_tipo_correcao, id_projeto, redacao_id
      FROM CORRECOES_PENDENTEANALISE PEN
     WHERE NOT EXISTS (SELECT 1
                        FROM CORRECOES_PENDENTEANALISE PENX
                       WHERE PENX.ERRO IS NOT NULL AND
                             PENX.REDACAO_ID = PEN.REDACAO_ID)
      ORDER BY ID

    open CRS_ANALISE
        fetch next from CRS_ANALISE into @ID, @ERRO, @ID_CORRECAO, @CO_BARRA_REDACAO,  @ID_TIPO_CORRECAO, @ID_PROJETO, @REDACAO_ID
        while @@FETCH_STATUS = 0
            BEGIN
                IF(@ID_TIPO_CORRECAO IN (1,2))
                    BEGIN
                        EXEC  sp_inserir_analise_gabarito_preteste @ID_CORRECAO, @ID_PROJETO, @retorno output
                        /*****************************************************************/
                        /* SE O RETORNO FOR POSITIVO E DELETADO DA FILA DE PENDENTES     */
                        /* CASO CONTRARIO E GRAVADO A MENSAGEM DE ERRO QUE FOI RETORNADA */
                        /*****************************************************************/
                        IF(@RETORNO in('OK','JÁ EXISTE'))
                            BEGIN
                                DELETE FROM CORRECOES_PENDENTEANALISE WHERE ID = @ID
                            END
                        ELSE
                            BEGIN
                                UPDATE CORRECOES_PENDENTEANALISE SET ERRO = @RETORNO WHERE ID = @ID
                            END
                    END


            fetch next from CRS_ANALISE into @ID, @ERRO, @ID_CORRECAO, @CO_BARRA_REDACAO, @ID_TIPO_CORRECAO, @ID_PROJETO, @REDACAO_ID
            END
    close CRS_ANALISE
deallocate CRS_ANALISE


GO
/****** Object:  StoredProcedure [dbo].[sp_consome_pendencia_analise_gabarito_preteste_enem]    Script Date: 16/10/2019 10:22:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   OR ALTER PROCEDURE [dbo].[sp_consome_pendencia_analise_gabarito_preteste_enem] as

DECLARE @ID               INT
DECLARE @ID_CORRECAO      INT
DECLARE @ID_TIPO_CORRECAO INT
DECLARE @ID_PROJETO       INT
DECLARE @ERRO             VARCHAR(500)
DECLARE @RETORNO          VARCHAR(500)
DECLARE @CO_BARRA_REDACAO VARCHAR(50)
DECLARE @REDACAO_ID       INT

/****** INICIO DO CURSOR ******/
declare CRS_ANALISE cursor for
    SELECT id, erro, id_correcao, co_barra_redacao,id_tipo_correcao, id_projeto, redacao_id
      FROM CORRECOES_PENDENTEANALISE PEN
     WHERE NOT EXISTS (SELECT 1
                        FROM CORRECOES_PENDENTEANALISE PENX
                       WHERE PENX.ERRO IS NOT NULL AND
                             PENX.REDACAO_ID = PEN.REDACAO_ID)
      ORDER BY ID

    open CRS_ANALISE
        fetch next from CRS_ANALISE into @ID, @ERRO, @ID_CORRECAO, @CO_BARRA_REDACAO,  @ID_TIPO_CORRECAO, @ID_PROJETO, @REDACAO_ID
        while @@FETCH_STATUS = 0
            BEGIN
                IF(@ID_TIPO_CORRECAO IN (5, 6))
                    BEGIN
                        EXEC  sp_inserir_analise_gabarito_preteste_enem @ID_CORRECAO, @ID_PROJETO, @retorno output
                        /*****************************************************************/
                        /* SE O RETORNO FOR POSITIVO E DELETADO DA FILA DE PENDENTES     */
                        /* CASO CONTRARIO E GRAVADO A MENSAGEM DE ERRO QUE FOI RETORNADA */
                        /*****************************************************************/
                        IF(@RETORNO in('OK','JÁ EXISTE'))
                            BEGIN
                                DELETE FROM CORRECOES_PENDENTEANALISE WHERE ID = @ID
                            END
                        ELSE
                            BEGIN
                                UPDATE CORRECOES_PENDENTEANALISE SET ERRO = @RETORNO WHERE ID = @ID
                            END
                    END


            fetch next from CRS_ANALISE into @ID, @ERRO, @ID_CORRECAO, @CO_BARRA_REDACAO, @ID_TIPO_CORRECAO, @ID_PROJETO, @REDACAO_ID
            END
    close CRS_ANALISE
deallocate CRS_ANALISE

GO
/****** Object:  StoredProcedure [dbo].[sp_correcoes_corretor_indicadores]    Script Date: 16/10/2019 10:22:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  OR ALTER  PROCEDURE [dbo].[sp_correcoes_corretor_indicadores] 
    @DATA_CARGA date,
    @ID_PROJETO INT AS

    DECLARE @DATA_INICIO DATE
    SET @DATA_INICIO = (select cast(data_inicio as date) from projeto_projeto WITH (NOLOCK) where id = @id_projeto)

     INSERT correcoes_corretor_indicadores 
            (USUARIO_ID, NOME, ID_HIERARQUIA, ID_USUARIO_RESPONSAVEL, PROJETO_ID, INDICE, TEMPO_CORRECAO,
             OUROS_CORRIGIDAS, MODAS_CORRIGIDAS, DISCREPANCIAS_OURO, APROVEITAMENTOS_COM_DISC, APROVEITAMENTOS_SEM_DISC,
             TOTAL_CORRECOES, DESEMPENHO_OURO, DESEMPENHO_MODA, DSP, TEMPO_MEDIO_CORRECAO, TAXA_DISCREPANCIA_OURO, TAXA_APROVEITAMENTO,
             TAXA_APROVEITAMENTO_COLETIVO, FLG_DADO_ATUAL, DATA_CALCULO)


select distinct usuario_id, nome =ISNULL(nome,''), id_hierarquia, id_usuario_responsavel, projeto_id, indice,
       TEMPO_CORRECAO               = sum(TEMPO_CORRECAO),
       OUROS_CORRIGIDAS             = sum(OUROS_CORRIGIDAS), 
       MODAS_CORRIGIDAS             = sum(MODAS_CORRIGIDAS), 
       DISCREPANCIAS_OURO           = sum(DISCREPANCIAS_OURO),
       APROVEITAMENTOS_COM_DISC     = sum(APROVEITAMENTOS_COM_DISC),
       APROVEITAMENTOS_SEM_DISC     = sum(APROVEITAMENTOS_SEM_DISC),
       TOTAL_CORRECOES              = sum(TOTAL_CORRECOES),   
       DESEMPENHO_OURO              = max(DESEMPENHO_OURO),  
       DESEMPENHO_MODA              = max(DESEMPENHO_MODA), 
       DSP                          = 0.0,
       TEMPO_MEDIO_CORRECAO         = 0.0,
       TAXA_DISCREPANCIA_OURO       = 0.0,
       TAXA_APROVEITAMENTO          = 0.0,
       TAXA_APROVEITAMENTO_COLETIVO = 0.0,
       FLG_DADO_ATUAL               = 0,
       DATA_CALCULO =  @DATA_CARGA 
  from (
select distinct vw.usuario_id, vw.nome, vw.id_hierarquia, vw.id_usuario_responsavel, vw.projeto_id, vw.indice, 
       TEMPO_CORRECAO = isnull((select sum(isnull(tempo_em_correcao,0)) 
                                  from correcoes_correcao corx WITH (NOLOCK) join correcoes_analise anax WITH (NOLOCK) on (corx.id = anax.id_correcao_a and 
                                                                                                                           corx.id_projeto = anax.id_projeto)
                                  where corx.id_corretor = vw.usuario_id                  and 
                                        corx.id_status   = 3                              and 
                                        @DATA_CARGA      = cast(corx.data_termino as date)),0), 
       OUROS_CORRIGIDAS         = sum(case when ANA.id_tipo_correcao_a = 5 then 1 else 0 end),
       MODAS_CORRIGIDAS         = sum(case when ANA.id_tipo_correcao_a = 6 then 1 else 0 end),
       DISCREPANCIAS_OURO       = sum(case when (ana.id_tipo_correcao_a    = 5 and ana.conclusao_analise  > 2) then 1 else 0 end),
       APROVEITAMENTOS_COM_DISC = sum(case when (ana.id_tipo_correcao_B IN(3,4)and ana.conclusao_analise  > 2) then 1 else 0 end),
       APROVEITAMENTOS_SEM_DISC = sum(case when (ana.id_tipo_correcao_A    = 1 AND ana.conclusao_analise  < 3) then 1 else 0 end),
       TOTAL_CORRECOES          = sum(case when (ana.id_tipo_correcao_A    = 1 AND ana.id_tipo_correcao_B = 2) then 1 else 0 end), 
       DESEMPENHO_OURO          = (select avg(anax.nota_desempenho) from correcoes_analise anax WITH (NOLOCK)
                                    where anax.id_corretor_A = ana.id_corretor_A and anax.id_tipo_correcao_a = 5 and 
                                          @DATA_CARGA = cast(anax.data_termino_A as date)), 
       DESEMPENHO_MODA          = (select avg(anax.nota_desempenho) from correcoes_analise anax WITH (NOLOCK)
                                    where anax.id_corretor_A = ana.id_corretor_A and anax.id_tipo_correcao_a = 6 and 
                                          @DATA_CARGA = cast(anax.data_termino_A as date)) 

  from  vw_usuario_hierarquia vw WITH (NOLOCK) left join correcoes_analise ana WITH (NOLOCK) on (vw.usuario_id = ana.id_corretor_A and 
                                                                vw.projeto_id = ana.id_projeto         and 
                                                                cast(ana.data_termino_A as date) = @DATA_CARGA) 
        where VW.PROJETO_ID = @ID_PROJETO  --AND VW.USUARIO_ID = 5312
group by vw.usuario_id, vw.nome, vw.id_hierarquia, vw.id_usuario_responsavel, vw.projeto_id, vw.indice,ana.id_corretor_A


union all 
select distinct vw.usuario_id, vw.nome, vw.id_hierarquia, vw.id_usuario_responsavel, vw.projeto_id, vw.indice, 
       TEMPO_CORRECAO = isnull((select sum(isnull(tempo_em_correcao,0)) 
                          from correcoes_correcao corx WITH (NOLOCK) join correcoes_analise anax WITH (NOLOCK) on (corx.id = anax.id_correcao_b and 
                                                                                                                   corx.id_projeto = anax.id_projeto)
                      where corx.id_corretor                = vw.usuario_id and 
                            corx.id_status                  = 3             and 
                            cast(corx.data_termino as date) = @DATA_CARGA) ,0), 
       OUROS_CORRIGIDAS         = 0,
       MODAS_CORRIGIDAS         = 0,
       DISCREPANCIAS_OURO       = 0,
       APROVEITAMENTOS_COM_DISC = 0,
       APROVEITAMENTOS_SEM_DISC = sum(case when (ana.id_tipo_correcao_b = 2 AND ana.conclusao_analise  < 3) then 1 else 0 end),
       TOTAL_CORRECOES          = sum(case when (ana.id_tipo_correcao_A = 1 AND ana.id_tipo_correcao_B = 2) then 1 else 0 end), 
       DESEMPENHO_OURO          = 0.0, 
       DESEMPENHO_MODA          = 0.0
  from vw_usuario_hierarquia vw WITH (NOLOCK) join correcoes_analise ana WITH (NOLOCK) on (vw.usuario_id = ana.id_corretor_b      and 
                                                                                           vw.projeto_id = ana.id_projeto         and 
                                                                                           cast(ana.data_termino_b as date) = @DATA_CARGA) 
       where VW.PROJETO_ID = @ID_PROJETO 
group by vw.usuario_id, vw.nome, vw.id_hierarquia, vw.id_usuario_responsavel, vw.projeto_id, vw.indice) as tab
group by usuario_id, nome, id_hierarquia, id_usuario_responsavel, projeto_id, indice
--**********************************************************************************************************************

UPDATE CCI SET 
       CCI.DSP =  CASE WHEN ouros_corrigidas = 0 AND modas_corrigidas = 0 THEN ISNULL((SELECT ci.DSP FROM correcoes_corretor_indicadores CI
                                                                                 WHERE CI.usuario_id = CCI.usuario_id
                                                                                   AND CI.projeto_id = CCI.projeto_id
                                                                                   AND DATA_CALCULO =
                                                                    /*DATA DO ANTERIOR VALIDO*/ (SELECT MAX(DATA_CALCULO) 
                                                                                                    FROM correcoes_corretor_indicadores CCIXX WITH (NOLOCK) 
                                                                                                    WHERE CCIXX.usuario_id = CI.USUARIO_ID AND 
                                                                                                        CCIXX.projeto_id = CI.PROJETO_ID AND 
                                                                                                        CCIXX.FLG_DADO_ATUAL = 1          AND 
                                                                                                        CCIXX.DSP IS NOT NULL  AND 
                                                                                                        CCIXX.DATA_CALCULO < @DATA_CARGA)), 0)
                     ELSE ISNULL(CAST(ROUND((CASE WHEN @DATA_CARGA < DATEADD(DAY, 3, @DATA_INICIO) THEN CCI.DESEMPENHO_OURO
                                         WHEN (CCI.OUROS_CORRIGIDAS = 0 OR CCI.MODAS_CORRIGIDAS = 0 ) THEN (CASE WHEN CCI.OUROS_CORRIGIDAS <> 0  THEN CCI.DESEMPENHO_OURO
                                                                                                                 WHEN CCI.MODAS_CORRIGIDAS <> 0  THEN CCI.DESEMPENHO_MODA 
                                                                                                                 ELSE NULL
                                                                                                            END) *  0.7 + 
                                                                                                        (SELECT ISNULL(CCIX.DSP,0) * 0.3 
                                                                                                           FROM correcoes_corretor_indicadores CCIX WITH (NOLOCK) 
                                                                                                          WHERE CCIX.usuario_id = CCI.USUARIO_ID AND 
                                                                                                                CCIX.projeto_id = CCI.PROJETO_ID AND 
                                                                                                                 CCIX.FLG_DADO_ATUAL = 1 AND
                                                                                                                CCIX.DATA_CALCULO =
                                                                                                                /*DATA DO ANTERIOR VALIDO*/ (SELECT MAX(DATA_CALCULO) 
                                                                                                                                               FROM correcoes_corretor_indicadores CCIXX WITH (NOLOCK) 
                                                                                                                                             WHERE CCIXX.usuario_id = CCI.USUARIO_ID AND 
                                                                                                                                                   CCIXX.projeto_id = CCI.PROJETO_ID AND 
                                                                                                                                                    CCIXX.FLG_DADO_ATUAL = 1          AND 
                                                                                                                                                    CCIXX.DSP IS NOT NULL  AND 
                                                                                                                                                    CCIXX.DATA_CALCULO < @DATA_CARGA)    /**/)
                                                                         ELSE 
                                                                             (isnull(CCI.DESEMPENHO_OURO,0) * 0.7 + isnull(CCI.DESEMPENHO_MODA,0) * 0.3) * 0.7 + 
                                                                             isnull((SELECT ISNULL(CCIX.DSP,0) * 0.3 
                                                                                FROM correcoes_corretor_indicadores CCIX WITH (NOLOCK) 
                                                                               WHERE CCIX.usuario_id = CCI.USUARIO_ID AND 
                                                                                     CCIX.projeto_id = CCI.PROJETO_ID AND 
                                                                                     CCIX.FLG_DADO_ATUAL = 1 AND
                                                                                    CCIX.DATA_CALCULO =
                                                                                    /*DATA DO ANTERIOR VALIDO*/ (SELECT MAX(DATA_CALCULO) 
                                                                                                                   FROM correcoes_corretor_indicadores CCIXX WITH (NOLOCK) 
                                                                                                                  WHERE CCIXX.usuario_id = CCI.USUARIO_ID AND 
                                                                                                                        CCIXX.projeto_id = CCI.PROJETO_ID AND 
                                                                                                                        CCIXX.FLG_DADO_ATUAL = 1          AND 
                                                                                                                        CCIXX.DSP IS NOT NULL  AND 
                                                                                                                        CCIXX.DATA_CALCULO < @DATA_CARGA)    /**/),0)                                                       
                                    END),2) AS FLOAT), 0)
                    END,                                                                          
  CCI.TEMPO_MEDIO_CORRECAO = CAST(ROUND(CASE WHEN total_correcoes >0  THEN CCI.TEMPO_CORRECAO / (total_correcoes * 1.0) 
                                                                      ELSE 0.00 END, 2) AS numeric(10, 2)),
  CCI.TAXA_APROVEITAMENTO  = CAST(ROUND(CASE WHEN total_correcoes > 0 THEN (APROVEITAMENTOS_COM_DISC + APROVEITAMENTOS_SEM_DISC) / (total_correcoes * 1.0) * 100
                                                                      ELSE 0.0 END, 2) AS numeric(10, 2)),
  CCI.TAXA_APROVEITAMENTO_COLETIVO   = CAST(ROUND(CASE WHEN (SELECT SUM(ccix.APROVEITAMENTOS_COM_DISC + ccix.APROVEITAMENTOS_SEM_DISC)
                                                               FROM correcoes_corretor_indicadores ccix
                                                              WHERE ccix.indice = cci.indice AND 
                                                                    ccix.DATA_CALCULO = cci.DATA_CALCULO) > 0 
                                                                      THEN (APROVEITAMENTOS_COM_DISC + APROVEITAMENTOS_SEM_DISC) / ((SELECT SUM(isnull(ccix.APROVEITAMENTOS_COM_DISC,0) + isnull(ccix.APROVEITAMENTOS_SEM_DISC,0))
                                                                                                                                       FROM correcoes_corretor_indicadores ccix WITH (NOLOCK)
                                                                                                                                      WHERE ccix.indice = cci.indice AND 
                                                                                                                                            ccix.DATA_CALCULO = cci.DATA_CALCULO)      * 1.0) * 100
                                                                      ELSE 0.0 END, 2) AS numeric(10, 2)),
  CCI.TAXA_DISCREPANCIA_OURO = CAST(ROUND(CASE WHEN OUROS_CORRIGIDAS > 0 THEN DISCREPANCIAS_OURO / (OUROS_CORRIGIDAS * 1.0) * 100
                                                                         ELSE 0.0 END, 2) AS numeric(10, 2))
FROM correcoes_corretor_indicadores cci
WHERE DATA_CALCULO = @DATA_CARGA AND 
      FLG_DADO_ATUAL = 0 AND 
      CCI.projeto_id = @ID_PROJETO

-- ************************************

--**********************************************************************************************************************

DELETE FROM correcoes_corretor_indicadores
 WHERE DATA_CALCULO = @DATA_CARGA AND 
       FLG_DADO_ATUAL = 1 AND 
       projeto_id = @ID_PROJETO

UPDATE correcoes_corretor_indicadores SET FLG_DADO_ATUAL = 1
 WHERE DATA_CALCULO = @DATA_CARGA AND 
       FLG_DADO_ATUAL = 0 AND 
       projeto_id = @ID_PROJETO


--Atualiza no corretor o valor mais recente de alguns indicadores
UPDATE cor
   SET cor.dsp = case when cci.desempenho_moda is null and cci.desempenho_ouro is null and cci.dsp = 0 then null else cci.dsp end,
       cor.tempo_medio_correcao = cci.tempo_medio_correcao
  FROM correcoes_corretor AS cor
       INNER JOIN correcoes_corretor_indicadores cci ON cci.usuario_id = cor.id
 WHERE cci.id = (SELECT max(cci2.id) FROM correcoes_corretor_indicadores cci2 WHERE cci2.usuario_id = cci.usuario_id)

GO
/****** Object:  StoredProcedure [dbo].[sp_correcoes_corretor_indicadores_new]    Script Date: 16/10/2019 10:22:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [dbo].[sp_correcoes_corretor_indicadores_new] 
	@DATA_CARGA date,
	@ID_PROJETO INT AS

	DECLARE @DATA_INICIO DATE
	SET @DATA_INICIO = (select cast(data_inicio as date) from projeto_projeto WITH (NOLOCK) where id = @id_projeto)

	 INSERT correcoes_corretor_indicadores 
	        (USUARIO_ID, NOME, ID_HIERARQUIA, ID_USUARIO_RESPONSAVEL, PROJETO_ID, INDICE, TEMPO_CORRECAO,
             OUROS_CORRIGIDAS, MODAS_CORRIGIDAS, DISCREPANCIAS_OURO, APROVEITAMENTOS_COM_DISC, APROVEITAMENTOS_SEM_DISC,
             TOTAL_CORRECOES, DESEMPENHO_OURO, DESEMPENHO_MODA, DSP, TEMPO_MEDIO_CORRECAO, TAXA_DISCREPANCIA_OURO, TAXA_APROVEITAMENTO,
             TAXA_APROVEITAMENTO_COLETIVO, FLG_DADO_ATUAL, DATA_CALCULO)

	--declare @DATA_CARGA date
	--declare @ID_PROJETO INT 
	--set @DATA_CARGA = '2018-11-09'
	--set @ID_PROJETO = 4

select distinct usuario_id, nome, id_hierarquia, id_usuario_responsavel, projeto_id, indice,
	   TEMPO_CORRECAO               = sum(TEMPO_CORRECAO),
	   OUROS_CORRIGIDAS             = sum(OUROS_CORRIGIDAS), 
	   MODAS_CORRIGIDAS             = sum(MODAS_CORRIGIDAS), 
	   DISCREPANCIAS_OURO           = sum(DISCREPANCIAS_OURO),
	   APROVEITAMENTOS_COM_DISC     = sum(APROVEITAMENTOS_COM_DISC),
	   APROVEITAMENTOS_SEM_DISC     = sum(APROVEITAMENTOS_SEM_DISC),
	   TOTAL_CORRECOES              = sum(TOTAL_CORRECOES),	  
	   DESEMPENHO_OURO              = max(DESEMPENHO_OURO),  
	   DESEMPENHO_MODA              = max(DESEMPENHO_MODA), 
       DSP                          = 0.0,
       TEMPO_MEDIO_CORRECAO         = 0.0,
       TAXA_DISCREPANCIA_OURO       = 0.0,
       TAXA_APROVEITAMENTO          = 0.0,
       TAXA_APROVEITAMENTO_COLETIVO = 0.0,
       FLG_DADO_ATUAL               = 0,
       DATA_CALCULO =  @DATA_CARGA 
  from (
select distinct vw.usuario_id, vw.nome, vw.id_hierarquia, vw.id_usuario_responsavel, vw.projeto_id, vw.indice, 
       TEMPO_CORRECAO = isnull((select sum(isnull(tempo_em_correcao,0)) 
                                  from correcoes_correcao corx WITH (NOLOCK) join correcoes_analise anax WITH (NOLOCK) on (corx.id = anax.id_correcao_a and 
       				                                                                                                       corx.id_projeto = anax.id_projeto)
       				              where corx.id_corretor = vw.usuario_id                  and 
       						            corx.id_status   = 3                              and 
       				                    @DATA_CARGA      = cast(corx.data_termino as date)),0), 
       OUROS_CORRIGIDAS         = sum(case when ANA.id_tipo_correcao_a = 5 then 1 else 0 end),
	   MODAS_CORRIGIDAS         = sum(case when ANA.id_tipo_correcao_a = 6 then 1 else 0 end),
       DISCREPANCIAS_OURO       = sum(case when (ana.id_tipo_correcao_a    = 5 and ana.conclusao_analise  > 2) then 1 else 0 end),
       APROVEITAMENTOS_COM_DISC = sum(case when (ana.id_tipo_correcao_B IN(3,4)and ana.conclusao_analise  > 2) then 1 else 0 end),
       APROVEITAMENTOS_SEM_DISC = sum(case when (ana.id_tipo_correcao_A    = 1 AND ana.conclusao_analise  < 3) then 1 else 0 end),
       TOTAL_CORRECOES          = sum(case when (ana.id_tipo_correcao_A    = 1 AND ana.id_tipo_correcao_B = 2) then 1 else 0 end), 
	   DESEMPENHO_OURO          = (select avg(anax.nota_desempenho) from correcoes_analise anax WITH (NOLOCK)
                                    where anax.id_corretor_A = ana.id_corretor_A and anax.id_tipo_correcao_a = 5 and 
                                          @DATA_CARGA = cast(anax.data_termino_A as date)), 
	   DESEMPENHO_MODA          = (select avg(anax.nota_desempenho) from correcoes_analise anax WITH (NOLOCK)
                                    where anax.id_corretor_A = ana.id_corretor_A and anax.id_tipo_correcao_a = 6 and 
                                          @DATA_CARGA = cast(anax.data_termino_A as date)) 

  from  vw_usuario_hierarquia vw WITH (NOLOCK) left join correcoes_analise ana WITH (NOLOCK) on (vw.usuario_id = ana.id_corretor_A and 
                                                                vw.projeto_id = ana.id_projeto         and 
																cast(ana.data_termino_A as date) = @DATA_CARGA) 
	    where VW.PROJETO_ID = 4  --AND VW.USUARIO_ID = 5312
group by vw.usuario_id, vw.nome, vw.id_hierarquia, vw.id_usuario_responsavel, vw.projeto_id, vw.indice,ana.id_corretor_A


union all 
select distinct vw.usuario_id, vw.nome, vw.id_hierarquia, vw.id_usuario_responsavel, vw.projeto_id, vw.indice, 
       TEMPO_CORRECAO = isnull((select sum(isnull(tempo_em_correcao,0)) 
                          from correcoes_correcao corx WITH (NOLOCK) join correcoes_analise anax WITH (NOLOCK) on (corx.id = anax.id_correcao_b and 
       				                                                                                               corx.id_projeto = anax.id_projeto)
       				  where corx.id_corretor                = vw.usuario_id and 
       						corx.id_status                  = 3             and 
       				        cast(corx.data_termino as date) = @DATA_CARGA) ,0), 
       OUROS_CORRIGIDAS         = 0,
       MODAS_CORRIGIDAS         = 0,
       DISCREPANCIAS_OURO       = 0,
       APROVEITAMENTOS_COM_DISC = 0,
       APROVEITAMENTOS_SEM_DISC = sum(case when (ana.id_tipo_correcao_b = 2 AND ana.conclusao_analise  < 3) then 1 else 0 end),
       TOTAL_CORRECOES          = sum(case when (ana.id_tipo_correcao_A = 1 AND ana.id_tipo_correcao_B = 2) then 1 else 0 end), 
	   DESEMPENHO_OURO          = 0.0, 
	   DESEMPENHO_MODA          = 0.0
  from vw_usuario_hierarquia vw WITH (NOLOCK) join correcoes_analise ana WITH (NOLOCK) on (vw.usuario_id = ana.id_corretor_b      and 
                                                                                           vw.projeto_id = ana.id_projeto         and 
																                           cast(ana.data_termino_b as date) = @DATA_CARGA) 
	   where VW.PROJETO_ID = @ID_PROJETO --AND VW.USUARIO_ID = 5312
group by vw.usuario_id, vw.nome, vw.id_hierarquia, vw.id_usuario_responsavel, vw.projeto_id, vw.indice) as tab
--where usuario_id = 1278
group by usuario_id, nome, id_hierarquia, id_usuario_responsavel, projeto_id, indice
--**********************************************************************************************************************
UPDATE CCI SET 
       CCI.DSP = CAST(ROUND((CASE WHEN @DATA_CARGA < DATEADD(DAY, 3, @DATA_INICIO) THEN CCI.DESEMPENHO_OURO
	                                     WHEN (CCI.OUROS_CORRIGIDAS = 0 OR CCI.MODAS_CORRIGIDAS = 0 ) THEN (CASE WHEN CCI.OUROS_CORRIGIDAS <> 0  THEN CCI.DESEMPENHO_OURO
	                                                                                                             WHEN CCI.MODAS_CORRIGIDAS <> 0  THEN CCI.DESEMPENHO_MODA 
																								                 ELSE NULL
	                                                                                                        END) *  0.7 + 
																			                            (SELECT ISNULL(CCIX.DSP,0) * 0.3 
																			                               FROM correcoes_corretor_indicadores CCIX WITH (NOLOCK) 
																			                              WHERE CCIX.usuario_id = CCI.USUARIO_ID AND 
																			                                    CCIX.projeto_id = CCI.PROJETO_ID AND 
																			                            		 CCIX.FLG_DADO_ATUAL = 1 AND
																			                            		CCIX.DATA_CALCULO =
																			                            		/*DATA DO ANTERIOR VALIDO*/ (SELECT MAX(DATA_CALCULO) 
																			                            		                               FROM correcoes_corretor_indicadores CCIXX WITH (NOLOCK) 
																			                                                                 WHERE CCIXX.usuario_id = CCI.USUARIO_ID AND 
																			                                                                       CCIXX.projeto_id = CCI.PROJETO_ID AND 
																			                            		                                    CCIXX.FLG_DADO_ATUAL = 1          AND 
																			                            											CCIXX.DSP IS NOT NULL  AND 
																			                            											CCIXX.DATA_CALCULO < @DATA_CARGA)    /**/)
                                                                         ELSE 
																			 (isnull(CCI.DESEMPENHO_OURO,0) * 0.7 + isnull(CCI.DESEMPENHO_MODA,0) * 0.3) * 0.7 + 
																			 isnull((SELECT ISNULL(CCIX.DSP,0) * 0.3 
																			    FROM correcoes_corretor_indicadores CCIX WITH (NOLOCK) 
																			   WHERE CCIX.usuario_id = CCI.USUARIO_ID AND 
																			         CCIX.projeto_id = CCI.PROJETO_ID AND 
																					 CCIX.FLG_DADO_ATUAL = 1 AND
																			 		CCIX.DATA_CALCULO =
																					/*DATA DO ANTERIOR VALIDO*/ (SELECT MAX(DATA_CALCULO) 
																					                               FROM correcoes_corretor_indicadores CCIXX WITH (NOLOCK) 
																			                                      WHERE CCIXX.usuario_id = CCI.USUARIO_ID AND 
																			                                            CCIXX.projeto_id = CCI.PROJETO_ID AND 
																					                                    CCIXX.FLG_DADO_ATUAL = 1          AND 
																														CCIXX.DSP IS NOT NULL  AND 
																														CCIXX.DATA_CALCULO < @DATA_CARGA)    /**/),0) 														
								    END),2) AS FLOAT),																			
  CCI.TEMPO_MEDIO_CORRECAO = CAST(ROUND(CASE WHEN total_correcoes >0  THEN CCI.TEMPO_CORRECAO / (total_correcoes * 1.0) 
                                                                      ELSE 0.00 END, 2) AS numeric(10, 2)),
  CCI.TAXA_APROVEITAMENTO  = CAST(ROUND(CASE WHEN total_correcoes > 0 THEN (APROVEITAMENTOS_COM_DISC + APROVEITAMENTOS_SEM_DISC) / (total_correcoes * 1.0) * 100
											 	                      ELSE 0.0 END, 2) AS numeric(10, 2)),
  CCI.TAXA_APROVEITAMENTO_COLETIVO   = CAST(ROUND(CASE WHEN (SELECT SUM(ccix.APROVEITAMENTOS_COM_DISC + ccix.APROVEITAMENTOS_SEM_DISC)
														       FROM correcoes_corretor_indicadores ccix
													          WHERE ccix.indice = cci.indice AND 
													                ccix.DATA_CALCULO = cci.DATA_CALCULO) > 0 
													                  THEN (APROVEITAMENTOS_COM_DISC + APROVEITAMENTOS_SEM_DISC) / ((SELECT SUM(isnull(ccix.APROVEITAMENTOS_COM_DISC,0) + isnull(ccix.APROVEITAMENTOS_SEM_DISC,0))
																													                   FROM correcoes_corretor_indicadores ccix WITH (NOLOCK)
																												                      WHERE ccix.indice = cci.indice AND 
																												                            ccix.DATA_CALCULO = cci.DATA_CALCULO)      * 1.0) * 100
                                                                      ELSE 0.0 END, 2) AS numeric(10, 2)),
  CCI.TAXA_DISCREPANCIA_OURO = CAST(ROUND(CASE WHEN OUROS_CORRIGIDAS > 0 THEN DISCREPANCIAS_OURO / (OUROS_CORRIGIDAS * 1.0) * 100
                                                                         ELSE 0.0 END, 2) AS numeric(10, 2))
FROM correcoes_corretor_indicadores cci
WHERE DATA_CALCULO = @DATA_CARGA AND 
      FLG_DADO_ATUAL = 0 AND 
	  CCI.projeto_id = @ID_PROJETO

-- ************************************

--**********************************************************************************************************************

DELETE FROM correcoes_corretor_indicadores
 WHERE DATA_CALCULO = @DATA_CARGA AND 
       FLG_DADO_ATUAL = 1 AND 
	   projeto_id = @ID_PROJETO

UPDATE correcoes_corretor_indicadores SET FLG_DADO_ATUAL = 1
 WHERE DATA_CALCULO = @DATA_CARGA AND 
       FLG_DADO_ATUAL = 0 AND 
	   projeto_id = @ID_PROJETO
GO
/****** Object:  StoredProcedure [dbo].[sp_correcoes_corretor_indicadores_old]    Script Date: 16/10/2019 10:22:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [dbo].[sp_correcoes_corretor_indicadores_old] 
	@DATA_CARGA date,
	@ID_PROJETO INT AS

	DECLARE @DATA_INICIO DATE
	SET @DATA_INICIO = (select cast(data_inicio as date) from projeto_projeto where id = @id_projeto)

	 INSERT correcoes_corretor_indicadores 
	        (USUARIO_ID, NOME, ID_HIERARQUIA, ID_USUARIO_RESPONSAVEL, PROJETO_ID, INDICE, TEMPO_CORRECAO,
             OUROS_CORRIGIDAS, DISCREPANCIAS_OURO, APROVEITAMENTOS_COM_DISC, APROVEITAMENTOS_SEM_DISC,
             TOTAL_CORRECOES, DESEMPENHO_OURO, DESEMPENHO_MODA, DSP, TEMPO_MEDIO_CORRECAO, TAXA_DISCREPANCIA_OURO, TAXA_APROVEITAMENTO,
             TAXA_APROVEITAMENTO_COLETIVO, FLG_DADO_ATUAL, DATA_CALCULO)

	--declare @DATA_CARGA date
	--declare @ID_PROJETO INT 
	--set @DATA_CARGA = '2018-11-09'
	--set @ID_PROJETO = 4

select distinct usuario_id, nome, id_hierarquia, id_usuario_responsavel, projeto_id, indice,
	   TEMPO_CORRECAO               = sum(TEMPO_CORRECAO),
	   OUROS_CORRIGIDAS             = sum(OUROS_CORRIGIDAS), 
	   DISCREPANCIAS_OURO           = sum(DISCREPANCIAS_OURO),
	   APROVEITAMENTOS_COM_DISC     = sum(APROVEITAMENTOS_COM_DISC),
	   APROVEITAMENTOS_SEM_DISC     = sum(APROVEITAMENTOS_SEM_DISC),
	   TOTAL_CORRECOES              = sum(TOTAL_CORRECOES),	  
	   DESEMPENHO_OURO              = max(DESEMPENHO_OURO),  
	   DESEMPENHO_MODA              = max(DESEMPENHO_MODA), 
       DSP                          = 0.0,
       TEMPO_MEDIO_CORRECAO         = 0.0,
       TAXA_DISCREPANCIA_OURO       = 0.0,
       TAXA_APROVEITAMENTO          = 0.0,
       TAXA_APROVEITAMENTO_COLETIVO = 0.0,
       FLG_DADO_ATUAL               = 0,
       DATA_CALCULO =  @DATA_CARGA 
  from (
select distinct vw.usuario_id, vw.nome, vw.id_hierarquia, vw.id_usuario_responsavel, vw.projeto_id, vw.indice, 
       TEMPO_CORRECAO = isnull((select sum(isnull(tempo_em_correcao,0)) 
                                  from correcoes_correcao corx  join correcoes_analise anax on (corx.id = anax.id_correcao_a and 
       				                                                                            corx.id_projeto = anax.id_projeto)
       				              where corx.id_corretor = vw.usuario_id                  and 
       						            corx.id_status   = 3                              and 
       				                    @DATA_CARGA      = cast(corx.data_termino as date)),0), 
       OUROS_CORRIGIDAS         = sum(case when id_tipo_correcao_a = 5 then 1 else 0 end),
       DISCREPANCIAS_OURO       = sum(case when (ana.id_tipo_correcao_a    = 5 and ana.conclusao_analise  > 2) then 1 else 0 end),
       APROVEITAMENTOS_COM_DISC = sum(case when (ana.id_tipo_correcao_B IN(3,4)and ana.conclusao_analise  > 2) then 1 else 0 end),
       APROVEITAMENTOS_SEM_DISC = sum(case when (ana.id_tipo_correcao_A    = 1 AND ana.conclusao_analise  < 3) then 1 else 0 end),
       TOTAL_CORRECOES          = sum(case when (ana.id_tipo_correcao_A    = 1 AND ana.id_tipo_correcao_B = 2) then 1 else 0 end), 
	   DESEMPENHO_OURO          = (select avg(anax.nota_desempenho) from correcoes_analise anax
                                    where anax.id_corretor_A = ana.id_corretor_A and anax.id_tipo_correcao_a = 5 and 
                                          @data_carga = cast(anax.data_termino_A as date)), 
	   DESEMPENHO_MODA          = (select avg(anax.nota_desempenho) from correcoes_analise anax
                                    where anax.id_corretor_A = ana.id_corretor_A and anax.id_tipo_correcao_a = 6 and 
                                          @data_carga = cast(anax.data_termino_A as date)) 
	  

  from  vw_usuario_hierarquia vw left join correcoes_analise ana on (vw.usuario_id = ana.id_corretor_A and 
                                                                vw.projeto_id = ana.id_projeto         and 
																cast(ana.data_termino_A as date) = @DATA_CARGA) 
	  where  VW.PROJETO_ID = @ID_PROJETO 
group by vw.usuario_id, vw.nome, vw.id_hierarquia, vw.id_usuario_responsavel, vw.projeto_id, vw.indice,ana.id_corretor_A


union all 
select distinct vw.usuario_id, vw.nome, vw.id_hierarquia, vw.id_usuario_responsavel, vw.projeto_id, vw.indice, 
       TEMPO_CORRECAO = isnull((select sum(isnull(tempo_em_correcao,0)) 
                          from correcoes_correcao corx  join correcoes_analise anax on (corx.id = anax.id_correcao_b and 
       				                                                                    corx.id_projeto = anax.id_projeto)
       				  where corx.id_corretor                = vw.usuario_id and 
       						corx.id_status                  = 3             and 
       				        cast(corx.data_termino as date) = @DATA_CARGA) ,0), 
       OUROS_CORRIGIDAS         = 0,
       DISCREPANCIAS_OURO       = 0,
       APROVEITAMENTOS_COM_DISC = 0,
       APROVEITAMENTOS_SEM_DISC = sum(case when (ana.id_tipo_correcao_b = 2 AND ana.conclusao_analise  < 3) then 1 else 0 end),
       TOTAL_CORRECOES          = sum(case when (ana.id_tipo_correcao_A = 1 AND ana.id_tipo_correcao_B = 2) then 1 else 0 end), 
	   DESEMPENHO_OURO          = 0.0, 
	   DESEMPENHO_MODA          = 0.0
  from vw_usuario_hierarquia vw join correcoes_analise ana on (vw.usuario_id = ana.id_corretor_b      and 
                                                                    vw.projeto_id = ana.id_projeto         and 
																    cast(ana.data_termino_b as date) = @DATA_CARGA) 
	   where VW.PROJETO_ID = @ID_PROJETO   
group by vw.usuario_id, vw.nome, vw.id_hierarquia, vw.id_usuario_responsavel, vw.projeto_id, vw.indice) as tab
--where usuario_id = 1278
group by usuario_id, nome, id_hierarquia, id_usuario_responsavel, projeto_id, indice
--**********************************************************************************************************************
UPDATE CCI SET 
       CCI.DSP = isnull(CAST(ROUND((CASE WHEN @DATA_CARGA < DATEADD(DAY, 3, @DATA_INICIO) THEN CCI.DESEMPENHO_OURO 
                                                                         ELSE 
																			 (isnull(CCI.DESEMPENHO_OURO,0) * 0.7 + isnull(CCI.DESEMPENHO_MODA,0) * 0.3) * 0.7 + 
																			 isnull((SELECT ISNULL(CCIX.DSP,0) * 0.3 
																			    FROM correcoes_corretor_indicadores CCIX 
																			   WHERE CCIX.usuario_id = CCI.USUARIO_ID AND 
																			         CCIX.projeto_id = CCI.PROJETO_ID AND 
																					 CCIX.FLG_DADO_ATUAL = 1 AND
																			 		CCIX.DATA_CALCULO = DATEADD(DAY, -1, @DATA_CARGA)),0) END),2) AS FLOAT),0.0),																			
  CCI.TEMPO_MEDIO_CORRECAO = CAST(ROUND(CASE WHEN total_correcoes >0  THEN CCI.TEMPO_CORRECAO / (total_correcoes * 1.0) 
                                                                      ELSE 0.00 END, 2) AS numeric(10, 2)),
  CCI.TAXA_APROVEITAMENTO  = CAST(ROUND(CASE WHEN total_correcoes > 0 THEN (APROVEITAMENTOS_COM_DISC + APROVEITAMENTOS_SEM_DISC) / (total_correcoes * 1.0) * 100
											 	                      ELSE 0.0 END, 2) AS numeric(10, 2)),
  CCI.TAXA_APROVEITAMENTO_COLETIVO   = CAST(ROUND(CASE WHEN (SELECT SUM(ccix.APROVEITAMENTOS_COM_DISC + ccix.APROVEITAMENTOS_SEM_DISC)
														       FROM correcoes_corretor_indicadores ccix
													          WHERE ccix.indice = cci.indice AND 
													                ccix.DATA_CALCULO = cci.DATA_CALCULO) > 0 
													                  THEN (APROVEITAMENTOS_COM_DISC + APROVEITAMENTOS_SEM_DISC) / ((SELECT SUM(isnull(ccix.APROVEITAMENTOS_COM_DISC,0) + isnull(ccix.APROVEITAMENTOS_SEM_DISC,0))
																													                   FROM correcoes_corretor_indicadores ccix
																												                      WHERE ccix.indice = cci.indice AND 
																												                            ccix.DATA_CALCULO = cci.DATA_CALCULO)      * 1.0) * 100
                                                                      ELSE 0.0 END, 2) AS numeric(10, 2)),
  CCI.TAXA_DISCREPANCIA_OURO = CAST(ROUND(CASE WHEN OUROS_CORRIGIDAS > 0 THEN DISCREPANCIAS_OURO / (OUROS_CORRIGIDAS * 1.0) * 100
                                                                         ELSE 0.0 END, 2) AS numeric(10, 2))
FROM correcoes_corretor_indicadores cci
WHERE DATA_CALCULO = @DATA_CARGA AND 
      FLG_DADO_ATUAL = 0 AND 
	  CCI.projeto_id = @ID_PROJETO

-- ************************************

--**********************************************************************************************************************

DELETE FROM correcoes_corretor_indicadores
 WHERE DATA_CALCULO = @DATA_CARGA AND 
       FLG_DADO_ATUAL = 1 AND 
	   projeto_id = @ID_PROJETO

UPDATE correcoes_corretor_indicadores SET FLG_DADO_ATUAL = 1
 WHERE DATA_CALCULO = @DATA_CARGA AND 
       FLG_DADO_ATUAL = 0 AND 
	   projeto_id = @ID_PROJETO
GO
/****** Object:  StoredProcedure [dbo].[SP_CORRIGE_FILAPESSOAL]    Script Date: 16/10/2019 10:22:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/******************
OS COORDENADORES POLO E SUPERVISORES APESENTAVAM REGISTROS NA FILAPESSOAL QUE NAO POSSUIAM REFERENCIA NA CORRECOES_CORRECAO

SOLUCAO: APGAR OS REGISTROS DA FILAPESSOAL (FOI FEITO BACKUP -> CORRECOES_FILAPESSOAL_SUPERVISOR_COORDENADOR_POLO_20181204__1115)
SELECT IDENTIFICA OS CASOS
*******************/
-- SELECT * FROM CORRECOES_FILAPESSOAL_SUPERVISOR_COORDENADOR_POLO_20181204__1115
CREATE OR ALTER PROCEDURE [dbo].[SP_CORRIGE_FILAPESSOAL] AS
BEGIN TRY
	BEGIN TRAN FILA
		insert into CORRECOES_FILAPESSOAL_SUPERVISOR_COORDENADOR_POLO_20181204__1115
		SELECT * FROM correcoes_filapessoal PES 
		WHERE NOT EXISTS (SELECT TOP 1 1 FROM CORRECOES_CORRECAO COR WHERE COR.co_barra_redacao = PES.co_barra_redacao AND 
																		   COR.id_corretor      = PES.id_corretor)
																		   ORDER BY id_corretor
		
		delete FROM CORRECOES_FILAPESSOAL WHERE ID IN (
		SELECT PES.ID 
		FROM CORRECOES_FILAPESSOAL PES JOIN CORRECOES_FILAPESSOAL_SUPERVISOR_COORDENADOR_POLO_20181204__1115 BKP ON (PES.id = BKP.ID))

	COMMIT TRAN FILA
END TRY
BEGIN CATCH
    ROLLBACK TRAN FILA 
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[sp_distribuir_ordem]    Script Date: 16/10/2019 10:22:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [dbo].[sp_distribuir_ordem] 
	@id_avaliador int, 
	@id_projeto   int,
	@id_redacaotipo int
as

DECLARE @QUANTIDADE           INT
DECLARE @CONT                 INT
declare @aux                  int
declare @resultado            int 
declare @id                   int
declare @nova_faixa           int
declare @nova_quantidade      int
declare @faixa_ouro           int
declare @qtd_ouro             int
declare @aux_ouro             int
declare @qtd_correcao         int
DECLARE @QUANTIDADE_CORRIGIDA INT 
DECLARE @POSICAO_INICIAL      INT 

/*
select @qtd_correcao = count(cor.id)
  from correcoes_correcao cor join correcoes_redacao red on (cor.co_barra_redacao = red.co_barra_redacao and
                                                             cor.id_projeto       = red.id_projeto)
where cor.id_corretor = 469 and
      cor.id_projeto  = 4 and 
	  cor.id_correcao_situacao = 3 and
	  red.id_redacaoouro is null 
*/
select @faixa_ouro = ouro_frequencia, @qtd_ouro= ouro_quantidade 
 from projeto_projeto where id = @id_projeto
set @aux = @faixa_ouro/ @qtd_ouro

SET @CONT   = 0
SET @QUANTIDADE = (SELECT COUNT(*) FROM CORRECOES_REDACAOOURO OUR WITH (NOLOCK) JOIN CORRECOES_REDACAO RED WITH (NOLOCK) ON (OUR.ID = RED.id_redacaoouro)
                                                                                JOIN CORRECOES_FILAOURO FIL WITH (NOLOCK)  ON (FIL.co_barra_redacao = RED.co_barra_redacao)
                    WHERE ID_REDACAOTIPO =  @ID_REDACAOTIPO AND 
					      FIL.posicao IS NULL AND 
						  FIL.id_corretor = @id_avaliador)

set @QUANTIDADE_CORRIGIDA = (SELECT COUNT(ID) FROM CORRECOES_CORRECAO COR  WITH (NOLOCK)
                             WHERE COR.id_corretor = @ID_AVALIADOR AND 
							       COR.id_projeto  = @ID_PROJETO   AND
								   COR.id_status   = 3             AND
								   COR.id_tipo_correcao < 5)


	SELECT @POSICAO_INICIAL = MAX(POSICAO) FROM CORRECOES_FILAOURO OUR WITH (NOLOCK) JOIN CORRECOES_REDACAO RED  WITH (NOLOCK)ON (OUR.co_barra_redacao = RED.co_barra_redacao)
	                                                   JOIN CORRECOES_REDACAOOURO REO WITH (NOLOCK) ON (REO.ID = RED.id_redacaoouro)
	WHERE OUR.id_corretor = @id_avaliador AND REO.id_redacaotipo = @id_redacaotipo

	IF (@POSICAO_INICIAL IS NOT NULL)
			BEGIN
				SET @QUANTIDADE_CORRIGIDA = @POSICAO_INICIAL
			END

	/*

	UPDATE  OURO SET OURO.POSICAO = NULL 
	FROM CORRECOES_FILAOURO OURO
	WHERE id_corretor = @id_avaliador and
		  id_projeto  = @id_projeto   and 		      
		  posicao > @QUANTIDADE_CORRIGIDA AND 
		  EXISTS (SELECT TOP 1 1 FROM CORRECOES_FILAOURO OUR WITH (NOLOCK) JOIN CORRECOES_REDACAO RED    WITH (NOLOCK)ON (OUR.co_barra_redacao = RED.co_barra_redacao)
	                                                                       JOIN CORRECOES_REDACAOOURO REO WITH (NOLOCK) ON (REO.ID = RED.id_redacaoouro) 
					WHERE OURO.CO_BARRA_REDACAO = OUR.CO_BARRA_REDACAO AND 
					      REO.id_redacaotipo = @id_redacaotipo)

*/


WHILE (@CONT < @QUANTIDADE)
	BEGIN
	
		
		set @resultado =  ((@QUANTIDADE_CORRIGIDA + @aux*@cont ) + (  @aux )*rand())
		if (@resultado = 0)
			begin
				set @resultado = 5
			end


		select top 1 @id = id from correcoes_filaouro OURO
		where id_corretor = @id_avaliador and
		      id_projeto  = @id_projeto   and 		      
			  posicao is null AND 
			   EXISTS (SELECT TOP 1 1 FROM CORRECOES_FILAOURO OUR WITH (NOLOCK) JOIN CORRECOES_REDACAO RED    WITH (NOLOCK)ON (OUR.co_barra_redacao = RED.co_barra_redacao)
	                                                                       JOIN CORRECOES_REDACAOOURO REO WITH (NOLOCK) ON (REO.ID = RED.id_redacaoouro) 
					WHERE OURO.CO_BARRA_REDACAO = OUR.CO_BARRA_REDACAO AND 
					      REO.id_redacaotipo = @id_redacaotipo)
		ORDER BY OURO.ID

		update correcoes_filaouro set posicao =  @resultado 
		where id = @id

		SET @CONT = @CONT + 1
	END
GO
/****** Object:  StoredProcedure [dbo].[sp_distribuir_ordem_DIARIO]    Script Date: 16/10/2019 10:22:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER   procedure [dbo].[sp_distribuir_ordem_DIARIO]
	@id_avaliador int,
	@id_projeto   int,
	@id_redacaotipo int
as

DECLARE @QUANTIDADE           INT
DECLARE @CONT                 INT
declare @aux                  int
declare @resultado            int
declare @id                   int
declare @nova_faixa           int
declare @nova_quantidade      int
declare @faixa_ouro           int
declare @qtd_ouro             int
declare @aux_ouro             int
declare @qtd_correcao         int
DECLARE @QUANTIDADE_CORRIGIDA_DIA_ANTERIOR INT
DECLARE @POSICAO_INICIAL      INT


select @faixa_ouro = ouro_frequencia, @qtd_ouro= ouro_quantidade
 from projeto_projeto where id = @id_projeto
set @aux = @faixa_ouro/ @qtd_ouro

SET @CONT   = 1

/* LIMPAR A POSICAO DE TODAS AS CORRECOES OURO OU MODA PARA NOVA REDISTRIBUICAO */
UPDATE  FIL SET FIL.POSICAO = NULL
	FROM CORRECOES_FILAOURO FIL WITH (NOLOCK) JOIN CORRECOES_REDACAO     RED WITH (NOLOCK) ON (FIL.REDACAO_ID = RED.ID)
                                              JOIN CORRECOES_REDACAOOURO OUR WITH (NOLOCK) ON (OUR.ID = RED.id_redacaoouro)
	WHERE FIL.id_corretor = @id_avaliador and
		  FIL.id_projeto  = @id_projeto   AND
		  OUR.id_redacaotipo = @id_redacaotipo



SET @QUANTIDADE = (SELECT COUNT(*) FROM CORRECOES_REDACAOOURO OUR WITH (NOLOCK) JOIN CORRECOES_REDACAO RED  WITH (NOLOCK) ON (OUR.ID = RED.id_redacaoouro)
                                                                                JOIN CORRECOES_FILAOURO FIL WITH (NOLOCK)  ON (FIL.redacao_id = RED.id)
                    WHERE ID_REDACAOTIPO =  @ID_REDACAOTIPO AND
					      FIL.posicao IS NULL AND
						  FIL.id_corretor = @id_avaliador AND
						  FIL.id_projeto  = @id_projeto)

set @QUANTIDADE_CORRIGIDA_DIA_ANTERIOR = (SELECT COUNT(ID) FROM CORRECOES_CORRECAO COR  WITH (NOLOCK)
											 WHERE COR.id_corretor = @ID_AVALIADOR AND
												   COR.id_projeto  = @ID_PROJETO   AND
												   COR.id_status   = 3             AND
												   COR.id_tipo_correcao < 5       AND
										  CAST(COR.DATA_TERMINO AS DATE)  <CAST(GETDATE() AS DATE))


WHILE (@CONT <= @QUANTIDADE)
	BEGIN


		set @resultado =  ((@QUANTIDADE_CORRIGIDA_DIA_ANTERIOR + @aux*@cont ) + ((@aux )*rand()))
		if (@resultado = 0)
			begin
				set @resultado = @QUANTIDADE_CORRIGIDA_DIA_ANTERIOR + 5
			end


		select top 1 @id = id from correcoes_filaouro OURO
		where id_corretor = @id_avaliador and
		      id_projeto  = @id_projeto   and
			  posicao is null AND
			   EXISTS (SELECT TOP 1 1 FROM CORRECOES_FILAOURO OUR WITH (NOLOCK) JOIN CORRECOES_REDACAO RED    WITH (NOLOCK)ON (OUR.redacao_id = RED.id)
	                                                                       JOIN CORRECOES_REDACAOOURO REO WITH (NOLOCK) ON (REO.ID = RED.id_redacaoouro)
					WHERE OURO.redacao_id = OUR.redacao_id AND
					      REO.id_redacaotipo = @id_redacaotipo)
		ORDER BY OURO.ID

		update correcoes_filaouro set posicao =  @resultado
		where id = @id

		SET @CONT = @CONT + 1
	END

GO
/****** Object:  StoredProcedure [dbo].[sp_foreach_table_azure]    Script Date: 16/10/2019 10:22:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [dbo].[sp_foreach_table_azure]
    @command1 nvarchar(2000), @replacechar nchar(1) = N'?', @command2 nvarchar(2000) = null,
  @command3 nvarchar(2000) = null, @whereand nvarchar(2000) = null,
    @precommand nvarchar(2000) = null, @postcommand nvarchar(2000) = null
AS
    declare @mscat nvarchar(12)
    select @mscat = ltrim(str(convert(int, 0x0002)))
    if (@precommand is not null)
        exec(@precommand)
   exec(N'declare hCForEachTable cursor global for select ''['' + REPLACE(schema_name(syso.schema_id), N'']'', N'']]'') + '']'' + ''.'' + ''['' + REPLACE(object_name(o.id), N'']'', N'']]'') + '']'' from dbo.sysobjects o join sys.all_objects syso on o.id = syso.object_id '
         + N' where OBJECTPROPERTY(o.id, N''IsUserTable'') = 1 ' + N' and o.category & ' + @mscat + N' = 0 '
         + @whereand)
    declare @retval int
    select @retval = @@error
    if (@retval = 0)
        exec @retval = dbo.sp_foreach_worker @command1, @replacechar, @command2, @command3, 0
    if (@retval = 0 and @postcommand is not null)
        exec(@postcommand)
    return @retval

GO
/****** Object:  StoredProcedure [dbo].[SP_GERAR_REDACAO_OURO_MODA]    Script Date: 16/10/2019 10:22:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*****************************************************************************************************************
*                                  PROCEDURE PARA CRIAR REDACOES OURO OU MODA                                    *
*                                                                                                                *
*  PROCEDURE QUE RECEBE O TIPO DE REDACAO A SER GERADA (2-OURO OU 3-MODA) E COM BASE NAS REDACOES CADASTRADAS NA * 
* TABELA redacoes_redacaoreferencia SERA CRIADO UMA COPIA NA TABELA CORRECOES_REDACAOOURO, UMA COPIA NA          *
* CORRECOES_REDACAO COM O CODIGO DE BARRA ALTERADO (SENDO INICIADO COM 001 PARA OURO E 002 PARA MODA DEPOIS      *
* CRIADO UM REGISTRO PARA CADA UMA NA CORRECOES_FILAOURO E EM SEGUIDA CRIADO UMA ORDENACAO DE BUSCA COM BASE NAS *
* INFORMACOESDA PROJETO_PROJETO                                                                                  *
*                                                                                                                *
* BANCO_SISTEMA : ENEM                                                                                           *
* CRIADO POR    : WEMERSON BITTORI MADURO                                                        DATA:27/11/2018 *
* ALTERADO POR  : WEMERSON BITTORI MADURO                                                        DATA:27/11/2018 *
******************************************************************************************************************/


CREATE OR ALTER PROCEDURE [dbo].[SP_GERAR_REDACAO_OURO_MODA] @TIPO_REDACAO INT AS 

DECLARE @ID_CORRETOR  INT 
DECLARE @ID_PROJETO   INT 

--***** INSERIR NA TABELA CORRRECOES_REDACAOOURO (as modas selecionadas na tabela redacoes_redacaoreferencia)
insert into correcoes_redacaoouro (link_imagem_recortada, link_imagem_original, co_barra_redacao, co_inscricao, co_formulario, id_prova, id_projeto, id_redacaotipo, data_criacao, id_origem)
select red.link_imagem_recortada, red.link_imagem_original, red.co_barra_redacao, red.co_inscricao, red.co_formulario, red.id_prova, red.id_projeto, id_redacaotipo = ref.id_redacao_tipo, 
       data_criacao = getdate(), id_origem = 1 
  from correcoes_redacao red join redacoes_redacaoreferencia  ref on  (ref.id_redacao       = red.id)  
                        left join correcoes_redacaoouro       our on  (red.co_barra_redacao = our.co_barra_redacao)
                        left join correcoes_redacaoouro       ourx on (red.id_redacaoouro   = ourx.id)
 where ref.id_redacao_tipo = @tipo_redacao and 
       our.co_barra_redacao is null and 
       ourx.co_barra_redacao is null 

-- **** inserir na tabela redacao as redacoes ouro para o candidato 
	 select link_imagem_recortada, link_imagem_original,nota_final, id_correcao_situacao, 
	        co_barra_redacao = CASE WHEN @tipo_redacao = 2 THEN '001'
			                        WHEN @tipo_redacao = 3 THEN '002'ELSE '***' END + right('000000' +convert(varchar(6),our.id),6) +
							                                                          right('000000' +convert(varchar(6),cor.id),6),
	        co_inscricao     = CASE WHEN @tipo_redacao = 2 THEN '001'
			                        WHEN @tipo_redacao = 3 THEN '002'ELSE '***' END + right('000000' +convert(varchar(6),our.id),6) +
							                                                          right('000000' +convert(varchar(6),cor.id),6),
	        co_formulario,id_prova, id_projeto,our.id, id_corretor = cor.id
	    into #tmp_correcoes_redacao
	   from correcoes_redacaoouro OUR join correcoes_corretor cor on (1=1)
	                                  join projeto_projeto_usuarios usu on (cor.id = usu.user_id)
		where usu.projeto_id = 4 and 
		      our.id_redacaotipo = @tipo_redacao and 
		      usu.user_id in (select usuario_id from vw_usuario_hierarquia where perfil in ('AUXILIARES DE CORREÇÃO DE REDAÇÃO', 'avaliador'))
	  order by co_barra_redacao

	  select * from #tmp_correcoes_redacao
	  -- *** inserir na tabela redacao com o codigo de barra alterado para o padrao moda ou ouro dependendo do tipo_redacao escolhido e levando o id da redacao referencia 
	insert correcoes_redacao (link_imagem_recortada, link_imagem_original, nota_final, id_redacao_situacao,
		   co_barra_redacao, co_inscricao, co_formulario, id_prova, id_projeto, id_redacaoouro)
	select link_imagem_recortada, link_imagem_original, nota_final, 1, 
		   co_barra_redacao, co_inscricao, co_formulario, id_prova, id_projeto,id 
	  from #tmp_correcoes_redacao tmp
	 where not exists (select 1 from correcoes_redacao redx 
	                    where redx.co_barra_redacao = tmp.co_barra_redacao AND
						      REDX.id_projeto = TMP.id_projeto)

	-- **** inserir na tabela filaOURO
	-- **** select * from correcoes_filaouro where posicao is null 
	insert correcoes_filaouro (co_barra_redacao, id_corretor, posicao, id_projeto, criado_em)
	SELECT tem.co_barra_redacao, tem.id_corretor, null, tem.id_projeto, GETDATE()
	  FROM #tmp_correcoes_redacao tem
	 where not exists (select top 1 1 from correcoes_filaouro flox 
						where flox.co_barra_redacao = tem.co_barra_redacao and 
							  flox.id_corretor      = tem.id_corretor AND 
							  FLOX.id_projeto       = 4)
 
 -- ***** monto a ordenacao de busca das redacoes para o busca mais um 
 declare CUR_DIS_ORD_OUR_MOD cursor for 
	SELECT id_corretor, id_projeto FROM #tmp_correcoes_redacao
	open CUR_DIS_ORD_OUR_MOD 
		fetch next from CUR_DIS_ORD_OUR_MOD into @id_corretor, @id_projeto
		while @@FETCH_STATUS = 0
			BEGIN
				 exec sp_distribuir_ordem  @id_corretor, @id_projeto, @tipo_redacao

			fetch next from CUR_DIS_ORD_OUR_MOD into @id_corretor, @id_projeto
			END
	close CUR_DIS_ORD_OUR_MOD 
deallocate CUR_DIS_ORD_OUR_MOD
GO
/****** Object:  StoredProcedure [dbo].[sp_insere_discrepancia_na_fila]    Script Date: 16/10/2019 10:22:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER   PROCEDURE [dbo].[sp_insere_discrepancia_na_fila]
	@CO_BARRA_REDACAO VARCHAR(100),
	@REDACAO_ID INT,
	@ID_ANALISE INT,
	@FILA INT
	AS
		IF(@FILA = 3)
			BEGIN
				INSERT INTO CORRECOES_FILA3 (CORRIGIDO_POR, id_projeto, co_barra_redacao, redacao_id)
				SELECT distinct DBO.fn_cor_corretor_redacao(CO_BARRA_REDACAO), id_projeto,co_barra_redacao, redacao_id
				  FROM correcoes_correcao FIL3 WITH (NOLOCK)
				 WHERE redacao_id = @REDACAO_ID AND
					   NOT EXISTS (SELECT 1  FROM correcoes_fila3 FILX
									WHERE FILX.id_projeto       = FIL3.id_projeto AND
										  FILX.redacao_id = FIL3.redacao_id) and
					   NOT EXISTS (SELECT TOP 1 1 FROM CORRECOES_CORRECAO CORX
					                WHERE CORX.redacao_id = FIL3.redacao_id AND
									      CORX.id_tipo_correcao = 3 AND
										  CORX.id_projeto = FIL3.id_projeto)


				UPDATE correcoes_analise SET FILA = 3 WHERE ID = @ID_ANALISE
			END
		ELSE IF(@FILA = 4)
			BEGIN
				INSERT INTO CORRECOES_FILA4 (CORRIGIDO_POR, id_projeto, co_barra_redacao, redacao_id)
				SELECT distinct DBO.fn_cor_corretor_redacao(CO_BARRA_REDACAO), id_projeto,co_barra_redacao,redacao_id
				  FROM correcoes_correcao FIL4 WITH (NOLOCK)
				 WHERE redacao_id = @REDACAO_ID AND
					   NOT EXISTS (SELECT 1  FROM correcoes_fila4 FILX
									WHERE FILX.id_projeto       = FIL4.id_projeto AND
										  FILX.redacao_id = FIL4.redacao_id)and
					   NOT EXISTS (SELECT TOP 1 1 FROM CORRECOES_CORRECAO CORX
					                WHERE CORX.redacao_id = FIL4.redacao_id AND
									      CORX.id_tipo_correcao = 4 AND
										  CORX.id_projeto = FIL4.id_projeto)

				UPDATE correcoes_analise SET FILA = 4 WHERE ID = @ID_ANALISE
			END

GO
/****** Object:  StoredProcedure [dbo].[sp_inserir_analise]    Script Date: 16/10/2019 10:22:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [dbo].[sp_inserir_analise]
	@ID_CORRECAO   INT,
	@TIPO_GRAVACAO INT,
	@ID_PROJETO    INT,
	@ERRO VARCHAR(500) OUTPUT
AS

DECLARE @NOTA INT
DECLARE @COMP1 INT
DECLARE @COMP2 INT
DECLARE @COMP3 INT
DECLARE @COMP4 INT
DECLARE @COMP5 INT
DECLARE @ID_CORRECAO1 INT
DECLARE @ID_CORRECAO2 INT
DECLARE @ID_CORRETOR1 INT
DECLARE @ID_CORRETOR2 INT
DECLARE @ID_ANALISE INT
DECLARE @SITUACAO VARCHAR(10)
DECLARE @CODBARRA VARCHAR(50)
DECLARE @CONCLUSAO INT
DECLARE @REDACAO_ID INT

DECLARE @VAI_PARA_AUDITORIA INT
DECLARE @CODIGO_PD INT

DECLARE @LIMITE_NOTA_FINAL       FLOAT
DECLARE @LIMITE_NOTA_COMPETENCIA FLOAT

DECLARE @NOTA_FINAL FLOAT
DECLARE @RETORNOU_REGISTRO INT

DECLARE @SOBERANA INT

DECLARE @EQUIDISTANTE INT
SET @EQUIDISTANTE = 0

SET @ERRO = ''
SET @RETORNOU_REGISTRO = 0
SET @VAI_PARA_AUDITORIA = 0


SELECT @CODIGO_PD  = ID FROM CORRECOES_SITUACAO WHERE SIGLA = 'PD'

-- ***** VERIFICA QUA O PRIMEIRO TIPO DE CORREÇÃO É SOBERANO *****
SELECT TOP 1 @SOBERANA = ID FROM CORRECOES_TIPO WHERE flag_soberano = 1 ORDER BY ID

print 'Soberana: ' + convert(varchar(50), @SOBERANA)

SELECT @CODBARRA = COR.CO_BARRA_REDACAO,
       @LIMITE_NOTA_FINAL = PRO.limite_nota_final,
	   @LIMITE_NOTA_COMPETENCIA = PRO.limite_nota_competencia,
       @REDACAO_ID = COR.REDACAO_ID
  FROM CORRECOES_CORRECAO COR WITH (NOLOCK) JOIN PROJETO_PROJETO PRO WITH (NOLOCK) ON (COR.id_projeto = PRO.id)
 WHERE COR.ID = @ID_CORRECAO AND
       COR.id_projeto = @ID_PROJETO

IF(@@ROWCOUNT = 0)
	BEGIN
		SET @ERRO = 'NAO EXISTE REFERENCIA PARA ESTE ID DE CORRECAO - ' + CONVERT(VARCHAR(20),@ID_CORRECAO)
	END

IF (@ERRO = '')
	BEGIN
		BEGIN TRANSACTION
		BEGIN TRY

			/************** TESTAR O TIPO DE GRAVACAO 1-(COMPARACAO 1,2) 2-(COMPARACAO 1,3) 3-(COMPARACAO 2-3) 4-(COMPARACAO 3-4)
			                                          5-(COMPARACAO 5 E OURO) 6-(COMPARACAO 6-MODA) 7-(COMPAFRACAO 7-ABSOLUTA)*******/
			IF (@TIPO_GRAVACAO = 1)
				BEGIN
					IF (EXISTS (SELECT TOP 1 1 FROM CORRECOES_ANALISE WITH (NOLOCK)
								 WHERE redacao_id   = @REDACAO_ID AND
									   id_tipo_correcao_A = 1 AND
									   id_tipo_correcao_B = 2 AND
                                       id_projeto = @ID_PROJETO))
						BEGIN
							SET @ERRO = 'JÁ EXISTE'
						END
					ELSE
						BEGIN
							SELECT @NOTA		 = NOTATOTAL,           @COMP1		  = COMPETENCIA1,
								   @COMP2		 = COMPETENCIA2,        @COMP3		  = COMPETENCIA3,
								   @COMP4		 = COMPETENCIA4,        @COMP5		  = COMPETENCIA5,
								   @SITUACAO     = DIVERGENCIASITUACAO, @ID_CORRECAO1 = CORRECAO1,
								   @ID_CORRECAO2 = CORRECAO2,		    @ID_CORRETOR1 = ID_CORRETOR1,
								   @ID_CORRETOR2 = ID_CORRETOR2
					  	     FROM vw_cor_avalia_discrepancia_divergencia_correcao_1_2 WITH (NOLOCK)
							WHERE id = @REDACAO_ID AND
							      id_projeto = @ID_PROJETO
							IF(@@ROWCOUNT = 0)
								BEGIN
									set @ERRO = 'NAO EXISTE'
								END
						END
				END
			ELSE IF (@TIPO_GRAVACAO = 2)
				BEGIN
					IF (EXISTS (SELECT 1 FROM CORRECOES_ANALISE WITH (NOLOCK)
								 WHERE redacao_id   = @REDACAO_ID AND
									   id_tipo_correcao_A = 1 AND
									   id_tipo_correcao_B = 3 AND
                                       id_projeto = @ID_PROJETO))
						BEGIN
							SET @ERRO = 'JÁ EXISTE'
						END
					ELSE
						BEGIN
							SELECT @NOTA		 = NOTATOTAL,           @COMP1		  = COMPETENCIA1,
								   @COMP2		 = COMPETENCIA2,        @COMP3		  = COMPETENCIA3,
								   @COMP4		 = COMPETENCIA4,        @COMP5		  = COMPETENCIA5,
								   @SITUACAO     = DIVERGENCIASITUACAO, @ID_CORRECAO1 = CORRECAO1,
								   @ID_CORRECAO2 = CORRECAO2,		    @ID_CORRETOR1 = ID_CORRETOR1,
								   @ID_CORRETOR2 = ID_CORRETOR2
							 FROM vw_cor_avalia_discrepancia_divergencia_correcao_1_3 WITH (NOLOCK)
							WHERE id = @REDACAO_ID AND
                                  id_projeto = @ID_PROJETO
							IF(@@ROWCOUNT = 0)
								BEGIN
									set @ERRO = 'NAO EXISTE'
								END
						END
				END
			ELSE IF (@TIPO_GRAVACAO = 3)
				BEGIN
					IF (EXISTS (SELECT 1 FROM CORRECOES_ANALISE WITH (NOLOCK)
								 WHERE redacao_id = @REDACAO_ID AND
									   id_tipo_correcao_A = 2 AND
									   id_tipo_correcao_B = 3 AND
                                       id_projeto = @ID_PROJETO))
						BEGIN
							SET @ERRO = 'JÁ EXISTE'
						END
					ELSE
						BEGIN
							SELECT @NOTA		 = NOTATOTAL,           @COMP1		  = COMPETENCIA1,
								   @COMP2		 = COMPETENCIA2,        @COMP3		  = COMPETENCIA3,
								   @COMP4		 = COMPETENCIA4,        @COMP5		  = COMPETENCIA5,
								   @SITUACAO     = DIVERGENCIASITUACAO, @ID_CORRECAO1 = CORRECAO1,
								   @ID_CORRECAO2 = CORRECAO2,		    @ID_CORRETOR1 = ID_CORRETOR1,
								   @ID_CORRETOR2 = ID_CORRETOR2
						  	  FROM vw_cor_avalia_discrepancia_divergencia_correcao_2_3 WITH (NOLOCK)
							WHERE id = @REDACAO_ID AND
                                       id_projeto = @ID_PROJETO
							IF(@@ROWCOUNT = 0)
								BEGIN
									set @ERRO = 'NAO EXISTE'
								END

							SET @RETORNOU_REGISTRO = @@ROWCOUNT
						END
				END
			ELSE IF (@TIPO_GRAVACAO = 4)
				BEGIN
					IF (EXISTS (SELECT 1 FROM CORRECOES_ANALISE WITH (NOLOCK)
								 WHERE redacao_id = @REDACAO_ID AND
									   id_tipo_correcao_A = 3 AND
									   id_tipo_correcao_B = 4 AND
                                       id_projeto = @ID_PROJETO))
						BEGIN
							SET @ERRO = 'JÁ EXISTE'
						END
					ELSE
						BEGIN
							SELECT @NOTA		 = NOTATOTAL,           @COMP1		  = COMPETENCIA1,
								   @COMP2		 = COMPETENCIA2,        @COMP3		  = COMPETENCIA3,
								   @COMP4		 = COMPETENCIA4,        @COMP5		  = COMPETENCIA5,
								   @SITUACAO     = DIVERGENCIASITUACAO, @ID_CORRECAO1 = CORRECAO1,
								   @ID_CORRECAO2 = CORRECAO2,		    @ID_CORRETOR1 = ID_CORRETOR1,
								   @ID_CORRETOR2 = ID_CORRETOR2
						  	  FROM vw_cor_avalia_discrepancia_divergencia_correcao_3_4 WITH (NOLOCK)
							WHERE id = @REDACAO_ID AND
                                       id_projeto = @ID_PROJETO
							IF(@@ROWCOUNT = 0)
								BEGIN
									set @ERRO = 'NAO EXISTE'
								END

							SET @RETORNOU_REGISTRO = @@ROWCOUNT
						END
				END

			IF (@ERRO = '')
				BEGIN
					/******* SE FOR COMPARACAO ENTRE 1 E 2 E HOUVER DISCREPANCIA GRAVAR UM REGISTRO NA FILA3 *********/
					/*************************************************************************************************
						ENCCEJA
							NOTA MAIOR OU IGUAL 400
						    SITUACOES DIFERENTES
						ENEM
							NOTAFINAL MAIOR  100
							NOTACOMPETENCIA MAIOR  80
							SITUACAO DIFERENTE
					*************************************************************************************************/

/*
print 'Situação: ' + @SITUACAO
print 'dif comp1: ' + convert(varchar(50), @COMP1)
print 'dif comp2: ' + convert(varchar(50), @COMP2)
print 'dif comp3: ' + convert(varchar(50), @COMP3)
print 'dif comp4: ' + convert(varchar(50), @COMP4)
print 'dif comp5: ' + convert(varchar(50), @COMP5)

print 'limite competencia: ' + convert(varchar(50), @LIMITE_NOTA_COMPETENCIA)
*/

					IF((@SITUACAO = 'SIM') )
						BEGIN
							SET @CONCLUSAO = 5
						END
					ELSE IF ((@NOTA >= @LIMITE_NOTA_FINAL))
						BEGIN
						    print @nota
							print @LIMITE_NOTA_FINAL
							SET @CONCLUSAO = 4
						END
					ELSE IF ((@COMP1 >= @LIMITE_NOTA_COMPETENCIA OR
					          @COMP2 >= @LIMITE_NOTA_COMPETENCIA OR
					          @COMP3 >= @LIMITE_NOTA_COMPETENCIA OR
					          @COMP4 >= @LIMITE_NOTA_COMPETENCIA OR
					          @COMP5 >= @LIMITE_NOTA_COMPETENCIA ) )
						BEGIN
							SET @CONCLUSAO = 3
						END
					ELSE IF ((@NOTA > 0) )
						BEGIN
							SET @CONCLUSAO = 2
						END
					ELSE IF ((@COMP1 > 0 OR
					          @COMP2 > 0 OR
					          @COMP3 > 0 OR
					          @COMP4 > 0 OR
					          @COMP5 > 0 )  )
						BEGIN
							SET @CONCLUSAO = 1
						END
					ELSE
						BEGIN
							SET @CONCLUSAO = 0
						END

					--PRINT 'GRAVAR NA CORRECCOES_ANALISE'
					/*****************************************************************************************************/

					/***** FAZER O INSERT DO PRIMEIRO CORRETOR NA TABELA ANALISE ******/
					INSERT INTO CORRECOES_ANALISE (id_correcao_A, co_barra_redacao, data_inicio_A, data_termino_A,
												   link_imagem_recortada, link_imagem_original,
												   nota_final_A, competencia1_A, competencia2_A, competencia3_A, competencia4_A, competencia5_A,
												   nota_competencia1_A, diferenca_competencia1, situacao_competencia1,
												   nota_competencia2_A, diferenca_competencia2, situacao_competencia2,
												   nota_competencia3_A, diferenca_competencia3, situacao_competencia3,
												   nota_competencia4_A, diferenca_competencia4, situacao_competencia4,
												   nota_competencia5_A, diferenca_competencia5, situacao_competencia5,
												   id_auxiliar1_A, id_auxiliar2_A, id_correcao_situacao_A,
												   id_corretor_A, id_status_A, id_tipo_correcao_A, situacao_nota_final,DIFERENCA_SITUACAO, id_projeto,
												   diferenca_nota_final,
												   conclusao_analise,fila,redacao_id,
                                                   ID_CORRECAO_B,
                                                   DATA_INICIO_B,         
                                                   DATA_TERMINO_B,        
                                                   NOTA_FINAL_B,          
                                                   COMPETENCIA1_B,        
                                                   COMPETENCIA2_B,        
                                                   COMPETENCIA3_B,        
                                                   COMPETENCIA4_B,        
                                                   COMPETENCIA5_B,        
                                                   NOTA_COMPETENCIA1_B,   
                                                   NOTA_COMPETENCIA2_B,   
                                                   NOTA_COMPETENCIA3_B,   
                                                   NOTA_COMPETENCIA4_B,   
                                                   NOTA_COMPETENCIA5_B,   
                                                   ID_AUXILIAR1_B,        
                                                   ID_AUXILIAR2_B ,       
                                                   ID_CORRECAO_SITUACAO_B,
                                                   ID_CORRETOR_B,         
                                                   ID_STATUS_B,           
                                                   ID_TIPO_CORRECAO_B)
					SELECT COR1.ID, COR1.co_barra_redacao, COR1.data_inicio, COR1.data_termino,
						   COR1.link_imagem_recortada, COR1.link_imagem_original,
						   COR1.nota_final, COR1.competencia1, COR1.competencia2, COR1.competencia3, COR1.competencia4, COR1.competencia5,
						   COR1.nota_competencia1, DIFERENCA_COMPETENCIA1 = @COMP1,
						   SITUACAO_COMPETENCIA1 = CASE WHEN @COMP1 >= @LIMITE_NOTA_COMPETENCIA THEN 2 WHEN @COMP1 = 0 THEN 0 ELSE 1 END,
						   COR1.nota_competencia2, DIFERENCA_COMPETENCIA2 = @COMP2,
						   SITUACAO_COMPETENCIA2 = CASE WHEN @COMP2 >= @LIMITE_NOTA_COMPETENCIA THEN 2 WHEN @COMP2 = 0 THEN 0 ELSE 1 END,
						   COR1.nota_competencia3, DIFERENCA_COMPETENCIA3 = @COMP3,
						   SITUACAO_COMPETENCIA3 = CASE WHEN @COMP3 >= @LIMITE_NOTA_COMPETENCIA THEN 2 WHEN @COMP3 = 0 THEN 0 ELSE 1 END,
						   COR1.nota_competencia4, DIFERENCA_COMPETENCIA4 = @COMP4,
						   SITUACAO_COMPETENCIA4 = CASE WHEN @COMP4 >= @LIMITE_NOTA_COMPETENCIA THEN 2 WHEN @COMP4 = 0 THEN 0 ELSE 1 END,
						   COR1.nota_competencia5, DIFERENCA_COMPETENCIA5 = @COMP5,
						   SITUACAO_COMPETENCIA5 = CASE WHEN @COMP5 >= @LIMITE_NOTA_COMPETENCIA THEN 2 WHEN @COMP5 = 0 THEN 0 ELSE 1 END,
						   COR1.id_auxiliar1, COR1.id_auxiliar2, COR1.id_correcao_situacao,
						   COR1.id_corretor, COR1.id_status, COR1.id_tipo_correcao,
						   SITUACAO_NOTA_FINAL   = CASE WHEN @NOTA    >= @LIMITE_NOTA_FINAL   THEN 2 WHEN @NOTA = 0 THEN 0 ELSE 1 END,
						   DIFERENCA_SITUACAO    = CASE WHEN @SITUACAO = 'SIM' THEN 2 ELSE 0 END, COR1.id_projeto,
						   @NOTA, @CONCLUSAO, 0, @REDACAO_ID,
                           COR2.ID,
                           COR2.data_inicio,
                           COR2.data_termino,
                           COR2.NOTA_FINAL,
                           COR2.competencia1,
                           COR2.competencia2,
                           COR2.competencia3,
                           COR2.competencia4,
                           COR2.competencia5,
                           COR2.NOTA_COMPETENCIA1,
                           COR2.NOTA_COMPETENCIA2,
                           COR2.NOTA_COMPETENCIA3,
                           COR2.NOTA_COMPETENCIA4,
                           COR2.NOTA_COMPETENCIA5,
                           COR2.id_auxiliar1,
                           COR2.id_auxiliar2,
                           COR2.id_correcao_situacao,
                           COR2.id_corretor,
                           COR2.id_status,
                           COR2.id_tipo_correcao
					  FROM CORRECOES_CORRECAO COR1 WITH (NOLOCK) JOIN CORRECOES_CORRECAO COR2 ON COR2.redacao_id = COR1.REDACAO_ID
					 WHERE COR1.ID = @ID_CORRECAO1
                       AND COR2.ID = @ID_CORRECAO2
					   AND COR1.id_projeto = @ID_PROJETO

					/***** RECUPERAR O ID DA TABELA ANALISE PARA O PODERMOS INSERIR A SEGUNDA CORRECAO ******/
					SET @ID_ANALISE = SCOPE_IDENTITY()

				END

			/****************************************************************************************************************/
			print 'passou 1'
            if exists(select top 1 1 from core_feature where codigo = 'auditoria' and ativo = 1) begin
			print 'passou 2'
				select distinct ID_PROJETO, redacao_id, CO_BARRA_REDACAO, id_correcao = null, corrigido_por = NULL, pendente = 0,
					    tipo_id = case when ((nota_final_A = 1000 and nota_final_B  = 1000) or (nota_final_B  = 1000 and id_tipo_correcao_B = 4)) then 1
										          when (id_correcao_situacao_A = @CODIGO_PD or id_correcao_situacao_B = @CODIGO_PD) then 2
										          when (competencia5_A = -1 or competencia5_B = -1)  then 3
										          else null end, id_corretor = null
				into #temp_auditoria
				 from correcoes_analise ana
				where (((nota_final_A = 1000 and nota_final_B  = 1000) or (nota_final_B  = 1000 and id_tipo_correcao_B = 4)) or
					   (competencia5_A = -1 or competencia5_B = -1) or
					   (id_correcao_situacao_A = @CODIGO_PD or id_correcao_situacao_B = @CODIGO_PD)) and
					   not exists (select 1 from correcoes_filaauditoria audx
					                where audx.redacao_id = ana.redacao_id and
									      audx.id_projeto       = ana.id_projeto       and
										  audx.tipo_id = (case when ((nota_final_A = 1000 and nota_final_B  = 1000) or (nota_final_B  = 1000 and id_tipo_correcao_B = 4)) then 1
										                       when (id_correcao_situacao_A = @CODIGO_PD or
															         id_correcao_situacao_B = @CODIGO_PD)
																	 then 2
										                       when (competencia5_A = -1 or competencia5_B = -1)
															        then 3
										                       else null end)) and

					id = @ID_ANALISE

					insert correcoes_filaauditoria (id_projeto, redacao_id, CO_BARRA_REDACAO, id_correcao, corrigido_por, pendente, tipo_id, id_corretor)
					select * from #temp_auditoria tem
					where not exists(select top 1 1 from correcoes_filaauditoria AUD WITH (NOLOCK) WHERE AUD.redacao_id = TEM.redacao_id)
					set @VAI_PARA_AUDITORIA = 0

					select @VAI_PARA_AUDITORIA = 1 from correcoes_filaauditoria aud WHERE AUD.redacao_id = @REDACAO_ID


					if(exists(select top 1 1 from correcoes_correcao corx join correcoes_analise anax on (corx.redacao_id = anax.redacao_id)
					             where anax.redacao_id = @REDACAO_ID and
								       corx.id_tipo_correcao = 7))
						begin
							set @VAI_PARA_AUDITORIA = 1
						end
            end
            /******************************************************************************************************************/
			/* EQUIDISTANCIA */

				/*select que busca todos equidistantes que nao possuem nenhuma discrepancia de competencia */
				IF ((SELECT COUNT(COR1.ID)
                                    FROM CORRECOES_CORRECAO COR1 WITH (NOLOCK) JOIN CORRECOES_CORRECAO COR2 WITH (NOLOCK) ON (COR1.redacao_id = COR2.redacao_id AND
                                                                                                                              COR1.id_tipo_correcao = 1 AND COR2.id_tipo_correcao = 2)
					                                            JOIN CORRECOES_CORRECAO COR3 WITH (NOLOCK) ON (COR3.redacao_id = COR2.redacao_id AND
						                                                                                       COR3.id_tipo_correcao = 3)
                                     WHERE ((COR3.nota_final = (COR1.nota_final + COR2.nota_final)/2.0) OR
                                            (COR1.nota_final = COR2.nota_final AND
	                                         COR1.id_correcao_situacao =1     AND
	                                         COR2.id_correcao_situacao =1     AND
	                                         COR3.id_correcao_situacao =1 ))  AND
					                         COR1.redacao_id = @REDACAO_ID and
											((abs(cor3.competencia1 - cor2.competencia1)<=2) and
											 (abs(cor3.competencia2 - cor2.competencia2)<=2) and
											 (abs(cor3.competencia3 - cor2.competencia3)<=2) and
											 (abs(cor3.competencia4 - cor2.competencia4)<=2) and
											 (abs(cor3.competencia5 - cor2.competencia5)<=2)) and
											((abs(cor3.competencia1 - cor1.competencia1)<=2) and
											 (abs(cor3.competencia2 - cor1.competencia2)<=2) and
											 (abs(cor3.competencia3 - cor1.competencia3)<=2) and
											 (abs(cor3.competencia4 - cor1.competencia4)<=2) and
											 (abs(cor3.competencia5 - cor1.competencia5)<=2))
											 )> 0) and EXISTS(SELECT 1 FROM CORE_FEATURE WHERE CODIGO = 'INSERE_NA_FILA_4_AUTOMATICO' AND ativo = 1)
				        BEGIN

				            SET @EQUIDISTANTE = 1
							SET @CONCLUSAO = 4
				        	EXEC SP_INSERE_DISCREPANCIA_NA_FILA @CODBARRA, @REDACAO_ID, @ID_ANALISE, 4
			        	UPDATE correcoes_analise SET CONCLUSAO_ANALISE = 4 WHERE ID = @ID_ANALISE
				        END

           /*****************************************************************************************************************/


           /*****************************************************************************************************************/
				IF(@VAI_PARA_AUDITORIA = 0)
					BEGIN
						IF(EXISTS(SELECT 1 FROM CORE_FEATURE
								   WHERE CODIGO = 'INSERE_NA_FILA_3_AUTOMATICO' AND ativo = 1) AND
							             @CONCLUSAO > 2  and @TIPO_GRAVACAO = 1)
							BEGIN
								EXEC SP_INSERE_DISCREPANCIA_NA_FILA @CODBARRA, @REDACAO_ID, @ID_ANALISE, 3
							END
						ELSE IF(EXISTS(SELECT 1 FROM CORE_FEATURE WHERE CODIGO = 'INSERE_NA_FILA_4_AUTOMATICO' AND ativo = 1)AND
							     @CONCLUSAO > 2 and
								 @TIPO_GRAVACAO = 3)
							BEGIN
							   /* se houver discrepancia na analise da terceira nas duas comparacoes 1 e 2 */
							    IF ((select count(id) from correcoes_analise
								      where redacao_id = @REDACAO_ID  and
									        id_tipo_correcao_B = 3        and
                                            conclusao_analise > 2) = 2 )
									BEGIN
										EXEC SP_INSERE_DISCREPANCIA_NA_FILA @CODBARRA, @REDACAO_ID, @ID_ANALISE, 4

									END
							END
						  ELSE IF(EXISTS(SELECT 1 FROM CORE_FEATURE WHERE CODIGO = 'INSERE_NA_FILA_4_AUTOMATICO' AND ativo = 1)AND
							    @EQUIDISTANTE = 1 and
								 @TIPO_GRAVACAO = 3)
							BEGIN
								EXEC SP_INSERE_DISCREPANCIA_NA_FILA @CODBARRA, @REDACAO_ID, @ID_ANALISE, 4

							END
						-- ****** CALCULO DA NOTA FINAL DA REDACAO
					    -- ***** se for comparacao de primeira com segunda e nao houver discrepancia
						IF(@TIPO_GRAVACAO = 1 and @CONCLUSAO <= 2)
							BEGIN
								  UPDATE RED SET RED.nota_final = (ABS(ISNULL(ANA.nota_final_A,0) + ISNULL(ANA.nota_final_B,0))/2.0) ,
								                 red.id_correcao_situacao = ana.id_correcao_situacao_B
								   FROM CORRECOES_ANALISE ANA JOIN CORRECOES_REDACAO RED ON (ANA.redacao_id = RED.id)
								   WHERE ANA.ID = @ID_ANALISE
							END
						-- ***** se for comparacao com terceira
						ELSE IF(@TIPO_GRAVACAO IN (2,3) AND @EQUIDISTANTE = 0)  -- SE FOR EQUIDISTANTE NAO GRAVA NOTA
							BEGIN
								IF(@SOBERANA <> 3 )
									BEGIN

										if((select count(id) from correcoes_analise
										  where redacao_id = @REDACAO_ID and
										        id_tipo_correcao_B = 3        and
										        conclusao_analise < 3) > 0)

										begin

										    DECLARE @NOTA_AUX  FLOAT
										    DECLARE @NOTA1 FLOAT
										   	DECLARE @NOTA2 FLOAT
											DECLARE @NOTA3 FLOAT
											DECLARE @SITUACAO1 INT
											DECLARE @SITUACAO2 INT
											DECLARE @SITUACAO_AUX INT

											select @NOTA1     = CASE WHEN conclusao_analise <3 THEN nota_final_A ELSE -1 END,
											       @NOTA3     = nota_final_B,
											       @SITUACAO1 = CASE WHEN id_correcao_situacao_B = id_correcao_situacao_A THEN id_correcao_situacao_B ELSE -1 END
											  from correcoes_analise
											 where redacao_id = @REDACAO_ID and id_tipo_correcao_B = 3 and id_tipo_correcao_A = 1

											select @NOTA2     = CASE WHEN conclusao_analise <3 THEN nota_final_A ELSE -1 END,
											       @SITUACAO2 = CASE WHEN id_correcao_situacao_B = id_correcao_situacao_A THEN id_correcao_situacao_B ELSE -1 END
											  from correcoes_analise
											 where redacao_id = @REDACAO_ID and id_tipo_correcao_B = 3 and id_tipo_correcao_A = 2

											SET @NOTA_AUX = (CASE WHEN (@NOTA2 < 0 AND @NOTA1 <0) THEN -1
														          WHEN (@NOTA2 < 0) THEN @NOTA1
														          WHEN (@NOTA1 < 0) THEN @NOTA2
														          WHEN ABS(@NOTA3 - @NOTA2) >= ABS(@NOTA3-@NOTA1) THEN @NOTA1 ELSE @NOTA2 END)

											SET @SITUACAO_AUX = (CASE WHEN @SITUACAO1 > 0 THEN @SITUACAO1
											                          WHEN @SITUACAO2 > 0 THEN @SITUACAO2
											                     END)

										    IF(@NOTA_AUX > 0)
												BEGIN
													UPDATE RED SET RED.nota_final =  (ABS(ISNULL(@NOTA_AUX,0) + ISNULL(@NOTA3,0))/2.0), RED.id_correcao_situacao = @SITUACAO_AUX
													   FROM CORRECOES_ANALISE ANA JOIN CORRECOES_REDACAO RED ON (ANA.redacao_id = RED.id)
													   WHERE ANA.ID = @ID_ANALISE
												END
											ELSE
												BEGIN
													UPDATE RED SET RED.nota_final =  0.0 , RED.id_correcao_situacao = @SITUACAO_AUX
													   FROM CORRECOES_ANALISE ANA JOIN CORRECOES_REDACAO RED ON (ANA.redacao_id = RED.id)
													   WHERE ANA.ID = @ID_ANALISE

												END

										end
									END -------
								ELSE
									BEGIN
										UPDATE RED SET RED.nota_final = ANA.nota_final_B, red.id_correcao_situacao = ana.id_correcao_situacao_B
										   FROM CORRECOES_ANALISE ANA JOIN CORRECOES_REDACAO RED ON (ANA.redacao_id = RED.id)
										   WHERE ANA.ID = @ID_ANALISE
									END
							END
						-- ***** se comparacao for com a quarta
						ELSE IF(@TIPO_GRAVACAO IN (4) AND @SOBERANA = 4)
							BEGIN

								UPDATE RED SET RED.nota_final = ANA.nota_final_B, red.id_correcao_situacao = ana.id_correcao_situacao_B
								   FROM CORRECOES_ANALISE ANA JOIN CORRECOES_REDACAO RED ON (ANA.redacao_id = RED.id)
								   WHERE ANA.ID = @ID_ANALISE
							END


						IF (@TIPO_GRAVACAO = 3 and @erro = '' AND @EQUIDISTANTE = 0)
							BEGIN
								exec SP_AVALIA_APROVEITAMENTO @REDACAO_ID, @id_projeto
							END
					end

			COMMIT
		END TRY
		BEGIN CATCH
			ROLLBACK
			SET @ERRO = 'O PROCESSAMENTO NAO FOI EFETUADO - ID_CORRECAO = ' + CONVERT(VARCHAR(30), @ID_CORRECAO) + ' - ' + ERROR_MESSAGE()
		END CATCH
	END

	IF(@ERRO = '')
		BEGIN
			SET @ERRO = 'OK'
		END

	RETURN

GO

/****** Object:  StoredProcedure [dbo].[sp_inserir_analise_auditoria]    Script Date: 16/10/2019 10:22:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  OR ALTER  procedure [dbo].[sp_inserir_analise_auditoria]
	@ID_CORRECAO INT,
	@ID_PROJETO INT,
	@ERRO VARCHAR(500) OUTPUT
AS

DECLARE @NOTA INT
DECLARE @COMP1 INT
DECLARE @COMP2 INT
DECLARE @COMP3 INT
DECLARE @COMP4 INT
DECLARE @COMP5 INT
DECLARE @ID_CORRECAO1 INT
DECLARE @ID_CORRECAO2 INT
DECLARE @ID_CORRETOR1 INT
DECLARE @ID_TIPO_CORRECAO INT
DECLARE @ID_ANALISE INT
DECLARE @SITUACAO VARCHAR(10)
DECLARE @CODBARRA VARCHAR(50)
DECLARE @LIMITE_NOTA_FINAL FLOAT
DECLARE @LIMITE_NOTA_COMPETENCIA FLOAT

DECLARE @RETORNOU_REGISTRO INT


SET @ERRO = ''
SET @RETORNOU_REGISTRO = 0

SELECT @CODBARRA = CO_BARRA_REDACAO, @ID_CORRETOR1 = id_corretor
  FROM CORRECOES_CORRECAO
 WHERE ID = @ID_CORRECAO AND
       id_projeto = @ID_PROJETO

 SELECT @NOTA         = NOTA_FINAL,           @COMP1		  = COMPETENCIA1,
		@COMP2		  = COMPETENCIA2,         @COMP3		  = COMPETENCIA3,
		@COMP4		  = COMPETENCIA4,         @COMP5		  = COMPETENCIA5,
		@SITUACAO     = ID_CORRECAO_SITUACAO, @ID_PROJETO     = ID_PROJETO,
		@ID_CORRECAO1 = ID,	                  @ID_CORRETOR1   = ID_CORRETOR,
		@ID_TIPO_CORRECAO = ID_TIPO_CORRECAO
   FROM CORRECOES_CORRECAO COR
  WHERE CO_BARRA_REDACAO = @CODBARRA AND
  	    id_projeto = @ID_PROJETO     AND
  	    ID_TIPO_CORRECAO = 7
IF(@@ROWCOUNT = 0)
	BEGIN
		SET @ERRO = 'NAO EXISTE REFERENCIA PARA ESTE ID DE CORRECAO - ' + CONVERT(VARCHAR(20),@ID_CORRECAO)
	END

IF (@ERRO = '')
	BEGIN
		BEGIN TRY
    		BEGIN TRANSACTION

			IF (EXISTS (SELECT 1 FROM CORRECOES_ANALISE
							WHERE CO_BARRA_REDACAO = @CODBARRA AND
								id_corretor_A      = @ID_CORRETOR1  AND
								id_projeto         = @ID_PROJETO    AND
								id_tipo_correcao_A = @ID_TIPO_CORRECAO))
				BEGIN
					SET @ERRO = 'JÁ EXISTE'
				END



			IF (@ERRO = '')
				BEGIN
					--PRINT 'GRAVAR NA CORRECCOES_ANALISE'
					/*****************************************************************************************************/
					/***** FAZER O INSERT DO PRIMEIRO CORRETOR NA TABELA ANALISE ******/

					INSERT INTO CORRECOES_ANALISE (co_barra_redacao, data_inicio_A, data_termino_A, id_correcao_A,
												   link_imagem_recortada, link_imagem_original,
												   nota_final_A, competencia1_A, competencia2_A, competencia3_A, competencia4_A, competencia5_A,
												   nota_competencia1_A, nota_competencia2_A, nota_competencia3_A,  nota_competencia4_A, nota_competencia5_A,
												   id_auxiliar1_A, id_auxiliar2_A, id_correcao_situacao_A, id_corretor_A, id_status_A, id_tipo_correcao_A,
												   id_projeto, conclusao_analise,fila)
					SELECT co_barra_redacao, data_inicio,data_termino, id,
						   link_imagem_recortada, link_imagem_original,
						   nota_final, competencia1, competencia2, competencia3, competencia4, competencia5,
						   nota_competencia1, nota_competencia2, nota_competencia3, nota_competencia4, nota_competencia5,
						   id_auxiliar1, id_auxiliar2, id_correcao_situacao, id_corretor, id_status, id_tipo_correcao, id_projeto, 0,0
					  FROM CORRECOES_CORRECAO
					 WHERE id_corretor = @ID_CORRETOR1  and
					       co_barra_redacao = @CODBARRA and
						   id_projeto = @ID_PROJETO     and
						   id_tipo_correcao = @ID_TIPO_CORRECAO
			/***** RECUPERAR O ID DA TABELA ANALISE PARA O PODERMOS INSERIR A SEGUNDA CORRECAO ******/
					select @ID_ANALISE = ANA.ID
					FROM CORRECOES_ANALISE ANA
					 WHERE ANA.CO_BARRA_REDACAO = @CODBARRA AND
						   ana.id_tipo_correcao_A = 7


			/****************************************************************************************************************/

			 UPDATE RED SET RED.nota_final =  ANA.nota_final_A, red.id_correcao_situacao = ana.id_correcao_situacao_A
			 FROM CORRECOES_ANALISE ANA JOIN CORRECOES_REDACAO RED ON (ANA.co_barra_redacao = RED.co_barra_redacao AND
			                                                           ANA.id_projeto       = RED.id_projeto)
			  WHERE ANA.ID = @ID_ANALISE

				END

			COMMIT
		END TRY
		BEGIN CATCH
			ROLLBACK
			SET @ERRO = 'AUDITORIA - O PROCESSAMENTO NAO FOI EFETUADO - ID_CORRECAO = ' + CONVERT(VARCHAR(30), @ID_CORRECAO) + ' - ' + ERROR_MESSAGE ( )
		END CATCH
	END

	IF(@ERRO = '')
		BEGIN
			SET @ERRO = 'OK'
		END

	RETURN

GO
/****** Object:  StoredProcedure [dbo].[sp_inserir_analise_gabarito]    Script Date: 16/10/2019 10:22:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER PROCEDURE [dbo].[sp_inserir_analise_gabarito]
	@ID_CORRECAO INT,
	@ID_PROJETO INT,
	@ERRO VARCHAR(500) OUTPUT
AS

DECLARE @NOTA INT
DECLARE @COMP1 INT
DECLARE @COMP2 INT
DECLARE @COMP3 INT
DECLARE @COMP4 INT
DECLARE @COMP5 INT
DECLARE @ID_CORRECAO1 INT
DECLARE @ID_CORRECAO2 INT
DECLARE @ID_CORRETOR1 INT
DECLARE @ID_CORRETOR2 INT
DECLARE @ID_ANALISE INT
DECLARE @SITUACAO VARCHAR(10)
DECLARE @CODBARRA VARCHAR(50)
DECLARE @REDACAO_ID INT

DECLARE @LIMITE_NOTA_COMPETENCIA DECIMAL(10,2)
DECLARE @LIMITE_NOTA_FINAL DECIMAL(10,2)

DECLARE @RETORNOU_REGISTRO INT

SET @ERRO = ''
SET @RETORNOU_REGISTRO = 0


--Carrega os valores limites para o cálculo da discrepância e divergência
select @LIMITE_NOTA_COMPETENCIA = LIMITE_NOTA_COMPETENCIA, @LIMITE_NOTA_FINAL = LIMITE_NOTA_FINAL
  from projeto_projeto
  where id = @ID_PROJETO

SELECT @CODBARRA = CO_BARRA_REDACAO, @ID_CORRETOR1 = id_corretor, @REDACAO_ID = redacao_id
  FROM CORRECOES_CORRECAO
 WHERE ID = @ID_CORRECAO AND
       id_projeto = @ID_PROJETO

IF(@@ROWCOUNT = 0)
	BEGIN
		SET @ERRO = 'NAO EXISTE REFERENCIA PARA ESTE ID DE CORRECAO - ' + CONVERT(VARCHAR(20),@ID_CORRECAO)
	END

IF (@ERRO = '')
	BEGIN
		BEGIN TRANSACTION
		BEGIN TRY

			IF (EXISTS (SELECT 1 FROM CORRECOES_ANALISE	
							WHERE redacao_id = @REDACAO_ID AND
								id_corretor_A = @ID_CORRETOR1  AND
								id_projeto = @ID_PROJETO)) BEGIN
				SET @ERRO = 'JÁ EXISTE'
			END


			IF (@ERRO = '')
				BEGIN
					--PRINT 'GRAVAR NA CORRECCOES_ANALISE'
					/*****************************************************************************************************/
					/***** FAZER O INSERT DO PRIMEIRO CORRETOR NA TABELA ANALISE ******/
					INSERT INTO CORRECOES_ANALISE (co_barra_redacao, data_inicio_A, data_termino_A, id_correcao_A,
												   link_imagem_recortada, link_imagem_original,
												   nota_final_A, competencia1_A, competencia2_A, competencia3_A, competencia4_A, competencia5_A,
												   nota_competencia1_A, diferenca_competencia1, situacao_competencia1,
												   nota_competencia2_A, diferenca_competencia2, situacao_competencia2,
												   nota_competencia3_A, diferenca_competencia3, situacao_competencia3,
												   nota_competencia4_A, diferenca_competencia4, situacao_competencia4,
												   nota_competencia5_A, diferenca_competencia5, situacao_competencia5,
												   id_auxiliar1_A, id_auxiliar2_A, id_correcao_situacao_A,
												   id_corretor_A, id_status_A, id_tipo_correcao_A, situacao_nota_final,DIFERENCA_SITUACAO,
												   diferenca_nota_final,id_projeto,
												   conclusao_analise,fila,
												   nota_final_b,
												   competencia1_b,        
												   competencia2_b,
												   competencia3_b,
												   competencia4_b,
												   competencia5_b,
												   nota_competencia1_b,
												   nota_competencia2_b,
												   nota_competencia3_b,
												   nota_competencia4_b,
												   nota_competencia5_b,
												   id_correcao_situacao_b,
                                                   redacao_id
												    )
                    SELECT top 1 cor.co_barra_redacao, cor.data_inicio_correcao, cor.data_termino_correcao, cor.id_correcao,
					       cor.link_imagem_recortada, cor.link_imagem_original,
						   nota_final_correcao,
						   id_competencia1_correcao,
						   id_competencia2_correcao,
						   id_competencia3_correcao,
						   id_competencia4_correcao,
						   id_competencia5_correcao,
						   nota_competencia1_correcao, competencia1_diferenca, case when competencia1_diferenca >= 81 then 2 when competencia1_diferenca = 0 then 0 else 1 end as situacao_competencia1,
						   nota_competencia2_correcao, competencia2_diferenca, case when competencia2_diferenca >= 81 then 2 when competencia2_diferenca = 0 then 0 else 1 end as situacao_competencia2,
						   nota_competencia3_correcao, competencia3_diferenca, case when competencia3_diferenca >= 81 then 2 when competencia3_diferenca = 0 then 0 else 1 end as situacao_competencia3,
						   nota_competencia4_correcao, competencia4_diferenca, case when competencia4_diferenca >= 81 then 2 when competencia4_diferenca = 0 then 0 else 1 end as situacao_competencia4,
						   nota_competencia5_correcao, competencia5_diferenca, case when competencia5_diferenca >= 81 then 2 when competencia5_diferenca = 0 then 0 else 1 end as situacao_competencia5,
						   id_auxiliar1, id_auxiliar2, id_correcao_situacao_correcao,
						   id_corretor, id_status, id_tipo_correcao,
						   case when nota_final_diferenca >= 101 then 2 when nota_final_diferenca = 0 then 0 else 1 end as situacao_nota_final,
						   case when divergencia_situacao = 'SIM' then 2 else 0 end,
						   nota_final_diferenca,id_projeto,
						   0 as conclusao_analise,
						   0 as fila,
                           cor.nota_final_gabarito,
                           cor.id_competencia1_gabarito,
                           cor.id_competencia2_gabarito,
                           cor.id_competencia3_gabarito,
                           cor.id_competencia4_gabarito,
                           cor.id_competencia5_gabarito,
                           cor.nota_competencia1_gabarito,
                           cor.nota_competencia2_gabarito,
                           cor.nota_competencia3_gabarito,
                           cor.nota_competencia4_gabarito,
                           cor.nota_competencia5_gabarito,
                           cor.id_correcao_situacao_gabarito,
                           @REDACAO_ID
					  FROM [vw_cor_batimento_gabarito] COR
					 WHERE cor.id_corretor = @ID_CORRETOR1 and
					       cor.co_barra_redacao = @CODBARRA and
						   cor.id_projeto = @ID_PROJETO

					/***** RECUPERAR O ID DA TABELA ANALISE PARA O PODERMOS INSERIR A SEGUNDA CORRECAO ******/
					set @ID_ANALISE = @@IDENTITY

			        --ATUALIZA A CONCLUSAO DA ANALISE
			        update ana set ana.conclusao_analise = 
			               case when diferenca_situacao > 0 then 5
			             when situacao_nota_final = 2  then 4
			             when (situacao_competencia1 = 2 or
			             	   situacao_competencia2 = 2 or
			             	   situacao_competencia3 = 2 or
			             	   situacao_competencia4 = 2 or
			             	   situacao_competencia5 = 2 )then 3
			             when  situacao_nota_final = 1 then 2
			             when (situacao_competencia1 = 1 or
			             	   situacao_competencia2 = 1 or
			             	   situacao_competencia3 = 1 or
			             	   situacao_competencia4 = 1 or
			             	   situacao_competencia5 = 1 )then 1 else 0 end
			              from correcoes_analise ana
			             where id = @ID_ANALISE

			   update ana set ana.nota_corretor = case  conclusao_analise when 5 then 0
                                  when 4 then 0
								  when 3 then 0
								  when 2 then 1
								  when 1 then 1
								  when 0 then 1 end,
					         ana.nota_desempenho = dbo.fn_calcula_nota_desempenho_ouro_moda(@ID_ANALISE) 
				from correcoes_analise ana 
			where id = @ID_ANALISE


			update correcoes_corretor set 
			       nota_corretor =  round(cast ((select sum(nota_corretor) * 10/ (select max_correcoes_dia 
                                                                                    from projeto_projeto proxx 
                                                                                   where proxx.id = @ID_PROJETO)
			 
			                                                 from correcoes_analise anax
															where id_corretor_A = @ID_CORRETOR1) as decimal(3,1)),2) 
			 where id = @ID_CORRETOR1



				END

			COMMIT
		END TRY
		BEGIN CATCH
			ROLLBACK
			SET @ERRO = 'O PROCESSAMENTO NAO FOI EFETUADO - ID_CORRECAO = ' + CONVERT(VARCHAR(30), @ID_CORRECAO) + ' - ' + ERROR_MESSAGE ( )
		END CATCH
	END

	IF(@ERRO = '')
		BEGIN
			SET @ERRO = 'OK'
		END

	RETURN
GO
/****** Object:  StoredProcedure [dbo].[sp_inserir_analise_gabarito_preteste]    Script Date: 16/10/2019 10:22:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  OR ALTER  procedure [dbo].[sp_inserir_analise_gabarito_preteste]
    @ID_CORRECAO INT,
    @ID_PROJETO INT,
    @ERRO VARCHAR(500) OUTPUT
AS

DECLARE @NOTA INT
DECLARE @COMP1 INT
DECLARE @COMP2 INT
DECLARE @COMP3 INT
DECLARE @COMP4 INT
DECLARE @COMP5 INT
DECLARE @ID_CORRECAO1 INT
DECLARE @ID_CORRECAO2 INT
DECLARE @ID_CORRETOR1 INT
DECLARE @ID_CORRETOR2 INT
DECLARE @ID_ANALISE INT
DECLARE @SITUACAO VARCHAR(10)
DECLARE @CODBARRA VARCHAR(50)
DECLARE @REDACAO_ID INT

DECLARE @LIMITE_NOTA_COMPETENCIA DECIMAL(10,2)
DECLARE @LIMITE_NOTA_FINAL DECIMAL(10,2)

DECLARE @RETORNOU_REGISTRO INT

SET @ERRO = ''
SET @RETORNOU_REGISTRO = 0


--Carrega os valores limites para o cálculo da discrepância e divergência
select @LIMITE_NOTA_COMPETENCIA = LIMITE_NOTA_COMPETENCIA, @LIMITE_NOTA_FINAL = LIMITE_NOTA_FINAL
  from projeto_projeto
  where id = @ID_PROJETO

SELECT @CODBARRA = CO_BARRA_REDACAO, @ID_CORRETOR1 = id_corretor, @REDACAO_ID = redacao_id
  FROM CORRECOES_CORRECAO
 WHERE ID = @ID_CORRECAO AND
       id_projeto = @ID_PROJETO

IF(@@ROWCOUNT = 0)
    BEGIN
        SET @ERRO = 'NAO EXISTE REFERENCIA PARA ESTE ID DE CORRECAO - ' + CONVERT(VARCHAR(20),@ID_CORRECAO)
    END

IF (@ERRO = '')
    BEGIN
        BEGIN TRANSACTION
        BEGIN TRY

            IF (EXISTS (SELECT 1 FROM CORRECOES_ANALISE 
                            WHERE CO_BARRA_REDACAO = @CODBARRA AND
                                id_corretor_A = @ID_CORRETOR1  AND
                                id_projeto = @ID_PROJETO)) BEGIN
                SET @ERRO = 'JÁ EXISTE'
            END


            IF (@ERRO = '')
                BEGIN
                    --PRINT 'GRAVAR NA CORRECCOES_ANALISE'
                    /*****************************************************************************************************/
                    /***** FAZER O INSERT DO PRIMEIRO CORRETOR NA TABELA ANALISE ******/
                    INSERT INTO CORRECOES_ANALISE (co_barra_redacao, data_inicio_A, data_termino_A, id_correcao_A,
                                                   link_imagem_recortada, link_imagem_original,
                                                   nota_final_A, competencia1_A, competencia2_A, competencia3_A, competencia4_A, competencia5_A,
                                                   nota_competencia1_A, diferenca_competencia1, situacao_competencia1,
                                                   nota_competencia2_A, diferenca_competencia2, situacao_competencia2,
                                                   nota_competencia3_A, diferenca_competencia3, situacao_competencia3,
                                                   nota_competencia4_A, diferenca_competencia4, situacao_competencia4,
                                                   nota_competencia5_A, diferenca_competencia5, situacao_competencia5,
                                                   id_auxiliar1_A, id_auxiliar2_A, id_correcao_situacao_A,
                                                   id_corretor_A, id_status_A, id_tipo_correcao_A, situacao_nota_final,DIFERENCA_SITUACAO,
                                                   diferenca_nota_final,id_projeto,
                                                   conclusao_analise,fila,
                                                   nota_final_b,
                                                   competencia1_b,        
                                                   competencia2_b,
                                                   competencia3_b,
                                                   competencia4_b,
                                                   competencia5_b,
                                                   nota_competencia1_b,
                                                   nota_competencia2_b,
                                                   nota_competencia3_b,
                                                   nota_competencia4_b,
                                                   nota_competencia5_b,
                                                   id_correcao_situacao_b, redacao_id
                                                    )
                    SELECT top 1 cor.co_barra_redacao, cor.data_inicio_correcao, cor.data_termino_correcao, cor.id_correcao,
                           cor.link_imagem_recortada, cor.link_imagem_original,
                           nota_final_correcao,
                           id_competencia1_correcao,
                           id_competencia2_correcao,
                           id_competencia3_correcao,
                           id_competencia4_correcao,
                           id_competencia5_correcao,
                           nota_competencia1_correcao, competencia1_diferenca, case when competencia1_diferenca >= @LIMITE_NOTA_COMPETENCIA then 2 when competencia1_diferenca = 0 then 0 else 1 end as situacao_competencia1,
                           nota_competencia2_correcao, competencia2_diferenca, case when competencia2_diferenca >= @LIMITE_NOTA_COMPETENCIA then 2 when competencia2_diferenca = 0 then 0 else 1 end as situacao_competencia2,
                           nota_competencia3_correcao, competencia3_diferenca, case when competencia3_diferenca >= @LIMITE_NOTA_COMPETENCIA then 2 when competencia3_diferenca = 0 then 0 else 1 end as situacao_competencia3,
                           nota_competencia4_correcao, competencia4_diferenca, case when competencia4_diferenca >= @LIMITE_NOTA_COMPETENCIA then 2 when competencia4_diferenca = 0 then 0 else 1 end as situacao_competencia4,
                           nota_competencia5_correcao, competencia5_diferenca, case when competencia5_diferenca >= @LIMITE_NOTA_COMPETENCIA then 2 when competencia5_diferenca = 0 then 0 else 1 end as situacao_competencia5,
                           id_auxiliar1, id_auxiliar2, id_correcao_situacao_correcao,
                           id_corretor, id_status, id_tipo_correcao,
                           case when nota_final_diferenca >= @LIMITE_NOTA_FINAL then 2 when nota_final_diferenca = 0 then 0 else 1 end as situacao_nota_final,
                           case when divergencia_situacao = 'SIM' then 2 else 0 end,
                           nota_final_diferenca,id_projeto,
                           0 as conclusao_analise,
                           0 as fila,
                           cor.nota_final_gabarito,
                           cor.id_competencia1_gabarito,
                           cor.id_competencia2_gabarito,
                           cor.id_competencia3_gabarito,
                           cor.id_competencia4_gabarito,
                           cor.id_competencia5_gabarito,
                           cor.nota_competencia1_gabarito,
                           cor.nota_competencia2_gabarito,
                           cor.nota_competencia3_gabarito,
                           cor.nota_competencia4_gabarito,
                           cor.nota_competencia5_gabarito,
                           cor.id_correcao_situacao_gabarito,
                           @REDACAO_ID
                      FROM [vw_cor_batimento_gabarito] COR
                     WHERE cor.id_corretor = @ID_CORRETOR1 and
                           cor.redacao_id = @REDACAO_ID and
                           cor.id_projeto = @ID_PROJETO

                    /***** RECUPERAR O ID DA TABELA ANALISE PARA O PODERMOS INSERIR A SEGUNDA CORRECAO ******/
                    set @ID_ANALISE = @@IDENTITY

                    --ATUALIZA A CONCLUSAO DA ANALISE
                    update ana set ana.conclusao_analise = 
                           case when diferenca_situacao > 0 then 5
                         when situacao_nota_final = 2  then 4
                         when (situacao_competencia1 = 2 or
                               situacao_competencia2 = 2 or
                               situacao_competencia3 = 2 or
                               situacao_competencia4 = 2 or
                               situacao_competencia5 = 2 )then 3
                         when  situacao_nota_final = 1 then 2
                         when (situacao_competencia1 = 1 or
                               situacao_competencia2 = 1 or
                               situacao_competencia3 = 1 or
                               situacao_competencia4 = 1 or
                               situacao_competencia5 = 1 )then 1 else 0 end
                          from correcoes_analise ana
                         where id = @ID_ANALISE

                        update ana
                           set ana.nota_corretor = (case conclusao_analise
                                                        when 5 then 0
                                                        when 4 then 0
                                                        when 3 then 0
                                                        when 2 then 1
                                                        when 1 then 1
                                                        when 0 then 1 end) * convert(decimal(10,2), ((select convert(decimal(10,2), isnull(valor, valor_padrao)) from core_parametros where nome = 'NOTA_MAXIMA_PRETESTE') / (select convert(decimal(10,2), isnull(valor, valor_padrao)) from core_parametros where nome = 'REDACOES_OURO_PRETESTE')))
                          from correcoes_analise ana
                         where id = @ID_ANALISE

                        update correcoes_corretor set 
                            nota_corretor =  round(cast ((select sum(nota_corretor)                        
                                                            from correcoes_analise anax
                                                           where id_corretor_A = @ID_CORRETOR1) as decimal(3,1)),2) 
                        where id = @ID_CORRETOR1

                END

            COMMIT
        END TRY
        BEGIN CATCH
            ROLLBACK
            SET @ERRO = 'O PROCESSAMENTO NAO FOI EFETUADO - ID_CORRECAO = ' + CONVERT(VARCHAR(30), @ID_CORRECAO) + ' - ' + ERROR_MESSAGE ( )
        END CATCH
    END

    IF(@ERRO = '')
        BEGIN
            SET @ERRO = 'OK'
        END

    RETURN

GO
/****** Object:  StoredProcedure [dbo].[sp_inserir_analise_gabarito_preteste_enem]    Script Date: 16/10/2019 10:22:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create OR ALTER   procedure [dbo].[sp_inserir_analise_gabarito_preteste_enem]
    @ID_CORRECAO INT,
    @ID_PROJETO INT,
    @ERRO VARCHAR(500) OUTPUT
AS

DECLARE @NOTA INT
DECLARE @COMP1 INT
DECLARE @COMP2 INT
DECLARE @COMP3 INT
DECLARE @COMP4 INT
DECLARE @COMP5 INT
DECLARE @ID_CORRECAO1 INT
DECLARE @ID_CORRECAO2 INT
DECLARE @ID_CORRETOR1 INT
DECLARE @ID_CORRETOR2 INT
DECLARE @ID_ANALISE INT
DECLARE @SITUACAO VARCHAR(10)
DECLARE @CODBARRA VARCHAR(50)
DECLARE @REDACAO_ID INT

DECLARE @LIMITE_NOTA_COMPETENCIA DECIMAL(10,2)
DECLARE @LIMITE_NOTA_FINAL DECIMAL(10,2)

DECLARE @RETORNOU_REGISTRO INT

SET @ERRO = ''
SET @RETORNOU_REGISTRO = 0


--Carrega os valores limites para o cálculo da discrepância e divergência
select @LIMITE_NOTA_COMPETENCIA = LIMITE_NOTA_COMPETENCIA, @LIMITE_NOTA_FINAL = LIMITE_NOTA_FINAL
  from projeto_projeto
  where id = @ID_PROJETO

SELECT @CODBARRA = CO_BARRA_REDACAO, @ID_CORRETOR1 = id_corretor, @REDACAO_ID = redacao_id
  FROM CORRECOES_CORRECAO
 WHERE ID = @ID_CORRECAO AND
       id_projeto = @ID_PROJETO

IF(@@ROWCOUNT = 0)
    BEGIN
        SET @ERRO = 'NAO EXISTE REFERENCIA PARA ESTE ID DE CORRECAO - ' + CONVERT(VARCHAR(20),@ID_CORRECAO)
    END

IF (@ERRO = '')
    BEGIN
        BEGIN TRANSACTION
        BEGIN TRY

            IF (EXISTS (SELECT 1 FROM CORRECOES_ANALISE 
                            WHERE CO_BARRA_REDACAO = @CODBARRA AND
                                id_corretor_A = @ID_CORRETOR1  AND
                                id_projeto = @ID_PROJETO)) BEGIN
                SET @ERRO = 'JÁ EXISTE'
            END


            IF (@ERRO = '')
                BEGIN
                    --PRINT 'GRAVAR NA CORRECCOES_ANALISE'
                    /*****************************************************************************************************/
                    /***** FAZER O INSERT DO PRIMEIRO CORRETOR NA TABELA ANALISE ******/
                    INSERT INTO CORRECOES_ANALISE (co_barra_redacao, data_inicio_A, data_termino_A, id_correcao_A,
                                                   link_imagem_recortada, link_imagem_original,
                                                   nota_final_A, competencia1_A, competencia2_A, competencia3_A, competencia4_A, competencia5_A,
                                                   nota_competencia1_A, diferenca_competencia1, situacao_competencia1,
                                                   nota_competencia2_A, diferenca_competencia2, situacao_competencia2,
                                                   nota_competencia3_A, diferenca_competencia3, situacao_competencia3,
                                                   nota_competencia4_A, diferenca_competencia4, situacao_competencia4,
                                                   nota_competencia5_A, diferenca_competencia5, situacao_competencia5,
                                                   id_auxiliar1_A, id_auxiliar2_A, id_correcao_situacao_A,
                                                   id_corretor_A, id_status_A, id_tipo_correcao_A, situacao_nota_final,DIFERENCA_SITUACAO,
                                                   diferenca_nota_final,id_projeto,
                                                   conclusao_analise,fila,
                                                   nota_final_b,
                                                   competencia1_b,        
                                                   competencia2_b,
                                                   competencia3_b,
                                                   competencia4_b,
                                                   competencia5_b,
                                                   nota_competencia1_b,
                                                   nota_competencia2_b,
                                                   nota_competencia3_b,
                                                   nota_competencia4_b,
                                                   nota_competencia5_b,
                                                   id_correcao_situacao_b, redacao_id
                                                    )
                    SELECT top 1 cor.co_barra_redacao, cor.data_inicio_correcao, cor.data_termino_correcao, cor.id_correcao,
                           cor.link_imagem_recortada, cor.link_imagem_original,
                           nota_final_correcao,
                           id_competencia1_correcao,
                           id_competencia2_correcao,
                           id_competencia3_correcao,
                           id_competencia4_correcao,
                           id_competencia5_correcao,
                           nota_competencia1_correcao, competencia1_diferenca, case when competencia1_diferenca >= @LIMITE_NOTA_COMPETENCIA then 2 when competencia1_diferenca = 0 then 0 else 1 end as situacao_competencia1,
                           nota_competencia2_correcao, competencia2_diferenca, case when competencia2_diferenca >= @LIMITE_NOTA_COMPETENCIA then 2 when competencia2_diferenca = 0 then 0 else 1 end as situacao_competencia2,
                           nota_competencia3_correcao, competencia3_diferenca, case when competencia3_diferenca >= @LIMITE_NOTA_COMPETENCIA then 2 when competencia3_diferenca = 0 then 0 else 1 end as situacao_competencia3,
                           nota_competencia4_correcao, competencia4_diferenca, case when competencia4_diferenca >= @LIMITE_NOTA_COMPETENCIA then 2 when competencia4_diferenca = 0 then 0 else 1 end as situacao_competencia4,
                           nota_competencia5_correcao, competencia5_diferenca, case when competencia5_diferenca >= @LIMITE_NOTA_COMPETENCIA then 2 when competencia5_diferenca = 0 then 0 else 1 end as situacao_competencia5,
                           id_auxiliar1, id_auxiliar2, id_correcao_situacao_correcao,
                           id_corretor, id_status, id_tipo_correcao,
                           case when nota_final_diferenca >= @LIMITE_NOTA_FINAL then 2 when nota_final_diferenca = 0 then 0 else 1 end as situacao_nota_final,
                           case when divergencia_situacao = 'SIM' then 2 else 0 end,
                           nota_final_diferenca,id_projeto,
                           0 as conclusao_analise,
                           0 as fila,
                           cor.nota_final_gabarito,
                           cor.id_competencia1_gabarito,
                           cor.id_competencia2_gabarito,
                           cor.id_competencia3_gabarito,
                           cor.id_competencia4_gabarito,
                           cor.id_competencia5_gabarito,
                           cor.nota_competencia1_gabarito,
                           cor.nota_competencia2_gabarito,
                           cor.nota_competencia3_gabarito,
                           cor.nota_competencia4_gabarito,
                           cor.nota_competencia5_gabarito,
                           cor.id_correcao_situacao_gabarito,
                           @REDACAO_ID
                      FROM [vw_cor_batimento_gabarito] COR
                     WHERE cor.id_corretor = @ID_CORRETOR1 and
                           cor.redacao_id = @REDACAO_ID and
                           cor.id_projeto = @ID_PROJETO

                    /***** RECUPERAR O ID DA TABELA ANALISE PARA O PODERMOS INSERIR A SEGUNDA CORRECAO ******/
                    set @ID_ANALISE = @@IDENTITY

                    --ATUALIZA A CONCLUSAO DA ANALISE
                    update ana set ana.conclusao_analise = 
                           case when diferenca_situacao > 0 then 5
                         when situacao_nota_final = 2  then 4
                         when (situacao_competencia1 = 2 or
                               situacao_competencia2 = 2 or
                               situacao_competencia3 = 2 or
                               situacao_competencia4 = 2 or
                               situacao_competencia5 = 2 )then 3
                         when  situacao_nota_final = 1 then 2
                         when (situacao_competencia1 = 1 or
                               situacao_competencia2 = 1 or
                               situacao_competencia3 = 1 or
                               situacao_competencia4 = 1 or
                               situacao_competencia5 = 1 )then 1 else 0 end
                          from correcoes_analise ana
                         where id = @ID_ANALISE

                        update ana
                           set ana.nota_corretor = dbo.fn_calcula_nota_desempenho_ouro_moda_preteste_enem(@ID_ANALISE),
                               ana.nota_desempenho = dbo.fn_calcula_nota_desempenho_ouro_moda_preteste_enem(@ID_ANALISE)
                          from correcoes_analise ana
                         where id = @ID_ANALISE

                        update correcoes_corretor set 
                            nota_corretor =  (select avg(nota_corretor)                        
                                                            from correcoes_analise anax
                                                           where id_corretor_A = @ID_CORRETOR1)
                        where id = @ID_CORRETOR1

                END

            COMMIT
        END TRY
        BEGIN CATCH
            ROLLBACK
            SET @ERRO = 'O PROCESSAMENTO NAO FOI EFETUADO - ID_CORRECAO = ' + CONVERT(VARCHAR(30), @ID_CORRECAO) + ' - ' + ERROR_MESSAGE ( )
        END CATCH
    END

    IF(@ERRO = '')
        BEGIN
            SET @ERRO = 'OK'
        END

    RETURN

GO
/****** Object:  StoredProcedure [dbo].[sp_inserir_log_erro_N]    Script Date: 16/10/2019 10:22:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*****************************************************************************************************************
*                        PROCEDURE PARA INSERIR NA TABELA DE LOG DE ERROS DOS ARQUIVOS N                         *
*                                                                                                                *
* PROCEDIMENTO QUE RECEBE O CODIGO DA CORRECAO QUE DEU ERRO, TIPO, O ARQUIVO N QUE DEU ERRO E A DESCRICAO DO     *
* ERRO                                                                                                           *
*                                                                                                                *
* BANCO_SISTEMA: CORRECAO_ENCCEJA                                                                                *
* AUTOR: WEMERSON BITTORI MADURO                                                                 DATA:07/08/2018 *
* MODIFICADO: WEMERSON BITTORI MADURO                                                            DATA:10/08/2018 *
******************************************************************************************************************/
-- SELECT * FROM inep_log_erro_N

CREATE OR ALTER PROCEDURE [dbo].[sp_inserir_log_erro_N] 
	@idCorrecao int,        /****  IDENTIFICADOR DA CORRECAO                         ***/
	@tipo_log varchar(100), /****  TIPO DO LOG { INSERT, UPDATE, DELETE,...          ***/
	@arquivo varchar(100),  /****  NOME DO ARQUIVO QUE GEROU O LOG { N02, N59, ...}  ***/
	@descricao varchar(1000),/****  DETALHAMENTO DO LOG                               ***/
	@tipo_erro varchar(1000) /****  TIPO DO ERRO QUE GEROU O LOG                      ***/
as 

insert into inep_log_erro_N (criado_em, id_correcao, tipo_log,   arquivo, des_log,     tipo_erro) 
     values                 (getdate(), @idCorrecao, @tipo_log, @arquivo, @descricao, @tipo_erro)
GO
/****** Object:  StoredProcedure [dbo].[sp_libera_correcao]    Script Date: 16/10/2019 10:22:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [dbo].[sp_libera_correcao] 
	@id_fila_pessoal int
AS

set nocount on

declare @id_correcao int
declare @id_tipo_correcao int
declare @co_barra_redacao varchar(50)
declare @corrigido_por varchar(255)
declare @id_projeto int
declare @id_grupo_corretor int

select @id_correcao = id_correcao from correcoes_filapessoal where id = @id_fila_pessoal

--Consulta dados da Correção
select @id_tipo_correcao = a.id_tipo_correcao, @co_barra_redacao = a.co_barra_redacao, @id_projeto = a.id_projeto, @id_grupo_corretor = b.id_grupo,
       @corrigido_por = ',' + (STUFF((
          SELECT ',' + convert(varchar(50), x.id_corretor)
          FROM correcoes_correcao x
          WHERE x.co_barra_redacao = a.co_barra_redacao and id <> @id_correcao
          FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 1, '')
		  ) + ','
  from correcoes_correcao a, correcoes_corretor b
 where a.id = @id_correcao and a.id_corretor = b.id

begin tran

delete from correcoes_filapessoal where id = @id_fila_pessoal
delete from ocorrencias_ocorrencia where correcao_id = @id_correcao
delete from correcoes_historicocorrecao where correcao_id = @id_correcao
delete from correcoes_correcao where id = @id_correcao

if @id_tipo_correcao = 1 begin
	insert into correcoes_fila1 (corrigido_por, id_grupo_corretor, id_projeto, co_barra_redacao)
	values (@corrigido_por, @id_grupo_corretor, @id_projeto, @co_barra_redacao);
end
if @id_tipo_correcao = 2 begin
	insert into correcoes_fila2 (corrigido_por, id_grupo_corretor, id_projeto, co_barra_redacao)
	values (@corrigido_por, @id_grupo_corretor, @id_projeto, @co_barra_redacao);
end
if @id_tipo_correcao = 3 begin
	insert into correcoes_fila3 (corrigido_por, id_grupo_corretor, id_projeto, co_barra_redacao)
	values (@corrigido_por, @id_grupo_corretor, @id_projeto, @co_barra_redacao);
end

set nocount off

print 'Correção retornada para fila' + convert(varchar(100), @id_tipo_correcao)

commit
GO
/****** Object:  StoredProcedure [dbo].[sp_WhoIsActive]    Script Date: 16/10/2019 10:22:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*********************************************************************************************
Who Is Active? v11.32 (2018-07-03)
(C) 2007-2018, Adam Machanic

Feedback: mailto:adam@dataeducation.com
Updates: http://whoisactive.com
Blog: http://dataeducation.com

License: 
	Who is Active? is free to download and use for personal, educational, and internal 
	corporate purposes, provided that this header is preserved. Redistribution or sale 
	of Who is Active?, in whole or in part, is prohibited without the author's express 
	written consent.
*********************************************************************************************/
CREATE OR ALTER  PROCEDURE [dbo].[sp_WhoIsActive]
(
--~
	--Filters--Both inclusive and exclusive
	--Set either filter to '' to disable
	--Valid filter types are: session, program, database, login, and host
	--Session is a session ID, and either 0 or '' can be used to indicate "all" sessions
	--All other filter types support % or _ as wildcards
	@filter sysname = '',
	@filter_type VARCHAR(10) = 'session',
	@not_filter sysname = '',
	@not_filter_type VARCHAR(10) = 'session',

	--Retrieve data about the calling session?
	@show_own_spid BIT = 0,

	--Retrieve data about system sessions?
	@show_system_spids BIT = 0,

	--Controls how sleeping SPIDs are handled, based on the idea of levels of interest
	--0 does not pull any sleeping SPIDs
	--1 pulls only those sleeping SPIDs that also have an open transaction
	--2 pulls all sleeping SPIDs
	@show_sleeping_spids TINYINT = 1,

	--If 1, gets the full stored procedure or running batch, when available
	--If 0, gets only the actual statement that is currently running in the batch or procedure
	@get_full_inner_text BIT = 0,

	--Get associated query plans for running tasks, if available
	--If @get_plans = 1, gets the plan based on the request's statement offset
	--If @get_plans = 2, gets the entire plan based on the request's plan_handle
	@get_plans TINYINT = 0,

	--Get the associated outer ad hoc query or stored procedure call, if available
	@get_outer_command BIT = 0,

	--Enables pulling transaction log write info and transaction duration
	@get_transaction_info BIT = 0,

	--Get information on active tasks, based on three interest levels
	--Level 0 does not pull any task-related information
	--Level 1 is a lightweight mode that pulls the top non-CXPACKET wait, giving preference to blockers
	--Level 2 pulls all available task-based metrics, including: 
	--number of active tasks, current wait stats, physical I/O, context switches, and blocker information
	@get_task_info TINYINT = 1,

	--Gets associated locks for each request, aggregated in an XML format
	@get_locks BIT = 0,

	--Get average time for past runs of an active query
	--(based on the combination of plan handle, sql handle, and offset)
	@get_avg_time BIT = 0,

	--Get additional non-performance-related information about the session or request
	--text_size, language, date_format, date_first, quoted_identifier, arithabort, ansi_null_dflt_on, 
	--ansi_defaults, ansi_warnings, ansi_padding, ansi_nulls, concat_null_yields_null, 
	--transaction_isolation_level, lock_timeout, deadlock_priority, row_count, command_type
	--
	--If a SQL Agent job is running, an subnode called agent_info will be populated with some or all of
	--the following: job_id, job_name, step_id, step_name, msdb_query_error (in the event of an error)
	--
	--If @get_task_info is set to 2 and a lock wait is detected, a subnode called block_info will be
	--populated with some or all of the following: lock_type, database_name, object_id, file_id, hobt_id, 
	--applock_hash, metadata_resource, metadata_class_id, object_name, schema_name
	@get_additional_info BIT = 0,

	--Walk the blocking chain and count the number of 
	--total SPIDs blocked all the way down by a given session
	--Also enables task_info Level 1, if @get_task_info is set to 0
	@find_block_leaders BIT = 0,

	--Pull deltas on various metrics
	--Interval in seconds to wait before doing the second data pull
	@delta_interval TINYINT = 0,

	--List of desired output columns, in desired order
	--Note that the final output will be the intersection of all enabled features and all 
	--columns in the list. Therefore, only columns associated with enabled features will 
	--actually appear in the output. Likewise, removing columns from this list may effectively
	--disable features, even if they are turned on
	--
	--Each element in this list must be one of the valid output column names. Names must be
	--delimited by square brackets. White space, formatting, and additional characters are
	--allowed, as long as the list contains exact matches of delimited valid column names.
	@output_column_list VARCHAR(8000) = '[dd%][session_id][sql_text][sql_command][login_name][wait_info][tasks][tran_log%][cpu%][temp%][block%][reads%][writes%][context%][physical%][query_plan][locks][%]',

	--Column(s) by which to sort output, optionally with sort directions. 
		--Valid column choices:
		--session_id, physical_io, reads, physical_reads, writes, tempdb_allocations, 
		--tempdb_current, CPU, context_switches, used_memory, physical_io_delta, reads_delta, 
		--physical_reads_delta, writes_delta, tempdb_allocations_delta, tempdb_current_delta, 
		--CPU_delta, context_switches_delta, used_memory_delta, tasks, tran_start_time, 
		--open_tran_count, blocking_session_id, blocked_session_count, percent_complete, 
		--host_name, login_name, database_name, start_time, login_time, program_name
		--
		--Note that column names in the list must be bracket-delimited. Commas and/or white
		--space are not required. 
	@sort_order VARCHAR(500) = '[start_time] ASC',

	--Formats some of the output columns in a more "human readable" form
	--0 disables outfput format
	--1 formats the output for variable-width fonts
	--2 formats the output for fixed-width fonts
	@format_output TINYINT = 1,

	--If set to a non-blank value, the script will attempt to insert into the specified 
	--destination table. Please note that the script will not verify that the table exists, 
	--or that it has the correct schema, before doing the insert.
	--Table can be specified in one, two, or three-part format
	@destination_table VARCHAR(4000) = '',

	--If set to 1, no data collection will happen and no result set will be returned; instead,
	--a CREATE TABLE statement will be returned via the @schema parameter, which will match 
	--the schema of the result set that would be returned by using the same collection of the
	--rest of the parameters. The CREATE TABLE statement will have a placeholder token of 
	--<table_name> in place of an actual table name.
	@return_schema BIT = 0,
	@schema VARCHAR(MAX) = NULL OUTPUT,

	--Help! What do I do?
	@help BIT = 0
--~
)
/*
OUTPUT COLUMNS
--------------
Formatted/Non:	[session_id] [smallint] NOT NULL
	Session ID (a.k.a. SPID)

Formatted:		[dd hh:mm:ss.mss] [varchar](15) NULL
Non-Formatted:	<not returned>
	For an active request, time the query has been running
	For a sleeping session, time since the last batch completed

Formatted:		[dd hh:mm:ss.mss (avg)] [varchar](15) NULL
Non-Formatted:	[avg_elapsed_time] [int] NULL
	(Requires @get_avg_time option)
	How much time has the active portion of the query taken in the past, on average?

Formatted:		[physical_io] [varchar](30) NULL
Non-Formatted:	[physical_io] [bigint] NULL
	Shows the number of physical I/Os, for active requests

Formatted:		[reads] [varchar](30) NULL
Non-Formatted:	[reads] [bigint] NULL
	For an active request, number of reads done for the current query
	For a sleeping session, total number of reads done over the lifetime of the session

Formatted:		[physical_reads] [varchar](30) NULL
Non-Formatted:	[physical_reads] [bigint] NULL
	For an active request, number of physical reads done for the current query
	For a sleeping session, total number of physical reads done over the lifetime of the session

Formatted:		[writes] [varchar](30) NULL
Non-Formatted:	[writes] [bigint] NULL
	For an active request, number of writes done for the current query
	For a sleeping session, total number of writes done over the lifetime of the session

Formatted:		[tempdb_allocations] [varchar](30) NULL
Non-Formatted:	[tempdb_allocations] [bigint] NULL
	For an active request, number of TempDB writes done for the current query
	For a sleeping session, total number of TempDB writes done over the lifetime of the session

Formatted:		[tempdb_current] [varchar](30) NULL
Non-Formatted:	[tempdb_current] [bigint] NULL
	For an active request, number of TempDB pages currently allocated for the query
	For a sleeping session, number of TempDB pages currently allocated for the session

Formatted:		[CPU] [varchar](30) NULL
Non-Formatted:	[CPU] [int] NULL
	For an active request, total CPU time consumed by the current query
	For a sleeping session, total CPU time consumed over the lifetime of the session

Formatted:		[context_switches] [varchar](30) NULL
Non-Formatted:	[context_switches] [bigint] NULL
	Shows the number of context switches, for active requests

Formatted:		[used_memory] [varchar](30) NOT NULL
Non-Formatted:	[used_memory] [bigint] NOT NULL
	For an active request, total memory consumption for the current query
	For a sleeping session, total current memory consumption

Formatted:		[physical_io_delta] [varchar](30) NULL
Non-Formatted:	[physical_io_delta] [bigint] NULL
	(Requires @delta_interval option)
	Difference between the number of physical I/Os reported on the first and second collections. 
	If the request started after the first collection, the value will be NULL

Formatted:		[reads_delta] [varchar](30) NULL
Non-Formatted:	[reads_delta] [bigint] NULL
	(Requires @delta_interval option)
	Difference between the number of reads reported on the first and second collections. 
	If the request started after the first collection, the value will be NULL

Formatted:		[physical_reads_delta] [varchar](30) NULL
Non-Formatted:	[physical_reads_delta] [bigint] NULL
	(Requires @delta_interval option)
	Difference between the number of physical reads reported on the first and second collections. 
	If the request started after the first collection, the value will be NULL

Formatted:		[writes_delta] [varchar](30) NULL
Non-Formatted:	[writes_delta] [bigint] NULL
	(Requires @delta_interval option)
	Difference between the number of writes reported on the first and second collections. 
	If the request started after the first collection, the value will be NULL

Formatted:		[tempdb_allocations_delta] [varchar](30) NULL
Non-Formatted:	[tempdb_allocations_delta] [bigint] NULL
	(Requires @delta_interval option)
	Difference between the number of TempDB writes reported on the first and second collections. 
	If the request started after the first collection, the value will be NULL

Formatted:		[tempdb_current_delta] [varchar](30) NULL
Non-Formatted:	[tempdb_current_delta] [bigint] NULL
	(Requires @delta_interval option)
	Difference between the number of allocated TempDB pages reported on the first and second 
	collections. If the request started after the first collection, the value will be NULL

Formatted:		[CPU_delta] [varchar](30) NULL
Non-Formatted:	[CPU_delta] [int] NULL
	(Requires @delta_interval option)
	Difference between the CPU time reported on the first and second collections. 
	If the request started after the first collection, the value will be NULL

Formatted:		[context_switches_delta] [varchar](30) NULL
Non-Formatted:	[context_switches_delta] [bigint] NULL
	(Requires @delta_interval option)
	Difference between the context switches count reported on the first and second collections
	If the request started after the first collection, the value will be NULL

Formatted:		[used_memory_delta] [varchar](30) NULL
Non-Formatted:	[used_memory_delta] [bigint] NULL
	Difference between the memory usage reported on the first and second collections
	If the request started after the first collection, the value will be NULL

Formatted:		[tasks] [varchar](30) NULL
Non-Formatted:	[tasks] [smallint] NULL
	Number of worker tasks currently allocated, for active requests

Formatted/Non:	[status] [varchar](30) NOT NULL
	Activity status for the session (running, sleeping, etc)

Formatted/Non:	[wait_info] [nvarchar](4000) NULL
	Aggregates wait information, in the following format:
		(Ax: Bms/Cms/Dms)E
	A is the number of waiting tasks currently waiting on resource type E. B/C/D are wait
	times, in milliseconds. If only one thread is waiting, its wait time will be shown as B.
	If two tasks are waiting, each of their wait times will be shown (B/C). If three or more 
	tasks are waiting, the minimum, average, and maximum wait times will be shown (B/C/D).
	If wait type E is a page latch wait and the page is of a "special" type (e.g. PFS, GAM, SGAM), 
	the page type will be identified.
	If wait type E is CXPACKET, the nodeId from the query plan will be identified

Formatted/Non:	[locks] [xml] NULL
	(Requires @get_locks option)
	Aggregates lock information, in XML format.
	The lock XML includes the lock mode, locked object, and aggregates the number of requests. 
	Attempts are made to identify locked objects by name

Formatted/Non:	[tran_start_time] [datetime] NULL
	(Requires @get_transaction_info option)
	Date and time that the first transaction opened by a session caused a transaction log 
	write to occur.

Formatted/Non:	[tran_log_writes] [nvarchar](4000) NULL
	(Requires @get_transaction_info option)
	Aggregates transaction log write information, in the following format:
	A:wB (C kB)
	A is a database that has been touched by an active transaction
	B is the number of log writes that have been made in the database as a result of the transaction
	C is the number of log kilobytes consumed by the log records

Formatted:		[open_tran_count] [varchar](30) NULL
Non-Formatted:	[open_tran_count] [smallint] NULL
	Shows the number of open transactions the session has open

Formatted:		[sql_command] [xml] NULL
Non-Formatted:	[sql_command] [nvarchar](max) NULL
	(Requires @get_outer_command option)
	Shows the "outer" SQL command, i.e. the text of the batch or RPC sent to the server, 
	if available

Formatted:		[sql_text] [xml] NULL
Non-Formatted:	[sql_text] [nvarchar](max) NULL
	Shows the SQL text for active requests or the last statement executed
	for sleeping sessions, if available in either case.
	If @get_full_inner_text option is set, shows the full text of the batch.
	Otherwise, shows only the active statement within the batch.
	If the query text is locked, a special timeout message will be sent, in the following format:
		<timeout_exceeded />
	If an error occurs, an error message will be sent, in the following format:
		<error message="message" />

Formatted/Non:	[query_plan] [xml] NULL
	(Requires @get_plans option)
	Shows the query plan for the request, if available.
	If the plan is locked, a special timeout message will be sent, in the following format:
		<timeout_exceeded />
	If an error occurs, an error message will be sent, in the following format:
		<error message="message" />

Formatted/Non:	[blocking_session_id] [smallint] NULL
	When applicable, shows the blocking SPID

Formatted:		[blocked_session_count] [varchar](30) NULL
Non-Formatted:	[blocked_session_count] [smallint] NULL
	(Requires @find_block_leaders option)
	The total number of SPIDs blocked by this session,
	all the way down the blocking chain.

Formatted:		[percent_complete] [varchar](30) NULL
Non-Formatted:	[percent_complete] [real] NULL
	When applicable, shows the percent complete (e.g. for backups, restores, and some rollbacks)

Formatted/Non:	[host_name] [sysname] NOT NULL
	Shows the host name for the connection

Formatted/Non:	[login_name] [sysname] NOT NULL
	Shows the login name for the connection

Formatted/Non:	[database_name] [sysname] NULL
	Shows the connected database

Formatted/Non:	[program_name] [sysname] NULL
	Shows the reported program/application name

Formatted/Non:	[additional_info] [xml] NULL
	(Requires @get_additional_info option)
	Returns additional non-performance-related session/request information
	If the script finds a SQL Agent job running, the name of the job and job step will be reported
	If @get_task_info = 2 and the script finds a lock wait, the locked object will be reported

Formatted/Non:	[start_time] [datetime] NOT NULL
	For active requests, shows the time the request started
	For sleeping sessions, shows the time the last batch completed

Formatted/Non:	[login_time] [datetime] NOT NULL
	Shows the time that the session connected

Formatted/Non:	[request_id] [int] NULL
	For active requests, shows the request_id
	Should be 0 unless MARS is being used

Formatted/Non:	[collection_time] [datetime] NOT NULL
	Time that this script's final SELECT ran
*/
AS
BEGIN;
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET QUOTED_IDENTIFIER ON;
	SET ANSI_PADDING ON;
	SET CONCAT_NULL_YIELDS_NULL ON;
	SET ANSI_WARNINGS ON;
	SET NUMERIC_ROUNDABORT OFF;
	SET ARITHABORT ON;

	IF
		@filter IS NULL
		OR @filter_type IS NULL
		OR @not_filter IS NULL
		OR @not_filter_type IS NULL
		OR @show_own_spid IS NULL
		OR @show_system_spids IS NULL
		OR @show_sleeping_spids IS NULL
		OR @get_full_inner_text IS NULL
		OR @get_plans IS NULL
		OR @get_outer_command IS NULL
		OR @get_transaction_info IS NULL
		OR @get_task_info IS NULL
		OR @get_locks IS NULL
		OR @get_avg_time IS NULL
		OR @get_additional_info IS NULL
		OR @find_block_leaders IS NULL
		OR @delta_interval IS NULL
		OR @format_output IS NULL
		OR @output_column_list IS NULL
		OR @sort_order IS NULL
		OR @return_schema IS NULL
		OR @destination_table IS NULL
		OR @help IS NULL
	BEGIN;
		RAISERROR('Input parameters cannot be NULL', 16, 1);
		RETURN;
	END;
	
	IF @filter_type NOT IN ('session', 'program', 'database', 'login', 'host')
	BEGIN;
		RAISERROR('Valid filter types are: session, program, database, login, host', 16, 1);
		RETURN;
	END;
	
	IF @filter_type = 'session' AND @filter LIKE '%[^0123456789]%'
	BEGIN;
		RAISERROR('Session filters must be valid integers', 16, 1);
		RETURN;
	END;
	
	IF @not_filter_type NOT IN ('session', 'program', 'database', 'login', 'host')
	BEGIN;
		RAISERROR('Valid filter types are: session, program, database, login, host', 16, 1);
		RETURN;
	END;
	
	IF @not_filter_type = 'session' AND @not_filter LIKE '%[^0123456789]%'
	BEGIN;
		RAISERROR('Session filters must be valid integers', 16, 1);
		RETURN;
	END;
	
	IF @show_sleeping_spids NOT IN (0, 1, 2)
	BEGIN;
		RAISERROR('Valid values for @show_sleeping_spids are: 0, 1, or 2', 16, 1);
		RETURN;
	END;
	
	IF @get_plans NOT IN (0, 1, 2)
	BEGIN;
		RAISERROR('Valid values for @get_plans are: 0, 1, or 2', 16, 1);
		RETURN;
	END;

	IF @get_task_info NOT IN (0, 1, 2)
	BEGIN;
		RAISERROR('Valid values for @get_task_info are: 0, 1, or 2', 16, 1);
		RETURN;
	END;

	IF @format_output NOT IN (0, 1, 2)
	BEGIN;
		RAISERROR('Valid values for @format_output are: 0, 1, or 2', 16, 1);
		RETURN;
	END;
	
	IF @help = 1
	BEGIN;
		DECLARE 
			@header VARCHAR(MAX),
			@params VARCHAR(MAX),
			@outputs VARCHAR(MAX);

		SELECT 
			@header =
				REPLACE
				(
					REPLACE
					(
						CONVERT
						(
							VARCHAR(MAX),
							SUBSTRING
							(
								t.text, 
								CHARINDEX('/' + REPLICATE('*', 93), t.text) + 94,
								CHARINDEX(REPLICATE('*', 93) + '/', t.text) - (CHARINDEX('/' + REPLICATE('*', 93), t.text) + 94)
							)
						),
						CHAR(13)+CHAR(10),
						CHAR(13)
					),
					'	',
					''
				),
			@params =
				CHAR(13) +
					REPLACE
					(
						REPLACE
						(
							CONVERT
							(
								VARCHAR(MAX),
								SUBSTRING
								(
									t.text, 
									CHARINDEX('--~', t.text) + 5, 
									CHARINDEX('--~', t.text, CHARINDEX('--~', t.text) + 5) - (CHARINDEX('--~', t.text) + 5)
								)
							),
							CHAR(13)+CHAR(10),
							CHAR(13)
						),
						'	',
						''
					),
				@outputs = 
					CHAR(13) +
						REPLACE
						(
							REPLACE
							(
								REPLACE
								(
									CONVERT
									(
										VARCHAR(MAX),
										SUBSTRING
										(
											t.text, 
											CHARINDEX('OUTPUT COLUMNS'+CHAR(13)+CHAR(10)+'--------------', t.text) + 32,
											CHARINDEX('*/', t.text, CHARINDEX('OUTPUT COLUMNS'+CHAR(13)+CHAR(10)+'--------------', t.text) + 32) - (CHARINDEX('OUTPUT COLUMNS'+CHAR(13)+CHAR(10)+'--------------', t.text) + 32)
										)
									),
									CHAR(9),
									CHAR(255)
								),
								CHAR(13)+CHAR(10),
								CHAR(13)
							),
							'	',
							''
						) +
						CHAR(13)
		FROM sys.dm_exec_requests AS r
		CROSS APPLY sys.dm_exec_sql_text(r.sql_handle) AS t
		WHERE
			r.session_id = @@SPID;

		WITH
		a0 AS
		(SELECT 1 AS n UNION ALL SELECT 1),
		a1 AS
		(SELECT 1 AS n FROM a0 AS a, a0 AS b),
		a2 AS
		(SELECT 1 AS n FROM a1 AS a, a1 AS b),
		a3 AS
		(SELECT 1 AS n FROM a2 AS a, a2 AS b),
		a4 AS
		(SELECT 1 AS n FROM a3 AS a, a3 AS b),
		numbers AS
		(
			SELECT TOP(LEN(@header) - 1)
				ROW_NUMBER() OVER
				(
					ORDER BY (SELECT NULL)
				) AS number
			FROM a4
			ORDER BY
				number
		)
		SELECT
			RTRIM(LTRIM(
				SUBSTRING
				(
					@header,
					number + 1,
					CHARINDEX(CHAR(13), @header, number + 1) - number - 1
				)
			)) AS [------header---------------------------------------------------------------------------------------------------------------]
		FROM numbers
		WHERE
			SUBSTRING(@header, number, 1) = CHAR(13);

		WITH
		a0 AS
		(SELECT 1 AS n UNION ALL SELECT 1),
		a1 AS
		(SELECT 1 AS n FROM a0 AS a, a0 AS b),
		a2 AS
		(SELECT 1 AS n FROM a1 AS a, a1 AS b),
		a3 AS
		(SELECT 1 AS n FROM a2 AS a, a2 AS b),
		a4 AS
		(SELECT 1 AS n FROM a3 AS a, a3 AS b),
		numbers AS
		(
			SELECT TOP(LEN(@params) - 1)
				ROW_NUMBER() OVER
				(
					ORDER BY (SELECT NULL)
				) AS number
			FROM a4
			ORDER BY
				number
		),
		tokens AS
		(
			SELECT 
				RTRIM(LTRIM(
					SUBSTRING
					(
						@params,
						number + 1,
						CHARINDEX(CHAR(13), @params, number + 1) - number - 1
					)
				)) AS token,
				number,
				CASE
					WHEN SUBSTRING(@params, number + 1, 1) = CHAR(13) THEN number
					ELSE COALESCE(NULLIF(CHARINDEX(',' + CHAR(13) + CHAR(13), @params, number), 0), LEN(@params)) 
				END AS param_group,
				ROW_NUMBER() OVER
				(
					PARTITION BY
						CHARINDEX(',' + CHAR(13) + CHAR(13), @params, number),
						SUBSTRING(@params, number+1, 1)
					ORDER BY 
						number
				) AS group_order
			FROM numbers
			WHERE
				SUBSTRING(@params, number, 1) = CHAR(13)
		),
		parsed_tokens AS
		(
			SELECT
				MIN
				(
					CASE
						WHEN token LIKE '@%' THEN token
						ELSE NULL
					END
				) AS parameter,
				MIN
				(
					CASE
						WHEN token LIKE '--%' THEN RIGHT(token, LEN(token) - 2)
						ELSE NULL
					END
				) AS description,
				param_group,
				group_order
			FROM tokens
			WHERE
				NOT 
				(
					token = '' 
					AND group_order > 1
				)
			GROUP BY
				param_group,
				group_order
		)
		SELECT
			CASE
				WHEN description IS NULL AND parameter IS NULL THEN '-------------------------------------------------------------------------'
				WHEN param_group = MAX(param_group) OVER() THEN parameter
				ELSE COALESCE(LEFT(parameter, LEN(parameter) - 1), '')
			END AS [------parameter----------------------------------------------------------],
			CASE
				WHEN description IS NULL AND parameter IS NULL THEN '----------------------------------------------------------------------------------------------------------------------'
				ELSE COALESCE(description, '')
			END AS [------description-----------------------------------------------------------------------------------------------------]
		FROM parsed_tokens
		ORDER BY
			param_group, 
			group_order;
		
		WITH
		a0 AS
		(SELECT 1 AS n UNION ALL SELECT 1),
		a1 AS
		(SELECT 1 AS n FROM a0 AS a, a0 AS b),
		a2 AS
		(SELECT 1 AS n FROM a1 AS a, a1 AS b),
		a3 AS
		(SELECT 1 AS n FROM a2 AS a, a2 AS b),
		a4 AS
		(SELECT 1 AS n FROM a3 AS a, a3 AS b),
		numbers AS
		(
			SELECT TOP(LEN(@outputs) - 1)
				ROW_NUMBER() OVER
				(
					ORDER BY (SELECT NULL)
				) AS number
			FROM a4
			ORDER BY
				number
		),
		tokens AS
		(
			SELECT 
				RTRIM(LTRIM(
					SUBSTRING
					(
						@outputs,
						number + 1,
						CASE
							WHEN 
								COALESCE(NULLIF(CHARINDEX(CHAR(13) + 'Formatted', @outputs, number + 1), 0), LEN(@outputs)) < 
								COALESCE(NULLIF(CHARINDEX(CHAR(13) + CHAR(255) COLLATE Latin1_General_Bin2, @outputs, number + 1), 0), LEN(@outputs))
								THEN COALESCE(NULLIF(CHARINDEX(CHAR(13) + 'Formatted', @outputs, number + 1), 0), LEN(@outputs)) - number - 1
							ELSE
								COALESCE(NULLIF(CHARINDEX(CHAR(13) + CHAR(255) COLLATE Latin1_General_Bin2, @outputs, number + 1), 0), LEN(@outputs)) - number - 1
						END
					)
				)) AS token,
				number,
				COALESCE(NULLIF(CHARINDEX(CHAR(13) + 'Formatted', @outputs, number + 1), 0), LEN(@outputs)) AS output_group,
				ROW_NUMBER() OVER
				(
					PARTITION BY 
						COALESCE(NULLIF(CHARINDEX(CHAR(13) + 'Formatted', @outputs, number + 1), 0), LEN(@outputs))
					ORDER BY
						number
				) AS output_group_order
			FROM numbers
			WHERE
				SUBSTRING(@outputs, number, 10) = CHAR(13) + 'Formatted'
				OR SUBSTRING(@outputs, number, 2) = CHAR(13) + CHAR(255) COLLATE Latin1_General_Bin2
		),
		output_tokens AS
		(
			SELECT 
				*,
				CASE output_group_order
					WHEN 2 THEN MAX(CASE output_group_order WHEN 1 THEN token ELSE NULL END) OVER (PARTITION BY output_group)
					ELSE ''
				END COLLATE Latin1_General_Bin2 AS column_info
			FROM tokens
		)
		SELECT
			CASE output_group_order
				WHEN 1 THEN '-----------------------------------'
				WHEN 2 THEN 
					CASE
						WHEN CHARINDEX('Formatted/Non:', column_info) = 1 THEN
							SUBSTRING(column_info, CHARINDEX(CHAR(255) COLLATE Latin1_General_Bin2, column_info)+1, CHARINDEX(']', column_info, CHARINDEX(CHAR(255) COLLATE Latin1_General_Bin2, column_info)+2) - CHARINDEX(CHAR(255) COLLATE Latin1_General_Bin2, column_info))
						ELSE
							SUBSTRING(column_info, CHARINDEX(CHAR(255) COLLATE Latin1_General_Bin2, column_info)+2, CHARINDEX(']', column_info, CHARINDEX(CHAR(255) COLLATE Latin1_General_Bin2, column_info)+2) - CHARINDEX(CHAR(255) COLLATE Latin1_General_Bin2, column_info)-1)
					END
				ELSE ''
			END AS formatted_column_name,
			CASE output_group_order
				WHEN 1 THEN '-----------------------------------'
				WHEN 2 THEN 
					CASE
						WHEN CHARINDEX('Formatted/Non:', column_info) = 1 THEN
							SUBSTRING(column_info, CHARINDEX(']', column_info)+2, LEN(column_info))
						ELSE
							SUBSTRING(column_info, CHARINDEX(']', column_info)+2, CHARINDEX('Non-Formatted:', column_info, CHARINDEX(']', column_info)+2) - CHARINDEX(']', column_info)-3)
					END
				ELSE ''
			END AS formatted_column_type,
			CASE output_group_order
				WHEN 1 THEN '---------------------------------------'
				WHEN 2 THEN 
					CASE
						WHEN CHARINDEX('Formatted/Non:', column_info) = 1 THEN ''
						ELSE
							CASE
								WHEN SUBSTRING(column_info, CHARINDEX(CHAR(255) COLLATE Latin1_General_Bin2, column_info, CHARINDEX('Non-Formatted:', column_info))+1, 1) = '<' THEN
									SUBSTRING(column_info, CHARINDEX(CHAR(255) COLLATE Latin1_General_Bin2, column_info, CHARINDEX('Non-Formatted:', column_info))+1, CHARINDEX('>', column_info, CHARINDEX(CHAR(255) COLLATE Latin1_General_Bin2, column_info, CHARINDEX('Non-Formatted:', column_info))+1) - CHARINDEX(CHAR(255) COLLATE Latin1_General_Bin2, column_info, CHARINDEX('Non-Formatted:', column_info)))
								ELSE
									SUBSTRING(column_info, CHARINDEX(CHAR(255) COLLATE Latin1_General_Bin2, column_info, CHARINDEX('Non-Formatted:', column_info))+1, CHARINDEX(']', column_info, CHARINDEX(CHAR(255) COLLATE Latin1_General_Bin2, column_info, CHARINDEX('Non-Formatted:', column_info))+1) - CHARINDEX(CHAR(255) COLLATE Latin1_General_Bin2, column_info, CHARINDEX('Non-Formatted:', column_info)))
							END
					END
				ELSE ''
			END AS unformatted_column_name,
			CASE output_group_order
				WHEN 1 THEN '---------------------------------------'
				WHEN 2 THEN 
					CASE
						WHEN CHARINDEX('Formatted/Non:', column_info) = 1 THEN ''
						ELSE
							CASE
								WHEN SUBSTRING(column_info, CHARINDEX(CHAR(255) COLLATE Latin1_General_Bin2, column_info, CHARINDEX('Non-Formatted:', column_info))+1, 1) = '<' THEN ''
								ELSE
									SUBSTRING(column_info, CHARINDEX(']', column_info, CHARINDEX('Non-Formatted:', column_info))+2, CHARINDEX('Non-Formatted:', column_info, CHARINDEX(']', column_info)+2) - CHARINDEX(']', column_info)-3)
							END
					END
				ELSE ''
			END AS unformatted_column_type,
			CASE output_group_order
				WHEN 1 THEN '----------------------------------------------------------------------------------------------------------------------'
				ELSE REPLACE(token, CHAR(255) COLLATE Latin1_General_Bin2, '')
			END AS [------description-----------------------------------------------------------------------------------------------------]
		FROM output_tokens
		WHERE
			NOT 
			(
				output_group_order = 1 
				AND output_group = LEN(@outputs)
			)
		ORDER BY
			output_group,
			CASE output_group_order
				WHEN 1 THEN 99
				ELSE output_group_order
			END;

		RETURN;
	END;

	WITH
	a0 AS
	(SELECT 1 AS n UNION ALL SELECT 1),
	a1 AS
	(SELECT 1 AS n FROM a0 AS a, a0 AS b),
	a2 AS
	(SELECT 1 AS n FROM a1 AS a, a1 AS b),
	a3 AS
	(SELECT 1 AS n FROM a2 AS a, a2 AS b),
	a4 AS
	(SELECT 1 AS n FROM a3 AS a, a3 AS b),
	numbers AS
	(
		SELECT TOP(LEN(@output_column_list))
			ROW_NUMBER() OVER
			(
				ORDER BY (SELECT NULL)
			) AS number
		FROM a4
		ORDER BY
			number
	),
	tokens AS
	(
		SELECT 
			'|[' +
				SUBSTRING
				(
					@output_column_list,
					number + 1,
					CHARINDEX(']', @output_column_list, number) - number - 1
				) + '|]' AS token,
			number
		FROM numbers
		WHERE
			SUBSTRING(@output_column_list, number, 1) = '['
	),
	ordered_columns AS
	(
		SELECT
			x.column_name,
			ROW_NUMBER() OVER
			(
				PARTITION BY
					x.column_name
				ORDER BY
					tokens.number,
					x.default_order
			) AS r,
			ROW_NUMBER() OVER
			(
				ORDER BY
					tokens.number,
					x.default_order
			) AS s
		FROM tokens
		JOIN
		(
			SELECT '[session_id]' AS column_name, 1 AS default_order
			UNION ALL
			SELECT '[dd hh:mm:ss.mss]', 2
			WHERE
				@format_output IN (1, 2)
			UNION ALL
			SELECT '[dd hh:mm:ss.mss (avg)]', 3
			WHERE
				@format_output IN (1, 2)
				AND @get_avg_time = 1
			UNION ALL
			SELECT '[avg_elapsed_time]', 4
			WHERE
				@format_output = 0
				AND @get_avg_time = 1
			UNION ALL
			SELECT '[physical_io]', 5
			WHERE
				@get_task_info = 2
			UNION ALL
			SELECT '[reads]', 6
			UNION ALL
			SELECT '[physical_reads]', 7
			UNION ALL
			SELECT '[writes]', 8
			UNION ALL
			SELECT '[tempdb_allocations]', 9
			UNION ALL
			SELECT '[tempdb_current]', 10
			UNION ALL
			SELECT '[CPU]', 11
			UNION ALL
			SELECT '[context_switches]', 12
			WHERE
				@get_task_info = 2
			UNION ALL
			SELECT '[used_memory]', 13
			UNION ALL
			SELECT '[physical_io_delta]', 14
			WHERE
				@delta_interval > 0	
				AND @get_task_info = 2
			UNION ALL
			SELECT '[reads_delta]', 15
			WHERE
				@delta_interval > 0
			UNION ALL
			SELECT '[physical_reads_delta]', 16
			WHERE
				@delta_interval > 0
			UNION ALL
			SELECT '[writes_delta]', 17
			WHERE
				@delta_interval > 0
			UNION ALL
			SELECT '[tempdb_allocations_delta]', 18
			WHERE
				@delta_interval > 0
			UNION ALL
			SELECT '[tempdb_current_delta]', 19
			WHERE
				@delta_interval > 0
			UNION ALL
			SELECT '[CPU_delta]', 20
			WHERE
				@delta_interval > 0
			UNION ALL
			SELECT '[context_switches_delta]', 21
			WHERE
				@delta_interval > 0
				AND @get_task_info = 2
			UNION ALL
			SELECT '[used_memory_delta]', 22
			WHERE
				@delta_interval > 0
			UNION ALL
			SELECT '[tasks]', 23
			WHERE
				@get_task_info = 2
			UNION ALL
			SELECT '[status]', 24
			UNION ALL
			SELECT '[wait_info]', 25
			WHERE
				@get_task_info > 0
				OR @find_block_leaders = 1
			UNION ALL
			SELECT '[locks]', 26
			WHERE
				@get_locks = 1
			UNION ALL
			SELECT '[tran_start_time]', 27
			WHERE
				@get_transaction_info = 1
			UNION ALL
			SELECT '[tran_log_writes]', 28
			WHERE
				@get_transaction_info = 1
			UNION ALL
			SELECT '[open_tran_count]', 29
			UNION ALL
			SELECT '[sql_command]', 30
			WHERE
				@get_outer_command = 1
			UNION ALL
			SELECT '[sql_text]', 31
			UNION ALL
			SELECT '[query_plan]', 32
			WHERE
				@get_plans >= 1
			UNION ALL
			SELECT '[blocking_session_id]', 33
			WHERE
				@get_task_info > 0
				OR @find_block_leaders = 1
			UNION ALL
			SELECT '[blocked_session_count]', 34
			WHERE
				@find_block_leaders = 1
			UNION ALL
			SELECT '[percent_complete]', 35
			UNION ALL
			SELECT '[host_name]', 36
			UNION ALL
			SELECT '[login_name]', 37
			UNION ALL
			SELECT '[database_name]', 38
			UNION ALL
			SELECT '[program_name]', 39
			UNION ALL
			SELECT '[additional_info]', 40
			WHERE
				@get_additional_info = 1
			UNION ALL
			SELECT '[start_time]', 41
			UNION ALL
			SELECT '[login_time]', 42
			UNION ALL
			SELECT '[request_id]', 43
			UNION ALL
			SELECT '[collection_time]', 44
		) AS x ON 
			x.column_name LIKE token ESCAPE '|'
	)
	SELECT
		@output_column_list =
			STUFF
			(
				(
					SELECT
						',' + column_name as [text()]
					FROM ordered_columns
					WHERE
						r = 1
					ORDER BY
						s
					FOR XML
						PATH('')
				),
				1,
				1,
				''
			);
	
	IF COALESCE(RTRIM(@output_column_list), '') = ''
	BEGIN;
		RAISERROR('No valid column matches found in @output_column_list or no columns remain due to selected options.', 16, 1);
		RETURN;
	END;
	
	IF @destination_table <> ''
	BEGIN;
		SET @destination_table = 
			--database
			COALESCE(QUOTENAME(PARSENAME(@destination_table, 3)) + '.', '') +
			--schema
			COALESCE(QUOTENAME(PARSENAME(@destination_table, 2)) + '.', '') +
			--table
			COALESCE(QUOTENAME(PARSENAME(@destination_table, 1)), '');
			
		IF COALESCE(RTRIM(@destination_table), '') = ''
		BEGIN;
			RAISERROR('Destination table not properly formatted.', 16, 1);
			RETURN;
		END;
	END;

	WITH
	a0 AS
	(SELECT 1 AS n UNION ALL SELECT 1),
	a1 AS
	(SELECT 1 AS n FROM a0 AS a, a0 AS b),
	a2 AS
	(SELECT 1 AS n FROM a1 AS a, a1 AS b),
	a3 AS
	(SELECT 1 AS n FROM a2 AS a, a2 AS b),
	a4 AS
	(SELECT 1 AS n FROM a3 AS a, a3 AS b),
	numbers AS
	(
		SELECT TOP(LEN(@sort_order))
			ROW_NUMBER() OVER
			(
				ORDER BY (SELECT NULL)
			) AS number
		FROM a4
		ORDER BY
			number
	),
	tokens AS
	(
		SELECT 
			'|[' +
				SUBSTRING
				(
					@sort_order,
					number + 1,
					CHARINDEX(']', @sort_order, number) - number - 1
				) + '|]' AS token,
			SUBSTRING
			(
				@sort_order,
				CHARINDEX(']', @sort_order, number) + 1,
				COALESCE(NULLIF(CHARINDEX('[', @sort_order, CHARINDEX(']', @sort_order, number)), 0), LEN(@sort_order)) - CHARINDEX(']', @sort_order, number)
			) AS next_chunk,
			number
		FROM numbers
		WHERE
			SUBSTRING(@sort_order, number, 1) = '['
	),
	ordered_columns AS
	(
		SELECT
			x.column_name +
				CASE
					WHEN tokens.next_chunk LIKE '%asc%' THEN ' ASC'
					WHEN tokens.next_chunk LIKE '%desc%' THEN ' DESC'
					ELSE ''
				END AS column_name,
			ROW_NUMBER() OVER
			(
				PARTITION BY
					x.column_name
				ORDER BY
					tokens.number
			) AS r,
			tokens.number
		FROM tokens
		JOIN
		(
			SELECT '[session_id]' AS column_name
			UNION ALL
			SELECT '[physical_io]'
			UNION ALL
			SELECT '[reads]'
			UNION ALL
			SELECT '[physical_reads]'
			UNION ALL
			SELECT '[writes]'
			UNION ALL
			SELECT '[tempdb_allocations]'
			UNION ALL
			SELECT '[tempdb_current]'
			UNION ALL
			SELECT '[CPU]'
			UNION ALL
			SELECT '[context_switches]'
			UNION ALL
			SELECT '[used_memory]'
			UNION ALL
			SELECT '[physical_io_delta]'
			UNION ALL
			SELECT '[reads_delta]'
			UNION ALL
			SELECT '[physical_reads_delta]'
			UNION ALL
			SELECT '[writes_delta]'
			UNION ALL
			SELECT '[tempdb_allocations_delta]'
			UNION ALL
			SELECT '[tempdb_current_delta]'
			UNION ALL
			SELECT '[CPU_delta]'
			UNION ALL
			SELECT '[context_switches_delta]'
			UNION ALL
			SELECT '[used_memory_delta]'
			UNION ALL
			SELECT '[tasks]'
			UNION ALL
			SELECT '[tran_start_time]'
			UNION ALL
			SELECT '[open_tran_count]'
			UNION ALL
			SELECT '[blocking_session_id]'
			UNION ALL
			SELECT '[blocked_session_count]'
			UNION ALL
			SELECT '[percent_complete]'
			UNION ALL
			SELECT '[host_name]'
			UNION ALL
			SELECT '[login_name]'
			UNION ALL
			SELECT '[database_name]'
			UNION ALL
			SELECT '[start_time]'
			UNION ALL
			SELECT '[login_time]'
			UNION ALL
			SELECT '[program_name]'
		) AS x ON 
			x.column_name LIKE token ESCAPE '|'
	)
	SELECT
		@sort_order = COALESCE(z.sort_order, '')
	FROM
	(
		SELECT
			STUFF
			(
				(
					SELECT
						',' + column_name as [text()]
					FROM ordered_columns
					WHERE
						r = 1
					ORDER BY
						number
					FOR XML
						PATH('')
				),
				1,
				1,
				''
			) AS sort_order
	) AS z;

	CREATE TABLE #sessions
	(
		recursion SMALLINT NOT NULL,
		session_id SMALLINT NOT NULL,
		request_id INT NOT NULL,
		session_number INT NOT NULL,
		elapsed_time INT NOT NULL,
		avg_elapsed_time INT NULL,
		physical_io BIGINT NULL,
		reads BIGINT NULL,
		physical_reads BIGINT NULL,
		writes BIGINT NULL,
		tempdb_allocations BIGINT NULL,
		tempdb_current BIGINT NULL,
		CPU INT NULL,
		thread_CPU_snapshot BIGINT NULL,
		context_switches BIGINT NULL,
		used_memory BIGINT NOT NULL, 
		tasks SMALLINT NULL,
		status VARCHAR(30) NOT NULL,
		wait_info NVARCHAR(4000) NULL,
		locks XML NULL,
		transaction_id BIGINT NULL,
		tran_start_time DATETIME NULL,
		tran_log_writes NVARCHAR(4000) NULL,
		open_tran_count SMALLINT NULL,
		sql_command XML NULL,
		sql_handle VARBINARY(64) NULL,
		statement_start_offset INT NULL,
		statement_end_offset INT NULL,
		sql_text XML NULL,
		plan_handle VARBINARY(64) NULL,
		query_plan XML NULL,
		blocking_session_id SMALLINT NULL,
		blocked_session_count SMALLINT NULL,
		percent_complete REAL NULL,
		host_name sysname NULL,
		login_name sysname NOT NULL,
		database_name sysname NULL,
		program_name sysname NULL,
		additional_info XML NULL,
		start_time DATETIME NOT NULL,
		login_time DATETIME NULL,
		last_request_start_time DATETIME NULL,
		PRIMARY KEY CLUSTERED (session_id, request_id, recursion) WITH (IGNORE_DUP_KEY = ON),
		UNIQUE NONCLUSTERED (transaction_id, session_id, request_id, recursion) WITH (IGNORE_DUP_KEY = ON)
	);

	IF @return_schema = 0
	BEGIN;
		--Disable unnecessary autostats on the table
		CREATE STATISTICS s_session_id ON #sessions (session_id)
		WITH SAMPLE 0 ROWS, NORECOMPUTE;
		CREATE STATISTICS s_request_id ON #sessions (request_id)
		WITH SAMPLE 0 ROWS, NORECOMPUTE;
		CREATE STATISTICS s_transaction_id ON #sessions (transaction_id)
		WITH SAMPLE 0 ROWS, NORECOMPUTE;
		CREATE STATISTICS s_session_number ON #sessions (session_number)
		WITH SAMPLE 0 ROWS, NORECOMPUTE;
		CREATE STATISTICS s_status ON #sessions (status)
		WITH SAMPLE 0 ROWS, NORECOMPUTE;
		CREATE STATISTICS s_start_time ON #sessions (start_time)
		WITH SAMPLE 0 ROWS, NORECOMPUTE;
		CREATE STATISTICS s_last_request_start_time ON #sessions (last_request_start_time)
		WITH SAMPLE 0 ROWS, NORECOMPUTE;
		CREATE STATISTICS s_recursion ON #sessions (recursion)
		WITH SAMPLE 0 ROWS, NORECOMPUTE;

		DECLARE @recursion SMALLINT;
		SET @recursion = 
			CASE @delta_interval
				WHEN 0 THEN 1
				ELSE -1
			END;

		DECLARE @first_collection_ms_ticks BIGINT;
		DECLARE @last_collection_start DATETIME;
		DECLARE @sys_info BIT;
		SET @sys_info = ISNULL(CONVERT(BIT, SIGN(OBJECT_ID('sys.dm_os_sys_info'))), 0);

		--Used for the delta pull
		REDO:;
		
		IF 
			@get_locks = 1 
			AND @recursion = 1
			AND @output_column_list LIKE '%|[locks|]%' ESCAPE '|'
		BEGIN;
			SELECT
				y.resource_type,
				y.database_name,
				y.object_id,
				y.file_id,
				y.page_type,
				y.hobt_id,
				y.allocation_unit_id,
				y.index_id,
				y.schema_id,
				y.principal_id,
				y.request_mode,
				y.request_status,
				y.session_id,
				y.resource_description,
				y.request_count,
				s.request_id,
				s.start_time,
				CONVERT(sysname, NULL) AS object_name,
				CONVERT(sysname, NULL) AS index_name,
				CONVERT(sysname, NULL) AS schema_name,
				CONVERT(sysname, NULL) AS principal_name,
				CONVERT(NVARCHAR(2048), NULL) AS query_error
			INTO #locks
			FROM
			(
				SELECT
					sp.spid AS session_id,
					CASE sp.status
						WHEN 'sleeping' THEN CONVERT(INT, 0)
						ELSE sp.request_id
					END AS request_id,
					CASE sp.status
						WHEN 'sleeping' THEN sp.last_batch
						ELSE COALESCE(req.start_time, sp.last_batch)
					END AS start_time,
					sp.dbid
				FROM sys.sysprocesses AS sp
				OUTER APPLY
				(
					SELECT TOP(1)
						CASE
							WHEN 
							(
								sp.hostprocess > ''
								OR r.total_elapsed_time < 0
							) THEN
								r.start_time
							ELSE
								DATEADD
								(
									ms, 
									1000 * (DATEPART(ms, DATEADD(second, -(r.total_elapsed_time / 1000), GETDATE())) / 500) - DATEPART(ms, DATEADD(second, -(r.total_elapsed_time / 1000), GETDATE())), 
									DATEADD(second, -(r.total_elapsed_time / 1000), GETDATE())
								)
						END AS start_time
					FROM sys.dm_exec_requests AS r
					WHERE
						r.session_id = sp.spid
						AND r.request_id = sp.request_id
				) AS req
				WHERE
					--Process inclusive filter
					1 =
						CASE
							WHEN @filter <> '' THEN
								CASE @filter_type
									WHEN 'session' THEN
										CASE
											WHEN
												CONVERT(SMALLINT, @filter) = 0
												OR sp.spid = CONVERT(SMALLINT, @filter)
													THEN 1
											ELSE 0
										END
									WHEN 'program' THEN
										CASE
											WHEN sp.program_name LIKE @filter THEN 1
											ELSE 0
										END
									WHEN 'login' THEN
										CASE
											WHEN sp.loginame LIKE @filter THEN 1
											ELSE 0
										END
									WHEN 'host' THEN
										CASE
											WHEN sp.hostname LIKE @filter THEN 1
											ELSE 0
										END
									WHEN 'database' THEN
										CASE
											WHEN DB_NAME(sp.dbid) LIKE @filter THEN 1
											ELSE 0
										END
									ELSE 0
								END
							ELSE 1
						END
					--Process exclusive filter
					AND 0 =
						CASE
							WHEN @not_filter <> '' THEN
								CASE @not_filter_type
									WHEN 'session' THEN
										CASE
											WHEN sp.spid = CONVERT(SMALLINT, @not_filter) THEN 1
											ELSE 0
										END
									WHEN 'program' THEN
										CASE
											WHEN sp.program_name LIKE @not_filter THEN 1
											ELSE 0
										END
									WHEN 'login' THEN
										CASE
											WHEN sp.loginame LIKE @not_filter THEN 1
											ELSE 0
										END
									WHEN 'host' THEN
										CASE
											WHEN sp.hostname LIKE @not_filter THEN 1
											ELSE 0
										END
									WHEN 'database' THEN
										CASE
											WHEN DB_NAME(sp.dbid) LIKE @not_filter THEN 1
											ELSE 0
										END
									ELSE 0
								END
							ELSE 0
						END
					AND 
					(
						@show_own_spid = 1
						OR sp.spid <> @@SPID
					)
					AND 
					(
						@show_system_spids = 1
						OR sp.hostprocess > ''
					)
					AND sp.ecid = 0
			) AS s
			INNER HASH JOIN
			(
				SELECT
					x.resource_type,
					x.database_name,
					x.object_id,
					x.file_id,
					CASE
						WHEN x.page_no = 1 OR x.page_no % 8088 = 0 THEN 'PFS'
						WHEN x.page_no = 2 OR x.page_no % 511232 = 0 THEN 'GAM'
						WHEN x.page_no = 3 OR (x.page_no - 1) % 511232 = 0 THEN 'SGAM'
						WHEN x.page_no = 6 OR (x.page_no - 6) % 511232 = 0 THEN 'DCM'
						WHEN x.page_no = 7 OR (x.page_no - 7) % 511232 = 0 THEN 'BCM'
						WHEN x.page_no IS NOT NULL THEN '*'
						ELSE NULL
					END AS page_type,
					x.hobt_id,
					x.allocation_unit_id,
					x.index_id,
					x.schema_id,
					x.principal_id,
					x.request_mode,
					x.request_status,
					x.session_id,
					x.request_id,
					CASE
						WHEN COALESCE(x.object_id, x.file_id, x.hobt_id, x.allocation_unit_id, x.index_id, x.schema_id, x.principal_id) IS NULL THEN NULLIF(resource_description, '')
						ELSE NULL
					END AS resource_description,
					COUNT(*) AS request_count
				FROM
				(
					SELECT
						tl.resource_type +
							CASE
								WHEN tl.resource_subtype = '' THEN ''
								ELSE '.' + tl.resource_subtype
							END AS resource_type,
						COALESCE(DB_NAME(tl.resource_database_id), N'(null)') AS database_name,
						CONVERT
						(
							INT,
							CASE
								WHEN tl.resource_type = 'OBJECT' THEN tl.resource_associated_entity_id
								WHEN tl.resource_description LIKE '%object_id = %' THEN
									(
										SUBSTRING
										(
											tl.resource_description, 
											(CHARINDEX('object_id = ', tl.resource_description) + 12), 
											COALESCE
											(
												NULLIF
												(
													CHARINDEX(',', tl.resource_description, CHARINDEX('object_id = ', tl.resource_description) + 12),
													0
												), 
												DATALENGTH(tl.resource_description)+1
											) - (CHARINDEX('object_id = ', tl.resource_description) + 12)
										)
									)
								ELSE NULL
							END
						) AS object_id,
						CONVERT
						(
							INT,
							CASE 
								WHEN tl.resource_type = 'FILE' THEN CONVERT(INT, tl.resource_description)
								WHEN tl.resource_type IN ('PAGE', 'EXTENT', 'RID') THEN LEFT(tl.resource_description, CHARINDEX(':', tl.resource_description)-1)
								ELSE NULL
							END
						) AS file_id,
						CONVERT
						(
							INT,
							CASE
								WHEN tl.resource_type IN ('PAGE', 'EXTENT', 'RID') THEN 
									SUBSTRING
									(
										tl.resource_description, 
										CHARINDEX(':', tl.resource_description) + 1, 
										COALESCE
										(
											NULLIF
											(
												CHARINDEX(':', tl.resource_description, CHARINDEX(':', tl.resource_description) + 1), 
												0
											), 
											DATALENGTH(tl.resource_description)+1
										) - (CHARINDEX(':', tl.resource_description) + 1)
									)
								ELSE NULL
							END
						) AS page_no,
						CASE
							WHEN tl.resource_type IN ('PAGE', 'KEY', 'RID', 'HOBT') THEN tl.resource_associated_entity_id
							ELSE NULL
						END AS hobt_id,
						CASE
							WHEN tl.resource_type = 'ALLOCATION_UNIT' THEN tl.resource_associated_entity_id
							ELSE NULL
						END AS allocation_unit_id,
						CONVERT
						(
							INT,
							CASE
								WHEN
									/*TODO: Deal with server principals*/ 
									tl.resource_subtype <> 'SERVER_PRINCIPAL' 
									AND tl.resource_description LIKE '%index_id or stats_id = %' THEN
									(
										SUBSTRING
										(
											tl.resource_description, 
											(CHARINDEX('index_id or stats_id = ', tl.resource_description) + 23), 
											COALESCE
											(
												NULLIF
												(
													CHARINDEX(',', tl.resource_description, CHARINDEX('index_id or stats_id = ', tl.resource_description) + 23), 
													0
												), 
												DATALENGTH(tl.resource_description)+1
											) - (CHARINDEX('index_id or stats_id = ', tl.resource_description) + 23)
										)
									)
								ELSE NULL
							END 
						) AS index_id,
						CONVERT
						(
							INT,
							CASE
								WHEN tl.resource_description LIKE '%schema_id = %' THEN
									(
										SUBSTRING
										(
											tl.resource_description, 
											(CHARINDEX('schema_id = ', tl.resource_description) + 12), 
											COALESCE
											(
												NULLIF
												(
													CHARINDEX(',', tl.resource_description, CHARINDEX('schema_id = ', tl.resource_description) + 12), 
													0
												), 
												DATALENGTH(tl.resource_description)+1
											) - (CHARINDEX('schema_id = ', tl.resource_description) + 12)
										)
									)
								ELSE NULL
							END 
						) AS schema_id,
						CONVERT
						(
							INT,
							CASE
								WHEN tl.resource_description LIKE '%principal_id = %' THEN
									(
										SUBSTRING
										(
											tl.resource_description, 
											(CHARINDEX('principal_id = ', tl.resource_description) + 15), 
											COALESCE
											(
												NULLIF
												(
													CHARINDEX(',', tl.resource_description, CHARINDEX('principal_id = ', tl.resource_description) + 15), 
													0
												), 
												DATALENGTH(tl.resource_description)+1
											) - (CHARINDEX('principal_id = ', tl.resource_description) + 15)
										)
									)
								ELSE NULL
							END
						) AS principal_id,
						tl.request_mode,
						tl.request_status,
						tl.request_session_id AS session_id,
						tl.request_request_id AS request_id,

						/*TODO: Applocks, other resource_descriptions*/
						RTRIM(tl.resource_description) AS resource_description,
						tl.resource_associated_entity_id
						/*********************************************/
					FROM 
					(
						SELECT 
							request_session_id,
							CONVERT(VARCHAR(120), resource_type) COLLATE Latin1_General_Bin2 AS resource_type,
							CONVERT(VARCHAR(120), resource_subtype) COLLATE Latin1_General_Bin2 AS resource_subtype,
							resource_database_id,
							CONVERT(VARCHAR(512), resource_description) COLLATE Latin1_General_Bin2 AS resource_description,
							resource_associated_entity_id,
							CONVERT(VARCHAR(120), request_mode) COLLATE Latin1_General_Bin2 AS request_mode,
							CONVERT(VARCHAR(120), request_status) COLLATE Latin1_General_Bin2 AS request_status,
							request_request_id
						FROM sys.dm_tran_locks
					) AS tl
				) AS x
				GROUP BY
					x.resource_type,
					x.database_name,
					x.object_id,
					x.file_id,
					CASE
						WHEN x.page_no = 1 OR x.page_no % 8088 = 0 THEN 'PFS'
						WHEN x.page_no = 2 OR x.page_no % 511232 = 0 THEN 'GAM'
						WHEN x.page_no = 3 OR (x.page_no - 1) % 511232 = 0 THEN 'SGAM'
						WHEN x.page_no = 6 OR (x.page_no - 6) % 511232 = 0 THEN 'DCM'
						WHEN x.page_no = 7 OR (x.page_no - 7) % 511232 = 0 THEN 'BCM'
						WHEN x.page_no IS NOT NULL THEN '*'
						ELSE NULL
					END,
					x.hobt_id,
					x.allocation_unit_id,
					x.index_id,
					x.schema_id,
					x.principal_id,
					x.request_mode,
					x.request_status,
					x.session_id,
					x.request_id,
					CASE
						WHEN COALESCE(x.object_id, x.file_id, x.hobt_id, x.allocation_unit_id, x.index_id, x.schema_id, x.principal_id) IS NULL THEN NULLIF(resource_description, '')
						ELSE NULL
					END
			) AS y ON
				y.session_id = s.session_id
				AND y.request_id = s.request_id
			OPTION (HASH GROUP);

			--Disable unnecessary autostats on the table
			CREATE STATISTICS s_database_name ON #locks (database_name)
			WITH SAMPLE 0 ROWS, NORECOMPUTE;
			CREATE STATISTICS s_object_id ON #locks (object_id)
			WITH SAMPLE 0 ROWS, NORECOMPUTE;
			CREATE STATISTICS s_hobt_id ON #locks (hobt_id)
			WITH SAMPLE 0 ROWS, NORECOMPUTE;
			CREATE STATISTICS s_allocation_unit_id ON #locks (allocation_unit_id)
			WITH SAMPLE 0 ROWS, NORECOMPUTE;
			CREATE STATISTICS s_index_id ON #locks (index_id)
			WITH SAMPLE 0 ROWS, NORECOMPUTE;
			CREATE STATISTICS s_schema_id ON #locks (schema_id)
			WITH SAMPLE 0 ROWS, NORECOMPUTE;
			CREATE STATISTICS s_principal_id ON #locks (principal_id)
			WITH SAMPLE 0 ROWS, NORECOMPUTE;
			CREATE STATISTICS s_request_id ON #locks (request_id)
			WITH SAMPLE 0 ROWS, NORECOMPUTE;
			CREATE STATISTICS s_start_time ON #locks (start_time)
			WITH SAMPLE 0 ROWS, NORECOMPUTE;
			CREATE STATISTICS s_resource_type ON #locks (resource_type)
			WITH SAMPLE 0 ROWS, NORECOMPUTE;
			CREATE STATISTICS s_object_name ON #locks (object_name)
			WITH SAMPLE 0 ROWS, NORECOMPUTE;
			CREATE STATISTICS s_schema_name ON #locks (schema_name)
			WITH SAMPLE 0 ROWS, NORECOMPUTE;
			CREATE STATISTICS s_page_type ON #locks (page_type)
			WITH SAMPLE 0 ROWS, NORECOMPUTE;
			CREATE STATISTICS s_request_mode ON #locks (request_mode)
			WITH SAMPLE 0 ROWS, NORECOMPUTE;
			CREATE STATISTICS s_request_status ON #locks (request_status)
			WITH SAMPLE 0 ROWS, NORECOMPUTE;
			CREATE STATISTICS s_resource_description ON #locks (resource_description)
			WITH SAMPLE 0 ROWS, NORECOMPUTE;
			CREATE STATISTICS s_index_name ON #locks (index_name)
			WITH SAMPLE 0 ROWS, NORECOMPUTE;
			CREATE STATISTICS s_principal_name ON #locks (principal_name)
			WITH SAMPLE 0 ROWS, NORECOMPUTE;
		END;
		
		DECLARE 
			@sql VARCHAR(MAX), 
			@sql_n NVARCHAR(MAX);

		SET @sql = 
			CONVERT(VARCHAR(MAX), '') +
			'DECLARE @blocker BIT;
			SET @blocker = 0;
			DECLARE @i INT;
			SET @i = 2147483647;

			DECLARE @sessions TABLE
			(
				session_id SMALLINT NOT NULL,
				request_id INT NOT NULL,
				login_time DATETIME,
				last_request_end_time DATETIME,
				status VARCHAR(30),
				statement_start_offset INT,
				statement_end_offset INT,
				sql_handle BINARY(20),
				host_name NVARCHAR(128),
				login_name NVARCHAR(128),
				program_name NVARCHAR(128),
				database_id SMALLINT,
				memory_usage INT,
				open_tran_count SMALLINT, 
				' +
				CASE
					WHEN 
					(
						@get_task_info <> 0 
						OR @find_block_leaders = 1 
					) THEN
						'wait_type NVARCHAR(32),
						wait_resource NVARCHAR(256),
						wait_time BIGINT, 
						'
					ELSE 
						''
				END +
				'blocked SMALLINT,
				is_user_process BIT,
				cmd VARCHAR(32),
				PRIMARY KEY CLUSTERED (session_id, request_id) WITH (IGNORE_DUP_KEY = ON)
			);

			DECLARE @blockers TABLE
			(
				session_id INT NOT NULL PRIMARY KEY WITH (IGNORE_DUP_KEY = ON)
			);

			BLOCKERS:;

			INSERT @sessions
			(
				session_id,
				request_id,
				login_time,
				last_request_end_time,
				status,
				statement_start_offset,
				statement_end_offset,
				sql_handle,
				host_name,
				login_name,
				program_name,
				database_id,
				memory_usage,
				open_tran_count, 
				' +
				CASE
					WHEN 
					(
						@get_task_info <> 0
						OR @find_block_leaders = 1 
					) THEN
						'wait_type,
						wait_resource,
						wait_time, 
						'
					ELSE
						''
				END +
				'blocked,
				is_user_process,
				cmd 
			)
			SELECT TOP(@i)
				spy.session_id,
				spy.request_id,
				spy.login_time,
				spy.last_request_end_time,
				spy.status,
				spy.statement_start_offset,
				spy.statement_end_offset,
				spy.sql_handle,
				spy.host_name,
				spy.login_name,
				spy.program_name,
				spy.database_id,
				spy.memory_usage,
				spy.open_tran_count,
				' +
				CASE
					WHEN 
					(
						@get_task_info <> 0  
						OR @find_block_leaders = 1 
					) THEN
						'spy.wait_type,
						CASE
							WHEN
								spy.wait_type LIKE N''PAGE%LATCH_%''
								OR spy.wait_type = N''CXPACKET''
								OR spy.wait_type LIKE N''LATCH[_]%''
								OR spy.wait_type = N''OLEDB'' THEN
									spy.wait_resource
							ELSE
								NULL
						END AS wait_resource,
						spy.wait_time, 
						'
					ELSE
						''
				END +
				'spy.blocked,
				spy.is_user_process,
				spy.cmd
			FROM
			(
				SELECT TOP(@i)
					spx.*, 
					' +
					CASE
						WHEN 
						(
							@get_task_info <> 0 
							OR @find_block_leaders = 1 
						) THEN
							'ROW_NUMBER() OVER
							(
								PARTITION BY
									spx.session_id,
									spx.request_id
								ORDER BY
									CASE
										WHEN spx.wait_type LIKE N''LCK[_]%'' THEN 
											1
										ELSE
											99
									END,
									spx.wait_time DESC,
									spx.blocked DESC
							) AS r 
							'
						ELSE 
							'1 AS r 
							'
					END +
				'FROM
				(
					SELECT TOP(@i)
						sp0.session_id,
						sp0.request_id,
						sp0.login_time,
						sp0.last_request_end_time,
						LOWER(sp0.status) AS status,
						CASE
							WHEN sp0.cmd = ''CREATE INDEX'' THEN
								0
							ELSE
								sp0.stmt_start
						END AS statement_start_offset,
						CASE
							WHEN sp0.cmd = N''CREATE INDEX'' THEN
								-1
							ELSE
								COALESCE(NULLIF(sp0.stmt_end, 0), -1)
						END AS statement_end_offset,
						sp0.sql_handle,
						sp0.host_name,
						sp0.login_name,
						sp0.program_name,
						sp0.database_id,
						sp0.memory_usage,
						sp0.open_tran_count, 
						' +
						CASE
							WHEN 
							(
								@get_task_info <> 0 
								OR @find_block_leaders = 1 
							) THEN
								'CASE
									WHEN sp0.wait_time > 0 AND sp0.wait_type <> N''CXPACKET'' THEN
										sp0.wait_type
									ELSE
										NULL
								END AS wait_type,
								CASE
									WHEN sp0.wait_time > 0 AND sp0.wait_type <> N''CXPACKET'' THEN 
										sp0.wait_resource
									ELSE
										NULL
								END AS wait_resource,
								CASE
									WHEN sp0.wait_type <> N''CXPACKET'' THEN
										sp0.wait_time
									ELSE
										0
								END AS wait_time, 
								'
							ELSE
								''
						END +
						'sp0.blocked,
						sp0.is_user_process,
						sp0.cmd
					FROM
					(
						SELECT TOP(@i)
							sp1.session_id,
							sp1.request_id,
							sp1.login_time,
							sp1.last_request_end_time,
							sp1.status,
							sp1.cmd,
							sp1.stmt_start,
							sp1.stmt_end,
							MAX(NULLIF(sp1.sql_handle, 0x00)) OVER (PARTITION BY sp1.session_id, sp1.request_id) AS sql_handle,
							sp1.host_name,
							MAX(sp1.login_name) OVER (PARTITION BY sp1.session_id, sp1.request_id) AS login_name,
							sp1.program_name,
							sp1.database_id,
							MAX(sp1.memory_usage)  OVER (PARTITION BY sp1.session_id, sp1.request_id) AS memory_usage,
							MAX(sp1.open_tran_count)  OVER (PARTITION BY sp1.session_id, sp1.request_id) AS open_tran_count,
							sp1.wait_type,
							sp1.wait_resource,
							sp1.wait_time,
							sp1.blocked,
							sp1.hostprocess,
							sp1.is_user_process
						FROM
						(
							SELECT TOP(@i)
								sp2.spid AS session_id,
								CASE sp2.status
									WHEN ''sleeping'' THEN
										CONVERT(INT, 0)
									ELSE
										sp2.request_id
								END AS request_id,
								MAX(sp2.login_time) AS login_time,
								MAX(sp2.last_batch) AS last_request_end_time,
								MAX(CONVERT(VARCHAR(30), RTRIM(sp2.status)) COLLATE Latin1_General_Bin2) AS status,
								MAX(CONVERT(VARCHAR(32), RTRIM(sp2.cmd)) COLLATE Latin1_General_Bin2) AS cmd,
								MAX(sp2.stmt_start) AS stmt_start,
								MAX(sp2.stmt_end) AS stmt_end,
								MAX(sp2.sql_handle) AS sql_handle,
								MAX(CONVERT(sysname, RTRIM(sp2.hostname)) COLLATE SQL_Latin1_General_CP1_CI_AS) AS host_name,
								MAX(CONVERT(sysname, RTRIM(sp2.loginame)) COLLATE SQL_Latin1_General_CP1_CI_AS) AS login_name,
								MAX
								(
									CASE
										WHEN blk.queue_id IS NOT NULL THEN
											N''Service Broker
												database_id: '' + CONVERT(NVARCHAR, blk.database_id) +
												N'' queue_id: '' + CONVERT(NVARCHAR, blk.queue_id)
										ELSE
											CONVERT
											(
												sysname,
												RTRIM(sp2.program_name)
											)
									END COLLATE SQL_Latin1_General_CP1_CI_AS
								) AS program_name,
								MAX(sp2.dbid) AS database_id,
								MAX(sp2.memusage) AS memory_usage,
								MAX(sp2.open_tran) AS open_tran_count,
								RTRIM(sp2.lastwaittype) AS wait_type,
								RTRIM(sp2.waitresource) AS wait_resource,
								MAX(sp2.waittime) AS wait_time,
								COALESCE(NULLIF(sp2.blocked, sp2.spid), 0) AS blocked,
								MAX
								(
									CASE
										WHEN blk.session_id = sp2.spid THEN
											''blocker''
										ELSE
											RTRIM(sp2.hostprocess)
									END
								) AS hostprocess,
								CONVERT
								(
									BIT,
									MAX
									(
										CASE
											WHEN sp2.hostprocess > '''' THEN
												1
											ELSE
												0
										END
									)
								) AS is_user_process
							FROM
							(
								SELECT TOP(@i)
									session_id,
									CONVERT(INT, NULL) AS queue_id,
									CONVERT(INT, NULL) AS database_id
								FROM @blockers

								UNION ALL

								SELECT TOP(@i)
									CONVERT(SMALLINT, 0),
									CONVERT(INT, NULL) AS queue_id,
									CONVERT(INT, NULL) AS database_id
								WHERE
									@blocker = 0

								UNION ALL

								SELECT TOP(@i)
									CONVERT(SMALLINT, spid),
									queue_id,
									database_id
								FROM sys.dm_broker_activated_tasks
								WHERE
									@blocker = 0
							) AS blk
							INNER JOIN sys.sysprocesses AS sp2 ON
								sp2.spid = blk.session_id
								OR
								(
									blk.session_id = 0
									AND @blocker = 0
								)
							' +
							CASE 
								WHEN 
								(
									@get_task_info = 0 
									AND @find_block_leaders = 0
								) THEN
									'WHERE
										sp2.ecid = 0 
									' 
								ELSE
									''
							END +
							'GROUP BY
								sp2.spid,
								CASE sp2.status
									WHEN ''sleeping'' THEN
										CONVERT(INT, 0)
									ELSE
										sp2.request_id
								END,
								RTRIM(sp2.lastwaittype),
								RTRIM(sp2.waitresource),
								COALESCE(NULLIF(sp2.blocked, sp2.spid), 0)
						) AS sp1
					) AS sp0
					WHERE
						@blocker = 1
						OR
						(1=1 
						' +
							--inclusive filter
							CASE
								WHEN @filter <> '' THEN
									CASE @filter_type
										WHEN 'session' THEN
											CASE
												WHEN CONVERT(SMALLINT, @filter) <> 0 THEN
													'AND sp0.session_id = CONVERT(SMALLINT, @filter) 
													'
												ELSE
													''
											END
										WHEN 'program' THEN
											'AND sp0.program_name LIKE @filter 
											'
										WHEN 'login' THEN
											'AND sp0.login_name LIKE @filter 
											'
										WHEN 'host' THEN
											'AND sp0.host_name LIKE @filter 
											'
										WHEN 'database' THEN
											'AND DB_NAME(sp0.database_id) LIKE @filter 
											'
										ELSE
											''
									END
								ELSE
									''
							END +
							--exclusive filter
							CASE
								WHEN @not_filter <> '' THEN
									CASE @not_filter_type
										WHEN 'session' THEN
											CASE
												WHEN CONVERT(SMALLINT, @not_filter) <> 0 THEN
													'AND sp0.session_id <> CONVERT(SMALLINT, @not_filter) 
													'
												ELSE
													''
											END
										WHEN 'program' THEN
											'AND sp0.program_name NOT LIKE @not_filter 
											'
										WHEN 'login' THEN
											'AND sp0.login_name NOT LIKE @not_filter 
											'
										WHEN 'host' THEN
											'AND sp0.host_name NOT LIKE @not_filter 
											'
										WHEN 'database' THEN
											'AND DB_NAME(sp0.database_id) NOT LIKE @not_filter 
											'
										ELSE
											''
									END
								ELSE
									''
							END +
							CASE @show_own_spid
								WHEN 1 THEN
									''
								ELSE
									'AND sp0.session_id <> @@spid 
									'
							END +
							CASE 
								WHEN @show_system_spids = 0 THEN
									'AND sp0.hostprocess > '''' 
									' 
								ELSE
									''
							END +
							CASE @show_sleeping_spids
								WHEN 0 THEN
									'AND sp0.status <> ''sleeping'' 
									'
								WHEN 1 THEN
									'AND
									(
										sp0.status <> ''sleeping''
										OR sp0.open_tran_count > 0
									)
									'
								ELSE
									''
							END +
						')
				) AS spx
			) AS spy
			WHERE
				spy.r = 1; 
			' + 
			CASE @recursion
				WHEN 1 THEN 
					'IF @@ROWCOUNT > 0
					BEGIN;
						INSERT @blockers
						(
							session_id
						)
						SELECT TOP(@i)
							blocked
						FROM @sessions
						WHERE
							NULLIF(blocked, 0) IS NOT NULL

						EXCEPT

						SELECT TOP(@i)
							session_id
						FROM @sessions; 
						' +

						CASE
							WHEN
							(
								@get_task_info > 0
								OR @find_block_leaders = 1
							) THEN
								'IF @@ROWCOUNT > 0
								BEGIN;
									SET @blocker = 1;
									GOTO BLOCKERS;
								END; 
								'
							ELSE 
								''
						END +
					'END; 
					'
				ELSE 
					''
			END +
			'SELECT TOP(@i)
				@recursion AS recursion,
				x.session_id,
				x.request_id,
				DENSE_RANK() OVER
				(
					ORDER BY
						x.session_id
				) AS session_number,
				' +
				CASE
					WHEN @output_column_list LIKE '%|[dd hh:mm:ss.mss|]%' ESCAPE '|' THEN 
						'x.elapsed_time '
					ELSE 
						'0 '
				END + 
					'AS elapsed_time, 
					' +
				CASE
					WHEN
						(
							@output_column_list LIKE '%|[dd hh:mm:ss.mss (avg)|]%' ESCAPE '|' OR 
							@output_column_list LIKE '%|[avg_elapsed_time|]%' ESCAPE '|'
						)
						AND @recursion = 1
							THEN 
								'x.avg_elapsed_time / 1000 '
					ELSE 
						'NULL '
				END + 
					'AS avg_elapsed_time, 
					' +
				CASE
					WHEN 
						@output_column_list LIKE '%|[physical_io|]%' ESCAPE '|'
						OR @output_column_list LIKE '%|[physical_io_delta|]%' ESCAPE '|'
							THEN 
								'x.physical_io '
					ELSE 
						'NULL '
				END + 
					'AS physical_io, 
					' +
				CASE
					WHEN 
						@output_column_list LIKE '%|[reads|]%' ESCAPE '|'
						OR @output_column_list LIKE '%|[reads_delta|]%' ESCAPE '|'
							THEN 
								'x.reads '
					ELSE 
						'0 '
				END + 
					'AS reads, 
					' +
				CASE
					WHEN 
						@output_column_list LIKE '%|[physical_reads|]%' ESCAPE '|'
						OR @output_column_list LIKE '%|[physical_reads_delta|]%' ESCAPE '|'
							THEN 
								'x.physical_reads '
					ELSE 
						'0 '
				END + 
					'AS physical_reads, 
					' +
				CASE
					WHEN 
						@output_column_list LIKE '%|[writes|]%' ESCAPE '|'
						OR @output_column_list LIKE '%|[writes_delta|]%' ESCAPE '|'
							THEN 
								'x.writes '
					ELSE 
						'0 '
				END + 
					'AS writes, 
					' +
				CASE
					WHEN 
						@output_column_list LIKE '%|[tempdb_allocations|]%' ESCAPE '|'
						OR @output_column_list LIKE '%|[tempdb_allocations_delta|]%' ESCAPE '|'
							THEN 
								'x.tempdb_allocations '
					ELSE 
						'0 '
				END + 
					'AS tempdb_allocations, 
					' +
				CASE
					WHEN 
						@output_column_list LIKE '%|[tempdb_current|]%' ESCAPE '|'
						OR @output_column_list LIKE '%|[tempdb_current_delta|]%' ESCAPE '|'
							THEN 
								'x.tempdb_current '
					ELSE 
						'0 '
				END + 
					'AS tempdb_current, 
					' +
				CASE
					WHEN 
						@output_column_list LIKE '%|[CPU|]%' ESCAPE '|'
						OR @output_column_list LIKE '%|[CPU_delta|]%' ESCAPE '|'
							THEN
								'x.CPU '
					ELSE
						'0 '
				END + 
					'AS CPU, 
					' +
				CASE
					WHEN 
						@output_column_list LIKE '%|[CPU_delta|]%' ESCAPE '|'
						AND @get_task_info = 2
						AND @sys_info = 1
							THEN 
								'x.thread_CPU_snapshot '
					ELSE 
						'0 '
				END + 
					'AS thread_CPU_snapshot, 
					' +
				CASE
					WHEN 
						@output_column_list LIKE '%|[context_switches|]%' ESCAPE '|'
						OR @output_column_list LIKE '%|[context_switches_delta|]%' ESCAPE '|'
							THEN 
								'x.context_switches '
					ELSE 
						'NULL '
				END + 
					'AS context_switches, 
					' +
				CASE
					WHEN 
						@output_column_list LIKE '%|[used_memory|]%' ESCAPE '|'
						OR @output_column_list LIKE '%|[used_memory_delta|]%' ESCAPE '|'
							THEN 
								'x.used_memory '
					ELSE 
						'0 '
				END + 
					'AS used_memory, 
					' +
				CASE
					WHEN 
						@output_column_list LIKE '%|[tasks|]%' ESCAPE '|'
						AND @recursion = 1
							THEN 
								'x.tasks '
					ELSE 
						'NULL '
				END + 
					'AS tasks, 
					' +
				CASE
					WHEN 
						(
							@output_column_list LIKE '%|[status|]%' ESCAPE '|' 
							OR @output_column_list LIKE '%|[sql_command|]%' ESCAPE '|'
						)
						AND @recursion = 1
							THEN 
								'x.status '
					ELSE 
						''''' '
				END + 
					'AS status, 
					' +
				CASE
					WHEN 
						@output_column_list LIKE '%|[wait_info|]%' ESCAPE '|' 
						AND @recursion = 1
							THEN 
								CASE @get_task_info
									WHEN 2 THEN
										'COALESCE(x.task_wait_info, x.sys_wait_info) '
									ELSE
										'x.sys_wait_info '
								END
					ELSE 
						'NULL '
				END + 
					'AS wait_info, 
					' +
				CASE
					WHEN 
						(
							@output_column_list LIKE '%|[tran_start_time|]%' ESCAPE '|' 
							OR @output_column_list LIKE '%|[tran_log_writes|]%' ESCAPE '|' 
						)
						AND @recursion = 1
							THEN 
								'x.transaction_id '
					ELSE 
						'NULL '
				END + 
					'AS transaction_id, 
					' +
				CASE
					WHEN 
						@output_column_list LIKE '%|[open_tran_count|]%' ESCAPE '|' 
						AND @recursion = 1
							THEN 
								'x.open_tran_count '
					ELSE 
						'NULL '
				END + 
					'AS open_tran_count, 
					' +
				CASE
					WHEN 
						@output_column_list LIKE '%|[sql_text|]%' ESCAPE '|' 
						AND @recursion = 1
							THEN 
								'x.sql_handle '
					ELSE 
						'NULL '
				END + 
					'AS sql_handle, 
					' +
				CASE
					WHEN 
						(
							@output_column_list LIKE '%|[sql_text|]%' ESCAPE '|' 
							OR @output_column_list LIKE '%|[query_plan|]%' ESCAPE '|' 
						)
						AND @recursion = 1
							THEN 
								'x.statement_start_offset '
					ELSE 
						'NULL '
				END + 
					'AS statement_start_offset, 
					' +
				CASE
					WHEN 
						(
							@output_column_list LIKE '%|[sql_text|]%' ESCAPE '|' 
							OR @output_column_list LIKE '%|[query_plan|]%' ESCAPE '|' 
						)
						AND @recursion = 1
							THEN 
								'x.statement_end_offset '
					ELSE 
						'NULL '
				END + 
					'AS statement_end_offset, 
					' +
				'NULL AS sql_text, 
					' +
				CASE
					WHEN 
						@output_column_list LIKE '%|[query_plan|]%' ESCAPE '|' 
						AND @recursion = 1
							THEN 
								'x.plan_handle '
					ELSE 
						'NULL '
				END + 
					'AS plan_handle, 
					' +
				CASE
					WHEN 
						@output_column_list LIKE '%|[blocking_session_id|]%' ESCAPE '|' 
						AND @recursion = 1
							THEN 
								'NULLIF(x.blocking_session_id, 0) '
					ELSE 
						'NULL '
				END + 
					'AS blocking_session_id, 
					' +
				CASE
					WHEN 
						@output_column_list LIKE '%|[percent_complete|]%' ESCAPE '|'
						AND @recursion = 1
							THEN 
								'x.percent_complete '
					ELSE 
						'NULL '
				END + 
					'AS percent_complete, 
					' +
				CASE
					WHEN 
						@output_column_list LIKE '%|[host_name|]%' ESCAPE '|' 
						AND @recursion = 1
							THEN 
								'x.host_name '
					ELSE 
						''''' '
				END + 
					'AS host_name, 
					' +
				CASE
					WHEN 
						@output_column_list LIKE '%|[login_name|]%' ESCAPE '|' 
						AND @recursion = 1
							THEN 
								'x.login_name '
					ELSE 
						''''' '
				END + 
					'AS login_name, 
					' +
				CASE
					WHEN 
						@output_column_list LIKE '%|[database_name|]%' ESCAPE '|' 
						AND @recursion = 1
							THEN 
								'DB_NAME(x.database_id) '
					ELSE 
						'NULL '
				END + 
					'AS database_name, 
					' +
				CASE
					WHEN 
						@output_column_list LIKE '%|[program_name|]%' ESCAPE '|' 
						AND @recursion = 1
							THEN 
								'x.program_name '
					ELSE 
						''''' '
				END + 
					'AS program_name, 
					' +
				CASE
					WHEN
						@output_column_list LIKE '%|[additional_info|]%' ESCAPE '|'
						AND @recursion = 1
							THEN
								'(
									SELECT TOP(@i)
										x.text_size,
										x.language,
										x.date_format,
										x.date_first,
										CASE x.quoted_identifier
											WHEN 0 THEN ''OFF''
											WHEN 1 THEN ''ON''
										END AS quoted_identifier,
										CASE x.arithabort
											WHEN 0 THEN ''OFF''
											WHEN 1 THEN ''ON''
										END AS arithabort,
										CASE x.ansi_null_dflt_on
											WHEN 0 THEN ''OFF''
											WHEN 1 THEN ''ON''
										END AS ansi_null_dflt_on,
										CASE x.ansi_defaults
											WHEN 0 THEN ''OFF''
											WHEN 1 THEN ''ON''
										END AS ansi_defaults,
										CASE x.ansi_warnings
											WHEN 0 THEN ''OFF''
											WHEN 1 THEN ''ON''
										END AS ansi_warnings,
										CASE x.ansi_padding
											WHEN 0 THEN ''OFF''
											WHEN 1 THEN ''ON''
										END AS ansi_padding,
										CASE ansi_nulls
											WHEN 0 THEN ''OFF''
											WHEN 1 THEN ''ON''
										END AS ansi_nulls,
										CASE x.concat_null_yields_null
											WHEN 0 THEN ''OFF''
											WHEN 1 THEN ''ON''
										END AS concat_null_yields_null,
										CASE x.transaction_isolation_level
											WHEN 0 THEN ''Unspecified''
											WHEN 1 THEN ''ReadUncomitted''
											WHEN 2 THEN ''ReadCommitted''
											WHEN 3 THEN ''Repeatable''
											WHEN 4 THEN ''Serializable''
											WHEN 5 THEN ''Snapshot''
										END AS transaction_isolation_level,
										x.lock_timeout,
										x.deadlock_priority,
										x.row_count,
										x.command_type, 
										' +
										CASE
											WHEN OBJECT_ID('master.dbo.fn_varbintohexstr') IS NOT NULL THEN
												'master.dbo.fn_varbintohexstr(x.sql_handle) AS sql_handle,
												master.dbo.fn_varbintohexstr(x.plan_handle) AS plan_handle,'
											ELSE
												'CONVERT(VARCHAR(256), x.sql_handle, 1) AS sql_handle,
												CONVERT(VARCHAR(256), x.plan_handle, 1) AS plan_handle,'
										END +
										'
										x.statement_start_offset,
										x.statement_end_offset,
										' +
										CASE
											WHEN @output_column_list LIKE '%|[program_name|]%' ESCAPE '|' THEN
												'(
													SELECT TOP(1)
														CONVERT(uniqueidentifier, CONVERT(XML, '''').value(''xs:hexBinary( substring(sql:column("agent_info.job_id_string"), 0) )'', ''binary(16)'')) AS job_id,
														agent_info.step_id,
														(
															SELECT TOP(1)
																NULL
															FOR XML
																PATH(''job_name''),
																TYPE
														),
														(
															SELECT TOP(1)
																NULL
															FOR XML
																PATH(''step_name''),
																TYPE
														)
													FROM
													(
														SELECT TOP(1)
															SUBSTRING(x.program_name, CHARINDEX(''0x'', x.program_name) + 2, 32) AS job_id_string,
															SUBSTRING(x.program_name, CHARINDEX('': Step '', x.program_name) + 7, CHARINDEX('')'', x.program_name, CHARINDEX('': Step '', x.program_name)) - (CHARINDEX('': Step '', x.program_name) + 7)) AS step_id
														WHERE
															x.program_name LIKE N''SQLAgent - TSQL JobStep (Job 0x%''
													) AS agent_info
													FOR XML
														PATH(''agent_job_info''),
														TYPE
												),
												'
											ELSE ''
										END +
										CASE
											WHEN @get_task_info = 2 THEN
												'CONVERT(XML, x.block_info) AS block_info, 
												'
											ELSE
												''
										END + '
										x.host_process_id,
										x.group_id
									FOR XML
										PATH(''additional_info''),
										TYPE
								) '
					ELSE
						'NULL '
				END + 
					'AS additional_info, 
				x.start_time, 
					' +
				CASE
					WHEN
						@output_column_list LIKE '%|[login_time|]%' ESCAPE '|'
						AND @recursion = 1
							THEN
								'x.login_time '
					ELSE 
						'NULL '
				END + 
					'AS login_time, 
				x.last_request_start_time
			FROM
			(
				SELECT TOP(@i)
					y.*,
					CASE
						WHEN DATEDIFF(hour, y.start_time, GETDATE()) > 576 THEN
							DATEDIFF(second, GETDATE(), y.start_time)
						ELSE DATEDIFF(ms, y.start_time, GETDATE())
					END AS elapsed_time,
					COALESCE(tempdb_info.tempdb_allocations, 0) AS tempdb_allocations,
					COALESCE
					(
						CASE
							WHEN tempdb_info.tempdb_current < 0 THEN 0
							ELSE tempdb_info.tempdb_current
						END,
						0
					) AS tempdb_current, 
					' +
					CASE
						WHEN 
							(
								@get_task_info <> 0
								OR @find_block_leaders = 1
							) THEN
								'N''('' + CONVERT(NVARCHAR, y.wait_duration_ms) + N''ms)'' +
									y.wait_type +
										CASE
											WHEN y.wait_type LIKE N''PAGE%LATCH_%'' THEN
												N'':'' +
												COALESCE(DB_NAME(CONVERT(INT, LEFT(y.resource_description, CHARINDEX(N'':'', y.resource_description) - 1))), N''(null)'') +
												N'':'' +
												SUBSTRING(y.resource_description, CHARINDEX(N'':'', y.resource_description) + 1, LEN(y.resource_description) - CHARINDEX(N'':'', REVERSE(y.resource_description)) - CHARINDEX(N'':'', y.resource_description)) +
												N''('' +
													CASE
														WHEN
															CONVERT(INT, RIGHT(y.resource_description, CHARINDEX(N'':'', REVERSE(y.resource_description)) - 1)) = 1 OR
															CONVERT(INT, RIGHT(y.resource_description, CHARINDEX(N'':'', REVERSE(y.resource_description)) - 1)) % 8088 = 0
																THEN 
																	N''PFS''
														WHEN
															CONVERT(INT, RIGHT(y.resource_description, CHARINDEX(N'':'', REVERSE(y.resource_description)) - 1)) = 2 OR
															CONVERT(INT, RIGHT(y.resource_description, CHARINDEX(N'':'', REVERSE(y.resource_description)) - 1)) % 511232 = 0
																THEN 
																	N''GAM''
														WHEN
															CONVERT(INT, RIGHT(y.resource_description, CHARINDEX(N'':'', REVERSE(y.resource_description)) - 1)) = 3 OR
															(CONVERT(INT, RIGHT(y.resource_description, CHARINDEX(N'':'', REVERSE(y.resource_description)) - 1)) - 1) % 511232 = 0
																THEN
																	N''SGAM''
														WHEN
															CONVERT(INT, RIGHT(y.resource_description, CHARINDEX(N'':'', REVERSE(y.resource_description)) - 1)) = 6 OR
															(CONVERT(INT, RIGHT(y.resource_description, CHARINDEX(N'':'', REVERSE(y.resource_description)) - 1)) - 6) % 511232 = 0 
																THEN 
																	N''DCM''
														WHEN
															CONVERT(INT, RIGHT(y.resource_description, CHARINDEX(N'':'', REVERSE(y.resource_description)) - 1)) = 7 OR
															(CONVERT(INT, RIGHT(y.resource_description, CHARINDEX(N'':'', REVERSE(y.resource_description)) - 1)) - 7) % 511232 = 0 
																THEN 
																	N''BCM''
														ELSE 
															N''*''
													END +
												N'')''
											WHEN y.wait_type = N''CXPACKET'' THEN
												N'':'' + SUBSTRING(y.resource_description, CHARINDEX(N''nodeId'', y.resource_description) + 7, 4)
											WHEN y.wait_type LIKE N''LATCH[_]%'' THEN
												N'' ['' + LEFT(y.resource_description, COALESCE(NULLIF(CHARINDEX(N'' '', y.resource_description), 0), LEN(y.resource_description) + 1) - 1) + N'']''
											WHEN
												y.wait_type = N''OLEDB''
												AND y.resource_description LIKE N''%(SPID=%)'' THEN
													N''['' + LEFT(y.resource_description, CHARINDEX(N''(SPID='', y.resource_description) - 2) +
														N'':'' + SUBSTRING(y.resource_description, CHARINDEX(N''(SPID='', y.resource_description) + 6, CHARINDEX(N'')'', y.resource_description, (CHARINDEX(N''(SPID='', y.resource_description) + 6)) - (CHARINDEX(N''(SPID='', y.resource_description) + 6)) + '']''
											ELSE
												N''''
										END COLLATE Latin1_General_Bin2 AS sys_wait_info, 
										'
							ELSE
								''
						END +
						CASE
							WHEN @get_task_info = 2 THEN
								'tasks.physical_io,
								tasks.context_switches,
								tasks.tasks,
								tasks.block_info,
								tasks.wait_info AS task_wait_info,
								tasks.thread_CPU_snapshot,
								'
							ELSE
								'' 
					END +
					CASE 
						WHEN NOT (@get_avg_time = 1 AND @recursion = 1) THEN
							'CONVERT(INT, NULL) '
						ELSE 
							'qs.total_elapsed_time / qs.execution_count '
					END + 
						'AS avg_elapsed_time 
				FROM
				(
					SELECT TOP(@i)
						sp.session_id,
						sp.request_id,
						COALESCE(r.logical_reads, s.logical_reads) AS reads,
						COALESCE(r.reads, s.reads) AS physical_reads,
						COALESCE(r.writes, s.writes) AS writes,
						COALESCE(r.CPU_time, s.CPU_time) AS CPU,
						sp.memory_usage + COALESCE(r.granted_query_memory, 0) AS used_memory,
						LOWER(sp.status) AS status,
						COALESCE(r.sql_handle, sp.sql_handle) AS sql_handle,
						COALESCE(r.statement_start_offset, sp.statement_start_offset) AS statement_start_offset,
						COALESCE(r.statement_end_offset, sp.statement_end_offset) AS statement_end_offset,
						' +
						CASE
							WHEN 
							(
								@get_task_info <> 0
								OR @find_block_leaders = 1 
							) THEN
								'sp.wait_type COLLATE Latin1_General_Bin2 AS wait_type,
								sp.wait_resource COLLATE Latin1_General_Bin2 AS resource_description,
								sp.wait_time AS wait_duration_ms, 
								'
							ELSE
								''
						END +
						'NULLIF(sp.blocked, 0) AS blocking_session_id,
						r.plan_handle,
						NULLIF(r.percent_complete, 0) AS percent_complete,
						sp.host_name,
						sp.login_name,
						sp.program_name,
						s.host_process_id,
						COALESCE(r.text_size, s.text_size) AS text_size,
						COALESCE(r.language, s.language) AS language,
						COALESCE(r.date_format, s.date_format) AS date_format,
						COALESCE(r.date_first, s.date_first) AS date_first,
						COALESCE(r.quoted_identifier, s.quoted_identifier) AS quoted_identifier,
						COALESCE(r.arithabort, s.arithabort) AS arithabort,
						COALESCE(r.ansi_null_dflt_on, s.ansi_null_dflt_on) AS ansi_null_dflt_on,
						COALESCE(r.ansi_defaults, s.ansi_defaults) AS ansi_defaults,
						COALESCE(r.ansi_warnings, s.ansi_warnings) AS ansi_warnings,
						COALESCE(r.ansi_padding, s.ansi_padding) AS ansi_padding,
						COALESCE(r.ansi_nulls, s.ansi_nulls) AS ansi_nulls,
						COALESCE(r.concat_null_yields_null, s.concat_null_yields_null) AS concat_null_yields_null,
						COALESCE(r.transaction_isolation_level, s.transaction_isolation_level) AS transaction_isolation_level,
						COALESCE(r.lock_timeout, s.lock_timeout) AS lock_timeout,
						COALESCE(r.deadlock_priority, s.deadlock_priority) AS deadlock_priority,
						COALESCE(r.row_count, s.row_count) AS row_count,
						COALESCE(r.command, sp.cmd) AS command_type,
						COALESCE
						(
							CASE
								WHEN
								(
									s.is_user_process = 0
									AND r.total_elapsed_time >= 0
								) THEN
									DATEADD
									(
										ms,
										1000 * (DATEPART(ms, DATEADD(second, -(r.total_elapsed_time / 1000), GETDATE())) / 500) - DATEPART(ms, DATEADD(second, -(r.total_elapsed_time / 1000), GETDATE())),
										DATEADD(second, -(r.total_elapsed_time / 1000), GETDATE())
									)
							END,
							NULLIF(COALESCE(r.start_time, sp.last_request_end_time), CONVERT(DATETIME, ''19000101'', 112)),
							sp.login_time
						) AS start_time,
						sp.login_time,
						CASE
							WHEN s.is_user_process = 1 THEN
								s.last_request_start_time
							ELSE
								COALESCE
								(
									DATEADD
									(
										ms,
										1000 * (DATEPART(ms, DATEADD(second, -(r.total_elapsed_time / 1000), GETDATE())) / 500) - DATEPART(ms, DATEADD(second, -(r.total_elapsed_time / 1000), GETDATE())),
										DATEADD(second, -(r.total_elapsed_time / 1000), GETDATE())
									),
									s.last_request_start_time
								)
						END AS last_request_start_time,
						r.transaction_id,
						sp.database_id,
						sp.open_tran_count,
						' +
							CASE
								WHEN EXISTS
								(
									SELECT
										*
									FROM sys.all_columns AS ac
									WHERE
										ac.object_id = OBJECT_ID('sys.dm_exec_sessions')
										AND ac.name = 'group_id'
								)
									THEN 's.group_id'
								ELSE 'CONVERT(INT, NULL) AS group_id'
							END + '
					FROM @sessions AS sp
					LEFT OUTER LOOP JOIN sys.dm_exec_sessions AS s ON
						s.session_id = sp.session_id
						AND s.login_time = sp.login_time
					LEFT OUTER LOOP JOIN sys.dm_exec_requests AS r ON
						sp.status <> ''sleeping''
						AND r.session_id = sp.session_id
						AND r.request_id = sp.request_id
						AND
						(
							(
								s.is_user_process = 0
								AND sp.is_user_process = 0
							)
							OR
							(
								r.start_time = s.last_request_start_time
								AND s.last_request_end_time <= sp.last_request_end_time
							)
						)
				) AS y
				' + 
				CASE 
					WHEN @get_task_info = 2 THEN
						CONVERT(VARCHAR(MAX), '') +
						'LEFT OUTER HASH JOIN
						(
							SELECT TOP(@i)
								task_nodes.task_node.value(''(session_id/text())[1]'', ''SMALLINT'') AS session_id,
								task_nodes.task_node.value(''(request_id/text())[1]'', ''INT'') AS request_id,
								task_nodes.task_node.value(''(physical_io/text())[1]'', ''BIGINT'') AS physical_io,
								task_nodes.task_node.value(''(context_switches/text())[1]'', ''BIGINT'') AS context_switches,
								task_nodes.task_node.value(''(tasks/text())[1]'', ''INT'') AS tasks,
								task_nodes.task_node.value(''(block_info/text())[1]'', ''NVARCHAR(4000)'') AS block_info,
								task_nodes.task_node.value(''(waits/text())[1]'', ''NVARCHAR(4000)'') AS wait_info,
								task_nodes.task_node.value(''(thread_CPU_snapshot/text())[1]'', ''BIGINT'') AS thread_CPU_snapshot
							FROM
							(
								SELECT TOP(@i)
									CONVERT
									(
										XML,
										REPLACE
										(
											CONVERT(NVARCHAR(MAX), tasks_raw.task_xml_raw) COLLATE Latin1_General_Bin2,
											N''</waits></tasks><tasks><waits>'',
											N'', ''
										)
									) AS task_xml
								FROM
								(
									SELECT TOP(@i)
										CASE waits.r
											WHEN 1 THEN
												waits.session_id
											ELSE
												NULL
										END AS [session_id],
										CASE waits.r
											WHEN 1 THEN
												waits.request_id
											ELSE
												NULL
										END AS [request_id],											
										CASE waits.r
											WHEN 1 THEN
												waits.physical_io
											ELSE
												NULL
										END AS [physical_io],
										CASE waits.r
											WHEN 1 THEN
												waits.context_switches
											ELSE
												NULL
										END AS [context_switches],
										CASE waits.r
											WHEN 1 THEN
												waits.thread_CPU_snapshot
											ELSE
												NULL
										END AS [thread_CPU_snapshot],
										CASE waits.r
											WHEN 1 THEN
												waits.tasks
											ELSE
												NULL
										END AS [tasks],
										CASE waits.r
											WHEN 1 THEN
												waits.block_info
											ELSE
												NULL
										END AS [block_info],
										REPLACE
										(
											REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
											REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
											REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
												CONVERT
												(
													NVARCHAR(MAX),
													N''('' +
														CONVERT(NVARCHAR, num_waits) + N''x: '' +
														CASE num_waits
															WHEN 1 THEN
																CONVERT(NVARCHAR, min_wait_time) + N''ms''
															WHEN 2 THEN
																CASE
																	WHEN min_wait_time <> max_wait_time THEN
																		CONVERT(NVARCHAR, min_wait_time) + N''/'' + CONVERT(NVARCHAR, max_wait_time) + N''ms''
																	ELSE
																		CONVERT(NVARCHAR, max_wait_time) + N''ms''
																END
															ELSE
																CASE
																	WHEN min_wait_time <> max_wait_time THEN
																		CONVERT(NVARCHAR, min_wait_time) + N''/'' + CONVERT(NVARCHAR, avg_wait_time) + N''/'' + CONVERT(NVARCHAR, max_wait_time) + N''ms''
																	ELSE 
																		CONVERT(NVARCHAR, max_wait_time) + N''ms''
																END
														END +
													N'')'' + wait_type COLLATE Latin1_General_Bin2
												),
												NCHAR(31),N''?''),NCHAR(30),N''?''),NCHAR(29),N''?''),NCHAR(28),N''?''),NCHAR(27),N''?''),NCHAR(26),N''?''),NCHAR(25),N''?''),NCHAR(24),N''?''),NCHAR(23),N''?''),NCHAR(22),N''?''),
												NCHAR(21),N''?''),NCHAR(20),N''?''),NCHAR(19),N''?''),NCHAR(18),N''?''),NCHAR(17),N''?''),NCHAR(16),N''?''),NCHAR(15),N''?''),NCHAR(14),N''?''),NCHAR(12),N''?''),
												NCHAR(11),N''?''),NCHAR(8),N''?''),NCHAR(7),N''?''),NCHAR(6),N''?''),NCHAR(5),N''?''),NCHAR(4),N''?''),NCHAR(3),N''?''),NCHAR(2),N''?''),NCHAR(1),N''?''),
											NCHAR(0),
											N''''
										) AS [waits]
									FROM
									(
										SELECT TOP(@i)
											w1.*,
											ROW_NUMBER() OVER
											(
												PARTITION BY
													w1.session_id,
													w1.request_id
												ORDER BY
													w1.block_info DESC,
													w1.num_waits DESC,
													w1.wait_type
											) AS r
										FROM
										(
											SELECT TOP(@i)
												task_info.session_id,
												task_info.request_id,
												task_info.physical_io,
												task_info.context_switches,
												task_info.thread_CPU_snapshot,
												task_info.num_tasks AS tasks,
												CASE
													WHEN task_info.runnable_time IS NOT NULL THEN
														''RUNNABLE''
													ELSE
														wt2.wait_type
												END AS wait_type,
												NULLIF(COUNT(COALESCE(task_info.runnable_time, wt2.waiting_task_address)), 0) AS num_waits,
												MIN(COALESCE(task_info.runnable_time, wt2.wait_duration_ms)) AS min_wait_time,
												AVG(COALESCE(task_info.runnable_time, wt2.wait_duration_ms)) AS avg_wait_time,
												MAX(COALESCE(task_info.runnable_time, wt2.wait_duration_ms)) AS max_wait_time,
												MAX(wt2.block_info) AS block_info
											FROM
											(
												SELECT TOP(@i)
													t.session_id,
													t.request_id,
													SUM(CONVERT(BIGINT, t.pending_io_count)) OVER (PARTITION BY t.session_id, t.request_id) AS physical_io,
													SUM(CONVERT(BIGINT, t.context_switches_count)) OVER (PARTITION BY t.session_id, t.request_id) AS context_switches, 
													' +
													CASE
														WHEN 
															@output_column_list LIKE '%|[CPU_delta|]%' ESCAPE '|'
															AND @sys_info = 1
															THEN
																'SUM(tr.usermode_time + tr.kernel_time) OVER (PARTITION BY t.session_id, t.request_id) '
														ELSE
															'CONVERT(BIGINT, NULL) '
													END + 
														' AS thread_CPU_snapshot, 
													COUNT(*) OVER (PARTITION BY t.session_id, t.request_id) AS num_tasks,
													t.task_address,
													t.task_state,
													CASE
														WHEN
															t.task_state = ''RUNNABLE''
															AND w.runnable_time > 0 THEN
																w.runnable_time
														ELSE
															NULL
													END AS runnable_time
												FROM sys.dm_os_tasks AS t
												CROSS APPLY
												(
													SELECT TOP(1)
														sp2.session_id
													FROM @sessions AS sp2
													WHERE
														sp2.session_id = t.session_id
														AND sp2.request_id = t.request_id
														AND sp2.status <> ''sleeping''
												) AS sp20
												LEFT OUTER HASH JOIN
												( 
												' +
													CASE
														WHEN @sys_info = 1 THEN
															'SELECT TOP(@i)
																(
																	SELECT TOP(@i)
																		ms_ticks
																	FROM sys.dm_os_sys_info
																) -
																	w0.wait_resumed_ms_ticks AS runnable_time,
																w0.worker_address,
																w0.thread_address,
																w0.task_bound_ms_ticks
															FROM sys.dm_os_workers AS w0
															WHERE
																w0.state = ''RUNNABLE''
																OR @first_collection_ms_ticks >= w0.task_bound_ms_ticks'
														ELSE
															'SELECT
																CONVERT(BIGINT, NULL) AS runnable_time,
																CONVERT(VARBINARY(8), NULL) AS worker_address,
																CONVERT(VARBINARY(8), NULL) AS thread_address,
																CONVERT(BIGINT, NULL) AS task_bound_ms_ticks
															WHERE
																1 = 0'
														END +
												'
												) AS w ON
													w.worker_address = t.worker_address 
												' +
												CASE
													WHEN
														@output_column_list LIKE '%|[CPU_delta|]%' ESCAPE '|'
														AND @sys_info = 1
														THEN
															'LEFT OUTER HASH JOIN sys.dm_os_threads AS tr ON
																tr.thread_address = w.thread_address
																AND @first_collection_ms_ticks >= w.task_bound_ms_ticks
															'
													ELSE
														''
												END +
											') AS task_info
											LEFT OUTER HASH JOIN
											(
												SELECT TOP(@i)
													wt1.wait_type,
													wt1.waiting_task_address,
													MAX(wt1.wait_duration_ms) AS wait_duration_ms,
													MAX(wt1.block_info) AS block_info
												FROM
												(
													SELECT DISTINCT TOP(@i)
														wt.wait_type +
															CASE
																WHEN wt.wait_type LIKE N''PAGE%LATCH_%'' THEN
																	'':'' +
																	COALESCE(DB_NAME(CONVERT(INT, LEFT(wt.resource_description, CHARINDEX(N'':'', wt.resource_description) - 1))), N''(null)'') +
																	N'':'' +
																	SUBSTRING(wt.resource_description, CHARINDEX(N'':'', wt.resource_description) + 1, LEN(wt.resource_description) - CHARINDEX(N'':'', REVERSE(wt.resource_description)) - CHARINDEX(N'':'', wt.resource_description)) +
																	N''('' +
																		CASE
																			WHEN
																				CONVERT(INT, RIGHT(wt.resource_description, CHARINDEX(N'':'', REVERSE(wt.resource_description)) - 1)) = 1 OR
																				CONVERT(INT, RIGHT(wt.resource_description, CHARINDEX(N'':'', REVERSE(wt.resource_description)) - 1)) % 8088 = 0
																					THEN 
																						N''PFS''
																			WHEN
																				CONVERT(INT, RIGHT(wt.resource_description, CHARINDEX(N'':'', REVERSE(wt.resource_description)) - 1)) = 2 OR
																				CONVERT(INT, RIGHT(wt.resource_description, CHARINDEX(N'':'', REVERSE(wt.resource_description)) - 1)) % 511232 = 0 
																					THEN 
																						N''GAM''
																			WHEN
																				CONVERT(INT, RIGHT(wt.resource_description, CHARINDEX(N'':'', REVERSE(wt.resource_description)) - 1)) = 3 OR
																				(CONVERT(INT, RIGHT(wt.resource_description, CHARINDEX(N'':'', REVERSE(wt.resource_description)) - 1)) - 1) % 511232 = 0 
																					THEN 
																						N''SGAM''
																			WHEN
																				CONVERT(INT, RIGHT(wt.resource_description, CHARINDEX(N'':'', REVERSE(wt.resource_description)) - 1)) = 6 OR
																				(CONVERT(INT, RIGHT(wt.resource_description, CHARINDEX(N'':'', REVERSE(wt.resource_description)) - 1)) - 6) % 511232 = 0 
																					THEN 
																						N''DCM''
																			WHEN
																				CONVERT(INT, RIGHT(wt.resource_description, CHARINDEX(N'':'', REVERSE(wt.resource_description)) - 1)) = 7 OR
																				(CONVERT(INT, RIGHT(wt.resource_description, CHARINDEX(N'':'', REVERSE(wt.resource_description)) - 1)) - 7) % 511232 = 0
																					THEN 
																						N''BCM''
																			ELSE
																				N''*''
																		END +
																	N'')''
																WHEN wt.wait_type = N''CXPACKET'' THEN
																	N'':'' + SUBSTRING(wt.resource_description, CHARINDEX(N''nodeId'', wt.resource_description) + 7, 4)
																WHEN wt.wait_type LIKE N''LATCH[_]%'' THEN
																	N'' ['' + LEFT(wt.resource_description, COALESCE(NULLIF(CHARINDEX(N'' '', wt.resource_description), 0), LEN(wt.resource_description) + 1) - 1) + N'']''
																ELSE 
																	N''''
															END COLLATE Latin1_General_Bin2 AS wait_type,
														CASE
															WHEN
															(
																wt.blocking_session_id IS NOT NULL
																AND wt.wait_type LIKE N''LCK[_]%''
															) THEN
																(
																	SELECT TOP(@i)
																		x.lock_type,
																		REPLACE
																		(
																			REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
																			REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
																			REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
																				DB_NAME
																				(
																					CONVERT
																					(
																						INT,
																						SUBSTRING(wt.resource_description, NULLIF(CHARINDEX(N''dbid='', wt.resource_description), 0) + 5, COALESCE(NULLIF(CHARINDEX(N'' '', wt.resource_description, CHARINDEX(N''dbid='', wt.resource_description) + 5), 0), LEN(wt.resource_description) + 1) - CHARINDEX(N''dbid='', wt.resource_description) - 5)
																					)
																				),
																				NCHAR(31),N''?''),NCHAR(30),N''?''),NCHAR(29),N''?''),NCHAR(28),N''?''),NCHAR(27),N''?''),NCHAR(26),N''?''),NCHAR(25),N''?''),NCHAR(24),N''?''),NCHAR(23),N''?''),NCHAR(22),N''?''),
																				NCHAR(21),N''?''),NCHAR(20),N''?''),NCHAR(19),N''?''),NCHAR(18),N''?''),NCHAR(17),N''?''),NCHAR(16),N''?''),NCHAR(15),N''?''),NCHAR(14),N''?''),NCHAR(12),N''?''),
																				NCHAR(11),N''?''),NCHAR(8),N''?''),NCHAR(7),N''?''),NCHAR(6),N''?''),NCHAR(5),N''?''),NCHAR(4),N''?''),NCHAR(3),N''?''),NCHAR(2),N''?''),NCHAR(1),N''?''),
																			NCHAR(0),
																			N''''
																		) AS database_name,
																		CASE x.lock_type
																			WHEN N''objectlock'' THEN
																				SUBSTRING(wt.resource_description, NULLIF(CHARINDEX(N''objid='', wt.resource_description), 0) + 6, COALESCE(NULLIF(CHARINDEX(N'' '', wt.resource_description, CHARINDEX(N''objid='', wt.resource_description) + 6), 0), LEN(wt.resource_description) + 1) - CHARINDEX(N''objid='', wt.resource_description) - 6)
																			ELSE
																				NULL
																		END AS object_id,
																		CASE x.lock_type
																			WHEN N''filelock'' THEN
																				SUBSTRING(wt.resource_description, NULLIF(CHARINDEX(N''fileid='', wt.resource_description), 0) + 7, COALESCE(NULLIF(CHARINDEX(N'' '', wt.resource_description, CHARINDEX(N''fileid='', wt.resource_description) + 7), 0), LEN(wt.resource_description) + 1) - CHARINDEX(N''fileid='', wt.resource_description) - 7)
																			ELSE
																				NULL
																		END AS file_id,
																		CASE
																			WHEN x.lock_type in (N''pagelock'', N''extentlock'', N''ridlock'') THEN
																				SUBSTRING(wt.resource_description, NULLIF(CHARINDEX(N''associatedObjectId='', wt.resource_description), 0) + 19, COALESCE(NULLIF(CHARINDEX(N'' '', wt.resource_description, CHARINDEX(N''associatedObjectId='', wt.resource_description) + 19), 0), LEN(wt.resource_description) + 1) - CHARINDEX(N''associatedObjectId='', wt.resource_description) - 19)
																			WHEN x.lock_type in (N''keylock'', N''hobtlock'', N''allocunitlock'') THEN
																				SUBSTRING(wt.resource_description, NULLIF(CHARINDEX(N''hobtid='', wt.resource_description), 0) + 7, COALESCE(NULLIF(CHARINDEX(N'' '', wt.resource_description, CHARINDEX(N''hobtid='', wt.resource_description) + 7), 0), LEN(wt.resource_description) + 1) - CHARINDEX(N''hobtid='', wt.resource_description) - 7)
																			ELSE
																				NULL
																		END AS hobt_id,
																		CASE x.lock_type
																			WHEN N''applicationlock'' THEN
																				SUBSTRING(wt.resource_description, NULLIF(CHARINDEX(N''hash='', wt.resource_description), 0) + 5, COALESCE(NULLIF(CHARINDEX(N'' '', wt.resource_description, CHARINDEX(N''hash='', wt.resource_description) + 5), 0), LEN(wt.resource_description) + 1) - CHARINDEX(N''hash='', wt.resource_description) - 5)
																			ELSE
																				NULL
																		END AS applock_hash,
																		CASE x.lock_type
																			WHEN N''metadatalock'' THEN
																				SUBSTRING(wt.resource_description, NULLIF(CHARINDEX(N''subresource='', wt.resource_description), 0) + 12, COALESCE(NULLIF(CHARINDEX(N'' '', wt.resource_description, CHARINDEX(N''subresource='', wt.resource_description) + 12), 0), LEN(wt.resource_description) + 1) - CHARINDEX(N''subresource='', wt.resource_description) - 12)
																			ELSE
																				NULL
																		END AS metadata_resource,
																		CASE x.lock_type
																			WHEN N''metadatalock'' THEN
																				SUBSTRING(wt.resource_description, NULLIF(CHARINDEX(N''classid='', wt.resource_description), 0) + 8, COALESCE(NULLIF(CHARINDEX(N'' dbid='', wt.resource_description) - CHARINDEX(N''classid='', wt.resource_description), 0), LEN(wt.resource_description) + 1) - 8)
																			ELSE
																				NULL
																		END AS metadata_class_id
																	FROM
																	(
																		SELECT TOP(1)
																			LEFT(wt.resource_description, CHARINDEX(N'' '', wt.resource_description) - 1) COLLATE Latin1_General_Bin2 AS lock_type
																	) AS x
																	FOR XML
																		PATH('''')
																)
															ELSE NULL
														END AS block_info,
														wt.wait_duration_ms,
														wt.waiting_task_address
													FROM
													(
														SELECT TOP(@i)
															wt0.wait_type COLLATE Latin1_General_Bin2 AS wait_type,
															wt0.resource_description COLLATE Latin1_General_Bin2 AS resource_description,
															wt0.wait_duration_ms,
															wt0.waiting_task_address,
															CASE
																WHEN wt0.blocking_session_id = p.blocked THEN
																	wt0.blocking_session_id
																ELSE
																	NULL
															END AS blocking_session_id
														FROM sys.dm_os_waiting_tasks AS wt0
														CROSS APPLY
														(
															SELECT TOP(1)
																s0.blocked
															FROM @sessions AS s0
															WHERE
																s0.session_id = wt0.session_id
																AND COALESCE(s0.wait_type, N'''') <> N''OLEDB''
																AND wt0.wait_type <> N''OLEDB''
														) AS p
													) AS wt
												) AS wt1
												GROUP BY
													wt1.wait_type,
													wt1.waiting_task_address
											) AS wt2 ON
												wt2.waiting_task_address = task_info.task_address
												AND wt2.wait_duration_ms > 0
												AND task_info.runnable_time IS NULL
											GROUP BY
												task_info.session_id,
												task_info.request_id,
												task_info.physical_io,
												task_info.context_switches,
												task_info.thread_CPU_snapshot,
												task_info.num_tasks,
												CASE
													WHEN task_info.runnable_time IS NOT NULL THEN
														''RUNNABLE''
													ELSE
														wt2.wait_type
												END
										) AS w1
									) AS waits
									ORDER BY
										waits.session_id,
										waits.request_id,
										waits.r
									FOR XML
										PATH(N''tasks''),
										TYPE
								) AS tasks_raw (task_xml_raw)
							) AS tasks_final
							CROSS APPLY tasks_final.task_xml.nodes(N''/tasks'') AS task_nodes (task_node)
							WHERE
								task_nodes.task_node.exist(N''session_id'') = 1
						) AS tasks ON
							tasks.session_id = y.session_id
							AND tasks.request_id = y.request_id 
						'
					ELSE
						''
				END +
				'LEFT OUTER HASH JOIN
				(
					SELECT TOP(@i)
						t_info.session_id,
						COALESCE(t_info.request_id, -1) AS request_id,
						SUM(t_info.tempdb_allocations) AS tempdb_allocations,
						SUM(t_info.tempdb_current) AS tempdb_current
					FROM
					(
						SELECT TOP(@i)
							tsu.session_id,
							tsu.request_id,
							tsu.user_objects_alloc_page_count +
								tsu.internal_objects_alloc_page_count AS tempdb_allocations,
							tsu.user_objects_alloc_page_count +
								tsu.internal_objects_alloc_page_count -
								tsu.user_objects_dealloc_page_count -
								tsu.internal_objects_dealloc_page_count AS tempdb_current
						FROM sys.dm_db_task_space_usage AS tsu
						CROSS APPLY
						(
							SELECT TOP(1)
								s0.session_id
							FROM @sessions AS s0
							WHERE
								s0.session_id = tsu.session_id
						) AS p

						UNION ALL

						SELECT TOP(@i)
							ssu.session_id,
							NULL AS request_id,
							ssu.user_objects_alloc_page_count +
								ssu.internal_objects_alloc_page_count AS tempdb_allocations,
							ssu.user_objects_alloc_page_count +
								ssu.internal_objects_alloc_page_count -
								ssu.user_objects_dealloc_page_count -
								ssu.internal_objects_dealloc_page_count AS tempdb_current
						FROM sys.dm_db_session_space_usage AS ssu
						CROSS APPLY
						(
							SELECT TOP(1)
								s0.session_id
							FROM @sessions AS s0
							WHERE
								s0.session_id = ssu.session_id
						) AS p
					) AS t_info
					GROUP BY
						t_info.session_id,
						COALESCE(t_info.request_id, -1)
				) AS tempdb_info ON
					tempdb_info.session_id = y.session_id
					AND tempdb_info.request_id =
						CASE
							WHEN y.status = N''sleeping'' THEN
								-1
							ELSE
								y.request_id
						END
				' +
				CASE 
					WHEN 
						NOT 
						(
							@get_avg_time = 1 
							AND @recursion = 1
						) THEN 
							''
					ELSE
						'LEFT OUTER HASH JOIN
						(
							SELECT TOP(@i)
								*
							FROM sys.dm_exec_query_stats
						) AS qs ON
							qs.sql_handle = y.sql_handle
							AND qs.plan_handle = y.plan_handle
							AND qs.statement_start_offset = y.statement_start_offset
							AND qs.statement_end_offset = y.statement_end_offset
						'
				END + 
			') AS x
			OPTION (KEEPFIXED PLAN, OPTIMIZE FOR (@i = 1)); ';

		SET @sql_n = CONVERT(NVARCHAR(MAX), @sql);

		SET @last_collection_start = GETDATE();

		IF 
			@recursion = -1
			AND @sys_info = 1
		BEGIN;
			SELECT
				@first_collection_ms_ticks = ms_ticks
			FROM sys.dm_os_sys_info;
		END;

		INSERT #sessions
		(
			recursion,
			session_id,
			request_id,
			session_number,
			elapsed_time,
			avg_elapsed_time,
			physical_io,
			reads,
			physical_reads,
			writes,
			tempdb_allocations,
			tempdb_current,
			CPU,
			thread_CPU_snapshot,
			context_switches,
			used_memory,
			tasks,
			status,
			wait_info,
			transaction_id,
			open_tran_count,
			sql_handle,
			statement_start_offset,
			statement_end_offset,		
			sql_text,
			plan_handle,
			blocking_session_id,
			percent_complete,
			host_name,
			login_name,
			database_name,
			program_name,
			additional_info,
			start_time,
			login_time,
			last_request_start_time
		)
		EXEC sp_executesql 
			@sql_n,
			N'@recursion SMALLINT, @filter sysname, @not_filter sysname, @first_collection_ms_ticks BIGINT',
			@recursion, @filter, @not_filter, @first_collection_ms_ticks;

		--Collect transaction information?
		IF
			@recursion = 1
			AND
			(
				@output_column_list LIKE '%|[tran_start_time|]%' ESCAPE '|'
				OR @output_column_list LIKE '%|[tran_log_writes|]%' ESCAPE '|' 
			)
		BEGIN;	
			DECLARE @i INT;
			SET @i = 2147483647;

			UPDATE s
			SET
				tran_start_time =
					CONVERT
					(
						DATETIME,
						LEFT
						(
							x.trans_info,
							NULLIF(CHARINDEX(NCHAR(254) COLLATE Latin1_General_Bin2, x.trans_info) - 1, -1)
						),
						121
					),
				tran_log_writes =
					RIGHT
					(
						x.trans_info,
						LEN(x.trans_info) - CHARINDEX(NCHAR(254) COLLATE Latin1_General_Bin2, x.trans_info)
					)
			FROM
			(
				SELECT TOP(@i)
					trans_nodes.trans_node.value('(session_id/text())[1]', 'SMALLINT') AS session_id,
					COALESCE(trans_nodes.trans_node.value('(request_id/text())[1]', 'INT'), 0) AS request_id,
					trans_nodes.trans_node.value('(trans_info/text())[1]', 'NVARCHAR(4000)') AS trans_info				
				FROM
				(
					SELECT TOP(@i)
						CONVERT
						(
							XML,
							REPLACE
							(
								CONVERT(NVARCHAR(MAX), trans_raw.trans_xml_raw) COLLATE Latin1_General_Bin2, 
								N'</trans_info></trans><trans><trans_info>', N''
							)
						)
					FROM
					(
						SELECT TOP(@i)
							CASE u_trans.r
								WHEN 1 THEN u_trans.session_id
								ELSE NULL
							END AS [session_id],
							CASE u_trans.r
								WHEN 1 THEN u_trans.request_id
								ELSE NULL
							END AS [request_id],
							CONVERT
							(
								NVARCHAR(MAX),
								CASE
									WHEN u_trans.database_id IS NOT NULL THEN
										CASE u_trans.r
											WHEN 1 THEN COALESCE(CONVERT(NVARCHAR, u_trans.transaction_start_time, 121) + NCHAR(254), N'')
											ELSE N''
										END + 
											REPLACE
											(
												REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
												REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
												REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
													CONVERT(VARCHAR(128), COALESCE(DB_NAME(u_trans.database_id), N'(null)')),
													NCHAR(31),N'?'),NCHAR(30),N'?'),NCHAR(29),N'?'),NCHAR(28),N'?'),NCHAR(27),N'?'),NCHAR(26),N'?'),NCHAR(25),N'?'),NCHAR(24),N'?'),NCHAR(23),N'?'),NCHAR(22),N'?'),
													NCHAR(21),N'?'),NCHAR(20),N'?'),NCHAR(19),N'?'),NCHAR(18),N'?'),NCHAR(17),N'?'),NCHAR(16),N'?'),NCHAR(15),N'?'),NCHAR(14),N'?'),NCHAR(12),N'?'),
													NCHAR(11),N'?'),NCHAR(8),N'?'),NCHAR(7),N'?'),NCHAR(6),N'?'),NCHAR(5),N'?'),NCHAR(4),N'?'),NCHAR(3),N'?'),NCHAR(2),N'?'),NCHAR(1),N'?'),
												NCHAR(0),
												N'?'
											) +
											N': ' +
										CONVERT(NVARCHAR, u_trans.log_record_count) + N' (' + CONVERT(NVARCHAR, u_trans.log_kb_used) + N' kB)' +
										N','
									ELSE
										N'N/A,'
								END COLLATE Latin1_General_Bin2
							) AS [trans_info]
						FROM
						(
							SELECT TOP(@i)
								trans.*,
								ROW_NUMBER() OVER
								(
									PARTITION BY
										trans.session_id,
										trans.request_id
									ORDER BY
										trans.transaction_start_time DESC
								) AS r
							FROM
							(
								SELECT TOP(@i)
									session_tran_map.session_id,
									session_tran_map.request_id,
									s_tran.database_id,
									COALESCE(SUM(s_tran.database_transaction_log_record_count), 0) AS log_record_count,
									COALESCE(SUM(s_tran.database_transaction_log_bytes_used), 0) / 1024 AS log_kb_used,
									MIN(s_tran.database_transaction_begin_time) AS transaction_start_time
								FROM
								(
									SELECT TOP(@i)
										*
									FROM sys.dm_tran_active_transactions
									WHERE
										transaction_begin_time <= @last_collection_start
								) AS a_tran
								INNER HASH JOIN
								(
									SELECT TOP(@i)
										*
									FROM sys.dm_tran_database_transactions
									WHERE
										database_id < 32767
								) AS s_tran ON
									s_tran.transaction_id = a_tran.transaction_id
								LEFT OUTER HASH JOIN
								(
									SELECT TOP(@i)
										*
									FROM sys.dm_tran_session_transactions
								) AS tst ON
									s_tran.transaction_id = tst.transaction_id
								CROSS APPLY
								(
									SELECT TOP(1)
										s3.session_id,
										s3.request_id
									FROM
									(
										SELECT TOP(1)
											s1.session_id,
											s1.request_id
										FROM #sessions AS s1
										WHERE
											s1.transaction_id = s_tran.transaction_id
											AND s1.recursion = 1
											
										UNION ALL
									
										SELECT TOP(1)
											s2.session_id,
											s2.request_id
										FROM #sessions AS s2
										WHERE
											s2.session_id = tst.session_id
											AND s2.recursion = 1
									) AS s3
									ORDER BY
										s3.request_id
								) AS session_tran_map
								GROUP BY
									session_tran_map.session_id,
									session_tran_map.request_id,
									s_tran.database_id
							) AS trans
						) AS u_trans
						FOR XML
							PATH('trans'),
							TYPE
					) AS trans_raw (trans_xml_raw)
				) AS trans_final (trans_xml)
				CROSS APPLY trans_final.trans_xml.nodes('/trans') AS trans_nodes (trans_node)
			) AS x
			INNER HASH JOIN #sessions AS s ON
				s.session_id = x.session_id
				AND s.request_id = x.request_id
			OPTION (OPTIMIZE FOR (@i = 1));
		END;

		--Variables for text and plan collection
		DECLARE	
			@session_id SMALLINT,
			@request_id INT,
			@sql_handle VARBINARY(64),
			@plan_handle VARBINARY(64),
			@statement_start_offset INT,
			@statement_end_offset INT,
			@start_time DATETIME,
			@database_name sysname;

		IF 
			@recursion = 1
			AND @output_column_list LIKE '%|[sql_text|]%' ESCAPE '|'
		BEGIN;
			DECLARE sql_cursor
			CURSOR LOCAL FAST_FORWARD
			FOR 
				SELECT 
					session_id,
					request_id,
					sql_handle,
					statement_start_offset,
					statement_end_offset
				FROM #sessions
				WHERE
					recursion = 1
					AND sql_handle IS NOT NULL
			OPTION (KEEPFIXED PLAN);

			OPEN sql_cursor;

			FETCH NEXT FROM sql_cursor
			INTO 
				@session_id,
				@request_id,
				@sql_handle,
				@statement_start_offset,
				@statement_end_offset;

			--Wait up to 5 ms for the SQL text, then give up
			SET LOCK_TIMEOUT 5;

			WHILE @@FETCH_STATUS = 0
			BEGIN;
				BEGIN TRY;
					UPDATE s
					SET
						s.sql_text =
						(
							SELECT
								REPLACE
								(
									REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
									REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
									REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
										N'--' + NCHAR(13) + NCHAR(10) +
										CASE 
											WHEN @get_full_inner_text = 1 THEN est.text
											WHEN LEN(est.text) < (@statement_end_offset / 2) + 1 THEN est.text
											WHEN SUBSTRING(est.text, (@statement_start_offset/2), 2) LIKE N'[a-zA-Z0-9][a-zA-Z0-9]' THEN est.text
											ELSE
												CASE
													WHEN @statement_start_offset > 0 THEN
														SUBSTRING
														(
															est.text,
															((@statement_start_offset/2) + 1),
															(
																CASE
																	WHEN @statement_end_offset = -1 THEN 2147483647
																	ELSE ((@statement_end_offset - @statement_start_offset)/2) + 1
																END
															)
														)
													ELSE RTRIM(LTRIM(est.text))
												END
										END +
										NCHAR(13) + NCHAR(10) + N'--' COLLATE Latin1_General_Bin2,
										NCHAR(31),N'?'),NCHAR(30),N'?'),NCHAR(29),N'?'),NCHAR(28),N'?'),NCHAR(27),N'?'),NCHAR(26),N'?'),NCHAR(25),N'?'),NCHAR(24),N'?'),NCHAR(23),N'?'),NCHAR(22),N'?'),
										NCHAR(21),N'?'),NCHAR(20),N'?'),NCHAR(19),N'?'),NCHAR(18),N'?'),NCHAR(17),N'?'),NCHAR(16),N'?'),NCHAR(15),N'?'),NCHAR(14),N'?'),NCHAR(12),N'?'),
										NCHAR(11),N'?'),NCHAR(8),N'?'),NCHAR(7),N'?'),NCHAR(6),N'?'),NCHAR(5),N'?'),NCHAR(4),N'?'),NCHAR(3),N'?'),NCHAR(2),N'?'),NCHAR(1),N'?'),
									NCHAR(0),
									N''
								) AS [processing-instruction(query)]
							FOR XML
								PATH(''),
								TYPE
						),
						s.statement_start_offset = 
							CASE 
								WHEN LEN(est.text) < (@statement_end_offset / 2) + 1 THEN 0
								WHEN SUBSTRING(CONVERT(VARCHAR(MAX), est.text), (@statement_start_offset/2), 2) LIKE '[a-zA-Z0-9][a-zA-Z0-9]' THEN 0
								ELSE @statement_start_offset
							END,
						s.statement_end_offset = 
							CASE 
								WHEN LEN(est.text) < (@statement_end_offset / 2) + 1 THEN -1
								WHEN SUBSTRING(CONVERT(VARCHAR(MAX), est.text), (@statement_start_offset/2), 2) LIKE '[a-zA-Z0-9][a-zA-Z0-9]' THEN -1
								ELSE @statement_end_offset
							END
					FROM 
						#sessions AS s,
						(
							SELECT TOP(1)
								text
							FROM
							(
								SELECT 
									text, 
									0 AS row_num
								FROM sys.dm_exec_sql_text(@sql_handle)
								
								UNION ALL
								
								SELECT 
									NULL,
									1 AS row_num
							) AS est0
							ORDER BY
								row_num
						) AS est
					WHERE 
						s.session_id = @session_id
						AND s.request_id = @request_id
						AND s.recursion = 1
					OPTION (KEEPFIXED PLAN);
				END TRY
				BEGIN CATCH;
					UPDATE s
					SET
						s.sql_text = 
							CASE ERROR_NUMBER() 
								WHEN 1222 THEN '<timeout_exceeded />'
								ELSE '<error message="' + ERROR_MESSAGE() + '" />'
							END
					FROM #sessions AS s
					WHERE 
						s.session_id = @session_id
						AND s.request_id = @request_id
						AND s.recursion = 1
					OPTION (KEEPFIXED PLAN);
				END CATCH;

				FETCH NEXT FROM sql_cursor
				INTO
					@session_id,
					@request_id,
					@sql_handle,
					@statement_start_offset,
					@statement_end_offset;
			END;

			--Return this to the default
			SET LOCK_TIMEOUT -1;

			CLOSE sql_cursor;
			DEALLOCATE sql_cursor;
		END;

		IF 
			@get_outer_command = 1 
			AND @recursion = 1
			AND @output_column_list LIKE '%|[sql_command|]%' ESCAPE '|'
		BEGIN;
			DECLARE @buffer_results TABLE
			(
				EventType VARCHAR(30),
				Parameters INT,
				EventInfo NVARCHAR(4000),
				start_time DATETIME,
				session_number INT IDENTITY(1,1) NOT NULL PRIMARY KEY
			);

			DECLARE buffer_cursor
			CURSOR LOCAL FAST_FORWARD
			FOR 
				SELECT 
					session_id,
					MAX(start_time) AS start_time
				FROM #sessions
				WHERE
					recursion = 1
				GROUP BY
					session_id
				ORDER BY
					session_id
				OPTION (KEEPFIXED PLAN);

			OPEN buffer_cursor;

			FETCH NEXT FROM buffer_cursor
			INTO 
				@session_id,
				@start_time;

			WHILE @@FETCH_STATUS = 0
			BEGIN;
				BEGIN TRY;
					--In SQL Server 2008, DBCC INPUTBUFFER will throw 
					--an exception if the session no longer exists
					INSERT @buffer_results
					(
						EventType,
						Parameters,
						EventInfo
					)
					EXEC sp_executesql
						N'DBCC INPUTBUFFER(@session_id) WITH NO_INFOMSGS;',
						N'@session_id SMALLINT',
						@session_id;

					UPDATE br
					SET
						br.start_time = @start_time
					FROM @buffer_results AS br
					WHERE
						br.session_number = 
						(
							SELECT MAX(br2.session_number)
							FROM @buffer_results br2
						);
				END TRY
				BEGIN CATCH
				END CATCH;

				FETCH NEXT FROM buffer_cursor
				INTO 
					@session_id,
					@start_time;
			END;

			UPDATE s
			SET
				sql_command = 
				(
					SELECT 
						REPLACE
						(
							REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
							REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
							REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
								CONVERT
								(
									NVARCHAR(MAX),
									N'--' + NCHAR(13) + NCHAR(10) + br.EventInfo + NCHAR(13) + NCHAR(10) + N'--' COLLATE Latin1_General_Bin2
								),
								NCHAR(31),N'?'),NCHAR(30),N'?'),NCHAR(29),N'?'),NCHAR(28),N'?'),NCHAR(27),N'?'),NCHAR(26),N'?'),NCHAR(25),N'?'),NCHAR(24),N'?'),NCHAR(23),N'?'),NCHAR(22),N'?'),
								NCHAR(21),N'?'),NCHAR(20),N'?'),NCHAR(19),N'?'),NCHAR(18),N'?'),NCHAR(17),N'?'),NCHAR(16),N'?'),NCHAR(15),N'?'),NCHAR(14),N'?'),NCHAR(12),N'?'),
								NCHAR(11),N'?'),NCHAR(8),N'?'),NCHAR(7),N'?'),NCHAR(6),N'?'),NCHAR(5),N'?'),NCHAR(4),N'?'),NCHAR(3),N'?'),NCHAR(2),N'?'),NCHAR(1),N'?'),
							NCHAR(0),
							N''
						) AS [processing-instruction(query)]
					FROM @buffer_results AS br
					WHERE 
						br.session_number = s.session_number
						AND br.start_time = s.start_time
						AND 
						(
							(
								s.start_time = s.last_request_start_time
								AND EXISTS
								(
									SELECT *
									FROM sys.dm_exec_requests r2
									WHERE
										r2.session_id = s.session_id
										AND r2.request_id = s.request_id
										AND r2.start_time = s.start_time
								)
							)
							OR 
							(
								s.request_id = 0
								AND EXISTS
								(
									SELECT *
									FROM sys.dm_exec_sessions s2
									WHERE
										s2.session_id = s.session_id
										AND s2.last_request_start_time = s.last_request_start_time
								)
							)
						)
					FOR XML
						PATH(''),
						TYPE
				)
			FROM #sessions AS s
			WHERE
				recursion = 1
			OPTION (KEEPFIXED PLAN);

			CLOSE buffer_cursor;
			DEALLOCATE buffer_cursor;
		END;

		IF 
			@get_plans >= 1 
			AND @recursion = 1
			AND @output_column_list LIKE '%|[query_plan|]%' ESCAPE '|'
		BEGIN;
			DECLARE @live_plan BIT;
			SET @live_plan = ISNULL(CONVERT(BIT, SIGN(OBJECT_ID('sys.dm_exec_query_statistics_xml'))), 0)

			DECLARE plan_cursor
			CURSOR LOCAL FAST_FORWARD
			FOR 
				SELECT
					session_id,
					request_id,
					plan_handle,
					statement_start_offset,
					statement_end_offset
				FROM #sessions
				WHERE
					recursion = 1
					AND plan_handle IS NOT NULL
			OPTION (KEEPFIXED PLAN);

			OPEN plan_cursor;

			FETCH NEXT FROM plan_cursor
			INTO 
				@session_id,
				@request_id,
				@plan_handle,
				@statement_start_offset,
				@statement_end_offset;

			--Wait up to 5 ms for a query plan, then give up
			SET LOCK_TIMEOUT 5;

			WHILE @@FETCH_STATUS = 0
			BEGIN;
				DECLARE @query_plan XML;
				SET @query_plan = NULL;

				IF @live_plan = 1
				BEGIN;
					BEGIN TRY;
						SELECT
							@query_plan = x.query_plan
						FROM sys.dm_exec_query_statistics_xml(@session_id) AS x;

						IF 
							@query_plan IS NOT NULL
							AND EXISTS
							(
								SELECT
									*
								FROM sys.dm_exec_requests AS r
								WHERE
									r.session_id = @session_id
									AND r.request_id = @request_id
									AND r.plan_handle = @plan_handle
									AND r.statement_start_offset = @statement_start_offset
									AND r.statement_end_offset = @statement_end_offset
							)
						BEGIN;
							UPDATE s
							SET
								s.query_plan = @query_plan
							FROM #sessions AS s
							WHERE 
								s.session_id = @session_id
								AND s.request_id = @request_id
								AND s.recursion = 1
							OPTION (KEEPFIXED PLAN);
						END;
					END TRY
					BEGIN CATCH;
						SET @query_plan = NULL;
					END CATCH;
				END;

				IF @query_plan IS NULL
				BEGIN;
					BEGIN TRY;
						UPDATE s
						SET
							s.query_plan =
							(
								SELECT
									CONVERT(xml, query_plan)
								FROM sys.dm_exec_text_query_plan
								(
									@plan_handle, 
									CASE @get_plans
										WHEN 1 THEN
											@statement_start_offset
										ELSE
											0
									END, 
									CASE @get_plans
										WHEN 1 THEN
											@statement_end_offset
										ELSE
											-1
									END
								)
							)
						FROM #sessions AS s
						WHERE 
							s.session_id = @session_id
							AND s.request_id = @request_id
							AND s.recursion = 1
						OPTION (KEEPFIXED PLAN);
					END TRY
					BEGIN CATCH;
						IF ERROR_NUMBER() = 6335
						BEGIN;
							UPDATE s
							SET
								s.query_plan =
								(
									SELECT
										N'--' + NCHAR(13) + NCHAR(10) + 
										N'-- Could not render showplan due to XML data type limitations. ' + NCHAR(13) + NCHAR(10) + 
										N'-- To see the graphical plan save the XML below as a .SQLPLAN file and re-open in SSMS.' + NCHAR(13) + NCHAR(10) +
										N'--' + NCHAR(13) + NCHAR(10) +
											REPLACE(qp.query_plan, N'<RelOp', NCHAR(13)+NCHAR(10)+N'<RelOp') + 
											NCHAR(13) + NCHAR(10) + N'--' COLLATE Latin1_General_Bin2 AS [processing-instruction(query_plan)]
									FROM sys.dm_exec_text_query_plan
									(
										@plan_handle, 
										CASE @get_plans
											WHEN 1 THEN
												@statement_start_offset
											ELSE
												0
										END, 
										CASE @get_plans
											WHEN 1 THEN
												@statement_end_offset
											ELSE
												-1
										END
									) AS qp
									FOR XML
										PATH(''),
										TYPE
								)
							FROM #sessions AS s
							WHERE 
								s.session_id = @session_id
								AND s.request_id = @request_id
								AND s.recursion = 1
							OPTION (KEEPFIXED PLAN);
						END;
						ELSE
						BEGIN;
							UPDATE s
							SET
								s.query_plan = 
									CASE ERROR_NUMBER() 
										WHEN 1222 THEN '<timeout_exceeded />'
										ELSE '<error message="' + ERROR_MESSAGE() + '" />'
									END
							FROM #sessions AS s
							WHERE 
								s.session_id = @session_id
								AND s.request_id = @request_id
								AND s.recursion = 1
							OPTION (KEEPFIXED PLAN);
						END;
					END CATCH;
				END;

				FETCH NEXT FROM plan_cursor
				INTO
					@session_id,
					@request_id,
					@plan_handle,
					@statement_start_offset,
					@statement_end_offset;
			END;

			--Return this to the default
			SET LOCK_TIMEOUT -1;

			CLOSE plan_cursor;
			DEALLOCATE plan_cursor;
		END;

		IF 
			@get_locks = 1 
			AND @recursion = 1
			AND @output_column_list LIKE '%|[locks|]%' ESCAPE '|'
		BEGIN;
			DECLARE locks_cursor
			CURSOR LOCAL FAST_FORWARD
			FOR 
				SELECT DISTINCT
					database_name
				FROM #locks
				WHERE
					EXISTS
					(
						SELECT *
						FROM #sessions AS s
						WHERE
							s.session_id = #locks.session_id
							AND recursion = 1
					)
					AND database_name <> '(null)'
				OPTION (KEEPFIXED PLAN);

			OPEN locks_cursor;

			FETCH NEXT FROM locks_cursor
			INTO 
				@database_name;

			WHILE @@FETCH_STATUS = 0
			BEGIN;
				BEGIN TRY;
					SET @sql_n = CONVERT(NVARCHAR(MAX), '') +
						'UPDATE l ' +
						'SET ' +
							'object_name = ' +
								'REPLACE ' +
								'( ' +
									'REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE( ' +
									'REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE( ' +
									'REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE( ' +
										'o.name COLLATE Latin1_General_Bin2, ' +
										'NCHAR(31),N''?''),NCHAR(30),N''?''),NCHAR(29),N''?''),NCHAR(28),N''?''),NCHAR(27),N''?''),NCHAR(26),N''?''),NCHAR(25),N''?''),NCHAR(24),N''?''),NCHAR(23),N''?''),NCHAR(22),N''?''), ' +
										'NCHAR(21),N''?''),NCHAR(20),N''?''),NCHAR(19),N''?''),NCHAR(18),N''?''),NCHAR(17),N''?''),NCHAR(16),N''?''),NCHAR(15),N''?''),NCHAR(14),N''?''),NCHAR(12),N''?''), ' +
										'NCHAR(11),N''?''),NCHAR(8),N''?''),NCHAR(7),N''?''),NCHAR(6),N''?''),NCHAR(5),N''?''),NCHAR(4),N''?''),NCHAR(3),N''?''),NCHAR(2),N''?''),NCHAR(1),N''?''), ' +
									'NCHAR(0), ' +
									N''''' ' +
								'), ' +
							'index_name = ' +
								'REPLACE ' +
								'( ' +
									'REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE( ' +
									'REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE( ' +
									'REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE( ' +
										'i.name COLLATE Latin1_General_Bin2, ' +
										'NCHAR(31),N''?''),NCHAR(30),N''?''),NCHAR(29),N''?''),NCHAR(28),N''?''),NCHAR(27),N''?''),NCHAR(26),N''?''),NCHAR(25),N''?''),NCHAR(24),N''?''),NCHAR(23),N''?''),NCHAR(22),N''?''), ' +
										'NCHAR(21),N''?''),NCHAR(20),N''?''),NCHAR(19),N''?''),NCHAR(18),N''?''),NCHAR(17),N''?''),NCHAR(16),N''?''),NCHAR(15),N''?''),NCHAR(14),N''?''),NCHAR(12),N''?''), ' +
										'NCHAR(11),N''?''),NCHAR(8),N''?''),NCHAR(7),N''?''),NCHAR(6),N''?''),NCHAR(5),N''?''),NCHAR(4),N''?''),NCHAR(3),N''?''),NCHAR(2),N''?''),NCHAR(1),N''?''), ' +
									'NCHAR(0), ' +
									N''''' ' +
								'), ' +
							'schema_name = ' +
								'REPLACE ' +
								'( ' +
									'REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE( ' +
									'REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE( ' +
									'REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE( ' +
										's.name COLLATE Latin1_General_Bin2, ' +
										'NCHAR(31),N''?''),NCHAR(30),N''?''),NCHAR(29),N''?''),NCHAR(28),N''?''),NCHAR(27),N''?''),NCHAR(26),N''?''),NCHAR(25),N''?''),NCHAR(24),N''?''),NCHAR(23),N''?''),NCHAR(22),N''?''), ' +
										'NCHAR(21),N''?''),NCHAR(20),N''?''),NCHAR(19),N''?''),NCHAR(18),N''?''),NCHAR(17),N''?''),NCHAR(16),N''?''),NCHAR(15),N''?''),NCHAR(14),N''?''),NCHAR(12),N''?''), ' +
										'NCHAR(11),N''?''),NCHAR(8),N''?''),NCHAR(7),N''?''),NCHAR(6),N''?''),NCHAR(5),N''?''),NCHAR(4),N''?''),NCHAR(3),N''?''),NCHAR(2),N''?''),NCHAR(1),N''?''), ' +
									'NCHAR(0), ' +
									N''''' ' +
								'), ' +
							'principal_name = ' + 
								'REPLACE ' +
								'( ' +
									'REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE( ' +
									'REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE( ' +
									'REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE( ' +
										'dp.name COLLATE Latin1_General_Bin2, ' +
										'NCHAR(31),N''?''),NCHAR(30),N''?''),NCHAR(29),N''?''),NCHAR(28),N''?''),NCHAR(27),N''?''),NCHAR(26),N''?''),NCHAR(25),N''?''),NCHAR(24),N''?''),NCHAR(23),N''?''),NCHAR(22),N''?''), ' +
										'NCHAR(21),N''?''),NCHAR(20),N''?''),NCHAR(19),N''?''),NCHAR(18),N''?''),NCHAR(17),N''?''),NCHAR(16),N''?''),NCHAR(15),N''?''),NCHAR(14),N''?''),NCHAR(12),N''?''), ' +
										'NCHAR(11),N''?''),NCHAR(8),N''?''),NCHAR(7),N''?''),NCHAR(6),N''?''),NCHAR(5),N''?''),NCHAR(4),N''?''),NCHAR(3),N''?''),NCHAR(2),N''?''),NCHAR(1),N''?''), ' +
									'NCHAR(0), ' +
									N''''' ' +
								') ' +
						'FROM #locks AS l ' +
						'LEFT OUTER JOIN ' + QUOTENAME(@database_name) + '.sys.allocation_units AS au ON ' +
							'au.allocation_unit_id = l.allocation_unit_id ' +
						'LEFT OUTER JOIN ' + QUOTENAME(@database_name) + '.sys.partitions AS p ON ' +
							'p.hobt_id = ' +
								'COALESCE ' +
								'( ' +
									'l.hobt_id, ' +
									'CASE ' +
										'WHEN au.type IN (1, 3) THEN au.container_id ' +
										'ELSE NULL ' +
									'END ' +
								') ' +
						'LEFT OUTER JOIN ' + QUOTENAME(@database_name) + '.sys.partitions AS p1 ON ' +
							'l.hobt_id IS NULL ' +
							'AND au.type = 2 ' +
							'AND p1.partition_id = au.container_id ' +
						'LEFT OUTER JOIN ' + QUOTENAME(@database_name) + '.sys.objects AS o ON ' +
							'o.object_id = COALESCE(l.object_id, p.object_id, p1.object_id) ' +
						'LEFT OUTER JOIN ' + QUOTENAME(@database_name) + '.sys.indexes AS i ON ' +
							'i.object_id = COALESCE(l.object_id, p.object_id, p1.object_id) ' +
							'AND i.index_id = COALESCE(l.index_id, p.index_id, p1.index_id) ' +
						'LEFT OUTER JOIN ' + QUOTENAME(@database_name) + '.sys.schemas AS s ON ' +
							's.schema_id = COALESCE(l.schema_id, o.schema_id) ' +
						'LEFT OUTER JOIN ' + QUOTENAME(@database_name) + '.sys.database_principals AS dp ON ' +
							'dp.principal_id = l.principal_id ' +
						'WHERE ' +
							'l.database_name = @database_name ' +
						'OPTION (KEEPFIXED PLAN); ';
					
					EXEC sp_executesql
						@sql_n,
						N'@database_name sysname',
						@database_name;
				END TRY
				BEGIN CATCH;
					UPDATE #locks
					SET
						query_error = 
							REPLACE
							(
								REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
								REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
								REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
									CONVERT
									(
										NVARCHAR(MAX), 
										ERROR_MESSAGE() COLLATE Latin1_General_Bin2
									),
									NCHAR(31),N'?'),NCHAR(30),N'?'),NCHAR(29),N'?'),NCHAR(28),N'?'),NCHAR(27),N'?'),NCHAR(26),N'?'),NCHAR(25),N'?'),NCHAR(24),N'?'),NCHAR(23),N'?'),NCHAR(22),N'?'),
									NCHAR(21),N'?'),NCHAR(20),N'?'),NCHAR(19),N'?'),NCHAR(18),N'?'),NCHAR(17),N'?'),NCHAR(16),N'?'),NCHAR(15),N'?'),NCHAR(14),N'?'),NCHAR(12),N'?'),
									NCHAR(11),N'?'),NCHAR(8),N'?'),NCHAR(7),N'?'),NCHAR(6),N'?'),NCHAR(5),N'?'),NCHAR(4),N'?'),NCHAR(3),N'?'),NCHAR(2),N'?'),NCHAR(1),N'?'),
								NCHAR(0),
								N''
							)
					WHERE 
						database_name = @database_name
					OPTION (KEEPFIXED PLAN);
				END CATCH;

				FETCH NEXT FROM locks_cursor
				INTO
					@database_name;
			END;

			CLOSE locks_cursor;
			DEALLOCATE locks_cursor;

			CREATE CLUSTERED INDEX IX_SRD ON #locks (session_id, request_id, database_name);

			UPDATE s
			SET 
				s.locks =
				(
					SELECT 
						REPLACE
						(
							REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
							REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
							REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
								CONVERT
								(
									NVARCHAR(MAX), 
									l1.database_name COLLATE Latin1_General_Bin2
								),
								NCHAR(31),N'?'),NCHAR(30),N'?'),NCHAR(29),N'?'),NCHAR(28),N'?'),NCHAR(27),N'?'),NCHAR(26),N'?'),NCHAR(25),N'?'),NCHAR(24),N'?'),NCHAR(23),N'?'),NCHAR(22),N'?'),
								NCHAR(21),N'?'),NCHAR(20),N'?'),NCHAR(19),N'?'),NCHAR(18),N'?'),NCHAR(17),N'?'),NCHAR(16),N'?'),NCHAR(15),N'?'),NCHAR(14),N'?'),NCHAR(12),N'?'),
								NCHAR(11),N'?'),NCHAR(8),N'?'),NCHAR(7),N'?'),NCHAR(6),N'?'),NCHAR(5),N'?'),NCHAR(4),N'?'),NCHAR(3),N'?'),NCHAR(2),N'?'),NCHAR(1),N'?'),
							NCHAR(0),
							N''
						) AS [Database/@name],
						MIN(l1.query_error) AS [Database/@query_error],
						(
							SELECT 
								l2.request_mode AS [Lock/@request_mode],
								l2.request_status AS [Lock/@request_status],
								COUNT(*) AS [Lock/@request_count]
							FROM #locks AS l2
							WHERE 
								l1.session_id = l2.session_id
								AND l1.request_id = l2.request_id
								AND l2.database_name = l1.database_name
								AND l2.resource_type = 'DATABASE'
							GROUP BY
								l2.request_mode,
								l2.request_status
							FOR XML
								PATH(''),
								TYPE
						) AS [Database/Locks],
						(
							SELECT
								COALESCE(l3.object_name, '(null)') AS [Object/@name],
								l3.schema_name AS [Object/@schema_name],
								(
									SELECT
										l4.resource_type AS [Lock/@resource_type],
										l4.page_type AS [Lock/@page_type],
										l4.index_name AS [Lock/@index_name],
										CASE 
											WHEN l4.object_name IS NULL THEN l4.schema_name
											ELSE NULL
										END AS [Lock/@schema_name],
										l4.principal_name AS [Lock/@principal_name],
										l4.resource_description AS [Lock/@resource_description],
										l4.request_mode AS [Lock/@request_mode],
										l4.request_status AS [Lock/@request_status],
										SUM(l4.request_count) AS [Lock/@request_count]
									FROM #locks AS l4
									WHERE 
										l4.session_id = l3.session_id
										AND l4.request_id = l3.request_id
										AND l3.database_name = l4.database_name
										AND COALESCE(l3.object_name, '(null)') = COALESCE(l4.object_name, '(null)')
										AND COALESCE(l3.schema_name, '') = COALESCE(l4.schema_name, '')
										AND l4.resource_type <> 'DATABASE'
									GROUP BY
										l4.resource_type,
										l4.page_type,
										l4.index_name,
										CASE 
											WHEN l4.object_name IS NULL THEN l4.schema_name
											ELSE NULL
										END,
										l4.principal_name,
										l4.resource_description,
										l4.request_mode,
										l4.request_status
									FOR XML
										PATH(''),
										TYPE
								) AS [Object/Locks]
							FROM #locks AS l3
							WHERE 
								l3.session_id = l1.session_id
								AND l3.request_id = l1.request_id
								AND l3.database_name = l1.database_name
								AND l3.resource_type <> 'DATABASE'
							GROUP BY 
								l3.session_id,
								l3.request_id,
								l3.database_name,
								COALESCE(l3.object_name, '(null)'),
								l3.schema_name
							FOR XML
								PATH(''),
								TYPE
						) AS [Database/Objects]
					FROM #locks AS l1
					WHERE
						l1.session_id = s.session_id
						AND l1.request_id = s.request_id
						AND l1.start_time IN (s.start_time, s.last_request_start_time)
						AND s.recursion = 1
					GROUP BY 
						l1.session_id,
						l1.request_id,
						l1.database_name
					FOR XML
						PATH(''),
						TYPE
				)
			FROM #sessions s
			OPTION (KEEPFIXED PLAN);
		END;

		IF 
			@find_block_leaders = 1
			AND @recursion = 1
			AND @output_column_list LIKE '%|[blocked_session_count|]%' ESCAPE '|'
		BEGIN;
			WITH
			blockers AS
			(
				SELECT
					session_id,
					session_id AS top_level_session_id,
					CONVERT(VARCHAR(8000), '.' + CONVERT(VARCHAR(8000), session_id) + '.') AS the_path
				FROM #sessions
				WHERE
					recursion = 1

				UNION ALL

				SELECT
					s.session_id,
					b.top_level_session_id,
					CONVERT(VARCHAR(8000), b.the_path + CONVERT(VARCHAR(8000), s.session_id) + '.') AS the_path
				FROM blockers AS b
				JOIN #sessions AS s ON
					s.blocking_session_id = b.session_id
					AND s.recursion = 1
					AND b.the_path NOT LIKE '%.' + CONVERT(VARCHAR(8000), s.session_id) + '.%' COLLATE Latin1_General_Bin2
			)
			UPDATE s
			SET
				s.blocked_session_count = x.blocked_session_count
			FROM #sessions AS s
			JOIN
			(
				SELECT
					b.top_level_session_id AS session_id,
					COUNT(*) - 1 AS blocked_session_count
				FROM blockers AS b
				GROUP BY
					b.top_level_session_id
			) x ON
				s.session_id = x.session_id
			WHERE
				s.recursion = 1;
		END;

		IF
			@get_task_info = 2
			AND @output_column_list LIKE '%|[additional_info|]%' ESCAPE '|'
			AND @recursion = 1
		BEGIN;
			CREATE TABLE #blocked_requests
			(
				session_id SMALLINT NOT NULL,
				request_id INT NOT NULL,
				database_name sysname NOT NULL,
				object_id INT,
				hobt_id BIGINT,
				schema_id INT,
				schema_name sysname NULL,
				object_name sysname NULL,
				query_error NVARCHAR(2048),
				PRIMARY KEY (database_name, session_id, request_id)
			);

			CREATE STATISTICS s_database_name ON #blocked_requests (database_name)
			WITH SAMPLE 0 ROWS, NORECOMPUTE;
			CREATE STATISTICS s_schema_name ON #blocked_requests (schema_name)
			WITH SAMPLE 0 ROWS, NORECOMPUTE;
			CREATE STATISTICS s_object_name ON #blocked_requests (object_name)
			WITH SAMPLE 0 ROWS, NORECOMPUTE;
			CREATE STATISTICS s_query_error ON #blocked_requests (query_error)
			WITH SAMPLE 0 ROWS, NORECOMPUTE;
		
			INSERT #blocked_requests
			(
				session_id,
				request_id,
				database_name,
				object_id,
				hobt_id,
				schema_id
			)
			SELECT
				session_id,
				request_id,
				database_name,
				object_id,
				hobt_id,
				CONVERT(INT, SUBSTRING(schema_node, CHARINDEX(' = ', schema_node) + 3, LEN(schema_node))) AS schema_id
			FROM
			(
				SELECT
					session_id,
					request_id,
					agent_nodes.agent_node.value('(database_name/text())[1]', 'sysname') AS database_name,
					agent_nodes.agent_node.value('(object_id/text())[1]', 'int') AS object_id,
					agent_nodes.agent_node.value('(hobt_id/text())[1]', 'bigint') AS hobt_id,
					agent_nodes.agent_node.value('(metadata_resource/text()[.="SCHEMA"]/../../metadata_class_id/text())[1]', 'varchar(100)') AS schema_node
				FROM #sessions AS s
				CROSS APPLY s.additional_info.nodes('//block_info') AS agent_nodes (agent_node)
				WHERE
					s.recursion = 1
			) AS t
			WHERE
				t.database_name IS NOT NULL
				AND
				(
					t.object_id IS NOT NULL
					OR t.hobt_id IS NOT NULL
					OR t.schema_node IS NOT NULL
				);
			
			DECLARE blocks_cursor
			CURSOR LOCAL FAST_FORWARD
			FOR
				SELECT DISTINCT
					database_name
				FROM #blocked_requests;
				
			OPEN blocks_cursor;
			
			FETCH NEXT FROM blocks_cursor
			INTO 
				@database_name;
			
			WHILE @@FETCH_STATUS = 0
			BEGIN;
				BEGIN TRY;
					SET @sql_n = 
						CONVERT(NVARCHAR(MAX), '') +
						'UPDATE b ' +
						'SET ' +
							'b.schema_name = ' +
								'REPLACE ' +
								'( ' +
									'REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE( ' +
									'REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE( ' +
									'REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE( ' +
										's.name COLLATE Latin1_General_Bin2, ' +
										'NCHAR(31),N''?''),NCHAR(30),N''?''),NCHAR(29),N''?''),NCHAR(28),N''?''),NCHAR(27),N''?''),NCHAR(26),N''?''),NCHAR(25),N''?''),NCHAR(24),N''?''),NCHAR(23),N''?''),NCHAR(22),N''?''), ' +
										'NCHAR(21),N''?''),NCHAR(20),N''?''),NCHAR(19),N''?''),NCHAR(18),N''?''),NCHAR(17),N''?''),NCHAR(16),N''?''),NCHAR(15),N''?''),NCHAR(14),N''?''),NCHAR(12),N''?''), ' +
										'NCHAR(11),N''?''),NCHAR(8),N''?''),NCHAR(7),N''?''),NCHAR(6),N''?''),NCHAR(5),N''?''),NCHAR(4),N''?''),NCHAR(3),N''?''),NCHAR(2),N''?''),NCHAR(1),N''?''), ' +
									'NCHAR(0), ' +
									N''''' ' +
								'), ' +
							'b.object_name = ' +
								'REPLACE ' +
								'( ' +
									'REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE( ' +
									'REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE( ' +
									'REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE( ' +
										'o.name COLLATE Latin1_General_Bin2, ' +
										'NCHAR(31),N''?''),NCHAR(30),N''?''),NCHAR(29),N''?''),NCHAR(28),N''?''),NCHAR(27),N''?''),NCHAR(26),N''?''),NCHAR(25),N''?''),NCHAR(24),N''?''),NCHAR(23),N''?''),NCHAR(22),N''?''), ' +
										'NCHAR(21),N''?''),NCHAR(20),N''?''),NCHAR(19),N''?''),NCHAR(18),N''?''),NCHAR(17),N''?''),NCHAR(16),N''?''),NCHAR(15),N''?''),NCHAR(14),N''?''),NCHAR(12),N''?''), ' +
										'NCHAR(11),N''?''),NCHAR(8),N''?''),NCHAR(7),N''?''),NCHAR(6),N''?''),NCHAR(5),N''?''),NCHAR(4),N''?''),NCHAR(3),N''?''),NCHAR(2),N''?''),NCHAR(1),N''?''), ' +
									'NCHAR(0), ' +
									N''''' ' +
								') ' +
						'FROM #blocked_requests AS b ' +
						'LEFT OUTER JOIN ' + QUOTENAME(@database_name) + '.sys.partitions AS p ON ' +
							'p.hobt_id = b.hobt_id ' +
						'LEFT OUTER JOIN ' + QUOTENAME(@database_name) + '.sys.objects AS o ON ' +
							'o.object_id = COALESCE(p.object_id, b.object_id) ' +
						'LEFT OUTER JOIN ' + QUOTENAME(@database_name) + '.sys.schemas AS s ON ' +
							's.schema_id = COALESCE(o.schema_id, b.schema_id) ' +
						'WHERE ' +
							'b.database_name = @database_name; ';
					
					EXEC sp_executesql
						@sql_n,
						N'@database_name sysname',
						@database_name;
				END TRY
				BEGIN CATCH;
					UPDATE #blocked_requests
					SET
						query_error = 
							REPLACE
							(
								REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
								REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
								REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
									CONVERT
									(
										NVARCHAR(MAX), 
										ERROR_MESSAGE() COLLATE Latin1_General_Bin2
									),
									NCHAR(31),N'?'),NCHAR(30),N'?'),NCHAR(29),N'?'),NCHAR(28),N'?'),NCHAR(27),N'?'),NCHAR(26),N'?'),NCHAR(25),N'?'),NCHAR(24),N'?'),NCHAR(23),N'?'),NCHAR(22),N'?'),
									NCHAR(21),N'?'),NCHAR(20),N'?'),NCHAR(19),N'?'),NCHAR(18),N'?'),NCHAR(17),N'?'),NCHAR(16),N'?'),NCHAR(15),N'?'),NCHAR(14),N'?'),NCHAR(12),N'?'),
									NCHAR(11),N'?'),NCHAR(8),N'?'),NCHAR(7),N'?'),NCHAR(6),N'?'),NCHAR(5),N'?'),NCHAR(4),N'?'),NCHAR(3),N'?'),NCHAR(2),N'?'),NCHAR(1),N'?'),
								NCHAR(0),
								N''
							)
					WHERE
						database_name = @database_name;
				END CATCH;

				FETCH NEXT FROM blocks_cursor
				INTO
					@database_name;
			END;
			
			CLOSE blocks_cursor;
			DEALLOCATE blocks_cursor;
			
			UPDATE s
			SET
				additional_info.modify
				('
					insert <schema_name>{sql:column("b.schema_name")}</schema_name>
					as last
					into (/additional_info/block_info)[1]
				')
			FROM #sessions AS s
			INNER JOIN #blocked_requests AS b ON
				b.session_id = s.session_id
				AND b.request_id = s.request_id
				AND s.recursion = 1
			WHERE
				b.schema_name IS NOT NULL;

			UPDATE s
			SET
				additional_info.modify
				('
					insert <object_name>{sql:column("b.object_name")}</object_name>
					as last
					into (/additional_info/block_info)[1]
				')
			FROM #sessions AS s
			INNER JOIN #blocked_requests AS b ON
				b.session_id = s.session_id
				AND b.request_id = s.request_id
				AND s.recursion = 1
			WHERE
				b.object_name IS NOT NULL;

			UPDATE s
			SET
				additional_info.modify
				('
					insert <query_error>{sql:column("b.query_error")}</query_error>
					as last
					into (/additional_info/block_info)[1]
				')
			FROM #sessions AS s
			INNER JOIN #blocked_requests AS b ON
				b.session_id = s.session_id
				AND b.request_id = s.request_id
				AND s.recursion = 1
			WHERE
				b.query_error IS NOT NULL;
		END;

		IF
			@output_column_list LIKE '%|[program_name|]%' ESCAPE '|'
			AND @output_column_list LIKE '%|[additional_info|]%' ESCAPE '|'
			AND @recursion = 1
			AND DB_ID('msdb') IS NOT NULL
		BEGIN;
			SET @sql_n =
				N'BEGIN TRY;
					DECLARE @job_name sysname;
					SET @job_name = NULL;
					DECLARE @step_name sysname;
					SET @step_name = NULL;

					SELECT
						@job_name = 
							REPLACE
							(
								REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
								REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
								REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
									j.name,
									NCHAR(31),N''?''),NCHAR(30),N''?''),NCHAR(29),N''?''),NCHAR(28),N''?''),NCHAR(27),N''?''),NCHAR(26),N''?''),NCHAR(25),N''?''),NCHAR(24),N''?''),NCHAR(23),N''?''),NCHAR(22),N''?''),
									NCHAR(21),N''?''),NCHAR(20),N''?''),NCHAR(19),N''?''),NCHAR(18),N''?''),NCHAR(17),N''?''),NCHAR(16),N''?''),NCHAR(15),N''?''),NCHAR(14),N''?''),NCHAR(12),N''?''),
									NCHAR(11),N''?''),NCHAR(8),N''?''),NCHAR(7),N''?''),NCHAR(6),N''?''),NCHAR(5),N''?''),NCHAR(4),N''?''),NCHAR(3),N''?''),NCHAR(2),N''?''),NCHAR(1),N''?''),
								NCHAR(0),
								N''?''
							),
						@step_name = 
							REPLACE
							(
								REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
								REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
								REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
									s.step_name,
									NCHAR(31),N''?''),NCHAR(30),N''?''),NCHAR(29),N''?''),NCHAR(28),N''?''),NCHAR(27),N''?''),NCHAR(26),N''?''),NCHAR(25),N''?''),NCHAR(24),N''?''),NCHAR(23),N''?''),NCHAR(22),N''?''),
									NCHAR(21),N''?''),NCHAR(20),N''?''),NCHAR(19),N''?''),NCHAR(18),N''?''),NCHAR(17),N''?''),NCHAR(16),N''?''),NCHAR(15),N''?''),NCHAR(14),N''?''),NCHAR(12),N''?''),
									NCHAR(11),N''?''),NCHAR(8),N''?''),NCHAR(7),N''?''),NCHAR(6),N''?''),NCHAR(5),N''?''),NCHAR(4),N''?''),NCHAR(3),N''?''),NCHAR(2),N''?''),NCHAR(1),N''?''),
								NCHAR(0),
								N''?''
							)
					FROM msdb.dbo.sysjobs AS j
					INNER JOIN msdb.dbo.sysjobsteps AS s ON
						j.job_id = s.job_id
					WHERE
						j.job_id = @job_id
						AND s.step_id = @step_id;

					IF @job_name IS NOT NULL
					BEGIN;
						UPDATE s
						SET
							additional_info.modify
							(''
								insert text{sql:variable("@job_name")}
								into (/additional_info/agent_job_info/job_name)[1]
							'')
						FROM #sessions AS s
						WHERE 
							s.session_id = @session_id
							AND s.recursion = 1
						OPTION (KEEPFIXED PLAN);
						
						UPDATE s
						SET
							additional_info.modify
							(''
								insert text{sql:variable("@step_name")}
								into (/additional_info/agent_job_info/step_name)[1]
							'')
						FROM #sessions AS s
						WHERE 
							s.session_id = @session_id
							AND s.recursion = 1
						OPTION (KEEPFIXED PLAN);
					END;
				END TRY
				BEGIN CATCH;
					DECLARE @msdb_error_message NVARCHAR(256);
					SET @msdb_error_message = ERROR_MESSAGE();
				
					UPDATE s
					SET
						additional_info.modify
						(''
							insert <msdb_query_error>{sql:variable("@msdb_error_message")}</msdb_query_error>
							as last
							into (/additional_info/agent_job_info)[1]
						'')
					FROM #sessions AS s
					WHERE 
						s.session_id = @session_id
						AND s.recursion = 1
					OPTION (KEEPFIXED PLAN);
				END CATCH;'

			DECLARE @job_id UNIQUEIDENTIFIER;
			DECLARE @step_id INT;

			DECLARE agent_cursor
			CURSOR LOCAL FAST_FORWARD
			FOR 
				SELECT
					s.session_id,
					agent_nodes.agent_node.value('(job_id/text())[1]', 'uniqueidentifier') AS job_id,
					agent_nodes.agent_node.value('(step_id/text())[1]', 'int') AS step_id
				FROM #sessions AS s
				CROSS APPLY s.additional_info.nodes('//agent_job_info') AS agent_nodes (agent_node)
				WHERE
					s.recursion = 1
			OPTION (KEEPFIXED PLAN);
			
			OPEN agent_cursor;

			FETCH NEXT FROM agent_cursor
			INTO 
				@session_id,
				@job_id,
				@step_id;

			WHILE @@FETCH_STATUS = 0
			BEGIN;
				EXEC sp_executesql
					@sql_n,
					N'@job_id UNIQUEIDENTIFIER, @step_id INT, @session_id SMALLINT',
					@job_id, @step_id, @session_id

				FETCH NEXT FROM agent_cursor
				INTO 
					@session_id,
					@job_id,
					@step_id;
			END;

			CLOSE agent_cursor;
			DEALLOCATE agent_cursor;
		END; 
		
		IF 
			@delta_interval > 0 
			AND @recursion <> 1
		BEGIN;
			SET @recursion = 1;

			DECLARE @delay_time CHAR(12);
			SET @delay_time = CONVERT(VARCHAR, DATEADD(second, @delta_interval, 0), 114);
			WAITFOR DELAY @delay_time;

			GOTO REDO;
		END;
	END;

	SET @sql = 
		--Outer column list
		CONVERT
		(
			VARCHAR(MAX),
			CASE
				WHEN 
					@destination_table <> '' 
					AND @return_schema = 0 
						THEN 'INSERT ' + @destination_table + ' '
				ELSE ''
			END +
			'SELECT ' +
				@output_column_list + ' ' +
			CASE @return_schema
				WHEN 1 THEN 'INTO #session_schema '
				ELSE ''
			END
		--End outer column list
		) + 
		--Inner column list
		CONVERT
		(
			VARCHAR(MAX),
			'FROM ' +
			'( ' +
				'SELECT ' +
					'session_id, ' +
					--[dd hh:mm:ss.mss]
					CASE
						WHEN @format_output IN (1, 2) THEN
							'CASE ' +
								'WHEN elapsed_time < 0 THEN ' +
									'RIGHT ' +
									'( ' +
										'REPLICATE(''0'', max_elapsed_length) + CONVERT(VARCHAR, (-1 * elapsed_time) / 86400), ' +
										'max_elapsed_length ' +
									') + ' +
										'RIGHT ' +
										'( ' +
											'CONVERT(VARCHAR, DATEADD(second, (-1 * elapsed_time), 0), 120), ' +
											'9 ' +
										') + ' +
										'''.000'' ' +
								'ELSE ' +
									'RIGHT ' +
									'( ' +
										'REPLICATE(''0'', max_elapsed_length) + CONVERT(VARCHAR, elapsed_time / 86400000), ' +
										'max_elapsed_length ' +
									') + ' +
										'RIGHT ' +
										'( ' +
											'CONVERT(VARCHAR, DATEADD(second, elapsed_time / 1000, 0), 120), ' +
											'9 ' +
										') + ' +
										'''.'' + ' + 
										'RIGHT(''000'' + CONVERT(VARCHAR, elapsed_time % 1000), 3) ' +
							'END AS [dd hh:mm:ss.mss], '
						ELSE
							''
					END +
					--[dd hh:mm:ss.mss (avg)] / avg_elapsed_time
					CASE 
						WHEN  @format_output IN (1, 2) THEN 
							'RIGHT ' +
							'( ' +
								'''00'' + CONVERT(VARCHAR, avg_elapsed_time / 86400000), ' +
								'2 ' +
							') + ' +
								'RIGHT ' +
								'( ' +
									'CONVERT(VARCHAR, DATEADD(second, avg_elapsed_time / 1000, 0), 120), ' +
									'9 ' +
								') + ' +
								'''.'' + ' +
								'RIGHT(''000'' + CONVERT(VARCHAR, avg_elapsed_time % 1000), 3) AS [dd hh:mm:ss.mss (avg)], '
						ELSE
							'avg_elapsed_time, '
					END +
					--physical_io
					CASE @format_output
						WHEN 1 THEN 'CONVERT(VARCHAR, SPACE(MAX(LEN(CONVERT(VARCHAR, physical_io))) OVER() - LEN(CONVERT(VARCHAR, physical_io))) + LEFT(CONVERT(CHAR(22), CONVERT(MONEY, physical_io), 1), 19)) AS '
						WHEN 2 THEN 'CONVERT(VARCHAR, LEFT(CONVERT(CHAR(22), CONVERT(MONEY, physical_io), 1), 19)) AS '
						ELSE ''
					END + 'physical_io, ' +
					--reads
					CASE @format_output
						WHEN 1 THEN 'CONVERT(VARCHAR, SPACE(MAX(LEN(CONVERT(VARCHAR, reads))) OVER() - LEN(CONVERT(VARCHAR, reads))) + LEFT(CONVERT(CHAR(22), CONVERT(MONEY, reads), 1), 19)) AS '
						WHEN 2 THEN 'CONVERT(VARCHAR, LEFT(CONVERT(CHAR(22), CONVERT(MONEY, reads), 1), 19)) AS '
						ELSE ''
					END + 'reads, ' +
					--physical_reads
					CASE @format_output
						WHEN 1 THEN 'CONVERT(VARCHAR, SPACE(MAX(LEN(CONVERT(VARCHAR, physical_reads))) OVER() - LEN(CONVERT(VARCHAR, physical_reads))) + LEFT(CONVERT(CHAR(22), CONVERT(MONEY, physical_reads), 1), 19)) AS '
						WHEN 2 THEN 'CONVERT(VARCHAR, LEFT(CONVERT(CHAR(22), CONVERT(MONEY, physical_reads), 1), 19)) AS '
						ELSE ''
					END + 'physical_reads, ' +
					--writes
					CASE @format_output
						WHEN 1 THEN 'CONVERT(VARCHAR, SPACE(MAX(LEN(CONVERT(VARCHAR, writes))) OVER() - LEN(CONVERT(VARCHAR, writes))) + LEFT(CONVERT(CHAR(22), CONVERT(MONEY, writes), 1), 19)) AS '
						WHEN 2 THEN 'CONVERT(VARCHAR, LEFT(CONVERT(CHAR(22), CONVERT(MONEY, writes), 1), 19)) AS '
						ELSE ''
					END + 'writes, ' +
					--tempdb_allocations
					CASE @format_output
						WHEN 1 THEN 'CONVERT(VARCHAR, SPACE(MAX(LEN(CONVERT(VARCHAR, tempdb_allocations))) OVER() - LEN(CONVERT(VARCHAR, tempdb_allocations))) + LEFT(CONVERT(CHAR(22), CONVERT(MONEY, tempdb_allocations), 1), 19)) AS '
						WHEN 2 THEN 'CONVERT(VARCHAR, LEFT(CONVERT(CHAR(22), CONVERT(MONEY, tempdb_allocations), 1), 19)) AS '
						ELSE ''
					END + 'tempdb_allocations, ' +
					--tempdb_current
					CASE @format_output
						WHEN 1 THEN 'CONVERT(VARCHAR, SPACE(MAX(LEN(CONVERT(VARCHAR, tempdb_current))) OVER() - LEN(CONVERT(VARCHAR, tempdb_current))) + LEFT(CONVERT(CHAR(22), CONVERT(MONEY, tempdb_current), 1), 19)) AS '
						WHEN 2 THEN 'CONVERT(VARCHAR, LEFT(CONVERT(CHAR(22), CONVERT(MONEY, tempdb_current), 1), 19)) AS '
						ELSE ''
					END + 'tempdb_current, ' +
					--CPU
					CASE @format_output
						WHEN 1 THEN 'CONVERT(VARCHAR, SPACE(MAX(LEN(CONVERT(VARCHAR, CPU))) OVER() - LEN(CONVERT(VARCHAR, CPU))) + LEFT(CONVERT(CHAR(22), CONVERT(MONEY, CPU), 1), 19)) AS '
						WHEN 2 THEN 'CONVERT(VARCHAR, LEFT(CONVERT(CHAR(22), CONVERT(MONEY, CPU), 1), 19)) AS '
						ELSE ''
					END + 'CPU, ' +
					--context_switches
					CASE @format_output
						WHEN 1 THEN 'CONVERT(VARCHAR, SPACE(MAX(LEN(CONVERT(VARCHAR, context_switches))) OVER() - LEN(CONVERT(VARCHAR, context_switches))) + LEFT(CONVERT(CHAR(22), CONVERT(MONEY, context_switches), 1), 19)) AS '
						WHEN 2 THEN 'CONVERT(VARCHAR, LEFT(CONVERT(CHAR(22), CONVERT(MONEY, context_switches), 1), 19)) AS '
						ELSE ''
					END + 'context_switches, ' +
					--used_memory
					CASE @format_output
						WHEN 1 THEN 'CONVERT(VARCHAR, SPACE(MAX(LEN(CONVERT(VARCHAR, used_memory))) OVER() - LEN(CONVERT(VARCHAR, used_memory))) + LEFT(CONVERT(CHAR(22), CONVERT(MONEY, used_memory), 1), 19)) AS '
						WHEN 2 THEN 'CONVERT(VARCHAR, LEFT(CONVERT(CHAR(22), CONVERT(MONEY, used_memory), 1), 19)) AS '
						ELSE ''
					END + 'used_memory, ' +
					CASE
						WHEN @output_column_list LIKE '%|_delta|]%' ESCAPE '|' THEN
							--physical_io_delta			
							'CASE ' +
								'WHEN ' +
									'first_request_start_time = last_request_start_time ' + 
									'AND num_events = 2 ' +
									'AND physical_io_delta >= 0 ' +
										'THEN ' +
										CASE @format_output
											WHEN 1 THEN 'CONVERT(VARCHAR, SPACE(MAX(LEN(CONVERT(VARCHAR, physical_io_delta))) OVER() - LEN(CONVERT(VARCHAR, physical_io_delta))) + LEFT(CONVERT(CHAR(22), CONVERT(MONEY, physical_io_delta), 1), 19)) ' 
											WHEN 2 THEN 'CONVERT(VARCHAR, LEFT(CONVERT(CHAR(22), CONVERT(MONEY, physical_io_delta), 1), 19)) '
											ELSE 'physical_io_delta '
										END +
								'ELSE NULL ' +
							'END AS physical_io_delta, ' +
							--reads_delta
							'CASE ' +
								'WHEN ' +
									'first_request_start_time = last_request_start_time ' + 
									'AND num_events = 2 ' +
									'AND reads_delta >= 0 ' +
										'THEN ' +
										CASE @format_output
											WHEN 1 THEN 'CONVERT(VARCHAR, SPACE(MAX(LEN(CONVERT(VARCHAR, reads_delta))) OVER() - LEN(CONVERT(VARCHAR, reads_delta))) + LEFT(CONVERT(CHAR(22), CONVERT(MONEY, reads_delta), 1), 19)) '
											WHEN 2 THEN 'CONVERT(VARCHAR, LEFT(CONVERT(CHAR(22), CONVERT(MONEY, reads_delta), 1), 19)) '
											ELSE 'reads_delta '
										END +
								'ELSE NULL ' +
							'END AS reads_delta, ' +
							--physical_reads_delta
							'CASE ' +
								'WHEN ' +
									'first_request_start_time = last_request_start_time ' + 
									'AND num_events = 2 ' +
									'AND physical_reads_delta >= 0 ' +
										'THEN ' +
										CASE @format_output
											WHEN 1 THEN 'CONVERT(VARCHAR, SPACE(MAX(LEN(CONVERT(VARCHAR, physical_reads_delta))) OVER() - LEN(CONVERT(VARCHAR, physical_reads_delta))) + LEFT(CONVERT(CHAR(22), CONVERT(MONEY, physical_reads_delta), 1), 19)) '
											WHEN 2 THEN 'CONVERT(VARCHAR, LEFT(CONVERT(CHAR(22), CONVERT(MONEY, physical_reads_delta), 1), 19)) '
											ELSE 'physical_reads_delta '
										END + 
								'ELSE NULL ' +
							'END AS physical_reads_delta, ' +
							--writes_delta
							'CASE ' +
								'WHEN ' +
									'first_request_start_time = last_request_start_time ' + 
									'AND num_events = 2 ' +
									'AND writes_delta >= 0 ' +
										'THEN ' +
										CASE @format_output
											WHEN 1 THEN 'CONVERT(VARCHAR, SPACE(MAX(LEN(CONVERT(VARCHAR, writes_delta))) OVER() - LEN(CONVERT(VARCHAR, writes_delta))) + LEFT(CONVERT(CHAR(22), CONVERT(MONEY, writes_delta), 1), 19)) '
											WHEN 2 THEN 'CONVERT(VARCHAR, LEFT(CONVERT(CHAR(22), CONVERT(MONEY, writes_delta), 1), 19)) '
											ELSE 'writes_delta '
										END + 
								'ELSE NULL ' +
							'END AS writes_delta, ' +
							--tempdb_allocations_delta
							'CASE ' +
								'WHEN ' +
									'first_request_start_time = last_request_start_time ' + 
									'AND num_events = 2 ' +
									'AND tempdb_allocations_delta >= 0 ' +
										'THEN ' +
										CASE @format_output
											WHEN 1 THEN 'CONVERT(VARCHAR, SPACE(MAX(LEN(CONVERT(VARCHAR, tempdb_allocations_delta))) OVER() - LEN(CONVERT(VARCHAR, tempdb_allocations_delta))) + LEFT(CONVERT(CHAR(22), CONVERT(MONEY, tempdb_allocations_delta), 1), 19)) '
											WHEN 2 THEN 'CONVERT(VARCHAR, LEFT(CONVERT(CHAR(22), CONVERT(MONEY, tempdb_allocations_delta), 1), 19)) '
											ELSE 'tempdb_allocations_delta '
										END + 
								'ELSE NULL ' +
							'END AS tempdb_allocations_delta, ' +
							--tempdb_current_delta
							--this is the only one that can (legitimately) go negative 
							'CASE ' +
								'WHEN ' +
									'first_request_start_time = last_request_start_time ' + 
									'AND num_events = 2 ' +
										'THEN ' +
										CASE @format_output
											WHEN 1 THEN 'CONVERT(VARCHAR, SPACE(MAX(LEN(CONVERT(VARCHAR, tempdb_current_delta))) OVER() - LEN(CONVERT(VARCHAR, tempdb_current_delta))) + LEFT(CONVERT(CHAR(22), CONVERT(MONEY, tempdb_current_delta), 1), 19)) '
											WHEN 2 THEN 'CONVERT(VARCHAR, LEFT(CONVERT(CHAR(22), CONVERT(MONEY, tempdb_current_delta), 1), 19)) '
											ELSE 'tempdb_current_delta '
										END + 
								'ELSE NULL ' +
							'END AS tempdb_current_delta, ' +
							--CPU_delta
							'CASE ' +
								'WHEN ' +
									'first_request_start_time = last_request_start_time ' + 
									'AND num_events = 2 ' +
										'THEN ' +
											'CASE ' +
												'WHEN ' +
													'thread_CPU_delta > CPU_delta ' +
													'AND thread_CPU_delta > 0 ' +
														'THEN ' +
															CASE @format_output
																WHEN 1 THEN 'CONVERT(VARCHAR, SPACE(MAX(LEN(CONVERT(VARCHAR, thread_CPU_delta + CPU_delta))) OVER() - LEN(CONVERT(VARCHAR, thread_CPU_delta))) + LEFT(CONVERT(CHAR(22), CONVERT(MONEY, thread_CPU_delta), 1), 19)) '
																WHEN 2 THEN 'CONVERT(VARCHAR, LEFT(CONVERT(CHAR(22), CONVERT(MONEY, thread_CPU_delta), 1), 19)) '
																ELSE 'thread_CPU_delta '
															END + 
												'WHEN CPU_delta >= 0 THEN ' +
													CASE @format_output
														WHEN 1 THEN 'CONVERT(VARCHAR, SPACE(MAX(LEN(CONVERT(VARCHAR, thread_CPU_delta + CPU_delta))) OVER() - LEN(CONVERT(VARCHAR, CPU_delta))) + LEFT(CONVERT(CHAR(22), CONVERT(MONEY, CPU_delta), 1), 19)) '
														WHEN 2 THEN 'CONVERT(VARCHAR, LEFT(CONVERT(CHAR(22), CONVERT(MONEY, CPU_delta), 1), 19)) '
														ELSE 'CPU_delta '
													END + 
												'ELSE NULL ' +
											'END ' +
								'ELSE ' +
									'NULL ' +
							'END AS CPU_delta, ' +
							--context_switches_delta
							'CASE ' +
								'WHEN ' +
									'first_request_start_time = last_request_start_time ' + 
									'AND num_events = 2 ' +
									'AND context_switches_delta >= 0 ' +
										'THEN ' +
										CASE @format_output
											WHEN 1 THEN 'CONVERT(VARCHAR, SPACE(MAX(LEN(CONVERT(VARCHAR, context_switches_delta))) OVER() - LEN(CONVERT(VARCHAR, context_switches_delta))) + LEFT(CONVERT(CHAR(22), CONVERT(MONEY, context_switches_delta), 1), 19)) '
											WHEN 2 THEN 'CONVERT(VARCHAR, LEFT(CONVERT(CHAR(22), CONVERT(MONEY, context_switches_delta), 1), 19)) '
											ELSE 'context_switches_delta '
										END + 
								'ELSE NULL ' +
							'END AS context_switches_delta, ' +
							--used_memory_delta
							'CASE ' +
								'WHEN ' +
									'first_request_start_time = last_request_start_time ' + 
									'AND num_events = 2 ' +
									'AND used_memory_delta >= 0 ' +
										'THEN ' +
										CASE @format_output
											WHEN 1 THEN 'CONVERT(VARCHAR, SPACE(MAX(LEN(CONVERT(VARCHAR, used_memory_delta))) OVER() - LEN(CONVERT(VARCHAR, used_memory_delta))) + LEFT(CONVERT(CHAR(22), CONVERT(MONEY, used_memory_delta), 1), 19)) '
											WHEN 2 THEN 'CONVERT(VARCHAR, LEFT(CONVERT(CHAR(22), CONVERT(MONEY, used_memory_delta), 1), 19)) '
											ELSE 'used_memory_delta '
										END + 
								'ELSE NULL ' +
							'END AS used_memory_delta, '
						ELSE ''
					END +
					--tasks
					CASE @format_output
						WHEN 1 THEN 'CONVERT(VARCHAR, SPACE(MAX(LEN(CONVERT(VARCHAR, tasks))) OVER() - LEN(CONVERT(VARCHAR, tasks))) + LEFT(CONVERT(CHAR(22), CONVERT(MONEY, tasks), 1), 19)) AS '
						WHEN 2 THEN 'CONVERT(VARCHAR, LEFT(CONVERT(CHAR(22), CONVERT(MONEY, tasks), 1), 19)) '
						ELSE ''
					END + 'tasks, ' +
					'status, ' +
					'wait_info, ' +
					'locks, ' +
					'tran_start_time, ' +
					'LEFT(tran_log_writes, LEN(tran_log_writes) - 1) AS tran_log_writes, ' +
					--open_tran_count
					CASE @format_output
						WHEN 1 THEN 'CONVERT(VARCHAR, SPACE(MAX(LEN(CONVERT(VARCHAR, open_tran_count))) OVER() - LEN(CONVERT(VARCHAR, open_tran_count))) + LEFT(CONVERT(CHAR(22), CONVERT(MONEY, open_tran_count), 1), 19)) AS '
						WHEN 2 THEN 'CONVERT(VARCHAR, LEFT(CONVERT(CHAR(22), CONVERT(MONEY, open_tran_count), 1), 19)) AS '
						ELSE ''
					END + 'open_tran_count, ' +
					--sql_command
					CASE @format_output 
						WHEN 0 THEN 'REPLACE(REPLACE(CONVERT(NVARCHAR(MAX), sql_command), ''<?query --''+CHAR(13)+CHAR(10), ''''), CHAR(13)+CHAR(10)+''--?>'', '''') AS '
						ELSE ''
					END + 'sql_command, ' +
					--sql_text
					CASE @format_output 
						WHEN 0 THEN 'REPLACE(REPLACE(CONVERT(NVARCHAR(MAX), sql_text), ''<?query --''+CHAR(13)+CHAR(10), ''''), CHAR(13)+CHAR(10)+''--?>'', '''') AS '
						ELSE ''
					END + 'sql_text, ' +
					'query_plan, ' +
					'blocking_session_id, ' +
					--blocked_session_count
					CASE @format_output
						WHEN 1 THEN 'CONVERT(VARCHAR, SPACE(MAX(LEN(CONVERT(VARCHAR, blocked_session_count))) OVER() - LEN(CONVERT(VARCHAR, blocked_session_count))) + LEFT(CONVERT(CHAR(22), CONVERT(MONEY, blocked_session_count), 1), 19)) AS '
						WHEN 2 THEN 'CONVERT(VARCHAR, LEFT(CONVERT(CHAR(22), CONVERT(MONEY, blocked_session_count), 1), 19)) AS '
						ELSE ''
					END + 'blocked_session_count, ' +
					--percent_complete
					CASE @format_output
						WHEN 1 THEN 'CONVERT(VARCHAR, SPACE(MAX(LEN(CONVERT(VARCHAR, CONVERT(MONEY, percent_complete), 2))) OVER() - LEN(CONVERT(VARCHAR, CONVERT(MONEY, percent_complete), 2))) + CONVERT(CHAR(22), CONVERT(MONEY, percent_complete), 2)) AS '
						WHEN 2 THEN 'CONVERT(VARCHAR, CONVERT(CHAR(22), CONVERT(MONEY, blocked_session_count), 1)) AS '
						ELSE ''
					END + 'percent_complete, ' +
					'host_name, ' +
					'login_name, ' +
					'database_name, ' +
					'program_name, ' +
					'additional_info, ' +
					'start_time, ' +
					'login_time, ' +
					'CASE ' +
						'WHEN status = N''sleeping'' THEN NULL ' +
						'ELSE request_id ' +
					'END AS request_id, ' +
					'GETDATE() AS collection_time '
		--End inner column list
		) +
		--Derived table and INSERT specification
		CONVERT
		(
			VARCHAR(MAX),
				'FROM ' +
				'( ' +
					'SELECT TOP(2147483647) ' +
						'*, ' +
						'CASE ' +
							'MAX ' +
							'( ' +
								'LEN ' +
								'( ' +
									'CONVERT ' +
									'( ' +
										'VARCHAR, ' +
										'CASE ' +
											'WHEN elapsed_time < 0 THEN ' +
												'(-1 * elapsed_time) / 86400 ' +
											'ELSE ' +
												'elapsed_time / 86400000 ' +
										'END ' +
									') ' +
								') ' +
							') OVER () ' +
								'WHEN 1 THEN 2 ' +
								'ELSE ' +
									'MAX ' +
									'( ' +
										'LEN ' +
										'( ' +
											'CONVERT ' +
											'( ' +
												'VARCHAR, ' +
												'CASE ' +
													'WHEN elapsed_time < 0 THEN ' +
														'(-1 * elapsed_time) / 86400 ' +
													'ELSE ' +
														'elapsed_time / 86400000 ' +
												'END ' +
											') ' +
										') ' +
									') OVER () ' +
						'END AS max_elapsed_length, ' +
						CASE
							WHEN @output_column_list LIKE '%|_delta|]%' ESCAPE '|' THEN
								'MAX(physical_io * recursion) OVER (PARTITION BY session_id, request_id) + ' +
									'MIN(physical_io * recursion) OVER (PARTITION BY session_id, request_id) AS physical_io_delta, ' +
								'MAX(reads * recursion) OVER (PARTITION BY session_id, request_id) + ' +
									'MIN(reads * recursion) OVER (PARTITION BY session_id, request_id) AS reads_delta, ' +
								'MAX(physical_reads * recursion) OVER (PARTITION BY session_id, request_id) + ' +
									'MIN(physical_reads * recursion) OVER (PARTITION BY session_id, request_id) AS physical_reads_delta, ' +
								'MAX(writes * recursion) OVER (PARTITION BY session_id, request_id) + ' +
									'MIN(writes * recursion) OVER (PARTITION BY session_id, request_id) AS writes_delta, ' +
								'MAX(tempdb_allocations * recursion) OVER (PARTITION BY session_id, request_id) + ' +
									'MIN(tempdb_allocations * recursion) OVER (PARTITION BY session_id, request_id) AS tempdb_allocations_delta, ' +
								'MAX(tempdb_current * recursion) OVER (PARTITION BY session_id, request_id) + ' +
									'MIN(tempdb_current * recursion) OVER (PARTITION BY session_id, request_id) AS tempdb_current_delta, ' +
								'MAX(CPU * recursion) OVER (PARTITION BY session_id, request_id) + ' +
									'MIN(CPU * recursion) OVER (PARTITION BY session_id, request_id) AS CPU_delta, ' +
								'MAX(thread_CPU_snapshot * recursion) OVER (PARTITION BY session_id, request_id) + ' +
									'MIN(thread_CPU_snapshot * recursion) OVER (PARTITION BY session_id, request_id) AS thread_CPU_delta, ' +
								'MAX(context_switches * recursion) OVER (PARTITION BY session_id, request_id) + ' +
									'MIN(context_switches * recursion) OVER (PARTITION BY session_id, request_id) AS context_switches_delta, ' +
								'MAX(used_memory * recursion) OVER (PARTITION BY session_id, request_id) + ' +
									'MIN(used_memory * recursion) OVER (PARTITION BY session_id, request_id) AS used_memory_delta, ' +
								'MIN(last_request_start_time) OVER (PARTITION BY session_id, request_id) AS first_request_start_time, '
							ELSE ''
						END +
						'COUNT(*) OVER (PARTITION BY session_id, request_id) AS num_events ' +
					'FROM #sessions AS s1 ' +
					CASE 
						WHEN @sort_order = '' THEN ''
						ELSE
							'ORDER BY ' +
								@sort_order
					END +
				') AS s ' +
				'WHERE ' +
					's.recursion = 1 ' +
			') x ' +
			'OPTION (KEEPFIXED PLAN); ' +
			'' +
			CASE @return_schema
				WHEN 1 THEN
					'SET @schema = ' +
						'''CREATE TABLE <table_name> ( '' + ' +
							'STUFF ' +
							'( ' +
								'( ' +
									'SELECT ' +
										''','' + ' +
										'QUOTENAME(COLUMN_NAME) + '' '' + ' +
										'DATA_TYPE + ' + 
										'CASE ' +
											'WHEN DATA_TYPE LIKE ''%char'' THEN ''('' + COALESCE(NULLIF(CONVERT(VARCHAR, CHARACTER_MAXIMUM_LENGTH), ''-1''), ''max'') + '') '' ' +
											'ELSE '' '' ' +
										'END + ' +
										'CASE IS_NULLABLE ' +
											'WHEN ''NO'' THEN ''NOT '' ' +
											'ELSE '''' ' +
										'END + ''NULL'' AS [text()] ' +
									'FROM tempdb.INFORMATION_SCHEMA.COLUMNS ' +
									'WHERE ' +
										'TABLE_NAME = (SELECT name FROM tempdb.sys.objects WHERE object_id = OBJECT_ID(''tempdb..#session_schema'')) ' +
										'ORDER BY ' +
											'ORDINAL_POSITION ' +
									'FOR XML ' +
										'PATH('''') ' +
								'), + ' +
								'1, ' +
								'1, ' +
								''''' ' +
							') + ' +
						''')''; ' 
				ELSE ''
			END
		--End derived table and INSERT specification
		);

	SET @sql_n = CONVERT(NVARCHAR(MAX), @sql);

	EXEC sp_executesql
		@sql_n,
		N'@schema VARCHAR(MAX) OUTPUT',
		@schema OUTPUT;
END;
GO
