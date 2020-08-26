with cte_problemas as (
select distinct tmp.* from tmp_imp_escola_1dia tmp left join auth_user usu  on (json_value(usu.extra, '$.hierarchy.unity.name') = tmp.nome_escola_ava and 
	                                                              json_value(usu.extra, '$.hierarchy.grade.name') = tmp.avaliacao_diagnostica)
where usu.id is null  

union 

select distinct tmp.nome_escola_ava, tmp.avaliacao_diagnostica, tmp.janela_aplicacao, tmp.dia_aplicacao
from tmp_imp_escola_2dia tmp left join auth_user usu  on (json_value(usu.extra, '$.hierarchy.unity.name') = tmp.nome_escola_ava and 
	                                                              json_value(usu.extra, '$.hierarchy.grade.name') = tmp.avaliacao_diagnostica)
where usu.id is null )


select distinct cte.*,json_value(usu.extra, '$.hierarchy.grade.name')
--update tmp set tmp.avaliacao_diagnostica = json_value(usu.extra, '$.hierarchy.grade.name')
from cte_problemas cte -- join tmp_imp_escola_1dia tmp on (tmp.avaliacao_diagnostica = cte.avaliacao_diagnostica and 
                       --                                 tmp.nome_escola_ava = cte.nome_escola_ava and
					   --								  tmp.dia_aplicacao = cte.dia_aplicacao)
                       left join auth_user usu on (json_value(usu.extra, '$.hierarchy.unity.name') = cte.nome_escola_ava and 
					                               json_value(usu.extra, '$.hierarchy.grade.name') = cte.avaliacao_diagnostica)

	where cte.avaliacao_diagnostica = '3ª série' 
	
	cte.avaliacao_diagnostica <> json_value(usu.extra, '$.hierarchy.grade.name') and 
	     left(reverse(json_value(usu.extra, '$.hierarchy.grade.name')), charindex(' ', reverse(json_value(usu.extra, '$.hierarchy.grade.name')))) = left(reverse(cte.avaliacao_diagnostica),charindex(' ',reverse(cte.avaliacao_diagnostica)))
	
