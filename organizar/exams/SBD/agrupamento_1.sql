
insert into application_application ( started_at, finished_at, exam_id, user_id, should_update_answers, timeout, forced_status, created_at, updated_at, room_id, reseted_at, reseted_by_id, bulk_create_uuid)
select distinct 
       started_at = null, finished_at  = null, exam_id = 17, user_id, should_update_answers, timeout = null, forced_status,
       created_at = getdate(), updated_at  = getdate(), room_id, reseted_at, reseted_by_id, bulk_create_uuid
  from exam_collection col join exam_exam               exa on (col.id = exa.collection_id)
                           join application_application app on (exa.id = app.exam_id) 
 where EXA.NAME LIKE '%SOCIEDADE BRASILEIRA DE DERMATOLOGIA - BLOCO%'
 and reseted_at is  null 


 insert into application_answer ( position, free_response, alternative_id, application_id, item_id, created_at, updated_at, seconds, value, timeout_date)
 select distinct 
        position = ite.position, free_response = null, alternative_id = ans.alternative_id, application_id = tem.id, item_id = ite.item_id,
        created_at = getdate(), updated_at  = getdate(), seconds = 0 , value = null, timeout_date = null
   from application_application tem  join exam_exam  exa on (exa.id = tem.exam_id)
                   join exam_examitem ite on (exa.id = ite.exam_id)
				   join application_answer ans on (ans.item_id = ite.item_id)
				   join application_application apo on (apo.id = ans.application_id and 
				                                        apo.user_id = tem.user_id)
				   join exam_exam               exo on (exo.id = apo.exam_id)
 where EXo.NAME LIKE '%SOCIEDADE BRASILEIRA DE DERMATOLOGIA - BLOCO%' and 
 EXa.NAME LIKE '%SOCIEDADE BRASILEIRA DE DERMATOLOGIA - complet%'  


 select * from application_application where user_id in (190, 283, 316, 435) order by user_id
   select *
   update usu set usu.is_active = 0 
   from auth_user usu join auth_user_groups gru on (gru.user_id = usu.id)
   where gru.group_id = 3




   select ans.* from application_application app join application_answer ans on (app.id = ans.application_id)
                                             join exam_exam          exa on (exa.id = app.exam_id)
   where exa.NAME LIKE '%SOCIEDADE BRASILEIRA DE DERMATOLOGIA - BLOCO%'
