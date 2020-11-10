create or alter view vw_nota_aluno as 
with cte_total_nota_disciplina as (
			select col.id as collection_id,col.name as collection_name,  exa.id as exam_id, exa.name as exam_nome, 
				   sum(ite.value) as valor_exam
			  from exam_exam exa join exam_examitem ite on (exa.id = ite.exam_id)
								 join exam_collection col on (col.id = exa.collection_id)
			  group by exa.id, exa.name, col.id, col.name
) 
	,	cte_total_nota_prova as (
			select collection_id as collection_id, 
				   sum(valor_exam) as valor_collection
			  from cte_total_nota_disciplina
			  group by collection_id
)		

	,	cte_nota_aluno_disciplina as (
			select app.exam_id, app.id as application_id,  col.id as collection_id,app.user_id as usuario_id,  sum(ans.value) as nota_exam
			  from application_application app join application_answer ans on (app.id = ans.application_id)
			                                   join exam_exam          exa on (exa.id = app.exam_id)
											   join exam_collection    col on (col.id = exa.collection_id)
			 group by app.exam_id, app.id, col.id, app.user_id 
)
	,	cte_nota_aluno_prova as (
			select collection_id, usuario_id,  sum(nota_exam) as nota_collection
			  from cte_nota_aluno_disciplina
			 group by collection_id, usuario_id
) 

		select 
		       JSON_VALUE(USU.EXTRA, '$.hierarchy.unity.name') as escola_nome, 
			   JSON_VALUE(USU.EXTRA, '$.hierarchy.grade.name') as grade_nome, 
		       tnd.collection_name, tnd.exam_nome, usu.id as aluno_id, usu.last_name as aluno_nome, 
		       tnd.valor_exam as NOTA_PROVA_DISCIPLINA, tnp.valor_collection as NOTA_PROVA, 
			   nad.nota_exam AS NOTA_ALUNO_DISCIPLINA, nap.nota_collection AS NOTA_ALUNO_PROVA, 
			   PERCENTUAL_DISCIPLINA = cast(round((nad.nota_exam * 100.0)/tnd.valor_exam , 2)  as numeric(10,2)),
			   PERCENTUAL_PROVA = cast(round((nap.nota_collection * 100.0)/tnp.valor_collection, 2)  as numeric(10,2))

		  from application_application app join auth_user                 usu on (usu.id = app.user_id)
		                                   join cte_total_nota_disciplina tnd on (tnd.exam_id = app.exam_id)
										   join cte_total_nota_prova      tnp on (tnp.collection_id = tnd.collection_id)
										   join cte_nota_aluno_disciplina nad on (nad.exam_id = app.exam_id and nad.collection_id = tnd.collection_id and nad.usuario_id = app.user_id)
										   join cte_nota_aluno_prova      nap on (nap.collection_id = nad.collection_id and nap.usuario_id = app.user_id) 


	select  * from vw_nota_aluno 
	  where  collection_name = 'Desafio SAE de Ensino Médio 3°BI - 1ª série'  --AND aluno_id = 260160
	order by 1,2,3,6,4
