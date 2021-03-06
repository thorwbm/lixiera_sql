/****** Object:  UserDefinedFunction [dbo].[vwf_relatorios_responsabilidadeavaliador]    Script Date: 04/10/2019 10:24:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 CREATE   FUNCTION [dbo].[vwf_relatorios_responsabilidadeavaliador]
(
    @usuario INT, @data_inicio date, @data_fim date
)
RETURNS TABLE
AS
RETURN
(

with cte_primeira as (
        select red.id as id, hie.time_id as id_hierarquia, hie_usu.id_usuario_responsavel,
                hie.usuario_id as id_corretor, hie.nome as corretor, red.id as redacao, cor.data_termino as data,
                hie.time_indice as indice, hie.usuario_id, hie.nome, hie_usu.id_hierarquia_usuario_pai, hie_usu.id_tipo_hierarquia_usuario,
                convert(int, ana3.aproveitamento) as aproveitamento,
                situacao_ava.sigla as avaliador_situacao, ana3.competencia1_A as avaliador_c1, ana3.competencia2_A as avaliador_c2,
                ana3.competencia3_A as avaliador_c3, ana3.competencia4_A as avaliador_c4, ana3.competencia5_A as avaliador_c5, case when ana3.competencia5_A = -1 then 1 else 0 end as avaliador_is_ddh,
                ana3.nota_final_A as avaliador_soma,
                situacao_espelho.sigla as espelho_situacao, cor_espelho.competencia1_A as espelho_c1, cor_espelho.competencia2_A as espelho_c2, cor_espelho.competencia3_A as espelho_c3, cor_espelho.competencia4_A as espelho_c4, cor_espelho.competencia5_A as espelho_c5, case when cor_espelho.competencia5_A = -1 then 1 else 0 end as espelho_is_ddh,
                cor_espelho.nota_final_A as espelho_soma,
                situacao_terceiro.sigla as terceiro_situacao, ana3.competencia1_B as terceiro_c1, ana3.competencia2_B as terceiro_c2, ana3.competencia3_B as terceiro_c3, ana3.competencia4_B as terceiro_c4, ana3.competencia5_B as terceiro_c5, case when ana3.competencia5_B = -1 then 1 else 0 end as terceiro_is_ddh,
                ana3.nota_final_B as terceiro_soma,
                conc_ana3.discrepou, 1 as flg_dado_atual, null as total_correcoes_time, cor.id_projeto
           from correcoes_analise                         ana3              with(NoLock)
                inner join correcoes_correcao             cor               with(NoLock) on (cor.id = ana3.id_correcao_A)
                inner join vw_usuario_hierarquia_completa hie               with(NoLock) on (hie.usuario_id = cor.id_corretor)
                inner join usuarios_hierarquia            hie_usu           with(NoLock) on (hie_usu.id = hie.time_id)
                inner join correcoes_situacao             situacao_terceiro with(NoLock) on (situacao_terceiro.id = ana3.id_correcao_situacao_B)
                inner join correcoes_situacao             situacao_ava      with(NoLock) on (situacao_ava.id = ana3.id_correcao_situacao_A)
                inner join correcoes_conclusao_analise    conc_ana3         with(NoLock) on conc_ana3.id = ana3.conclusao_analise and ana3.id_tipo_correcao_B = 3
                inner join correcoes_redacao              red               with(NoLock) on (red.ID = cor.redacao_id)
                inner join correcoes_analise              cor_espelho       with(NoLock) on (cor_espelho.redacao_id = ana3.redacao_id and 
                                                                                             cor_espelho.id_tipo_correcao_A <> ana3.id_tipo_correcao_A and 
                                                                                             cor_espelho.id_tipo_correcao_B = 3)
                inner join correcoes_situacao             situacao_espelho  with(NoLock) on (situacao_espelho.id = cor_espelho.id_correcao_situacao_A)
    where  usuario_id = @usuario and cor.data_inicio between @data_inicio and @data_fim 
),
    cte_segunda as (
        select red.id as id, hie.time_id as id_hierarquia, hie_usu.id_usuario_responsavel,
        hie.usuario_id as id_corretor, hie.nome as corretor, red.id as redacao, cor.data_termino as data,
        hie.time_indice as indice, hie.usuario_id, hie.nome, hie_usu.id_hierarquia_usuario_pai, hie_usu.id_tipo_hierarquia_usuario,
        convert(int, ana2.aproveitamento) as aproveitamento,
       situacao_ava.sigla as avaliador_situacao, ana2.competencia1_A as avaliador_c1, ana2.competencia2_A as avaliador_c2,
       ana2.competencia3_A as avaliador_c3, ana2.competencia4_A as avaliador_c4, ana2.competencia5_A as avaliador_c5, case when ana2.competencia5_A = -1 then 1 else 0 end as avaliador_is_ddh,
       ana2.nota_final_A as avaliador_soma,
       situacao_espelho.sigla as espelho_situacao, ana2.competencia1_B as espelho_c1, ana2.competencia2_B as espelho_c2, ana2.competencia3_B as espelho_c3, ana2.competencia4_B as espelho_c4, ana2.competencia5_B as espelho_c5, case when ana2.competencia5_B = -1 then 1 else 0 end as espelho_is_ddh,
       ana2.nota_final_B as espelho_soma,
       NULL as terceiro_situacao, NULL as terceiro_c1, NULL as terceiro_c2, NULL as terceiro_c3, NULL as terceiro_c4, NULL as terceiro_c5, case when NULL = -1 then 1 else 0 end as terceiro_is_ddh,
       NULL as terceiro_soma,
       conc_ana2.discrepou, 1 as flg_dado_atual, null as total_correcoes_time, cor.id_projeto
   from correcoes_analise ana2 with(NoLock)
        inner join correcoes_correcao             cor              with(NoLock) on (cor.id = ana2.id_correcao_A)
        inner join vw_usuario_hierarquia_completa hie              with(NoLock) on (hie.usuario_id = cor.id_corretor)
        inner join usuarios_hierarquia            hie_usu          with(NoLock) on (hie_usu.id = hie.time_id)
        inner join correcoes_situacao             situacao_ava     with(NoLock) on (situacao_ava.id = ana2.id_correcao_situacao_A)
        inner join correcoes_situacao             situacao_espelho with(NoLock) on (situacao_espelho.id = ana2.id_correcao_situacao_B)
        inner join correcoes_conclusao_analise    conc_ana2        with(NoLock) on (conc_ana2.id = ana2.conclusao_analise and 
                                                                                    ana2.id_tipo_correcao_B = 2)
        inner join correcoes_redacao              red              with(NoLock) on (red.ID = cor.redacao_id)
  where usuario_id = @usuario and cor.data_inicio between @data_inicio and @data_fim and 
        conc_ana2.discrepou = 1 and 
        not exists (select top 1 1 from correcoes_analise ana3 with(NoLock)  
                     where ana3.redacao_id = ana2.redacao_id and ana3.id_tipo_correcao_B = 3)
      
  ), 
    cte_terceira as (
        select red.id as id, hie.time_id as id_hierarquia, hie_usu.id_usuario_responsavel,
        hie.usuario_id as id_corretor, hie.nome as corretor, red.id as redacao, cor.data_termino as data,
        hie.time_indice as indice, hie.usuario_id, hie.nome, hie_usu.id_hierarquia_usuario_pai, hie_usu.id_tipo_hierarquia_usuario,
        aproveitamento = null,
        situacao_ava.sigla as avaliador_situacao, ana2.competencia1_B as avaliador_c1, ana2.competencia2_B as avaliador_c2,
        ana2.competencia3_B as avaliador_c3, ana2.competencia4_B as avaliador_c4, ana2.competencia5_B as avaliador_c5, case when ana2.competencia5_B = -1 then 1 else 0 end as avaliador_is_ddh,
        ana2.nota_final_B as avaliador_soma,
        situacao_espelho.sigla as espelho_situacao, ana2.competencia1_A as espelho_c1, ana2.competencia2_A as espelho_c2, ana2.competencia3_A as espelho_c3, ana2.competencia4_A as espelho_c4, ana2.competencia5_A as espelho_c5, case when ana2.competencia5_A = -1 then 1 else 0 end as espelho_is_ddh,
        ana2.nota_final_A as espelho_soma,
        NULL as terceiro_situacao, NULL as terceiro_c1, NULL as terceiro_c2, NULL as terceiro_c3, NULL as terceiro_c4, NULL as terceiro_c5, case when NULL = -1 then 1 else 0 end as terceiro_is_ddh,
        NULL as terceiro_soma,
        conc_ana2.discrepou, 1 as flg_dado_atual, null as total_correcoes_time, cor.id_projeto
   from correcoes_analise                         ana2             with(NoLock)
        inner join correcoes_correcao             cor              with(NoLock) on (cor.id = ana2.id_correcao_B)
        inner join vw_usuario_hierarquia_completa hie              with(NoLock) on (hie.usuario_id = cor.id_corretor)
        inner join usuarios_hierarquia            hie_usu          with(NoLock) on (hie_usu.id = hie.time_id)
        inner join correcoes_conclusao_analise    conc_ana2        with(NoLock) on (conc_ana2.id = ana2.conclusao_analise and ana2.id_tipo_correcao_B = 2)
        inner join correcoes_redacao              red              with(NoLock) on (red.ID = cor.redacao_id)
        inner join correcoes_situacao             situacao_ava     with(NoLock) on (situacao_ava.id = ana2.id_correcao_situacao_B)
        inner join correcoes_situacao             situacao_espelho with(NoLock) on (situacao_espelho.id = ana2.id_correcao_situacao_A)
  where usuario_id = @usuario and cor.data_inicio between @data_inicio and @data_fim and 
        conc_ana2.discrepou = 1 and 
        not exists (select top 1 1 from correcoes_analise ana3 with(NoLock) 
                     where ana3.redacao_id = ana2.redacao_id and ana3.id_tipo_correcao_B = 3)
    )

     select * from cte_primeira
     union 
     select * from cte_segunda
     union 
     select * from cte_terceira
)

GO
