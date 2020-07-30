 BEGIN tran;
WITH cte_janela AS (
 SELECT jap.* ,
 vteg.grade_id, 
 vteg.escola_id
FROM temp_janelaaplicacao jap JOIN vw_turma_escola_grade vteg ON (jap.escola = vteg.escola_nome AND jap.simulado = vteg.grade_nome) 		               
WHERE NOT EXISTS (SELECT 1 FROM temp_bloqueados tb 
                   WHERE tb.escola = jap.escola AND 
				         tb.simulado = jap.simulado) 
AND  jap.janela is not null  AND simulado = '3ª série'
 )


 INSERT INTO application_applicationtimewindow (start_time,	end_time,	max_duration,	application_id, created_at,	updated_at)

SELECT  DISTINCT start_time = cast (convert(varchar(10),jan.janela,120) + ' ' +convert(varchar(8),tmw.start_time,114) as datetime) ,	
             end_time =  dateadd(day,1,jan.janela),	
			 max_duration = tmw.max_duration, application_id = app.id, 	
			 created_at = getdate(),	updated_at = getdate()--, tmw.start_time,tmw.end_time, jan.janela

FROM application_application app JOIN auth_user usu ON (app.user_id = usu.id)
                                          JOIN exam_exam exa ON (app.exam_id = exa.id)
										  JOIN exam_timewindow tmw on (tmw.exam_id = exa.id)
										  JOIN cte_janela      jan ON (jan.escola_id = JSON_VALUE(usu.extra, '$.hierarchy.unity.value') AND 
										                               jan.grade_id =  JSON_VALUE(usu.extra,  '$.hierarchy.grade.value') )
										  JOIN application_applicationtimewindow xxx ON (xxx.application_id = app.id AND 
										                                                 xxx.start_time = cast (convert(varchar(10),jan.janela,120) + ' ' +convert(varchar(8),tmw.start_time,114) as datetime))

WHERE exa.name like '%2º BI%' AND jan.janela IS NOT NULL 
    
SELECT distinct simulado FROM temp_janelaaplicacao WHERE simulado LIKE '%3%'
	-- commit 
	-- ROLLBACK  

	SELECT ET.* 
	  FROM exam_exam EXA JOIN exam_timewindow et ON EXA.id = et.exam_id
	WHERE exa.name like '%2º BI%'                      
	case when JSON_VALUE(u.extra, '$.hierarchy.grade.value') = '01E01411-D828-4F80-8264-B7587B1F4987' THEN 'EC369C51-44F6-4B5D-8E5D-2B3927C38B2F' ELSE JSON_VALUE(u.extra, '$.hierarchy.grade.value') end