--####   Backup
---
EXEC msdb.dbo.rds_backup_database
@source_db_name = 'erp_prd',
@s3_arn_to_backup_to = 'arn:aws:s3:::educat-feluma-rds-backups/ERP/PRD/erp_prd_2020_03_18__1153_higienizacao.bak',
@overwrite_S3_backup_file = 1;
---


Status
---
EXEC msdb.dbo.rds_task_status
---

-- ####   Restore
---
EXEC msdb.dbo.rds_restore_database
@restore_db_name='ERP_HMG',
@s3_arn_to_restore_from='arn:aws:s3:::educat-feluma-rds-backups/PRD/erp_prd/erp_prd_2020-07-30_2.bak'

---

EXEC msdb.dbo.rds_task_status

-- feluma -> 'arn:aws:s3:::educat-feluma-rds-backups/ERP/PRD/erp_prd_2020_03_18__1153_higienizacao.bak'
-- 
