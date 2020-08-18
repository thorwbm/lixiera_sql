--select * from VW_PRO_CURRICULO_TURMA_ESTAGIO
drop table #temp_insert 

select distinct 
       DAG.CURRICULO_NOME, DAG.ALUNO_NOME, EST.DISCIPLINA_NOME, EST.TURMA_NOME, EST.DISCIPLINA_ID, EST.TURMA_ID,
       EST.TURMADISCIPLINA_ID, DAG.TDA_CURRICULO_ALUNO_ID AS CURRICULO_ALUNO_ID, DAG.ALUNO_ID
into #temp_insert
from vw_curriculo_curso_turma_disciplina_aluno_grade dag
                              join VW_PRO_CURRICULO_TURMA_ESTAGIO est on (dag.grade_id = est.GRADE_ID and
							                                              dag.curriculo_id = est.CURRICULO_ID)
							  join VW_PRO_DISCIPLINA_NAO_CURSADA  ncr on (ncr.curriculo_aluno_id = dag.tda_curriculo_aluno_id and
							                                              ncr.disciplina_id = est.DISCIPLINA_ID)

where dag.status_mat_dis_id = 14 
order by DAG.curriculo_nome, DAG.aluno_nome, EST.DISCIPLINA_NOME, EST.TURMA_NOME

DECLARE @DISCIPLINA_ID INT 
DECLARE @TURMA_ID INT 
DECLARE @TURMADISCIPLINA_ID INT 
DECLARE @CURRICULO_ALUNO_ID INT 
DECLARE @ALUNO_ID INT



declare CUR_ESP cursor for 
    -------------------------------------------------------------------------------------------------
	SELECT DISCIPLINA_ID, TURMA_ID,TURMADISCIPLINA_ID, CURRICULO_ALUNO_ID, ALUNO_ID 
	  FROM #temp_insert
	 order by curriculo_nome, aluno_nome, DISCIPLINA_NOME, TURMA_NOME
	-------------------------------------------------------------------------------------------------
	open CUR_ESP 
		fetch next from CUR_ESP into @DISCIPLINA_ID, @TURMA_ID, @TURMADISCIPLINA_ID, @CURRICULO_ALUNO_ID, @ALUNO_ID
		while @@FETCH_STATUS = 0
			BEGIN
			----------------------------------------------------------------------------------------
				IF ((SELECT VAGA_DISPONIVEL 
				      FROM VW_PRO_TURMA_DISCIPLINA_QUANTIDADE_DISPONIVEL_VAGA VAG 
					 WHERE VAG.turmadisciplina_id = @TURMADISCIPLINA_ID) > 0)
					BEGIN
						INSERT INTO academico_turmadisciplinaaluno (
							   ALUNO_ID, TURMA_DISCIPLINA_ID, CRIADO_EM, CRIADO_POR, ATUALIZADO_EM, ATUALIZADO_POR, 
							   exigencia_matricula_disciplina_id,TIPO_MATRICULA_ID, STATUS_MATRICULA_DISCIPLINA_ID, 
							   FECHADO_EM, TENTAR_FECHAMENTO, CURRICULO_ALUNO_ID)

						SELECT distinct ALUNO_ID = tem.ALUNO_ID, TURMA_DISCIPLINA_ID = tem.turmadisciplina_id, CRIADO_EM = GETDATE(), CRIADO_POR = 11717, 
							   ATUALIZADO_EM = GETDATE(), ATUALIZADO_POR = 11717, EXIGENCIA_MATRICULA_DISCIPLINA_ID = 2, TIPO_MATRICULA_ID = 1, 
							   STATUS_MATRICULA_DISCIPLINA_ID = 14, FECHADO_EM = NULL, TENTAR_FECHAMENTO = 0, CURRICULO_ALUNO_ID = tem.CURRICULO_ALUNO_ID
						  FROM #temp_insert tem LEFT JOIN academico_turmadisciplinaaluno XXX ON (XXX.aluno_id = tem.ALUNO_ID AND 
																									 XXX.turma_disciplina_id = tem.turmadisciplina_id AND
																									 XXX.curriculo_aluno_id  = tem.CURRICULO_ALUNO_ID)
                         WHERE XXX.id IS NULL AND 
						       tem.TURMADISCIPLINA_ID = @TURMADISCIPLINA_ID AND
							   tem.CURRICULO_ALUNO_ID = @CURRICULO_ALUNO_ID


					    DELETE FROM #temp_insert 
						 WHERE CURRICULO_ALUNO_ID = @CURRICULO_ALUNO_ID AND
						       DISCIPLINA_ID      = @DISCIPLINA_ID
					END
				ELSE 
					BEGIN
						PRINT 'O ALUNO NAO PODE SER INCLUIDO POR FALTA DE VAGAS ->' + CONVERT(VARCHAR(10),@ALUNO_ID)
					END
			----------------------------------------------------------------------------------------



			fetch next from CUR_ESP into @DISCIPLINA_ID, @TURMA_ID, @TURMADISCIPLINA_ID, @CURRICULO_ALUNO_ID, @ALUNO_ID
			END
	close CUR_ESP 
deallocate CUR_ESP 




