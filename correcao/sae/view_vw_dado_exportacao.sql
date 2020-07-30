-- use exams

create or alter view vw_dados_exportacao as 
with    cte_participante_avaliacao as (
            -- traz a quantidade de participantes de uma avalicao e a menor data de aplicacao --
            select distinct 
                   app.exam_id, count(distinct user_id) as qtd_participante, cast(min (ext.start_time) as date) as data_aplicacao
              from 
                   application_application app left join exam_timewindow ext on (ext.exam_id = app.exam_id)
             where 
                   app.started_at  is not null and 
                   app.finished_at is not null 
             group by 
                   app.exam_id 
)         

    ,   cte_usuario as (
            -- traz as informacoes dos usuarios participantes --
            select distinct                    
                   usu.id as usuario_id, usu.name as usuario_nome,
                   json_value(usu.extra, '$.hierarchy.unity.value') AS escola_id, json_value(usu.extra, '$.hierarchy.unity.name') AS escola_nome,       
                   json_value(usu.extra, '$.hierarchy.class.value') AS curso_id, json_value(usu.extra, '$.hierarchy.class.name') AS curso_nome,
                   usu.provider_id
              from
                   auth_user usu join application_application app on (usu.id = app.user_id)
             where 
                   app.started_at is not null 
)

            select distinct 
                   pro.id as instituicao_id, pro.name as instituicao_nome, 
                   usu.usuario_id, usu.usuario_nome, usu.escola_id,usu.escola_nome, usu.curso_id, usu.curso_nome,
                   json_value(exa.extra, '$.discipline.value') AS disciplina_id, json_value(exa.extra, '$.discipline.name') AS disciplina_nome,       
                   json_value(exa.extra, '$.grade.value') AS grade_id, json_value(exa.extra, '$.grade.name') AS grade_nome,
                   exa.id as avaliacao_id, exa.name as avaliacao_nome, 
                   par.qtd_participante, par.data_aplicacao 
              from 
                   application_application app join exam_exam                  exa on (exa.id = app.exam_id)
                                               join exam_examitem              exi on (exa.id = exi.exam_id)
                                               join item_item                  ite on (ite.id = exi.item_id)
                                               join cte_usuario                usu on (usu.usuario_id = app.user_id)
                                               join login_provider             pro on (pro.id = usu.provider_id)
                                               join cte_participante_avaliacao par on (exa.id = par.exam_id)

