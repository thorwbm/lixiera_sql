USE [erp_hmg]
GO
/****** Object:  View [dbo].[vw_frequencia_diaria_carga_avaliacoes]    Script Date: 09/01/2020 18:38:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


create view [dbo].[vw_frequencia_diaria_carga_avaliacoes] as
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
	   prof.nome as professor
  from academico_turmadisciplinaaluno tda
       inner join academico_turmadisciplina td on td.id = tda.turma_disciplina_id
	   inner join academico_turma turma on turma.id = td.turma_id
	   inner join academico_aula aula on aula.turma_disciplina_id = td.id
	   inner join tmp_frequencia_diaria_carga freq on freq.aula_id = aula.id and freq.aluno_id = tda.aluno_id
	   inner join academico_professor prof on prof.id = aula.professor_id
	   cross apply openjson (tda.atributos, N'$.universus_avaliacoes')
	       with (codescola int, ano int, regime int, periodo int, codcurso int, numetapa int, codetapa int, codturno int, numgrade int, anograde int, regimegrade int,
		         periodograde int, codaluno int, coddisciplina int, seqenturma int, turma varchar(200), avaliacao int, codavalia int, professor_id int) as attr
 where json_query(tda.atributos, '$.universus_avaliacoes') is not null
	   and aula.data_inicio <= getdate()
	   and turma.atributos is not null
	   and attr.professor_id = aula.professor_id
) tab
group by codescola, ano, regime, periodo, codcurso, numetapa, codetapa, codturno, numgrade, anograde, regimegrade, periodograde, codaluno, coddisciplina, seqenturma, turma, avaliacao, codavalia, professor_id, professor, data_aula
GO
