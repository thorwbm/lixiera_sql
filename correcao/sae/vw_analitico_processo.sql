create or alter view vw_analitico_processo as 
select 
       pro.id as prova_id, pro.name as prova_nome, pro.external_id as prova_externo_id,
       json_value(pro.extra, '$.discipline.value') AS prova_disciplina_id, json_value(pro.extra, '$.discipline.name') AS prova_disciplina_nome,       
       json_value(pro.extra, '$.grade.value') AS prova_grade_id,           json_value(pro.extra, '$.grade.name') AS prova_grade_nome,
       usu.id as usuario_id, usu.name as usuario_nome,
       json_value(usu.extra, '$.hierarchy.unity.value') AS escola_id, json_value(usu.extra, '$.hierarchy.unity.name') AS escola_nome,       
       json_value(usu.extra, '$.hierarchy.class.value') AS curso_id,  json_value(usu.extra, '$.hierarchy.class.name') AS curso_nome,
       usu.provider_id as instituicao_id, prv.name as instituicao_nome,
       app.started_at as prova_inicio, app.finished_at as prova_finalizada,
       res.position as resposta_posicao, 
       ite.id as item_id, ite.question as item_pergunta, ite.external_id as item_externo_id,
       ita.id as alternativa_id, ita.external_id as alternativa_externo_id, 
       ita.content as resposta_opacao, ita.letter as resposta_letra, ita.is_answer as resposta_gabarito, res.alternative_id as reposta_marcada--
--case when ita.id = res.alternative_id and ita.is_answer = 1 then 
  from 
       application_application app join exam_exam          pro on (pro.id = app.exam_id)
                                   join auth_user          usu on (usu.id = app.user_id)
                                   join login_provider     prv on (prv.id = usu.provider_id)
                              left join application_answer res on (app.id = res.application_id)
                              left join item_item          ite on (ite.id = res.item_id)
                              left join item_alternative   ita on (ite.id = ita.item_id)
                           
 

