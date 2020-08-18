/*
select DISTINCT ent.curriculo_id, cra.grade_id, cra.aluno_id, CRA.ALUNO_NOME
       -- ,ent.disciplina_id, ent.disciplina_nome, cra.curriculo_aluno_id 
  from VW_ACD_CURRICULO_ALUNO_PESSOA cra join vw_pro_disciplina_nao_cursada ent on (ent.curriculo_aluno_id = cra.curriculo_aluno_id and 
                                                                                       ent.grade_id           = cra.grade_id and 
																					   ent.exigenciadisciplina_id = 2)
										
  where cra.aluno_nome = 'JESSICA ROSA DOS SANTOS' and 
        curriculo_aluno_status_id = 13

------------------------------------------------------------------------

select top 100  * from  VW_ACD_CURRICULO_GRADE_TURMA_DISCIPLINA_VAGAS
WHERE CURRICULO_ID =2375  AND GRADE_ID = 7009    ORDER BY TURMA_NOME, DISCIPLINA_NOME

*/
drop table  #temp_insert;


select * from vw_Curriculo_aluno_pessoa where aluno_nome = 'JESSICA ROSA DOS SANTOS'
with cte_alunos_enturmar as (
select ent.curriculo_id, cra.aluno_id, ent.disciplina_id, ent.disciplina_nome, cra.grade_id, cra.curriculo_aluno_id,
       CRA.curriculo_nome, ALUNO_NOME
  from VW_ACD_CURRICULO_ALUNO_PESSOA cra join vw_pro_disciplina_nao_cursada ent on (ent.curriculo_aluno_id = cra.curriculo_aluno_id and 
                                                                                       ent.grade_id           = cra.grade_id and 
																					   ent.exigenciadisciplina_id = 2)
										
  where cra.aluno_nome = 'JESSICA ROSA DOS SANTOS' and 
        curriculo_aluno_status_id = 13
), 
	cte_turmadisciplina as (
	select DISTINCT turma_id, turma_nome, disciplina_id, disciplina_nome, turma_disciplina_id
	  from vw_turma_disciplina_grade
	  where turma_nome in ('M074S01B202T') 
	   
)


select ENT.DISCIPLINA_ID, TURMA_ID,TURMA_DISCIPLINA_ID, ent.curriculo_aluno_id as CURRICULO_ALUNO_ID, ALUNO_ID,
       curriculo_NOME as curriculo_nome, ENT.aluno_nome, ENT.DISCIPLINA_NOME, TURMA_NOME
into #temp_insert
from cte_alunos_enturmar ent join cte_turmadisciplina tds on (ent.disciplina_id = tds.disciplina_id)
--where disciplina_NOME =  'TREINAMENTO DE HABILIDADES VII'
order by curriculo_nome,aluno_nome, ENT.DISCIPLINA_NOME, TURMA_NOME

-- drop table  #temp_insert

-- SELECT * FROM #temp_insert

BEGIN TRY
BEGIN TRAN 

DECLARE @DISCIPLINA_ID INT 
DECLARE @TURMA_ID INT 
DECLARE @TURMADISCIPLINA_ID INT 
DECLARE @CURRICULO_ALUNO_ID INT 
DECLARE @ALUNO_ID INT

DECLARE @CURRICULO_ALUNO INT 
SELECT DISTINCT @CURRICULO_ALUNO = CURRICULO_ALUNO_ID FROM #temp_insert

declare CUR_ESP cursor for 
    -------------------------------------------------------------------------------------------------
	SELECT DISCIPLINA_ID, TURMA_ID,TURMA_DISCIPLINA_ID, CURRICULO_ALUNO_ID, ALUNO_ID 
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

						SELECT distinct ALUNO_ID = tem.ALUNO_ID, TURMA_DISCIPLINA_ID = tem.turma_disciplina_id, CRIADO_EM = GETDATE(), CRIADO_POR = 11717, 
							   ATUALIZADO_EM = GETDATE(), ATUALIZADO_POR = 11717, EXIGENCIA_MATRICULA_DISCIPLINA_ID = 2, TIPO_MATRICULA_ID = 1, 
							   STATUS_MATRICULA_DISCIPLINA_ID = 14, FECHADO_EM = NULL, TENTAR_FECHAMENTO = 0, CURRICULO_ALUNO_ID = tem.CURRICULO_ALUNO_ID
						  FROM #temp_insert tem LEFT JOIN academico_turmadisciplinaaluno XXX ON (XXX.aluno_id = tem.ALUNO_ID AND 
																									 XXX.turma_disciplina_id = tem.turma_disciplina_id AND
																									 XXX.curriculo_aluno_id  = tem.CURRICULO_ALUNO_ID)
                         WHERE XXX.id IS NULL AND 
						       tem.TURMA_DISCIPLINA_ID = @TURMADISCIPLINA_ID AND
							   tem.CURRICULO_ALUNO_ID = @CURRICULO_ALUNO_ID


					    DELETE FROM #temp_insert 
						 WHERE CURRICULO_ALUNO_ID = @CURRICULO_ALUNO_ID AND
						       DISCIPLINA_ID      = @DISCIPLINA_ID
					END
			----------------------------------------------------------------------------------------



			fetch next from CUR_ESP into @DISCIPLINA_ID, @TURMA_ID, @TURMADISCIPLINA_ID, @CURRICULO_ALUNO_ID, @ALUNO_ID
			END
	close CUR_ESP 
deallocate CUR_ESP 



 EXEC SP_PRO_CARGA_SUBTURMAS_ALUNO @CURRICULO_ALUNO

 COMMIT
 PRINT '****** SUCESSO ******'
 END TRY
 BEGIN CATCH
 ROLLBACK 
 PRINT '****** ERRO  ********'

 END CATCH



 SELECT * FROM vw_curriculo_curso_turma_disciplina_aluno_grade
 WHERE status_mat_dis_id = 14 AND 
       ALUNO_NOME = 'LARISSA JARDIM MELO'