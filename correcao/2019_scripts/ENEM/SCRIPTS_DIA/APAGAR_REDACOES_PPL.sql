-- **** REMOVER OCORRENCIAS_OCORRENCIA *****
SELECT * 
--  DELETE 
FROM OCORRENCIAS_OCORRENCIA WHERE id IN (
select oco.id 
-- SELECT OCO.* INTO TMP_ocorrencias_ocorrencia_REDACOES_REMOVER
 from ocorrencias_ocorrencia oco join correcoes_correcao   COR ON (oco.correcao_id = COR.ID)
                                 JOIN tmp_redacoes_remover tmp on (COR.redacao_id = TMP.ID)
) 



-- **** REMOVER CORRECOES_HISTORICOCORRECAO *****
SELECT * 
--  DELETE 
FROM CORRECOES_HISTORICOCORRECAO WHERE id IN (
select HIS.ID 
-- SELECT HIS.* INTO TMP_correcoes_historicocorrecao_REDACOES_REMOVER
 from CORRECOES_HISTORICOCORRECAO HIS join correcoes_correcao   COR ON (HIS.correcao_id = COR.ID)
                                 JOIN tmp_redacoes_remover      tmp on (COR.redacao_id = TMP.ID)			 
) 


-- **** REMOVER CORRECOES_CORRECAO ****
SELECT * 
-- DELETE 
FROM correcoes_correcao WHERE id IN (
SELECT cor.ID
-- SELECT COR.* INTO TMP_CORRECOES_CORRECAO_REDACOES_REMOVER
  FROM CORRECOES_CORRECAO COR JOIN  tmp_redacoes_remover tmp on (COR.redacao_id = TMP.ID)
)

     
-- **** REMOVER CORRECOES_REDACAO ****
SELECT * 
-- DELETE 
FROM CORRECOES_REDACAO WHERE id IN (
SELECT RED.ID
-- SELECT RED.* INTO TMP_correcoes_redacao_REDACOES_REMOVER
  FROM CORRECOES_REDACAO RED JOIN  tmp_redacoes_remover tmp on (RED.ID = TMP.ID)
)
