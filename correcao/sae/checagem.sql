CREATE VIEW vw_analise_exame_item_alternativa AS 
WITH	cte_analise AS (
			SELECT distinct 
			       exa.id AS exam_id, exa.name AS exam_nome,
			       eit.id AS examitem_id, eit.position, ite.id AS item_id,
			       ite.external_id AS item_external_id,alt.id AS alternativa_id,
				   alt.position AS alternativa_posicao, alt.is_answer AS alternativa_resposta,
				   alt.letter AS alternativa_letra, alt.item_id AS alternativa_item_id, 
				   alt.external_id AS alternativa_external_id
			  FROM 
			       exam_exam exa left JOIN exam_examitem    eit ON (exa.id = eit.exam_id)
				                 left JOIN item_item        ite ON (ite.id = eit.item_id)
								 LEFT JOIN item_alternative alt ON (alt.item_id = ite.id)
								
)

	,	cte_qtd_item AS (
			SELECT cte.exam_id, count(DISTINCT item_id) AS qtd_itens
			  FROM cte_analise cte
			 GROUP BY cte.exam_id
)

	,	cte_qtd_alternativa AS (
			SELECT 
			       alt.exam_id, alt.alternativa_item_id, count(1) AS qtd_alternativa
			  FROM 
			       cte_analise alt 
			 GROUP BY 
			       alt.exam_id, alt.alternativa_item_id
)

	,	cte_qtd_alternativa_gab AS (
			SELECT 
			       alt.exam_id, alt.alternativa_item_id, count(1) AS qtd_alternativa_gab
			  FROM 
			       cte_analise alt 
			 WHERE 
			       alt.alternativa_resposta = 1
			 GROUP BY
			       alt.exam_id, alt.alternativa_item_id
)

			SELECT  
			       ana.*, qite.qtd_itens, qalt.qtd_alternativa, qgab.qtd_alternativa_gab 
			  FROM 
			       cte_analise ana LEFT JOIN cte_qtd_item            qite ON (ana.exam_id = qite.exam_id)
				                   LEFT JOIN cte_qtd_alternativa     qalt ON (ana.exam_id = qalt.exam_id AND
								                                              ana.alternativa_item_id = qalt.alternativa_item_id)
								   LEFT JOIN cte_qtd_alternativa_gab qgab ON (ana.exam_id = qgab.exam_id AND 
								                                              ana.alternativa_item_id = qgab.alternativa_item_id) 
		     WHERE ana.exam_id = 1 
			      
		


