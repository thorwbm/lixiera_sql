select distinct 
       col.name as provas,
       json_value(usu.extra, '$.hierarchy.unity.name') as escola_nome,
	   json_value(usu.extra, '$.hierarchy.grade.name') as grade_nome, count(distinct usu.id) as quantidade_participante
from auth_user usu join application_application app on (app.user_id = usu.id) 
                   join exam_exam               exa on (exa.id = app.exam_id)
				   join exam_collection         col on (col.id = exa.collection_id)
			  left join application_answer      apw on (app.id = apw.application_id)

where exa.name like '%diagn%' and 
      (app.started_at is not null or apw.alternative_id is not null) 
group by  json_value(usu.extra, '$.hierarchy.unity.name'),
	   json_value(usu.extra, '$.hierarchy.grade.name'), col.name


order by 1, 2, 3