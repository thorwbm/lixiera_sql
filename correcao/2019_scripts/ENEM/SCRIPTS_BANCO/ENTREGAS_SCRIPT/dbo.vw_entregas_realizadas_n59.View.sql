/****** Object:  View [dbo].[vw_entregas_realizadas_n59]    Script Date: 26/12/2019 13:14:39 ******/
DROP VIEW IF EXISTS [dbo].[vw_entregas_realizadas_n59]
GO
/****** Object:  View [dbo].[vw_entregas_realizadas_n59]    Script Date: 26/12/2019 13:14:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[vw_entregas_realizadas_n59] as
select lote.nome as lote, lote.data_liberacao,
n59.id, n59.redacao_id, n59.lote_id, n59.projeto_id, n59.criado_em, n59.data_inicio, n59.data_termino, n59.tp_origem, n59.co_inscricao, n59.co_etapa, n59.sg_uf_prova, n59.nu_conceito_max_competencia1, n59.nu_conceito_max_competencia2, n59.nu_conceito_max_competencia3, n59.nu_conceito_max_competencia4, n59.nu_conceito_max_competencia5, n59.co_tipo_avaliacao, n59.link_imagem_recortada, n59.nu_cpf_av1, n59.dt_inicio_av1, n59.dt_fim_av1, n59.nu_tempo_av1, n59.id_lote_av1, n59.co_situacao_redacao_av1, n59.sg_situacao_redacao_av1, n59.nu_nota_av1, n59.nu_nota_comp1_av1, n59.nu_nota_comp2_av1, n59.nu_nota_comp3_av1, n59.nu_nota_comp4_av1, n59.nu_nota_comp5_av1, n59.in_fere_dh_av1, n59.nu_cpf_av2, n59.dt_inicio_av2, n59.dt_fim_av2, n59.nu_tempo_av2, n59.id_lote_av2, n59.co_situacao_redacao_av2, n59.sg_situacao_redacao_av2, n59.nu_nota_av2, n59.nu_nota_comp1_av2, n59.nu_nota_comp2_av2, n59.nu_nota_comp3_av2, n59.nu_nota_comp4_av2, n59.nu_nota_comp5_av2, n59.in_fere_dh_av2, n59.nu_cpf_av3, n59.dt_inicio_av3, n59.dt_fim_av3, n59.nu_tempo_av3, n59.id_lote_av3, n59.co_situacao_redacao_av3, n59.sg_situacao_redacao_av3, n59.nu_nota_av3, n59.nu_nota_comp1_av3, n59.nu_nota_comp2_av3, n59.nu_nota_comp3_av3, n59.nu_nota_comp4_av3, n59.nu_nota_comp5_av3, n59.in_fere_dh_av3, n59.nu_cpf_av4, n59.dt_inicio_av4, n59.dt_fim_av4, n59.nu_tempo_av4, n59.id_lote_av4, n59.co_situacao_redacao_av4, n59.sg_situacao_redacao_av4, n59.nu_nota_av4, n59.nu_nota_comp1_av4, n59.nu_nota_comp2_av4, n59.nu_nota_comp3_av4, n59.nu_nota_comp4_av4, n59.nu_nota_comp5_av4, n59.in_fere_dh_av4, n59.nu_nota_media_comp1 as nu_nota_comp1_final, n59.nu_nota_media_comp2 as nu_nota_comp2_final, n59.nu_nota_media_comp3 as nu_nota_comp3_final, n59.nu_nota_media_comp4 as nu_nota_comp4_final, n59.nu_nota_media_comp5 as nu_nota_comp5_final, n59.co_situacao_redacao_final, n59.nu_nota_final, n59.in_fere_dh, n59.co_justificativa, n59.nu_cpf_auditor, n59.in_divulgacao, n59.co_projeto
  from inep_n59 n59 join inep_lote lote on lote.id = n59.lote_id and lote.status_id = 4 and substituido_por is null
GO
