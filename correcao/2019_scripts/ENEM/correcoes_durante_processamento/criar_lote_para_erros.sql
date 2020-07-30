-- criar novo lote
select * from inep_lote 
--INSERT INTO inep_lote
select 'REDACOES_20191211_5_CORRECAO',	6, DBO.getlocaldate(),	2	,NULL,	NULL,	1	,NULL  -- 107

-- INSERIR OS REGISTROS COM PROBLEMAS NO LOTE 107
INSERT INEP_N59
select  redacao_id, lote_id = 107, projeto_id, criado_em, data_inicio, data_termino, tp_origem, co_inscricao, co_etapa, 
sg_uf_prova, nu_conceito_max_competencia1, nu_conceito_max_competencia2, nu_conceito_max_competencia3, nu_conceito_max_competencia4, 
nu_conceito_max_competencia5, co_tipo_avaliacao, link_imagem_recortada, nu_cpf_av1, dt_inicio_av1, dt_fim_av1, nu_tempo_av1, 
id_lote_av1, co_situacao_redacao_av1, sg_situacao_redacao_av1, nu_nota_av1, nu_nota_comp1_av1, nu_nota_comp2_av1, nu_nota_comp3_av1, 
nu_nota_comp4_av1, nu_nota_comp5_av1, in_fere_dh_av1, nu_cpf_av2, dt_inicio_av2, dt_fim_av2, nu_tempo_av2, id_lote_av2, 
co_situacao_redacao_av2, sg_situacao_redacao_av2, nu_nota_av2, nu_nota_comp1_av2, nu_nota_comp2_av2, nu_nota_comp3_av2,
 nu_nota_comp4_av2, nu_nota_comp5_av2, in_fere_dh_av2, nu_cpf_av3, dt_inicio_av3, dt_fim_av3, nu_tempo_av3, id_lote_av3, 
 co_situacao_redacao_av3, sg_situacao_redacao_av3, nu_nota_av3, nu_nota_comp1_av3, nu_nota_comp2_av3, nu_nota_comp3_av3, 
 nu_nota_comp4_av3, nu_nota_comp5_av3, in_fere_dh_av3, nu_cpf_av4, dt_inicio_av4, dt_fim_av4, nu_tempo_av4, id_lote_av4, 
 co_situacao_redacao_av4, sg_situacao_redacao_av4, nu_nota_av4, nu_nota_comp1_av4, nu_nota_comp2_av4, nu_nota_comp3_av4, 
 nu_nota_comp4_av4, nu_nota_comp5_av4, in_fere_dh_av4, nu_nota_media_comp1, nu_nota_media_comp2, nu_nota_media_comp3, 
 nu_nota_media_comp4, nu_nota_media_comp5, co_situacao_redacao_final, nu_nota_final, in_fere_dh, co_justificativa, 
 nu_cpf_auditor, in_divulgacao, co_projeto
-- into #tmp_carga 
  from inep_n59 
  where lote_id = 103 AND 
        REDACAO_ID IN (SELECT * FROM #temp )