
begin tran 
DECLARE @DATAEXECUCAO DATETIME      
SET @DATAEXECUCAO = CAST( CONVERT(VARCHAR(19),GETDATE(),120) AS DATETIME) 

--select distinct lan.* 
--update lan set lan.status_id = 9, lan.atualizado_em = @DATAEXECUCAO, lan.atualizado_por = 11717
from VW_FNC_CONTR_CURRIC_LANCAMENTO_DESC_ALUNO fnc join financeiro_lancamento lan on (lan.id = fnc.lancamento_id)
where 
      contrato_vigente = 1 and 
      desconto_tipo_id = 3 and 
      lancamento_valor_bruto = desconto_valor and 
      lan.status_id in (1,2,3)

EXEC SP_GERAR_LOG_EM_LOTE_UPDATE 'FINANCEIRO_LANCAMENTO', @DATAEXECUCAO, 11717,null, null,null   


-- select * from FINANCEIRO_LANCAMENTO where atualizado_em >= '2020-05-05 10:18:00' and atualizado_por = 11717
-- commit 
-- rollback 
-- select * from financeiro_statuslancamento

SELECT * FROM contratos_tipodesconto