-- ################################################################################
-- PESSOAS QUE POSSUEM APENAS UM AUTH_USER POREM E PROFESSOR E ALUNO
-----------------------------------------------------------------------------------
WITH CTE_PESSOAS AS (
			SELECT PES.ID
			  FROM PESSOAS_PESSOA PES JOIN AUTh_USER USU ON (PES.ID = USU.PERSON_ID)
			  GROUP BY PES.ID 
			  HAVING COUNT(DISTINCT USU.ID) = 1
) 

		SELECT * 
		  FROM CTE_PESSOAS PES JOIN ACADEMICO_ALUNO     ALU ON (PES.ID = ALU.pessoa_id) 
		                       JOIN ACADEMICO_PROFESSOR PRO ON (PES.ID = PRO.pessoa_id)
		   