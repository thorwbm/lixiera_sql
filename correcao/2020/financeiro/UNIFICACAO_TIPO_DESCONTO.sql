
--    drop table #temp_acordo
--    drop table #temp

begin tran 
DECLARE @DATAEXECUCAO DATETIME        
SET @DATAEXECUCAO = CAST( CONVERT(VARCHAR(19),GETDATE(),120) AS DATETIME) 
select distinct 
       des.id as desconto_id, data = @DATAEXECUCAO, tipo_desconto_id, tipo_id_novo = 15
  into #temp_acordo
  from financeiro_acordo des 
 where tipo_desconto_id in (10,11)

------------------------------------------------------------------------------------------------------------------------
  update des set des.tipo_desconto_id = tem.tipo_id_novo, 
                 des.atualizado_em = tem.data, 
				 des.atualizado_por = 11717
  from financeiro_acordo des join #temp_acordo tem on (des.id = tem.desconto_id)
 

declare @desconto_id int, @tipo_id int, @tipo_id_novo int , @observacao varchar(max)

	   declare CUR_ACR cursor for 
	SELECT *,
	        DBO.FN_GERAR_JSON_UPDATE( 'tipo_desconto_id' + ';' + convert(varchar(20),tipo_desconto_id) + ';' + convert(varchar(20),tipo_id_novo))
	FROM #temp_acordo
	open CUR_ACR 
		fetch next from CUR_ACR into @desconto_id, @DATAEXECUCAO, @tipo_id, @tipo_id_novo, @observacao
		while @@FETCH_STATUS = 0
			BEGIN
				print @desconto_id
				print @observacao
				print '*************************************************'
				EXEC SP_GERAR_LOG 'financeiro_acordo', @desconto_id, '~', 11717, @observacao, null, 'UNIFICANDO DESCONTOS [10,11 -> 15]'  

			fetch next from CUR_ACR into  @desconto_id, @DATAEXECUCAO, @tipo_id, @tipo_id_novo, @observacao
			END
	close CUR_ACR 
deallocate CUR_ACR 


---------------------------------------------------------------------------------------------------------------------




--begin tran 
--DECLARE @DATAEXECUCAO DATETIME        
--SET @DATAEXECUCAO = CAST( CONVERT(VARCHAR(19),GETDATE(),120) AS DATETIME) 
select distinct 
       des.id as desconto_id, data = @DATAEXECUCAO, tipo_id, tipo_id_novo = 15
  into #temp
  from financeiro_desconto des 
 where tipo_id in (10,11)

------------------------------------------------------------------------------------------------------------------------
  update des set des.tipo_id = tem.tipo_id_novo, 
                 des.atualizado_em = tem.data, 
				 des.atualizado_por = 11717
  from financeiro_desconto des join #temp tem on (des.id = tem.desconto_id)
 

--declare @desconto_id int, @tipo_id int, @tipo_id_novo int , @observacao varchar(max)

	   declare CUR_ cursor for 
	SELECT *,
	        DBO.FN_GERAR_JSON_UPDATE( 'tipo_id' + ';' + convert(varchar(20),tipo_id) + ';' + convert(varchar(20),tipo_id_novo))
	FROM #temp
	open CUR_ 
		fetch next from CUR_ into @desconto_id, @DATAEXECUCAO, @tipo_id, @tipo_id_novo, @observacao
		while @@FETCH_STATUS = 0
			BEGIN
				print @desconto_id
				print @observacao
				print '*************************************************'
				EXEC SP_GERAR_LOG 'financeiro_desconto', @desconto_id, '~', 11717, @observacao, null, 'UNIFICANDO DESCONTOS [10,11 -> 15]'  

			fetch next from CUR_ into  @desconto_id, @DATAEXECUCAO, @tipo_id, @tipo_id_novo, @observacao
			END
	close CUR_ 
deallocate CUR_ 

  
------------------------------------------------------------------------------------------------------------------------
DELETE FROM  contratos_tipodesconto
WHERE ID IN (10,11)


SELECT * FROM contratos_tipodesconto
WHERE ID IN (10,11)

select * from log_financeiro_acordo
where atualizado_por = 11717 and atualizado_em = @DATAEXECUCAO


select * from log_financeiro_desconto
where atualizado_por = 11717 and atualizado_em = @DATAEXECUCAO


-- commit 
-- rollback 



