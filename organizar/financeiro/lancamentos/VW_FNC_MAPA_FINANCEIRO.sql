
create view VW_FNC_MAPA_FINANCEIRO as 
select con.id as contrato_id, con.descricao as contrato_descricao, 
       cur.id as curso_id, cur.nome as curso_nome, 
	   crc.id as curriculo_id, crc.nome as curriculo_nome, 
	   alu.id as aluno_id, alu.nome as aluno_nome, 
	   lan.id as lancamento_id, lan.ano_competencia, lan.mes_competencia, 
	   lan.valor_bruto, lan.valor_liquido, lan.valor_pago, lan.valor_desconto_pontualidade, 
	   lan.data_vencimento, lan.pago_em, 
	   lcb.boleto_id, lcb.valor_pago as boleto_valor,lcb.pago_em as boleto_pago_em, lcb.valor_acrescimos as boleto_acrescimo,
	   lcb.valor_descontos as boleto_desconto,
	   slc.id as lancamento_status_id, slc.nome as lancamento_status_nome,
	   des.id as desconto_id, des.descricao as descricao_lancamento, des.valor as desconto_valor,
	   pes.id as responsavel_id, pes.nome_civil as responsavel_nome
  from financeiro_lancamento lan join contratos_tipopagamento     tpp on (tpp.id = lan.tipo_id)
                                 join contratos_contrato          con on (con.id = lan.contrato_id)
								 join academico_aluno             alu on (alu.id = con.aluno_id)
								 join curriculos_curriculo        crc on (crc.id = con.curriculo_id)
								 join academico_curso             cur on (cur.id = crc.curso_id)
								 join financeiro_statuslancamento slc on (slc.id = lan.status_id)
								 join pessoas_pessoa              pes on (pes.id = lan.responsavel_id)
                            left join financeiro_desconto         des on (lan.id = des.lancamento_id)
							left join contratos_tipodesconto      tpd on (tpd.id = des.tipo_id)
							left join financeiro_lancamentoboleto lcb on (lan.id = lcb.lancamento_id)
						