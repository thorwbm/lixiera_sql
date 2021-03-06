USE [erp_hmg]
GO
/****** Object:  View [dbo].[vw_etapaano_competencia]    Script Date: 09/01/2020 18:38:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create view [dbo].[vw_etapaano_competencia] as 
select  distinct eta.id as etapaano_id, 
        etp.etapa, eta.ano, competencia = convert(varchar(10),etp.etapa) + '/' + convert(varchar(10),eta.ano)
from  academico_etapaano eta join academico_etapa etp on (etp.id = eta.etapa_id) 
GO
