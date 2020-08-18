/****************************************************************************************************
*                                 VW_PRO_ALUNO_DISCIPLINA_ENTURMAR                                  *
*                                                                                                   *
*  VIEW QUE APRESENTA OS ALUNOS E AS DISCIPLINAS NAS QUAIS ELE DEVERA SER ENTURMADO.                *
*                                                                                                   *
*                                                                                                   *
* BANCO_SISTEMA : ERP_PRD                                                                           *
* CRIADO POR    : WEMERSON BITTORI MADURO                                           DATA:24/07/2020 *
* ALTERADO POR  : WEMERSON BITTORI MADURO                                           DATA:24/07/2020 *
****************************************************************************************************/


CREATE   VIEW [dbo].[VW_PRO_ALUNO_DISCIPLINA_ENTURMAR] AS       
WITH cte_turma_disciplina_aluno_cursando AS (      
   SELECT       
          tda.curriculo_aluno_id, tds.disciplina_id, tds.turma_id, gde.disciplina_equivalente_id, cra.curriculo_id, tda.aluno_id      
     FROM       
          academico_turmadisciplinaaluno tda JOIN academico_turmadisciplina     tds ON (tds.id = tda.turma_disciplina_id)      
                                             JOIN curriculos_aluno              cra ON (cra.id = tda.curriculo_aluno_id)      
                                        LEFT JOIN vw_gradedisciplinaequivalente gde ON (gde.curriculo_id = cra.curriculo_id AND      
                                                                                        gde.disciplina_equivalente_id = tds.disciplina_id)      
    WHERE       
          tda.status_matricula_disciplina_id = 1      
)      
      
   SELECT distinct       
          alu.ALUNO_ID, alu.ALUNO_NOME, alu.CURRICULO_ID, alu.CURRICULO_NOME,  ATC.GRADE_DESTINO_NOME AS DESTINO, alu.curriculo_aluno_id,      
          ncs.disciplina_id, ncs.curso_id, ncs.grade_id, ncs.grade_nome   
    FROM       
         vw_pro_relacao_alunos alu join VW_PRO_ALUNO_TURMA_CANDIDATA        atc on (atc.CURRICULO_ALUNO_ID = ALU.curriculo_aluno_id AND   
                                                                                    ATC.ANO = 2020 AND ATC.SEMESTRE = 1)  
                                   JOIN vw_pro_disciplina_nao_cursada       ncs ON (alu.curriculo_aluno_id = ncs.curriculo_aluno_id AND     
                                                                                    ATC.GRADE_DESTINO_NOME = ncs.grade_NOME and    
                                                                                    ncs.exigenciadisciplina_id = 2)      
                              LEFT JOIN cte_turma_disciplina_aluno_cursando tac ON (tac.curriculo_aluno_id = alu.curriculo_aluno_id AND      
                                                                                    tac.disciplina_id = ncs.disciplina_id)       
                              LEFT JOIN cte_turma_disciplina_aluno_cursando equ ON (equ.curriculo_aluno_id = alu.curriculo_aluno_id AND      
                                                                                    equ.disciplina_equivalente_id = ncs.disciplina_id)             
    WHERE      
      tac.curriculo_aluno_id IS NULL AND      
      equ.curriculo_aluno_id IS NULL  