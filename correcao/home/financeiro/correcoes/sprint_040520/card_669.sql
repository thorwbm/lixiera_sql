
select distinct  lancamento_id, aluno_nome, lancamento_valor_liquido , lancamento_valor_pago, lancamento_mes, lancamento_ano,*
  from VW_FNC_CONTR_CURRIC_LANCAMENTO_DESC_ALUNO
where abs(lancamento_valor_liquido) <> abs(lancamento_valor_pago) and 
     aluno_nome in ('RAFAELLA MORÉS ARTIFON','RAFAEL MOURA DE OLIVEIRA') and 
     lancamento_status_nome = 'pago'  


     no caso sa RAFAELLA MORÉS ARTIFON, ela tem dois lancamentos_boleto (id_boletos -> 35637,36505)

     select * from financeiro_statuslancamento

--  ######################################################################################
begin tran 
DECLARE @DATAEXECUCAO DATETIME      
SET @DATAEXECUCAO = CAST( CONVERT(VARCHAR(19),GETDATE(),120) AS DATETIME) 

     update lan set lan.pago_em = null, 
                    lan.valor_pago = 0,
                    lan.status_id  = 2,
                    lan.atualizado_em = @DATAEXECUCAO,
                    lan.atualizado_por = 11717
     -- select *
     from financeiro_lancamento  lan
     where id = 202 and 
           status_id = 5 

EXEC SP_GERAR_LOG_EM_LOTE_UPDATE 'FINANCEIRO_LANCAMENTO', @DATAEXECUCAO, 11717,null, null,null   

exec sp_gerar_log_em_lote_delete 'financeiro_lancamentoboleto','id', 308
-- exec sp_gerar_log_em_lote_delete 'financeiro_lancamentoboleto','id', 4434

 delete
 -- select * 
     from financeiro_lancamentoboleto
     where lancamento_id in (202)

     --commit 
     -- rollback 