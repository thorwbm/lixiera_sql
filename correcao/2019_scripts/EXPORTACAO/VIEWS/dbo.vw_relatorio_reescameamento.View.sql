/****** Object:  View [dbo].[vw_relatorio_reescameamento]    Script Date: 04/10/2019 10:16:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[vw_relatorio_reescameamento] as
select 
    url_antiga url_original,
    url_nova url_reescaneada,
    ocorrencia_id id_ocorrencia,
    (
        CASE
            WHEN url_antiga like '%_G_%' then 'CESGRANRIO'
            WHEN url_antiga like '%_F_%' then 'FGV'
        END
    ) empresa,
    (
        CASE 
            WHEN enviado = 1 then 'SIM'
            WHEN enviado <> 1 then 'NAO'
        END
    ) enviado,
    (
        CASE
            WHEN url_nova is null then 'NAO'
            WHEN url_nova is not null then 'SIM'
        END
    ) respondido
from ocorrencias_imagemfalha img
 join ocorrencias_ocorrencia oc
    on oc.id = img.ocorrencia_id
     JOIN ocorrencias_loteimagem li on 
        li.id = img.lote_id;
GO
