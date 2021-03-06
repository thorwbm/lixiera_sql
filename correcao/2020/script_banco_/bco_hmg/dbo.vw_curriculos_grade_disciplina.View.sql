USE [erp_hmg]
GO
/****** Object:  View [dbo].[vw_curriculos_grade_disciplina]    Script Date: 12/02/2020 15:40:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[vw_curriculos_grade_disciplina] as 
select crc.id as curriculo_id, crc.nome as curriculo_nome, 
       gra.id as grade_id, gra.nome as grade_nome, 
	   grd.id as gradedisciplina_id, egd.id as exigenciadisciplina_id, egd.nome as exigenciaDisciplina_nome,
	   dis.id as disciplina_id, dis.nome as disciplina_nome, 
	   etp.id as etapa_id, etp.nome as etapa_nome,etp.etapa
  from curriculos_curriculo crc join curriculos_grade               gra on (crc.id = gra.curriculo_id)
                                join curriculos_gradedisciplina     grd on (gra.id = grd.grade_id)
								join curriculos_exigenciadisciplina egd on (egd.id = grd.exigencia_disciplina_id)
								join academico_disciplina           dis on (dis.id = grd.disciplina_id)
								join academico_etapa                etp on (etp.id = gra.etapa_id)
GO
