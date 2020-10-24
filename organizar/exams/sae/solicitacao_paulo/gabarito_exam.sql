SELECT COUNT(1)
from VW_AGENDAMENTO_PROVA_ALUNO_CODIGO APA LEFT join TMP_VETOR_RESPOSTA vet WITH(NOLOCK) on (vet.COLLECTION_ID = APA.PROVA_ID and
								                                                               vet.USER_ID       = APA.USUARIO_ID and 
															                                   vet.EXAM_ID       = APA.EXAME_id)
where APA.prova_nome like '%2%bi%' AND 
      VET.EXAM_ID IS NULL 



       drop table tmp_exam_gabarito
	  select id as exam_id, dbo.FN_GABARITO_EXAME(id) as gabarito_exam 
	  into tmp_exam_gabarito
	  from exam_exam

	  drop table tmp_aluno_gabarito
	 select app.user_id, app.exam_id, EXA.collection_id, app.id as application_id, gabarito_aluno = replicate('x', 100)
	 into tmp_aluno_gabarito_novo
from application_application app WITH(NOLOCK) join exam_exam         exa WITH(NOLOCK) on (exa.id = app.exam_id)
                                              join exam_collection   col WITH(NOLOCK) on (col.id = exa.collection_id)								              
where col.name like '%diagn%'



select top 100 * 

from tmp_resposta_aluno


update tmp_aluno_gabarito set gabarito_aluno = dbo.FN_GABARITO_ALUNO(application_id)
where application_id = 1238877



CREATE NONCLUSTERED INDEX IX_TMP_ex__APPLICATION_ID
ON [dbo].[tmp_resposta_aluno] ([application_id])