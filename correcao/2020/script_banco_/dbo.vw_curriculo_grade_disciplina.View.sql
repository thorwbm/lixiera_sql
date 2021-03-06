USE [erp_hmg]
GO
/****** Object:  View [dbo].[vw_curriculo_grade_disciplina]    Script Date: 09/01/2020 18:38:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[vw_curriculo_grade_disciplina] as 
select distinct crc.id as curriculo_id, crc.nome as curriculo_nome, crc.carga_horaria_min_exigida, 
			    crg.id as grade_id,  crd.id as gradeDisciplina_id, 
			   dis.id as disciplina_id, dis.nome as disciplina_nome
		  from curriculos_curriculo crc join curriculos_grade           crg on (crc.id = crg.curriculo_id)
										join curriculos_gradedisciplina crd on (crg.id = crd.grade_id) 
										join academico_disciplina       dis on (dis.id = crd.disciplina_id)
GO
