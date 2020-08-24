drop table  #temp_carga

--------  CRIAR TABELA TEMPORARIA PARA CARGA -------------------------
select exa.id as exam_id, usu.id as user_id, should_update_answers = 0, timeout = null, forced_status = null, created_at = cast( getdate() as datetime), updated_at = cast( getdate() as datetime), 
       tmp.janela_aplicacao, etw.max_duration as max_duration, 
	   start_time = cast (convert(varchar(10),tmp.janela_aplicacao,120) + ' ' +convert(varchar(8),etw.start_time,114) as datetime) ,	
       end_time =  dateadd(day,1,tmp.janela_aplicacao)
into #temp_carga
from exam_collection exc join tmp_imp_escola_1dia tmp on (ltrim(rtrim(left(exc.name,charindex( '-',exc.name)-1))) = tmp.avaliacao_diagnostica and 
                                                          reverse( ltrim(rtrim(left(reverse(exc.name),charindex( '-',reverse(exc.name))-1)))) = dia_aplicacao)
						 join exam_exam exa on (exa.collection_id = exc.id) 
						 join auth_user usu on (json_value(usu.extra, '$.hierarchy.unity.name') = tmp.nome_escola_ava and 
						                        json_value(usu.extra, '$.hierarchy.grade.name') = tmp.avaliacao_diagnostica)
					left join tmp_imp_bloquear blk on (blk.nome_escola_ava = tmp.nome_escola_ava and 
					                                   blk.simulado_bimestral = tmp.avaliacao_diagnostica and 
													   blk.janela_aplicacao = 'BLOQUEAR')
					left join exam_timewindow etw on (etw.exam_id = exa.id)
					left join application_application xxx on (xxx.user_id = usu.id and 
					                                          xxx.exam_id = exa.id)
where charindex( '-',exc.name) > 0 AND 
      XXX.id IS NULL  and 
      exc.name like '%Diagnóstica%' and 
	  blk.nome_escola_ava is null 

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
insert into APPLICATION_APPLICATIONTIMEWINDOW (created_at, updated_at, start_time, end_time, max_duration, application_id)
select distinct  created_at =app.created_at , updated_at = app.updated_at, 
                 start_time = car.start_time,	
                 end_time =  car.end_time,
				 max_duration = car.max_duration, 
				 application_id = app.id 
from #temp_carga CAR join application_application app on (app.user_id = CAR.user_id and 
					                                      app.exam_id = CAR.exam_id)
				left join APPLICATION_APPLICATIONTIMEWINDOW xxx on (xxx.application_id = app.id and 
				                                                    xxx.start_time = car.start_time)
where  xxx.id is null and 
      car.janela_aplicacao is not null 


------------------------------------------------------------------------------------------------------------------------
insert into application_answer (position, application_id, item_id, created_at, updated_at, value, seconds)
select ite.position, app.id as application_id, ite.item_id as item_id, car.created_at, car.updated_at, value = 0, seconds = 0
  from #temp_carga CAR join application_application app on (app.user_id = CAR.user_id and 
					                                        app.exam_id = CAR.exam_id)
					   join exam_examitem           ite on (ite.exam_id = car.exam_id)
				  left join application_answer      xxx on (xxx.application_id = app.id and
				                                            xxx.item_id        = ite.id)
where xxx.id is null 


-- commit 
-- rollback 

