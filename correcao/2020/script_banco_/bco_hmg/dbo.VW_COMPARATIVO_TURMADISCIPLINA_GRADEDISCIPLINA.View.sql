USE [erp_hmg]
GO
/****** Object:  View [dbo].[VW_COMPARATIVO_TURMADISCIPLINA_GRADEDISCIPLINA]    Script Date: 12/02/2020 15:40:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   VIEW [dbo].[VW_COMPARATIVO_TURMADISCIPLINA_GRADEDISCIPLINA]
AS
SELECT        dbo.academico_turmadisciplina.id AS TURMADISCIPLINA_ID, dbo.academico_turmadisciplina.disciplina_id, dbo.academico_turmadisciplina.turma_id,
              dbo.academico_turma.nome, dbo.curriculos_gradedisciplina.disciplina_id AS CURRICULOGRADEDISCIPLINA_ID, 
                         dbo.curriculos_grade.id AS CURRICULOGRADE_ID, dbo.academico_disciplina.nome AS DISCIPLINA_NOME
FROM            dbo.academico_turmadisciplina INNER JOIN
                         dbo.academico_turma ON dbo.academico_turmadisciplina.turma_id = dbo.academico_turma.id INNER JOIN
                         dbo.curriculos_grade ON dbo.academico_turma.grade_id = dbo.curriculos_grade.id INNER JOIN
                         dbo.curriculos_gradedisciplina ON dbo.curriculos_grade.id = dbo.curriculos_gradedisciplina.grade_id AND dbo.academico_turmadisciplina.disciplina_id = dbo.curriculos_gradedisciplina.disciplina_id INNER JOIN
                         dbo.academico_disciplina ON dbo.academico_turmadisciplina.disciplina_id = dbo.academico_disciplina.id AND dbo.curriculos_gradedisciplina.disciplina_id = dbo.academico_disciplina.id
GO
