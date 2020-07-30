--  testar se podemos deletar sem problemas as aulas
-- select MAX(id) from academico_aula  

-- select * into #tmp_academico_aula_041119__1420 from academico_aula where id in (173379, 173380)


 declare @aula_id int, @grupo_id int 

	set @aula_id = 173380
	select @grupo_id = grupo_id from academico_aula where id = @aula_id
	PRINT @grupo_id
	if ((
		select distinct isnull (aaa.aula_id, ISNULL(aaf.aula_id, ISNULL(aai.aula_id, 0))) as chavestrangeira
			from academico_aula aul left join atividades_atividade_aula  aaa on (aul.id = aaa.aula_id)
									left join academico_frequenciadiaria aaf on (aul.id = aaf.aula_id)
									left join academico_intercorrencia   aai on (aul.id = aai.aula_id)
			where aul.id = @aula_id) = 0)
			 begin
				 BEGIN TRAN     -- TRANSACAO
					BEGIN TRY   -- TRATAMENTO ERRO
						EXEC sp_gerar_log_academico_AULA NULL, NULL, NULL, '-',NULL, @aula_id
						
						DELETE FROM academico_aula WHERE ID = @aula_id
						
						exec sp_agrupar_aula @GRUPO_ID
						
						PRINT 'PROCESSO CONCLUIDO COM SUCESSO!!!'
						COMMIT
					END TRY
					BEGIN CATCH -- TRATANDO ERRO 
						IF @@TRANCOUNT > 0  
						    PRINT 'OCORREU UM ERRO DURANTE O PROCESSAMENTO'
							ROLLBACK;  -- CANCELANDO TRANSACAO
					END CATCH;  
  
			 end
	else 
			begin 
				print 'EXISTE ALGUM REGISTRO RELACIONADO A CHAVE NAS TABELAS {atividades_atividade_aula,academico_frequenciadiaria,academico_intercorrencia}'
			end 
--- gerar log delecao academico aula
--- apagar aula no academico aula

--- gerar log academico grupo 
--- atualizar data inicio e fim do academico grupo


--select * from INFORMATION_SCHEMA.COLUMNS where COLUMN_NAME in('grupo_id', 'grupoaula_id', 'aula_id') and       left(TABLE_NAME,3) not in ('bkp','tmp','vw_','log') order by 4