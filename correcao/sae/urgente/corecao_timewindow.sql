select atw.*, escola_nome

--begin tran delete atw
from vw_app_exam_usuario_janela ja join application_applicationtimewindow atw on (ja.app_time_win_id = atw.id)
where --aluno_nome = 'ana luiza cantuário dias teixeira' and
      grade_nome = '9º ano' and 
	  exam_nome like '9º ano%2º BI/2020' and 
	  escola_nome = 'Centro de Integração Escolar Dom Bosco'

-- commit
-- rollback 

insert into application_applicationtimewindow (created_at, updated_at, start_time, end_time, max_duration,application_id)
select  distinct created_at = getdate(), updated_at = getdate(), start_time = '2020-07-03 10:30:00.0000000',end_time = '2020-07-04 00:00:00.0000000',
               max_duration = ja.exam_max_duration, application_id = ja.application_id
from vw_app_exam_usuario_janela ja left join application_applicationtimewindow xxx on (xxx.application_id = ja.application_id and 
                                                                                       xxx.start_time = '2020-07-03 10:30:00.0000000')
where --aluno_nome = 'ana luiza cantuário dias teixeira' and
      grade_nome = '9º ano' and 
	  exam_nome like '9º ano%2º BI/2020' and 
	  escola_nome = 'Centro de Integração Escolar Dom Bosco' and
	  xxx.id is null 



