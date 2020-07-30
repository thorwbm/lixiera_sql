with cte_tratar as (
			select nome, cpf
			from pessoas_pessoa 
			group by nome, cpf
			having count(1) > 1
)
	,	cte_tratar_1 as (
			select pes.id, pes.nome, pes.cpf from pessoas_pessoa pes join cte_tratar tra on (pes.nome = tra.nome and 
			                                                         isnull(pes.cpf,0)  = isnull(tra.cpf,0))
)
	,	cte_tratar_final as (
        select distinct cte1.nome, cte1.cpf,  
		menor = case when cte1.id < cte2.id then cte1.id else cte2.id end,
        maior = case when cte1.id > cte2.id then cte1.id else cte2.id end
		from cte_tratar_1 cte1 join cte_tratar_1 cte2 	on (isnull(cte1.cpf,0) = isnull(cte2.cpf,0) and 
		                                                    cte1.nome = cte2.nome)	
		where case when cte1.id < cte2.id then cte1.id else cte2.id end <> case when cte1.id > cte2.id then cte1.id else cte2.id end
)
	
		select * into #tmp from cte_tratar_final order by 1


	declare @nome varchar(max), @cpf varchar(50), @menor int, @maior int
 
declare CUR_ cursor for 
	SELECT nome, cpf, menor, maior FROM #tmp
	open CUR_ 
		fetch next from CUR_ into @nome, @cpf, @menor, @maior
		while @@FETCH_STATUS = 0
			BEGIN
				
				EXEC SP_ALTERAR_VALOR_EM_TODO_BANCO_FK 'PESSOAS_PESSOA', 'ID', @maior, @menor				
				EXEC SP_GERAR_LOG 'PESSOAS_PESSOA', @maior, '-', 11717, NULL, NULL, NULL
				DELETE FROM PESSOAS_PESSOA WHERE ID = @maior

			fetch next from CUR_ into @nome, @cpf, @menor, @maior
			END
	close CUR_ 
deallocate CUR_ 