USE [erp_hmg]
GO
/****** Object:  View [dbo].[vw_aux_turmadisciplina]    Script Date: 12/02/2020 15:40:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   view  [dbo].[vw_aux_turmadisciplina] as 
select distinct tds.id as turmadisciplina_id, 
                tur.id as turma_id, tur.nome as turma_nome, 
				dis.id as disciplina_id, dis.nome as disciplina_nome

  from academico_turmadisciplina tds join academico_turma      tur on (tur.id = tds.turma_id)
                                     join academico_disciplina dis on (dis.id = tds.disciplina_id)
GO
