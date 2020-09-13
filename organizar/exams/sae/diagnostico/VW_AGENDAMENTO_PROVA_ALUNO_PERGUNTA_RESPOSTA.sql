create or alter  view VW_AGENDAMENTO_PROVA_ALUNO_PERGUNTA_RESPOSTA AS             
select distinct              
       COL.NAME AS PROVA_NOME, JSON_VALUE(USU.EXTRA, '$.hierarchy.unity.name') AS ESCOLA_NOME,             
       EXA.NAME AS EXAME_NOME,             
       JSON_VALUE(USU.EXTRA, '$.hierarchy.grade.name') AS GRADE_NOME,             
       USU.NAME AS ALUNO_NOME,             
      dateadd(hour, -3, TMW.START_TIME) AS EXA_TWD_INICIO,dateadd(hour, -3, TMW.END_TIME) AS EXA_TWD_TERMINO, TMW.MAX_DURATION AS EXA_TWD_DURACAO,            
      dateadd(hour, -3, ATW.START_TIME) AS APP_TWD_INICIO,dateadd(hour, -3, ATW.END_TIME) AS APP_TWD_TERMINO, ATW.MAX_DURATION AS APP_TWD_DURACAO,            
      app.id as application_id, ATW.ID AS APPLICATION_TMW_ID,  usu.id as usuario_id, 
	  asw.id as answer_id, asw.alternative_id as alternativa_marcada, asw.item_id
  from auth_user usu with(nolock) join application_application           app with(nolock) on (usu.id = app.user_id)            
                                  join exam_exam                         exa with(nolock) on (exa.id = app.exam_id)            
                                  join exam_timewindow                   tmw with(nolock) on (exa.id = tmw.exam_id)            
                                  join exam_collection                   col with(nolock) on (col.id = exa.collection_id)            
                             left join application_applicationtimewindow atw with(nolock) on (app.id = atw.application_id) 
							 left join application_answer                asw with(nolock) on (app.id = asw.application_id)