
create procedure sp_rel_relatorio_financeiro as 
declare @coluna_pivot varchar(200), @sql varchar(max), @sql_create varchar(max)
    exec sp_retorna_campo_pivot 'grupo_nome','VW_EXTRATO_FINANCEIRO', @coluna_pivot output 	

	set @sql_create = @coluna_pivot
	set @sql_create = replace(@coluna_pivot, ',',' float,')
	set @sql_create = N'create table tmp_relatorio_financeiro (contrato_id int, ano_competencia float, mes_competencia int, ' +
	                  'valor_bruto int, valor_liquido float, valor_pago float,' + @sql_create + ' float)'
   
drop table tmp_relatorio_financeiro
	exec (@sql_create)
	
	create index ix__tmp_relatorio_financeiro__contrato_id on tmp_relatorio_financeiro(contrato_id)
	create index ix__tmp_relatorio_financeiro__ano_mes_competencia on tmp_relatorio_financeiro(ano_competencia, mes_competencia)
	create index ix__tmp_relatorio_financeiro__contrato_ano_mes_competencia on tmp_relatorio_financeiro(contrato_id,ano_competencia, mes_competencia)


   set @sql = N' SELECT * 
	                FROM (SELECT * from VW_EXTRATO_FINANCEIRO ) em_linha 
					pivot 
					(sum(valor_desconto) for  grupo_nome in ( ' + @coluna_pivot + ')) em_colunas ORDER BY CONTRATO_ID'
      insert into tmp_relatorio_financeiro
	  EXEC (@SQL) 

	  select * from tmp_relatorio_financeiro
	  -- delete
	  from contratos_grupototalizadordesconto where id = 3

	  -- insert into contratos_grupototalizadordesconto
	  select 'desconto teste_paulo'


	  select * from financeiro_desconto


	  

create table tmp_relatorio_financeiro (contrato_id int, ano_competencia float, mes_competencia int, valor_bruto int, 
valor_liquido float, valor_pago float,[desconto teste_teste] float,[desconto] float,[desconto novo] float,[desconto teste] float,[desconto teste_paulo] float)


select * from tmp_relatorio_financeiro