-- ******* LIMPAR TABELAS TEMPORARIAS **********

-- *** FAZER UM BACKUP ***
EXEC SP_GERAR_BACKUP_NUVEM

-- *** VERIFICAR O TERMNINO DO BACKUP ***
exec msdb.dbo.rds_task_status

-- *** GERAR LISTA DE DROP DAS TABELAS TEMPORARIAS ***
select  'drop table ' + name,* from sys.tables 
 where name like 'tmp_%' or 
       name like '%[0123456789]%' OR 
	   name LIKE 'BKP_%'
order by name

