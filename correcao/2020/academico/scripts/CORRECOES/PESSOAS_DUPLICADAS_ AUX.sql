with cte_pessoa_dup as (
			select nome, cpf
			from pessoas_pessoa 
			where cpf is not null 
			group by nome, cpf
			having count(1) > 1
) 
	,	cte_tabelas as (
			select distinct * from (
			select pessoa_id, tabela = 'pessoas_endereco' from pessoas_endereco						  union
			select pessoa_id, tabela = 'financeiro_conta' from financeiro_conta						  union
			select pessoa_id, tabela = 'pessoas_email' from pessoas_email							  union
			select pessoa_id, tabela = 'pessoas_telefone' from pessoas_telefone						  union
			select pessoa_id, tabela = 'academico_pessoa_titulacao' from academico_pessoa_titulacao	  union
			select pessoa_id, tabela = 'academico_aluno' from academico_aluno						  union
			select pessoa_id, tabela = 'contratos_fiador' from contratos_fiador						  union
			select pessoa_id,                 tabela = 'academico_professor' from academico_professor         union
			select person_id                , tabela = 'auth_user              ' from auth_user               union            
			select pai_id                   , tabela = 'pessoas_pessoa         ' from pessoas_pessoa          union            
			select mae_id                   , tabela = 'pessoas_pessoa         ' from pessoas_pessoa          union            
			select responsavel_id           , tabela = 'financeiro_lancamento  ' from financeiro_lancamento   union            
			select responsavel_id           , tabela = 'financeiro_responsavel ' from financeiro_responsavel  union            
			select responsavel_financeiro_id, tabela = 'contratos_financiamento' from contratos_financiamento union           
			select responsavel_financeiro_id, tabela = 'contratos_contrato     ' from contratos_contrato ) as tab      	
)
	,	cte_duplicidade as (
			select pes.nome, pes.cpf, pes.id as pessoa_id 
			from pessoas_pessoa pes join cte_pessoa_dup dup on (pes.nome = dup.nome and pes.cpf = dup.cpf)
)

			select * from cte_duplicidade dup left join cte_tabelas tab on (dup.pessoa_id = tab.pessoa_id)
           --  where tab.pessoa_id is null

			--select * from vw_tabela_coluna where coluna like '%respons%'


           