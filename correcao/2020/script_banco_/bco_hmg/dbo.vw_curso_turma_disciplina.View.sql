USE [erp_hmg]
GO
/****** Object:  View [dbo].[vw_curso_turma_disciplina]    Script Date: 12/02/2020 15:40:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   view [dbo].[vw_curso_turma_disciplina] as 
select cur.id as curso_id, cur.nome as curso_nome, 
       tur.id as turma_id, tur.nome as turma_nome, 
	   dis.id as disciplina_id, dis.nome as disciplina_nome, 
	   tur.inicio_vigencia, tur.termino_vigencia, tur.grade_id, tur.turma_pai_id,
	   tdc.id as turma_disciplina_id 
  from academico_turmadisciplina tdc with(nolock) join academico_turma      tur with(nolock) on (tur.id = tdc.turma_id)
                                                  join academico_disciplina dis with(nolock) on (dis.id = tdc.disciplina_id)
												  join academico_curso      cur with(nolock) on (cur.id = tur.curso_id)


GO
