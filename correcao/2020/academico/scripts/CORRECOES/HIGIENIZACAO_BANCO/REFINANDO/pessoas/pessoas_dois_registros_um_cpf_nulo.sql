with cte_duplicados as (
			select nome 
			from pessoas_pessoa
			group by nome 
			having count(1) >1
)

	,	cte_pessoas_com_null as (
			select * from cte_duplicados dup 
			where nome in (select nome from pessoas_pessoa pes where cpf is null )
)

	,	cte_duplicados_com_null as (
			select pes.id, pes.nome, pes.cpf
			  from cte_pessoas_com_null nul join pessoas_pessoa pes on (nul.nome = pes.nome)			
)

			select CTE1.NOME, 
			       ORIGEM = CASE WHEN CTE1.CPF IS NULL THEN CTE1.ID ELSE CTE2.ID END , 
			       DESTINO = CASE WHEN CTE1.CPF IS NULL THEN CTE2.ID ELSE CTE1.ID END 
			 INTO #TEMP
			 from cte_duplicados_com_null CTE1 JOIN cte_duplicados_com_null CTE2 ON (CTE1.NOME = CTE2.NOME)
			WHERE  CASE WHEN CTE1.CPF IS NULL THEN CTE1.ID ELSE CTE2.ID END <> CASE WHEN CTE1.CPF IS NULL THEN CTE2.ID ELSE CTE1.ID END


			SELECT * FROM #TEMP



DECLARE @ORIGEM INT, @DESTINO INT 

declare CUR_ cursor for 
	SELECT ORIGEM, DESTINO FROM #TEMP
	open CUR_ 
		fetch next from CUR_ into @ORIGEM, @DESTINO
		while @@FETCH_STATUS = 0
			BEGIN
				
				EXEC SP_ALTERAR_VALOR_EM_TODO_BANCO_FK 'PESSOAS_PESSOA', 'ID', @ORIGEM, @DESTINO				
				EXEC SP_GERAR_LOG 'PESSOAS_PESSOA', @ORIGEM, '-', 11717, NULL, NULL, NULL
				DELETE FROM PESSOAS_PESSOA WHERE ID = @ORIGEM


			fetch next from CUR_ into @ORIGEM, @DESTINO
			END
	close CUR_ 
deallocate CUR_ 