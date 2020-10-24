select alu.nome, lan.id as lancamento_id, 
        lan.mes_competencia, lan.ano_competencia, format(lan.data_vencimento,'dd/MM/yyyy') as data_vencimento ,  format(lan.pago_em,'dd/MM/yyyy') as pago_em, valor_bruto, valor_pago,
		par.id, par.ano_competencia, par.mes_competencia, lan.criado_em, lan.status_id

	-- update lan set lan.mes_competencia = 7
	-- update par set par.mes_competencia = 7

  from academico_aluno alu join financeiro_conta con on (con.pessoa_id = alu.pessoa_id)
                           join financeiro_lancamento lan on (con.id =  lan.conta_id)
					       join contratos_parcela     par on (par.id = lan.parcela_id)
where alu.nome in (
'ISABELA JULIANA MARTINS',
'GABRIELA GONÇALVES ALAM',
'ROSELI SOARES DOS REIS',
'MARIANE BÁRBARA MAURA DE ANDRADE'
)
and lan.mes_competencia =1 and lan.ano_competencia = 2020 --and par.mes_competencia = 1


select * from financeiro_statuslancamento

select alu.nome, lan.id as lancamento_id, 
        lan.mes_competencia, lan.ano_competencia, format(lan.data_vencimento,'dd/MM/yyyy') as data_vencimento ,  format(lan.pago_em,'dd/MM/yyyy') as pago_em, valor_bruto, valor_pago,
		par.id, par.ano_competencia, par.mes_competencia, lan.status_id
  from academico_aluno alu join financeiro_conta con on (con.pessoa_id = alu.pessoa_id)
                           join financeiro_lancamento lan on (con.id =  lan.conta_id)
					       join contratos_parcela     par on (par.id = lan.parcela_id)
where alu.nome in (
'ISABELA JULIANA MARTINS',
'GABRIELA GONÇALVES ALAM',
'ROSELI SOARES DOS REIS',
'MARIANE BÁRBARA MAURA DE ANDRADE'
)
and lan.mes_competencia =7 and lan.ano_competencia = 2020-- and par.mes_competencia = 1



