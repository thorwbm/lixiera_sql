select id, criado_em, atualizado_em, valor, valor_parcela, num_parcelas, num_fiadores, aluno_id, criado_por, curriculo_id, etapa_ano_id, responsavel_financeiro_id, atualizado_por

  select * from contratos_contrato


  /*
insert into contratos_contrato (criado_em, atualizado_em, valor, valor_parcela, num_parcelas, num_fiadores, aluno_id, criado_por, curriculo_id, etapa_ano_id, responsavel_financeiro_id, atualizado_por)
--select distinct alu.id as aluno_id, etc.etapaano_id, alu.pessoa_id,cra.curriculo_id 
select distinct   criado_em = getdate(), atualizado_em = getdate(), valor = -1, valor_parcela = -1, num_parcelas = -1, num_fiadores = 0, 
                  aluno_id = alu.id, criado_por = 2137, curriculo_id = cra.curriculo_id, etapa_ano_id= null , 
				  responsavel_financeiro_id = alu.pessoa_id, atualizado_por = 2137

  from  academico_aluno alu  join rem_hmg_20200210..vw_parcelas par on (par.ra collate database_default = alu.ra collate database_default)
							 join curriculos_aluno              cra on (cra.aluno_id = alu.id)

  where cra.status_id = 13 and 
         par.competencia = '2/2020' 

insert into contratos_parcela (criado_em, atualizado_em, descricao, data_vencimento, valor, mes_competencia, ano_competencia, contrato_id, criado_por, tipo_id, atualizado_por)
select criado_em = getdate(), atualizado_em = getdate(), descricao = 'parcela mes 2', data_vencimento = '2020-02-05', valor = par.VALOR, 
       mes_competencia = 2, ano_competencia = 2020, contrato_id = con.id, criado_por = 2137, tipo_id = 2, atualizado_por = 2137
         from contratos_contrato con join academico_aluno alu on (con.aluno_id = alu.id)
                                     join rem_hmg_20200210..vw_parcelas par on ( alu.ra collate database_default = par.ra collate database_default)


-- ##########################################################
select * from contratos_desconto

insert into contratos_desconto ( descricao, porcentagem, valor, parcela_id, tipo_id)
select descricao = 'desconto 2/2020', porcentagem = null, valor = des.valor, parcela_id = par.id, tipo_id = 2
from contratos_contrato con join academico_aluno alu on (con.aluno_id = alu.id)
                                     join rem_hmg_20200210..vw_descontos des on ( alu.ra collate database_default = des.ra collate database_default)
								     join contratos_parcela par on (par.contrato_id = con.id)


-- ##########################################################

--insert into contratos_desconto ( descricao, porcentagem, valor, parcela_id, tipo_id)
select descricao = 'desconto FIES 2/2020', porcentagem = null, valor = des.valor, parcela_id = par.id, tipo_id = 2
from contratos_contrato con join academico_aluno alu on (con.aluno_id = alu.id)
                                     join rem_hmg_20200210..vw_descontos_fies des on ( alu.ra collate database_default = des.ra collate database_default)
								     join contratos_parcela par on (par.contrato_id = con.id AND 
									                                PAR.mes_competencia = LEFT(DES.COMPETENCIA, CHARINDEX('/',DES.COMPETENCIA)-1) AND 
																	PAR.ano_competencia = RIGHT(DES.COMPETENCIA, LEN(DES.COMPETENCIA) - CHARINDEX('/',DES.COMPETENCIA)))
*/

select * from contratos_contrato con join contratos_parcela par on (con.id = par.contrato_id)
                                    left join contratos_desconto des on (par.id = des.parcela_id)