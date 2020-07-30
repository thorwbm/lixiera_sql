-- exec sp_MSforeachtable @command1="DISABLE TRIGGER ALL On ?"
-- update projeto_projeto set codigo = '1810401'

-- create OR ALTER VIEW [dbo].[VW_N67_REDACAO_REFERENCIA_BANCA] AS 
SELECT distinct 
   ID_PROJETO = pro.codigo,
   ORIGEM     = 'F',
   CODPROVA   = RED.id_redacaoouro,   --######################
   CPF        = '33820018883',        --######################
   REFERENCIA = CASE WHEN LEFT(RED.CO_BARRA_REDACAO,3) = '001' THEN 2 
                     WHEN LEFT(RED.CO_BARRA_REDACAO,3) = '002' THEN 3 ELSE -1 END,
   --DATA       = ISNULL(DAT.DATA_CRIACAO,'2018-11-27'),
   SITUACAO   = OUR.id_correcao_situacao,
   NOTA_FINAL = OUR.nota_final,
   NOTA_COMP1 = OUR.nota_competencia1,
   NOTA_COMP2 = OUR.NOTA_competencia2,
   NOTA_COMP3 = OUR.NOTA_competencia3,
   NOTA_COMP4 = OUR.NOTA_competencia4,
   NOTA_COMP5 = OUR.NOTA_competencia5,
   ORIGEM_RED = CASE WHEN LEFT(RED.CO_BARRA_REDACAO,3) = '001' THEN 3 
                     WHEN LEFT(RED.CO_BARRA_REDACAO,3) = '002' THEN 1 ELSE -1 END,
   JUSTIFICATIVA = NULL, 
   DDH           = CASE WHEN OUR.ID_competencia5 = -1 THEN 1 
                        WHEN OUR.ID_competencia5 =  0 THEN 0 ELSE NULL END
                  
  FROM CORRECOES_REDACAO RED WITH (NOLOCK) JOIN projeto_projeto                      PRO WITH (NOLOCK) ON (PRO.ID = RED.id_projeto)
                                           JOIN CORRECOES_REDACAOOURO                OUR WITH (NOLOCK) ON (RED.id_redacaoouro = OUR.id)
									 -- LEFT JOIN entregas_regular..TMP_DATA_OURO_MODA DAT WITH (NOLOCK) ON (DAT.CO_BARRA_REDACAO = our.co_barra_redacao)
WHERE LEFT(RED.CO_BARRA_REDACAO,3) IN ('001','002')


GO 
-------------------------------------------------------------------------------------------------------------------------
-- REGISTROS GERAL
-------------------------------------------------------------------------------------------------------------------------
SELECT * 
  --INTO entregas_regular.dbo.N67_21122018_002  /* TABELA A SER CRIADA SEMPRE COM A DATA D - 1 */
 FROM VW_N67_REDACAO_REFERENCIA_BANCA VW WITH (NOLOCK) 
 WHERE NOT EXISTS (
		SELECT TOP 1 1 FROM entregas_regular.dbo.N67_18122018_002 TMP WITH (NOLOCK) /* TABELA DE REFERENCIA PARA COMPARACAO SEMPRE D -2*/
		 WHERE TMP.ID_PROJETO = VW.ID_PROJETO  AND 
		       TMP.ORIGEM     = VW.ORIGEM      AND
			   TMP.CODPROVA   = VW.CODPROVA    AND
			   TMP.REFERENCIA = VW.REFERENCIA  AND 
			   TMP.DATA       = VW.DATA        AND
			   TMP.SITUACAO   = VW.SITUACAO    AND 
			   TMP.NOTA_FINAL = VW.NOTA_FINAL  AND 
			   TMP.NOTA_COMP1 = VW.NOTA_COMP1  AND 
			   TMP.NOTA_COMP2 = VW.NOTA_COMP2  AND 
			   TMP.NOTA_COMP3 = VW.NOTA_COMP3  AND 
			   TMP.NOTA_COMP4 = VW.NOTA_COMP4  AND 
			   TMP.NOTA_COMP5 = VW.NOTA_COMP5  AND
			   TMP.ORIGEM_RED = VW.ORIGEM_RED  AND
               isnull(TMP.DDH, 100)        = isnull(VW.DDH, 100) 
         ) and 
		 NOT EXISTS (
		SELECT TOP 1 1 FROM entregas_regular.dbo.N67_19122018_002 TMP WITH (NOLOCK) /* TABELA DE REFERENCIA PARA COMPARACAO SEMPRE D -2*/
		 WHERE TMP.ID_PROJETO = VW.ID_PROJETO  AND 
		       TMP.ORIGEM     = VW.ORIGEM      AND
			   TMP.CODPROVA   = VW.CODPROVA    AND
			   TMP.REFERENCIA = VW.REFERENCIA  AND 
			   TMP.DATA       = VW.DATA        AND
			   TMP.SITUACAO   = VW.SITUACAO    AND 
			   TMP.NOTA_FINAL = VW.NOTA_FINAL  AND 
			   TMP.NOTA_COMP1 = VW.NOTA_COMP1  AND 
			   TMP.NOTA_COMP2 = VW.NOTA_COMP2  AND 
			   TMP.NOTA_COMP3 = VW.NOTA_COMP3  AND 
			   TMP.NOTA_COMP4 = VW.NOTA_COMP4  AND 
			   TMP.NOTA_COMP5 = VW.NOTA_COMP5  AND
			   TMP.ORIGEM_RED = VW.ORIGEM_RED  AND
               isnull(TMP.DDH, 100)        = isnull(VW.DDH, 100) 
         ) and 
		 NOT EXISTS (
		SELECT TOP 1 1 FROM entregas_regular.dbo.N67_20122018_002 TMP WITH (NOLOCK) /* TABELA DE REFERENCIA PARA COMPARACAO SEMPRE D -2*/
		 WHERE TMP.ID_PROJETO = VW.ID_PROJETO  AND 
		       TMP.ORIGEM     = VW.ORIGEM      AND
			   TMP.CODPROVA   = VW.CODPROVA    AND
			   TMP.REFERENCIA = VW.REFERENCIA  AND 
			   TMP.DATA       = VW.DATA        AND
			   TMP.SITUACAO   = VW.SITUACAO    AND 
			   TMP.NOTA_FINAL = VW.NOTA_FINAL  AND 
			   TMP.NOTA_COMP1 = VW.NOTA_COMP1  AND 
			   TMP.NOTA_COMP2 = VW.NOTA_COMP2  AND 
			   TMP.NOTA_COMP3 = VW.NOTA_COMP3  AND 
			   TMP.NOTA_COMP4 = VW.NOTA_COMP4  AND 
			   TMP.NOTA_COMP5 = VW.NOTA_COMP5  AND
			   TMP.ORIGEM_RED = VW.ORIGEM_RED  AND
               isnull(TMP.DDH, 100)        = isnull(VW.DDH, 100) 
         ) and 
		 NOT EXISTS (
		SELECT TOP 1 1 FROM entregas_regular.dbo.N67_21122018_002 TMP WITH (NOLOCK) /* TABELA DE REFERENCIA PARA COMPARACAO SEMPRE D -2*/
		 WHERE TMP.ID_PROJETO = VW.ID_PROJETO  AND 
		       TMP.ORIGEM     = VW.ORIGEM      AND
			   TMP.CODPROVA   = VW.CODPROVA    AND
			   TMP.REFERENCIA = VW.REFERENCIA  AND 
			   TMP.DATA       = VW.DATA        AND
			   TMP.SITUACAO   = VW.SITUACAO    AND 
			   TMP.NOTA_FINAL = VW.NOTA_FINAL  AND 
			   TMP.NOTA_COMP1 = VW.NOTA_COMP1  AND 
			   TMP.NOTA_COMP2 = VW.NOTA_COMP2  AND 
			   TMP.NOTA_COMP3 = VW.NOTA_COMP3  AND 
			   TMP.NOTA_COMP4 = VW.NOTA_COMP4  AND 
			   TMP.NOTA_COMP5 = VW.NOTA_COMP5  AND
			   TMP.ORIGEM_RED = VW.ORIGEM_RED  AND
               isnull(TMP.DDH, 100)        = isnull(VW.DDH, 100) 
         ) 


			   
			   



-------------------------------------------------------------------------------------------------------------------------
-- VALIDACOES
-------------------------------------------------------------------------------------------------------------------------

SELECT * FROM entregas_regular.dbo.N67_18122018_001
