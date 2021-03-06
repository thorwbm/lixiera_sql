USE [erp_hmg]
GO
/****** Object:  View [dbo].[vw_matriz_dcn]    Script Date: 12/02/2020 15:40:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[vw_matriz_dcn] as
 select af.curso_id, curso.nome as curso, saf.area_formacao_id, af.nome as area_formacao, do.subarea_formacao_id, saf.nome as sub_area_formacao, de.dominio_id, do.nome as dominio, de.id as desempenho_id, de.nome as desempenho
   from dcn_areaformacao af
        inner join dcn_subareaformacao saf on saf.area_formacao_id = af.id
        inner join dcn_dominio do on do.subarea_formacao_id = saf.id
        inner join dcn_desempenho de on de.dominio_id = do.id
        inner join academico_curso curso on curso.id = af.curso_id
GO
