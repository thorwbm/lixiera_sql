BEGIN tran;
WITH cte_carga AS (
SELECT   distinct usu.name as usuario_nome, app.id AS application_id, 
         json_value(usu.extra, '$.hierarchy.unity.value') AS escola_id,  json_value(usu.extra, '$.hierarchy.unity.name') AS escola_nome, 
         json_value(usu.extra, '$.hierarchy.grade.name') AS grade, 
         exa.name AS exam_nome, 
         tmw.start_time AS exam_timewindow,tmw.max_duration,
         atw.start_time AS application_timewindow, cast(jan.janela AS date) AS janela_data
  FROM application_application app JOIN exam_exam exa ON (exa.id = app.exam_id)
                                   JOIN auth_user usu ON (usu.id = app.user_id)
                                   JOIN exam_timewindow tmw ON (tmw.exam_id = exa.id)
                                   JOIN temp_janelaaplicacao jan ON (jan.escola = json_value(usu.extra, '$.hierarchy.unity.name') AND 
                                                                     jan.simulado = '3ª série')
                               LEFT JOIN application_applicationtimewindow atw ON (atw.application_id =app.id)

WHERE json_value(usu.extra, '$.hierarchy.grade.name') LIKE '%extensivo%' AND 
      atw.id IS NULL  AND 
      exa.name like '%2º BI%' AND 
      jan.janela IS NOT NULL 
)

  INSERT INTO application_applicationtimewindow (start_time,	end_time,	max_duration,	application_id, created_at,	updated_at)
SELECT DISTINCT start_time = cast (convert(varchar(10),janela_data) + ' ' +convert(varchar(8),exam_timewindow,114) as datetime) ,	
             end_time =  dateadd(day,1,janela_data),	
			 max_duration = car.max_duration, application_id = car.application_id, 	
			 created_at = getdate(),	updated_at = getdate()--, tmw.start_time,tmw.end_time, jan.janela

FROM cte_carga car LEFT JOIN application_applicationtimewindow xxx ON (car.application_id = xxx.application_id AND 
                                                                       xxx.start_time = cast (convert(varchar(10),janela_data) + ' ' +convert(varchar(8),exam_timewindow,114) as datetime))
WHERE xxx.id IS NULL 

-- commit 
-- rollback 
