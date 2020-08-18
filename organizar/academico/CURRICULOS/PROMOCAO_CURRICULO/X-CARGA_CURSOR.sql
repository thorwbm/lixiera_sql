
-- ***** RODAR CARGA DAS SUBTURMAS PARA TODOS OS ALUNOS JA PRE ENTURMADOS COM DISCPLINA PAI
CREATE PROCEDURE SP_PRO_CARGA_SUBTURMA_CURRICULO @CURRICULOALUNO_ID int AS 

 declare CUR_SUB cursor for 
	----------------------------------------------------------
	SELECT DISTINCT CURRICULOALUNO_ID 
      from vw_aluno_curriculo_curso_turma_etapa_discplina ted
     where STATUS_TURMADISCIPLINAALUNO = 'Pré-enturmado' 
	----------------------------------------------------------
	open CUR_SUB 
		fetch next from CUR_SUB into @CURRICULOALUNO_ID
		while @@FETCH_STATUS = 0
			BEGIN
				EXEC SP_PRO_CARGA_SUBTURMAS_ALUNO @CURRICULOALUNO_ID

			fetch next from CUR_SUB into @CURRICULOALUNO_ID
			END
	close CUR_SUB 
deallocate CUR_SUB 







