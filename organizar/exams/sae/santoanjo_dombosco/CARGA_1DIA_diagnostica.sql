select distinct * from tmp_imp_carga_aluno_db_sa WHERE ESCOLA_NOME = 'COLÉGIO DOM BOSCO (BALSAS)'
--{"hierarchy": {"provider": {"value": "SAE", "name": "SAE"}, "unity":{"value":"d07e0a07387e91cde8c81768443f235b","name":"Centro de Integração Escolar Dom Bosco"}, "class":{"value":"79bd2ffcc8cf4c8fa328d2fafd754192","name":"3º MEGA"}, "grade":{"value":"4D717306-4F4E-4F1D-B703-6C391C7B25DB","name":"Extensivo Mega"}}}
drop table  #temp_carga
--------  CRIAR TABELA TEMPORARIA PARA CARGA -------------------------
select distinct  exa.id as exam_id, usu.id as user_id, should_update_answers = 0, timeout = null, forced_status = null, 
       created_at = cast( getdate() as datetime), updated_at = cast( getdate() as datetime), 
       tmp.grade_nome, escola_nome = tmp.escola_nome, json_value(usu.extra, '$.hierarchy.grade.name') as serie_aluno, exa.name as exame_nome

into #temp_carga
--  select *
from exam_collection exc join tmp_imp_carga_aluno_db_sa tmp on (charindex( '-',exc.name) > 0 and 
                                                                ltrim(rtrim(left(exc.name,charindex( '-',exc.name)-1))) = case when tmp.grade_nome in ('extensivo','extensivo mega') then '3ª série' else tmp.grade_nome end)
						 join exam_exam exa on (exa.collection_id = exc.id) 
						 join auth_user usu on (json_value(usu.extra, '$.hierarchy.unity.name') = tmp.escola_nome and 
						                        usu.public_identifier = tmp.aluno_id and
			--			                       -- case when json_value(usu.extra, '$.hierarchy.grade.name') in ('extensivo','extensivo mega') then '3ª série' else json_value(usu.extra, '$.hierarchy.grade.name') end = tmp.grade_nome)
											    json_value(usu.extra, '$.hierarchy.grade.name') = tmp.grade_nome)					
					left join application_application xxx on (xxx.user_id = usu.id and 
					                                          xxx.exam_id = exa.id)
where exc.name like '%Diagnóstica%' and exc.name not like '%prospect%' and       
	  reverse( ltrim(rtrim(left(reverse(exc.name),charindex( '-',reverse(exc.name))-1)))) = '2º Dia'  and
      XXX.id IS NULL  

	  
	  select distinct escola_nome, exame_nome,  grade_nome from #temp_carga where user_id = 276881  -- where json_value(extra, '$.hierarchy.unity.name') = 'BAZAR TIA LEILA' and json_value(extra, '$.hierarchy.grade.name')= 'extensivo'

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



select distinct apa.*
  from VW_AGENDAMENTO_PROVA_ALUNO apa join tmp_imp_carga_aluno_db_sa tmp on (apa.ESCOLA_NOME = tmp.escola_nome and 
                                                                             apa.aluno_nome  = tmp.aluno_nome)
									  join auth_user usu on (apa.usuario_id = usu.id and
									                         usu.public_identifier = tmp.aluno_id)
where
apa.prova_nome like '%Diagnóstica%' and apa.prova_nome not like '%prospect%' 
and apa.usuario_id = 276367