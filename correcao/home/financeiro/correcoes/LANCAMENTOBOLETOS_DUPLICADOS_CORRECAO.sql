with cte_duplicidade as (
            select lancamento_id, id as lancamento_boleto_id 
            from financeiro_lancamentoboleto 
               where lancamento_id in (
            SELECT lan.id
              FROM financeiro_lancamento lan join financeiro_lancamentoboleto lbl on (lan.id = lbl.lancamento_id)
              where lbl.pago_em is not null and lan.id <> 3293 
              group by lan.id
              having count(distinct lbl.id) > 1
            )
)

select lancamento_id, max(lancamento_boleto_id) as lancbol_id 
into #temp
  from cte_duplicidade
 group by lancamento_id
 order by 1

--#############################################################
 BEGIN TRAN 
declare @lancamento_id int 
declare @lancbol_id int

declare CUR_ cursor for 
	SELECT lancamento_id, lancbol_id FROM #temp order by lancamento_id
	open CUR_ 
		fetch next from CUR_ into @lancamento_id, @lancbol_id
		while @@FETCH_STATUS = 0
			BEGIN

                exec SP_GERAR_LOG 'financeiro_lancamentoboleto',@lancbol_id,'-',11717,null,null,'DUPLICIDADE DE REGISTRO'
				print 'deletar o lancamento_boleto ' + convert(varchar(10), @lancbol_id)+ ' do lancamento ' + convert(varchar(10),@lancamento_id) 
                DELETE FROM financeiro_lancamentoboleto WHERE ID = @lancbol_id

			fetch next from CUR_ into @lancamento_id, @lancbol_id
			END
	close CUR_ 
deallocate CUR_ 

-- COMMIT 
-- ROLLBACK 


--#######################################
SELECT TOP 100 * FROM LOG_financeiro_lancamentoboleto ORDER BY history_id DESC -- 10949