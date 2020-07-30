CREATE OR ALTER view VW_FNC_DESCONTO_MAT_REM AS     
SELECT * FROM  REM_PRD..vw_desconto_REMATRICULA      
union     
SELECT * FROM  mat_PRD..vw_desconto_mATRICULA 