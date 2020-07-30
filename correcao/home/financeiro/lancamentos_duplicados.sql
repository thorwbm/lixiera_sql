WITH cte AS (
    SELECT *, ROW_NUMBER() OVER (
            PARTITION BY 
                mes_competencia, 
                ano_competencia, 
                data_vencimento,
                valor_bruto,
                responsavel_id, 
              --  curriculo_aluno_id,
                conta_id
            ORDER BY 
                id
        ) row_num
     FROM 
       financeiro_lancamento
       where classificacao_id is null
)
select distinct 
       cap.aluno_ra, cap.aluno_nome, cap.curriculo_nome,
       cte.id, conta_id, responsavel_id, mes_competencia, ano_competencia, valor_bruto, cte.curriculo_aluno_id, data_vencimento
       , case when tra.id is null then 'sem remessa' else 'com remessa' end
  from cte join vw_Curriculo_aluno_pessoa cap on (cap.curriculo_aluno_id = cte.curriculo_aluno_id)
      left join financeiro_transacao tra on (cte.id = tra.lancamento_id)

 where  row_num > 1
       -- and tra.id is null 



select conta_id, responsavel_id, mes_competencia, ano_competencia, valor_bruto, data_vencimento
from financeiro_lancamento
where classificacao_id is null
--where ano_competencia = 2020 and curriculo_aluno_id is not null 
group by conta_id, responsavel_id, mes_competencia, ano_competencia, valor_bruto,  data_vencimento
having count(1) > 1

order by 1,2,4,3

select * from financeiro_statuslancamento
where conta_id = 142 and mes_competencia = 10 and ano_competencia = 2020 and curriculo_aluno_id = 38085

