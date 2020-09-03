--select * from tmp_imp_escola_2dia  where nome_escola_ava = 'SOCIEDADE EDUCACIONAL DOM OTAVIO AGUIAR LTDA'


drop table  #temp_carga

--------  CRIAR TABELA TEMPORARIA PARA CARGA -------------------------
select exa.id as exam_id, usu.id as user_id, should_update_answers = 0, timeout = null, forced_status = null, created_at = getdate(), updated_at = getdate(), 
       tmp.SERIE, etw.max_duration as max_duration, 
	   --start_time = cast (convert(varchar(10),tmp.janela_aplicacao,120) + ' ' +convert(varchar(8),etw.start_time,114) as datetime) ,	
       --end_time =  dateadd(day,1,tmp.janela_aplicacao), 
	   nome_escola = tmp.ESCOLA--, serie = tmp.avaliacao_diagnostica
	   ,usu.name as aluno
into #temp_carga
from exam_collection exc join tmp_imp_carga_final tmp on  ( case when  ltrim(rtrim(left(exc.name,charindex( '-',exc.name)-1))) = '3� s�rie' then 'extensivo' else ltrim(rtrim(left(exc.name,charindex( '-',exc.name)-1))) end= tmp.SERIE and 
                                                                       reverse( ltrim(rtrim(left(reverse(exc.name),charindex( '-',reverse(exc.name))-1)))) = DIA) 
						 join exam_exam exa on (exa.collection_id = exc.id) 
						 join auth_user usu on (json_value(usu.extra, '$.hierarchy.unity.name') = tmp.ESCOLA and 
						                        json_value(usu.extra, '$.hierarchy.grade.name') = tmp.SERIE)
					left join tmp_imp_bloquear blk on (blk.nome_escola_ava = tmp.ESCOLA and 
					                                   blk.simulado_bimestral = tmp.SERIE and 
													   blk.janela_aplicacao = 'BLOQUEAR')
					left join exam_timewindow etw on (etw.exam_id = exa.id)
					left join application_application xxx on (xxx.user_id = usu.id and 
					                                          xxx.exam_id = exa.id)
where charindex( '-',exc.name) > 0 AND 
      exc.name like '%Diagn�stica%' and 
      XXX.id IS NULL  and 
	 -- usu.public_identifier  in ('32114efb08791124301ef462a249a570') and 
	  tmp.ESCOLA =  'Col�gio Uni�o' and 
	  TMP.DIA = '2� Dia'  AND 
	  blk.nome_escola_ava is null 

	--  select tmp.*, exa.name
	  delete car 
	  from #temp_carga car join tmp_imp_escola_2dia tmp on (tmp.nome_escola_ava = car.nome_escola and tmp.avaliacao_diagnostica = car.serie and tmp.lingua_espanhol = 'bloquear') 
	                                join exam_exam exa on (exa.id = car.exam_id)
	  where exa.name like '%L�ngua Espanhola%'


	  	--  select tmp.*, exa.name 
		  delete car 
		  from #temp_carga car join tmp_imp_escola_2dia tmp on (tmp.nome_escola_ava = car.nome_escola and tmp.avaliacao_diagnostica = car.serie and tmp.lingua_ingles = 'bloquear') 
	                                join exam_exam exa on (exa.id = car.exam_id)
	  where exa.name like '%L�ngua Inglesa%'

	  select * from tmp_imp_carga_final where escola =  'Col�gio Uni�o' 
	  select  DISTINCT nome_escola, serie from #temp_carga   where aluno = 'Ana Cecilia Oliveira Da Silva' order by 1
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



 commit 
-- rollback 
