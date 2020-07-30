with cte_pessoa_dup as (
			select nome, CPF
			from pessoas_pessoa
			where cpf is not null
			group by nome, CPF 
			having count(1) > 1 
) 
	,	cte_responsavel as (			
			select responsavel_financeiro_id,tabela = 'contratos_contrato '  from contratos_contrato          union
			select responsavel_financeiro_id,tabela = 'contratos_financiamento'  from contratos_financiamento union
			select responsavel_id           ,tabela = 'financeiro_lancamento '  from financeiro_lancamento 	  union
			select responsavel_id           ,tabela = 'financeiro_responsavel '  from financeiro_responsavel  
	)

			 select   pes.id, pes.nome, pes.cpf from pessoas_pessoa pes join cte_pessoa_dup dup on (dup.nome = pes.nome) 
			                                                          join cte_responsavel res on (pes.id = res.responsavel_financeiro_id)
