declare @passo varchar(200)

begin try
begin tran 
---#####################################################################################  
--  IMPORTACAO DAS INFORMACOES DE PARCELAS E DESCONTOS DOS ALUNOS (CALOUROS) 
---#####################################################################################
--------------------------------------------------------------------------------------------------------------------
-- ****** INSERIR CONTRATOS 
			--* QUANDO NAO EXISTIR UM RESPONSAVEL CADASTRADO NA PESSOAS_PESSOA, O ALUNO SERA SEU PROPRIO RESPONSAVEL
--------------------------------------------------------------------------------------------------------------------
-- COMMIT 
set @passo = 'contrato'
BEGIN TRAN insert into contratos_contrato (criado_em, atualizado_em, valor, valor_parcela, num_parcelas, num_fiadores, aluno_id, criado_por, curriculo_id, etapa_ano_id, responsavel_financeiro_id, atualizado_por, data_matricula)
select distinct criado_em = getdate(), 
                atualizado_em = getdate(), 
				valor = PAR.VALOR_CONTRATO, valor_parcela = -1, 
				num_parcelas =  PAR.QTD_PARCELA_CONTRATO, 
				num_fiadores = ISNULL(fia.qtd_fiadores,0), 
                aluno_id = alu.id, criado_por = 11717, 
				curriculo_id = CUR.id, etapa_ano_id= null, 
				responsavel_financeiro_id = isnull(pes.id, alu.pessoa_id), 
				atualizado_por = 11717,
				par.data_matricula
  from  academico_aluno alu   join VW_FNC_PARCELA_MAT_REM        par on (par.ra collate database_default = alu.ra collate database_default)
                              JOIN CURRICULOS_CURRICULO          CUR ON (CUR.nome COLLATE DATABASE_DEFAULT = PAR.CURRICULO_NOME COLLATE DATABASE_DEFAULT)
						 LEFT JOIN vw_FNC_responsavel_financeiro rsp on (rsp.ra collate database_default = par.ra collate database_default and 
						                                                 rsp.competencia collate database_default = par.COMPETENCIA collate database_default)
						 left join pessoas_pessoa                pes on (pes.cpf collate database_default = rsp.cpf collate database_default)
                         left join vw_FNC_QTD_fiadores           fia on (par.ra = fia.ra)
  where  
       PAR.GRATUIDADE_ID is null and       
       PAR.DESCONTO_ID is null and               
       PAR.PERIODO_CORRENTE = 1  AND   
	   PAR.STATUS_MATRICULA_ID  = 11 AND 
	  -- PAR.MES_COMPETENCIA = 1 AND 
	   STATUS_PARCELA = 'PAGO' AND
		 not exists (select 1 from contratos_contrato contx
		             where contx.aluno_id =  alu.id  )
 
--####################################################################################
--------------------------------------------------------------------------------------------------------------------
-- ****** INSERIR CONTA PARA TODOS OS CONTRATOS
--------------------------------------------------------------------------------------------------------------------
 set @passo = 'conta'
 insert into financeiro_conta (criado_em, atualizado_em, saldo, criado_por, pessoa_id, atualizado_por, titular_id)
	   select criado_em = getdate(), atualizado_em = getdate(), saldo = 0.0, criado_por = 11717, 
	          pessoa_id = alu.pessoa_id , atualizado_por = 11717, titular_id = ALU.PESSOA_ID  
	     from contratos_contrato con join academico_aluno  alu on (alu.id = con.aluno_id)
	                            left join financeiro_conta fcn on (fcn.pessoa_id = alu.pessoa_id)
where fcn.id is null 
-- ##################################################################################
--------------------------------------------------------------------------------------------------------------------
-- ****** INSERIR PARCELAS REFERENTES A UM CONTRATO 
--------------------------------------------------------------------------------------------------------------------
set @passo = 'inserir parcela'
-- COMMIT 
-- ROLLBACK 
BEGIN TRAN insert into contratos_parcela (criado_em, atualizado_em, descricao, data_vencimento, valor, mes_competencia, ano_competencia, contrato_id, criado_por, tipo_id, atualizado_por)
select criado_em       = getdate(), 
       atualizado_em   = getdate(), 
       descricao       = 'parcela mes ' + par.competencia, 
	   data_vencimento = par.data_vencimento, valor = par.VALOR, 
       mes_competencia = par.mes_competencia, 
	   ano_competencia = par.ano_competencia, 
	   contrato_id     = con.id, criado_por = 11717,
	   tipo_id         = case when par.transacao_tipo_id in (1,3) then 2 
	                          when par.transacao_tipo_id in (2,4) then 1 end, 
	   atualizado_por  = 11717
         from contratos_contrato con join academico_aluno alu on (con.aluno_id = alu.id)
                                     join VW_FNC_PARCELA_MAT_REM par on ( alu.ra collate database_default = par.ra collate database_default)
         where
       PAR.GRATUIDADE_ID is null and       
       PAR.DESCONTO_ID is null and               
       PAR.PERIODO_CORRENTE = 1  AND   
	   PAR.STATUS_MATRICULA_ID  = 11 AND 
	  -- PAR.MES_COMPETENCIA = 1 AND 
	   STATUS_PARCELA = 'PAGO' AND
		 not exists (select 1 from contratos_parcela parx
			                 where parx.contrato_id     = con.id and
						           parx.mes_competencia = par.mes_competencia and
                                   parx.ano_competencia = par.ano_competencia)

-- ##########################################################
--------------------------------------------------------------------------------------------------------------------
-- ****** INSERIR DESCONTOS REFERENTES A UMA PARCELA 
--------------------------------------------------------------------------------------------------------------------
set @passo = 'inserir desconto'
-- COMMIT 
-- ROLLBACK 
BEGIN TRAN insert into contratos_desconto ( descricao, porcentagem, valor, parcela_id, tipo_id, criado_em, criado_por, atualizado_em, atualizado_por)
select descricao = 'desconto ' + DES.COMPETENCIA, porcentagem = null, valor = des.valor, parcela_id = par.id, 
       tipo_id = ISNULL(tpd.id, CASE WHEN DES.DESCONTO_NOME = 'ANTECIPAÇÃO: 3,5% DESCONTO SEMESTRAL' then 10 else null end), 
	  -- DES.DESCONTO_NOME, 
       criado_em = getdate(), criado_por = 11717, 
	   atualizado_em = getdate(), atualizado_por = 11717
from contratos_contrato con join academico_aluno         alu on (con.aluno_id = alu.id)
                            join VW_FNC_DESCONTO_MAT_REM des on (alu.ra collate database_default = des.ra collate database_default)
						    join contratos_parcela       par on (par.contrato_id = con.id and 
						                                         par.mes_competencia = des.mes_competencia and
										     		             par.ano_competencia = des.ano_competencia)
					   left join contratos_tipodesconto  tpd on (tpd.descricao collate database_default = des.desconto_nome collate database_default )
where GRATUIDADE_ID IS NULL AND 
	  MATRICULA_STATUS_ID = 11 AND 
	  PERIODO_CORRENTE = 1 AND 
	  isnull(pesSOA_prouni,0) = 0 AND 
not exists (select 1  
	               from contratos_desconto desx 
				   where desx.parcela_id = par.id and 
				         desx.valor      = des.valor)
		
		SELECT * FROM contratos_tipodesconto
-- ##########################################################
--------------------------------------------------------------------------------------------------------------------
-- ****** INSERIR LANCAMENTOS REFERENTES A UMA PARCELA  DESDE QUE JA NAO EXISTA
--------------------------------------------------------------------------------------------------------------------
set @passo = 'inserir lancamento'
-- COMMIT 
-- ROLLBACK 
BEGIN TRAN insert into financeiro_lancamento (criado_em, atualizado_em, mes_competencia, ano_competencia, data_vencimento, pago_em, valor_bruto, valor_liquido, 
                                   pagamento_por_remessa, conta_id, contrato_id, criado_por, curriculo_aluno_id, operacao_id, parcela_id, protocolo_id, 
                                   status_id, tipo_id, atualizado_por, extra, responsavel_id, valor_pago, valor_acrescimos,valor_desconto_pontualidade)
select distinct 
       criado_em = getdate(), atualizado_em = getdate(), par.mes_competencia, par.ano_competencia, par.data_vencimento, pago_em = PRX.data_pagamento, 
	   valor_bruto = par.valor , valor_liquido = par.valor - sum( isnull(dsc.valor,0)) , pagamento_por_remessa = 1, conta_id = fnc.id, par.contrato_id, 
	   criado_por = 11717, curriculo_aluno_id = cra.id, operacao_id = 2, parcela_id = par.id, protocolo_id= null , 
	   status_id = case when PRX.status_parcela = 'PAGO' THEN 5 ELSE 1 END ,
	   tipo_id = case when PRX.transacao_tipo_id in (1,3) then 2 
	                  when PRX.transacao_tipo_id in (2,4) then 1 end,
	   atualizado_por = 11717, extra = null, responsavel_id = con.responsavel_financeiro_id, 
	   valor_pago = isnull(prx.valor_pago,0), valor_acrescimos=0,valor_desconto_pontualidade =0
--select *
  from contratos_parcela par      join contratos_contrato    con on (con.id = par.contrato_id)
                                  join academico_aluno       alu on (alu.id = con.aluno_id )
								  join curriculos_aluno      cra on (alu.id = cra.aluno_id and cra.status_id = 12)
								  JOIN mat_prd..vw_parcela_matricula  PRX ON (PRX.RA collate database_default = ALU.RA collate database_default AND 
								                                     par.mes_competencia = PRX.mes_competencia and
                                                                     par.ano_competencia = PRX.ano_competencia and
																	 prx.status_matricula_id = 11 and 
																	 prx.desconto_id is null and 
																	 prx.gratuidade_id is null )
                             left join financeiro_lancamento lan on (par.id = lan.parcela_id)
                             left join contratos_desconto    dsc on (par.id = dsc.parcela_id)
							 left join financeiro_conta      fnc on (fnc.pessoa_id = alu.pessoa_id)
							 
where lan.id is null   and prx.status_parcela = 'pago' 
	group by par.mes_competencia, par.ano_competencia, par.data_vencimento, PRX.data_pagamento,  par.valor , 
	         fnc.id, par.contrato_id,  cra.id, par.id, PRX.status_parcela,con.responsavel_financeiro_id, prx.valor_pago, PRX.transacao_tipo_id
 
-- ##########################################################
--------------------------------------------------------------------------------------------------------------------
-- ****** CORRECAO DOS VALORES DOS LANCAMENTOS PAGOS PARA OS LANCAMENTOS QUE NAO SEJAM MENSAL
--------------------------------------------------------------------------------------------------------------------
set @passo = 'atualizar lancamento'
     update lan set
       lan.status_id  = case when vwp.boleto_id is null then 1 else 5 end , 
	   lan.pago_em    = case when vwp.boleto_id is null then null else bol.data_pagamento end ,
	   lan.valor_pago = case when vwp.boleto_id is null then 0 else vwp.value end 
 -- select * 
 from financeiro_lancamento lan join curriculos_aluno                   cra on (cra.id = lan.curriculo_aluno_id)
                                 join academico_aluno                    alu on (alu.id = cra.aluno_id)
								 join mat_prd..vw_valor_final_parcela    vwp on (vwp.ra collate database_default = alu.ra collate database_default and 
								                                                 lan.mes_competencia = vwp.mes_competencia and 
																			     lan.ano_competencia = vwp.ano_competencia)
                                 join mat_prd..vw_parcela_matricula               par on (par.ra collate database_default= alu.ra collate database_default and
								                                                          par.COMPETENCIA = vwp.competencia and 
																						  par.status_matricula_id = 11 and 
																						  par.desconto_id is null and 
																						  par.gratuidade_id is null )
                            left join boletos_service.db_owner.vw_boleto bol on (bol.boleto_id = vwp.boleto_id) 
where par.plano_nome <> 'MENSAL' AND  
      vwp.boleto_id IS NOT NULL  and 
	   cast(lan.criado_em as date) >= cast(DATEADD(day, -1,getdate()) as date)

commit
print ('sucesso')
end try 
begin catch

rollback 
 print @passo
end catch 


