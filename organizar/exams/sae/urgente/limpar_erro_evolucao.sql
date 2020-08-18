SELECT app.id as application_id into #temp_app
FROM auth_user usu JOIN application_application app ON (app.user_id = usu.id)
                            JOIN exam_exam               exa ON (app.exam_id = exa.id)
WHERE exa.name LIKE '%2º BI%' AND 
      JSON_VALUE(usu.extra, '$.hierarchy.unity.value') = 'b9c33cfe465ae4ca2b85e1fcf655b06f'


select apw.id as application_answer_id  into #temp_apw
from application_answer apw join #temp_app tem on (apw.application_id = tem.application_id)

select atw.id as application_timewindow_id into #temp_atw
from application_applicationtimewindow atw join #temp_app tem on (atw.application_id = tem.application_id)


----------------------------------------------------------------------------------------------------------
-- limpar time window
select * --into tmp_application_applicationtimewindow_2020_06_30
-- begin tran delete atw
from application_applicationtimewindow atw join #temp_atw tem on (tem.application_timewindow_id = atw.id)
where cast(atw.created_at as date)  = '2020-06-29'


-- limpar answer
select * --into tmp_application_answer_2020_06_30
-- begin tran delete apw
from application_answer apw  join #temp_apw tem on (tem.application_answer_id = apw.id)
where cast(apw.created_at as date)  = '2020-06-29'
-- limpar application
select * --into tmp_application_application_2020_06_30
-- begin tran delete app
from application_application app  join #temp_app tem on (tem.application_id = app.id)
where cast(app.created_at as date)  = '2020-06-29'

-- commit 
-- rollback 