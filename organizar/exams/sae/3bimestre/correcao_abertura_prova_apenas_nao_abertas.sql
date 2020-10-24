
with cte_alunos_50 as (
select  usu.name as usuario_nome,usu.id as usuario_id
  from application_application app join application_applicationtimewindow atw on (app.id = atw.application_id)
                                   join exam_exam                         exa on (exa.id = app.exam_id)  
								   join auth_user                         usu on (usu.id = app.user_id) 
								   join application_answer                ans on (app.id = ans.application_id)
where ans.alternative_id is null and 
      exa.name like '%3º BI/2020'  and --usu.name = 'Camile Vitória Del Roio' and 
	  app.finished_at <= '2020-10-08 15:30:00'
	  group by usu.name, usu.id
	  
),


cte_qtd_application as (
select usu.name as aluno_nome, usu.id as aluno_id, count(distinct app.id) as qtd_application 
  from application_application app join auth_user usu on (usu.id = user_id)
  group by usu.name, usu.id
),

cte_prova_aluno as (
select distinct 
       col.name as prova_nome, exa.id as exame_id, usu.id as usuario_id, 
	   app.id as application_id, 
       json_value(usu.extra, '$.hierarchy.unity.name') as escola_nome, 
       json_value(usu.extra, '$.hierarchy.grade.name') as grade_nome,
       usu.public_identifier as aluno_id, usu.name as aluno_nome, qtd.qtd_application
  from application_application app join application_applicationtimewindow atw on (app.id = atw.application_id)
                                   join exam_exam                         exa on (exa.id = app.exam_id)  
								   join exam_collection                   col on (col.id = exa.collection_id)
								   join auth_user                         usu on (usu.id = app.user_id) 
								   join application_answer                ans on (app.id = ans.application_id)
								   join cte_alunos_50                     cte on (cte.usuario_id = app.user_id)
								   join cte_qtd_application               qtd on (qtd.aluno_id = app.user_id and 
								                                                  qtd.qtd_application > 50)
where ans.alternative_id is null and
      exa.name like '%3º BI/2020'  
),

cte_horarios as (
 select inicio = '2020-10-13 10:30:00.0000000', termino = '2020-10-14 00:00:00.0000000' union 
 select inicio = '2020-10-14 10:30:00.0000000', termino = '2020-10-15 00:00:00.0000000'  ), 

 cte_exclusao as (
  select ans.application_id
  from cte_prova_aluno tmp  join application_answer ans on (tmp.application_id = ans.application_id)
  group by  ans.application_id
  having  count(ans.alternative_id) = 0) 

---   drop table bkp_application_application_reagendamento_20201008_ignacio

select  distinct  app.*, prv.aluno_nome, prv.aluno_id, etw.max_duration , hor.* , prv.qtd_application
  into bkp_application_application_reagendamento_20201008_ignacio
  from cte_prova_aluno  prv join application_application           app on (app.id = prv.application_id)
                            join exam_exam                         exa on (exa.id = app.exam_id)
					       	join exam_timewindow                   etw on (exa.id = etw.exam_id)
							join cte_horarios                      hor on (1 = 1) 
					   left join cte_exclusao                      exc on (app.id = exc.application_id)
                       left join application_applicationtimewindow atw on (app.id = atw.application_id)
  where exc.application_id is not null  and 
  prv.aluno_nome <> 'Rafael Henriko Da Silva'
--where prv.aluno_nome = 'Miquéias Ferreira Amaral'


--select  created_at, updated_at, start_time, end_time, max_duration, application_id from application_applicationtimewindow


--   begin tran
insert into application_applicationtimewindow(created_at, updated_at, start_time, end_time, max_duration, application_id)
select created_at = getdate(), updated_at  = getdate(), start_time = inicio , end_time = termino, tmp.max_duration, application_id = app.id
  from application_application app join bkp_application_application_reagendamento_20201008_novo tmp on (app.id = tmp.id)    
                              left join application_applicationtimewindow                  xxx on (app.id = xxx.application_id and 
							                                                                       xxx.start_time = tmp.inicio and 
																								   xxx.end_time   = tmp.termino)
 where tmp.aluno_nome = 'rafael borges ramos'
 order by app.id

 -- select distinct app.* 
   update app set app.updated_at = getdate(), app.reseted_at = getdate(), app.reseted_by_id = 4 , app.started_at = null, app.finished_at = null, app.timeout = null
   from application_application app join bkp_application_application_reagendamento_20201008_novo tmp on (app.id = tmp.id)                                 
  where tmp.aluno_nome = 'rafael borges ramos'

 commit 

 --   select * from bkp_application_application_reagendamento_20201008  where aluno_nome like ('teste%') order by aluno_nome -- 1553


 select top 100 * from auth_user where last_name like '%priscilla%'
 

 select distinct application_id from application_answer where application_id in (
   select distinct id from bkp_application_application_reagendamento_20201008_novo  where aluno_nome like ('rafael borges ramos'))   --4215701


   select *
    --delete atw
     from application_application app join bkp_application_application_reagendamento_20201008_novo tmp on (app.id = tmp.id)
	                                  join application_applicationtimewindow                       atw on (app.id = atw.application_id and 
									                                                                       atw.start_time = tmp.inicio)
   where tmp.aluno_nome like ('rafael henriko da silva') 
  


     select distinct app.id, app.user_id
   -- update app set app.started_at = tmp.started_at, app.finished_at = tmp.finished_at,  app.timeout = tmp.timeout--, app.reseted_at = null, app.reseted_by_id = null
     from application_application app join bkp_application_application_reagendamento_20201008_novo tmp on (app.id = tmp.id)
   where tmp.aluno_nome like ('rafael henriko da silva')



   The column name 'reseted_at' is specified more than once in the SET clause or column list of an INSERT.
   A column cannot be assigned more than one value in the same clause. 
   Modify the clause to make sure that a column is updated only once. 
   If this statement updates or inserts columns into a view, column aliasing can conceal the duplication in your code.



   select * 
   -- update app set  app.reseted_by_id = null
   from application_application app
   where id in (3977696, 3989478, 3995369, 4001260, 4013042, 4024824)



   select distinct exa.name , app.started_at
     from application_application app join exam_exam exa on (exa.id = app.exam_id)
	                                  join exam_collection col on (col.id = exa.collection_id)
									  join application_applicationtimewindow atw on (app.id = atw.application_id)
									  join application_answer                ans on (app.id = ans.application_id)

	where  app.user_id = 109105 and 
	       col.name like '%Desafio SAE de Ensino Médio 3°BI%'
		   and ans.alternative_id is  null 


	select distinct  	
	escola_nome	= json_value(usu.extra, '$.hierarchy.unity.name'), 
	grade_nome	=json_value(usu.extra, '$.hierarchy.grade.name'),
	aluno_id	= usu.public_identifier, 
	aluno_nome	= usu.last_name,
	qtd_apps = tmp.qtd_application

	from bkp_application_application_reagendamento_20201008_ignacio tmp join auth_user usu on (usu.id = tmp.user_id)
	                                                                    join exam_exam exa on (exa.id = tmp.exam_id)


