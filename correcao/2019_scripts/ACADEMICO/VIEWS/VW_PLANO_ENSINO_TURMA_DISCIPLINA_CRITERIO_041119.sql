CREATE OR ALTER VIEW vw_plano_ensino_turma_disciplina_criterio as 
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
       PEP.id AS PLANO_ID,PEP.ementa, PEP.carga_horaria, PEP.matriz,
       CUR.id AS CURSO_ID, CUR.nome AS CURSO_NOME, 
       TUR.id AS TURMA_ID, TUR.nome AS TURMA_NOME, tur.atributos as TURMA_ATRIBUTOS, TUR.inicio_vigencia, TUR.termino_vigencia, 
	   DIS.id AS DISCIPLINA_ID, DIS.nome AS DISCIPLINA_NOME, 
	   ATC.ID AS CRITERIO_ID, ATC.NOME AS CRITERIO_NOME, ATC.posicao,
	   ETA.id AS ETAPAANO_ID, ETA.ano, 
	   ETP.id AS ETAPA_ID, ETP.etapa,
	   TDS.id AS TURMADISCIPLINA_ID , 
	   isnull(PTD.professor_id, PRD.professor_id) as professor_responsavel_id , 
	   isnull(PTD.professor_nome, PRD.professor_nome) as professor_responsavel
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

