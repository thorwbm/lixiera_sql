 IF OBJECT_ID('tempdb..#tmp_lancamento') IS NOT NULL
BEGIN
   DROP TABLE #tmp_lancamento
END
------------------------------------------------------------------------------------------------------------------------
 declare @ORIGEM  INT = 3296
 DECLARE @DESTINO INT = 4265
 
select lano.id as lancamento_id,
       contrato_id   = conD.id, 
       parcela_id    = parD.id, 
	   atualizado_em = getdate(), 
	   atualizado_por= 11717 
 ,lano.ano_competencia, lano.mes_competencia

 into #tmp_lancamento   
from contratos_contrato conO join contratos_parcela parO on (conO.id = parO.contrato_id)
                                      join financeiro_lancamento lanO on (parO.id = lanO.parcela_id and 
									                                      conO.id = lanO.contrato_id)
                                      join contratos_parcela parD on (parD.ano_competencia = parO.ano_competencia and
									                                  parD.mes_competencia = parO.mes_competencia)
                                      join contratos_contrato conD on (conD.id = parD.contrato_id) 
 
 where conO.id = @ORIGEM and 
      conD.id = @DESTINO
 
 --    select * from #tmp_lancamento

 BEGIN TRY
 begin tran 
 -- GERAR LOG    
---------------------------------------------------------------------------------
declare @lancamento_id int 

 declare CUR_lanc cursor for         
    SELECT distinct lancamento_id FROM #tmp_lancamento        
        open CUR_lanc         
        fetch next from CUR_lanc into @lancamento_id        
        while @@FETCH_STATUS = 0        
            BEGIN        
            
                exec SP_GERAR_LOG 'financeiro_lancamento', @lancamento_id, '~',11717, NULL, NULL, NULL        
        
                fetch next from CUR_lanc into @lancamento_id        
            END        
        close CUR_lanc         
        deallocate CUR_lanc    
		
-- ATUALIZAR TABELA LANCAMENTO
---------------------------------------------------------------------------------   
    UPDATE  lan set lan.contrato_id = tmp.contrato_id, 
                    lan.parcela_id  = tmp.parcela_id, 
				    lan.atualizado_em = getdate(), 
				    lan.atualizado_por = 11717,
                    lan.justificativa = 'correcao_teste'       
       from       
           financeiro_lancamento lan join #tmp_lancamento tmp on (lan.id = tmp.lancamento_id)        
 commit
 PRINT '********* PROCESSO EXECUTADO COM SUCESSO **********'

 END TRY 

 BEGIN CATCH 
	ROLLBACK 
	PRINT '############# PROCESSO NAO EXECUTADO ###############   ' + ERROR_MESSAGE() 
 END CATCH
 -- rollback


   select *  from financeiro_lancamento where justificativa = 'correcao_teste'

-----------------------------------------------------------------------------------------------------------------------------
select dst.aluno_id, ori.id as origem, dst.id as destino
from contratos_contrato dst join contratos_contrato ori on (dst.origem_id = ori.id)
where dst.aluno_id = 20484
--------------------------------------------------------------------------------------------


   select ano_competencia, mes_competencia,con.* from contratos_contrato con join financeiro_lancamento lan on (con.id = lan.contrato_id)
where con.id = 3296
order by ano_competencia, mes_competencia
--------------------------------------------------------------------------------------------------------------------------------------------
   select ano_competencia, mes_competencia,con.* from contratos_contrato con join financeiro_lancamento lan on (con.id = lan.contrato_id)
where con.id = 4265
order by ano_competencia, mes_competencia
--------------------------------------------------------------------------------------------------------------------------------------

select ano_competencia, mes_competencia,con.* from contratos_contrato con left join financeiro_lancamento lan on (con.id = lan.contrato_id)
where con.id = 3780
order by ano_competencia, mes_competencia







