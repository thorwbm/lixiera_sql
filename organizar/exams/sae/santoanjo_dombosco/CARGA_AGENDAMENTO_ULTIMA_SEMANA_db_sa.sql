select distinct serie from TMP_IMP_ESCOLA_AGENDAMENTO_ULTIMA_SEMANA where serie in ()
select reverse( ltrim(rtrim(left(reverse(exc.name),charindex( '-',reverse(exc.name))-1)))),* 
from exam_collection exc where exc.name like 'Desafio SAE % 3°BI%'



drop table  #temp_carga

--------  CRIAR TABELA TEMPORARIA PARA CARGA -------------------------
select exa.id as exam_id, usu.id as user_id, should_update_answers = 0, timeout = null, forced_status = null, 
       created_at = cast( getdate() as datetime), updated_at = cast( getdate() as datetime), 
	   ESCOLA_NOME = tmp.ESCOLA_NOME, exc.name as collection_nome, tmp.grade_nome
into #temp_carga

from exam_collection exc join tmp_imp_carga_aluno_db_sa tmp on  (charindex( '-',exc.name) > 0 and exc.name like 'Desafio SAE % 3°BI%'   and 
                                                                reverse( ltrim(rtrim(left(reverse(exc.name),charindex( '-',reverse(exc.name))-1))))  = 
																case when tmp.grade_nome in ('extensivo','extensivo mega') then '3ª série' else tmp.grade_nome end)						 
						 join exam_exam exa on (exa.collection_id = exc.id) 
						 join auth_user usu on (json_value(usu.extra, '$.hierarchy.unity.name') = tmp.escola_NOME and 
						                        usu.public_identifier = tmp.ALUNO_ID and
						                         json_value(usu.extra, '$.hierarchy.grade.name') = tmp.grade_nome)
					left join exam_timewindow etw on (etw.exam_id = exa.id)					
					left join application_application xxx on (xxx.user_id = usu.id and 
					                                          xxx.exam_id = exa.id)
where XXX.id IS NULL   

	  select distinct ESCOLA_NOME, grade_nome, collection_nome from #temp_carga  order by 1,2

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
 --  insert into APPLICATION_APPLICATIONTIMEWINDOW (created_at, updated_at, start_time, end_time, max_duration, application_id)
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
--         car.DATA_APLICACAO is not null 
--   

------------------------------------------------------------------------------------------------------------------------

--begin tran
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

select  apa.PROVA_NOME, apa.ESCOLA_NOME, apa.EXAME_NOME, apa.GRADE_NOME, apa.ALUNO_NOME, apa.EXA_TWD_INICIO, 
       apa.EXA_TWD_TERMINO, apa.EXA_TWD_DURACAO,        apa.APP_TWD_INICIO, apa.APP_TWD_TERMINO, apa.APP_TWD_DURACAO--, 
	  -- apa.application_application_id

	  select distinct apa.EXA_TWD_TERMINO
from tmp_imp_carga_aluno_db_sa car join VW_AGENDAMENTO_PROVA_ALUNO apa on (car.ALUNO_NOME  = apa.ALUNO_NOME and 
                                                                           car.ESCOLA_NOME = apa.ESCOLA_NOME )
where --apa.PROVA_NOME like 'Desafio SAE % 3°BI%' and 
apa.escola_nome = 'COLÉGIO DOM BOSCO (BALSAS)'
order by 2,3,5



select id into #tmp_carga from application_application where id in (select distinct --apa.PROVA_NOME, apa.ESCOLA_NOME, apa.EXAME_NOME, apa.GRADE_NOME, apa.ALUNO_NOME, apa.EXA_TWD_INICIO, 
       --apa.EXA_TWD_TERMINO, apa.EXA_TWD_DURACAO,        apa.APP_TWD_INICIO, apa.APP_TWD_TERMINO, apa.APP_TWD_DURACAO, 
	   apa.application_application_id
from tmp_imp_carga_aluno_db_sa car join VW_AGENDAMENTO_PROVA_ALUNO apa on (car.ALUNO_NOME  = apa.ALUNO_NOME and 
                                                                           car.ESCOLA_NOME = apa.ESCOLA_NOME )
where apa.PROVA_NOME like 'Desafio SAE % 3°BI%') and cast(created_at as date) = '2020-09-11'

select * from auth_user where id in (151896, 269337, 277300)

select * delete ans from #tmp_carga tem join application_answer ans on (tem.id = ans.application_id)
select * delete app from #tmp_carga tem join application_application app on (tem.id = app.id)


