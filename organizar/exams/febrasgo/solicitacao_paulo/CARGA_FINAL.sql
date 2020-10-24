select * from avaliacoes_avaliacao
select * from itens_item
select * from itens_alternativa


-- CARGA CORE EXAME
INSERT INTO CORE_EXAME(criado_em,atualizado_em, descricao)
SELECT CRIADO_EM = GETDATE(), ATUALIZADO_EM = GETDATE(), DESCRICAO =  'EXAME FEBRASGO'

-- CARGA AVALIACAO AVALIACAO 
INSERT INTO avaliacoes_avaliacao (criado_em, atualizado_em, nome, VALOR, VERSAO, INSTRUCOES, ATUALIZADO_POR_ID, CRIADO_POR_ID, EXAME_ID)
select criado_em = getdate(), atualizado_em = getdate(), nome = 'PROVA A', VALOR = 10, VERSAO = 1, INSTRUCOES = NULL,
       ATUALIZADO_POR_ID = 1, CRIADO_POR_ID = 1, EXAME_ID = 1 
	UNION    
select criado_em = getdate(), atualizado_em = getdate(), nome = 'PROVA B', VALOR = 10, VERSAO = 1, INSTRUCOES = NULL,
       ATUALIZADO_POR_ID = 1, CRIADO_POR_ID = 1, EXAME_ID = 1 
    UNION 
select criado_em = getdate(), atualizado_em = getdate(), nome = 'PROVA C', VALOR = 10, VERSAO = 1, INSTRUCOES = NULL,
       ATUALIZADO_POR_ID = 1, CRIADO_POR_ID = 1, EXAME_ID = 1 


--DECLARE @CONTADOR INT  = 1
--DECLARE @PROVA VARCHAR(1) ='C'

----DELETE FROM TMP_ITENS

--WHILE (@CONTADOR <= 100)
--BEGIN
--   INSERT INTO TMP_ITENS (PROVA, ID)
--   SELECT PROVA = @PROVA, ID = @CONTADOR
--   SET @CONTADOR = @CONTADOR + 1
--END 

INSERT INTO ITENS_ITEM (criado_em, atualizado_em, versao, publico, criado_por, status_id, EXAME_ID, EXTERNAL_ID, palavras_chave)
SELECT ITEM_BASE.*, EXTERNAL_ID = TMP.ID, palavras_chave = TMP.PROVA FROM (
SELECT criado_em = getdate(), atualizado_em = getdate(), versao = 1, publico = 0, criado_por =1, status_id =1, 
       EXAME_ID = 1 ) AS ITEM_BASE JOIN TMP_ITENS TMP ON (1= 1)

--##############################################################################

INSERT INTO avaliacoes_avaliacaoitem (criado_em, atualizado_em, posicao, valor, avaliacao_id, item_id)
SELECT criado_em = getdate(), atualizado_em = getdate(), 
       posicao = ROW_NUMBER() OVER(PARTITION BY ITE.palavras_chave ORDER BY ITE.EXTERNAL_ID ASC), 
	   valor = NULL, avaliacao_id = AVA.ID, item_id = ITE.ID        
FROM avaliacoes_avaliacao AVA JOIN ITENS_ITEM ITE ON (ITE.palavras_chave = RIGHT(AVA.NOME,1))



SELECT * FROM ITENS_ITEM 
SELECT * FROM itens_alternativa 


SELECT * FROM ITEM

INSERT INTO itens_alternativa (CRIADO_EM, ATUALIZADO_EM, DESCRICAO, JUSTIFICATIVA, GABARITO, POSICAO, ARQUIVO_ID, ITEM_ID)
SELECT CRIADO_EM = GETDATE(), ATUALIZADO_EM = GETDATE(), DESCRICAO = TAB.LETRA, JUSTIFICATIVA = NULL, 
      GABARITO = 0 , POSICAO = TAB.ID, ARQUIVO_ID = NULL, ITEM_ID = ITE.ID FROM (
SELECT LETRA = 'A', ID = 1 UNION 
SELECT LETRA = 'B', ID = 2 UNION 
SELECT LETRA = 'C', ID = 3 UNION 
SELECT LETRA = 'D', ID = 4 ) AS TAB JOIN ITENS_ITEM ITE ON (1 =1 )
ORDER BY ITE.ID, TAB.LETRA, TAB.ID 

SELECT * FROM TMP_GABARITO
WHERE 

--SELECT * 
--UPDATE ALT SET ALT.GABARITO = 1
--FROM itens_alternativa ALT --WHERE ITEM_ID <=100 
--JOIN TMP_GABARITO GAB ON (GAB.PROVA = 'A' AND CAST( RIGHT( GAB.id,3) AS INT) = ALT.ITEM_ID)
--WHERE GAB.Gabarito = ALT.descricao

--SELECT * 
----UPDATE ALT SET ALT.GABARITO = 1
--FROM itens_alternativa ALT --WHERE ITEM_ID <=100 
--JOIN TMP_GABARITO GAB ON (GAB.PROVA = 'B' AND CAST( RIGHT( GAB.id,3) AS INT) + 100 = ALT.ITEM_ID)
--WHERE GAB.Gabarito = ALT.descricao



SELECT * 
--UPDATE ALT SET ALT.GABARITO = 1
FROM itens_alternativa ALT --WHERE ITEM_ID <=100 
JOIN TMP_GABARITO GAB ON (GAB.PROVA = 'C' AND CAST( RIGHT( GAB.id,3) AS INT) + 200 = ALT.ITEM_ID)
WHERE GAB.Gabarito = ALT.descricao