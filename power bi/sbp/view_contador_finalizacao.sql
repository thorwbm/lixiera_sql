create or alter view vw_dsh_contador_finalizacao as 
with cte_exam_colletion_grupo_qtd as (
			select exc.group_id  , count(distinct exa.id) as qtd_grupo, count(distinct app.user_id) as qtd_alunos
			  from exam_exam exa join exam_collection col on (col.id = exa.collection_id)
			                     join tmp_exam_colletion_sbp exc on (exc.collection_id = col.id)
								 join application_application app on (app.exam_id = exc.exam_id)
			group by exc.group_id
)
	,	cte_exam_contador_finalizado as (
			select exc.exam_id,
			       count(distinct case when app.finished_at is not null then app.user_id else null end) as qtd_exa_concluido,
                   count(distinct case when app.finished_at is     null then app.user_id else null end) as qtd_exa_nao_concluido
			  from  tmp_exam_colletion_sbp exc join application_application app on (exc.exam_id = app.exam_id )
			 group by exc.exam_id
)	
	,	cte_collection_contador_finalizado as (
			select exc.collection_id,
			       count(distinct case when app.finished_at is not null then app.user_id else null end) as qtd_collection_concluido,
                   count(distinct case when app.finished_at is     null then app.user_id else null end) as qtd_collection_nao_concluido
			  from  tmp_exam_colletion_sbp exc join application_application app on (exc.exam_id = app.exam_id)
			 group by exc.collection_id
)
	,	cte_grupo_contador_finalizado as (
			select exc.group_id,
			       count(distinct case when app.finished_at is not null then app.user_id else null end) as qtd_grupo_concluido,
                   count(distinct case when app.finished_at is     null then app.user_id else null end) as qtd_grupo_nao_concluido
			  from  tmp_exam_colletion_sbp exc join application_application app on (exc.exam_id = app.exam_id )
			 group by exc.group_id
)

 select exa.id as exam_id, exa.name as exam_nome, 
        col.id as collection_id, col.name as collection_nome, 
		tmp.group_id, gru.name as grupo_nome, qtd.qtd_grupo, qtd.qtd_alunos as qtd_alunos_grupo,  
		cgr.qtd_grupo_concluido, cgr.qtd_grupo_nao_concluido,
		ccl.qtd_collection_concluido, ccl.qtd_collection_nao_concluido,
		cex.qtd_exa_concluido, cex.qtd_exa_nao_concluido, 
		gru.ordem as grupo_ordem, tcl.ordem as collection_ordem
		
		from exam_exam exa join exam_collection                    col on (col.id = exa.collection_id)
						   join tmp_exam_colletion_sbp             tmp on (tmp.collection_id = col.id and
						                                                   tmp.exam_id       = exa.id)
		                   join cte_exam_colletion_grupo_qtd       qtd on (qtd.group_id      = tmp.group_id)
						   join tmp_grupo                          gru on (gru.id            = tmp.group_id)
						   join cte_grupo_contador_finalizado      cgr on (cgr.group_id      = gru.id)
						   join cte_collection_contador_finalizado ccl on (ccl.collection_id = tmp.collection_id)
                           join cte_exam_contador_finalizado       cex on (cex.exam_id       = tmp.exam_id)
						   join tmp_Collection                     tcl on (tcl.collection_id = col.id)
					   

					   select * from vw_dsh_contador_finalizacao



					   