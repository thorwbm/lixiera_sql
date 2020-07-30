with cte_fone1 as (
			select ciccpf, fone1
				from carga_universus..pessoa
				where ciccpf is not null and 
					  fone1 is not null  and 
					  len(fone1) >= 8
)

	,	cte_fone2 as (
			select ciccpf, fone2
				from carga_universus..pessoa
				where ciccpf is not null and 
					  fone2 is not null  and 
					  len(fone2) >= 8
)

	,	cte_fone3 as (
			select ciccpf, fone3
				from carga_universus..pessoa
				where ciccpf is not null and 
					  fone3 is not null  and 
					  len(fone3) >= 8
)

     select * from cte_fone1 union
     select * from cte_fone2 union
     select * from cte_fone3