-- cte com todas as aulas que possuem professor diferente do professor que esta associado ao grupo id 
-- podendo tambem ter professores na tabela aula associado a um grupoaula que nao nao estao relacionados na tabela grupoaula com mesmo id
with cte_problemas as (
		select distinct grupo.id 
		  from academico_aula aula with(nolock)  join academico_grupoaula grupo with(nolock) on (grupo.id = aula.grupo_id)
         where aula.professor_id != grupo.professor_id
)
    -- todos os professores e grupo id que estao relacionados nos problemas de forma distinta na tabela aula
	,cte_aula_professores as (
		select distinct professor_id, grupo_id  
		  from academico_aula aul with(nolock) join cte_problemas pro with(nolock) on (pro.id = aul.grupo_id)
	)

	-- todos os professores e grupo id que estao relacionados nos problemas de forma distinta vindo da tabela grupo
	,cte_grupo_professores as (
		select distinct gpa.professor_id, gpa.ID
		  from academico_grupoaula gpa with(nolock) join cte_problemas pro with(nolock) on (gpa.id = pro.id)
    )

	-- todos os professores da tabela aula que nao estao relacionados na tabela grupo (pode nao existir ou ter relacionamento errado)
	select distinct aul.grupo_id, aul.professor_id, gru.id, gru.professor_id
	  from cte_aula_professores aul with(nolock) left join cte_grupo_professores gru on (aul.grupo_id = gru.id and 
	                                                                                     aul.professor_id = gru.professor_id)
	 where gru.id is null 
	order by aul.grupo_id, aul.professor_id




	
	--select professor_id,* from academico_aula      where grupo_id = 72998	
	--select professor_id,* from academico_grupoaula where id       = 72998