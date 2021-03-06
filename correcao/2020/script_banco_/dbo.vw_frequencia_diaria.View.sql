USE [erp_hmg]
GO
/****** Object:  View [dbo].[vw_frequencia_diaria]    Script Date: 09/01/2020 18:38:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[vw_frequencia_diaria] as
select aluno_id, codescola, ano, regime, periodo, codcurso, numetapa, codetapa, codturno, numgrade, anograde, regimegrade, periodograde, codaluno, coddisciplina, seqenturma, turma, data_aula,
       count(case when presente = 0 then 1 else null end) faltas, count(1) as aulas
from (
select tda.aluno_id,
       json_value(tda.atributos, '$.universus_key.codescola') as codescola,
       json_value(tda.atributos, '$.universus_key.ano') as ano,
       json_value(tda.atributos, '$.universus_key.regime') as regime,
       json_value(tda.atributos, '$.universus_key.periodo') as periodo,
       json_value(tda.atributos, '$.universus_key.codcurso') as codcurso,
       json_value(tda.atributos, '$.universus_key.numetapa') as numetapa,
       json_value(tda.atributos, '$.universus_key.codetapa') as codetapa,
       json_value(tda.atributos, '$.universus_key.codturno') as codturno,
       json_value(tda.atributos, '$.universus_key.numgrade') as numgrade,
       json_value(tda.atributos, '$.universus_key.anograde') as anograde,
       json_value(tda.atributos, '$.universus_key.regimegrade') as regimegrade,
       json_value(tda.atributos, '$.universus_key.periodograde') as periodograde,
       json_value(tda.atributos, '$.universus_key.codaluno') as codaluno,
       json_value(tda.atributos, '$.universus_key.coddisciplina') as coddisciplina,
       json_value(tda.atributos, '$.universus_key.seqenturma') as seqenturma,
       json_value(turma.atributos, '$.universus_key.turma') as turma,
	   freq.presente,
	   convert(date, aula.data_inicio) as data_aula
  from academico_turmadisciplinaaluno tda
       inner join academico_turmadisciplina td on td.id = tda.turma_disciplina_id
	   inner join academico_turma turma on turma.id = td.turma_id
	   inner join academico_aula aula on aula.turma_disciplina_id = td.id
	   inner join academico_frequenciadiaria freq on freq.aula_id = aula.id and freq.aluno_id = tda.aluno_id
 where tda.atributos is not null and aula.data_inicio <= getdate() and turma.atributos is not null
) tab
group by aluno_id, codescola, ano, regime, periodo, codcurso, numetapa, codetapa, codturno, numgrade, anograde, regimegrade, periodograde, codaluno, coddisciplina, seqenturma, turma, data_aula
GO
