USE [erp_hmg]
GO
/****** Object:  View [dbo].[vw_Disciplina_Turma_Criterio_Professor]    Script Date: 12/02/2020 15:40:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_Disciplina_Turma_Criterio_Professor] as
select curso.nome as Curso, d.nome as Disciplina, t.nome as Turma, t.inicio_vigencia, t.termino_vigencia, aa.valor as Valor, aa.peso as Peso, aa.nome as Atividade, prof.nome as Professor
from academico_turmadisciplina td 
join academico_turma t on t.id = td.turma_id
join academico_disciplina d on d.id = td.disciplina_id
join atividades_criterio_turmadisciplina actd on actd.turma_disciplina_id = td.id
join atividades_criterio ac on ac.id = actd.criterio_id
join atividades_atividade aa on aa.criterio_turma_disciplina_id = actd.id
left join academico_professor prof on prof.id = actd.professor_id
join academico_curso curso on curso.id = t.curso_id
GO
