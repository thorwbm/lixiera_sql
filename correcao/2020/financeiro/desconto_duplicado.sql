with cte_log_insert_duplicado_desconto as (
			select lancamento_id, desconto_contrato_id--, tipo_id   
			  from log_financeiro_desconto dlt 
			 where dlt.history_type = '+' and 
				   dlt.desconto_contrato_id is not null 
			 group by lancamento_id, desconto_contrato_id--, tipo_id  
			 having count(dlt.id) > 1
)
	--,	cte
			
			select crc.id as curriculo_id, crc.nome as curriculo_nome,    
                   alu.id as aluno_id, alu.nome as aluno_nome, alu.ra as aluno_ra,    
                   lan.id as lancamento_id, lan.valor_bruto, lan.valor_liquido, lan.valor_pago, lan.status_id,    
                   lan.ano_competencia as lancamento_ano, lan.mes_competencia as lancamento_mes,    
                   ctp.id as lancamento_tipo_id, ctp.descricao as lancamento_tipo_nome,     
                   fsl.id as lancamento_satus_id, fsl.nome as lancamento_status_nome,     
                   des.id as desconto_id, des.descricao, des.valor, tds.id as desconto_tipo_id, tds.descricao as desconto_tipo_nome,    
                   con.id as contrato_id,   
                   des.criado_em as desconto_criado_em,   
                   usu.id as desconto_criado_por_id, usu.nome_civil as desconto_criado_por_nome 
			  from cte_log_insert_duplicado_desconto dpd join financeiro_lancamento       lan on (lan.id = dpd.lancamento_id)
			                                             join log_financeiro_desconto     des on (lan.id = des.lancamento_id and 
														                                          des.desconto_contrato_id = dpd.desconto_contrato_id)       
														 join contratos_contrato          con on (con.id = lan.contrato_id)
														 join academico_aluno             alu on (alu.id = con.aluno_id)
														 join curriculos_curriculo        crc on (crc.id = con.curriculo_id)
														 join contratos_tipodesconto      tds on (tds.id = des.tipo_id) 
														 join financeiro_statuslancamento fsl on (fsl.id = lan.status_id)    
                                                         join contratos_tipopagamento     ctp on (ctp.id = lan.tipo_id)
													left join auth_user                   usu on (usu.id = des.criado_por)
