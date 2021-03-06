USE [erp_hmg]
GO
/****** Object:  View [dbo].[vw_complementacaocargahoraria_carga]    Script Date: 09/01/2020 18:38:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE    view [dbo].[vw_complementacaocargahoraria_carga] as
select json_value(tda.atributos, '$.universus_key.codescola') as codescola,
       json_value(tda.atributos, '$.universus_key.ano') as ano,
       json_value(tda.atributos, '$.universus_key.regime') as regime,
       json_value(tda.atributos, '$.universus_key.periodo') as periodo,
       json_value(tda.atributos, '$.universus_key.coddisciplina') as coddisciplina,
       json_value(tda.atributos, '$.universus_key.codcurso') as codcurso,
       json_value(tda.atributos, '$.universus_key.numetapa') as numetapa,
       json_value(tda.atributos, '$.universus_key.codetapa') as codetapa,
       json_value(tda.atributos, '$.universus_key.codturno') as codturno,
       json_value(tda.atributos, '$.universus_key.numgrade') as numgrade,
       json_value(tda.atributos, '$.universus_key.anograde') as anograde,
       json_value(tda.atributos, '$.universus_key.regimegrade') as regimegrade,
       json_value(tda.atributos, '$.universus_key.periodograde') as periodograde,
       json_value(tda.atributos, '$.universus_key.codaluno') as codaluno,
       json_value(tda.atributos, '$.universus_key.seqenturma') as seqenturma,
       turma.nome as turma,
       tda.atributos as tda_attr,
       tda.id as turma_disciplina_aluno_id,
       cch.carga_horaria, faltas,
	   convert(date, '2019-07-13') as data_aula
  from academico_complementacaocargahoraria cch
       inner join academico_turmadisciplinaaluno tda on tda.turma_disciplina_id = cch.turma_disciplina_id and tda.aluno_id = cch.aluno_id
       inner join academico_turmadisciplina td on td.id = tda.turma_disciplina_id
       inner join academico_turma turma on turma.id = td.turma_id
GO
