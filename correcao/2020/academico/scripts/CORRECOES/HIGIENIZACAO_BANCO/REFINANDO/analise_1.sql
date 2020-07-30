-- 9975, 9979
--11382, 11383

DECLARE @TDS_1 INT, @TDS_2 INT
SET @TDS_1 = 14074
SET @TDS_2 = 14076

;
WITH CTE_ANALISE_1 AS (
			SELECT TDS.ID AS TURMA_DISCIPLINA_ID, TUR.NOME AS TURMA_NOME, DIS.NOME AS DISCPLINA_NOME, 
			       ALU.ID AS ALUNO_ID, ALU.NOME AS ALUNO_NOME, AUL.ID AS AULA_ID, 
				   FRE.ID AS FREQUENCIA_ID, CCH.ID AS COMP_CARGA_HORARIA, CCH.ALUNO_ID AS ALUNO_ID_COMPLEMENTO
		  FROM academico_turmadisciplina TDS JOIN ACADEMICO_TURMA                      TUR ON (TUR.ID = TDS.turma_id)
											 JOIN ACADEMICO_DISCIPLINA                 DIS ON (DIS.ID = TDS.disciplina_id)
										LEFT JOIN academico_turmadisciplinaaluno       TDA ON (TDS.ID = TDA.turma_disciplina_id)
										LEFT JOIN ACADEMICO_ALUNO                      ALU ON (ALU.ID = TDA.aluno_id)
										LEFT JOIN ACADEMICO_AULA                       AUL ON (TDS.ID = AUL.turma_disciplina_id)
										LEFT JOIN academico_frequenciadiaria           FRE ON (AUL.ID = FRE.aula_id AND 
										                                                       ALU.ID = FRE.aluno_id)
										LEFT JOIN academico_complementacaocargahoraria CCH ON (TDS.ID = CCH.turma_disciplina_id)
		WHERE TDS.ID = @TDS_1
)
	,	CTE_ANALISE_2 AS (
			SELECT TDS.ID AS TURMA_DISCIPLINA_ID, TUR.NOME AS TURMA_NOME, DIS.NOME AS DISCPLINA_NOME, 
			       ALU.ID AS ALUNO_ID, ALU.NOME AS ALUNO_NOME, AUL.ID AS AULA_ID, 
				   FRE.ID AS FREQUENCIA_ID, CCH.ID AS COMP_CARGA_HORARIA, CCH.ALUNO_ID AS ALUNO_ID_COMPLEMENTO
			  FROM academico_turmadisciplina TDS JOIN ACADEMICO_TURMA                      TUR ON (TUR.ID = TDS.turma_id)
												 JOIN ACADEMICO_DISCIPLINA                 DIS ON (DIS.ID = TDS.disciplina_id)
											LEFT JOIN academico_turmadisciplinaaluno       TDA ON (TDS.ID = TDA.turma_disciplina_id)
											LEFT JOIN ACADEMICO_ALUNO                      ALU ON (ALU.ID = TDA.aluno_id)
											LEFT JOIN ACADEMICO_AULA                       AUL ON (TDS.ID = AUL.turma_disciplina_id)
											LEFT JOIN academico_frequenciadiaria           FRE ON (AUL.ID = FRE.aula_id AND 
											                                                       ALU.ID = FRE.aluno_id)
											LEFT JOIN academico_complementacaocargahoraria CCH ON (TDS.ID = CCH.turma_disciplina_id )
			WHERE TDS.ID = @TDS_2
)
	
			SELECT DISTINCT * FROM CTE_ANALISE_1 UNION 
			SELECT DISTINCT * FROM CTE_ANALISE_2
	

--	SELECT * FROM academico_complementacaocargahoraria WHERE aluno_id = 43707