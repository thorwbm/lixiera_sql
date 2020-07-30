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

CREATE VIEW VW_ACAD_ATIVIDADE_CRITERIO_TURMA_DISCIPLINA_PROF AS 
WITH CTE_ATIVIDADE_CRITERIO_TURMA_DISCIPLINA_PROF AS (
		 SELECT DISTINCT  
				TURMA_ID = TUR.ID, TURMA_NOME = TUR.NOME, 
				DISCIPLINA_ID = DIS.ID, DISCIPLINA_NOME = DIS.NOME, 
				PROFESSOR_ID = PRO.ID, PROFESSOR_NOME = PRO.NOME, 
				CRITERIO_ID = CRI.ID, CRITERIO_NOME = CRI.NOME, CRITERIO_VALOR = CRI.VALOR, CRITERIO_PESO = CRI.PESO,  
				ATIVIDADE_ID = ATV.id, ATIVIDADE_NOME = ATV.nome, 
				ATIV_TUR_DIS_ID = ACT.id, ATIV_TUR_DIS_INI_JANELA = ACT.inicio_janela_lancamento, ATIV_TUR_DIS_TER_JANELA = ACT.termino_janela_lancamento 
 
		   FROM  ATIVIDADES_ATIVIDADE ATV WITH(NOLOCK) JOIN atividades_criterio_turmadisciplina ACT WITH(NOLOCK) ON (ACT.id  = ATV.criterio_turma_disciplina_id)
													   JOIN atividades_criterio                 CRI WITH(NOLOCK) ON (CRI.id  = ACT.criterio_id)
													   JOIN academico_professor                 PRO WITH(NOLOCK) ON (PRO.id  = ACT.professor_id)
													   JOIN academico_turmadisciplina           TRD WITH(NOLOCK) ON (TRD.id  = ACT.turma_disciplina_id)
													   JOIN academico_turma                     TUR WITH(NOLOCK) ON (TUR.id  = TRD.turma_id)
													   JOIN academico_disciplina                DIS WITH(NOLOCK) ON (DIS.id  = TRD.disciplina_id)
)

	SELECT * FROM CTE_ATIVIDADE_CRITERIO_TURMA_DISCIPLINA_PROF