
create or ALTER VIEW [dbo].[VW_N68_REDACAO_REFERENCIA_AVALIADORES] AS 
SELECT 
   CO_PROJETO            = PRO.CODIGO,
   TP_ORIGEM             = 'F',
   CO_PROVA_OURO         = RED.id_redacaoouro,
   NU_CPF                = pes.cpf,
   TP_REFERENCIA         = CASE WHEN LEFT(RED.CO_BARRA_REDACAO,3) = '001' THEN 2 
                                WHEN LEFT(RED.CO_BARRA_REDACAO,3) = '002' THEN 3 ELSE -1 END,
   DT_INICIO             = COR.data_inicio,
   DT_FIM                = COR.data_termino,
   CO_SITUACAO_REDACAO   = COR.id_correcao_situacao,
   NU_NOTA_REDACAO       = COR.nota_final,
   NU_NOTA_COMP1_REDACAO = COR.nota_competencia1,
   NU_NOTA_COMP2_REDACAO = COR.nota_competencia2,
   NU_NOTA_COMP3_REDACAO = COR.nota_competencia3,
   NU_NOTA_COMP4_REDACAO = COR.nota_competencia4,
   NU_NOTA_COMP5_REDACAO = COR.nota_competencia5,
   CO_JUSTIFICATIVA      = NULL, 
   CORRECAO_ID           = COR.ID
                  
  FROM CORRECOES_REDACAO RED JOIN projeto_projeto    PRO ON (PRO.ID = RED.id_projeto)
                             JOIN CORRECOES_CORRECAO COR ON (RED.ID = COR.REDACAO_ID)
                             JOIN usuarios_pessoa    pes ON (COR.id_corretor = pes.usuario_id)

WHERE LEFT(RED.CO_BARRA_REDACAO,3) IN ('001','002') and 
      cor.id_status = 3
GO

-------------------------------------------------------------------------------------------------------------------------
-- VALIDACAO
-------------------------------------------------------------------------------------------------------------------------
/* VALIDACAO NOTAS E COMPETENCIAS */
SELECT * FROM VW_N68_REDACAO_REFERENCIA_AVALIADORES
  WHERE NU_NOTA_REDACAO <> NU_NOTA_COMP1_REDACAO + NU_NOTA_COMP2_REDACAO + NU_NOTA_COMP3_REDACAO + NU_NOTA_COMP4_REDACAO + NU_NOTA_COMP5_REDACAO 

SELECT * FROM VW_N68_REDACAO_REFERENCIA_AVALIADORES
  WHERE NU_NOTA_REDACAO <> 0 AND SITUACAO <> 1 

/* VALIDACAO NOTA_FINAIS NA REDACAO */
SELECT RED.NU_NOTA_REDACAO, VW.NU_NOTA_REDACAO, RED.co_barra_redacao
  FROM CORRECOES_REDACAO RED WITH (NOLOCK) JOIN VW_N68_REDACAO_REFERENCIA_AVALIADORES VW WITH (NOLOCK) ON (RED.co_barra_redacao = VW.co_barra_redacao)
 WHERE RED.NU_NOTA_REDACAO <> VW.NU_NOTA_REDACAO

 
/* VALIDACAO APENAS UMA CORRECAO POR CORRETOR */
SELECT CPF,CO_BARRA_REDACAO, COUNT(*) FROM  VW_N68_REDACAO_REFERENCIA_AVALIADORES VW WITH (NOLOCK) 
GROUP BY CPF, CO_BARRA_REDACAO
HAVING COUNT(*) > 1
-------------------------------------------------------------------------------------------------------------------------
-- REGISTROS GERAL - SEM AS QUE FORAM DISTRIBUIDAS NA FILA UM 
-- OBS. REDACOES OURO QUER FORAM INSERIDAS INDEVIDADMENTE NA FILA UM 
-------------------------------------------------------------------------------------------------------------------------
SELECT DISTINCT ID_PROJETO, ORIGEM, CODPROVA, CPF, REFERENCIA, INICIO, TERMINO, SITUACAO, NU_NOTA_REDACAO, NOTA_COMP1, NOTA_COMP2, NOTA_COMP3, NOTA_COMP4, NU_NOTA_COMP5_REDACAO 
          INTO entregas_regular.dbo.N68_29122018_001 
FROM VW_N68_REDACAO_REFERENCIA_AVALIADORES
WHERE co_barra_redacao NOT IN 
(SELECT  RED.co_barra_redacao
  FROM CORRECOES_REDACAO RED WITH (NOLOCK) JOIN VW_N68_REDACAO_REFERENCIA_AVALIADORES VW WITH (NOLOCK) ON (RED.co_barra_redacao = VW.co_barra_redacao)
 WHERE RED.NU_NOTA_REDACAO <> VW.NU_NOTA_REDACAO)


 -------------------------------------------------------------------------------------------------------------------------
-- REGISTROS 
-- OBS. REDACOES OURO QUER FORAM INSERIDAS INDEVIDADMENTE NA FILA UM 
-------------------------------------------------------------------------------------------------------------------------
SELECT DISTINCT ID_PROJETO, ORIGEM, CODPROVA, CPF, REFERENCIA, INICIO, TERMINO, SITUACAO, NU_NOTA_REDACAO, NOTA_COMP1, NOTA_COMP2, NOTA_COMP3, NOTA_COMP4, NU_NOTA_COMP5_REDACAO 
        --   INTO entregas_regular.dbo.N68_21122018_002
FROM VW_N68_REDACAO_REFERENCIA_AVALIADORES
WHERE co_barra_redacao  IN 
(SELECT  RED.co_barra_redacao
  FROM CORRECOES_REDACAO RED WITH (NOLOCK) JOIN VW_N68_REDACAO_REFERENCIA_AVALIADORES VW WITH (NOLOCK) ON (RED.co_barra_redacao = VW.co_barra_redacao)
 WHERE RED.NU_NOTA_REDACAO <> VW.NU_NOTA_REDACAO)


 --- select * from drop table entregas_regular.dbo.N68_18122018_001 