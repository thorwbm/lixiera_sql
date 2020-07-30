/****** Object:  View [dbo].[relatorios_responsabilidadeavaliadorcomdata]    Script Date: 04/10/2019 10:16:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   view [dbo].[relatorios_responsabilidadeavaliadorcomdata] as
 select red.id as id, hie.time_id as id_hierarquia, hie_usu.id_usuario_responsavel,
        cor.id as id_correcao,
        hie.usuario_id as id_corretor, hie.nome as corretor, red.id as redacao, cor.data_termino as data,
	    hie.time_indice as indice, hie.usuario_id, hie.nome, hie_usu.id_hierarquia_usuario_pai, hie_usu.id_tipo_hierarquia_usuario,

		convert(int, ana3.aproveitamento) as aproveitamento,

	    ana3.id_correcao_situacao_A as avaliador_situacao, ana3.competencia1_A as avaliador_c1, ana3.competencia2_A as avaliador_c2,
	    ana3.competencia3_A as avaliador_c3, ana3.competencia4_A as avaliador_c4, ana3.competencia5_A as avaliador_c5, case when ana3.competencia5_A = -1 then 1 else 0 end as avaliador_is_ddh,
	    ana3.nota_final_A as avaliador_soma,
	    cor_espelho.id_correcao_situacao_A as espelho_situacao, cor_espelho.competencia1_A as espelho_c1, cor_espelho.competencia2_A as espelho_c2, cor_espelho.competencia3_A as espelho_c3, cor_espelho.competencia4_A as espelho_c4, cor_espelho.competencia5_A as espelho_c5, case when cor_espelho.competencia5_A = -1 then 1 else 0 end as espelho_is_ddh,
	    cor_espelho.nota_final_A as espelho_soma, cor_espelho.data_termino_A as espelho_data,
	    ana3.id_correcao_situacao_B as terceiro_situacao, ana3.competencia1_B as terceiro_c1, ana3.competencia2_B as terceiro_c2, ana3.competencia3_B as terceiro_c3, ana3.competencia4_B as terceiro_c4, ana3.competencia5_B as terceiro_c5, case when ana3.competencia5_B = -1 then 1 else 0 end as terceiro_is_ddh,
	    ana3.nota_final_B as terceiro_soma, ana3.data_termino_b as terceiro_data,
	    conc_ana3.discrepou, 1 as flg_dado_atual, null as total_correcoes_time, cor.id_projeto
   from correcoes_analise2019 ana3 with(nolock)
        inner join correcoes_conclusao_analise conc_ana3 with(nolock) on conc_ana3.id = ana3.conclusao_analise and ana3.id_tipo_correcao_B = 3
	    inner join correcoes_correcao2019 cor with(nolock) on cor.id = ana3.id_correcao_A
		inner join correcoes_redacao2019 red with(nolock) on red.co_barra_redacao = cor.co_barra_redacao
		inner join vw_usuario_hierarquia_completa hie with(nolock) on hie.usuario_id = cor.id_corretor
		inner join usuarios_hierarquia hie_usu with(nolock) on hie_usu.id = hie.time_id
		inner join correcoes_analise2019 cor_espelho with(nolock) on cor_espelho.co_barra_redacao = ana3.co_barra_redacao and cor_espelho.id_tipo_correcao_A <> ana3.id_tipo_correcao_A and cor_espelho.id_tipo_correcao_B = 3
		left outer join correcoes_filaauditoria aud with(nolock) on (aud.co_barra_redacao = red.co_barra_redacao)
	    left outer join correcoes_correcao2019 corQua with(nolock) on (corQua.co_barra_redacao = red.co_barra_redacao and corQua.id_tipo_correcao = 4)  -- correcoes de quarta
	    left outer join correcoes_correcao2019 corAud with(nolock) on (corAud.co_barra_redacao = red.co_barra_redacao and corAud.id_tipo_correcao = 7)  -- correcoes de auditoria
	    left outer join correcoes_fila3 fil3 with(nolock) on (fil3.co_barra_redacao = red.co_barra_redacao)  -- fila 3
	    left outer join correcoes_fila4 fil4 with(nolock) on (fil4.co_barra_redacao = red.co_barra_redacao) -- fila 4
	    left outer join correcoes_filaauditoria filaud with(nolock) on (filaud.co_barra_redacao = red.co_barra_redacao) -- fila auditoria
union all
 select red.id as id, hie.time_id as id_hierarquia, hie_usu.id_usuario_responsavel,
 cor.id as id_correcao,
        hie.usuario_id as id_corretor, hie.nome as corretor, red.id as redacao, cor.data_termino as data,
	    hie.time_indice as indice, hie.usuario_id, hie.nome, hie_usu.id_hierarquia_usuario_pai, hie_usu.id_tipo_hierarquia_usuario,

		convert(int, ana2.aproveitamento) as aproveitamento,

	   ana2.id_correcao_situacao_A as avaliador_situacao, ana2.competencia1_A as avaliador_c1, ana2.competencia2_A as avaliador_c2,
	   ana2.competencia3_A as avaliador_c3, ana2.competencia4_A as avaliador_c4, ana2.competencia5_A as avaliador_c5, case when ana2.competencia5_A = -1 then 1 else 0 end as avaliador_is_ddh,
	   ana2.nota_final_A as avaliador_soma,
	   ana2.id_correcao_situacao_B as espelho_situacao, ana2.competencia1_B as espelho_c1, ana2.competencia2_B as espelho_c2, ana2.competencia3_B as espelho_c3, ana2.competencia4_B as espelho_c4, ana2.competencia5_B as espelho_c5, case when ana2.competencia5_B = -1 then 1 else 0 end as espelho_is_ddh,
	   ana2.nota_final_B as espelho_soma, ana2.data_termino_B as espelho_data,
	   NULL as terceiro_situacao, NULL as terceiro_c1, NULL as terceiro_c2, NULL as terceiro_c3, NULL as terceiro_c4, NULL as terceiro_c5, case when NULL = -1 then 1 else 0 end as terceiro_is_ddh,
	   NULL as terceiro_soma, NULL as terceiro_data,
	   conc_ana2.discrepou, 1 as flg_dado_atual, null as total_correcoes_time, cor.id_projeto
   from correcoes_analise2019 ana2 with(nolock)
        inner join correcoes_conclusao_analise conc_ana2 with(nolock) on conc_ana2.id = ana2.conclusao_analise and ana2.id_tipo_correcao_B = 2
	    inner join correcoes_correcao2019 cor with(nolock) on cor.id = ana2.id_correcao_A
		inner join correcoes_redacao2019 red with(nolock) on red.co_barra_redacao = cor.co_barra_redacao
		inner join vw_usuario_hierarquia_completa hie with(nolock) on hie.usuario_id = cor.id_corretor
		inner join usuarios_hierarquia hie_usu with(nolock) on hie_usu.id = hie.time_id
		left outer join correcoes_filaauditoria aud with(nolock) on (aud.co_barra_redacao = red.co_barra_redacao)
	    left outer join correcoes_correcao2019 corQua with(nolock) on (corQua.co_barra_redacao = red.co_barra_redacao and corQua.id_tipo_correcao = 4)  -- correcoes de quarta
	    left outer join correcoes_correcao2019 corAud with(nolock) on (corAud.co_barra_redacao = red.co_barra_redacao and corAud.id_tipo_correcao = 7)  -- correcoes de auditoria
	    left outer join correcoes_fila3 fil3 with(nolock) on (fil3.co_barra_redacao = red.co_barra_redacao)  -- fila 3
	    left outer join correcoes_fila4 fil4 with(nolock) on (fil4.co_barra_redacao = red.co_barra_redacao) -- fila 4
	    left outer join correcoes_filaauditoria filaud with(nolock) on (filaud.co_barra_redacao = red.co_barra_redacao) -- fila auditoria
  where conc_ana2.discrepou = 1 and not exists (select top 1 1 from correcoes_analise2019 ana3 with(nolock) where co_barra_redacao = ana2.co_barra_redacao and ana3.id_tipo_correcao_B = 3)

union all

 select red.id as id, hie.time_id as id_hierarquia, hie_usu.id_usuario_responsavel,
 cor.id as id_correcao,
        hie.usuario_id as id_corretor, hie.nome as corretor, red.id as redacao, cor.data_termino as data,
	    hie.time_indice as indice, hie.usuario_id, hie.nome, hie_usu.id_hierarquia_usuario_pai, hie_usu.id_tipo_hierarquia_usuario,
	    aproveitamento = null,
	    ana2.id_correcao_situacao_B as avaliador_situacao, ana2.competencia1_B as avaliador_c1, ana2.competencia2_B as avaliador_c2,
	    ana2.competencia3_B as avaliador_c3, ana2.competencia4_B as avaliador_c4, ana2.competencia5_B as avaliador_c5, case when ana2.competencia5_B = -1 then 1 else 0 end as avaliador_is_ddh,
	    ana2.nota_final_B as avaliador_soma,
	    ana2.id_correcao_situacao_A as espelho_situacao, ana2.competencia1_A as espelho_c1, ana2.competencia2_A as espelho_c2, ana2.competencia3_A as espelho_c3, ana2.competencia4_A as espelho_c4, ana2.competencia5_A as espelho_c5, case when ana2.competencia5_A = -1 then 1 else 0 end as espelho_is_ddh,
	    ana2.nota_final_A as espelho_soma, ana2.data_termino_A as data,
	    NULL as terceiro_situacao, NULL as terceiro_c1, NULL as terceiro_c2, NULL as terceiro_c3, NULL as terceiro_c4, NULL as terceiro_c5, case when NULL = -1 then 1 else 0 end as terceiro_is_ddh,
	    NULL as terceiro_soma, NULL as terceiro_data,
	    conc_ana2.discrepou, 1 as flg_dado_atual, null as total_correcoes_time, cor.id_projeto
   from correcoes_analise2019 ana2 with(nolock)
        inner join correcoes_conclusao_analise conc_ana2 with(nolock) on conc_ana2.id = ana2.conclusao_analise and ana2.id_tipo_correcao_B = 2
	    inner join correcoes_correcao2019 cor with(nolock) on cor.id = ana2.id_correcao_B
		inner join correcoes_redacao2019 red with(nolock) on red.co_barra_redacao = cor.co_barra_redacao
		inner join vw_usuario_hierarquia_completa hie with(nolock) on hie.usuario_id = cor.id_corretor
		inner join usuarios_hierarquia hie_usu with(nolock) on hie_usu.id = hie.time_id
  where conc_ana2.discrepou = 1 and not exists (select top 1 1 from correcoes_analise2019 ana3 with(nolock) where co_barra_redacao = ana2.co_barra_redacao and ana3.id_tipo_correcao_B = 3)

GO
