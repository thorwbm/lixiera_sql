/****************************************************************************************************
*                            VW_TURMA_DISCIPLINA_ALUNO_CURRICULO_STATUS                             *
*                                                                                                   *
*  VIEW QUE APRESENTA AS INFORMACOES DE TURMA DISCIPLINA GRADE STATUS E ALUNO.                      *
*                                                                                                   *
*                                                                                                   *
* BANCO_SISTEMA : ERP_PRD                                                                           *
* CRIADO POR    : WEMERSON BITTORI MADURO                                           DATA:24/07/2020 *
* ALTERADO POR  : WEMERSON BITTORI MADURO                                           DATA:24/07/2020 *
****************************************************************************************************/

CREATE OR ALTER VIEW VW_TURMA_DISCIPLINA_ALUNO_CURRICULO_STATUS AS  
SELECT DISTINCT 
       TDS.ID AS TURMA_DISCIPLINA_ID, TUR.ID AS TURMA_ID, TUR.NOME AS TURMA_NOME, 
	   GRA.ID AS GRADE_ID, GRA.NOME AS GRADE_NOME,
	   CGD.disciplina_id,
       CRA.ALUNO_ID, CRA.curriculo_id, CRA.status_id, TDA.ID AS TURMA_DISCIPLINA_ALUNO_ID,
	   TDA.status_matricula_disciplina_id, TDA.curriculo_aluno_id
  FROM ACADEMICO_TURMADISCIPLINA TDS JOIN ACADEMICO_TURMA                TUR ON (TUR.ID = TDS.turma_id)  
                                     JOIN CURRICULOS_GRADE               GRA ON (GRA.ID = TUR.grade_id)  
                                     JOIN curriculos_gradedisciplina     CGD ON (GRA.ID = CGD.grade_id AND  
                                                                                 TDS.DISCIPLINA_ID = CGD.disciplina_id)  
                                     JOIN CURRICULOS_ALUNO               CRA ON (GRA.curriculo_id  = CRA.curriculo_id)  
                                LEFT JOIN ACADEMICO_TURMADISCIPLINAALUNO TDA ON (TDS.ID = TDA.turma_disciplina_id AND   
                                                                                 TDA.aluno_id = CRA.aluno_id)