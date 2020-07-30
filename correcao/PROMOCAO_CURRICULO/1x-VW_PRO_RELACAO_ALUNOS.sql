/****************************************************************************************************
*                                      VW_PRO_RELACAO_ALUNOS                                        *
*                                                                                                   *
*  VIEW QUE RELACIONA OS ALUNOS CANDIDATOS A PROMOCAO DE SERIE/PERIODO .                            *
*                                                                                                   *
*                                                                                                   *
* BANCO_SISTEMA : ERP_PRD                                                                           *
* CRIADO POR    : WEMERSON BITTORI MADURO                                           DATA:23/07/2020 *
* ALTERADO POR  : WEMERSON BITTORI MADURO                                           DATA:23/07/2020 *
****************************************************************************************************/
 
CREATE or alter   VIEW VW_PRO_RELACAO_ALUNOS AS        
SELECT distinct ALU.ID AS ALUNO_ID, ALU.NOME AS ALUNO_NOME,     
       CRC.ID AS CURRICULO_ID, CRC.NOME AS CURRICULO_NOME,     
       TUR.ID AS TURMA_ID, TUR.NOME AS TURMA_NOME, TDA.ID AS TURMA_DISCIPLINA_ALUNO_ID,        
       TUR.etapa_ano_id, TDA.status_matricula_disciplina_id, ETP.NOME AS etapa_nome, CRA.ID AS curriculo_aluno_id    
  FROM  TMP_RENOVACAO_MATRICULA_2020 REN JOIN CURRICULOS_CURRICULO           CRC ON (REN.CURRICULO = CRC.NOME)    
                                         JOIN CURRICULOS_ALUNO               CRA ON (CRA.curriculo_id = CRC.ID)    
                                         JOIN ACADEMICO_ALUNO                ALU ON (ALU.ID = CRA.ALUNO_ID)    
                                         JOIN academico_turmadisciplinaaluno TDA ON (TDA.ALUNO_ID = CRA.ALUNO_ID)    
                                         JOIN academico_turmadisciplina      TDS ON (TDS.ID = TDA.turma_disciplina_id)    
                                         JOIN ACADEMICO_TURMA                TUR ON (TUR.ID = TDS.TURMA_ID AND TUR.TURMA_PAI_ID IS NULL)    
                                         JOIN academico_etapaano             ETA ON (ETA.ID = TUR.ETAPA_ANO_ID)    
                                         JOIN ACADEMICO_ETAPA                ETP ON (ETP.ID = ETA.ETAPA_ID)    
WHERE CRA.status_id = 13 AND     
      (MONTH(TUR.inicio_vigencia) <7 AND YEAR(TUR.inicio_vigencia) = 2020) AND     
      TDA.status_matricula_disciplina_id in (1, 6,7,9)

