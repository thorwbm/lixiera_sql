/********************************************************************************************
	CONSULTA PARA ELENCAR LANCAMENTOS ERRADOS (FORAM LANCADOS NOTAS EM ATIVIDADES ERRADAS)

*********************************************************************************************/
WITH CTE_AGRUPAMENTO AS (
		SELECT DISTINCT  CRITERIO_ID = ATC.id, CRITERIO_NOME = ATC.nome, CRITERIO_VALOR = ATC.valor,
						 ATI_CRI_TUR_DIS_ID = ACT.id, INICIO_LANCAMENTO = act.inicio_janela_lancamento ,TERMINO_LANCAMENTO =  act.termino_janela_lancamento,
						 PROFESSOR_ID = PRO.ID, PROFESSOR_NOME = PRO.NOME,
						 ALUNO_ID = ALU.ID, ALUNO_NOME = ALU.NOME, ALUNO_RA = ALU.RA,
						 TURMA_ID = TUR.ID, TURMA_NOME = TUR.NOME,
						 DISCIPLINA_ID = DIS.ID, DISCIPLINA_NOME = DIS.NOME,
						 ATIVIDADE_ID = ATV.id, ATIVIDADE_NOME = ATV.nome, ATIVIDADE_VALOR = ATV.valor, 
						 ALUNO_NOTA = AAA.nota, LANCAMENTO = AAA.criado_em, 
						 LANCAMENTO_ID = AAA.ID

		 FROM atividades_atividade_aluno AAA WITH(NOLOCK) JOIN ATIVIDADES_ATIVIDADE                ATV WITH(NOLOCK) ON (ATV.id  = AAA.atividade_id )
														  JOIN atividades_criterio_turmadisciplina ACT WITH(NOLOCK) ON (ACT.id  = ATV.criterio_turma_disciplina_id)
														  JOIN atividades_criterio                 ATC WITH(NOLOCK) ON (ATC.id  = ACT.criterio_id)
														  JOIN academico_professor                 PRO WITH(NOLOCK) ON (PRO.id  = ACT.professor_id)
														  JOIN academico_turmadisciplina           TRD WITH(NOLOCK) ON (TRD.id  = ACT.turma_disciplina_id)
														  JOIN academico_turma                     TUR WITH(NOLOCK) ON (TUR.id  = TRD.turma_id)
														  JOIN academico_disciplina                DIS WITH(NOLOCK) ON (DIS.id  = TRD.disciplina_id)
														  JOIN academico_aluno                     ALU WITH(NOLOCK) ON (ALU.id  = AAA.aluno_id)
)

	SELECT DISTINCT *
	 INTO BKP_atividades_criterio_turmadisciplina_021019__1603 FROM CTE_AGRUPAMENTO
	WHERE LANCAMENTO NOT BETWEEN INICIO_LANCAMENTO AND TERMINO_LANCAMENTO AND 
	      CRITERIO_NOME <> '1ª AVALIAÇÃO FORMATIVA'

--select top 10 *  FROM academico_aluno
--select top 10 * from VW_ACAD_ATIVIDADE_CRITERIO_TURMA_DISCIPLINA_PROF

SELECT agr.CRITERIO_ID, vwa.criterio_id, agr.atividade_id, vwa.atividade_id, *

  FROM CTE_AGRUPAMENTO  agr join VW_ACAD_ATIVIDADE_CRITERIO_TURMA_DISCIPLINA_PROF vwa on (agr.turma_id = vwa.turma_id and 
                                                                                          agr.disciplina_id = vwa.disciplina_id)
 WHERE vwa.CRITERIO_NOME = '1ª AVALIAÇÃO' and 
       agr.ATIVIDADE_ID <> vwa.atividade_id

select * from atividades_atividade_aluno where id = 744