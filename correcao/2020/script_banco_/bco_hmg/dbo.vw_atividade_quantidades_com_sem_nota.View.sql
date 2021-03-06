USE [erp_hmg]
GO
/****** Object:  View [dbo].[vw_atividade_quantidades_com_sem_nota]    Script Date: 12/02/2020 15:40:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 CREATE view [dbo].[vw_atividade_quantidades_com_sem_nota] as   
WITH CTE_ATIVIDADES AS (  
  SELECT ATI.id AS ATIVIDADE_ID, ATI.nome AS ATIVIDADE_NOME, valor AS ATIVIDADE_VALOR, data_divulgacao_notas AS ATIVIDADE_DATA_DIVULGACAO,   
         DATA AS ATIVIDADE_DATA,  
      STA.id AS STATUS_ATIVIDADE_ID, STA.nome AS STATUS_ATIVIDADE_NOME , 	  ati.criterio_turma_disciplina_id 
    FROM atividades_atividade ATI JOIN ATIVIDADES_STATUS STA ON (STA.ID = ATI.status_id)  
),   
    CTE_ATIVIDADE_ALUNOS_COM_NOTA_QTD AS (  
  SELECT atividade_id, QTD_COM_NOTA = COUNT (ALUNO_ID)  
       FROM atividades_atividade_aluno  
   WHERE nota IS NOT NULL   
    GROUP BY ATIVIDADE_ID  
)   
--   , CTE_ATIVIDADE_ALUNOS_SEM_NOTA_QTD AS (  
--  SELECT atividade_id, QTD_SEM_NOTA = COUNT (ALUNO_ID)  
--       FROM atividades_atividade_aluno  
--   WHERE nota IS NULL   
--    GROUP BY ATIVIDADE_ID  
--)  
  
    SELECT  ATI.*, COM_NOTA = ISNULL(COM.QTD_COM_NOTA,0)--, SEM_NOTA = ISNULL(SEM.QTD_SEM_NOTA,0)  
  FROM CTE_ATIVIDADES ATI LEFT JOIN CTE_ATIVIDADE_ALUNOS_COM_NOTA_QTD COM ON (ATI.ATIVIDADE_ID = COM.atividade_id)  
                                --  LEFT JOIN CTE_ATIVIDADE_ALUNOS_SEM_NOTA_QTD SEM ON (ATI.ATIVIDADE_ID = SEM.atividade_id)  
  
 
GO
