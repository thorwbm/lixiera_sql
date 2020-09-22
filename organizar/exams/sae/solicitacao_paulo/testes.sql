

select DISTINCT APA.USUARIO_ID, APA.EXAME_ID, APA.PROVA_ID
  from VW_AGENDAMENTO_PROVA_ALUNO_CODIGO APA LEFT join TMP_VETOR_RESPOSTA vet WITH(NOLOCK) on (vet.COLLECTION_ID = APA.PROVA_ID and
								                                                         vet.USER_ID = APA.USUARIO_ID and 
															                             vet.EXAM_ID = APA.EXAME_id)
where APA.prova_nome like '%2%bi%' AND 
      VET.EXAM_ID IS NULL 
	  ORDER BY 1



SELECT DISTINCT *  FROM   TMP_VETOR_RESPOSTA WHERE USER_ID = 104154

INSERT INTO TMP_VETOR_RESPOSTA
select app.user_id, app.exam_id, EXA.collection_id, 
       dbo.FN_GABARITO_ALUNO(app.id) AS GABARITO_ALUNO, 
	   dbo.FN_GABARITO_EXAME(app.exam_id) AS GABARITO_EXAME
from application_application app WITH(NOLOCK) join exam_exam         exa WITH(NOLOCK) on (exa.id = app.exam_id)
                                              join exam_collection   col WITH(NOLOCK) on (col.id = exa.collection_id)
								              
where col.name like 'Desafio SAE%2°BI -%' AND
      APP.USER_ID in (104154) 



-----
1059369 -- 1059269


DECLARE @CONTADOR INT 
SELECT @CONTADOR = COUNT(1)
from VW_AGENDAMENTO_PROVA_ALUNO_CODIGO APA LEFT join TMP_VETOR_RESPOSTA vet WITH(NOLOCK) on (vet.COLLECTION_ID = APA.PROVA_ID and
								                                                               vet.USER_ID       = APA.USUARIO_ID and 
															                                   vet.EXAM_ID       = APA.EXAME_id)
where APA.prova_nome like '%2%bi%' AND 
      VET.EXAM_ID IS NULL 


PRINT @CONTADOR

WHILE (@CONTADOR > 0)
	BEGIN 
		INSERT INTO TMP_VETOR_RESPOSTA
		select TOP 100  APA.USUARIO_ID, APA.EXAME_ID, APA.PROVA_ID, APA.APPLICATION_ID,
			   dbo.FN_GABARITO_ALUNO(APA.APPLICATION_ID) AS GABARITO_ALUNO, 
			   dbo.FN_GABARITO_EXAME(APA.examE_id) AS GABARITO_EXAME 
		  from VW_AGENDAMENTO_PROVA_ALUNO_CODIGO APA LEFT join TMP_VETOR_RESPOSTA vet WITH(NOLOCK) on (vet.COLLECTION_ID = APA.PROVA_ID and
																									   vet.USER_ID       = APA.USUARIO_ID and 
																									   vet.EXAM_ID       = APA.EXAME_id)
		where APA.prova_nome like '%2%bi%' AND 
			  VET.EXAM_ID IS NULL 
			  ORDER BY 1

		-------- CONTROLE DO WHILE --------------------
		SELECT @CONTADOR = COUNT(1)
		from VW_AGENDAMENTO_PROVA_ALUNO_CODIGO APA LEFT join TMP_VETOR_RESPOSTA vet WITH(NOLOCK) on (vet.COLLECTION_ID = APA.PROVA_ID and
																									   vet.USER_ID       = APA.USUARIO_ID and 
																									   vet.EXAM_ID       = APA.EXAME_id)
		where APA.prova_nome like '%2%bi%' AND 
			  VET.EXAM_ID IS NULL 

	END 


