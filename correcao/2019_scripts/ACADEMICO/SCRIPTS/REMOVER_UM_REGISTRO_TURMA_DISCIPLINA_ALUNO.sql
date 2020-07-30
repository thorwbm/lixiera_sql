/*

select * from academico_aluno where nome like 'DIEGO VIEIRA SAMPAIO'

select turmaDisciplinaAluno_id, * 
from vw_curso_turma_disciplina_aluno 
where turma_nome like '1MAP01.22º2019-2' and   
      aluno_nome like 'DIEGO VIEIRA SAMPAIO'

*/
DECLARE @TURMADISCIPLINAALUNOID INT, @DELETAR INT 
SET @TURMADISCIPLINAALUNOID = 200083
SET @DELETAR = 0


IF (@DELETAR = 1)
	BEGIN
		BEGIN TRAN 
			EXEC sp_gerar_log_academico_turmadisciplinaaluno NULL, NULL, NULL, '-',NULL, @TURMADISCIPLINAALUNOID

			DELETE FROM academico_turmadisciplinaaluno WHERE ID = @TURMADISCIPLINAALUNOID
			PRINT 'VOCE PRECISA COMMITAR OU CANCELAR O PROCESSO!!!!!'
	END 

SELECT * FROM academico_turmadisciplinaaluno WHERE id = @TURMADISCIPLINAALUNOID
SELECT * FROM LOG_academico_turmadisciplinaaluno WHERE id = @TURMADISCIPLINAALUNOID
-- COMMIT
-- ROLLBACK 




-- select turmaDisciplinaAluno_id, * from vw_curso_turma_disciplina_aluno where turma_nome like '2mcp052%2019-1' and   aluno_nome like 'larissa murici sousa'
