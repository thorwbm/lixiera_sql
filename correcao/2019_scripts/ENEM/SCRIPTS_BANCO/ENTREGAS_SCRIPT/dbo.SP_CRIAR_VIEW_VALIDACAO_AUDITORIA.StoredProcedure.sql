/****** Object:  StoredProcedure [dbo].[SP_CRIAR_VIEW_VALIDACAO_AUDITORIA]    Script Date: 26/12/2019 13:14:39 ******/
DROP PROCEDURE IF EXISTS [dbo].[SP_CRIAR_VIEW_VALIDACAO_AUDITORIA]
GO
/****** Object:  StoredProcedure [dbo].[SP_CRIAR_VIEW_VALIDACAO_AUDITORIA]    Script Date: 26/12/2019 13:14:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- EXEC SP_CRIAR_VIEW_VALIDACAO_AUDITORIA '20191223'
CREATE   PROCEDURE [dbo].[SP_CRIAR_VIEW_VALIDACAO_AUDITORIA] @ESQUEMA VARCHAR(100) AS 

DECLARE @SQL1 NVARCHAR(MAX)
DECLARE @SQL2 NVARCHAR(MAX) 
DECLARE @SQL3 NVARCHAR(MAX) 
DECLARE @SQL4 NVARCHAR(MAX) 

SET @SQL1 = N'
create OR ALTER view [' + @ESQUEMA + '].[vw_validacao_auditoria] as 
WITH CTE_VALIDACAO_AUDITORIA AS (
		SELECT RED.ID AS REDACAO_ID, TPA.descricao AS TIPO_AUDITORIA, RED.id_projeto AS PROJETO_ID, 
			   COR1.ID AS CORRECAO1, 
			   COR2.ID AS CORRECAO2, 
			   COR3.ID AS CORRECAO3, 
			   COR4.ID AS CORRECAO4, 
			   COR5.ID AS CORRECAO5, 
			   COR6.ID AS CORRECAO6, 
			   COR7.ID AS CORRECAO7,
	   
			   CASE WHEN ISNULL(COR1.NOTA_FINAL,0) = 1000 THEN 1 ELSE 0 END  AS NOTA_FINAL_1, 
			   CASE WHEN ISNULL(COR2.NOTA_FINAL,0) = 1000 THEN 1 ELSE 0 END  AS NOTA_FINAL_2, 
			   CASE WHEN ISNULL(COR3.NOTA_FINAL,0) = 1000 THEN 1 ELSE 0 END  AS NOTA_FINAL_3, 
			   CASE WHEN ISNULL(COR4.NOTA_FINAL,0) = 1000 THEN 1 ELSE 0 END  AS NOTA_FINAL_4, 
			   CASE WHEN ISNULL(COR5.NOTA_FINAL,0) = 1000 THEN 1 ELSE 0 END  AS NOTA_FINAL_5, 
			   CASE WHEN ISNULL(COR6.NOTA_FINAL,0) = 1000 THEN 1 ELSE 0 END  AS NOTA_FINAL_6, 
			   CASE WHEN ISNULL(COR7.NOTA_FINAL,0) = 1000 THEN 1 ELSE 0 END  AS NOTA_FINAL_7,
	   
			   CASE WHEN COR1.competencia5 = -1 THEN ' + CHAR(39) + 'DDH' + CHAR(39) + ' ELSE ' + CHAR(39) + 'NORMAL' + CHAR(39) + ' END AS DDH_1, 
			   CASE WHEN COR2.competencia5 = -1 THEN ' + CHAR(39) + 'DDH' + CHAR(39) + ' ELSE ' + CHAR(39) + 'NORMAL' + CHAR(39) + ' END AS DDH_2, 
			   CASE WHEN COR3.competencia5 = -1 THEN ' + CHAR(39) + 'DDH' + CHAR(39) + ' ELSE ' + CHAR(39) + 'NORMAL' + CHAR(39) + ' END AS DDH_3, 
			   CASE WHEN COR4.competencia5 = -1 THEN ' + CHAR(39) + 'DDH' + CHAR(39) + ' ELSE ' + CHAR(39) + 'NORMAL' + CHAR(39) + ' END AS DDH_4, 
			   CASE WHEN COR5.competencia5 = -1 THEN ' + CHAR(39) + 'DDH' + CHAR(39) + ' ELSE ' + CHAR(39) + 'NORMAL' + CHAR(39) + ' END AS DDH_5, 
			   CASE WHEN COR6.competencia5 = -1 THEN ' + CHAR(39) + 'DDH' + CHAR(39) + ' ELSE ' + CHAR(39) + 'NORMAL' + CHAR(39) + ' END AS DDH_6, 
			   CASE WHEN COR7.competencia5 = -1 THEN ' + CHAR(39) + 'DDH' + CHAR(39) + ' ELSE ' + CHAR(39) + 'NORMAL' + CHAR(39) + ' END AS DDH_7,
	   
			   CASE WHEN COR1.id_correcao_situacao = 9 THEN ' + CHAR(39) + 'PD' + CHAR(39) + ' ELSE ' + CHAR(39) + 'NORMAL' + CHAR(39) + ' END AS PD_1, 
			   CASE WHEN COR2.id_correcao_situacao = 9 THEN ' + CHAR(39) + 'PD' + CHAR(39) + ' ELSE ' + CHAR(39) + 'NORMAL' + CHAR(39) + ' END AS PD_2, 
			   CASE WHEN COR3.id_correcao_situacao = 9 THEN ' + CHAR(39) + 'PD' + CHAR(39) + ' ELSE ' + CHAR(39) + 'NORMAL' + CHAR(39) + ' END AS PD_3, 
			   CASE WHEN COR4.id_correcao_situacao = 9 THEN ' + CHAR(39) + 'PD' + CHAR(39) + ' ELSE ' + CHAR(39) + 'NORMAL' + CHAR(39) + ' END AS PD_4, 
			   CASE WHEN COR5.id_correcao_situacao = 9 THEN ' + CHAR(39) + 'PD' + CHAR(39) + ' ELSE ' + CHAR(39) + 'NORMAL' + CHAR(39) + ' END AS PD_5, 
			   CASE WHEN COR6.id_correcao_situacao = 9 THEN ' + CHAR(39) + 'PD' + CHAR(39) + ' ELSE ' + CHAR(39) + 'NORMAL' + CHAR(39) + ' END AS PD_6, 
			   CASE WHEN COR7.id_correcao_situacao = 9 THEN ' + CHAR(39) + 'PD' + CHAR(39) + ' ELSE ' + CHAR(39) + 'NORMAL' + CHAR(39) + ' END AS PD_7

		  FROM [' + @ESQUEMA + '].CORRECOES_REDACAO RED JOIN [' + @ESQUEMA + '].CORRECOES_CORRECAO      COR7  ON (RED.ID = COR7.REDACAO_ID AND COR7.ID_TIPO_CORRECAO = 7 AND COR7.id_status = 3)
		                                                JOIN [' + @ESQUEMA + '].CORRECOES_CORRECAO      COR1  ON (RED.ID = COR1.REDACAO_ID AND COR1.ID_TIPO_CORRECAO = 1 AND COR1.id_status = 3)
												        JOIN [' + @ESQUEMA + '].CORRECOES_CORRECAO      COR2  ON (RED.ID = COR2.REDACAO_ID AND COR2.ID_TIPO_CORRECAO = 2 AND COR2.id_status = 3)
													    JOIN                    CORRECOES_TIPOAUDITORIA TPA   ON (TPA.ID = COR7.tipo_auditoria_id)
												   LEFT JOIN [' + @ESQUEMA + '].CORRECOES_CORRECAO      COR3  ON (RED.ID = COR3.REDACAO_ID AND COR3.ID_TIPO_CORRECAO = 3 AND COR3.id_status = 3)
												   LEFT JOIN [' + @ESQUEMA + '].CORRECOES_CORRECAO      COR4  ON (RED.ID = COR4.REDACAO_ID AND COR4.ID_TIPO_CORRECAO = 4 AND COR4.id_status = 3)
												   LEFT JOIN [' + @ESQUEMA + '].CORRECOES_CORRECAO      COR5  ON (RED.ID = COR5.REDACAO_ID AND COR5.ID_TIPO_CORRECAO = 5 AND COR5.id_status = 3)
												   LEFT JOIN [' + @ESQUEMA + '].CORRECOES_CORRECAO      COR6  ON (RED.ID = COR6.REDACAO_ID AND COR6.ID_TIPO_CORRECAO = 6 AND COR6.id_status = 3)
)'

SET @SQL2 = N'
	SELECT REDACAO_ID, PROJETO_ID, TIPO_AUDITORIA 
	  FROM CTE_VALIDACAO_AUDITORIA 
	  WHERE (TIPO_AUDITORIA = ' + CHAR(39) + 'N. MÁXIMA' + CHAR(39) + ' AND 
				 (	(NOTA_FINAL_1 = 0  AND NOTA_FINAL_2 = 0  AND NOTA_FINAL_3 = 0  AND NOTA_FINAL_4 = 0) AND
				    (NOTA_FINAL_1 = 0  AND NOTA_FINAL_2 = 0  AND NOTA_FINAL_3 = 1  AND NOTA_FINAL_4 = 0) AND  
				    (NOTA_FINAL_1 = 0  AND NOTA_FINAL_2 = 1  AND NOTA_FINAL_3 = 0  AND NOTA_FINAL_4 = 0) AND  
				    (NOTA_FINAL_1 = 0  AND NOTA_FINAL_2 = 1  AND NOTA_FINAL_3 = 1  AND NOTA_FINAL_4 = 1) AND   
				    (NOTA_FINAL_1 = 1  AND NOTA_FINAL_2 = 0  AND NOTA_FINAL_3 = 0  AND NOTA_FINAL_4 = 1) AND  
				    (NOTA_FINAL_1 = 1  AND NOTA_FINAL_2 = 0  AND NOTA_FINAL_3 = 1  AND NOTA_FINAL_4 = 0) AND  
				    (NOTA_FINAL_1 = 1  AND NOTA_FINAL_2 = 1  AND NOTA_FINAL_3 = 0  AND NOTA_FINAL_4 = 1) AND  
				    (NOTA_FINAL_1 = 1  AND NOTA_FINAL_2 = 1  AND NOTA_FINAL_3 = 1  AND NOTA_FINAL_4 = 0) AND  
				    (NOTA_FINAL_1 = 1  AND NOTA_FINAL_2 = 1  AND NOTA_FINAL_3 = 1  AND NOTA_FINAL_4 = 1)   
				)	 
	        )  OR '
	
SET @SQL3 = N'
			(TIPO_AUDITORIA   = ' + CHAR(39) + 'PD' + CHAR(39) + ' AND 
				NOT (	(PD_1 = ' + CHAR(39) + 'NORMAL' + CHAR(39) + ' AND PD_2 = ' + CHAR(39) + 'NORMAL' + CHAR(39) + ' AND PD_3 = ' + CHAR(39) + 'NORMAL' + CHAR(39) + ' AND PD_4 = ' + CHAR(39) + 'PD' + CHAR(39) + '    ) OR 
				        (PD_1 = ' + CHAR(39) + 'NORMAL' + CHAR(39) + ' AND PD_2 = ' + CHAR(39) + 'NORMAL' + CHAR(39) + ' AND PD_3 = ' + CHAR(39) + 'PD'     + CHAR(39) + ' AND PD_4 = ' + CHAR(39) + 'NORMAL' + CHAR(39) + ') OR   
				        (PD_1 = ' + CHAR(39) + 'NORMAL' + CHAR(39) + ' AND PD_2 = ' + CHAR(39) + 'PD'     + CHAR(39) + ' AND PD_3 = ' + CHAR(39) + 'NORMAL' + CHAR(39) + ' AND PD_4 = ' + CHAR(39) + 'NORMAL' + CHAR(39) + ') OR    
				        (PD_1 = ' + CHAR(39) + 'PD'     + CHAR(39) + ' AND PD_2 = ' + CHAR(39) + 'NORMAL' + CHAR(39) + ' AND PD_3 = ' + CHAR(39) + 'NORMAL' + CHAR(39) + ' AND PD_4 = ' + CHAR(39) + 'NORMAL' + CHAR(39) + ') OR   
				        (PD_1 = ' + CHAR(39) + 'PD'     + CHAR(39) + ' AND PD_2 = ' + CHAR(39) + 'PD'     + CHAR(39) + ' AND PD_3 = ' + CHAR(39) + 'NORMAL' + CHAR(39) + ' AND PD_4 = ' + CHAR(39) + 'NORMAL' + CHAR(39) + ')				     
				)
			) OR '

SET @SQL4 = N'
			(TIPO_AUDITORIA = ' + CHAR(39) + 'DDH' + CHAR(39) + ' AND 
				NOT	(	(DDH_1 = ' + CHAR(39) + 'NORMAL' + CHAR(39) + ' AND DDH_2 = ' + CHAR(39) + 'NORMAL' + CHAR(39) + ' AND DDH_3 = ' + CHAR(39) + 'NORMAL' + CHAR(39) + ' AND DDH_4 = ' + CHAR(39) + 'DDH' + CHAR(39) + ') OR 
				        (DDH_1 = ' + CHAR(39) + 'NORMAL' + CHAR(39) + ' AND DDH_2 = ' + CHAR(39) + 'NORMAL' + CHAR(39) + ' AND DDH_3 = ' + CHAR(39) + 'DDH'    + CHAR(39) + ' AND DDH_4 = ' + CHAR(39) + 'NORMAL' + CHAR(39) + ') OR   
				        (DDH_1 = ' + CHAR(39) + 'NORMAL' + CHAR(39) + ' AND DDH_2 = ' + CHAR(39) + 'DDH'    + CHAR(39) + ' AND DDH_3 = ' + CHAR(39) + 'NORMAL' + CHAR(39) + ' AND DDH_4 = ' + CHAR(39) + 'NORMAL' + CHAR(39) + ') OR    
				        (DDH_1 = ' + CHAR(39) + 'DDH'    + CHAR(39) + ' AND DDH_2 = ' + CHAR(39) + 'NORMAL' + CHAR(39) + ' AND DDH_3 = ' + CHAR(39) + 'NORMAL' + CHAR(39) + ' AND DDH_4 = ' + CHAR(39) + 'NORMAL' + CHAR(39) + ') OR   
				        (DDH_1 = ' + CHAR(39) + 'DDH'    + CHAR(39) + ' AND DDH_2 = ' + CHAR(39) + 'DDH'    + CHAR(39) + ' AND DDH_3 = ' + CHAR(39) + 'NORMAL' + CHAR(39) + ' AND DDH_4 = ' + CHAR(39) + 'NORMAL' + CHAR(39) + ')				     
				)
			)
'

EXEC (@SQL1 + @SQL2 + @SQL3 + @SQL4)
GO
