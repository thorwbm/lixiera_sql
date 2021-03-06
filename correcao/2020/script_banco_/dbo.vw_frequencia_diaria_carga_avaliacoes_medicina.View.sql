USE [erp_hmg]
GO
/****** Object:  View [dbo].[vw_frequencia_diaria_carga_avaliacoes_medicina]    Script Date: 09/01/2020 18:38:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE    view [dbo].[vw_frequencia_diaria_carga_avaliacoes_medicina] as
select codescola, ano, regime, periodo, codcurso, numetapa, codetapa, codturno, numgrade, anograde, regimegrade, periodograde, codaluno, coddisciplina, seqenturma, turma, avaliacao, codavalia, professor_id, professor, data_aula,
       count(case when presente = 0 then 1 else null end) faltas, count(1) as aulas
from (
select attr.codescola,
       attr.ano,
       attr.regime,
       attr.periodo,
       attr.codcurso,
       attr.numetapa,
       attr.codetapa,
       attr.codturno,
       attr.numgrade,
       attr.anograde,
       attr.regimegrade,
       attr.periodograde,
       attr.codaluno,
       attr.coddisciplina,
       attr.seqenturma,
       attr.turma,
	   freq.presente,
	   convert(date, aula.data_inicio) as data_aula,
	   attr.avaliacao,
	   attr.codavalia,
	   aula.professor_id,
	   prof.nome as professor,
	   aula.id as aula_id
  from tmp_frequencia_diaria_carga_medicina freq
	   inner join academico_aula aula on aula.id = freq.aula_id
       inner join academico_turmadisciplina td on td.id = aula.turma_disciplina_id
	   inner join academico_turma turma on turma.id = td.turma_id
	   inner join academico_curso curso on curso.id = turma.curso_id
	   inner join academico_professor prof on prof.id = aula.professor_id
	   cross apply openjson (freq.atributos, N'$.universus_avaliacoes')
	       with (codescola int, ano int, regime int, periodo int, codcurso int, numetapa int, codetapa int, codturno int, numgrade int, anograde int, regimegrade int,
		         periodograde int, codaluno int, coddisciplina int, seqenturma int, turma varchar(200), avaliacao int, codavalia int, professor_id int) as attr
 where json_query(freq.atributos, '$.universus_avaliacoes') is not null
	   and aula.data_inicio <= getdate()
	   and attr.professor_id = aula.professor_id
	   and json_value(curso.atributos, '$.universus_key.codcurso') = 1
) tab
group by codescola, ano, regime, periodo, codcurso, numetapa, codetapa, codturno, numgrade, anograde, regimegrade, periodograde, codaluno, coddisciplina, seqenturma, turma, avaliacao, codavalia, professor_id, professor, data_aula
GO
