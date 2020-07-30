/**********************************************************************************************************************************  
*                                          BACKUP AUTOMATIZADO - SP_BACKP_AUTOMATIZADO                                            *  
*                                                                                                                                 *  
*  PROCEDURE QUE CORRE A TABELA [controle_backup] E DISPARA O BACKUP NO S3 PARA TODAS QUE POSSUEM O CAMPO [FAZER_BACKUP = 1]      *  
*                                                                                                                                 *  
*                                                                                                                                 *  
* BANCO_SISTEMA : EDUCAT                                                                                                          *  
* CRIADO POR    : WEMERSON BITTORI MADURO                                                                         DATA:14/02/2020 *  
* ALTERADO POR  : WEMERSON BITTORI MADURO                                                                         DATA:14/02/2020 *  
**********************************************************************************************************************************/  
  
create OR ALTER  procedure SP_BACKP_AUTOMATIZADO as   
DECLARE @DATABASE VARCHAR(200), @SQL VARCHAR(MAX), @SQL_DATA VARCHAR(50), @DATA DATETIME
SET @DATA = GETDATE()

SET @SQL_DATA = CONVERT(VARCHAR(10), @DATA, 121) + '__' +  
                CONVERT(VARCHAR(10), DATEPART(HOUR,@DATA)) + '_00_00' 

declare CUR_ cursor for   
 SELECT NOME_BANCO FROM controle_backup WHERE FAZER_BACKUP = 1  
 open CUR_    
  fetch next from CUR_ into @DATABASE  
  while @@FETCH_STATUS = 0  
   BEGIN  
    SET @SQL = N'EXEC msdb.dbo.rds_backup_database        @source_db_name = ' + CHAR(39) +  @DATABASE + CHAR(39) +',        @s3_arn_to_backup_to = '+ CHAR(39) +'arn:aws:s3:::educat-feluma-rds-backups/PRD/' + @DATABASE + '/'++ @DATABASE + '_'+ @SQL_DATA + 
'.bak'+ CHAR(39) +',        @overwrite_S3_backup_file = 1;'   
    exec(@sql)  
  update controle_backup set arquivo_s3 = 'arn:aws:s3:::educat-feluma-rds-backups/PRD/' + @DATABASE + '/'++ @DATABASE + '_'+ @SQL_DATA + '.bak',  
                             ultima_acao = getdate()  
  where nome_banco = @DATABASE  
  PRINT '###########################################################'  
  
   fetch next from CUR_ into @DATABASE  
   END  
 close CUR_   
deallocate CUR_   