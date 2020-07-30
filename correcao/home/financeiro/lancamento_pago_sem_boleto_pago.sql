select mac.aluno_nome, mac.aluno_ra, mac.curriculo_nome, 
       mac.ano_competencia, mac.mes_competencia, mac.lanc_valor_bruto, 
	   mac.lanc_data_vencimento, 
	   fnc.plano_nome,
	   fnc.status_parcela as status_sistema_boleto,
	   mac.status_lancamento as status_no ,
       mac.parcela_id, mac.lancamento_id,
	   fnc.data_pagamento, 
       fnc.boleto_id, fnc.valor_pago
	 --into #temp
	  from VW_FNC_PARCELA_MAT_REM  fnc left join vw_financeiro_macro mac on (fnc.RA collate database_default = mac.aluno_ra collate database_default and
	                                                                         fnc.mes_competencia = mac.mes_competencia and 
																			 fnc.ano_competencia = mac.ano_competencia and
																			 cast(fnc.DATA_VENCIMENTO as date) = cast(mac.parcela_data_vencimento as date))
									   left join boletos_service.DB_OWNER.vw_boleto bol on (bol.boleto_id = fnc.boleto_id)
	where fnc.desconto_id is null and 
	      mac.curriculo_aluno_status_id = 13 and 
		  fnc.status_parcela <> 'pago' and mac.status_lancamento = 'pago'
		  order by fnc.ra, mac.ano_competencia, mac.mes_competencia

	-- ###############################################################################################################
	select mac.aluno_nome, mac.aluno_ra, mac.curriculo_nome, 
       mac.ano_competencia, mac.mes_competencia, mac.lanc_valor_bruto, 
	   mac.lanc_data_vencimento, 
	   fnc.plano_nome,
	   fnc.status_parcela as status_sistema_boleto,
	   mac.status_lancamento as status_no_lancamento,
       mac.parcela_id, mac.lancamento_id,
	   fnc.data_pagamento, 
       fnc.boleto_id, fnc.valor_pago
	 --into #temp
	  from VW_FNC_PARCELA_MAT_REM  fnc left join vw_financeiro_macro mac on (fnc.RA collate database_default = mac.aluno_ra collate database_default and
	                                                                         fnc.mes_competencia = mac.mes_competencia and 
																			 fnc.ano_competencia = mac.ano_competencia and
																			 cast(fnc.DATA_VENCIMENTO as date) = cast(mac.parcela_data_vencimento as date))
									   left join boletos_service.DB_OWNER.vw_boleto bol on (bol.boleto_id = fnc.boleto_id)
									   left join financeiro_lancamentoboleto lcb on (mac.lancamento_id = lcb.lancamento_id)
	where fnc.desconto_id is null and 
	      --mac.curriculo_aluno_status_id not in(13,19) and 
		  fnc.status_parcela <> 'pago' and 
		  mac.status_lancamento = 'pago' and
		  lcb.id is null --and mac.status_lancamento = 'pago'
		  order by fnc.ra, mac.ano_competencia, mac.mes_competencia
