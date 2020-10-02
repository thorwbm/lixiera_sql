use exams_sae

       drop table tmp_exam_gabarito
	  select id as exam_id, dbo.FN_GABARITO_EXAME(id) as gabarito_exam 
	  into tmp_exam_gabarito
	  from exam_exam

	  drop table tmp_aluno_gabarito
	 select app.user_id, app.exam_id, EXA.collection_id, app.id as application_id, gabarito_aluno = replicate('x', 100)
	 into tmp_aluno_gabarito
from application_application app WITH(NOLOCK) join exam_exam         exa WITH(NOLOCK) on (exa.id = app.exam_id)
                                              join exam_collection   col WITH(NOLOCK) on (col.id = exa.collection_id)								              
where col.name like '%diagn%'


	SELECT * FROM  tmp_aluno_gabarito WHERE gabarito_aluno IS not  NULL


	select dbo.FN_GABARITO_ALUNO_AUX (2605825)