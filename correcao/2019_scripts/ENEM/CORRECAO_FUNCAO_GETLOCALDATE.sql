/****** Object:  View [dbo].[vw_distribiucao_faixa_ouro]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER view [dbo].[vw_distribiucao_faixa_ouro] as 
    select id_corretor, total_correcoes = correcao, 
           correcoes_ouro_dia = correcaoouro,
           total_correcao_dia = total_dia_correcao,
           total_correcao_anterior = correcao_dia_anterior,
           id_projeto = tab.id_projeto, 
           cota_correcao_dia = dia.correcoes,
           limite_dia = tab.correcao_dia_anterior + dia.correcoes, faixa = tab.correcao_dia_anterior + dia.correcoes - total_dia_correcao
    
    from (
select distinct  id_corretor, correcao = (select count(*) from correcoes_correcao cor with (nolock) where cor.Id_corretor = our.id_corretor  
                      and  cor.id_status = 3 ), 
                      correcaoouro = (select count(*) from correcoes_correcao cor with (nolock) where cor.Id_corretor = our.id_corretor  
                      and  cor.id_status = 3 and id_tipo_correcao = 5 and cast(data_termino as date)=  cast(DBO.GETLOCALDATE() as date)),
                total_dia_correcao = (select count(*) from correcoes_correcao cor with (nolock) where cor.Id_corretor = our.id_corretor  
                      and  cor.id_status = 3 and cast(data_termino as date)=  cast(DBO.GETLOCALDATE() as date)),
                 correcao_dia_anterior = (select count(*) from correcoes_correcao cor with (nolock) where cor.Id_corretor = our.id_corretor  
                      and  cor.id_status = 3  and cast(data_termino as date)  <  cast( DBO.GETLOCALDATE() as date)),
                id_projeto = our.id_projeto
 from correcoes_filaouro our) as tab join VW_CORRECAO_DIA dia on (tab.id_corretor = dia.id and tab.id_projeto = dia.id_projeto)

GO
--##############################################################################################################################################
create OR ALTER view [dbo].[vw_util_current_queries] as
SELECT
    RIGHT('00' + CAST(DATEDIFF(SECOND, COALESCE(B.start_time, A.login_time), DBO.GETLOCALDATE()) / 86400 AS VARCHAR), 2) + ' ' + 
    RIGHT('00' + CAST((DATEDIFF(SECOND, COALESCE(B.start_time, A.login_time), DBO.GETLOCALDATE()) / 3600) % 24 AS VARCHAR), 2) + ':' + 
    RIGHT('00' + CAST((DATEDIFF(SECOND, COALESCE(B.start_time, A.login_time), DBO.GETLOCALDATE()) / 60) % 60 AS VARCHAR), 2) + ':' + 
    RIGHT('00' + CAST(DATEDIFF(SECOND, COALESCE(B.start_time, A.login_time), DBO.GETLOCALDATE()) % 60 AS VARCHAR), 2) + '.' + 
    RIGHT('000' + CAST(DATEDIFF(SECOND, COALESCE(B.start_time, A.login_time), DBO.GETLOCALDATE()) AS VARCHAR), 3) 
    AS Duration,
    A.session_id AS session_id,
    B.command,
    CAST('<?query --' + CHAR(10) + (
        SELECT TOP 1 SUBSTRING(X.[text], B.statement_start_offset / 2 + 1, ((CASE
                                                                          WHEN B.statement_end_offset = -1 THEN (LEN(CONVERT(NVARCHAR(MAX), X.[text])) * 2)
                                                                          ELSE B.statement_end_offset
                                                                      END
                                                                     ) - B.statement_start_offset
                                                                    ) / 2 + 1
                     )
    ) + CHAR(10) + '--?>' AS XML) AS sql_text,
    CAST('<?query --' + CHAR(10) + X.[text] + CHAR(10) + '--?>' AS XML) AS sql_command,
    A.login_name,
    '(' + CAST(COALESCE(E.wait_duration_ms, B.wait_time) AS VARCHAR(20)) + 'ms)' + COALESCE(E.wait_type, B.wait_type) + COALESCE((CASE 
        WHEN COALESCE(E.wait_type, B.wait_type) LIKE 'PAGEIOLATCH%' THEN ':' + DB_NAME(LEFT(E.resource_description, CHARINDEX(':', E.resource_description) - 1)) + ':' + SUBSTRING(E.resource_description, CHARINDEX(':', E.resource_description) + 1, 999)
        WHEN COALESCE(E.wait_type, B.wait_type) = 'OLEDB' THEN '[' + REPLACE(REPLACE(E.resource_description, ' (SPID=', ':'), ')', '') + ']'
        ELSE ''
    END), '') AS wait_info,
    COALESCE(B.cpu_time, 0) AS CPU,
    COALESCE(F.tempdb_allocations, 0) AS tempdb_allocations,
    COALESCE((CASE WHEN F.tempdb_allocations > F.tempdb_current THEN F.tempdb_allocations - F.tempdb_current ELSE 0 END), 0) AS tempdb_current,
    COALESCE(B.logical_reads, 0) AS reads,
    COALESCE(B.writes, 0) AS writes,
    COALESCE(B.reads, 0) AS physical_reads,
    COALESCE(B.granted_query_memory, 0) AS used_memory,
    NULLIF(B.blocking_session_id, 0) AS blocking_session_id,
    COALESCE(G.blocked_session_count, 0) AS blocked_session_count,
    'KILL ' + CAST(A.session_id AS VARCHAR(10)) AS kill_command,
    (CASE 
        WHEN B.[deadlock_priority] <= -5 THEN 'Low'
        WHEN B.[deadlock_priority] > -5 AND B.[deadlock_priority] < 5 AND B.[deadlock_priority] < 5 THEN 'Normal'
        WHEN B.[deadlock_priority] >= 5 THEN 'High'
    END) + ' (' + CAST(B.[deadlock_priority] AS VARCHAR(3)) + ')' AS [deadlock_priority],
    B.row_count,
    B.open_transaction_count,
    (CASE B.transaction_isolation_level
        WHEN 0 THEN 'Unspecified' 
        WHEN 1 THEN 'ReadUncommitted' 
        WHEN 2 THEN 'ReadCommitted' 
        WHEN 3 THEN 'Repeatable' 
        WHEN 4 THEN 'Serializable' 
        WHEN 5 THEN 'Snapshot'
    END) AS transaction_isolation_level,
    A.[status],
    NULLIF(B.percent_complete, 0) AS percent_complete,
    A.[host_name],
    COALESCE(DB_NAME(CAST(B.database_id AS VARCHAR)), 'master') AS [database_name],
    A.[program_name],
    H.[name] AS resource_governor_group,
    COALESCE(B.start_time, A.last_request_end_time) AS start_time,
    A.login_time,
    COALESCE(B.request_id, 0) AS request_id,
    W.query_plan
FROM
    sys.dm_exec_sessions AS A WITH (NOLOCK)
    LEFT JOIN sys.dm_exec_requests AS B WITH (NOLOCK) ON A.session_id = B.session_id
    JOIN sys.dm_exec_connections AS C WITH (NOLOCK) ON A.session_id = C.session_id AND A.endpoint_id = C.endpoint_id
    LEFT JOIN (
        SELECT
            session_id, 
            wait_type,
            wait_duration_ms,
            resource_description,
            ROW_NUMBER() OVER(PARTITION BY session_id ORDER BY (CASE WHEN wait_type LIKE 'PAGEIO%' THEN 0 ELSE 1 END), wait_duration_ms) AS Ranking
        FROM 
            sys.dm_os_waiting_tasks
    ) E ON A.session_id = E.session_id AND E.Ranking = 1
    LEFT JOIN (
        SELECT
            session_id,
            request_id,
            SUM(internal_objects_alloc_page_count + user_objects_alloc_page_count) AS tempdb_allocations,
            SUM(internal_objects_dealloc_page_count + user_objects_dealloc_page_count) AS tempdb_current
        FROM
            sys.dm_db_task_space_usage
        GROUP BY
            session_id,
            request_id
    ) F ON B.session_id = F.session_id AND B.request_id = F.request_id
    LEFT JOIN (
        SELECT 
            blocking_session_id,
            COUNT(*) AS blocked_session_count
        FROM 
            sys.dm_exec_requests
        WHERE 
            blocking_session_id != 0
        GROUP BY
            blocking_session_id
    ) G ON A.session_id = G.blocking_session_id
    OUTER APPLY sys.dm_exec_sql_text(COALESCE(B.[sql_handle], C.most_recent_sql_handle)) AS X
    OUTER APPLY sys.dm_exec_query_plan(B.[plan_handle]) AS W
    LEFT JOIN sys.dm_resource_governor_workload_groups H ON A.group_id = H.group_id
WHERE
    A.session_id > 50
    AND A.session_id <> @@SPID
    AND (A.[status] != 'sleeping' OR (A.[status] = 'sleeping' AND B.open_transaction_count > 0))

GO
--###################################################################################################

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
		set @data = DBO.GETLOCALDATE()
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
--###########################################################################################


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
					insert correcoes_historicocorrecao values (DBO.GETLOCALDATE(), null, @CORRECAO_ID, 1, @AVALIADOR_ID)
				end

          UPDATE correcoes_correcao
          SET data_inicio = DBO.GETLOCALDATE()
          WHERE  id = @CORRECAO_ID
                 AND data_inicio IS NULL
				 AND id_projeto  = @ID_PROJETO
     END

	IF(@CORRECAO_ID = 0)
		BEGIN

			EXEC SP_BUSCA_MAIS_UM_NA_FILAAUDITORIA @AVALIADOR_ID,@ID_PROJETO,@ID_GRUPO_CORRETOR,@TIPO_BUSCA, @CORRECAO_ID output

			IF (@CORRECAO_ID > 0)
				begin
					insert correcoes_historicocorrecao values (DBO.GETLOCALDATE(), null, @CORRECAO_ID, 1, @AVALIADOR_ID)
				end
		END
	 SET NOCOUNT OFF;
RETURN

GO
--####################################################################################################

CREATE OR ALTER procedure [dbo].[sp_busca_mais_um_na_filaauditoria]
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
     DECLARE @USA_CONSISTENCIA_AUDITORIA int

	 SET NOCOUNT ON;

     SET @CORRECAO_ID = 0
	 
	 SELECT @USA_CONSISTENCIA_AUDITORIA = ativo FROM core_feature where codigo = 'checar_consistencia_auditoria'

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
					 (consistido_auditoria = 1 OR @USA_CONSISTENCIA_AUDITORIA = 0)  and
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
											DBO.GETLOCALDATE(),
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
					          (consistido_auditoria = 1 OR @USA_CONSISTENCIA_AUDITORIA = 0)  and
			                  id_projeto = @ID_PROJETO and 
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

GO
--####################################################################################################

create OR ALTER procedure [dbo].[sp_distribuir_ordem_DIARIO]
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
declare @alcance              int


--update projeto_projeto set ouro_quantidade = 2, ouro_frequencia = 30 where id = 4

select @faixa_ouro = ouro_frequencia, @qtd_ouro= ouro_quantidade
 from projeto_projeto where id =  @id_projeto
set @aux = @faixa_ouro/ @qtd_ouro
print @aux 
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
                                          CAST(COR.DATA_TERMINO AS DATE)  <CAST(DBO.GETLOCALDATE() AS DATE))

WHILE (@CONT <= @QUANTIDADE)
    BEGIN

		set @resultado =  @QUANTIDADE_CORRIGIDA_DIA_ANTERIOR + (@aux * @cont) - (cast (RAND() * (@aux - 1) as int) + 1)  
		set @alcance   = (@QUANTIDADE_CORRIGIDA_DIA_ANTERIOR + @aux*@cont )
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

        update correcoes_filaouro set posicao =  @resultado, alcance = @alcance
        where id = @id

        SET @CONT = @CONT + 1
    END

GO
--####################################################################################################

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
       data_criacao = DBO.GETLOCALDATE(), id_origem = 1 
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
    SELECT tem.co_barra_redacao, tem.id_corretor, null, tem.id_projeto, DBO.GETLOCALDATE()
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
--####################################################################################################

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

CREATE OR ALTER procedure [dbo].[sp_inserir_log_erro_N] 
    @idCorrecao int,        /****  IDENTIFICADOR DA CORRECAO                         ***/
    @tipo_log varchar(100), /****  TIPO DO LOG { INSERT, UPDATE, DELETE,...          ***/
    @arquivo varchar(100),  /****  NOME DO ARQUIVO QUE GEROU O LOG { N02, N59, ...}  ***/
    @descricao varchar(1000),/****  DETALHAMENTO DO LOG                               ***/
    @tipo_erro varchar(1000) /****  TIPO DO ERRO QUE GEROU O LOG                      ***/
as 

insert into inep_log_erro_N (criado_em, id_correcao, tipo_log,   arquivo, des_log,     tipo_erro) 
     values                 (DBO.GETLOCALDATE(), @idCorrecao, @tipo_log, @arquivo, @descricao, @tipo_erro)

GO