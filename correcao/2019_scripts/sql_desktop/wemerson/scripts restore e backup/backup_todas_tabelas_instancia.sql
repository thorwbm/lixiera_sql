USE [administracao]
GO

/****** Object:  StoredProcedure [dbo].[SP_GERAR_BACKUP_NUVEM]    Script Date: 17/09/2018 12:11:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[SP_GERAR_BACKUP_NUVEM] AS
declare @banco varchar(200)
declare @endereco varchar(500)

declare @data varchar(16)

declare abc cursor for 
	select distinct name from sys.databases
     where name not in ('master','tempdb','model','msdb','rdsadmin') 

	open abc 
		fetch next from abc into @banco
		while @@FETCH_STATUS = 0
			BEGIN
				set @data = replace((select convert(varchar(4),year(getdate())) + '_' + right('0'+convert(varchar(2),month(getdate())),2) + '_' + right('0'+convert(varchar(2),day(getdate())),2) + '_'+ CONVERT(VARCHAR(15),GETDATE(),(114))),':','_')
				set @endereco = 'arn:aws:s3:::fgv-rds-backup/encceja/homologacao/' + @banco + '/' + @banco + '_' + @data +'_from_aws.bak'
				print '*******************************************************'
				PRINT @BANCO
				print getdate()
				  exec msdb.dbo.rds_backup_database @source_db_name= @banco, @s3_arn_to_backup_to= @endereco
				print getdate()
				print '*******************************************************'

			fetch next from abc into @banco
			END
	close abc 
deallocate abc
GO


