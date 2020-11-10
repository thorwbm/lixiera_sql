--   drop table #tmp_carga
declare @criado_em datetime = dbo.getlocaldate()

select distinct 
       started_at = null, finished_at = null, cle.exam_id,user_id = usu.id,should_update_answers = 0,timeout = null,forced_status = null,
       created_at = @criado_em, updated_at = @criado_em,room_id,reseted_at = null,reseted_by_id = null
	   
  --into #tmp_carga
 --select *
  from tmp_imp_4bi_ultima_semana ult join auth_user                   usu on (ult.escola_id        = json_value(usu.extra, '$.hierarchy.unity.value'))
                                     join VW_COLLECTION_EXAM_4BI      cle on (cle.COLLECTION_GRADE = json_value(usu.extra, '$.hierarchy.grade.name'))
								LEFT JOIN tmp_imp_4bi_agendamento_blk BLK ON (BLK.escolaNome       = ULT.escola_nome AND
								                                              BLK.SERIE = CLE.COLLECTION_GRADE)
							    left join application_application     app on (app.user_id = usu.id and 
								                                              app.exam_id = cle.exam_id)
where app.id is null  AND 
      BLK.ESCOLANOME IS NULL 

	------------------------------------------------------------------------------------------------------------------------
-- CARGA NA APPLICATION_APPLICATION --
---insert into application_application (exam_id, user_id, should_update_answers, timeout, forced_status, created_at, updated_at)
select distinct  CAR.exam_id, CAR.user_id, CAR.should_update_answers, null, CAR.forced_status, CAR.created_at, CAR.updated_at
from #tmp_carga CAR left join application_application xxx on (xxx.user_id = CAR.user_id and 
					                                          xxx.exam_id = CAR.exam_id)
where XXX.ID is null 
------------------------------------------------------------------------------------------------------------------------
 --begin tran
--insert into application_answer (position, application_id, item_id, created_at, updated_at, value, seconds)
select distinct  ite.position, app.id as application_id, ite.item_id as item_id, car.created_at, car.updated_at, value = 0, seconds = 0
  from #tmp_carga CAR join application_application app on (app.user_id = CAR.user_id and 
					                                        app.exam_id = CAR.exam_id)
					   join exam_examitem           ite on (ite.exam_id = car.exam_id)
				  left join application_answer      xxx on (xxx.application_id = app.id and
				                                            xxx.item_id        = ite.item_id)
where xxx.id is null 

--  #######################################################################################################################################

--   drop table #tmp_carga_extensivo
declare @criado_em datetime = dbo.getlocaldate()

select distinct 
       started_at = null, finished_at = null, cle.exam_id,user_id = usu.id,should_update_answers = 0,timeout = null,forced_status = null,
       created_at = @criado_em, updated_at = @criado_em,room_id,reseted_at = null,reseted_by_id = null
	   
  into #tmp_carga_extensivo
  from tmp_imp_4bi_ultima_semana ult join auth_user                   usu on (ult.escola_id        = json_value(usu.extra, '$.hierarchy.unity.value'))
                                     join VW_COLLECTION_EXAM_4BI      cle on (cle.COLLECTION_GRADE =  '3ª série' and
                                                                              json_value(usu.extra, '$.hierarchy.grade.name') in ('3ª série', 'extensivo', 'Extensivo Mega'))
								LEFT JOIN tmp_imp_4bi_agendamento_blk BLK ON (BLK.escolaNome       = ULT.escola_nome AND
								                                              BLK.SERIE = CLE.COLLECTION_GRADE)
							    left join application_application     xxx on (xxx.user_id = usu.id and 
								                                              xxx.exam_id = cle.exam_id)
where xxx.id is null  AND 
      BLK.ESCOLANOME IS NULL 

------------------------------------------------------------------------------------------------------------------------
-- CARGA NA APPLICATION_APPLICATION --
---insert into application_application (exam_id, user_id, should_update_answers, timeout, forced_status, created_at, updated_at)
select distinct  CAR.exam_id, CAR.user_id, CAR.should_update_answers, null, CAR.forced_status, CAR.created_at, CAR.updated_at
from #tmp_carga_extensivo CAR left join application_application xxx on (xxx.user_id = CAR.user_id and 
					                                          xxx.exam_id = CAR.exam_id)
where XXX.ID is null 
------------------------------------------------------------------------------------------------------------------------
 --begin tran
--insert into application_answer (position, application_id, item_id, created_at, updated_at, value, seconds)
select distinct  ite.position, app.id as application_id, ite.item_id as item_id, car.created_at, car.updated_at, value = 0, seconds = 0
  from #tmp_carga_extensivo CAR join application_application app on (app.user_id = CAR.user_id and 
					                                        app.exam_id = CAR.exam_id)
					   join exam_examitem           ite on (ite.exam_id = car.exam_id)
				  left join application_answer      xxx on (xxx.application_id = app.id and
				                                            xxx.item_id        = ite.item_id)
where xxx.id is null 



