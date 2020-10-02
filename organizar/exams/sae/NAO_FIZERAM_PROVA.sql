
with cte_alunos_resposta as (
select app.user_id, sum( case when ans.alternative_id is null then 0 else 1 end) as resposta, 
       cast(isnull(atw.start_time, etw.start_time) as date) as data_inicio,
	   exa.name as exame_nome
from application_answer ans join application_application app on (app.id = ans.application_id)
                            join exam_exam               exa on (exa.id = app.exam_id)
							join exam_timewindow         etw on (etw.exam_id = exa.id)
							join application_applicationtimewindow atw on (atw.application_id = app.id)
where exa.name =  '1ª série - Matemática - Diagnóstica 2/2020 - 2º dia'
group by app.user_id, cast(isnull(atw.start_time, etw.start_time) as date), exa.name
)


select res.exame_nome, 
json_value(usu.extra, '$.hierarchy.unity.name') as escola_nome,usu.name, usu.public_identifier
 from cte_alunos_resposta res join auth_user usu on (usu.id = res.user_id)
where data_inicio = '2020-09-30' and 
       resposta = 0
	   order by 1,2,3