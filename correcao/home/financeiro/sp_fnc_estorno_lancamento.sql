  
--  exec sp_fnc_estorno_lancamento 202, 11717  
create or alter procedure [dbo].[sp_fnc_estorno_lancamento] 
    @lancamento_id int,
    @usuario_id int as   
  
DECLARE @DATAEXECUCAO DATETIME  
SET @DATAEXECUCAO = CAST( CONVERT(VARCHAR(19),GETDATE(),120) AS DATETIME)   
  
begin try  
    begin tran    
-- ###########################################################################################  
-- atualizar lancamento  
             update lan set lan.pago_em = null,   
                            lan.valor_pago = 0,  
                            lan.status_id  = 2,  
                            lan.atualizado_em = @DATAEXECUCAO,  
                            lan.atualizado_por = @usuario_id,  
                            lan.creditado_em = null  
             from financeiro_lancamento  lan  
             where id = @lancamento_id and   
                   status_id = 5   
  
        EXEC SP_GERAR_LOG_EM_LOTE_UPDATE 'FINANCEIRO_LANCAMENTO', @DATAEXECUCAO, @usuario_id,null, null,null    
-- ###########################################################################################  
-- atualizar lancamentoboletos  
        update lab set  
               lab.atualizado_em = @DATAEXECUCAO,  
               lab.atualizado_por = @usuario_id,  
               lab.pago_em = null,   
               lab.valor_pago = 0,  
               lab.creditado_em = null  
  
        from FINANCEIRO_LANCAMENTOBOLETO lab  
        where lab.lancamento_id = @lancamento_id  
  
        EXEC SP_GERAR_LOG_EM_LOTE_UPDATE 'FINANCEIRO_LANCAMENTOBOLETO', @DATAEXECUCAO, @usuario_id,null, null,null      
-- ###########################################################################################  
    commit  
    PRINT 'PROCESSO EFETUADO COM SUCESSO'  
end try  
begin catch  
    rollback  
    print 'ERRO DURANTE O ESTORNO - ' + ERROR_MESSAGE()  
end catch  