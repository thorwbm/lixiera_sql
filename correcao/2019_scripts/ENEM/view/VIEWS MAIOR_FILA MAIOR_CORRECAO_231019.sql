-- ********  VIEW QUE RETORNA QUAL O MAIOR NIVEL DE CORRECAO EXISTENTE PARA UMA REDACAO ***********************
CREATE OR ALTER VIEW VW_MAIOR_CORRECAO AS 
SELECT RED.ID AS REDACAO_ID, red.id_projeto, MAX(COR.ID_TIPO_CORRECAO) AS MAIOR_CORRECAO
  FROM correcoes_redacao RED JOIN correcoes_correcao COR ON (RED.id = COR.redacao_id)
  GROUP BY RED.ID, red.id_projeto
  GO 

-- ********************** VIEW QUE RETORNA A FILA MAIS ALTA QUE EXISTE PARA UMA REDACAO ***********************
CREATE OR ALTER VIEW VW_FILA_MAIS_ALTA  AS 
SELECT DISTINCT  RED.id AS REDACAO_ID, RED.id_projeto,  
       CASE WHEN FILPES.id IS NOT NULL THEN 10 -- PESSOAL
	        WHEN FILAUD.id IS NOT NULL THEN 7  -- AUDITORIA
	        WHEN FILOUR.id IS NOT NULL THEN 5  -- OURO MODA
	        WHEN FIL4.id   IS NOT NULL THEN 4  -- FILA 4
	        WHEN FIL3.id   IS NOT NULL THEN 3  -- FILA 3 
	        WHEN FIL2.id   IS NOT NULL THEN 2  -- FILA 2
	        WHEN FIL1.id   IS NOT NULL THEN 1  -- FILA 1
			ELSE 0 END AS FILA ,                -- NENHUMA FILA  
       CASE WHEN FILPES.id IS NOT NULL THEN 'PESSOAL'
	        WHEN FILAUD.id IS NOT NULL THEN 'AUDITORIA'
	        WHEN FILOUR.id IS NOT NULL THEN 'OURO MODA'
	        WHEN FIL4.id   IS NOT NULL THEN 'FILA 4'
	        WHEN FIL3.id   IS NOT NULL THEN 'FILA 3'
	        WHEN FIL2.id   IS NOT NULL THEN 'FILA 2'
	        WHEN FIL1.id   IS NOT NULL THEN 'FILA 1'
			ELSE 'NENHUMA FILA'  END AS FILA_NOME
  
  FROM correcoes_redacao RED LEFT JOIN correcoes_fila1         FIL1   ON (RED.id = FIL1  .redacao_id AND RED.id_projeto = FIL1  .id_projeto)
                             LEFT JOIN correcoes_fila2         FIL2   ON (RED.id = FIL2  .redacao_id AND RED.id_projeto = FIL2  .id_projeto)
                             LEFT JOIN correcoes_fila3         FIL3   ON (RED.id = FIL3  .redacao_id AND RED.id_projeto = FIL3  .id_projeto)
                             LEFT JOIN correcoes_fila4         FIL4   ON (RED.id = FIL4  .redacao_id AND RED.id_projeto = FIL4  .id_projeto)
                             LEFT JOIN correcoes_filaAUDITORIA FILAUD ON (RED.id = FILAUD.redacao_id AND RED.id_projeto = FILAUD.id_projeto)
                             LEFT JOIN correcoes_filaouro      FILOUR ON (RED.id = FILOUR.redacao_id AND RED.id_projeto = FILOUR.id_projeto)
                             LEFT JOIN correcoes_filapessoal   FILPES ON (RED.id = FILPES.redacao_id AND RED.id_projeto = FILPES.id_projeto)

