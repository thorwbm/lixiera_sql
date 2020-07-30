with cte_tratar as (
			select nome
			from pessoas_pessoa 
			group by nome
			having count(1) > 1
)
--	,	cte_tratar_1 as (
			select pes.id, pes.nome, pes.cpf, pes.rg, pes.data_nascimento
			, pes.pai_id, pes.mae_id, pes.sexo_id
			from pessoas_pessoa pes join cte_tratar tra on (pes.nome = tra.nome) 


		    order by nome
