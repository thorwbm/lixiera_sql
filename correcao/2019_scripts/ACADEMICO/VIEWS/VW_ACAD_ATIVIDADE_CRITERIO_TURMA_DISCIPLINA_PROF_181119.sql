USE [erp_prd]
GO

/****** Object:  View [dbo].[VW_ACAD_ATIVIDADE_CRITERIO_TURMA_DISCIPLINA_PROF]    Script Date: 18/11/2019 16:47:29 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/**********************************************************************************************************************************  
*                                       [VW_ACAD_ATIVIDADE_CRITERIO_TURMA_DISCIPLINA_PROF]                                        *  
*                                                                                                                                 *  
*  VIEW QUE AGRUPA AS INFORMACOES DAS TABELAS ATIVIDADE, CRITERIO, TURMA, DISCIPLINA, PROFESSOR                                   *  
*                                                                                                                                 *  
*                                                                                                                                 *  
* BANCO_SISTEMA : ACADEMICO                                                                                                       *  
* CRIADO POR    : WEMERSON BITTORI MADURO                                                                         DATA:02/10/2019 *  
* ALTERADO POR  : WEMERSON BITTORI MADURO                                                                         DATA:02/10/2019 *  
***********************************************************************************************************************************/  
  
CREATE OR ALTER VIEW [dbo].[VW_ACAD_ATIVIDADE_CRITERIO_TURMA_DISCIPLINA_PROF] AS   
WITH CTE_ATIVIDADE_CRITERIO_TURMA_DISCIPLINA_PROF AS (  
   SELECT DISTINCT    
    CUR.id AS curso_id, CUR.nome AS CURSO_NOME, 
    TURMA_ID = TUR.ID, TURMA_NOME = TUR.NOME, TUR.inicio_vigencia AS turma_inicio_vigencia, TUR.termino_vigencia as turma_termino_vigencia,   
    DISCIPLINA_ID = DIS.ID, DISCIPLINA_NOME = DIS.NOME,   
    PROFESSOR_ID = PRO.ID, PROFESSOR_NOME = PRO.NOME,   
    CRITERIO_ID = CRI.ID, CRITERIO_NOME = CRI.NOME, CRITERIO_VALOR = CRI.VALOR, CRITERIO_PESO = CRI.PESO,    
    ATIVIDADE_ID = ATV.id, ATIVIDADE_NOME = ATV.nome,   
    ATI_TUR_DIS_ID = ACT.id, ATI_TUR_DIS_INI_JANELA = ACT.inicio_janela_lancamento, ATI_TUR_DIS_TER_JANELA = ACT.termino_janela_lancamento,
	ACT.turma_disciplina_id as turmadisciplina_id   
   
     FROM  ATIVIDADES_ATIVIDADE ATV WITH(NOLOCK) JOIN atividades_criterio_turmadisciplina ACT WITH(NOLOCK) ON (ACT.id  = ATV.criterio_turma_disciplina_id)  
                                                 JOIN atividades_criterio                 CRI WITH(NOLOCK) ON (CRI.id  = ACT.criterio_id)  
                                                 JOIN academico_professor                 PRO WITH(NOLOCK) ON (PRO.id  = ACT.professor_id)  
                                                 JOIN academico_turmadisciplina           TRD WITH(NOLOCK) ON (TRD.id  = ACT.turma_disciplina_id)  
                                                 JOIN academico_turma                     TUR WITH(NOLOCK) ON (TUR.id  = TRD.turma_id)  
                                                 JOIN academico_disciplina                DIS WITH(NOLOCK) ON (DIS.id  = TRD.disciplina_id)  
												 JOIN academico_curso                     CUR WITH(NOLOCK) ON (CUR.id  = TUR.curso_id)
)  
  
 SELECT * FROM CTE_ATIVIDADE_CRITERIO_TURMA_DISCIPLINA_PROF
GO


