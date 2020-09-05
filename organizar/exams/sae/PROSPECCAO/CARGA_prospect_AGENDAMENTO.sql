drop table  #temp_carga

--select *
--update tmp set tmp.avaliacao_diagnostica = 'extensivo'
--from tmp_imp_escola_2dia tmp
--where nome_escola_ava = 'SOCIEDADE EDUCACIONAL DOM OTAVIO AGUIAR LTDA' and avaliacao_diagnostica = '3ª série'

--------  CRIAR TABELA TEMPORARIA PARA CARGA -------------------------
select exa.id as exam_id, usu.id as user_id, should_update_answers = 0, timeout = null, forced_status = null, created_at = cast( getdate() as datetime), updated_at = cast( getdate() as datetime), 
       tmp.serie, etw.max_duration as max_duration, 
	   nome_escola = tmp.escola, exc.name as collection_nome, 
	   json_value(usu.extra, '$.hierarchy.grade.name') as serie_aluno

into #temp_carga
from exam_collection exc join tmp_imp_prospect tmp on (ltrim(rtrim(left(exc.name,charindex( '-',exc.name)-1))) = tmp.serie and 
                                                       reverse( ltrim(rtrim(left(reverse(exc.name),charindex( '-',reverse(exc.name))-1)))) = dia)
						 join exam_exam exa on (exa.collection_id = exc.id) 
						 join auth_user usu on (json_value(usu.extra, '$.hierarchy.unity.name') = tmp.escola and 
						                        case when json_value(usu.extra, '$.hierarchy.grade.name') in ('extensivo','extensivo mega') then '3ª série' else json_value(usu.extra, '$.hierarchy.grade.name') end = tmp.serie)
												
					left join exam_timewindow etw on (etw.exam_id = exa.id)
					left join application_application xxx on (xxx.user_id = usu.id and 
					                                          xxx.exam_id = exa.id)
where charindex( '-',exc.name) > 0 AND 
      XXX.id IS NULL  and 
      exc.name like '%prospect%' and 
	 -- usu.public_identifier  in ('32114efb08791124301ef462a249a570') and  
	-- tmp.escola = 'Colégio União' and 
	-- tmp.dia = '1º Dia'  and 
	--  blk.nome_escola_ava is null 

	  select distinct --json_value(usu.extra, '$.hierarchy.unity.name') as escola, 
	                  json_value(usu.extra, '$.hierarchy.grade.name') as grade
	  from auth_user usu where json_value(usu.extra, '$.hierarchy.unity.name') = 'COLEGIO FLAMBOYANTS'
	  
	  select * from tmp_imp_carga_final where escola ='Colégio União'
	  select distinct nome_escola, serie, serie_aluno , collection_nome from #temp_carga  -- where json_value(extra, '$.hierarchy.unity.name') = 'BAZAR TIA LEILA' and json_value(extra, '$.hierarchy.grade.name')= 'extensivo'

	  begin tran 
------------------------------------------------------------------------------------------------------------------------
-- CARGA NA APPLICATION_APPLICATION --
insert into application_application (exam_id, user_id, should_update_answers, timeout, forced_status, created_at, updated_at)
select distinct  CAR.exam_id, CAR.user_id, CAR.should_update_answers, null, CAR.forced_status, CAR.created_at, CAR.updated_at
from #temp_carga CAR left join application_application xxx on (xxx.user_id = CAR.user_id and 
					                                          xxx.exam_id = CAR.exam_id)
where XXX.ID is null 
------------------------------------------------------------------------------------------------------------------------

-- CARGA NA APPLICATION_APPLICATIONTIMEWINDOW --
--   insert into APPLICATION_APPLICATIONTIMEWINDOW (created_at, updated_at, start_time, end_time, max_duration, application_id)
--   select distinct  created_at =app.created_at , updated_at = app.updated_at, 
--                    start_time = car.start_time,	
--                    end_time =  car.end_time,
--   				 max_duration = car.max_duration, 
--   				 application_id = app.id 
--   from #temp_carga CAR join application_application app on (app.user_id = CAR.user_id and 
--   					                                      app.exam_id = CAR.exam_id)
--   				left join APPLICATION_APPLICATIONTIMEWINDOW xxx on (xxx.application_id = app.id and 
--   				                                                    xxx.start_time = car.start_time)
--   where  xxx.id is null and 
--         car.janela_aplicacao is not null 
--   

------------------------------------------------------------------------------------------------------------------------

begin tran
insert into application_answer (position, application_id, item_id, created_at, updated_at, value, seconds)
select distinct  ite.position, app.id as application_id, ite.item_id as item_id, car.created_at, car.updated_at, value = 0, seconds = 0
  from #temp_carga CAR join application_application app on (app.user_id = CAR.user_id and 
					                                        app.exam_id = CAR.exam_id)
					   join exam_examitem           ite on (ite.exam_id = car.exam_id)
				  left join application_answer      xxx on (xxx.application_id = app.id and
				                                            xxx.item_id        = ite.id)
where xxx.id is null 


 --commit
-- rollback 



