
USE REM_PRD
DECLARE @Database VARCHAR(255)   
DECLARE @Table VARCHAR(255)  
DECLARE @cmd NVARCHAR(500)  
DECLARE @fillfactor INT
SET @fillfactor = 80  

DECLARE DatabaseCursor CURSOR FOR 

Select [name] as [databases] From sys.databases where name  not in ('master', 'tempdb', 'model', 'msdb', 'rdsadmin' )-- and name = 'exams_sae'

   OPEN DatabaseCursor
   FETCH NEXT FROM DatabaseCursor INTO @Database   
   WHILE @@FETCH_STATUS = 0   
   BEGIN   
            print '#########################################################################################################'
			SET @cmd = N'USE [' + @Database+'] ; select top 1 ' + char(39) +  @Database +  char(39) +  ' as tabela, * from sys.tables '
			PRINT (@cmd) 
		    exec sp_executesql @cmd
			print '##############   [' + @Database+']  ##############'
			--USE exams_sae
			DECLARE TableCursor CURSOR FOR 
			SELECT table_name  as tableName FROM INFORMATION_SCHEMA.TABLES WHERE table_type = 'BASE TABLE' and table_name not in ('sysdiagrams', 'health_check_db_testmodel')
			OPEN TableCursor   
				FETCH NEXT FROM TableCursor INTO @Table   
					WHILE @@FETCH_STATUS = 0   
						BEGIN   
							BEGIN
								SET @cmd = 'USE ' + @Database + '----- ' + @Table
								
								--SET @cmd = 'ALTER INDEX ALL ON ' + @Table + ' REBUILD WITH (FILLFACTOR = ' + CONVERT(VARCHAR(3),@fillfactor) + ')' 
								--EXEC (@cmd) 
								PRINT (@cmd)
								--SET @cmd = 'UPDATE STATISTICS  ' + @Table 
								--EXEC (@cmd) 
								--PRINT (@cmd)
							END
							FETCH NEXT FROM TableCursor INTO @Table   
						END   
					CLOSE TableCursor   
				DEALLOCATE TableCursor  
			
			--SET @cmd = 'USE master' 
			FETCH NEXT FROM DatabaseCursor INTO @Database   
		END   
	CLOSE DatabaseCursor   
DEALLOCATE DatabaseCursor 
 

-- USE batimento_fundep

----   SELECT a.object_id, object_name(a.object_id) AS TableName,
----       a.index_id, name AS IndedxName, avg_fragmentation_in_percent
----   FROM sys.dm_db_index_physical_stats
----       (DB_ID (N'erp_hmg')
----           , OBJECT_ID(N'academico_turmadisciplinaaluno')
----           , NULL
----           , NULL
----           , NULL) AS a
----   INNER JOIN sys.indexes AS b
----       ON a.object_id = b.object_id
----       AND a.index_id = b.index_id;

--Função de banco de dados db_ddladmin1
--Função de banco de dados db_owner
--função de servidor sysadmin