
--Backup
---
EXEC msdb.dbo.rds_backup_database
@source_db_name = 'erp_prd',
@s3_arn_to_backup_to = 'arn:aws:s3:::educat-feluma-rds-backups/ERP/PRD/2020_01_22_11_25.bak',
@overwrite_S3_backup_file = 1;
---


--Status
---
EXEC msdb.dbo.rds_task_status
---

--Restore
---
EXEC msdb.dbo.rds_restore_database
@restore_db_name='erp_hmg_2020_01_22',
@s3_arn_to_restore_from='arn:aws:s3:::educat-feluma-rds-backups/ERP/PRD/2020_01_22_11_25.bak'
---
