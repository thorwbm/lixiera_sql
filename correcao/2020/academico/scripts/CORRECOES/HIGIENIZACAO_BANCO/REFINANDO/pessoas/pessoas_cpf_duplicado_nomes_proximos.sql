with cte_duplicados as (

select cpf
from pessoas_pessoa 
group by cpf 
having count(1) =2
)

--select pes.id, pes.nome, pes.cpf, pes.*
--from pessoas_pessoa pes join cte_duplicados dup on (pes.cpf = dup.cpf) 
--order by  pes.cpf, case when pes.rg is null then 0 else 1 end + 
--                       case when pes.pai_id is null then 0 else 1 end +
--					   case when pes.mae_id is null then 0 else 1 end +
--					   case when pes.data_nascimento is null then 0 else 1 end desc, len(pes.nome) desc, pes.id
-- '11111111111','28948220306','42954535016'

-- drop table #temp
select pes.id, pes.cpf, 
       sequencial = (ROW_NUMBER() OVER (PARTITION BY pes.cpf ORDER BY pes.cpf, case when pes.rg is null then 0 else 1 end + 
                                            case when pes.pai_id is null then 0 else 1 end +
					                        case when pes.mae_id is null then 0 else 1 end +
					                        case when pes.data_nascimento is null then 0 else 1 end desc, len(pes.nome) desc, pes.id) )
 into #temp 
from pessoas_pessoa pes join cte_duplicados dup on (pes.cpf = dup.cpf) 
  where pes.cpf not in ('11111111111','28948220306','42954535016')
order by  pes.cpf, case when pes.rg is null then 0 else 1 end + 
                       case when pes.pai_id is null then 0 else 1 end +
					   case when pes.mae_id is null then 0 else 1 end +
					   case when pes.data_nascimento is null then 0 else 1 end desc, len(pes.nome) desc, pes.id

select * from #temp

--####################################################################
begin try
begin tran

declare @cpf varchar(max), @origem_id int, @destino_id int
declare CUR_ cursor for 
	SELECT distinct cpf  FROM #temp
	open CUR_ 
		fetch next from CUR_ into @cpf
		while @@FETCH_STATUS = 0
			BEGIN
				select @destino_id = id from #temp where cpf = @cpf and sequencial = 1
				select @origem_id  = id from #temp where cpf = @cpf and sequencial = 2

				EXEC SP_ALTERAR_VALOR_EM_TODO_BANCO_FK 'PESSOAS_PESSOA', 'ID', @origem_id, @destino_id				
				EXEC SP_GERAR_LOG 'PESSOAS_PESSOA', @origem_id, '-', 11717, NULL, NULL, NULL
				DELETE FROM PESSOAS_PESSOA WHERE ID = @origem_id

				
				
			fetch next from CUR_ into @cpf
			END
	close CUR_ 
deallocate CUR_ 

commit
print 'SUCESSO CURSOR'
END TRY
BEGIN CATCH
	ROLLBACK
	PRINT ERROR_MESSAGE()
END CATCH