/****** Object:  StoredProcedure [dbo].[sp_bloqueio]    Script Date: 25/11/2019 09:23:18 ******/
DROP PROCEDURE [dbo].[sp_bloqueio]
GO
/****** Object:  StoredProcedure [dbo].[sp_bloqueio]    Script Date: 25/11/2019 09:23:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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

CREATE   PROCEDURE [dbo].[sp_bloqueio] as 

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
