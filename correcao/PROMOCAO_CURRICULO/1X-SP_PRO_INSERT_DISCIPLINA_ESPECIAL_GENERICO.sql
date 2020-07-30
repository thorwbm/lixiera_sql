/*****************************************************************************************************************
*                                      SP_PRO_INSERT_DISCIPLINA_ESPECIAL_GENERICO                                *
*                                                                                                                *
*  PROCEDURE QUE FAZ A INSERCAO DO UMA DISCIPLINA PASSADA POR PARAMETRO PARA UM ALUNO COM BASE NA SUA            *
*  TURMA PAI  - PARAMETROS CURRICULO_ALUNO_ID E O NOME RAIZ DA DISCIPLINA                                        *
*                                                                                                                *
* BANCO_SISTEMA : GENERICO                                                                                       *
* CRIADO POR    : WEMERSON BITTORI MADURO                                                        DATA:24/07/2020 *
* ALTERADO POR  : WEMERSON BITTORI MADURO                                                        DATA:24/07/2020 *
******************************************************************************************************************/
--  EXEC SP_PRO_INSERT_DISCIPLINA_ESPECIAL_GENERICO 36180, 'INTEGRAÇÃO CURRICULAR','M068A04B202T'

create OR ALTER procedure SP_PRO_INSERT_DISCIPLINA_ESPECIAL_GENERICO 
       @CURRICULO_ALUNO_ID INT, @DISCIPLINA VARCHAR(200), @TURMA_PAI  VARCHAR(200)  AS 

SET @TURMA_PAI =  ISNULL((SELECT ISNULL(NOME,'*') FROM ACADEMICO_TURMA WHERE NOME = @TURMA_PAI),'*')
declare @turma_NOME varchar(200)
declare @aluno_id int
DECLARE @grade_id int
DECLARE @DISCIPLINA_ID INT

select distinct @turma_NOME = tur.nome, @aluno_id = tda.aluno_id, 
                @CURRICULO_ALUNO_ID = tda.curriculo_aluno_id, @grade_id = tur.grade_id
  from academico_turmadisciplinaaluno tda join academico_turmadisciplina tds on (tds.id = tda.turma_disciplina_id)
                                          join academico_turma           tur on (tur.id = tds.turma_id)
where tur.turma_pai_id is null and
      tda.status_matricula_disciplina_id = 14 and 
      year(tur.inicio_vigencia) = 2020 and 
	  month(tur.inicio_vigencia) > 6 and 
	  tda.curriculo_aluno_id = @CURRICULO_ALUNO_ID 


--###################################################################################################
-- encontrar a turma disciplina que ainda tem vaga para cadastrar 
declare @TURMADISCIPLINA_ID int
select @TURMADISCIPLINA_ID = null


--SELECT * 
--  FROM academico_turmadisciplinaaluno tda join VW_ACD_CURSO_TURMA_DISCIPLINA ctd on (tda.turma_disciplina_id = ctd.turma_disciplina_id)
--WHERE CURRICULO_ALUNO_ID = @CURRICULO_ALUNO_ID AND status_matricula_disciplina_id = 14 and
--      ctd.disciplina_nome like @DISCIPLINA + '%'

PRINT @TURMA_NOME
PRINT @TURMA_PAI
PRINT '**************************'

declare CUR_INS_DIS cursor for 
----------------------------------------------------------------------
	  select DISTINCT CGD.disciplina_ID
	    from VW_ACD_CURRIULO_CURSO_GRADE_DISCIPLINA CGD JOIN ACADEMICO_TURMA           TUR ON (TUR.grade_id = CGD.grade_id)
		                                                JOIN ACADEMICO_TURMADISCIPLINA TDS ON (CGD.disciplina_id = TDS.disciplina_id AND
	                                                                                           TUR.ID = TDS.TURMA_ID)
	  where disciplina_nome like @DISCIPLINA + '%' and 
	        
	        CGD.grade_id = @grade_id 
----------------------------------------------------------------------
	open CUR_INS_DIS 
		fetch next from CUR_INS_DIS into  @DISCIPLINA_ID
		while @@FETCH_STATUS = 0
			BEGIN
				-------------------------------------------------------
				
				select @TURMADISCIPLINA_ID =  turma_disciplina_id from (
				select top 1 ctd.turma_disciplina_id, (ctd.maximo_vagas - count(tda.id)) as qtd 
				  from VW_ACD_CURSO_TURMA_DISCIPLINA ctd left join academico_turmadisciplinaaluno tda on (tda.turma_disciplina_id = ctd.turma_disciplina_id)
				where GRADE_ID = @GRADE_ID and
					  disciplina_id = @DISCIPLINA_ID AND 
					  (TURMA_NOME LIKE @TURMA_PAI + '%' OR @TURMA_PAI = '*')
				group by ctd.turma_disciplina_id, ctd.maximo_vagas, turma_nome
				having (ctd.maximo_vagas - count(tda.id)) > 0 
				order by turma_nome) as tab
				-------------------------------------------------------
				
				-- FAZER A INSERCAO NA TURMA DISCIPLINA ALUNO

				IF(ISNULL(@TURMADISCIPLINA_ID,0) > 0) 
					BEGIN
						INSERT INTO academico_turmadisciplinaaluno (ALUNO_ID, TURMA_DISCIPLINA_ID, CRIADO_EM, CRIADO_POR, ATUALIZADO_EM, ATUALIZADO_POR, 
						                                            exigencia_matricula_disciplina_id, TIPO_MATRICULA_ID, STATUS_MATRICULA_DISCIPLINA_ID, FECHADO_EM, 
																	TENTAR_FECHAMENTO, CURRICULO_ALUNO_ID)
						SELECT ALUNO_ID = @ALUNO_ID, TURMA_DISCIPLINA_ID = @TURMADISCIPLINA_ID, CRIADO_EM = GETDATE(), CRIADO_POR = 11717, ATUALIZADO_EM = GETDATE(), 
						       ATUALIZADO_POR = 11717, EXIGENCIA_MATRICULA_DISCIPLINA_ID = 2, TIPO_MATRICULA_ID = 1, STATUS_MATRICULA_DISCIPLINA_ID = 14, FECHADO_EM = NULL, 
							   TENTAR_FECHAMENTO = 0, CURRICULO_ALUNO_ID = @CURRICULO_ALUNO_ID
							   WHERE NOT EXISTS (SELECT 1 FROM academico_turmadisciplinaaluno 
												  WHERE ALUNO_ID = @ALUNO_ID AND 
														TURMA_DISCIPLINA_ID = @TURMADISCIPLINA_ID AND 
														CURRICULO_ALUNO_ID = @CURRICULO_ALUNO_ID)

						PRINT 'INSERIDO'
					END

				-------------------------------------------------------
			fetch next from CUR_INS_DIS into  @DISCIPLINA_ID
			END
	close CUR_INS_DIS 
deallocate CUR_INS_DIS 

