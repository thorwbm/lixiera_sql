DROP TABLE #temp_enturmacao

select distinct DAG.ALUNO_NOME, EST.TURMA_NOME, DAG.aluno_id, DAG.tda_curriculo_aluno_id AS curriculo_aluno_id, 
                DAG.curriculo_ID, dag.GRADE_ID, EST.TURMADISCIPLINA_ID, est.disciplina_id, est.disciplina_nome
		INTO #temp_enturmacao
		from vw_curriculo_curso_turma_disciplina_aluno_grade dag JOIN VW_PRO_CURRICULO_TURMA_ESTAGIO EST ON (EST.CURRICULO_ID = dag.curriculo_id AND
		                                                                                                     EST.GRADE_ID     = dag.GRADE_ID )
		where DAG.curriculo_nome = 'PSICOLOGIA 2016/10-1' and
		     -- dag.disciplina_nome = 
			  DAG.status_mat_dis_id = 14
		ORDER BY DAG.curriculo_ID,dag.ALUNO_NOME, EST.TURMA_NOME 

		--SELECT DISTINCT DISCIPLINA_NOME FROM #temp_enturmacao


DECLARE @VAGA_DISPONIVEL INT
DECLARE @CURRICULO_ALUNO_ID INT
DECLARE @TURMA_ID INT
DECLARE @GRADE_ID INT
DECLARE @ALUNO_ID INT
DECLARE @DISCIPLINA_ID INT 
DECLARE @ALUNO_NOME VARCHAR(200)
DECLARE @TURMA_NOME VARCHAR(200)
DECLARE @TURMA_DISCIPLINA_ID INT
DECLARE @CURRICULO_ID INT

declare CUR_ESP cursor for 
	------------------------------------------------------------------------------------------------
	select distinct DAG.ALUNO_NOME, EST.TURMA_NOME, DAG.aluno_id, DAG.tda_curriculo_aluno_id, DAG.curriculo_ID, dag.GRADE_ID, EST.TURMADISCIPLINA_ID,
	       est.disciplina_id
		from vw_curriculo_curso_turma_disciplina_aluno_grade dag JOIN VW_PRO_CURRICULO_TURMA_ESTAGIO EST ON (EST.CURRICULO_ID = dag.curriculo_id AND
		                                                                                                     EST.GRADE_ID     = dag.GRADE_ID )
		where DAG.curriculo_nome = 'PSICOLOGIA 2016/10-1' and
			  DAG.status_mat_dis_id = 14
		ORDER BY DAG.curriculo_ID,dag.ALUNO_NOME, EST.TURMA_NOME
	------------------------------------------------------------------------------------------------
	open CUR_ESP 
		fetch next from CUR_ESP into @ALUNO_NOME,@TURMA_NOME, @ALUNO_ID, @CURRICULO_ALUNO_ID, @CURRICULO_ID, @GRADE_ID, @TURMA_DISCIPLINA_ID, @DISCIPLINA_ID
		while @@FETCH_STATUS = 0
			BEGIN
			----------------------------------------------------------------------------------------
			 set @VAGA_DISPONIVEL = (select VAG.VAGA_DISPONIVEL 
			   FROM VW_PRO_TURMA_DISCIPLINA_QUANTIDADE_DISPONIVEL_VAGA VAG
			 WHERE VAG.turmadisciplina_id =  @TURMA_DISCIPLINA_ID)
					 				  
			----------------------------------------------------------------------------------------
			IF (@VAGA_DISPONIVEL > 0)
				BEGIN 
					INSERT INTO academico_turmadisciplinaaluno (
						   ALUNO_ID, TURMA_DISCIPLINA_ID, CRIADO_EM, CRIADO_POR, ATUALIZADO_EM, ATUALIZADO_POR, 
						   exigencia_matricula_disciplina_id,TIPO_MATRICULA_ID, STATUS_MATRICULA_DISCIPLINA_ID, 
						   FECHADO_EM, TENTAR_FECHAMENTO, CURRICULO_ALUNO_ID)

					SELECT distinct ALUNO_ID = tem.ALUNO_ID, TURMA_DISCIPLINA_ID = tem.turmadisciplina_id, CRIADO_EM = GETDATE(), CRIADO_POR = 11717, 
						   ATUALIZADO_EM = GETDATE(), ATUALIZADO_POR = 11717, EXIGENCIA_MATRICULA_DISCIPLINA_ID = 2, TIPO_MATRICULA_ID = 1, 
						   STATUS_MATRICULA_DISCIPLINA_ID = 14, FECHADO_EM = NULL, TENTAR_FECHAMENTO = 0, CURRICULO_ALUNO_ID = tem.curriculo_aluno_id
					  FROM #temp_enturmacao tem LEFT JOIN vw_curriculo_curso_turma_disciplina_aluno_grade XXX ON (XXX.aluno_id = tem.ALUNO_ID AND 
																								 XXX.disciplina_id             = tem.DISCIPLINA_ID AND
																								 XXX.TDA_curriculo_aluno_id    = tem.curriculo_aluno_id AND
																								 XXX.grade_id                  = tem.grade_id)
					 WHERE XXX.TURMA_DISCIPLINA_ALUNO_ID IS NULL AND 
					       tem.TURMADISCIPLINA_ID = @TURMA_DISCIPLINA_ID AND 
						   TEM.CURRICULO_ALUNO_ID = @CURRICULO_ALUNO_ID

					 DELETE FROM  #temp_enturmacao 
					 WHERE ALUNO_ID = @ALUNO_ID AND 
					       disciplina_id = @DISCIPLINA_ID AND 
						   CURRICULO_ALUNO_ID = @CURRICULO_ALUNO_ID

				END 

			fetch next from CUR_ESP into @ALUNO_NOME,@TURMA_NOME, @ALUNO_ID, @CURRICULO_ALUNO_ID, @CURRICULO_ID, @GRADE_ID, @TURMA_DISCIPLINA_ID, @DISCIPLINA_ID
			END
	close CUR_ESP 
deallocate CUR_ESP 