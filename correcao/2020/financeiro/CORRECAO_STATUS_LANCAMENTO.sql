
--    drop table #temp

begin tran 
DECLARE @DATAEXECUCAO DATETIME        
SET @DATAEXECUCAO = CAST( CONVERT(VARCHAR(19),GETDATE(),120) AS DATETIME) 
select distinct 
       lan.id as lancamento_id, data = @DATAEXECUCAO, status_id, status_novo = 8
  into #temp
  from financeiro_lancamento lan 
 where responsavel_id = 782928 and 
       status_id in (3, 5)

------------------------------------------------------------------------------------------------------------------------
  update lan set lan.status_id = tem.status_novo, 
                 lan.atualizado_em = tem.data, 
				 lan.atualizado_por = 11717
  from financeiro_lancamento lan join #temp tem on (lan.id = tem.lancamento_id)
 

declare @lancamento_id int, @status_id int, @status_novo int , @observacao varchar(max)

	   declare CUR_ cursor for 
	SELECT *,
	        DBO.FN_GERAR_JSON_UPDATE( 'sataus_id' + ';' + convert(varchar(20),status_id) + ';' + convert(varchar(20),8))
	FROM #temp
	open CUR_ 
		fetch next from CUR_ into @lancamento_id, @DATAEXECUCAO, @status_id, @status_novo, @observacao
		while @@FETCH_STATUS = 0
			BEGIN
				print @lancamento_id
				print @observacao
				print '*************************************************'
				EXEC SP_GERAR_LOG 'financeiro_lancamento', @lancamento_id, '~', 11717, @observacao, null, 'FNDE É FINANCIAMENTO'  

			fetch next from CUR_ into  @lancamento_id, @DATAEXECUCAO, @status_id, @status_novo, @observacao
			END
	close CUR_ 
deallocate CUR_ 

  
------------------------------------------------------------------------------------------------------------------------
select * from log_financeiro_lancamento
where atualizado_por = 11717 and atualizado_em = @DATAEXECUCAO


-- commit 
-- rollback 

