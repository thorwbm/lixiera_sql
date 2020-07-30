SELECT TUR.grade_id, TDA.curriculo_aluno_id, TUR.NOME
-- UPDATE CRA SET CRA.grade_id = TUR.grade_id
  FROM academico_turmadisciplinaaluno TDA JOIN ACADEMICO_TURMADISCIPLINA TDS ON (TDS.ID = TDA.turma_disciplina_id)
                                          JOIN ACADEMICO_TURMA           TUR ON (TUR.ID = TDS.TURMA_ID)
										  join curriculos_aluno          cra on (cra.id = tda.curriculo_aluno_id and
										                                         cra.status_id = 13)
 WHERE TDA.status_matricula_disciplina_id = 14 AND
       TUR.turma_pai_id IS NULL 


	   SELECT TOP 100 * FROM CURRICULOS_ALUNO WHERE ID = 37658


	   SELECT * FROM CURRICULOS_GRADE WHERE ID IN (6986, 6985)