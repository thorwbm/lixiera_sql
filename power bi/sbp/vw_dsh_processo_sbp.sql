create OR ALTER view vw_dsh_processo_sbp as
select tec.*, gru.name as grupo_nome,
       usu.id as usuario_id, usu.name as usuario_nome, 
	   app.id as aplicacao_id, app.started_at as iniciado_em, app.finished_at as finalizado_em, 
	   SITUACAO = CASE WHEN app.finished_at IS NOT NULL THEN 'FINALIZADA'
	                   WHEN app.started_at  IS     NULL THEN 'NAO INICIDADA' ELSE 'EM ANDAMENTO' END,
	   itx.item_id, itx.value as item_valor, 
	   ans.seconds as tempo_gasto, ans.value as item_nota
  from tmp_exam_colletion_sbp tec with(nolock) join tmp_grupo               gru with(nolock) on (gru.id = tec.group_id)
                                               join application_application app with(nolock) on (app.exam_id = tec.exam_id)
								               join auth_user               usu with(nolock) on (usu.id = app.user_id)
								               join exam_examitem           itx with(nolock) on (itx.exam_id = tec.exam_id)
								               join application_answer      ans with(nolock) on (app.id = ans.application_id and 
								                                                    itx.item_id = ans.item_id)


										

										SELECT * FROM vw_dsh_processo_sbp
										WHERE GROUP_ID = 6