-- exec SP_PRO_CARGA_SUBTURMAS_ALUNO 36180


create or alter procedure SP_PRO_CARGA_SUBTURMAS_ALUNO
    @curriculo_aluno_id int AS 

--SELECT * FROM vw_Curriculo_aluno_pessoa WHERE curriculo_aluno_id = @curriculo_aluno_id

DECLARE @ALUNO_ID INT,  @TURMA_ID INT, @DISCIPLINA_ID INT, @TURMADISCIPLINA_ID INT

BEGIN TRY
BEGIN TRAN

declare CUR_SBT cursor for 
--------------------------------------------------------------------------------------
select distinct aluno_id, curriculo_aluno_id, tds.turma_id,  tds.disciplina_id
  from academico_turmadisciplinaaluno tda join academico_aluno           alu on (alu.id = tda.aluno_id)
                                          join academico_turmadisciplina tds on (tds.id = tda.turma_disciplina_id)    
										  join VW_ACD_TURMA_PAI_FILHA    tpf on (tpf.turmadisciplina_pai_id = tds.id)
where curriculo_aluno_id = @curriculo_aluno_id and
      status_matricula_disciplina_id = 14      AND 
	  tds.disciplina_id <> 7285
order by 1
--------------------------------------------------------------------------------------
	open CUR_SBT 
		fetch next from CUR_SBT into  @ALUNO_ID, @curriculo_aluno_id,  @TURMA_ID, @DISCIPLINA_ID
		while @@FETCH_STATUS = 0
			BEGIN
------------------------------------------------------------------------------
SET @TURMADISCIPLINA_ID = NULL 

SELECT @TURMADISCIPLINA_ID = turmadisciplina_id 
  FROM ( select top 1 turma_pai_id,  turmadisciplina_id,turma_nome, disciplina_id   
	       from ( select tur.turma_pai_id, tds.id as turmadisciplina_id, tur.nome as turma_nome, 
		                 dis.id as disciplina_id, tds.maximo_vagas, count(tda.id) as qtd_alunos
                    from academico_turma tur join academico_turmadisciplina      tds on (tur.id = tds.turma_id)
                                             join academico_disciplina           dis on (dis.id = tds.disciplina_id)
							            left join academico_turmadisciplinaaluno tda on (tds.id = tda.turma_disciplina_id)
                   where tur.turma_pai_id = @TURMA_ID and
                         dis.id = @DISCIPLINA_ID
                   group by tur.turma_pai_id, tds.id, tur.nome, dis.id, tds.maximo_vagas) as tab
          where maximo_vagas - qtd_alunos > 0
          order by turma_nome) AS TABX
-------------------------------------------------------------------------------

IF(ISNULL(@TURMADISCIPLINA_ID,0) > 0) 
	BEGIN
		INSERT INTO academico_turmadisciplinaaluno 
		       (ALUNO_ID, TURMA_DISCIPLINA_ID, CRIADO_EM, CRIADO_POR, ATUALIZADO_EM, ATUALIZADO_POR, 
			    exigencia_matricula_disciplina_id, TIPO_MATRICULA_ID, STATUS_MATRICULA_DISCIPLINA_ID, 
				FECHADO_EM, TENTAR_FECHAMENTO, CURRICULO_ALUNO_ID)
		SELECT ALUNO_ID = @ALUNO_ID, TURMA_DISCIPLINA_ID = @TURMADISCIPLINA_ID, CRIADO_EM = GETDATE(), 
		       CRIADO_POR = 11717, ATUALIZADO_EM = GETDATE(), ATUALIZADO_POR = 11717, 
			   EXIGENCIA_MATRICULA_DISCIPLINA_ID = 2, TIPO_MATRICULA_ID = 1, STATUS_MATRICULA_DISCIPLINA_ID = 14, 
			   FECHADO_EM = NULL, TENTAR_FECHAMENTO = 0, CURRICULO_ALUNO_ID = @CURRICULO_ALUNO_ID
			   WHERE NOT EXISTS (SELECT 1   
			                       FROM academico_turmadisciplinaaluno 
								  WHERE ALUNO_ID = @ALUNO_ID AND 
										TURMA_DISCIPLINA_ID = @TURMADISCIPLINA_ID AND 
										CURRICULO_ALUNO_ID = @CURRICULO_ALUNO_ID)
	END
	   
			fetch next from CUR_SBT into  @ALUNO_ID, @curriculo_aluno_id,  @TURMA_ID, @DISCIPLINA_ID
			END
	close CUR_SBT 
deallocate CUR_SBT 

COMMIT
PRINT ('PROCESSO EFETUADO COM SUCESSO - FORAM INSERIDAS AS SUBTURMAS PARA O CURRIUCLO ALUNO ID = ' + CONVERT(VARCHAR(10),@curriculo_aluno_id))
END TRY

BEGIN CATCH
	ROLLBACK
	PRINT ('OCORREU UM ERRO DURANTE O PRECESSAMENTO DO CURRIUCLO ALUNO ID = ' + CONVERT(VARCHAR(10),@curriculo_aluno_id))
	PRINT ERROR_MESSAGE() 
END CATCH






--  ###########################################################################
-- pegar a turma disciplina da sub turma disciplina

/*
select top 1 turma_pai_id, turmadisciplina_id,turma_nome, disciplina_id   from (
select tur.turma_pai_id, tds.id as turmadisciplina_id, tur.nome as turma_nome, dis.id as disciplina_id, tds.maximo_vagas, count(tda.id) as qtd_alunos
from academico_turma tur join academico_turmadisciplina tds on (tur.id = tds.turma_id)
                                  join academico_disciplina dis on (dis.id = tds.disciplina_id)
							left  join academico_turmadisciplinaaluno tda on (tds.id = tda.turma_disciplina_id)
where tur.turma_pai_id = 5777 and
      dis.id = 7046
group by tur.turma_pai_id, tds.id, tur.nome, dis.id, tds.maximo_vagas ) as tab
where maximo_vagas - qtd_alunos > 0
order by turma_nome
*/





