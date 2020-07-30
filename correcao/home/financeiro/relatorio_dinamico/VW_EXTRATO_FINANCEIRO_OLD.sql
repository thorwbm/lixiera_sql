  
CREATE     VIEW [dbo].[VW_EXTRATO_FINANCEIRO] AS       
with CTE_AGRUPAMENTO_1 AS (      
select lan.contrato_id, lan.mes_competencia, lan.ano_competencia, lan.valor_bruto,       
          lan.valor_liquido, lan.valor_pago, TPD.grupo_totalizador_id AS GRUPO_ID,   
    SUM(ISNULL(FDS.VALOR,0)) AS VALOR_DESCONTO--, lan.responsavel_id      
     from financeiro_lancamento lan  join financeiro_desconto fds on (lan.id = fds.lancamento_id)   
                                LEFT join contratos_tipodesconto tpd on (tpd.id = fds.tipo_id)       
    group by lan.contrato_id, lan.mes_competencia, lan.ano_competencia, lan.valor_bruto, lan.valor_liquido, lan.valor_pago, TPD.grupo_totalizador_id-- , lan.responsavel_id      
)       
 , CTE_AGRUPAMENTO_2 AS (      
   select lan.contrato_id, lan.mes_competencia, lan.ano_competencia, lan.valor_bruto, lan.valor_liquido,       
          lan.valor_pago, GRU.ID AS GRUPO_ID, GRU.NOME AS GRUPO_NOME--, lan.responsavel_id      
              from financeiro_lancamento lan  JOIN contratos_grupototalizador GRU ON (1=1)                                             
          group by lan.contrato_id, lan.mes_competencia, lan.ano_competencia, lan.valor_bruto, lan.valor_liquido, lan.valor_pago, GRU.ID, GRU.NOME--, lan.responsavel_id      
)      
      
   SELECT AG2.CONTRATO_ID, AG2.ano_competencia, AG2.mes_competencia, AG2.valor_bruto, AG2.valor_liquido, AG2.valor_pago, AG2.GRUPO_NOME,      
          ISNULL(AG1.VALOR_DESCONTO,0) AS VALOR_DESCONTO --, ag2.responsavel_id      
     FROM CTE_AGRUPAMENTO_2 AG2 LEFT JOIN CTE_AGRUPAMENTO_1 AG1 ON (AG2.CONTRATO_ID = AG1.CONTRATO_ID AND       
                                                                    AG2.mes_competencia = AG1.MES_COMPETENCIA AND       
                                                                    AG2.ano_competencia = AG1.ANO_COMPETENCIA AND      
                                                                    AG2.GRUPO_ID        = AG1.GRUPO_ID)  
    UNION -- HOT FIX: O PROUNI não é um desconto isso foi uma forma de exibir os dados  
        select l.CONTRATO_ID, l.ano_competencia, l.mes_competencia, l.valor_bruto, l.valor_liquido, l.valor_pago, 'VALOR PROUNI' [GRUPO_NOME], l.valor_bruto [VALOR_DESCONTO]  
         --,l.responsavel_id  
    from financeiro_lancamento l join pessoas_pessoa p on (p.id = l.responsavel_id)  
         where p.nome = 'PROUNI'  
    