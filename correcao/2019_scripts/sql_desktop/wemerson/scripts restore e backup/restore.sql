exec msdb.dbo.rds_restore_database 
     @restore_db_name='correcao_redacao_regular_replica', 
      @s3_arn_to_restore_from='arn:aws:s3:::fgv-rds-backup/encceja/producao/correcao_redacao_regular_encceja_replica_2018_09_16_20_38_from_aws.bak';

	  
exec msdb.dbo.rds_task_status