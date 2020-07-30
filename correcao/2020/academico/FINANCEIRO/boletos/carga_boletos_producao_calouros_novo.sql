
---#####################################################################################  
--  IMPORTACAO DAS INFORMACOES DE PARCELAS E DESCONTOS DOS ALUNOS (CALOUROS) 
---#####################################################################################

--------------------------------------------------------------------------------------------------------------------
-- ****** INSERIR CONTRATOS 
			--* QUANDO NAO EXISTIR UM RESPONSAVEL CADASTRADO NA PESSOAS_PESSOA, O ALUNO SERA SEU PROPRIO RESPONSAVEL
--------------------------------------------------------------------------------------------------------------------

insert into contratos_contrato (criado_em, atualizado_em, valor, valor_parcela, num_parcelas, num_fiadores, aluno_id, criado_por, curriculo_id, etapa_ano_id, responsavel_financeiro_id, atualizado_por)
select distinct   criado_em = getdate(), atualizado_em = getdate(), valor = -1, valor_parcela = -1, num_parcelas = -1, num_fiadores = ISNULL(fia.qtd_fiadores,0), 
                  aluno_id = alu.id, criado_por = 2136, curriculo_id = CUR.id, etapa_ano_id= null , 
				  responsavel_financeiro_id = isnull(pes.id, alu.pessoa_id) , atualizado_por = 2136

  from  academico_aluno alu   join mat_prd..vw_parcelas               par on (par.ra collate database_default = alu.ra collate database_default)
                              JOIN CURRICULOS_CURRICULO               CUR ON (CUR.nome COLLATE DATABASE_DEFAULT = PAR.CURRICULO_NOME COLLATE DATABASE_DEFAULT)
						 LEFT JOIN mat_prd..vw_responsavel_financeiro rsp on (rsp.ra collate database_default = par.ra collate database_default and 
						                                                      rsp.competencia collate database_default = par.COMPETENCIA collate database_default)
						 left join pessoas_pessoa                     pes on (pes.cpf collate database_default = rsp.cpf collate database_default)
                         left join mat_prd..vw_fiadores               fia on (par.ra = fia.ra)
  where  
		 not exists (select 1 from contratos_contrato contx
		             where contx.aluno_id =  alu.id  )

-- ##########################################################
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
         from contratos_contrato con join academico_aluno alu on (con.aluno_id = alu.id)
                                     join mat_prd..vw_parcelas par on ( alu.ra collate database_default = par.ra collate database_default)
         where 
		       left(par.competencia, charindex('/', par.competencia)-1) >1 and 
		       not exists (select 1 from contratos_parcela parx
			               where parx.contrato_id = con.id and
						         parx.mes_competencia = left(par.competencia, charindex('/', par.competencia)-1) and
                                 parx.ano_competencia = right(par.competencia, len(par.competencia) - charindex('/', par.competencia)))

-- ##########################################################
--------------------------------------------------------------------------------------------------------------------
-- ****** INSERIR DESCONTOS REFERENTES A UMA PARCELA 
--------------------------------------------------------------------------------------------------------------------
insert into contratos_desconto ( descricao, porcentagem, valor, parcela_id, tipo_id, criado_em, criado_por, atualizado_em, atualizado_por)
select descricao = 'desconto ' + DES.COMPETENCIA, porcentagem = null, valor = des.valor, parcela_id = par.id, tipo_id = 2,
       criado_em = getdate(), criado_por = 2136, atualizado_em = getdate(), atualizado_por = 2136
from contratos_contrato con join academico_aluno alu on (con.aluno_id = alu.id)
                                     join mat_prd..vw_descontos des on ( alu.ra collate database_default = des.ra collate database_default)
								     join contratos_parcela par on (par.contrato_id = con.id and 
									                                par.mes_competencia = left(des.competencia, charindex('/', des.competencia)-1) and
																	par.ano_competencia = right(des.competencia, len(des.competencia) - charindex('/', des.competencia)))
where  
	   not exists (select 1  
	               from contratos_desconto desx 
				   where desx.parcela_id = par.id and 
				         desx.valor      = des.valor)


