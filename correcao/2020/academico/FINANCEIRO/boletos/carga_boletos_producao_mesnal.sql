---#####################################################################################  
--  IMPORTACAO DAS INFORMACOES DE PARCELAS E DESCONTOS DOS ALUNOS (VETERANOS) 
---#####################################################################################

--------------------------------------------------------------------------------------------------------------------
-- ****** INSERIR CONTRATOS 
			--* O ALUNO SERA SEU PROPRIO RESPONSAVEL
--------------------------------------------------------------------------------------------------------------------

--insert into contratos_contrato (criado_em, atualizado_em, valor, valor_parcela, num_parcelas, num_fiadores, aluno_id, criado_por, curriculo_id, etapa_ano_id, responsavel_financeiro_id, atualizado_por)
select distinct   criado_em = getdate(), atualizado_em = getdate(), valor = -1, valor_parcela = -1, num_parcelas = -1, num_fiadores = fia.qtd_fiadores, 
                  aluno_id = alu.id, criado_por = 2137, curriculo_id = cra.curriculo_id, etapa_ano_id= null , 
				  responsavel_financeiro_id = alu.pessoa_id, atualizado_por = 2137--, par.ra
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

insert into contratos_parcela (criado_em, atualizado_em, descricao, data_vencimento, valor, mes_competencia, ano_competencia, contrato_id, criado_por, tipo_id, atualizado_por)
select criado_em = getdate(), atualizado_em = getdate(), 
       descricao = 'parcela mes ' + left(par.competencia, charindex('/', par.competencia)-1), 
	   data_vencimento = par.data_vencimento, valor = par.VALOR, 
       mes_competencia = left(par.competencia, charindex('/', par.competencia)-1) , 
	   ano_competencia = right(par.competencia, len(par.competencia) - charindex('/', par.competencia)), 
	   contrato_id = con.id, criado_por = 2136, tipo_id = 2, atualizado_por = 2136
	   , par.plano_nome
         from contratos_contrato con join academico_aluno alu on (con.aluno_id = alu.id)
                                     join rem_prd..vw_parcelas par on ( alu.ra collate database_default = par.ra collate database_default)
         where par.plano_nome = 'mensal' and 
		       left(par.competencia, charindex('/', par.competencia)-1) >1 and 
		       not exists (select 1 from contratos_parcela parx
			               where parx.contrato_id = con.id and
						         parx.mes_competencia = left(par.competencia, charindex('/', par.competencia)-1) and
                                 parx.ano_competencia = right(par.competencia, len(par.competencia) - charindex('/', par.competencia))	)

-- ##########################################################
--------------------------------------------------------------------------------------------------------------------
-- ****** INSERIR DESCONTOS REFERENTES A UMA PARCELA 
--------------------------------------------------------------------------------------------------------------------

--insert into contratos_desconto ( descricao, porcentagem, valor, parcela_id, tipo_id, criado_em, criado_por, atualizado_em, atualizado_por)
select descricao = 'desconto ' + DES.COMPETENCIA, porcentagem = null, valor = des.valor, parcela_id = par.id, tipo_id = 2,
       criado_em = getdate(), criado_por = 2136, atualizado_em = getdate(), atualizado_por = 2136, des.ra
from contratos_contrato con join academico_aluno alu on (con.aluno_id = alu.id)
                                     join rem_prd..vw_descontos des on ( alu.ra collate database_default = des.ra collate database_default)
								     join contratos_parcela par on (par.contrato_id = con.id and 
									                                par.mes_competencia = left(des.competencia, charindex('/', des.competencia)-1) and
																	par.ano_competencia = right(des.competencia, len(des.competencia) - charindex('/', des.competencia)))
where des.ra in (

'1142.000064',
'1161.000074',
'20104.00068',
'1161.000031',
'1181.000079',
'1190.000153'
)
and 


not exists (select 1  
	               from contratos_desconto desx 
				   where desx.parcela_id = par.id and 
				         desx.valor      = des.valor)


-- ##########################################################

select * from rem_prd..vw_parcelas where ra in (
'1142.000064',
'1181.000079',
'1190.000153'
)

select * from rem_prd..vw_descontos where ra in (
'1142.000064',
'1181.000079',
'1190.000153'
)