declare @erp varchar(200), @mat varchar(200), @rem varchar(200), @boleto varchar(200)
set @erp = 'arn:aws:s3:::educat-feluma-rds-backups/PRD/erp_prd/erp_prd_2020-03-02__04_30_00.bak'
set @mat = 'arn:aws:s3:::educat-feluma-rds-backups/PRD/mat_prd/mat_prd_2020-03-02__04_30_00.bak'
set @rem = 'arn:aws:s3:::educat-feluma-rds-backups/PRD/rem_prd/rem_prd_2020-03-02__04_30_00.bak'
set @boleto = 'arn:aws:s3:::educat-feluma-rds-backups/PRD/boletos_service/boletos_service_2020-03-02__04_30_00.bak'


--Restore
-- ### ERP_HMG ###
EXEC msdb.dbo.rds_restore_database
@restore_db_name='ERP_HMG',
@s3_arn_to_restore_from=@erp

-- ### MAT_PRD ###
EXEC msdb.dbo.rds_restore_database
@restore_db_name='MAT_PRD',
@s3_arn_to_restore_from=@mat

-- ### REM_PRD ###
EXEC msdb.dbo.rds_restore_database
@restore_db_name='REM_PRD',
@s3_arn_to_restore_from=@rem

-- ### boletos_service ###
EXEC msdb.dbo.rds_restore_database
@restore_db_name='BOLETOS_SERVICE',
@s3_arn_to_restore_from=@boleto

-- ###  LIMPAR OS EMAILS ######
update erp_hmg..auth_user set email = 'educaterpdev@gmail.com'
update mat_prd..auth_user  set email = 'educaterpdev@gmail.com'
update rem_prd..auth_user set email = 'educaterpdev@gmail.com'


--##############################################
EXEC msdb.dbo.rds_task_status
