SELECT TOP 100 * , DBO.FN_GABARITO_ALUNO_AUX(APPLICATION_ID) AS GABARITO
FROM tmp_aluno_gabarito WITH(NOLOCK)



	CREATE INDEX IX_TMP_ALUNO_GABARITO__APPLICATION_ID   ON tmp_aluno_gabarito (application_id)
	CREATE INDEX IX_TMP_ALUNO_GABARITO__APPLICATION_ID   ON tmp_aluno_gabarito (application_id)

SELECT * FROM TMP_ALUNO_GABARITO 



update tmp_aluno_gabarito set gabarito_aluno =   dbo.FN_GABARITO_ALUNO(application_id)
where application_id = (SELECT APPLICATION_ID FROM )

update tmp_aluno_gabarito set gabarito_aluno = null    dbo.FN_GABARITO_ALUNO(application_id)


select * FROM tmp_aluno_gabarito

DECLARE @CONTADOR INT = 1 
WHILE (@CONTADOR > 0)
BEGIN
		UPDATE tmp_aluno_gabarito  set gabarito_aluno =   dbo.FN_GABARITO_ALUNO(application_id)
		where application_id IN  (SELECT TOP 100 APPLICATION_ID FROM tmp_aluno_gabarito WHERE gabarito_aluno IS NULL)


		SELECT @CONTADOR = COUNT(1) FROM  tmp_aluno_gabarito WHERE gabarito_aluno IS NULL
END



select top 20 alu.user_id as aluno_id, usu.name as aluno_nome, 
               json_value(usu.extra, '$.hierarchy.unity.value') as escola_codigo,json_value(usu.extra, '$.hierarchy.unity.name') as escola_nome,
               json_value(usu.extra, '$.hierarchy.class.value') as turma_codigo,json_value(usu.extra, '$.hierarchy.class.name') as turma_nome,
               json_value(usu.extra, '$.hierarchy.grade.value') as grade_codigo,json_value(usu.extra, '$.hierarchy.grade.name') as grade_nome,
			   alu.application_id, 
			   alu.collection_id as prova_id, col.name as prova_nome,
			   exm.id as exam_id, exm.name as exam_nome, 
			   alu.gabarito_aluno, exa.gabarito_exam
from tmp_aluno_gabarito  alu join tmp_exam_gabarito exa on (alu.exam_id = exa.exam_id)
                             join exam_exam         exm on (exm.id = exa.exam_id)
							 join exam_collection   col on (col.id = alu.collection_id)
							 join auth_user         usu on (usu.id = alu.user_id)
WHERE --len(gabarito_exam) > 4 and 
      exm.name like '%filosofia%' and json_value(usu.extra, '$.hierarchy.grade.name') like '4%'