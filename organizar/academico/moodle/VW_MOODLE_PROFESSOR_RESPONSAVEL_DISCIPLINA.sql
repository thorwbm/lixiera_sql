CREATE VIEW VW_MOODLE_PROFESSOR_RESPONSAVEL_DISCIPLINA AS 
SELECT DISTINCT 
       CUR.ID AS CURSO_ID, CUR.NOME AS CURSO_NOME, 
       DIS.ID AS DISCIPLINA_ID, DIS.NOME AS DISCIPLINA_NOME, 
	   PRO.ID AS PROFESSOR_ID, PRO.NOME AS PROFESSOR_NOME, 
	   json_value(usu.atributos, '$.moodle.id' ) as PROFESSOR_MOODLE_ID, 
	   RES.criado_em, RES.atualizado_em
  FROM academico_responsaveldisciplina RES JOIN ACADEMICO_PROFESSOR  PRO ON (PRO.ID = RES.professor_id)
                                           JOIN AUTH_USER            USU ON (USU.ID = PRO.user_id)
										   JOIN ACADEMICO_CURSO      CUR ON (CUR.ID = RES.curso_id)
										   JOIN ACADEMICO_DISCIPLINA DIS ON (DIS.ID = RES.disciplina_id)
