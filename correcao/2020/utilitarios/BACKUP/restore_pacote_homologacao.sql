
EXEC msdb.dbo.sp_delete_database_backuphistory @database_name = N'ERP_HMG'
GO
use [ERP_HMG];
GO
use [master];
GO
USE [master]
GO
ALTER DATABASE [ERP_HMG] SET  SINGLE_USER WITH ROLLBACK IMMEDIATE
GO
USE [master]
GO
/****** Object:  Database [ERP_HMG]    Script Date: 03/06/2020 16:54:44 ******/
DROP DATABASE [ERP_HMG]
GO
-----------------------------------------------------------------------
declare @caminho varchar(max), @SQL_DATA VARCHAR(50), @DATA DATETIME
SET @DATA = GETDATE()

SET @SQL_DATA = replace(CONVERT(VARCHAR(10), @DATA, 121) + '__' +  
                CONVERT(VARCHAR(10), DATEPART(HOUR,@DATA)) + '_00_00','-','_') 
set @caminho = 'arn:aws:s3:::educat-feluma-rds-backups/ERP/PRD/erp_prd_'  + @SQL_DATA + '.bak'
----------------------------------------------------------------------

EXEC msdb.dbo.rds_restore_database
@restore_db_name='ERP_HMG',
@s3_arn_to_restore_from= @caminho

--########################################################
EXEC msdb.dbo.sp_delete_database_backuphistory @database_name = N'BOLETOS_SERVICE'
GO
USE [master]
GO
DROP DATABASE [BOLETOS_SERVICE]
GO
-----------------------------------------------------------------------
declare @caminho varchar(max), @SQL_DATA VARCHAR(50), @DATA DATETIME
SET @DATA = GETDATE()

SET @SQL_DATA = replace(CONVERT(VARCHAR(10), @DATA, 121) + '__' +  
                CONVERT(VARCHAR(10), DATEPART(HOUR,@DATA)) + '_00_00','-','_') 
set @caminho = 'arn:aws:s3:::educat-feluma-rds-backups/ERP/BOLETO/boletos_service_' + @SQL_DATA + '.bak'
-----------------------------------------------------------------------

EXEC msdb.dbo.rds_restore_database
@restore_db_name='BOLETOS_SERVICE',
@s3_arn_to_restore_from=@caminho 

--###################################################################
EXEC msdb.dbo.sp_delete_database_backuphistory @database_name = N'MAT_PRD'
GO
USE [master]
GO
DROP DATABASE [MAT_PRD]
GO
-----------------------------------------------------------------------
declare @caminho varchar(max), @SQL_DATA VARCHAR(50), @DATA DATETIME
SET @DATA = GETDATE()

SET @SQL_DATA = replace(CONVERT(VARCHAR(10), @DATA, 121) + '__' +  
                CONVERT(VARCHAR(10), DATEPART(HOUR,@DATA)) + '_00_00','-','_') 
set @caminho = 'arn:aws:s3:::educat-feluma-rds-backups/ERP/MAT/mat_prd_' + @SQL_DATA + '.bak'
-----------------------------------------------------------------------

EXEC msdb.dbo.rds_restore_database
@restore_db_name='MAT_PRD',
@s3_arn_to_restore_from= @caminho

--#############################################################
EXEC msdb.dbo.sp_delete_database_backuphistory @database_name = N'REM_PRD'
GO
USE [master]
GO
DROP DATABASE [REM_PRD]
GO
-----------------------------------------------------------------------
declare @caminho varchar(max), @SQL_DATA VARCHAR(50), @DATA DATETIME
SET @DATA = GETDATE()

SET @SQL_DATA = replace(CONVERT(VARCHAR(10), @DATA, 121) + '__' +  
                CONVERT(VARCHAR(10), DATEPART(HOUR,@DATA)) + '_00_00','-','_') 
set @caminho = 'arn:aws:s3:::educat-feluma-rds-backups/ERP/REM/rem_prd_' + @SQL_DATA + '.bak'
-----------------------------------------------------------------------

EXEC msdb.dbo.rds_restore_database
@restore_db_name='REM_PRD',
@s3_arn_to_restore_from= @caminho



EXEC msdb.dbo.rds_task_status