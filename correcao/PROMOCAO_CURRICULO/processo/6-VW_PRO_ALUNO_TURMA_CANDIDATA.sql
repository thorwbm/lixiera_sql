/****************************************************************************************************  
*                                   VW_PRO_ALUNO_TURMA_CANDIDATA                                    *  
*                                                                                                   *  
*  VIEW QUE RELACIONA A TURMA COM MAIOR OCORRENCIA PARA UM ALUNO EM UM ANO SEMESTRE.                *  
*                                                                                                   *  
*                                                                                                   *  
* BANCO_SISTEMA : ERP_PRD                                                                           *  
* CRIADO POR    : WEMERSON BITTORI MADURO                                           DATA:23/07/2020 *  
* ALTERADO POR  : WEMERSON BITTORI MADURO                                           DATA:23/07/2020 *  
****************************************************************************************************/  
  
CREATE OR ALTER VIEW [dbo].[VW_PRO_ALUNO_TURMA_CANDIDATA] AS       
WITH CTE_TURMA_ALUNO_ANO_SEMESTRE AS (      
       SELECT   
           TDA.ALUNO_ID, CRA.ID AS CURRICULO_ALUNO_ID, TUR.ID AS TURMA_ID,       
              YEAR(TUR.inicio_vigencia) AS ANO,   
        CASE WHEN MONTH(TUR.inicio_vigencia) <7 THEN 1 ELSE 2 END AS SEMESTRE,       
              COUNT(TDA.ID) AS QTD_TURMA      
         FROM academico_turmadisciplinaaluno TDA JOIN ACADEMICO_TURMADISCIPLINA TDS ON (TDS.ID = TDA.TURMA_DISCIPLINA_ID)      
                                                 JOIN ACADEMICO_TURMA           TUR ON (TUR.ID = TDS.TURMA_ID)      
                                                 JOIN CURRICULOS_ALUNO          CRA ON (CRA.ALUNO_ID = TDA.ALUNO_ID AND      
                                                                                        CRA.STATUS_ID = 13)      
        WHERE        
              TDA.STATUS_MATRICULA_DISCIPLINA_ID IN  (1,6,7,9) AND      
			  TUR.categoria_id = 1 and
              TUR.turma_pai_id IS NULL       
        GROUP BY   
        TDA.ALUNO_ID, CRA.ID, TUR.ID, YEAR(TUR.inicio_vigencia),   
           CASE WHEN MONTH(TUR.inicio_vigencia) <7 THEN 1 ELSE 2 END      
)      
      
 , CTE_QTD_MAIOR_TURMA AS (      
		SELECT   
			   ALUNO_ID, ctE.CURRICULO_ALUNO_ID, CTE.ANO, CTE.SEMESTRE, MAX(QTD_TURMA) AS QTD      
	      FROM   
			   CTE_TURMA_ALUNO_ANO_SEMESTRE ctE       
	     GROUP BY   
			   ALUNO_ID, ctE.CURRICULO_ALUNO_ID,  CTE.ANO, CTE.SEMESTRE      
)      
      
       SELECT   
              CTE.ALUNO_ID, CTE.CURRICULO_ALUNO_ID, CTE.ANO, CTE.SEMESTRE,   
              TUR.ID AS TURMA_ID, TUR.NOME AS TURMA_NOME,    
              DST.ID AS TURMA_DESTINO_ID, DST.NOME AS TURMA_DESTINO_NOME,   
              GRA.id AS GRADE_DESTINO_ID,  GRA.NOME AS GRADE_DESTINO_NOME  
         FROM   
              CTE_TURMA_ALUNO_ANO_SEMESTRE ctE JOIN ACADEMICO_TURMA     TUR ON (TUR.ID = CTE.TURMA_ID)      
                                               JOIN CTE_QTD_MAIOR_TURMA MAI ON (CTE.ALUNO_ID = MAI.ALUNO_ID AND      
                                                                                CTE.CURRICULO_ALUNO_ID = MAI.CURRICULO_ALUNO_ID AND      
                                                                                CTE.ANO = MAI.ANO AND      
                                                                                CTE.SEMESTRE = MAI.SEMESTRE AND      
                                                                                CTE.QTD_TURMA = MAI.QTD)      
                                          left join ACADEMICO_TURMA     DST ON (DST.turma_origem_rematricula_id = TUR.ID)  
                                          LEFT JOIN CURRICULOS_GRADE    GRA ON (GRA.ID = DST.grade_id)
