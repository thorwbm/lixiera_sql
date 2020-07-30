
select * from temp_alunos where escolanome like 'Escola Evolução' and usuarioserie  LIKE '%1%'

select * from auth_user usu
where JSON_VALUE(usu.extra, '$.hierarchy.grade.name') LIKE '%1%' and 
      JSON_VALUE(usu.extra, '$.hierarchy.unity.name') = 'Escola Evolução'


SELECT *
-- select distinct grade_nome 
FROM vw_app_exam_usuario_janela
WHERE
     escola_nome like 'Escola Evolução' and
	 (exam_nome like '%2º BI%') or exam_nome is null ) AND 
	 (grade_nome  LIKE '%1%') OR
grade_nome LIKE '%extensivo%') 



-- begin tran insert into application_application (exam_id, user_id, should_update_answers, created_at, updated_at)
select distinct exam_id = exa.id, user_id = usu.id, should_update_answers = 0, created_at = GETDATE(), 
updated_at = GETDATE()  -- , JSON_VALUE(usu.extra, '$.hierarchy.unity.name') AS escola
FROM auth_user usu  join exam_exam exa on (exa.name LIKE '2%2º BI%') /****** CONFERIR ******/
                 LEFT JOIN application_application xxx ON (xxx.user_id = usu.id AND xxx.exam_id = exa.id)
WHERE (--JSON_VALUE(usu.extra, '$.hierarchy.grade.name') LIKE '%extensivo%' OR 
       JSON_VALUE(usu.extra, '$.hierarchy.grade.name') LIKE '%2%' ) AND  /****** CONFERIR ******/
      JSON_VALUE(usu.extra, '$.hierarchy.unity.value') = '4f9f6a088c15655d5eee859dbbe7f973'  /****** CONFERIR ******/
	  AND xxx.id IS  NULL 

-- commit 
-- rollback 

--  begin tran      insert into application_answer ([position], application_id, item_id, created_at, updated_at, seconds)
SELECT  distinct ite.position, application_id = app.id, ite.item_id, created_at = GETDATE(), updated_at = GETDATE(), seconds = 0
  FROM application_application app JOIN exam_exam          exa ON (app.exam_id = exa.id)
                                   JOIN exam_examitem      ite ON (ite.exam_id = exa.id)
								   JOIN auth_user          usu ON (usu.id      = app.user_id)
                              LEFT JOIN application_answer xxx ON (xxx.application_id = app.id AND 
							                                       xxx.item_id = ite.item_id)			                 
 WHERE exa.name  like '2%2º BI%' AND  /****** CONFERIR ******/
       JSON_VALUE(usu.extra, '$.hierarchy.unity.value') = '4f9f6a088c15655d5eee859dbbe7f973'  AND  /****** CONFERIR ******/
       xxx.id IS NULL 

-- commit 
-- rollback 

--begin tran INSERT INTO application_applicationtimewindow (start_time,	end_time,	max_duration,	application_id, created_at,	updated_at)
SELECT  DISTINCT start_time = '2020-07-10 10:30:00.0000000' ,	
             end_time =  '2020-07-11 00:00:00.0000000',	
			 max_duration = tmw.max_duration, application_id = app.id, 	
			 created_at = getdate(),	updated_at = getdate() --, usu.name, tmw.start_time,tmw.end_time
FROM application_application app JOIN auth_user usu ON (app.user_id = usu.id)
                                          JOIN exam_exam exa ON (app.exam_id = exa.id)
										  JOIN exam_timewindow tmw on (tmw.exam_id = exa.id)
								     LEFT JOIN application_applicationtimewindow xxx ON (xxx.application_id = app.id AND
									                                                     xxx.start_time = '2020-07-10 10:30:00.0000000'  )

WHERE json_value (usu.extra, '$.hierarchy.unity.value') = '4f9f6a088c15655d5eee859dbbe7f973' /****** CONFERIR ******/
and exa.name like '2%2º BI%'  /****** CONFERIR ******/
and (json_value (usu.extra, '$.hierarchy.grade.name') like '%2%')  /****** CONFERIR ******/-- OR json_value (usu.extra, '$.hierarchy.grade.name') like '%extensivo%')
AND xxx.id IS NULL 
-- commit
-- rollbacak 




/*
--INSERT INTO application_applicationtimewindow (start_time,	end_time,	max_duration,	application_id, created_at,	updated_at)
SELECT  DISTINCT start_time = '2020-07-03 10:30:00.0000000' ,	
             end_time =  '2020-07-04 00:00:00.0000000',	
			 max_duration = tmw.max_duration, application_id = app.id, 	
			 created_at = getdate(),	updated_at = getdate()--, tmw.start_time,tmw.end_time, jan.janela
FROM application_application app JOIN auth_user usu ON (app.user_id = usu.id)
                                          JOIN exam_exam exa ON (app.exam_id = exa.id)
										  JOIN exam_timewindow tmw on (tmw.exam_id = exa.id)
									 LEFT JOIN application_applicationtimewindow xxx ON (xxx.application_id = app.id AND
									                                                     xxx.start_time = '2020-07-03 10:30:00.0000000' )
WHERE json_value (usu.extra, '$.hierarchy.unity.value') like 'd17e519b163fcaf2fe210d3424428d51'
and exa.name like '3%2º BI%' 
and (json_value (usu.extra, '$.hierarchy.grade.name') like '%3%' OR json_value (usu.extra, '$.hierarchy.grade.name') like '%extensivo%')
AND xxx.id IS NULL 
*