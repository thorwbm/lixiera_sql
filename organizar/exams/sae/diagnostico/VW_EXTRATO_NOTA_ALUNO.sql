CREATE OR ALTER   VIEW VW_EXTRATO_NOTA_ALUNO AS   
with cte_agendado as (  
   select col.id as prova_id, col.name as prova_nome,   
       exa.id as exame_id, exa.name as exame_nome,  
       json_value(usu.extra, '$.hierarchy.unity.name') as escola_nome,  
       json_value(usu.extra, '$.hierarchy.unity.value') as escola_id,  
       json_value(usu.extra, '$.hierarchy.grade.name') as grade_nome,  
       json_value(usu.extra, '$.hierarchy.grade.value') as grade_id,  
       usu.id as usuario_id, usu.name as usuario_nome,   
       ans.value as nota, ans.updated_at as data_termino, ANS.ID AS ANSWER_ID  
   from exam_exam exa with(nolock) join exam_collection         col with(nolock) on (col.id = exa.collection_id)  
                                   join application_application app with(nolock) on (exa.id = app.exam_id)  
                                   join auth_user               usu with(nolock) on (usu.id = app.user_id)  
                              LEFT join application_answer      ans with(nolock) on (app.id = ans.application_id)  
)  
  
 , cte_soma_exame as (  
   select  prova_id, exame_id, escola_id, usuario_id, sum(nota) as nota,  max(data_termino) as data_termino  
     from cte_agendado cte       
   group by prova_id, exame_id, escola_id, usuario_id  
)  
 , cte_soma_prova as (  
   select  prova_id, escola_id, usuario_id, sum(nota) as nota  
     from cte_agendado cte  
   group by prova_id, escola_id, usuario_id  
)  
  
  
select distinct age.prova_id, age.prova_nome, age.exame_id, age.exame_nome,age.escola_nome,   
       age.escola_id, age.grade_nome, age.grade_id, age.usuario_id, age.usuario_nome, dateadd(hour, -3, cse.data_termino) as data_termino,   
    cse.nota as nota_exame, pro.nota as nota_prova  
  from cte_agendado age left join cte_soma_exame cse on (age.prova_id   = cse.prova_id and  
                                                         age.exame_id   = cse.exame_id and  
               age.escola_id  = cse.escola_id and  
               age.usuario_id = cse.usuario_id)  
      left join cte_soma_prova pro on (age.prova_id   = pro.prova_id and  
               age.escola_id  = pro.escola_id and  
               age.usuario_id = pro.usuario_id)