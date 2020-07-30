
declare @caminho varchar(max), @SQL_DATA VARCHAR(50), @DATA DATETIME
SET @DATA = GETDATE()

SET @SQL_DATA = replace(CONVERT(VARCHAR(10), @DATA, 121) + '__' +  
                CONVERT(VARCHAR(10), DATEPART(HOUR,@DATA)) + '_00_00','-','_') 

set @caminho =   'arn:aws:s3:::educat-feluma-rds-backups/ERP/PRD/erp_prd_' + @SQL_DATA + '.bak'
EXEC msdb.dbo.rds_backup_database
@source_db_name = 'boletos_service',
@s3_arn_to_backup_to = @caminho,
@overwrite_S3_backup_file = 1;

set @caminho ='arn:aws:s3:::educat-feluma-rds-backups/ERP/PRD/erp_prd_' + @SQL_DATA + '.bak' 
EXEC msdb.dbo.rds_backup_database
@source_db_name = 'erp_prd',
@s3_arn_to_backup_to = @caminho,
@overwrite_S3_backup_file = 1;

set @caminho = 'arn:aws:s3:::educat-feluma-rds-backups/ERP/MAT/mat_prd_' + @SQL_DATA + '.bak'
EXEC msdb.dbo.rds_backup_database
@source_db_name = 'mat_prd',
@s3_arn_to_backup_to = @caminho,
@overwrite_S3_backup_file = 1;

set @caminho = 'arn:aws:s3:::educat-feluma-rds-backups/ERP/REM/rem_prd_' + @SQL_DATA + '.bak'
EXEC msdb.dbo.rds_backup_database
@source_db_name = 'rem_prd',
@s3_arn_to_backup_to = @caminho,
@overwrite_S3_backup_file = 1;