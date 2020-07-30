---#####################################################################################  
--  IMPORTACAO DAS INFORMACOES DE PARCELAS E DESCONTOS DOS ALUNOS (VETERANOS) 
---#####################################################################################

--------------------------------------------------------------------------------------------------------------------
-- ****** INSERIR CONTRATOS 
			--* O ALUNO SERA SEU PROPRIO RESPONSAVEL
--------------------------------------------------------------------------------------------------------------------

--insert into contratos_contrato (criado_em, atualizado_em, valor, valor_parcela, num_parcelas, num_fiadores, aluno_id, criado_por, curriculo_id, etapa_ano_id, responsavel_financeiro_id, atualizado_por)
select distinct   criado_em = getdate(), atualizado_em = getdate(), valor = -1, valor_parcela = -1, num_parcelas = -1, num_fiadores = fia.qtd_fiadores, 
                  aluno_id = alu.id, criado_por = 2136, curriculo_id = cra.curriculo_id, etapa_ano_id= null , 
				  responsavel_financeiro_id = alu.pessoa_id, atualizado_por = 2136, par.ra
  from  academico_aluno alu   join rem_prd..vw_parcelas par on (par.ra collate database_default = alu.ra collate database_default)
                         left join rem_prd..vw_fiadores fia on (par.ra = fia.ra)
						left	 join curriculos_aluno  cra on (cra.aluno_id = alu.id and cra.status_id = 13)

  where   
  cra.id is not null  and 
		 not exists (select 1 from contratos_contrato contx
		             where contx.aluno_id =  alu.id  )
 
--####################################################################################
--------------------------------------------------------------------------------------------------------------------
-- ****** INSERIR CONTA PARA TODOS OS CONTRATOS
--------------------------------------------------------------------------------------------------------------------
       --insert into financeiro_conta (criado_em, atualizado_em, saldo, criado_por, pessoa_id, atualizado_por, titular_id)
	   select criado_em = getdate(), atualizado_em = getdate(), saldo = 0.0, criado_por = 2136, 
	          pessoa_id = alu.pessoa_id , atualizado_por = 2136, titular_id = ALU.PESSOA_ID  
	     from contratos_contrato con join academico_aluno  alu on (alu.id = con.aluno_id)
	                            left join financeiro_conta fcn on (fcn.pessoa_id = alu.pessoa_id)
where fcn.id is null 
-- ##################################################################################
--------------------------------------------------------------------------------------------------------------------
-- ****** INSERIR PARCELAS REFERENTES A UM CONTRATO 
			--* NAO ESTA SENDO INSERIDO A PRIMEIRA PARCELA
--------------------------------------------------------------------------------------------------------------------
select * from contratos_parcela
insert into contratos_parcela (criado_em, atualizado_em, descricao, data_vencimento, valor, mes_competencia, 
                               ano_competencia, contrato_id, criado_por, tipo_id, atualizado_por)
select criado_em = getdate(), atualizado_em = getdate(), 
       descricao = 'parcela mes ' + left(par.competencia, charindex('/', par.competencia)-1), 
	   data_vencimento = par.data_vencimento, valor = par.VALOR, 
       mes_competencia = left(par.competencia, charindex('/', par.competencia)-1) , 
	   ano_competencia = right(par.competencia, len(par.competencia) - charindex('/', par.competencia)), 
	   contrato_id = con.id, criado_por = 2137,
	   tipo_id = CASE WHEN left(par.competencia, charindex('/', par.competencia)-1)  = '1' THEN 1 ELSE 2 END , 
	   atualizado_por = 2137
         from contratos_contrato con join academico_aluno alu on (con.aluno_id = alu.id)
                                     join rem_prd..vw_parcelas par on ( alu.ra collate database_default = par.ra collate database_default)
         where   --par.plano_nome <> 'mensal' and 
		      -- left(par.competencia, charindex('/', par.competencia)-1) = 1 and 
		       not exists (select 1 from contratos_parcela parx
			               where parx.contrato_id = con.id and
						         parx.mes_competencia = left(par.competencia, charindex('/', par.competencia)-1) and
                                 parx.ano_competencia = right(par.competencia, len(par.competencia) - charindex('/', par.competencia))	)


								 SELECT * FROM contratos_tipopagamento
-- ##########################################################
--------------------------------------------------------------------------------------------------------------------
-- ****** INSERIR DESCONTOS REFERENTES A UMA PARCELA 
--------------------------------------------------------------------------------------------------------------------

--insert into contratos_desconto ( descricao, porcentagem, valor, parcela_id, tipo_id, criado_em, criado_por, atualizado_em, atualizado_por)
select DISTINCT  descricao = 'desconto ' + DES.COMPETENCIA, porcentagem = null, valor = des.valor, parcela_id = par.id, 
      tipo_id = CASE WHEN par.mes_competencia = 1 THEN 3 ELSE 2 END ,
       criado_em = getdate(), criado_por = 2136, atualizado_em = getdate(), atualizado_por = 2136
from contratos_contrato con join academico_aluno alu on (con.aluno_id = alu.id)
                                     join rem_prd..vw_descontos des on ( alu.ra collate database_default = des.ra collate database_default)
								     join contratos_parcela par on (par.contrato_id = con.id and 
									                                par.mes_competencia = left(des.competencia, charindex('/', des.competencia)-1) and
																	par.ano_competencia = right(des.competencia, len(des.competencia) - charindex('/', des.competencia)))
where --par.ano_competencia = 2020 and par.mes_competencia = 1 and 
not exists (select 1  
	               from contratos_desconto desx 
				   where desx.parcela_id = par.id and 
				         desx.valor      = des.valor)


						 SELECT * FROM contratos_tipodesconto
--#################################################################################################################

insert into financeiro_lancamento (criado_em, atualizado_em, mes_competencia, ano_competencia, data_vencimento, pago_em, valor_bruto, valor_liquido, 
                                   pagamento_por_remessa, conta_id, contrato_id, criado_por, curriculo_aluno_id, operacao_id, parcela_id, protocolo_id, 
                                   status_id, tipo_id, atualizado_por, extra, responsavel_id, valor_pago)
select distinct 
       criado_em = getdate(), atualizado_em = getdate(), par.mes_competencia, par.ano_competencia, par.data_vencimento, pago_em = PRX.data_pagamento, valor_bruto = par.valor , 
	   valor_liquido = par.valor - isnull(dsc.valor,0), pagamento_por_remessa = 1, conta_id = fnc.id, par.contrato_id, criado_por = 2136, curriculo_aluno_id = cra.id, operacao_id = 2, 
	   parcela_id = par.id, protocolo_id= null , 
	   status_id = case when PRX.status_parcela = 'PAGO' THEN 5 ELSE 1 END , 
	   tipo_id = 1, atualizado_por = 2136, extra = null, responsavel_id = con.responsavel_financeiro_id, valor_pago = isnull(prx.valor_pago,0)

  from contratos_parcela par      join contratos_contrato    con on (con.id = par.contrato_id)
                                  join academico_aluno       alu on (alu.id = con.aluno_id)
								  join curriculos_aluno      cra on (alu.id = cra.aluno_id and cra.status_id = 13)
								  JOIN rem_prd..vw_parcelas  PRX ON (PRX.RA collate database_default = ALU.RA collate database_default AND 
								                                     par.mes_competencia = left(PRX.competencia, charindex('/', PRX.competencia)-1) and
                                                                     par.ano_competencia = right(PRX.competencia, len(PRX.competencia) - charindex('/', PRX.competencia)))
                             left join financeiro_lancamento lan on (par.id = lan.parcela_id)
                             left join contratos_desconto    dsc on (par.id = dsc.parcela_id)
							 left join financeiro_conta      fnc on (fnc.pessoa_id = alu.pessoa_id)
 where lan.id is null 


 --#########################################################################################


     update lan set
       lan.status_id = case when vwp.boleto_id is null then 1 else 5 end , 
	   lan.pago_em = case when vwp.boleto_id is null then null else bol.data_pagamento end ,
	   lan.valor_pago = case when vwp.boleto_id is null then 0 else vwp.value end 
 --  select par.plano_nome, lan.*, vwp.*
  from financeiro_lancamento lan join curriculos_aluno cra on (cra.id = lan.curriculo_aluno_id)
                                 join academico_aluno  alu on (alu.id = cra.aluno_id)
								 join rem_prd..vw_valor_final_parcela vwp on (vwp.ra collate database_default = alu.ra collate database_default and 
								                                              lan.mes_competencia = left(vwp.competencia, charindex('/', vwp.competencia)-1) and 
																			  lan.ano_competencia = right(vwp.competencia, len(vwp.competencia) - charindex('/', vwp.competencia)))
                                 join rem_prd..vw_parcelas            par on (par.ra collate database_default= alu.ra collate database_default and
								                                              par.COMPETENCIA = vwp.competencia)
                            left join boletos_service.db_owner.vw_boleto      bol on (bol.boleto_id = vwp.boleto_id) 
where par.plano_nome <> 'mensal'
