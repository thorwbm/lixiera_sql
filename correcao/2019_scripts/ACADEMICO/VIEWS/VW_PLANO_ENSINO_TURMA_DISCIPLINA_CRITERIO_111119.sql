  
-- SELECT * FROM VW_PLANO_ENSINO_TURMA_DISCIPLINA_CRITERIO WHERE TURMA_nome = '2MC1º2018-1'  
  
CREATE OR ALTER    VIEW [dbo].[vw_plano_ensino_turma_disciplina_criterio] as   
WITH CTE_PROFESSOR_TURMA_DISCIPINA_UNICO AS (  
  SELECT tdp.*, pro.nome as professor_nome   
    FROM academico_turmadisciplinaprofessor tdp join academico_professor pro on (tdp.professor_id = pro.id)  
   WHERE TURMA_DISCIPLINA_ID IN (select TURMA_DISCIPLINA_ID   
                                         from academico_turmadisciplinaprofessor   
                                        GROUP BY TURMA_DISCIPLINA_ID   
                                       HAVING COUNT(PROFESSOR_ID) = 1)  
)  
  
     ,CTE_PROFESSOR_RESPONSAVEL_DISCIPINA_UNICO AS (  
  SELECT rpd.* , pro.nome as professor_nome  
    FROM academico_responsaveldisciplina rpd join academico_professor pro on (rpd.professor_id = pro.id)  
   WHERE DISCIPLINA_ID IN (select DISCIPLINA_ID   
                                         from academico_responsaveldisciplina   
                                        GROUP BY DISCIPLINA_ID   
                                       HAVING COUNT(PROFESSOR_ID) = 1)  
)   
        
  
SELECT DISTINCT    
       PEP.ID AS PLANOENSINO_ID,PEP.EMENTA, PEP.CARGA_HORARIA, PEP.MATRIZ,  
       CUR.ID AS CURSO_ID, CUR.NOME AS CURSO_NOME,   
       TUR.ID AS TURMA_ID, TUR.NOME AS TURMA_NOME, TUR.ATRIBUTOS AS TURMA_ATRIBUTOS, TUR.INICIO_VIGENCIA, TUR.TERMINO_VIGENCIA,   
       DIS.ID AS DISCIPLINA_ID, DIS.NOME AS DISCIPLINA_NOME,   
       ATC.ID AS CRITERIO_ID, ATC.NOME AS CRITERIO_NOME, ATC.POSICAO AS CRITERIO_POSICAO,  
       ETA.ID AS ETAPAANO_ID, ETA.ANO,   
       ETP.ID AS ETAPA_ID, ETP.ETAPA,  
       TDS.ID AS TURMADISCIPLINA_ID ,   
       PPC.ID AS PLANOENSINOCRITERIO_ID,   
       ISNULL(PTD.PROFESSOR_ID, PRD.PROFESSOR_ID) AS PROFESSOR_RESPONSAVEL_ID ,   
       ISNULL(PTD.PROFESSOR_NOME, PRD.PROFESSOR_NOME) AS PROFESSOR_RESPONSAVEL  
  FROM planos_ensino_planoensino PEP WITH(NOLOCK) JOIN planos_ensino_planoensino_criterio PPC WITH(NOLOCK) ON (PEP.id = PPC.planoensino_id)  
                                                  JOIN atividades_criterio                ATC WITH(NOLOCK) ON (ATC.id = PPC.criterio_id)  
              JOIN academico_curso                    CUR WITH(NOLOCK) ON (CUR.id = PEP.curso_id)  
              JOIN academico_etapaano                 ETA WITH(NOLOCK) ON (ETA.id = PEP.etapa_ano_id)  
              JOIN academico_etapa                    ETP WITH(NOLOCK) ON (ETP.id = ETA.etapa_id)  
              JOIN academico_turma                    TUR WITH(NOLOCK) ON (ETA.id = TUR.etapa_ano_id)  
              JOIN academico_disciplina               DIS WITH(NOLOCK) ON (DIS.id = PEP.disciplina_id)  
              JOIN academico_turmadisciplina          TDS WITH(NOLOCK) ON (TUR.id = TDS.turma_id AND   
                                                                           DIS.ID = TDS.disciplina_id)  
               LEFT JOIN CTE_PROFESSOR_TURMA_DISCIPINA_UNICO       PTD WITH(NOLOCK) ON (TDS.ID = PTD.turma_disciplina_id)   
               LEFT JOIN CTE_PROFESSOR_RESPONSAVEL_DISCIPINA_UNICO PRD WITH(NOLOCK) ON (TDS.disciplina_id = PRD.disciplina_id)   
  