USE [erp_hmg]
GO
/****** Object:  View [dbo].[vw_aulas_sem_alunos]    Script Date: 12/02/2020 15:40:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[vw_aulas_sem_alunos]
as 
select c.nome curso, t.nome turma, d.nome disciplina, au.data_inicio, au.data_termino, p.nome professor from academico_aula au
join academico_turmadisciplina td on td.id = au.turma_disciplina_id
join academico_turma t on t.id = td.turma_id
join academico_disciplina d on d.id = td.disciplina_id
join academico_curso c on c.id = t.curso_id
join academico_professor p on p.id = au.professor_id
where turma_disciplina_id not in (select turma_disciplina_id from academico_turmadisciplinaaluno)
GO
