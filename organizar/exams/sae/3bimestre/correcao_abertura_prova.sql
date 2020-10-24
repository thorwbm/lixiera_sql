
with cte_alunos_50 as (
select  usu.name as usuario_nome,usu.id as usuario_id, count(app.id) as qtd_apps
  from application_application app join application_applicationtimewindow atw on (app.id = atw.application_id)
                                   join exam_exam                         exa on (exa.id = app.exam_id)  
								   join auth_user                         usu on (usu.id = app.user_id) 
								   join application_answer                ans on (app.id = ans.application_id)
where ans.alternative_id is null and 
      exa.name like '%3º BI/2020'  and 
	  app.finished_at <= '2020-10-07 15:30:00'
	  group by usu.name, usu.id
	  having count(app.id) > 50 
),

cte_prova_aluno as (
select distinct 
       col.name as prova_nome, exa.id as exame_id, usu.id as usuario_id, 
	   app.id as application_id, 
       json_value(usu.extra, '$.hierarchy.unity.name') as escola_nome, 
       json_value(usu.extra, '$.hierarchy.grade.name') as grade_nome,
       usu.public_identifier as aluno_id, usu.name as aluno_nome
  from application_application app join application_applicationtimewindow atw on (app.id = atw.application_id)
                                   join exam_exam                         exa on (exa.id = app.exam_id)  
								   join exam_collection                   col on (col.id = exa.collection_id)
								   join auth_user                         usu on (usu.id = app.user_id) 
								   join application_answer                ans on (app.id = ans.application_id)
								   join cte_alunos_50                     cte on (cte.usuario_id = app.user_id)
where ans.alternative_id is null and
      exa.name like '%3º BI/2020'  and 
	  app.finished_at <= '2020-10-07 15:30:00'
),

cte_horarios as (
 select inicio = '2020-10-13 10:30:00.0000000', termino = '2020-10-14 00:00:00.0000000' union 
 select inicio = '2020-10-14 10:30:00.0000000', termino = '2020-10-15 00:00:00.0000000'  )



 select * from cte_prova_aluno where aluno_nome = 'Miquéias Ferreira Amaral'


---   drop table bkp_application_application_reagendamento_20201008

select  distinct  app.*, prv.aluno_nome, prv.aluno_id, etw.max_duration , hor.* 
  into bkp_application_application_reagendamento_20201008
  from cte_prova_aluno  prv join application_application           app on (app.id = prv.application_id)
                            join exam_exam                         exa on (exa.id = app.exam_id)
					       	join exam_timewindow                   etw on (exa.id = etw.exam_id)
							join cte_horarios                      hor on (1 = 1) 
                       left join application_applicationtimewindow atw on (app.id = atw.application_id)
--where prv.aluno_nome = 'Miquéias Ferreira Amaral'


--select  created_at, updated_at, start_time, end_time, max_duration, application_id from application_applicationtimewindow


--   begin tran
insert into application_applicationtimewindow(created_at, updated_at, start_time, end_time, max_duration, application_id)
select created_at = getdate(), updated_at  = getdate(), start_time = inicio , end_time = termino, tmp.max_duration, application_id = app.id
  from application_application app join bkp_application_application_reagendamento_20201008 tmp on (app.id = tmp.id)    
                              left join application_applicationtimewindow                  xxx on (app.id = xxx.application_id and 
							                                                                       xxx.start_time = tmp.inicio and 
																								   xxx.end_time   = tmp.termino)
 where tmp.aluno_nome = 'Miquéias Ferreira Amaral'


 -- select distinct app.* 
   update app set app.updated_at = getdate(), app.reseted_at = getdate(), app.reseted_by_id = 4 , app.started_at = null, app.finished_at = null, app.timeout = null
   from application_application app join bkp_application_application_reagendamento_20201008 tmp on (app.id = tmp.id)                                 
 where tmp.aluno_nome = 'Miquéias Ferreira Amaral'

 commit 

 --   select * from bkp_application_application_reagendamento_20201008  where aluno_nome = 'Miquéias Ferreira Amaral' order by aluno_nome -- 1553


 select top 100 * from auth_user where last_name like '%priscilla%'
 

 select * from application_answer where application_id in (
   select distinct id from bkp_application_application_reagendamento_20201008  where aluno_nome = 'Miquéias Ferreira Amaral')