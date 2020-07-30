/*
alter database erp_hmg set single_user with rollback immediate
EXEC rdsadmin.dbo.rds_modify_db_name N'erp_hmg', N'erp_hmg_OLD'
alter database erp_hmg_OLD set multi_user

alter database erp_hmg_2020_01_16 set single_user with rollback immediate
EXEC rdsadmin.dbo.rds_modify_db_name N'erp_hmg_2020_01_16', N'erp_hmg'
alter database erp_hmg set multi_user
*/

/*
-- ##################  VOLTAR AO ESTADO ANTERIOR ###############
alter database erp_hmg set single_user with rollback immediate
EXEC rdsadmin.dbo.rds_modify_db_name N'erp_hmg', N'erp_hmg_2020_01_16'
alter database erp_hmg_2020_01_16 set multi_user

alter database erp_hmg_OLD set single_user with rollback immediate
EXEC rdsadmin.dbo.rds_modify_db_name N'erp_hmg_OLD', N'erp_hmg'
alter database erp_hmg set multi_user
*/



