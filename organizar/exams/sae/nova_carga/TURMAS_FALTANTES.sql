with cte as (
			select distinct JSON_VALUE(extra, '$.hierarchy.unity.name') escola,  
				CASE 
					WHEN JSON_VALUE(extra, '$.hierarchy.grade.name') = 'Extensivo' then '3ª série'
					WHEN JSON_VALUE(extra, '$.hierarchy.grade.name') = 'Extensivo Mega' then '3ª série'
					ELSE JSON_VALUE(extra, '$.hierarchy.grade.name')
				end
				serie from auth_user
				where JSON_VALUE(extra, '$.hierarchy.grade.name') is not null  and 
					  JSON_VALUE(extra, '$.hierarchy.grade.name') <> ''
)
,	cte_nao_bloqueados as (
			  select distinct escola, serie from cte
			  left  join tmp_imp_bloquear b
					on b.nome_escola_ava = escola
						and b.simulado_bimestral = serie
			where b.nome_escola_ava is null 
)
,	cte_criados as (
			select distinct col.name  , 
			   CASE 
					WHEN JSON_VALUE(usu.extra, '$.hierarchy.grade.name') = 'Extensivo' then '3ª série'
					WHEN JSON_VALUE(usu.extra, '$.hierarchy.grade.name') = 'Extensivo Mega' then '3ª série'
					ELSE JSON_VALUE(usu.extra, '$.hierarchy.grade.name')
				end as grade_nome, 
			json_value(usu.extra, '$.hierarchy.unity.name') as escola_nome
			from application_application app join auth_user usu on (app.user_id = usu.id)
											 join exam_exam exa on (exa.id = app.exam_id) 
											 join exam_collection col on ( col.id = exa.collection_id)
			where col.name like '%- Diagnóstica 2/2020 - % dia' and 
				   json_value(usu.extra, '$.hierarchy.unity.name') <> ''
)

,	cte_dia as (
			select dia = '1º Dia' union 
			select dia = '2º Dia'
)

		select distinct  escola, serie--, dia 
		--into tmp_imp_carga_final
		from cte_nao_bloqueados nbk --join cte_dia dia on (1 = 1)
		                                left join  cte_criados cri on (nbk.escola = cri.escola_nome and 
		                                                               nbk.serie  = cri.grade_nome)
		where cri.escola_nome is null  and 
		      nbk.escola = 'Anglo Zona Oeste'



			  SELECT * FROM VW_AGENDAMENTO_PROVA_ALUNO WHERE ESCOLA_NOME = 'Anglo Zona Oeste' AND  PROVA_NOME  like '%- Diagnóstica 2/2020 - % dia'