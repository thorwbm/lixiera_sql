select * , diferenca = (bas.qtd - pre.qtd), diferenca_porcentagem = abs( cast(round( (bas.qtd - pre.qtd)*100/(bas.qtd *1.0),2) as numeric(10,2)))
from vw_tabela_preenchimento_base bas with (nolock) 
join vw_tabela_preenchimento pre  with (nolock) on (bas.tabela = pre.tabela)
where bas.qtd <> pre.qtd

order by 4 desc

select * from vw_monitoriamento_sincronismo
order by 5 desc