USE [erp_hmg]
GO
/****** Object:  View [dbo].[vw_aluno_etapaano_competencia]    Script Date: 09/01/2020 18:38:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   view [dbo].[vw_aluno_etapaano_competencia] as  
select distinct alu.aluno_id,  etp.id as etapaano_id,   
        eta.etapa, etp.ano, competencia = convert(varchar(10),eta.etapa) + '/' + convert(varchar(10),etp.ano)  
 from curriculos_aluno alu join curriculos_curriculo crc on (crc.id = alu.curriculo_id)  
         join academico_etapa      eta on (eta.curso_oferta_id = crc.curso_oferta_id)  
                           join academico_etapaano   etp on (eta.id = etp.etapa_id)  
where alu.status_id = 13
GO
