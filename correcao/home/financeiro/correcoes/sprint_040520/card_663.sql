-- https://trello.com/c/PVv63IuU
-- https://trello.com/c/5tnIEjiY
begin tran 
DECLARE @DATAEXECUCAO DATETIME      
SET @DATAEXECUCAO = CAST( CONVERT(VARCHAR(19),GETDATE(),120) AS DATETIME) 

 SELECT fnc.*
  -- update lan set lan.status_id = 8, atualizado_em = @DATAEXECUCAO, atualizado_por = 11717
  FROM VW_FNC_CONTR_CURRIC_LANCAMENTO_DESC_ALUNO fnc join vw_fnc_responsavel_financeiro_bolsa res on (fnc.lancamento_responsavel_financeiro_id = res.responsavel_id)
                                                     join financeiro_lancamento               lan on (lan.id = fnc.lancamento_id)
WHERE lancamento_responsavel_financeiro_nome like '%prouni%' and 
      lan.status_id not in (10,7)

EXEC SP_GERAR_LOG_EM_LOTE_UPDATE 'FINANCEIRO_LANCAMENTO', @DATAEXECUCAO, 11717,null, null,null   


-- select * from FINANCEIRO_LANCAMENTO where atualizado_em >= '2020-05-4 16:18:00' and atualizado_por = 11717
-- commit 
-- rollback 
-- select * from financeiro_statuslancamento