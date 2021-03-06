/****** Object:  StoredProcedure [dbo].[sp_criar_lote_bi_batimento]    Script Date: 26/12/2019 13:14:39 ******/
DROP PROCEDURE IF EXISTS [dbo].[sp_criar_lote_bi_batimento]
GO
/****** Object:  StoredProcedure [dbo].[sp_criar_lote_bi_batimento]    Script Date: 26/12/2019 13:14:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[sp_criar_lote_bi_batimento] as
	begin

	DECLARE @co_inscricao NVARCHAR(50), @id_situacao int, @lote_id int
	declare @data_char char(8) = format(dbo.getlocaldate(), 'yyyyMMdd')
	declare @prefixo varchar(50) = 'REDACOES'
    declare @tipo_bi int = 3
    declare @interface_n59 int = 1
	
    declare @nota_max_competencia_em int
    declare @nota_max_competencia_ef int

    set @nota_max_competencia_em = 200
    set @nota_max_competencia_ef = 250

	insert into inep_lote (nome, status_id, criado_em, tipo_id, interface_id) values (@prefixo + '_' + @data_char + '_BI_BATIMENTO', 1, dbo.getlocaldate(), @tipo_bi, @interface_n59)
	set @lote_id = @@IDENTITY

	insert into inep_n59 (lote_id, criado_em, tp_origem, co_inscricao, co_etapa, sg_uf_prova, nu_conceito_max_competencia1, 
                          nu_conceito_max_competencia2, nu_conceito_max_competencia3, nu_conceito_max_competencia4, nu_conceito_max_competencia5,
                          co_tipo_avaliacao, co_situacao_redacao_final,
                          projeto_id,
                          nu_nota_media_comp1, nu_nota_media_comp2, nu_nota_media_comp3, nu_nota_media_comp4, nu_nota_media_comp5, nu_nota_final,
                          co_projeto, in_divulgacao, link_imagem_recortada)
     select @lote_id, dbo.getlocaldate(), 'F', n02.co_inscricao, substring(n02.co_barra_redacao, 3, 1), isnull(n90.SG_UF_MUNICIPIO_PROVA, n02.SG_UF_PROVA),
            200,
            200,
            200,
            200,
            200,
            case n91.id_item_atendimento when 8 then 2 when 5 then 3 else 1 end as co_tipo_avaliacao,
            case isnull(s.result, 'blank') when 'blank' then 4 else 8 end co_situacao_redacao_final,
            case n91.id_item_atendimento when 8 then 5 when 5 then 6 else 4 end as projeto_id,
            0, 0, 0, 0, 0, 0, n02.co_projeto, 0, s.processed_key
       from inep_n02 n02
	        left outer join subscriptions_subscription_3 s on s.enrolment_key = n02.co_inscricao
--	        left outer join batch_essay essay on essay.id = s.essay_id
            left outer join inep_n91 n91 on n91.CO_INSCRICAO = n02.CO_INSCRICAO
            left outer join inep_n90 n90 on n90.CO_INSCRICAO = n02.CO_INSCRICAO
      where (s.result in ('blank', 'insufficient') or s.removed = 1)

end
GO
