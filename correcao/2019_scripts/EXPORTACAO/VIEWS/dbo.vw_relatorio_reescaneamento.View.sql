/****** Object:  View [dbo].[vw_relatorio_reescaneamento]    Script Date: 04/10/2019 10:16:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[vw_relatorio_reescaneamento] as
select 
    url_antiga url_original,
    url_nova url_reescaneada,
    ocorrencia_id id_ocorrencia,
    r.id mascara_redacao,
    (
        CASE
            WHEN LEFT(url_antiga, LEN(url_antiga) - 4) like '%G%' then 'CESGRANRIO'
            WHEN LEFT(url_antiga, LEN(url_antiga) - 4) like '%F%' then 'FGV'
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
        li.id = img.lote_id
        join correcoes_correcao c
            on c.id = oc.correcao_id
                join correcoes_redacao r
                 on c.co_barra_redacao = r.co_barra_redacao;
GO
