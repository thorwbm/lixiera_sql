USE [erp_hmg]
GO
/****** Object:  View [dbo].[vw_frequencia_diaria_carga2]    Script Date: 09/01/2020 18:38:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[vw_frequencia_diaria_carga2] as
select codescola, ano, regime, periodo, codcurso, codaluno, coddisciplina, turma, data_aula,
       count(case when presente = 0 then 1 else null end) faltas, count(1) as aulas
from (
select json_value(tda.atributos, '$.universus_key.codescola') as codescola,
       json_value(tda.atributos, '$.universus_key.ano') as ano,
       json_value(tda.atributos, '$.universus_key.regime') as regime,
       json_value(tda.atributos, '$.universus_key.periodo') as periodo,
       json_value(tda.atributos, '$.universus_key.codcurso') as codcurso,
       json_value(tda.atributos, '$.universus_key.codaluno') as codaluno,
       json_value(tda.atributos, '$.universus_key.coddisciplina') as coddisciplina,
       json_value(turma.atributos, '$.universus_key.turma') as turma,
	   freq.presente,
	   convert(date, aula.data_inicio) as data_aula
  from academico_turmadisciplinaaluno tda
       inner join academico_turmadisciplina td on td.id = tda.turma_disciplina_id
	   inner join academico_turma turma on turma.id = td.turma_id
	   inner join academico_aula aula on aula.turma_disciplina_id = td.id
	   inner join tmp_frequencia_diaria_carga freq on freq.aula_id = aula.id and freq.aluno_id = tda.aluno_id
 where json_query(tda.atributos, '$.universus_avaliacoes') is null
   and json_query(tda.atributos, '$.universus_key') is not null
   and json_query(td.atributos, '$.universus_key_to') is null --Indica que a TurmaDisciplina possui uma indicação específica sobre para qual turma disciplina no Universus a frequência será enviada. Nesses casos, as frequências serão enviadas no union mais abaixo.
   and aula.data_inicio <= getdate()
   and turma.atributos is not null
union all
select json_value(td.atributos, '$.universus_key_to.codescola') as codescola,
       json_value(td.atributos, '$.universus_key_to.ano') as ano,
       json_value(td.atributos, '$.universus_key_to.regime') as regime,
       json_value(td.atributos, '$.universus_key_to.periodo') as periodo,
       json_value(curso.atributos, '$.universus_key.codcurso') as codcurso,
       json_value(aluno.atributos, '$.universus_key.codaluno') as codaluno,
       json_value(td.atributos, '$.universus_key_to.coddisciplina') as coddisciplina,
       json_value(td.atributos, '$.universus_key_to.turma') as turma,
	   freq.presente,
	   convert(date, aula.data_inicio) as data_aula
  from academico_turmadisciplinaaluno tda
       inner join academico_turmadisciplina td on td.id = tda.turma_disciplina_id
	   inner join academico_turma turma on turma.id = td.turma_id
	   inner join academico_aula aula on aula.turma_disciplina_id = td.id
	   inner join academico_curso curso on curso.id = turma.curso_id
	   inner join tmp_frequencia_diaria_carga freq on freq.aula_id = aula.id and freq.aluno_id = tda.aluno_id
	   inner join academico_aluno aluno on aluno.id = tda.aluno_id
 where json_query(tda.atributos, '$.universus_avaliacoes') is null
   and json_query(td.atributos, '$.universus_key_to') is not null --Indica que a TurmaDisciplina possui uma indicação específica sobre para qual turma disciplina no Universus a frequência será enviada.
   and json_query(aluno.atributos, '$.universus_key') is not null
   and json_query(curso.atributos, '$.universus_key') is not null
   and aula.data_inicio <= getdate()
) tab
group by codescola, ano, regime, periodo, codcurso, codaluno, coddisciplina, turma, data_aula
GO
