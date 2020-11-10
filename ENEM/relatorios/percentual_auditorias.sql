
with cte_quantidade_corecao as (
select  case when cor.id_projeto = 7 then 4 else cor.id_projeto end as id_projeto, count(1) * 1.0 as qtd_correcoes
from correcoes_correcao cor join projeto_projeto pro on (pro.id = case when cor.id_projeto = 7 then 4 else cor.id_projeto end)
                            join correcoes_redacao red on (red.id = cor.redacao_id and pro.id = case when red.id_projeto = 7 then 4 else cor.id_projeto end and red.cancelado = 0)
where red.id_redacaoouro is null 
group by case when cor.id_projeto = 7 then 4 else cor.id_projeto end
)
select pro.id,  pro.descricao AS projeto,  
       tpa.descricao as tipo_auditoria, cast ( round(( count(1)  / qtc.qtd_correcoes),4) * 100 as numeric(10,2)) as porcentagem,
       count(1) as quantidade,   qtc.qtd_correcoes         
from correcoes_correcao cor join correcoes_tipoauditoria tpa on (tpa.id = cor.tipo_auditoria_id)
                            join projeto_projeto         pro on (pro.id = case when cor.id_projeto = 7 then 4 else cor.id_projeto end)
							join cte_quantidade_corecao  qtc on (pro.id = qtc.id_projeto)
where tipo_auditoria_id is not null 
group by  pro.id,  pro.descricao, tpa.descricao,  qtc.qtd_correcoes


select top 100 * from correcoes_redacao where id_redacaoouro is not null 