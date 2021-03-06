USE [erp_hmg]
GO
/****** Object:  View [dbo].[vw_frequencia_diaria_carga_medicina]    Script Date: 12/02/2020 15:40:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE    view [dbo].[vw_frequencia_diaria_carga_medicina] as
select codescola, ano, regime, periodo, codaluno, coddisciplina, turma, data_aula,
       count(case when presente = 0 then 1 else null end) faltas, count(1) as aulas
from (
select json_value(freq.atributos, '$.universus_key_to.codescola') as codescola,
       json_value(freq.atributos, '$.universus_key_to.ano') as ano,
       json_value(freq.atributos, '$.universus_key_to.regime') as regime,
       json_value(freq.atributos, '$.universus_key_to.periodo') as periodo,
       json_value(freq.atributos, '$.universus_key_to.codaluno') as codaluno,
       json_value(freq.atributos, '$.universus_key_to.coddisciplina') as coddisciplina,
       isnull(json_value(freq.atributos, '$.universus_key_to.turma'), json_value(turma.atributos, '$.universus_key.turma')) as turma,
	   freq.presente,
	   convert(date, aula.data_inicio) as data_aula
  from tmp_frequencia_diaria_carga_medicina freq
	   inner join academico_aula aula on aula.id = freq.aula_id
       inner join academico_turmadisciplina td on td.id = aula.turma_disciplina_id
	   inner join academico_turma turma on turma.id = td.turma_id
 where json_query(freq.atributos, '$.universus_avaliacoes') is null
   and json_query(freq.atributos, '$.universus_key_to') is not null --Indica que a TurmaDisciplina possui uma indicação específica sobre para qual turma disciplina no Universus a frequência será enviada. Nesses casos, as frequências serão enviadas no union mais abaixo.
   and aula.data_inicio <= getdate()
   and turma.curso_id = 1
) tab
group by codescola, ano, regime, periodo, codaluno, coddisciplina, turma, data_aula
GO
