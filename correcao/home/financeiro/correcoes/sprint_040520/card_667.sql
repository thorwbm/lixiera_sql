-- card https://trello.com/c/ycODKXta

select * from VW_FNC_CONTR_CURRIC_PARCELA_DESC_ALUNO
where aluno_nome in (
'PEDRO HENRIQUE DE SOUZA PEREIRA',--) and parcela_tipo_nome = '1ª Parcela'
'ISADORA FIDELIS RIBEIRO DE SOUZA')
and parcela_mes = 1


begin tran 
DECLARE @DATAEXECUCAO DATETIME      
SET @DATAEXECUCAO = CAST( CONVERT(VARCHAR(19),GETDATE(),120) AS DATETIME) 

-- select * 
 update lan set lan.mes_competencia = 1,
        atualizado_em = @DATAEXECUCAO, atualizado_por = 11717
from financeiro_lancamento lan where parcela_id in (9670, 12879)

EXEC SP_GERAR_LOG_EM_LOTE_UPDATE 'financeiro_lancamento', @DATAEXECUCAO, 11717,'mes_competencia', 2,1   

--#############################################################################
SET @DATAEXECUCAO = CAST( CONVERT(VARCHAR(19),GETDATE(),120) AS DATETIME) 

-- select * 
 update par set par.mes_competencia = 1, par.descricao = 'parcela mes 1',
        atualizado_em = @DATAEXECUCAO, atualizado_por = 11717
from contratos_parcela par where id in (9670, 12879)

EXEC SP_GERAR_LOG_EM_LOTE_UPDATE 'contratos_parcela', @DATAEXECUCAO, 11717,'mes_competencia', 2,1   

-- commit 
-- rollback 