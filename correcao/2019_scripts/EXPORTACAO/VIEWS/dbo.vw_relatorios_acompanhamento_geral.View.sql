/****** Object:  View [dbo].[vw_relatorios_acompanhamento_geral]    Script Date: 04/10/2019 10:16:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   VIEW [dbo].[vw_relatorios_acompanhamento_geral] as
select
    projeto,
    projeto_id,
    nr_1_correcao_concluida,
    nr_2_correcao_concluida,
    nr_3_correcao_concluida,
    nr_4_correcao_concluida,
    nr_ouro_concluida,
    nr_moda_concluida,
    nr_auditoria_concluida,
    nr_redacoes_em_andamento,
    nr_redacoes_concluidas,
    etapa_ensino_id,
    etapa_ensino
from (
    select
        SUM(CASE WHEN cor.id_tipo_correcao = 1 and cor.id_status = 3 THEN 1 ELSE 0 END) as nr_1_correcao_concluida,
        SUM(CASE WHEN cor.id_tipo_correcao = 2 and cor.id_status = 3 THEN 1 ELSE 0 END) as nr_2_correcao_concluida,
        SUM(CASE WHEN cor.id_tipo_correcao = 3 and cor.id_status = 3 THEN 1 ELSE 0 END) as nr_3_correcao_concluida,
        SUM(CASE WHEN cor.id_tipo_correcao = 4 and cor.id_status = 3 THEN 1 ELSE 0 END) as nr_4_correcao_concluida,
        SUM(CASE WHEN cor.id_tipo_correcao = 5 and cor.id_status = 3 THEN 1 ELSE 0 END) as nr_ouro_concluida,
        SUM(CASE WHEN cor.id_tipo_correcao = 6 and cor.id_status = 3 THEN 1 ELSE 0 END) as nr_moda_concluida,
        SUM(CASE WHEN cor.id_tipo_correcao = 7 and cor.id_status = 3 THEN 1 ELSE 0 END) as nr_auditoria_concluida,
        cor.id_projeto as projeto_id,
        proj.descricao as projeto,
        etap.id as etapa_ensino_id,
        etap.abreviacao as etapa_ensino
    from correcoes_correcao cor
    join projeto_projeto proj on cor.id_projeto = proj.id
    left join projeto_etapaensino etap on proj.etapa_ensino_id = etap.id
    group by cor.id_projeto, proj.descricao, etap.id, etap.abreviacao) a
join (
    select 
        id_projeto,
        COUNT(DISTINCT(CASE WHEN red.id_correcao_situacao IN (2, 3) THEN red.co_barra_redacao END)) as nr_redacoes_em_andamento,
        COUNT(DISTINCT(CASE WHEN red.id_correcao_situacao = 4 THEN red.co_barra_redacao END)) as nr_redacoes_concluidas
    from correcoes_redacao red
    group by id_projeto) b
on a.projeto_id = b.id_projeto

GO
