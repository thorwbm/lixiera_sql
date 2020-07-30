/***********************************************************************************************
                         CRIAR REGISTROS NAS LANCAMENTOS_BOLETOS
************************************************************************************************/

INSERT INTO financeiro_lancamentoboleto (criado_em, atualizado_em, boleto_id, criado_por, lancamento_id, atualizado_por, pago_em, valor_pago, 
             valor_acrescimos, valor_descontos, BANCO, creditado_em, comprovante_key, justificativa, metodo_pagamento_id,
			 conta_bancaria_id )
select distinct criado_em = getdate(), atualizado_em = getdate(), bol.boleto_id, criado_por = 2137, lancamento_id = lan.id, atualizado_por = 2137,
       pago_em = cast(bol.data_pagamento as date), valor_pago = ISNULL(bol.valor_pago,0), valor_acrescimos = ISNULL(lan.valor_acrescimos,0), 
	   valor_descontos = ISNULL(BOL.DESCONTO_ANTECIPACAO,0), BANCO= NULL, creditado_em = cast(bol.data_pagamento as date),
	   comprovante_key = NULL, justificativa = NULL, 
	   metodo_pagamento_id = 5, conta_bancaria_id = NULL

  from VW_FNC_PARCELAS par join vw_contrato_parcela_desconto_aluno pda on (par.RA = pda.aluno_ra collate database_default and 
                                                                           cast(par.DATA_VENCIMENTO as date) = cast(pda.data_vencimento as date) and 
																		   pda.mes_competencia = left(par.competencia, charindex('/', par.competencia)-1) and
																	       pda.ano_competencia = right(par.competencia, len(par.competencia) - charindex('/', par.competencia)))
						   join financeiro_lancamento              lan on (lan.parcela_id = pda.parcela_id and lan.contrato_id = pda.contrato_id)                   
					  LEFT join boletos_service.db_owner.vw_boleto bol on (bol.boleto_id = par.boleto_id)
					  left join financeiro_lancamentoboleto        lnb on (lan.id = lnb.lancamento_id)
					  
where pda.tipopagamento_nome = '1ª Parcela' and 
      par.status_parcela = 'pago' and 
      lnb.id is null 



	   create    view vw_contrato_parcela_desconto_aluno as               
select alu.ra as aluno_ra, alu.nome as aluno_nome,               
       con.id as contrato_id,               
       par.id as parcela_id, par.descricao as parcela_nome, par.data_vencimento, par.mes_competencia, par.ano_competencia, par.valor as parcela_valor,               
       dsc.id as desconto_id, dsc.descricao as desconto_desc, dsc.valor as desconto_valor,         
       lan.pago_em as lancamento_pago_em, lan.valor_pago as lancamento_valor_pago, lan.id as lancamento_id,       
    stl.id as status_lancamento_id, stl.nome as status_lancamento_nome,   
       tpa.id as tipopgamento_id, tpa.descricao as tipopagamento_nome,    
       lnb.id as lancamento_boleto_id, lnb.boleto_id    
from contratos_contrato con      join academico_aluno             alu on (alu.id = con.aluno_id)        
                            left join contratos_parcela           par on (con.id = par.contrato_id)              
                            left join contratos_desconto          dsc on (par.id = dsc.parcela_id)             
                            left join financeiro_lancamento       lan on (con.id = lan.contrato_id and         
                                                                          par.id = lan.parcela_id)      
                            left join contratos_tipopagamento     tpa on (tpa.id = lan.tipo_id)    
       left join financeiro_statuslancamento stl on (stl.id = lan.status_id)  
                            left join financeiro_lancamentoboleto lnb on (lan.id = lnb.lancamento_id)