SELECT * FROM exam_collection 
WHERE NAME LIKE 'SOCIEDADE BRASILEIRA DE DERMATOLOGIA - %'

--INSERT INTO EXAM_COLLECTION
SELECT created_at = GETDATE(), updated_at= GETDATE(), name = 'SOCIEDADE BRASILEIRA DE DERMATOLOGIA - COMPLETA', 
       start_time, end_time, max_duration, share_timeouts, instructions, can_disclose_report, pdf_zip_key, 
	   report_card_decimal_places, application_configuration_id, default_room_capacity, show_application_after_timeout, 
	   can_pre_register
	   FROM EXAM_COLLECTION
	   WHERE ID = 10

-- INSERT INTO EXAM_EXAM (namE, shuffle_items, extra, external_id, instructions, created_at, updated_at, collection_id, report_card_decimal_places)
SELECT  namE = 'SOCIEDADE BRASILEIRA DE DERMATOLOGIA - COMPLETA', shuffle_items, extra, external_id = 10, instructions, 
        created_at = GETDATE(), updated_at = GETDATE(), collection_id = 23, report_card_decimal_places
		FROM EXAM_EXAM 
WHERE collection_id = 10

select * from exam_exam

SELECT EXA.NAME, row_number() over(order by  EXA.NAME, item_id) ,*



-- insert into exam_examitem (position, exam_id, item_id, created_at, updated_at, value, is_cancelled, justification) 
select position =row_number() over(order by  EXA.NAME, item_id), exam_id = 17, ITE.item_id, ITE.created_at, ITE.updated_at, ITE.value, ITE.is_cancelled, ITE.justification
 FROM exam_examitem ITE JOIN EXAM_EXAM EXA ON (EXA.id = ITE.exam_id)
 WHERE EXA.NAME LIKE '%SOCIEDADE BRASILEIRA DE DERMATOLOGIA - BLOCO%'
 ORDER BY EXA.NAME, item_id



 


select distinct 
       started_at = null, finished_at  = null, exam_id = 17, user_id, should_update_answers, timeout = null, forced_status,
       created_at = getdate(), updated_at  = getdate(), room_id, reseted_at, reseted_by_id, bulk_create_uuid
	   into #temp
  from exam_collection col join exam_exam               exa on (col.id = exa.collection_id)
                           join application_application app on (exa.id = app.exam_id)
 where EXA.NAME LIKE '%SOCIEDADE BRASILEIRA DE DERMATOLOGIA - BLOCO%'


 select position = ite.position, free_response = null, alternative_id = null, application_id = tem.exam_id, item_id = ite.item_id,
        created_at = getdate(), updated_at  = getdate(), seconds = 0 , value = null, timeout_date = null
   from #temp tem  join exam_exam  exa on (exa.id = tem.exam_id)
                   join exam_examitem ite on (exa.id = ite.exam_id)


   select * from application_answer