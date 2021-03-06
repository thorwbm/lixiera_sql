USE [erp_hmg]
GO
/****** Object:  View [dbo].[vw_log_atividades_atividade_aluno]    Script Date: 09/01/2020 18:38:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[vw_log_atividades_atividade_aluno] as
 select turma.nome as turma, disc.nome as disciplina, prof.nome as professor, us.last_name as usuario_que_alterou, latva.history_date, latva.observacao, latva.history_type, aluno.nome as aluno
   from log_atividades_atividade_aluno latva
        inner join atividades_atividade atv on atv.id = latva.atividade_id
        inner join atividades_criterio_turmadisciplina ctd on ctd.id = atv.criterio_turma_disciplina_id
        inner join academico_turmadisciplina td on td.id = ctd.turma_disciplina_id
        inner join auth_user us on us.id = latva.history_user_id
        inner join academico_professor prof on prof.id = ctd.professor_id
        inner join academico_aluno aluno on aluno.id = latva.aluno_id
        inner join academico_turma turma on turma.id = td.turma_id
        inner join academico_disciplina disc on disc.id = td.disciplina_id
GO
