with cte_instituicao_duplicada_com_referencia as (
		select nome  from (
			select distinct instituicao_ensino_medio_id as codigo from historicos_historico  union  
			select distinct instituicao_id from academico_pessoa_titulacao  union 
			select distinct instituicao_id from  academico_alunodisciplinainformada union 
			select distinct instituicao_id from curriculos_disciplinainformada) as tab join 
						core_instituicao ins on (tab.codigo = ins.id)
		group by ins.nome, ins.cidade_id
		having count(1) > 1
)			

	, cte_todas_instituicoes_duplicadas as (
		select nome,cidade_id
		  from core_instituicao ins 
		  group by nome,cidade_id 
		  having count(id) > 1
) 

	, cte_sem_referencia as (
		select dup.* 
		from cte_todas_instituicoes_duplicadas dup left join cte_instituicao_duplicada_com_referencia ref on (dup.nome = ref.nome)
		where ref.nome is null 
)
-- DROP TABLE #TMP
		select * INTO #TMP from cte_todas_instituicoes_duplicadas
		


declare @nome varchar(500) 		
declare @CIDADE INT 
declare abc cursor for 
	SELECT NOME, cidade_id FROM #tmp
	open abc 
		fetch next from abc into @nome, @CIDADE 
		while @@FETCH_STATUS = 0
			BEGIN
		EXEC sp_corrigir_duplicidade_instituicao @nome, @CIDADE

			fetch next from abc into @nome, @CIDADE
			END
	close abc 
deallocate abc 