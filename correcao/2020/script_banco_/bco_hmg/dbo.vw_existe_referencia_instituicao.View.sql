USE [erp_hmg]
GO
/****** Object:  View [dbo].[vw_existe_referencia_instituicao]    Script Date: 12/02/2020 15:40:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[vw_existe_referencia_instituicao] as 
select distinct instituicao_ensino_medio_id as codigo from historicos_historico  union  
select distinct instituicao_id from academico_pessoa_titulacao  union 
select distinct instituicao_id from  academico_alunodisciplinainformada union 
select distinct instituicao_id from curriculos_disciplinainformada
GO
