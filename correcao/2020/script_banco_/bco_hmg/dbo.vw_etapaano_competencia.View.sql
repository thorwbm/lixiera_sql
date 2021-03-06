USE [erp_hmg]
GO
/****** Object:  View [dbo].[vw_etapaano_competencia]    Script Date: 12/02/2020 15:40:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create view [dbo].[vw_etapaano_competencia] as 
select  distinct eta.id as etapaano_id, 
        etp.etapa, eta.ano, competencia = convert(varchar(10),etp.etapa) + '/' + convert(varchar(10),eta.ano)
from  academico_etapaano eta join academico_etapa etp on (etp.id = eta.etapa_id) 
GO
