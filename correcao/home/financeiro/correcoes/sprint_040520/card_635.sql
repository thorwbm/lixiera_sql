-- https://trello.com/c/OdfNYq7d

select distinct 
                aluno_nome, lancamento_valor_liquido, lancamento_valor_pago, lancamento_id, lancamento_ano, lancamento_mes,
                tipo = case when lancamento_valor_liquido > lancamento_valor_pago then 'A MAIOR' ELSE 'A MENOR' END 
from VW_FNC_CONTR_CURRIC_LANCAMENTO_DESC_ALUNO
where lancamento_valor_liquido <> lancamento_valor_pago and 
      aluno_nome = 'BRENDA BHERING ANDRADE' and 
      lancamento_status_nome = 'pago' 
order by aluno_nome, lancamento_ano, lancamento_mes
SELECT * FROM financeiro_lancamentoboleto WHERE LANCAMENTO_ID = 934

-- ###########################################################################
DECLARE @LANCAMENTO_ID INT 
DECLARE @LANCAMENTOBOLETO_ID INT 

SET @LANCAMENTO_ID = 934
SELECT @LANCAMENTOBOLETO_ID = ID 
  FROM FINANCEIRO_LANCAMENTOBOLETO 
 WHERE LANCAMENTO_ID = @LANCAMENTO_ID

begin tran 
DECLARE @DATAEXECUCAO DATETIME      
SET @DATAEXECUCAO = CAST( CONVERT(VARCHAR(19),GETDATE(),120) AS DATETIME) 

exec SP_GERAR_LOG 'FINANCEIRO_LANCAMENTOBOLETO',@LANCAMENTOBOLETO_ID,'-',11717,NULL, NULL,NULL
DELETE from financeiro_lancamentoboleto where id = @LANCAMENTOBOLETO_ID

/* exec SP_GERAR_LOG 'FINANCEIRO_LANCAMENTOBOLETO',   4161,'-',11717,NULL, NULL,NULL
   DELETE from financeiro_lancamentoboleto where id = 4161
*/
UPDATE LAN SET
       status_id = 3, pago_em = null, valor_pago = 0, banco = null, creditado_em = null, 
       atualizado_em = @DATAEXECUCAO, atualizado_por = 11717
  from financeiro_lancamento LAN
 where id = @LANCAMENTO_ID

EXEC SP_GERAR_LOG_EM_LOTE_UPDATE 'FINANCEIRO_LANCAMENTO', @DATAEXECUCAO, 11717,null, null,null  

select * from log_financeiro_lancamentoboleto WHERE  ID = @LANCAMENTOBOLETO_ID AND HISTORY_USER_ID >= 11717
SELECT * FROM log_financeiro_lancamento       WHERE ID = @LANCAMENTO_ID        AND atualizado_em >= @DATAEXECUCAO

-- COMMIT 
-- ROLLBACK