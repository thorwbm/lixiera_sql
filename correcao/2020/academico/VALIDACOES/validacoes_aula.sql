/*
-- #####################################################################################################
--------------------------------------------------------------------------------------------------------
-- ALUNOS COM FREQUENCIA LANCADA PARA TURMA DISCIPLINA QUE ELE NAO ESTA REGISTRADO
--------------------------------------------------------------------------------------------------------
SELECT TUR.ID AS TURMA_ID, TUR.NOME AS TURMA_NOME, 
       DIS.ID AS DISCIPLINA_ID, DIS.NOME AS DISCIPLINA_NOME, 
	   ALU.ID AS ALUNO_ID, ALU.NOME AS ALUNO_NOME, 
	   AUL.data_inicio, AUL.data_termino, 
	   TUR.inicio_vigencia AS TURMA_INI_VIGENCIA, TUR.termino_vigencia AS TURMA_FIM_VIGENCIA
FROM academico_frequenciadiaria FRE JOIN ACADEMICO_AULA                 AUL ON (AUL.ID = FRE.aula_id)
                                    JOIN ACADEMICO_ALUNO                ALU ON (ALU.ID = FRE.aluno_id)
							        JOIN ACADEMICO_TURMADISCIPLINA      TDS ON (TDS.ID = AUL.turma_disciplina_id)
									JOIN ACADEMICO_TURMA                TUR ON (TUR.ID = TDS.turma_id)
									JOIN ACADEMICO_DISCIPLINA           DIS ON (DIS.ID = TDS.disciplina_id)
							   LEFT JOIN academico_turmadisciplinaaluno TDA ON (TDS.ID = TDA.turma_disciplina_id AND
							                                                    ALU.ID = TDA.aluno_id)
WHERE TDA.ID IS NULL  AND 
      TUR.inicio_vigencia > '2020-01-01'
*/

SELECT TUR.ID AS TURMA_ID, TUR.NOME AS TURMA_NOME, 
       DIS.ID AS DISCIPLINA_ID, DIS.NOME AS DISCIPLINA_NOME, 
	   PRO.ID AS PROFESSOR_ID, PRO.NOME AS PROFESSOR_NOME, 
	   AUL.ID AS AULA_ID, AUL.data_inicio, AUL.data_termino, 
	   TUR.inicio_vigencia AS TURMA_INI_VIGENCIA, TUR.termino_vigencia AS TURMA_FIM_VIGENCIA
FROM  ACADEMICO_AULA            AUL JOIN academico_professor                PRO ON (PRO.ID = AUL.professor_id)
							        JOIN ACADEMICO_TURMADISCIPLINA          TDS ON (TDS.ID = AUL.turma_disciplina_id)
									JOIN ACADEMICO_TURMA                    TUR ON (TUR.ID = TDS.turma_id)
									JOIN ACADEMICO_DISCIPLINA               DIS ON (DIS.ID = TDS.disciplina_id)
							   LEFT JOIN academico_turmadisciplinaprofessor TDP ON (TDS.ID = TDP.turma_disciplina_id AND
							                                                        PRO.ID = TDP.professor_id)
WHERE TDP.ID IS NULL  AND 
      TUR.inicio_vigencia > '2020-01-01'


SELECT PROFESSOR_ID, turma_disciplina_id, data_inicio, data_termino, STATUS_ID FROM ACADEMICO_AULA WHERE ID = 229993
SELECT * FROM academico_turmadisciplinaprofessor WHERE professor_id = 7515   AND turma_disciplina_id = 17124
--  SELECT * FROM academico_statusaula 




	  
	  SELECT TOP 10 * FROM ACADEMICO_AULA
	  SELECT TOP 10 * FROM ACADEMICO_TURMADIS