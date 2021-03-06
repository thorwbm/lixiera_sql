USE [erp_hmg]
GO
/****** Object:  View [dbo].[vw_etapa_natural]    Script Date: 12/02/2020 15:40:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[vw_etapa_natural] as 
select ea.ano as ano, ea.periodo as periodo, etapa.etapa as etapa_natural, aluno.id as aluno_id, ca.id as curriculo_aluno_id
  from curriculos_etapanatural en
       join academico_etapaano ea on ea.id = en.etapa_ano_id
       join academico_etapa etapa on etapa.id = ea.etapa_id
       join curriculos_aluno ca on ca.id = en.curriculo_aluno_id
       join academico_aluno aluno on aluno.id = ca.aluno_id

GO
