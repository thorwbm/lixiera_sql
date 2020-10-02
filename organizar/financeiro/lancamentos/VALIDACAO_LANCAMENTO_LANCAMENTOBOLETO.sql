SELECT LAN.ID, LAN.data_vencimento, LAN.PAGO_EM, LAN.VALOR_BRUTO, LAN.valor_liquido, LAN.valor_pago, LAN.valor_desconto_pontualidade, 
       LAN.ano_competencia, LAN.mes_competencia, 
	   pes.nome as aluno,
	   ope.nome as operacao_nome,
	   stl.nome as status_lancamento_nome, 
	   tpl.descricao as lancamento_tipo_pagamento, 
	   res.nome as responsavel_financeiro,
	   lcb.pago_em as lanc_bol_pago_em,
	   lcb.valor_acrescimos as lanc_bol_valor_acrescimo, 
	   lcb.valor_descontos  as lanc_bol_valor_desconto, 
	   lcb.valor_pago as lanc_bol_valor_pago, 
	   mtp.nome as metodo_pagamento, 
	   dsc.desconto_por_lancamento
-- select lcb.*
  FROM FINANCEIRO_LANCAMENTO LAN JOIN financeiro_conta                CON ON (CON.ID = LAN.conta_id)
                                 join pessoas_pessoa                  pes on (pes.id = con.pessoa_id)
								 join financeiro_operacao             ope on (ope.id = lan.operacao_id)
								 join financeiro_statuslancamento     stl on (stl.id = lan.status_id)
								 join contratos_tipopagamento         tpl on (tpl.id = lan.tipo_id)
								 join pessoas_pessoa                  res on (res.id = lan.responsavel_id)
							left join financeiro_lancamentoboleto     lcb on (lan.id = lcb.lancamento_id)
							left join financeiro_metodopagamento      mtp on (mtp.id = lcb.metodo_pagamento_id)
							left join vw_fnc_descontos_por_lancamento dsc on (lan.id = dsc.lancamento_id)
  WHERE PES.NOME = 'DANIELA SOBRAL PEREIRA'
  ORDER BY LAN.ano_competencia, LAN.mes_competencia

/* ###################################################################################################
      LANCAMENTOS COM MAIS DE UMA LACAMENTO BOLETO
   ###################################################################################################*/
  select alu.nome as aluno_nome, lan.ano_competencia, lan.mes_competencia, 
         lan.valor_bruto, lan.valor_liquido, lan.valor_pago,
	     stl.nome as status_lancamento_nome 
    from financeiro_lancamento lan join financeiro_conta con on (con.id = lan.conta_id)
	                               join pessoas_pessoa   alu on (alu.id = con.pessoa_id)
							       join financeiro_statuslancamento stl on (stl.id = lan.status_id)

where lan.id in (
  select lancamento_id 
  from financeiro_lancamentoboleto
  group by lancamento_id 
  having count(1) > 1)


/* ###################################################################################################
      LANCAMENTOS PAGOS SEM LACAMENTO BOLETO
   ###################################################################################################*/
  select alu.nome as aluno_nome, lan.ano_competencia, lan.mes_competencia, 
         lan.valor_bruto, lan.valor_liquido, lan.valor_pago,
	     stl.nome as status_lancamento_nome 
    from financeiro_lancamento lan join financeiro_conta            con on (con.id = lan.conta_id)
	                               join pessoas_pessoa              alu on (alu.id = con.pessoa_id)
							       join financeiro_statuslancamento stl on (stl.id = lan.status_id)
							  LEFT JOIN FINANCEIRO_LANCAMENTOBOLETO LCB ON (LAN.ID = LCB.lancamento_id)
 WHERE LCB.ID IS NULL AND STL.NOME = 'PAGO'



