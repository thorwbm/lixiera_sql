CREATE   VIEW VW_FILAS_DA_REDACAO AS           
select red.id AS REDACAO_ID, fila = 1  , FILA_NOME = 'FILA 1'   , RED.ID_PROJETO from correcoes_redacao red join correcoes_fila1         fil1 on (red.id = fil1.redacao_id AND RED.ID_PROJETO = fil1.ID_PROJETO) UNION   
select red.id AS REDACAO_ID, fila = 2  , FILA_NOME = 'FILA 2'   , RED.ID_PROJETO from correcoes_redacao red join correcoes_fila2         fil2 on (red.id = fil2.redacao_id AND RED.ID_PROJETO = fil2.ID_PROJETO) UNION   
select red.id AS REDACAO_ID, fila = 3  , FILA_NOME = 'FILA 3'   , RED.ID_PROJETO from correcoes_redacao red join correcoes_fila3         fil3 on (red.id = fil3.redacao_id AND RED.ID_PROJETO = fil3.ID_PROJETO) UNION   
select red.id AS REDACAO_ID, fila = 4  , FILA_NOME = 'FILA 4'   , RED.ID_PROJETO from correcoes_redacao red join correcoes_fila4         fil4 on (red.id = fil4.redacao_id AND RED.ID_PROJETO = fil4.ID_PROJETO) UNION   
select red.id AS REDACAO_ID, fila = 7  , FILA_NOME = 'AUDITORIA', RED.ID_PROJETO from correcoes_redacao red join correcoes_filaauditoria fila on (red.id = fila.redacao_id AND RED.ID_PROJETO = fila.ID_PROJETO) UNION   
select red.id AS REDACAO_ID, fila = 10 , FILA_NOME = 'PESSOAL'  , RED.ID_PROJETO from correcoes_redacao red join correcoes_filapessoal   filp on (red.id = filp.redacao_id AND RED.ID_PROJETO = filp.ID_PROJETO) UNION   
select red.id AS REDACAO_ID, fila = 5  , FILA_NOME = 'OURO/MODA', RED.ID_PROJETO from correcoes_redacao red join correcoes_filaouro      filo on (red.id = filo.redacao_id AND RED.ID_PROJETO = filo.ID_PROJETO)  
  