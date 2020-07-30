
 create OR ALTER VIEW [dbo].[VW_N67_REDACAO_REFERENCIA_BANCA] AS 
SELECT distinct 
   our.redacao_id, 
   our.id                 as redacaoouro_id, 
   CO_PROJETO             = pro.codigo,
   TP_ORIGEM              = 'F',
   NU_CPF                 = '33820018883',       
   CO_PROVA_OURO          = OUR.ID,   
   TP_REFERENCIA          = OUR.id_redacaotipo,
   DT_COMPLETA            = ISNULL(our.DATA_CRIACAO,'2019-11-27'),
   CO_SITUACAO_REDACAO    = OUR.id_correcao_situacao,
   VL_RESULTADO_AVALIADOR = OUR.nota_final,
   VL_NOTA_COMPETENCIA_1  = OUR.nota_competencia1,
   VL_NOTA_COMPETENCIA_2  = OUR.NOTA_competencia2,
   VL_NOTA_COMPETENCIA_3  = OUR.NOTA_competencia3,
   VL_NOTA_COMPETENCIA_4  = OUR.NOTA_competencia4,
   VL_NOTA_COMPETENCIA_5  = OUR.NOTA_competencia5,
   CO_ORIGEM_REDACAO      = our.id_origem,
   CO_JUSTIFICATIVA       = NULL, 
   IN_FERE_DH             = CASE WHEN OUR.ID_competencia5 = -1 THEN 1 
                                 WHEN OUR.ID_competencia5 =  0 THEN 0 ELSE NULL END
   FROM CORRECOES_REDACAOOURO OUR JOIN projeto_projeto PRO ON (OUR.id_projeto = PRO.ID)


GO 
-------------------------------------------------------------------------------------------------------------------------
-- REGISTROS GERAL
-------------------------------------------------------------------------------------------------------------------------
