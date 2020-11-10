

  drop table  #temp_carga
------ insert into application application 
declare @criado_em datetime = dbo.getlocaldate()

select distinct  started_at = null, finished_at = null, exa.exam_id, usu.id as user_id, should_update_answers = 0, timeout = null, forced_status = null, 
       created_at = @criado_em, updated_at =@criado_em,
	   start_time = cast (convert(varchar(10),blk.data_aplicacao,120) + ' ' +convert(varchar(8),etw.start_time,114) as datetime) ,	
       end_time =  dateadd(day,1,blk.data_aplicacao), etw.max_duration
	   into #temp_carga
  from  auth_user usu  join VW_COLLECTION_EXAM_4BI  exa on (exa.COLLECTION_GRADE = '3ª série' and
                                                            json_value(usu.extra, '$.hierarchy.grade.name') in ('3ª série', 'extensivo', 'Extensivo Mega'))
					   join tmp_imp_4bi_agendamento_blk blk on (blk.escolaNome = json_value(usu.extra, '$.hierarchy.unity.name') and 
									                            blk.serie =exa.COLLECTION_GRADE )
					   join exam_timewindow             etw on (exa.exam_id = etw.exam_id)
				  left join application_application     xxx on (xxx.user_id = usu.id and 
				                                                xxx.exam_id = exa.exam_id)
where xxx.id is null and blk.data_aplicacao is not null and 
      --blk.escolaNome = 'COLÉGIO 21 DE ABRIL'   and 
  not (   (isnull(espanhol  ,'x') = 'bloquear' and disciplina = 'Língua Espanhola') or 
	      (isnull(ingles    ,'x') = 'bloquear' and disciplina = 'Língua Inglesa') or   
	      (isnull(artes     ,'x') = 'bloquear' and disciplina = 'Arte')  or   
	      (isnull(filosofia ,'x') = 'bloquear' and disciplina = 'Filosofia')  or   
	      (isnull(sociologia,'x') = 'bloquear' and disciplina = 'Sociologia') )

select * from #temp_carga where start_time is null 

select distinct serie from tmp_imp_4bi_agendamento_blk

------------------------------------------------------------------------------------------------------------------------
-- CARGA NA APPLICATION_APPLICATION --
---insert into application_application (exam_id, user_id, should_update_answers, timeout, forced_status, created_at, updated_at)
select distinct  CAR.exam_id, CAR.user_id, CAR.should_update_answers, null, CAR.forced_status, CAR.created_at, CAR.updated_at
from #temp_carga CAR left join application_application xxx on (xxx.user_id = CAR.user_id and 
					                                          xxx.exam_id = CAR.exam_id)
where XXX.ID is null 
------------------------------------------------------------------------------------------------------------------------

-- CARGA NA APPLICATION_APPLICATIONTIMEWINDOW --
--  insert into APPLICATION_APPLICATIONTIMEWINDOW (created_at, updated_at, start_time, end_time, max_duration, application_id)
   select distinct  created_at =app.created_at , updated_at = app.updated_at, 
                    start_time = car.start_time,	
                    end_time =  car.end_time,
   				 max_duration = car.max_duration, 
   				 application_id = app.id 
   from #temp_carga CAR join application_application app on (app.user_id = CAR.user_id and 
   					                                      app.exam_id = CAR.exam_id)
   				left join APPLICATION_APPLICATIONTIMEWINDOW xxx on (xxx.application_id = app.id and 
   				                                                    xxx.start_time = car.start_time)
   where  xxx.id is null 
   

------------------------------------------------------------------------------------------------------------------------

--begin tran
--insert into application_answer (position, application_id, item_id, created_at, updated_at, value, seconds)
select distinct  ite.position, app.id as application_id, ite.item_id as item_id, car.created_at, car.updated_at, value = 0, seconds = 0
  from #temp_carga CAR join application_application app on (app.user_id = CAR.user_id and 
					                                        app.exam_id = CAR.exam_id)
					   join exam_examitem           ite on (ite.exam_id = car.exam_id)
				  left join application_answer      xxx on (xxx.application_id = app.id and
				                                            xxx.item_id        = ite.id)
where xxx.id is null 



/************************************************************************************
select * delete from application_answer where application_id in (
select id  from application_application 
where created_at >= '2020-11-03 12:12:08') 

select * delete from application_applicationtimewindow where application_id in (
select id  from application_application 
where created_at >= '2020-11-03 12:12:08') 


select id  delete from application_application 
where created_at >= '2020-11-03 12:12:08'

*************************************************************************************/




