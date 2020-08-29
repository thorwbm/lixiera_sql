select distinct atw.* 
from application_applicationtimewindow atw join application_application app on (app.id = atw.application_id)
                                           join auth_user               usu on (usu.id = app.user_id)
										   join TMP_IMP_AGENDAMENTO_EXTRA ext on (ext.nome_escola_ava = json_value(usu.extra, '$.hierarchy.unity.name') and
										                                          ext.avaliacao_diagnostica =  json_value(usu.extra, '$.hierarchy.grade.name') )

where cast(atw.created_at as date)= '2020-08-27'