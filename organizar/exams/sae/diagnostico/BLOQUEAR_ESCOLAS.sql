--   DROP TABLE #temp_bloqueio

SELECT DISTINCT PROVA_NOME, ESCOLA_NOME, GRADE_NOME,  application_id, application_tmw_id, answer_id 
into #temp_bloqueio
FROM VW_AGENDAMENTO_PROVA_ALUNO_PERGUNTA_RESPOSTA
where PROVA_NOME like '%- Diagnóstica 2/2020 - % dia%' and 
      PROVA_NOME not like '%(prospect)%' and escola_nome ='COLEGIO SILOGEU' and 
	  grade_nome = 'Extensivo'
/*******************************************************************************
           TESTAR SE EXISTE ALGUMA PERGUNTA JA RESPONDIDA
		   CASO AFIRMATIVO VER COM A PRISCILLA
*******************************************************************************/
 SELECT tmp.*, ans.alternative_id from application_answer ANS join #temp_bloqueio tmp on (ANS.id = tmp.ANSWER_ID)
  WHERE ANS.alternative_id IS NOT NULL 

BEGIN TRAN 
/*******************************************************************************
           COPIA DA APPLICATION APPLICATION BLOQUEADA (EXCLUIDA)
*******************************************************************************/
insert into application_bloqueada (id, started_at, finished_at, exam_id, user_id, should_update_answers, 
                                   timeout, forced_status, created_at, updated_at, room_id, reseted_at, reseted_by_id)
select distinct 
       app.id, app.started_at, app.finished_at, app.exam_id, app.user_id, app.should_update_answers,
       app.timeout, app.forced_status, app.created_at, app.updated_at, app.room_id, app.reseted_at, 
	   app.reseted_by_id	   
  from application_application app join #temp_bloqueio        tmp on (app.id = tmp.application_id)
                              left join application_bloqueada xxx on (xxx.id = app.id)
 where xxx.id is null 


/*******************************************************************************
           COPIA DA APPLICATION TIME WINDOW BLOQUEADA (EXCLUIDA)
*******************************************************************************/
insert into application_TMW_bloqueada (id, created_at, updated_at, start_time, end_time, max_duration, application_id)
select distinct 
       TMW.id, TMW.created_at, TMW.updated_at, TMW.start_time, TMW.end_time, TMW.max_duration, TMW.application_id	
  from application_applicationtimewindow TMW join #temp_bloqueio            tmp on (TMW.id = tmp.APPLICATION_TMW_ID)
                                        left join application_TMW_bloqueada xxx on (xxx.id = TMW.id)
 where xxx.id is null 
 

/*******************************************************************************
           COPIA DA APPLICATION ANSWER BLOQUEADA (EXCLUIDA)
*******************************************************************************/
insert into application_ANSWER_bloqueada (id, position, free_response, alternative_id, application_id, 
                                          item_id, created_at, updated_at, seconds, value, timeout_date)
select distinct 
       ANS.id, ANS.position, ANS.free_response, ANS.alternative_id, ANS.application_id, ANS.item_id, 
	   ANS.created_at, ANS.updated_at, ANS.seconds, ANS.value, ANS.timeout_date	
	
  from application_answer ANS join #temp_bloqueio                              tmp on (ANS.id = tmp.ANSWER_ID)
                                        left join application_ANSWER_bloqueada xxx on (xxx.id = ANS.id)
 where xxx.id is null 
 

/*******************************************************************************
           DELETAR AS INFORMACOES DAS TABELAS 
*******************************************************************************/
DELETE ANS from application_answer                ANS join #temp_bloqueio tmp on (ANS.id = tmp.ANSWER_ID)
DELETE TMW from application_applicationtimewindow TMW join #temp_bloqueio tmp on (TMW.id = tmp.APPLICATION_TMW_ID) 
DELETE app FROM application_application           app join #temp_bloqueio tmp on (app.id = tmp.application_id)

-- COMMIT 
-- ROLLBACK 