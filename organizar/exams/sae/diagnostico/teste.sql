with	cte_apuracao as (
			select distinct  prova_nome, escola_nome, exame_nome, grade_nome, aluno_nome, alternativa_marcada, letter, 
				   apr.item_id, alt.is_answer,apr.answer_id  
			  from VW_AGENDAMENTO_PROVA_ALUNO_PERGUNTA_RESPOSTA apr with(nolock) 
			                         left join item_alternative alt with(nolock) on (alt.id = apr.alternativa_marcada and 
															                         alt.item_id = apr.item_id)																									   
)
	,	cte_acertos as (
			select prova_nome, escola_nome, exame_nome, grade_nome, aluno_nome, count(answer_id) as acertos
			  from cte_apuracao 
			 where is_answer = 1
			 group by prova_nome, escola_nome, exame_nome, grade_nome, aluno_nome
) 	
	,	cte_erros as (
			select prova_nome, escola_nome, exame_nome, grade_nome, aluno_nome, count(answer_id) as erros
			  from cte_apuracao 
			 where is_answer = 0 
			 group by prova_nome, escola_nome, exame_nome, grade_nome, aluno_nome
) 	
,	cte_brancos as (
			select prova_nome, escola_nome, exame_nome, grade_nome, aluno_nome, count(answer_id) as brancos
			  from cte_apuracao 
			 where alternativa_marcada is null
			 group by prova_nome, escola_nome, exame_nome, grade_nome, aluno_nome
) 

	,	 cte_perguntas as (
			select app.id as application_id, exa.id as exame_id, exa.name as exame_nome, col.id as prova_id, 
			       col.name as prova_nome, count(ans.item_id) as qtd_perguntas 
			  from application_application          app with(nolock) 
			                join exam_exam          exa with(nolock) on (exa.id = app.exam_id)
                            join exam_collection    col with(nolock) on (col.id = exa.collection_id)
					        join application_answer ans with(nolock) on (app.id = ans.application_id)
group by app.id, exa.id, exa.name, col.id, col.name
) 

select distinct
       apr.prova_nome, apr.escola_nome, apr.exame_nome, apr.grade_nome, apr.aluno_nome, isnull(ace.acertos,0) as acerto, 
       isnull(err.erros,0) as erro ,isnull(bro.brancos,0) as brancos, per.qtd_perguntas
  from VW_AGENDAMENTO_PROVA_ALUNO_PERGUNTA_RESPOSTA apr left join cte_acertos   ace on (apr.aluno_nome = ace.aluno_nome and 
                                                                                        apr.prova_nome = ace.prova_nome and 
																				        apr.exame_nome = ace.exame_nome and 
																				        apr.grade_nome = ace.grade_nome)
													    left join cte_erros     err on (apr.aluno_nome = err.aluno_nome and 
                                                                                        apr.prova_nome = err.prova_nome and 
																				        apr.exame_nome = err.exame_nome and 
																				        apr.grade_nome = err.grade_nome)
													    left join cte_brancos   bro on (apr.aluno_nome = bro.aluno_nome and 
                                                                                        apr.prova_nome = bro.prova_nome and 
																				        apr.exame_nome = bro.exame_nome and 
																			 	        apr.grade_nome = bro.grade_nome)
													    left join cte_perguntas per on (apr.prova_nome = per.prova_nome and 
																				        apr.exame_nome = per.exame_nome)

 where   apr.aluno_nome = 'Matheus Da Conceição Bastos' and 
	 			   apr.prova_nome = 'Desafio SAE de Ensino Médio -  2ª série' --and 
				   --apr.exame_nome = '2ª série - Arte'

