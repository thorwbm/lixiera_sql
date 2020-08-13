with cte_lancamento_desconto as (
			select distinct lan.id as lancamento_id, lan.ano_competencia, lan.mes_competencia, lan.valor_bruto, 
			       lan.valor_pago, lan.valor_liquido,
				   des.id as desconto_id, des.descricao as desconto_descricao, des.valor as desconto_valor, 
				   tds.id as desconto_tipo_id, tds.descricao as desconto_tipo_nome,
				   data_delecao = null, deletado_por = null , tipo = 'desconto ativo'
			  from financeiro_lancamento lan join financeiro_desconto     des on (lan.id = des.lancamento_id)
			                                 join contratos_tipodesconto  tds on (tds.id = des.tipo_id)
										     join log_financeiro_desconto lds on (des.lancamento_id = lds.lancamento_id and 
																			  	  lds.history_type = '-')
)
	,	cte_lancamento_desconto_deletado as (
			select distinct lan.id as lancamento_id, lan.ano_competencia, lan.mes_competencia, lan.valor_bruto, 
			       lan.valor_pago, lan.valor_liquido,
				   dlt.id as desconto_id, dlt.descricao as desconto_descricao, dlt.valor as desconto_valor, 
				   tds.id as desconto_tipo_id, tds.descricao as desconto_tipo_nome,
				   data_delecao = dlt.history_date, deletado_por = dlt.history_user_id , tipo = 'desconto deletado'
			  from financeiro_desconto des join financeiro_lancamento   lan on (lan.id = des.lancamento_id)
										   join log_financeiro_desconto dlt on (des.lancamento_id = dlt.lancamento_id and 
																		        dlt.history_type = '-')
										   join contratos_tipodesconto  tds on (tds.id = dlt.tipo_id)
)

select * from cte_lancamento_desconto union
select * from cte_lancamento_desconto_deletado 
order by lancamento_id, ano_competencia, mes_competencia, tipo



select * from contratos_desconto