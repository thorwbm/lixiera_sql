USE [ADMINISTRACAO]
GO
/****** Object:  StoredProcedure [dbo].[SP_RESTORE_BACKUP_AUTOMATIZADO]    Script Date: 28/03/2020 15:18:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/**********************************************************************************************************************************
*                                                 SP_RESTORE_BACKUP_AUTOMATIZADO                                                  *
*                                                                                                                                 *
*  PROCEDURE DISPARA NA INSTANCIA DE HOMOLOGACAO O RESTORE DAS BASES INDICADAS NA TABELA                                          *
*  [ADMINISTRACAO.controle_backup_homologacao] COM O NOME DA BASE MAIS O COMPLEMENTO [_DIARIO]                                    *
*                                                                                                                                 *
* BANCO_SISTEMA : ADMINISTRACAO                                                                                                   *
* CRIADO POR    : WEMERSON BITTORI MADURO                                                                         DATA:27/03/2020 *
* ALTERADO POR  : WEMERSON BITTORI MADURO                                                                         DATA:27/03/2020 *
**********************************************************************************************************************************/
-- EXEC SP_RESTORE_BACKUP_AUTOMATIZADO
-- SELECT * FROM controle_backup_homologacao

ALTER   PROCEDURE [dbo].[SP_RESTORE_BACKUP_AUTOMATIZADO] AS 

DECLARE @DATABASE VARCHAR(200), @SQL VARCHAR(MAX), @SQL_DELETE VARCHAR(MAX),
        @DATA DATETIME, @ENDERECO VARCHAR(MAX), @BANCO_HOM VARCHAR(100), @POSICAO INT


declare CUR_ cursor for   
 SELECT pri.nome_banco, nome_homol = pri.nome_banco + '_DIARIO',
        endereco_backup =  CHAR(39) +'arn:aws:s3:::educat-feluma-rds-backups/PRD/' + pri.NOME_BANCO + '/'+ pri.NOME_BANCO + '_'+ CONVERT(VARCHAR(10), getdate(), 121 ) + '_' + convert(varchar(10),isnull(max(sec.posicao),1) + 1)+ 
                '.bak'+ CHAR(39),
		posicao = isnull(max(sec.posicao),1) + 1
  FROM controle_backup_homologacao pri left join controle_backup_homologacao sec on (pri.id = sec.id and 
                                                                                    cast(sec.ultima_acao as date) = cast(getdate() as date))
 WHERE pri.RESTAURAR_BACKUP = 1  
 group by pri.nome_banco

 open CUR_    
  fetch next from CUR_ into @DATABASE, @BANCO_HOM, @ENDERECO, @POSICAO   
  while @@FETCH_STATUS = 0  
   BEGIN  
   SET @SQL_DELETE = N'
					  IF(EXISTS(SELECT 1 FROM sys.databases WHERE NAME = ' + CHAR(39) + @BANCO_HOM + CHAR(39) +'))
							BEGIN
								USE [master]
								ALTER DATABASE ' + @BANCO_HOM + ' SET  SINGLE_USER WITH ROLLBACK IMMEDIATE
								USE [master]
								DROP DATABASE ' + @BANCO_HOM + '
								USE [ADMINISTRACAO]
						   END '
   EXEC(@SQL_DELETE) 

   SET @SQL = N'EXEC msdb.dbo.rds_restore_database
              @restore_db_name=' + CHAR(39) + @BANCO_HOM + CHAR(39) +',
              @s3_arn_to_restore_from=' + @ENDERECO 
   EXEC(@SQL)

  update controle_backup_homologacao set arquivo_s3 = @ENDERECO,  POSICAO = @POSICAO, ultima_acao = getdate()    where nome_banco = @DATABASE

  SET @SQL = N'USE [' + @BANCO_HOM +'] 
               UPDATE administacao_banco SET CRIADO_EM = GETDATE(), TIPO_DATABASE = ' + CHAR(39) + 'HOMOLOGACAO' + CHAR(39) 
  EXEC (@SQL)
    

  print '#####################################################################################3'
  
   fetch next from CUR_ into @DATABASE, @BANCO_HOM, @ENDERECO, @POSICAO   
   END  
 close CUR_   
deallocate CUR_   

