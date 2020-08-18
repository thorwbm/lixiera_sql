/*****************************************************************************************************************
*                                      SP_PRO_INSERT_DISCIPLINA_ESPECIAL                                         *
*                                                                                                                *
*  PROCEDURE QUE FAZ A INSERCAO DO UMA DISCIPLINA PASSADA POR PARAMETRO PARA UM ALUNO COM BASE NA SUA            *
*  TURMA PAI  - PARAMETROS CURRICULO_ALUNO_ID E O NOME RAIZ DA DISCIPLINA                                        *
*                                                                                                                *
* BANCO_SISTEMA : GENERICO                                                                                       *
* CRIADO POR    : WEMERSON BITTORI MADURO                                                        DATA:24/07/2020 *
* ALTERADO POR  : WEMERSON BITTORI MADURO                                                        DATA:24/07/2020 *
******************************************************************************************************************/

create OR ALTER procedure SP_PRO_INSERT_DISCIPLINA_ESPECIAL 
       @CURRICULO_ALUNO_ID INT, @DISCIPLINA VARCHAR(200) AS 

declare @turma varchar(200)
declare @aluno_id int

select distinct @turma = tur.nome, @aluno_id = tda.aluno_id, @CURRICULO_ALUNO_ID = tda.curriculo_aluno_id
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

select @TURMADISCIPLINA_ID = turma_disciplina_id from (
select top 1 ctd.turma_disciplina_id, (ctd.maximo_vagas - count(tda.id)) as qtd 
  from VW_ACD_CURSO_TURMA_DISCIPLINA ctd left join academico_turmadisciplinaaluno tda on (tda.turma_disciplina_id = ctd.turma_disciplina_id)
where turma_nome like @turma + '%' and
      disciplina_nome like @DISCIPLINA + '%'
group by ctd.turma_disciplina_id, ctd.maximo_vagas, turma_nome
having (ctd.maximo_vagas - count(tda.id)) > 0 
order by turma_nome) as tab
 
-- ##################################################################################################
-- FAZER A INSERCAO NA TURMA DISCIPLINA ALUNO

IF(ISNULL(@TURMADISCIPLINA_ID,0) > 0) 
	BEGIN
		INSERT INTO academico_turmadisciplinaaluno (ALUNO_ID, TURMA_DISCIPLINA_ID, CRIADO_EM, CRIADO_POR, ATUALIZADO_EM, ATUALIZADO_POR, exigencia_matricula_disciplina_id,
													TIPO_MATRICULA_ID, STATUS_MATRICULA_DISCIPLINA_ID, FECHADO_EM, TENTAR_FECHAMENTO, CURRICULO_ALUNO_ID)
		SELECT ALUNO_ID = @ALUNO_ID, TURMA_DISCIPLINA_ID = @TURMADISCIPLINA_ID, CRIADO_EM = GETDATE(), CRIADO_POR = 11717, ATUALIZADO_EM = GETDATE(), ATUALIZADO_POR = 11717, 
			   EXIGENCIA_MATRICULA_DISCIPLINA_ID = 2, TIPO_MATRICULA_ID = 1, STATUS_MATRICULA_DISCIPLINA_ID = 14, FECHADO_EM = NULL, TENTAR_FECHAMENTO = 0, CURRICULO_ALUNO_ID = @CURRICULO_ALUNO_ID
			   WHERE NOT EXISTS (SELECT 1 FROM academico_turmadisciplinaaluno 
								  WHERE ALUNO_ID = @ALUNO_ID AND 
										TURMA_DISCIPLINA_ID = @TURMADISCIPLINA_ID AND 
										CURRICULO_ALUNO_ID = @CURRICULO_ALUNO_ID)
	END