USE [erp_hmg]
GO
/****** Object:  View [dbo].[vw_curriculo_turma_disciplina_grade_oferta]    Script Date: 12/02/2020 15:40:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[vw_curriculo_turma_disciplina_grade_oferta] as 
select  crc.id as curriculo_id, crc.nome as curriculo_nome, 
        gra.id as grade_id, gra.nome as grade_nome, 
		tur.id as turma_id, tur.nome as turma_nome, 
		dis.id as disciplina_id, dis.nome as disciplina_nome, cro.tipo_oferta_id
from academico_turmadisciplina tds join academico_turma       tur on (tur.id = tds.turma_id)
                                   join academico_disciplina  dis on (dis.id = tds.disciplina_id)
								   join curriculos_grade      gra on (gra.id = tur.grade_id)
								   join curriculos_curriculo  crc on (crc.id = gra.curriculo_id)
								   join academico_cursooferta cro on (cro.id = crc.curso_oferta_id)


								   
GO
