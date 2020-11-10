
SELECT * 
from exam_exam exa join exam_collection                    col on (col.id = exa.collection_id)
				   join tmp_exam_colletion_sbp             tmp on (tmp.collection_id = col.id and
						                                           tmp.exam_id       = exa.id)


SELECT * FROM vw_quantidade_por_collection 

WHERE FINALIZADO = 1

SELECT * FROM tmp_exam_colletion_sbp

SELECT * FROM AUTH_USER WHERE ID = 2728



create OR ALTER  view vw_quantidade_por_collection as  
select distinct col.id as collection_id, app.user_id , 
       CASE WHEN APP.started_at IS NOT NULL                         THEN 1 ELSE 0 END AS INCIADO,	   
       CASE WHEN APP.started_at IS NOT NULL AND finished_at IS NULL THEN 1 ELSE 0 END AS EM_EXECUCAO,
	   CASE WHEN finished_at    IS NOT NULL                         THEN 1 ELSE 0 END AS FINALIZADO
from application_application app join exam_exam exa on (exa.id = app.exam_id)  
                                 join exam_collection col on (col.id = exa.collection_id)  
								 JOIN tmp_exam_colletion_sbp TEC ON (TEC.exam_id = APP.exam_id)
  



  SELECT * FROM APPLICATION_APPLICATION APP JOIN tmp_exam_colletion_sbp TEC ON (TEC.exam_id = APP.exam_id)
  
  WHERE USER_ID = 2728


  

  SELECT * DELETE FROM APPLICATION_APPLICATION WHERE ID IN (16421, 16094, 16095, 16096, 16097)

  
  
  SELECT * DELETE FROM application_answerlog WHERE APPLICATION_ID IN (16421, 16094, 16095, 16096, 16097)
  
  SELECT * DELETE FROM application_answer WHERE APPLICATION_ID IN (16421, 16094, 16095, 16096, 16097)
  SELECT * DELETE FROM application_applicationtimewindow WHERE APPLICATION_ID IN (16421, 16094, 16095, 16096, 16097)