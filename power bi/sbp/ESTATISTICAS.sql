with cte_estatistica as (
			SELECT TEC.exam_id, ANS.item_id,  seconds as tempo_gasto,
				   sum(case when isnull(value,0) > 0 then 1 else 0 end) as qtd_item
			  FROM application_answer ANS JOIN APPLICATION_APPLICATION APP ON (APP.ID = ANS.application_id)
										  JOIN tmp_exam_colletion_sbp  TEC ON (TEC.EXAM_ID = APP.exam_id)
				group by  tec.exam_id, ans.item_id, seconds
)
	,	cte_estatistica_temporal as (
			select exam_id, max(tempo_gasto) as maior_tempo_gasto , min(tempo_gasto) as menor_tempo_gasto
			  from cte_estatistica sta
			group by exam_id
)

			select EST.exam_id, EST.item_id, XXX.menor_nota from cte_estatistica est join 
					(select exam_id, min(qtd_item) as menor_nota 
					  from cte_estatistica
					  group by exam_id, item_id) AS XXX ON (EST.exam_id = XXX.exam_id AND EST.qtd_item = XXX.menor_nota)



			select distinct * 
			  from cte_statistica sta join tmp_exam_colletion_sbp tec on (sta.exam_id = tec.exam_id)
			                          join tmp_grupo              gru on (gru.id = tec.group_id)

			order by item_id