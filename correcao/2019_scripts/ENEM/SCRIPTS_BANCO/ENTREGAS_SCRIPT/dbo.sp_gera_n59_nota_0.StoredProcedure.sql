/****** Object:  StoredProcedure [dbo].[sp_gera_n59_nota_0]    Script Date: 26/12/2019 13:14:39 ******/
DROP PROCEDURE IF EXISTS [dbo].[sp_gera_n59_nota_0]
GO
/****** Object:  StoredProcedure [dbo].[sp_gera_n59_nota_0]    Script Date: 26/12/2019 13:14:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[sp_gera_n59_nota_0] @lote_id int, @co_inscricao varchar(50), @situacao int as
begin

    declare @nota_max_competencia_em int
    declare @nota_max_competencia_ef int

    set @nota_max_competencia_em = 200
    set @nota_max_competencia_ef = 250

    begin tran

    --Caso exista registro da inscrição que será zerada, para os lotes pendentes de análise,
    -- a inscrição é apagada para garantir que fique apenas o registro zerado.
    delete from inep_n59 where co_inscricao = @co_inscricao and lote_id in (select id from inep_lote where status_id = 1)

	insert into inep_n59 (lote_id, criado_em, tp_origem, co_inscricao, co_etapa, sg_uf_prova, nu_conceito_max_competencia1, 
                          nu_conceito_max_competencia2, nu_conceito_max_competencia3, nu_conceito_max_competencia4, nu_conceito_max_competencia5,
                          co_tipo_avaliacao, co_situacao_redacao_final,
                          projeto_id,
                          nu_nota_media_comp1, nu_nota_media_comp2, nu_nota_media_comp3, nu_nota_media_comp4, nu_nota_media_comp5, nu_nota_final,
                          co_projeto, in_divulgacao, link_imagem_recortada)
     select @lote_id, dbo.getlocaldate(), 'F', @co_inscricao, substring(co_barra_redacao, 3, 1), n02.SG_UF_PROVA,
            case substring(co_barra_redacao, 3, 1) when '1' then @nota_max_competencia_ef when '2' then @nota_max_competencia_em else 0 end,
            case substring(co_barra_redacao, 3, 1) when '1' then @nota_max_competencia_ef when '2' then @nota_max_competencia_em else 0 end,
            case substring(co_barra_redacao, 3, 1) when '1' then @nota_max_competencia_ef when '2' then @nota_max_competencia_em else 0 end,
            case substring(co_barra_redacao, 3, 1) when '1' then @nota_max_competencia_ef when '2' then @nota_max_competencia_em else 0 end,
            case substring(co_barra_redacao, 3, 1) when '1' then null when '2' then @nota_max_competencia_em else 0 end,
            case n91.id_item_atendimento when 8 then 2 when 11 then 3 else null end, @situacao,
            case substring(co_barra_redacao, 3, 1)
                 when '1' then (case n91.id_item_atendimento when 8 then 2 when 11 then 3 else 1 end)
                 when '2' then (case n91.id_item_atendimento when 8 then 5 when 11 then 6 else 4 end)
                 else 0
            end,
            0, 0, 0, 0, 0, 0, n02.co_projeto, 0, essay.processed_key
       from inep_n02 n02
            left outer join inep_n91 n91 on n91.co_inscricao = n02.co_inscricao
            left outer join subscriptions_subscription s on s.enrolment_key = n02.co_inscricao
	        left outer join batch_essay essay on essay.id = s.essay_id
      where n02.co_inscricao = @co_inscricao

    commit

end
GO
