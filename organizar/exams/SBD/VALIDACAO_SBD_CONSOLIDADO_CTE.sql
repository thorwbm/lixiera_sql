
with cte_base as (
select base, count(1) as qtd_base
from tmp_aux_exam
group by base
) 

SELECT usu.id, usu.name,bas.qtd_base, count(app.exam_id) as qtd_inscricoes
FROM IMP_SBP_CONSOLIDADA con left join auth_user usu on (con.nome = usu.name)
                        left join application_application app on (app.user_id = usu.id )
                        left join tmp_aux_exam tex on (tex.exam_id = app.exam_id and 
							                           con.AREAATUACAO = tex.base)
                        left join cte_base     bas on (bas.base = tex.base)

group by usu.id, usu.name,bas.qtd_base
having bas.qtd_base = count(app.exam_id)





