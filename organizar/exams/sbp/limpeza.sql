select bi.exam_id, bi.exam_nome, count(distinct app.user_id) as qtd 
  from vw_bi bi join application_application app on (app.exam_id = bi.exam_id)
  group by bi.exam_id,  bi.exam_nome

   select user_id, username, name
   from application_application app join auth_user usu on (usu.id = app.user_id) where app.exam_id = 4

  select user_id  from application_application where exam_id = 6
  except
 
  select user_id from application_application where exam_id = 75

  select * from auth_user where id in (5,6,7)

  
  
   select *  --  delete 
 from application_applicationtimewindow where application_id in (2,4698)


   select *  --  delete 
 from application_answer where application_id in (2,4698)

select * --delete 
from application_answerlog where application_id in (2,4698)
select * --  delete 
from application_application where exam_id = 4 and user_id in (11,3)
