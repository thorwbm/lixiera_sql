select alu.nome, lan.id as lancamento_id, 
        lan.mes_competencia, lan.ano_competencia, format(lan.data_vencimento,'dd/MM/yyyy') as data_vencimento ,  
		format(pago_em,'dd/MM/yyyy') as pago_em, valor_bruto, valor_pago,
		par.mes_competencia

	--	update lan set lan.mes_competencia = lan.mes_competencia + 6
	--	update par set par.mes_competencia = par.mes_competencia + 6

  from academico_aluno alu join financeiro_conta con on (con.pessoa_id = alu.pessoa_id)
                           join financeiro_lancamento lan on (con.id =  lan.conta_id)
						   join contratos_parcela     par on (par.id = lan.parcela_id)
where alu.nome in (
'LUANA DE BARROS BARRETO',
'SOLAYNE CRISTINA DE RESENDE SILVA',
'LETÍCIA DE ARAÚJO PIRES',
'JULIA ABREU DORNELES',
'BRUNA GUIMARAES CAMILO',
'THIAGO FERRANTE REBELLO DE ANDRADE',
'Raquel Nantes Andrade',
'GUILHERME ANSELMO SILVA',
'JÚLIA RESENDE FERREIRA MAGRI',
'LETHÍCIA MENDONÇA DE OLIVEIRA PINTO',
'ARTHUR DEL FRANCO MARTINS',
'DANIELLE LOREGIAN DA SILVA'
)
and lan.mes_competencia <> 9 
--  and valor_bruto = 45
and lan.data_vencimento > '2020-08-01'
--select * from financeiro_lancamentoboleto where lancamento_id = 35005

--select * from curriculos_aluno where aluno_id in (59942, 61088)

--select * from curriculos_statusaluno





