
select *
--update tmp set tmp.serie = '3ª série'
from TMP_IMP_ESCOLA_AGENDAMENTO tmp where escola_nome = 'COLEGIO EVOLUCAO' and serie = 'extensivo'
SELECT TOP 50 * FROM TMP_IMP_ESCOLA_BLOQUEADA where ESCOLA_NOME = 'COLEGIO EVOLUCAO'

drop table  #temp_carga

--------  CRIAR TABELA TEMPORARIA PARA CARGA -------------------------
select exa.id as exam_id, usu.id as user_id, should_update_answers = 0, timeout = null, forced_status = null, 
       created_at = cast( getdate() as datetime), updated_at = cast( getdate() as datetime), 
       tmp.serie, etw.max_duration as max_duration, 
	   start_time = cast (convert(varchar(10),TMP.DATA_APLICACAO,120) + ' ' +convert(varchar(8),etw.start_time,114) as datetime) ,	
       end_time =  dateadd(day,1,TMP.DATA_APLICACAO),
	   ESCOLA_NOME = tmp.ESCOLA_NOME, exc.name as collection_nome, TMP.DATA_APLICACAO, EXA.NAME AS EXAME_NOME
into #temp_carga
--SELECT *
from exam_collection exc join TMP_IMP_ESCOLA_AGENDAMENTO tmp on (EXC.NAME like 'Desafio SAE % 3°BI%'   and
                                                                 reverse( ltrim(rtrim(left(reverse(exc.name),charindex( '-',reverse(exc.name))-1)))) =
																 case when TMP.SERIE in ('extensivo','extensivo mega') then '3ª série' else  TMP.SERIE end )
						 join exam_exam exa on (exa.collection_id = exc.id) 
						 join auth_user usu on (json_value(usu.extra, '$.hierarchy.unity.name') = tmp.escola_NOME and 
						                         json_value(usu.extra, '$.hierarchy.grade.name') = tmp.serie)
						                       -- case when json_value(usu.extra, '$.hierarchy.grade.name') in ('extensivo','extensivo mega') then '3ª série' else json_value(usu.extra, '$.hierarchy.grade.name') end = tmp.serie)						
					left join exam_timewindow etw on (etw.exam_id = exa.id)
					--LEFT JOIN TMP_IMP_ESCOLA_BLOQUEADA BLK ON (BLK.ESCOLA_NOME = TMP.ESCOLA_NOME AND 
					--                                           BLK.SERIE = TMP.SERIE AND 
					--										   BLK.PROCESSO = TMP.PROCESSO)
					left join application_application xxx on (xxx.user_id = usu.id and 
					                                          xxx.exam_id = exa.id)
where charindex( '-',exc.name) > 0 AND 
	 -- tmp.SERIE = '3ª série' and 
      exc.name like 'Desafio SAE % 3°BI%' and 
	  --tmp.ESCOLA_NOME = 'CENTRO CULTURAL MANILHA' and 
	  --TMP.SERIE IN ('extensivo','extensivo mega','3ª série') AND 
	  json_value(usu.extra, '$.hierarchy.unity.value') = '6db64e812c6b1a6ede239eacf2eb48fa' and 
      XXX.id IS NULL  and 
	  BLK.ESCOLA_NOME IS NULL  
	  -----------------------------------------
	 delete tmp 
	 -- select *
	 FROM #temp_carga TMP JOIN TMP_IMP_ESCOLA_AGENDAMENTO IEA ON (TMP.ESCOLA_NOME = IEA.ESCOLA_NOME AND 
	                                                                       TMP.SERIE       = IEA.SERIE AND INGLES = 'BLOQUEAR' AND TMP.EXAME_NOME LIKE '%Língua Inglesa%')
	  -----------------------------------------
	 DELETE TMP 
	 -- select *
	 FROM #temp_carga TMP JOIN TMP_IMP_ESCOLA_AGENDAMENTO IEA ON (TMP.ESCOLA_NOME = IEA.ESCOLA_NOME AND 
	                                                                       TMP.SERIE       = IEA.SERIE AND ESPANHOL = 'BLOQUEAR' AND TMP.EXAME_NOME LIKE '%Língua Espanhola%')
	  -----------------------------------------
	 DELETE TMP FROM #temp_carga TMP JOIN TMP_IMP_ESCOLA_AGENDAMENTO IEA ON (TMP.ESCOLA_NOME = IEA.ESCOLA_NOME AND 
	                                                                       TMP.SERIE       = IEA.SERIE AND ARTES = 'BLOQUEAR' AND TMP.EXAME_NOME LIKE '%ARTE%')
	  -----------------------------------------
	 DELETE TMP FROM #temp_carga TMP JOIN TMP_IMP_ESCOLA_AGENDAMENTO IEA ON (TMP.ESCOLA_NOME = IEA.ESCOLA_NOME AND 
	                                                                       TMP.SERIE       = IEA.SERIE AND FILOSOFIA= 'BLOQUEAR' AND TMP.EXAME_NOME LIKE '%Filosofia%')
	  -----------------------------------------
	 DELETE TMP FROM #temp_carga TMP JOIN TMP_IMP_ESCOLA_AGENDAMENTO IEA ON (TMP.ESCOLA_NOME = IEA.ESCOLA_NOME AND 
	                                                                       TMP.SERIE       = IEA.SERIE AND SOCIOLOGIA= 'BLOQUEAR' AND TMP.EXAME_NOME LIKE '%SOCIOLOGIA%')
	  

	  select distinct serie, ESCOLA_NOME from #temp_carga ORDER BY 2


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
         car.DATA_APLICACAO is not null 
   

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



