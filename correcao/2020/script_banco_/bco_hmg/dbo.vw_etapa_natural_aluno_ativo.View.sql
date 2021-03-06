USE [erp_hmg]
GO
/****** Object:  View [dbo].[vw_etapa_natural_aluno_ativo]    Script Date: 12/02/2020 15:40:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[vw_etapa_natural_aluno_ativo] as 
select cra.aluno_id,alu.nome as aluno_nome, alu.ra,  
       cra.curriculo_id, gra.id as grade_id, gra.nome as grade_nome,
       eta.etapa as etapa_natural, eta.id as etapa_id
  from curriculos_aluno cra join curriculos_grade gra on (gra.id = cra.grade_id)
                            join academico_etapa  eta on (eta.id = gra.etapa_id)
							join academico_aluno  alu on (alu.id = cra.aluno_id)
where cra.status_id = 13

							
GO
