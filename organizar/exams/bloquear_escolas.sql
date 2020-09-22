
drop table #tmp_excluir
select application_application_id as application_id into #tmp_excluir
--   select distinct grade_nome
from VW_AGENDAMENTO_PROVA_ALUNO 
where escola_nome = 'COLÉGIO UNINOVE' and
      prova_nome like '%Diagnóstica 2/2020 -%' and 
      prova_nome not like '%prospect%' and 
	  grade_nome in (N'4º ano', N'5º ano', N'6º ano') 

select * from application_answer where application_id in (select application_id from #tmp_excluir )

begin tran
insert into application_ANSWER_bloqueada
select aux.* from application_answer aux join #tmp_excluir tmp on (tmp.application_id = aux.application_id)

insert into application_TMW_bloqueada
select aux.* from application_applicationtimewindow aux join #tmp_excluir tmp on (tmp.application_id = aux.application_id)

insert into application_bloqueada
select aux.* from application_application aux join #tmp_excluir tmp on (tmp.application_id = aux.id)

delete aux from application_answer aux join #tmp_excluir tmp on (tmp.application_id = aux.application_id)
delete aux from application_applicationtimewindow aux join #tmp_excluir tmp on (tmp.application_id = aux.application_id)
delete aux from application_application aux join #tmp_excluir tmp on (tmp.application_id = aux.id)

 --commit
-- rollback 


/*******************************************************************************
                             VOLTAR ESCOLA BLOQEADA
--------------------------------------------------------------------------------
select blk.id as application_id
into #tmp_restaurar
from application_bloqueada blk join exam_exam exa on (exa.id = blk.exam_id)
                                        join auth_user usu on (usu.id = blk.user_id)

where json_value(usu.extra, '$.hierarchy.unity.name') = 'COLÉGIO UNINOVE' and 
      json_value(usu.extra, '$.hierarchy.grade.name') in (N'4º ano', N'5º ano') and
      exa.name like '%Diagnóstica 2/2020 -%' and 
      exa.name not like '%prospect%'


--- INSERIR NA APPLICATION
insert into application_application (started_at, finished_at, exam_id, user_id, should_update_answers, timeout, 
                                     forced_status, created_at, updated_at, room_id, reseted_at, reseted_by_id)
select blo.started_at, blo.finished_at, blo.exam_id, blo.user_id, blo.should_update_answers, blo.timeout, 
       blo.forced_status, blo.created_at, blo.updated_at, blo.room_id, blo.reseted_at, blo.reseted_by_id

from #tmp_restaurar exc join application_bloqueada blo on (blo.id = exc.application_id ) 
                 left join application_application app on (app.exam_id = blo.exam_id and 
				                                           app.user_id = blo.user_id)
where app.id is  null 


-- INSERIR NA application_applicationtimewindow
INSERT INTO application_applicationtimewindow (created_at, updated_at, start_time, 
                                               end_time, max_duration, application_id)
SELECT TMB.created_at, TMB.updated_at, TMB.start_time, TMB.end_time, TMB.max_duration, APP.ID 
  from #tmp_restaurar exc join application_bloqueada   blo on (blo.id = exc.application_id ) 
                        join application_application app on (app.exam_id = blo.exam_id and 
				                                             app.user_id = blo.user_id)
						JOIN application_TMW_bloqueada TMB ON (TMB.application_id = BLO.ID)
				   LEFT JOIN application_applicationtimewindow XXX ON (XXX.application_id = APP.ID)
where XXX.ID IS NULL 


-- INSERIR NA application_ANSWER
INSERT INTO application_ANSWER (position, free_response, alternative_id, application_id, 
                                  item_id, created_at, updated_at, seconds, value, timeout_date)
SELECT TAW.position, TAW.free_response, TAW.alternative_id, APP.ID, 
        TAW.item_id, TAW.created_at, TAW.updated_at, TAW.seconds, TAW.value, TAW.timeout_date
  from #tmp_restaurar exc join application_bloqueada   blo on (blo.id = exc.application_id ) 
                        join application_application app on (app.exam_id = blo.exam_id and 
				                                             app.user_id = blo.user_id)
						JOIN application_ANSWER_bloqueada TAW ON (TAW.application_id = BLO.ID)
				   LEFT JOIN application_ANSWER XXX ON (XXX.application_id = APP.ID AND
				                                        XXX.item_id = TAW.item_id)
where XXX.ID IS NULL

********************************************************************************/