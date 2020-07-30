SELECT TBA.id_avaliacao, TBA.ds_avaliacao AS AVALIACAO_NOME, TBA.dt_criada AS DATA_AVALIACAO, 
       CUR.ID_CURSO, CUR.ds_curso AS CURSO_NOME, 
       DIS.id_disciplina, DIS.ds_disciplina AS DISCIPLINA_NOME,
       PER.id_periodo, PER.DS_PERIODO AS PERIODO_NOME, 
       INS.id_instituicao, INS.ds_instituicao AS INSTITUICAO_NOME, 
	   APL.nr_respondentes AS NRO_PARTICIPANTE, 
	   APL.id_avaliacao_aplicacao
  FROM TbAvaliacaoAplicacao APL JOIN TBCURSO   CUR ON (APL.id_curso = CUR.id_curso)
                                JOIN TBPERIODO PER ON (PER.id_periodo = APL.id_periodo)
								JOIN TBDISCIPLINA DIS ON (DIS.id_disciplina = APL.id_disciplina)
								JOIN TBINSTITUICAO INS ON (INS.id_instituicao = APL.id_instituicao)
								JOIN TBAVALIACAO   TBA ON (TBA.ID_AVALIACAO = APL.id_avaliacao)
WHERE APL.ID_DISCIPLINA = 1717

SELECT * FROM TbAvaliacaoRealizacao
WHERE id_avaliacao_aplicacao IN (31881,31882)

SELECT * FROM TbAvaliacaoRealizacaoResposta
WHERE id_avaliacao_realizacao IN (
SELECT id_avaliacao_realizacao FROM TbAvaliacaoRealizacao
WHERE id_avaliacao_aplicacao IN (31881,31882))



SELECT * FROM TbAvaliacaoItem
WHERE id_avaliacao_item  IN (
	SELECT ID_AVALIACAO_ITEM FROM TbAvaliacaoRealizacaoResposta
	WHERE id_avaliacao_realizacao IN (
		SELECT id_avaliacao_realizacao FROM TbAvaliacaoRealizacao
		WHERE id_avaliacao_aplicacao IN (31881,31882)
	)
)
and id_avaliacao in (1458,1459)