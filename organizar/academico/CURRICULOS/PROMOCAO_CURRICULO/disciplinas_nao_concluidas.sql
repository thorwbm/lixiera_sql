/****************************************************************************************************
*                                  VW_PRO_DISCIPLINA_NAO_CURSADA                                    *
*                                                                                                   *
*  VIEW QUE INFORMA AS DISCIPLINAS DE UM ALUNO QUE AINDA NAO FORAM CURSADAS - NAO EXISTEM NA        *
*  CURRICULOS_DISCIPLINACONCLUIDA E NAO ESTA SENDO CURSADA NA ACADEMICO_TURMADISCIPLINAALUNO.       *
*                                                                                                   *
* BANCO_SISTEMA : ERP_PRD                                                                           *
* CRIADO POR    : WEMERSON BITTORI MADURO                                           DATA:24/07/2020 *
* ALTERADO POR  : WEMERSON BITTORI MADURO                                           DATA:24/07/2020 *
****************************************************************************************************/

CREATE OR ALTER VIEW VW_PRO_DISCIPLINA_NAO_CURSADA AS 
WITH	CTE_DISCIPLINA_CURSADA_GRADE AS (
			SELECT  
			       CON.curriculo_aluno_id, CON.disciplina_id, CGD.CURRICULO_ID, CGD.CURRICULO_NOME, CGD.GRADE_NOME
              FROM 
			       vw_curriculos_grade_disciplina_ETAPA_ANO CGD JOIN curriculos_disciplinaconcluida CON ON (CON.disciplina_id = CGD.DISCIPLINA_ID AND 
                                                                                                            CON.etapa_ano_id  = CGD.ETAPA_ANO_ID)
)

			SELECT  cap.aluno_id, cap.curriculo_aluno_id, cap.curriculo_id, cgd.disciplina_id, cap.curso_id, cgd.grade_id, cgd.grade_nome
			  FROM vw_Curriculo_aluno_pessoa cap JOIN vw_curriculos_grade_disciplina cgd ON (cgd.curriculo_id = cap.curriculo_id )	
			                                LEFT JOIN CTE_DISCIPLINA_CURSADA_GRADE   cdc ON (cdc.curriculo_aluno_id = cap.curriculo_aluno_id AND
											                                                 cdc.disciplina_id = cgd.disciplina_id)
			 WHERE cdc.curriculo_aluno_id IS NULL 


