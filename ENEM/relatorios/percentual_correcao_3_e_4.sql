
with cte_quantidade_corecao as (
select  case when cor.id_projeto = 7 then 4 else cor.id_projeto end as id_projeto, count(1) * 1.0 as qtd_correcoes

from correcoes_correcao cor join projeto_projeto pro on (pro.id = case when cor.id_projeto = 7 then 4 else cor.id_projeto end)
                            join correcoes_redacao red on (red.id = cor.redacao_id and pro.id = case when red.id_projeto = 7 then 4 else cor.id_projeto end and red.cancelado = 0)
where red.id_redacaoouro is null 
group by case when cor.id_projeto = 7 then 4 else cor.id_projeto end
)
select pro.id as id_projeto,  pro.descricao as projeto,  
       tpc.descricao as tipo_correcao, cast ( round(( count(1)  / qtc.qtd_correcoes),4) * 100 as numeric(10,2)) as porcentagem,
       count(1) as quantidade,   qtc.qtd_correcoes         
from correcoes_correcao cor join correcoes_tipo          tpc on (tpc.id = cor.id_tipo_correcao)
                            join projeto_projeto         pro on (pro.id = case when cor.id_projeto = 7 then 4 else cor.id_projeto end)
							join cte_quantidade_corecao  qtc on (pro.id = qtc.id_projeto)
							

where cor.id_tipo_correcao in (3,4)
group by  pro.id,  pro.descricao, tpc.descricao,  qtc.qtd_correcoes

order by tpc.descricao desc , pro.descricao


select * from correcoes_tipo