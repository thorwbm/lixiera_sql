USE [erp_hmg]
GO
/****** Object:  View [dbo].[vw_gradedisciplinaequivalente]    Script Date: 12/02/2020 15:40:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   view [dbo].[vw_gradedisciplinaequivalente] as  
select equiv.grade_disciplina_id, grade.curriculo_id, cur.nome as nome_curriculo, etapa.nome as nome_etapa, etapa.etapa, disc.nome as disciplina,  
       equiv.grade_disciplina_equivalente_id, gradeequiv.curriculo_id as curriculo_equivalente_id, curequiv.nome as nome_curriculo_equivalente, 
	   etapaequiv.nome as nome_etapa_equivalente, etapaequiv.etapa as etapa_equivalente, discequiv.nome as disciplina_equivalente,  
       equiv.atributos  
  from curriculos_gradedisciplinaequivalente equiv      with(nolock) 
       join curriculos_gradedisciplina       gd         with(nolock) on gd.id = equiv.grade_disciplina_id  
       join curriculos_gradedisciplina       gdequiv    with(nolock) on gdequiv.id = equiv.grade_disciplina_equivalente_id  
       join curriculos_grade                 grade      with(nolock) on  grade.id = gd.grade_id  
       join curriculos_grade                 gradeequiv with(nolock) on gradeequiv.id = gdequiv.grade_id  
       join curriculos_curriculo             cur        with(nolock) on cur.id = grade.curriculo_id  
       join curriculos_curriculo             curequiv   with(nolock) on curequiv.id = gradeequiv.curriculo_id  
       join academico_etapa                  etapa      with(nolock) on etapa.id = grade.etapa_id  
       join academico_etapa                  etapaequiv with(nolock) on etapaequiv.id = gradeequiv.etapa_id  
       join academico_disciplina             disc       with(nolock) on disc.id = gd.disciplina_id  
       join academico_disciplina             discequiv  with(nolock) on discequiv.id = gdequiv.disciplina_id  
GO
