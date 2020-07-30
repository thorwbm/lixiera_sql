-- select distinct turma_nome, disciplina_nome, turmadisciplina_id from tmp_higienizacao_alunos_afetados

declare @turma varchar(500), @DISCIPLINA VARCHAR(500)
DECLARE @TURMADISCIPLINA_ID_ORIGEM INT, @TURMADISCIPLINA_ID_DESTINO INT

declare CUR_ cursor for 
		select turma_nome, disciplina_nome
	from  tmp_higienizacao_alunos_afetados
	group by turma_nome, disciplina_nome
	having count(distinct turmadisciplina_id) > 1
	
	open CUR_ 
		fetch next from CUR_ into @turma, @DISCIPLINA
		while @@FETCH_STATUS = 0
			BEGIN
			   select @TURMADISCIPLINA_ID_DESTINO = MIN(turmadisciplina_id) ,
				      @TURMADISCIPLINA_ID_ORIGEM  = MAX(TURMADISCIPLINA_ID)  
                 from tmp_higienizacao_alunos_afetados
				WHERE turma_nome = @TURMA AND 
				      DISCIPLINA_NOME = @DISCIPLINA

					  EXEC sp_transportar_turmadisciplina_id @turmaDisciplina_id_origem , @turmaDisciplina_id_destino

			fetch next from CUR_ into  @turma, @DISCIPLINA
			END
	close CUR_ 
deallocate CUR_ 
