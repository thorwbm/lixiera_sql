ADMINISTRACAO
batimento_fundep
BOLETOS_SERVICE
boletos_service_DIARIO
carga_universus
correcao_fundep
cpa_forms
cpa_forms_hmg
educat_cmmg
emails_service
ERP_HMG
erp_pos_prd_DIARIO
ERP_PRD_TESTE
exams_cmmg
homologacao_teste
master
mat_hmg
mat_pos_prd_DIARIO
MAT_PRD
mat_prd_DIARIO
model
msdb
rdsadmin
USE rem_hmg
USE rem_hmg_v2
USE REM_PRD
--rem_prd_DIARIO

-- EXEC SP_MNT_REBUID_INDICES 80
CREATE OR ALTER PROCEDURE SP_MNT_REBUID_INDICES @fillfactor INT AS 
declare @Table varchar(max), @cmd varchar(max)
print '### rem_hmg ###' 
DECLARE TableCursor CURSOR FOR 
			SELECT table_name  as tableName FROM INFORMATION_SCHEMA.TABLES WHERE table_type = 'BASE TABLE' and table_name not in ('sysdiagrams', 'health_check_db_testmodel')
			OPEN TableCursor   
				FETCH NEXT FROM TableCursor INTO @Table   
					WHILE @@FETCH_STATUS = 0   
						BEGIN   
							BEGIN	
								SET @cmd = 'ALTER INDEX ALL ON ' + @Table + ' REBUILD WITH (FILLFACTOR = ' + CONVERT(VARCHAR(3),@fillfactor) + ')' 
								--EXEC (@cmd) 
								PRINT (@cmd)
								SET @cmd = 'UPDATE STATISTICS  ' + @Table 
								--EXEC (@cmd) 
								PRINT (@cmd)
							END
							FETCH NEXT FROM TableCursor INTO @Table   
						END   
					CLOSE TableCursor   
				DEALLOCATE TableCursor  