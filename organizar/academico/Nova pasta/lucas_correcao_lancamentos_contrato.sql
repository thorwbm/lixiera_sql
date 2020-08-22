
select distinct lan.id, cap.curriculo_nome, cap.curso_nome,
       con.id as contrato_id, con.responsavel_financeiro_id,
	   par.descricao as parcela_descricao, par.id, par.ano_competencia, par.mes_competencia,
       lan.id as lancamento_id, lan.ano_competencia, lan.mes_competencia, lan.valor_bruto, lan.valor_pago,
	   tpg.id as lancamento_tipo_id, tpg.descricao as lancamento_tipo_nome,
	   des.id as desconto_id, des.descricao as desconto_descricao, des.valor as desconto_valor, 
	   tpd.id as desconto_tipo_id, tpd.descricao as desconto_tipo_nome
  from contratos_contrato con join VW_ACD_CURRICULO_ALUNO_PESSOA cap on (cap.aluno_id = con.aluno_id and 
                                                                         cap.curriculo_id = con.curriculo_id)
						 left join contratos_parcela             par on (con.id = par.contrato_id)
						 left join financeiro_lancamento         lan on (con.id = lan.contrato_id and
						                                                 lan.curriculo_aluno_id = cap.curriculo_aluno_id and 
																		 par.id = lan.parcela_id)
						 left join financeiro_desconto           des on (lan.id = des.lancamento_id)
						 left join contratos_tipodesconto        tpd on (tpd.id = des.tipo_id)
						 left join contratos_tipopagamento       tpg on (tpg.id = lan.tipo_id)
where cap.aluno_nome = 'JOÃO PEDRO ASSIS CARVALHO' 

order by con.id 


/*
select * from vw_tabela_coluna
where coluna = 'contrato_id'

3845

financeiro_lancamento
contratos_fiador
contratos_parcela
contratos_financiamento, contratos_fiador
*/


select * from contratos_parcela where contrato_id in (1090,3845)


select lano.id,
                lanO.contrato_id   , conD.id, 
                lanO.parcela_id    , parD.id, 
				lanO.atualizado_em , getdate(), 
				lanO.atualizado_por, 11717 
--update lano set lanO.contrato_id = conD.id, 
--                lanO.parcela_id  = parD.id, 
--				lanO.atualizado_em = getdate(), 
--				lanO.atualizado_por = 11717

from contratos_contrato conO join contratos_parcela parO on (conO.id = parO.contrato_id)
                                      join financeiro_lancamento lanO on (parO.id = lanO.parcela_id and 
									                                      conO.id = lanO.contrato_id)
                                      join contratos_parcela parD on (parD.ano_competencia = parO.ano_competencia and
									                                  parD.mes_competencia = parO.mes_competencia)
                                      join contratos_contrato conD on (conD.id = parD.contrato_id)
where conO.id = 1930 and 
      conD.id = 3846


select * from financeiro_lancamento lan join contratos_contrato    con on (con.id = lan.contrato_id)                                        
                                   left join financeiro_lancamento nov on (nov.contrato_id = @novo_contrato and
								                                           nov.lan

where con.aluno_id = 41158
