USE [erp_hmg]
GO
/****** Object:  View [dbo].[vw_turma_disciplina_educat]    Script Date: 12/02/2020 15:40:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   view [dbo].[vw_turma_disciplina_educat] as
select turma.nome as turma, disc.nome as disciplina, (select aluno.nome from academico_turmadisciplinaaluno tda inner join academico_aluno aluno on aluno.id = tda.aluno_id where tda.turma_disciplina_id = td.id order by aluno.nome FOR JSON PATH) as alunos
  from academico_turmadisciplina td
       inner join academico_turma turma on turma.id = td.turma_id
	   inner join academico_curso curso on curso.id = turma.curso_id and curso.escola_id = 1
	   inner join academico_disciplina disc on disc.id = td.disciplina_id
GO
