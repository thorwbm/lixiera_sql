with cte_tempos_prova as (
select distinct 
       usu.public_identifier, usu.name as aluno_nome, 	   
       JSON_VALUE(usu.extra, '$.hierarchy.unity.name') as escola_nome,
	   JSON_VALUE(usu.extra, '$.hierarchy.grade.name') as grade_nome,
	   col.name as prova_nome, min(app.started_at) as inicio ,max(app.finished_at) as termino

  from auth_user usu with(nolock) join application_application app with(nolock) on (usu.id = app.user_id)
                                  join exam_exam               exa with(nolock) on (exa.id = app.exam_id)
								  join exam_collection         col with(nolock) on (col.id = exa.collection_id)
 where exa.name like '%diagn%' --and 
      -- JSON_VALUE(usu.extra, '$.hierarchy.unity.name') = 'ESCOLA AMELBIT'

 group by  usu.public_identifier, usu.name , JSON_VALUE(usu.extra, '$.hierarchy.unity.name'), 
	        JSON_VALUE(usu.extra, '$.hierarchy.grade.name'),col.name
) 

		select   prova_nome, escola_nome, grade_nome, aluno_nome, public_identifier, inicio, termino, 
		       datediff(minute, inicio, termino) as tempo_decorrido_min
		  from cte_tempos_prova 
		--  where inicio is not null 
order by  case when inicio is null then 1 else 0 end ,prova_nome, escola_nome, grade_nome, aluno_nome, public_identifier