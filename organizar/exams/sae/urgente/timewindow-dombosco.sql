--BEGIN tran;
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
                                                                     jan.simulado = json_value(usu.extra, '$.hierarchy.grade.name'))
                               LEFT JOIN application_applicationtimewindow atw ON (atw.application_id =app.id)

WHERE json_value(usu.extra, '$.hierarchy.unity.name') = 'COLEGIO BATISTA DO CARIRI'
AND atw.id IS NULL  AND exa.name like '%2º BI%'
) 
 -- INSERT INTO application_applicationtimewindow (start_time,	end_time,	max_duration,	application_id, created_at,	updated_at)
SELECT DISTINCT start_time = cast (convert(varchar(10),janela_data) + ' ' +convert(varchar(8),exam_timewindow,114) as datetime) ,	
             end_time =  dateadd(day,1,janela_data),	
			 max_duration = car.max_duration, application_id = car.application_id, 	
			 created_at = getdate(),	updated_at = getdate()--, tmw.start_time,tmw.end_time, jan.janela

FROM cte_carga car LEFT JOIN application_applicationtimewindow xxx ON (car.application_id = xxx.application_id AND 
                                                                       xxx.start_time = cast (convert(varchar(10),janela_data) + ' ' +convert(varchar(8),exam_timewindow,114) as datetime))
WHERE xxx.id IS NULL 


-- commit 

-- rollback 

SELECT  * FROM vw_app_exam_usuario_janela
WHERE --exam_nome like '%2º BI%' AND 
     escola_nome = 'EDUCANDARIO AMERICO MESQUITA' and
	 (exam_nome like '%2º BI%' or exam_nome is null) AND 
	 (grade_nome = '7º ano')    --  OR grade_nome LIKE '%extensivo%')

	 

	 SELECT DISTINCT aluno_nome, aluno_id , grade_nome
	 FROM vw_app_exam_usuario_janela 
	 WHERE escola_nome = 'COLEGIO BATISTA DO CARIRI' AND 
	       (grade_nome = '3º ano' OR grade_nome LIKE '%extensivo%') AND 
	       exam_nome like '%2º BI%'

	 SELECT DISTINCT aluno_nome, aluno_id , grade_nome, APP_TIME_WIN_INICIO
	 FROM vw_app_exam_usuario_janela USU JOIN temp_janelaaplicacao tj ON (TJ.ESCOLA = USU.E)
	 WHERE escola_nome = 'COLEGIO BATISTA DO CARIRI' AND 
	       grade_nome = '4º ano'  AND 
	       exam_nome like '%2º BI%'




--INSERT INTO application_applicationtimewindow (start_time,	end_time,	max_duration,	application_id, created_at,	updated_at)
SELECT  DISTINCT start_time = '2020-06-30 10:30:00.0000000' ,	
             end_time =  '2020-07-01 00:00:00.0000000',	
			 max_duration = tmw.max_duration, application_id = app.id, 	
			 created_at = getdate(),	updated_at = getdate()--, tmw.start_time,tmw.end_time, jan.janela
FROM application_application app JOIN auth_user usu ON (app.user_id = usu.id)
                                          JOIN exam_exam exa ON (app.exam_id = exa.id)
										  JOIN exam_timewindow tmw on (tmw.exam_id = exa.id)
									 LEFT JOIN application_applicationtimewindow xxx ON (xxx.application_id = app.id AND
									                                                     xxx.start_time = '2020-06-30 10:30:00.0000000' )
WHERE json_value (usu.extra, '$.hierarchy.unity.value') like '92bcbab56b7d692dc804e4cb5036f800' 
and exa.name like '7%2º BI%' 
and (json_value (usu.extra, '$.hierarchy.grade.name') like '%7%')
AND xxx.id IS NULL 



-- commit  