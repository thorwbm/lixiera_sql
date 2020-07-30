
   declare @coluna_pivot varchar(200), @sql varchar(max)
    exec sp_retorna_campo_pivot 'grupo_nome','VW_EXTRATO_FINANCEIRO', @coluna_pivot output 	
	set @sql = N' SELECT * 
	                FROM (SELECT * from VW_EXTRATO_FINANCEIRO ) em_linha 
					pivot 
					(sum(valor_desconto) for  grupo_nome in ( ' + @coluna_pivot + ')) em_colunas ORDER BY CONTRATO_ID'
      
	  EXEC (@SQL) 

	  select * 
	  -- delete
	  from contratos_grupototalizadordesconto where id = 3

	  -- insert into contratos_grupototalizadordesconto
	  select 'desconto teste_teste'

--    	  where contrato_id = 726 and mes_competencia = 3

/*
create OR ALTER  procedure sp_retorna_campo_pivot @campo varchar(100), @tabela varchar(100), @retorno varchar(1000) output as 
declare @sql varchar(1000)    
declare @retorno_tab table (campos varchar(800))    
   
  set @sql = N' select stuff((    
                   select distinct ' + char(39)+ ',' +char(39) + ' + quotename('+ @campo + ')     
        from ' + @tabela + ' for xml path(' + char(39) + char(39) + ')), 1, 1, '+ char(39) + char(39) + ')'    
 insert into @retorno_tab    
exec (@sql)    
select @retorno = campos from  @retorno_tab    

--##############################################################################
CREATE or alter VIEW VW_EXTRATO_FINANCEIRO AS   
with CTE_AGRUPAMENTO_1 AS (  
   select lan.contrato_id, lan.mes_competencia, lan.ano_competencia, lan.valor_bruto,   
          lan.valor_liquido, lan.valor_pago, TPD.grupototalizador_ID AS GRUPO_ID, SUM(ISNULL(FDS.VALOR,0)) AS VALOR_DESCONTO  
     from financeiro_lancamento lan  join financeiro_desconto fds on (lan.id = fds.lancamento_id)  
           LEFT join contratos_tipodesconto tpd on (tpd.id = fds.tipo_id)  
    group by lan.contrato_id, lan.mes_competencia, lan.ano_competencia, lan.valor_bruto, lan.valor_liquido, lan.valor_pago, TPD.grupototalizador_ID  
)   
 , CTE_AGRUPAMENTO_2 AS (  
   select lan.contrato_id, lan.mes_competencia, lan.ano_competencia, lan.valor_bruto, lan.valor_liquido,   
          lan.valor_pago, GRU.ID AS GRUPO_ID, GRU.NOME AS GRUPO_NOME  
              from financeiro_lancamento lan  JOIN contratos_grupototalizadordesconto GRU ON (1=1)                                           
          group by lan.contrato_id, lan.mes_competencia, lan.ano_competencia, lan.valor_bruto, lan.valor_liquido, lan.valor_pago, GRU.ID, GRU.NOME  
)  
  
   SELECT AG2.CONTRATO_ID, AG2.ano_competencia, AG2.mes_competencia, AG2.valor_bruto, AG2.valor_liquido, AG2.valor_pago, AG2.GRUPO_NOME,  
          ISNULL(AG1.VALOR_DESCONTO,0) AS VALOR_DESCONTO  
     FROM CTE_AGRUPAMENTO_2 AG2   
                           LEFT JOIN CTE_AGRUPAMENTO_1 AG1 ON (AG2.CONTRATO_ID = AG1.CONTRATO_ID AND   
                                                                    AG2.mes_competencia = AG1.MES_COMPETENCIA AND   
                       AG2.ano_competencia = AG1.ANO_COMPETENCIA AND  
                    AG2.GRUPO_ID        = AG1.GRUPO_ID)


*/
	