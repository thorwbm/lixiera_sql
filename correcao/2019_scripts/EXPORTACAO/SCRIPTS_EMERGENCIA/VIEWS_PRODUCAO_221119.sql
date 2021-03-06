--#####################################################
/*
relatorios_responsabilidadeavaliador VIEW

vw_relatorio_padrao_ouro_geral VIEW

vw_relatorio_padrao_ouro_polo  VIEW
*/
--#####################################################


CREATE OR ALTER      view [dbo].[correcoes_analise2019] as select * from correcoes_analise

GO
/****** Object:  View [dbo].[correcoes_analise2019_back]    Script Date: 22/11/2019 11:44:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER      view [dbo].[correcoes_analise2019_back] as select * from correcoes_analise where id_corretor_A in (select user_id from usuarios_hierarquia_usuarios where hierarquia_id > 400) or id_correcao_B in (select user_id from usuarios_hierarquia_usuarios where id > 400)

GO
/****** Object:  View [dbo].[correcoes_correcao2019]    Script Date: 22/11/2019 11:44:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER      view [dbo].[correcoes_correcao2019] as select * from correcoes_correcao

GO
/****** Object:  View [dbo].[correcoes_correcao2019_back]    Script Date: 22/11/2019 11:44:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER    view [dbo].[correcoes_correcao2019_back] as select * from correcoes_correcao where id_corretor in (select user_id from usuarios_hierarquia_usuarios where hierarquia_id > 400)

GO
/****** Object:  View [dbo].[correcoes_redacao2019]    Script Date: 22/11/2019 11:44:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER      view [dbo].[correcoes_redacao2019] as
select * from correcoes_redacao

GO
/****** Object:  View [dbo].[correcoes_redacao2019_back]    Script Date: 22/11/2019 11:44:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER      view [dbo].[correcoes_redacao2019_back] as
select * from correcoes_redacao where co_barra_redacao like '%EVT%' or link_imagem_recortada like '%evento_teste2%'
union
select * from correcoes_redacao red where exists (select top 1 1 from correcoes_correcao corr join auth_user us on us.id = corr.id_corretor where red.id = corr.redacao_id and us.username in (
'02801198528',
'05075837522',
'03918462560',
'99311925500',
'50934015520',
'79357652515'
))

GO
/****** Object:  View [dbo].[relatorios_responsabilidadeavaliador]    Script Date: 22/11/2019 11:44:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*
CREATE OR ALTER      VIEW [dbo].[relatorios_responsabilidadeavaliador] as

 select red.id as id, hie.time_id as id_hierarquia, hie_usu.id_usuario_responsavel, 
        hie.usuario_id as id_corretor, hie.nome as corretor, red.id as redacao, cor.data_termino as data, 
	    hie.time_indice as indice, hie.usuario_id, hie.nome, hie_usu.id_hierarquia_usuario_pai, hie_usu.id_tipo_hierarquia_usuario, 

		convert(int, ana3.aproveitamento) as aproveitamento,

	    ana3.id_correcao_situacao_A as avaliador_situacao, ana3.competencia1_A as avaliador_c1, ana3.competencia2_A as avaliador_c2, 
	    ana3.competencia3_A as avaliador_c3, ana3.competencia4_A as avaliador_c4, ana3.competencia5_A as avaliador_c5, case when ana3.competencia5_A = -1 then 1 else 0 end as avaliador_is_ddh, 
	    ana3.nota_final_A as avaliador_soma,
	    cor_espelho.id_correcao_situacao_A as espelho_situacao, cor_espelho.competencia1_A as espelho_c1, cor_espelho.competencia2_A as espelho_c2, cor_espelho.competencia3_A as espelho_c3, cor_espelho.competencia4_A as espelho_c4, cor_espelho.competencia5_A as espelho_c5, case when cor_espelho.competencia5_A = -1 then 1 else 0 end as espelho_is_ddh, 
	    cor_espelho.nota_final_A as espelho_soma,
	    ana3.id_correcao_situacao_B as terceiro_situacao, ana3.competencia1_B as terceiro_c1, ana3.competencia2_B as terceiro_c2, ana3.competencia3_B as terceiro_c3, ana3.competencia4_B as terceiro_c4, ana3.competencia5_B as terceiro_c5, case when ana3.competencia5_B = -1 then 1 else 0 end as terceiro_is_ddh,
	    ana3.nota_final_B as terceiro_soma,
	    conc_ana3.discrepou, 1 as flg_dado_atual, null as total_correcoes_time, cor.id_projeto
   from correcoes_analise ana3 with(NoLock)
        inner join correcoes_conclusao_analise conc_ana3 with(NoLock) on conc_ana3.id = ana3.conclusao_analise and ana3.id_tipo_correcao_B = 3
	    inner join correcoes_correcao cor with(NoLock) on cor.id = ana3.id_correcao_A
		inner join correcoes_redacao red with(NoLock) on red.co_barra_redacao = cor.co_barra_redacao
		inner join vw_usuario_hierarquia_completa hie with(NoLock) on hie.usuario_id = cor.id_corretor
		inner join usuarios_hierarquia hie_usu with(NoLock) on hie_usu.id = hie.time_id
		inner join correcoes_analise cor_espelho with(NoLock) on cor_espelho.co_barra_redacao = ana3.co_barra_redacao and cor_espelho.id_tipo_correcao_A <> ana3.id_tipo_correcao_A and cor_espelho.id_tipo_correcao_B = 3
		left outer join correcoes_filaauditoria aud with(NoLock) on (aud.co_barra_redacao = red.co_barra_redacao)
	    left outer join correcoes_correcao corQua with(NoLock) on (corQua.co_barra_redacao = red.co_barra_redacao and corQua.id_tipo_correcao = 4)  -- correcoes de quarta
	    left outer join correcoes_correcao corAud with(NoLock) on (corAud.co_barra_redacao = red.co_barra_redacao and corAud.id_tipo_correcao = 7)  -- correcoes de auditoria
	    left outer join correcoes_fila3 fil3 with(NoLock) on (fil3.co_barra_redacao = red.co_barra_redacao)  -- fila 3
	    left outer join correcoes_fila4 fil4 with(NoLock) on (fil4.co_barra_redacao = red.co_barra_redacao) -- fila 4 
	    left outer join correcoes_filaauditoria filaud with(NoLock) on (filaud.co_barra_redacao = red.co_barra_redacao) -- fila auditoria
union all
 select red.id as id, hie.time_id as id_hierarquia, hie_usu.id_usuario_responsavel, 
        hie.usuario_id as id_corretor, hie.nome as corretor, red.id as redacao, cor.data_termino as data, 
	    hie.time_indice as indice, hie.usuario_id, hie.nome, hie_usu.id_hierarquia_usuario_pai, hie_usu.id_tipo_hierarquia_usuario, 

		convert(int, ana2.aproveitamento) as aproveitamento,

	   ana2.id_correcao_situacao_A as avaliador_situacao, ana2.competencia1_A as avaliador_c1, ana2.competencia2_A as avaliador_c2, 
	   ana2.competencia3_A as avaliador_c3, ana2.competencia4_A as avaliador_c4, ana2.competencia5_A as avaliador_c5, case when ana2.competencia5_A = -1 then 1 else 0 end as avaliador_is_ddh, 
	   ana2.nota_final_A as avaliador_soma,
	   ana2.id_correcao_situacao_B as espelho_situacao, ana2.competencia1_B as espelho_c1, ana2.competencia2_B as espelho_c2, ana2.competencia3_B as espelho_c3, ana2.competencia4_B as espelho_c4, ana2.competencia5_B as espelho_c5, case when ana2.competencia5_B = -1 then 1 else 0 end as espelho_is_ddh, 
	   ana2.nota_final_B as espelho_soma,
	   NULL as terceiro_situacao, NULL as terceiro_c1, NULL as terceiro_c2, NULL as terceiro_c3, NULL as terceiro_c4, NULL as terceiro_c5, case when NULL = -1 then 1 else 0 end as terceiro_is_ddh,
	   NULL as terceiro_soma,
	   conc_ana2.discrepou, 1 as flg_dado_atual, null as total_correcoes_time, cor.id_projeto
   from correcoes_analise ana2 with(NoLock) 
        inner join correcoes_conclusao_analise conc_ana2 with(NoLock) on conc_ana2.id = ana2.conclusao_analise and ana2.id_tipo_correcao_B = 2
	    inner join correcoes_correcao cor with(NoLock) on cor.id = ana2.id_correcao_A
		inner join correcoes_redacao red with(NoLock) on red.co_barra_redacao = cor.co_barra_redacao
		inner join vw_usuario_hierarquia_completa hie with(NoLock) on hie.usuario_id = cor.id_corretor
		inner join usuarios_hierarquia hie_usu with(NoLock) on hie_usu.id = hie.time_id
		left outer join correcoes_filaauditoria aud with(NoLock) on (aud.co_barra_redacao = red.co_barra_redacao)
	    left outer join correcoes_correcao corQua with(NoLock) on (corQua.co_barra_redacao = red.co_barra_redacao and corQua.id_tipo_correcao = 4)  -- correcoes de quarta
	    left outer join correcoes_correcao corAud with(NoLock) on (corAud.co_barra_redacao = red.co_barra_redacao and corAud.id_tipo_correcao = 7)  -- correcoes de auditoria
	    left outer join correcoes_fila3 fil3 with(NoLock) on (fil3.co_barra_redacao = red.co_barra_redacao)  -- fila 3
	    left outer join correcoes_fila4 fil4 with(NoLock) on (fil4.co_barra_redacao = red.co_barra_redacao) -- fila 4 
	    left outer join correcoes_filaauditoria filaud with(NoLock) on (filaud.co_barra_redacao = red.co_barra_redacao) -- fila auditoria
  where conc_ana2.discrepou = 1 and not exists (select top 1 1 from correcoes_analise ana3 with(NoLock)  where co_barra_redacao = ana2.co_barra_redacao and ana3.id_tipo_correcao_B = 3)

union all

 select red.id as id, hie.time_id as id_hierarquia, hie_usu.id_usuario_responsavel, 
        hie.usuario_id as id_corretor, hie.nome as corretor, red.id as redacao, cor.data_termino as data, 
	    hie.time_indice as indice, hie.usuario_id, hie.nome, hie_usu.id_hierarquia_usuario_pai, hie_usu.id_tipo_hierarquia_usuario, 
	    aproveitamento = null,
	   
	    ana2.id_correcao_situacao_B as avaliador_situacao, ana2.competencia1_B as avaliador_c1, ana2.competencia2_B as avaliador_c2, 
	    ana2.competencia3_B as avaliador_c3, ana2.competencia4_B as avaliador_c4, ana2.competencia5_B as avaliador_c5, case when ana2.competencia5_B = -1 then 1 else 0 end as avaliador_is_ddh, 
	    ana2.nota_final_B as avaliador_soma,
	    ana2.id_correcao_situacao_A as espelho_situacao, ana2.competencia1_A as espelho_c1, ana2.competencia2_A as espelho_c2, ana2.competencia3_A as espelho_c3, ana2.competencia4_A as espelho_c4, ana2.competencia5_A as espelho_c5, case when ana2.competencia5_A = -1 then 1 else 0 end as espelho_is_ddh, 
	    ana2.nota_final_A as espelho_soma,
	    NULL as terceiro_situacao, NULL as terceiro_c1, NULL as terceiro_c2, NULL as terceiro_c3, NULL as terceiro_c4, NULL as terceiro_c5, case when NULL = -1 then 1 else 0 end as terceiro_is_ddh,
	    NULL as terceiro_soma,
	    conc_ana2.discrepou, 1 as flg_dado_atual, null as total_correcoes_time, cor.id_projeto
   from correcoes_analise ana2 with(NoLock)
        inner join correcoes_conclusao_analise conc_ana2 with(NoLock) on conc_ana2.id = ana2.conclusao_analise and ana2.id_tipo_correcao_B = 2
	    inner join correcoes_correcao cor with(NoLock) on cor.id = ana2.id_correcao_B
		inner join correcoes_redacao red with(NoLock) on red.co_barra_redacao = cor.co_barra_redacao
		inner join vw_usuario_hierarquia_completa hie with(NoLock) on hie.usuario_id = cor.id_corretor
		inner join usuarios_hierarquia hie_usu with(NoLock) on hie_usu.id = hie.time_id
  where conc_ana2.discrepou = 1 and not exists (select top 1 1 from correcoes_analise ana3 with(NoLock) where co_barra_redacao = ana2.co_barra_redacao and ana3.id_tipo_correcao_B = 3)


*/

GO
/****** Object:  View [dbo].[relatorios_responsabilidadeavaliadorcomdata]    Script Date: 22/11/2019 11:44:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER    view [dbo].[relatorios_responsabilidadeavaliadorcomdata] as
 select red.id as id_redacao, hie.time_id as id_hierarquia, hie_usu.id_usuario_responsavel,
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
   from correcoes_analise ana3 with(nolock)
        inner join correcoes_conclusao_analise conc_ana3 with(nolock) on conc_ana3.id = ana3.conclusao_analise and ana3.id_tipo_correcao_B = 3
        inner join correcoes_correcao cor with(nolock) on cor.id = ana3.id_correcao_A
        inner join correcoes_redacao red with(nolock) on red.co_barra_redacao = cor.co_barra_redacao
        inner join vw_usuario_hierarquia_completa hie with(nolock) on hie.usuario_id = cor.id_corretor
        inner join usuarios_hierarquia hie_usu with(nolock) on hie_usu.id = hie.time_id
        inner join correcoes_analise cor_espelho with(nolock) on cor_espelho.co_barra_redacao = ana3.co_barra_redacao and cor_espelho.id_tipo_correcao_A <> ana3.id_tipo_correcao_A and cor_espelho.id_tipo_correcao_B = 3
        left outer join correcoes_filaauditoria aud with(nolock) on (aud.co_barra_redacao = red.co_barra_redacao)
        left outer join correcoes_correcao corQua with(nolock) on (corQua.co_barra_redacao = red.co_barra_redacao and corQua.id_tipo_correcao = 4)  -- correcoes de quarta
        left outer join correcoes_correcao corAud with(nolock) on (corAud.co_barra_redacao = red.co_barra_redacao and corAud.id_tipo_correcao = 7)  -- correcoes de auditoria
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
   from correcoes_analise ana2 with(nolock)
        inner join correcoes_conclusao_analise conc_ana2 with(nolock) on conc_ana2.id = ana2.conclusao_analise and ana2.id_tipo_correcao_B = 2
        inner join correcoes_correcao cor with(nolock) on cor.id = ana2.id_correcao_A
        inner join correcoes_redacao red with(nolock) on red.co_barra_redacao = cor.co_barra_redacao
        inner join vw_usuario_hierarquia_completa hie with(nolock) on hie.usuario_id = cor.id_corretor
        inner join usuarios_hierarquia hie_usu with(nolock) on hie_usu.id = hie.time_id
        left outer join correcoes_filaauditoria aud with(nolock) on (aud.co_barra_redacao = red.co_barra_redacao)
        left outer join correcoes_correcao corQua with(nolock) on (corQua.co_barra_redacao = red.co_barra_redacao and corQua.id_tipo_correcao = 4)  -- correcoes de quarta
        left outer join correcoes_correcao corAud with(nolock) on (corAud.co_barra_redacao = red.co_barra_redacao and corAud.id_tipo_correcao = 7)  -- correcoes de auditoria
        left outer join correcoes_fila3 fil3 with(nolock) on (fil3.co_barra_redacao = red.co_barra_redacao)  -- fila 3
        left outer join correcoes_fila4 fil4 with(nolock) on (fil4.co_barra_redacao = red.co_barra_redacao) -- fila 4
        left outer join correcoes_filaauditoria filaud with(nolock) on (filaud.co_barra_redacao = red.co_barra_redacao) -- fila auditoria
  where conc_ana2.discrepou = 1 and not exists (select top 1 1 from correcoes_analise ana3 with(nolock) where co_barra_redacao = ana2.co_barra_redacao and ana3.id_tipo_correcao_B = 3)

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
   from correcoes_analise ana2 with(nolock)
        inner join correcoes_conclusao_analise conc_ana2 with(nolock) on conc_ana2.id = ana2.conclusao_analise and ana2.id_tipo_correcao_B = 2
        inner join correcoes_correcao cor with(nolock) on cor.id = ana2.id_correcao_B
        inner join correcoes_redacao red with(nolock) on red.co_barra_redacao = cor.co_barra_redacao
        inner join vw_usuario_hierarquia_completa hie with(nolock) on hie.usuario_id = cor.id_corretor
        inner join usuarios_hierarquia hie_usu with(nolock) on hie_usu.id = hie.time_id
  where conc_ana2.discrepou = 1 and not exists (select top 1 1 from correcoes_analise ana3 with(nolock) where co_barra_redacao = ana2.co_barra_redacao and ana3.id_tipo_correcao_B = 3)

GO
/****** Object:  View [dbo].[vw_aproveitamento_notas_time]    Script Date: 22/11/2019 11:44:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER      VIEW [dbo].[vw_aproveitamento_notas_time] as
select
    polo.id as polo_id,
    polo.descricao as polo_descricao,
    time.id as time_id,
    time.descricao as time_descricao,
    time.indice as indice,
    p.nome as avaliador,
    ultima_correcao,
    isnull(discrepantes.id_corretor, total_correcoes_1a_2a.id_corretor) usuario_id,
    isnull(discrepantes.data, total_correcoes_1a_2a.data) data,
    isnull(total_correcoes_1a_2a.nr_corrigidas, 0 ) nr_corrigidas,
    isnull(nr_aproveitadas, 0) nr_aproveitadas,
    isnull(nr_nao_aproveitadas, 0) nr_nao_aproveitadas,
    isnull(nr_discrepantes, 0) nr_discrepantes
from (
    select
        id_corretor,
        cast(data as date) data,
        count(1) nr_discrepantes,
        sum(case when aproveitamento = 1 then 1 else 0 end) as nr_aproveitadas,
        sum(case when (aproveitamento = 0 or aproveitamento is null) and terceiro_situacao is not null then 1 else 0 end) as nr_nao_aproveitadas
    from  relatorios_responsabilidadeavaliadorcomdata
    group by id_corretor, cast(data as date)
) discrepantes
right join (
    select
        id_corretor,
        cast(data_termino as date) [data],
        COUNT(1) nr_corrigidas,
        MAX(data_termino) as ultima_correcao
    from correcoes_correcao
    where data_termino is not null and id_tipo_correcao in (1, 2)
    GROUP by id_corretor, cast(data_termino as date)
) total_correcoes_1a_2a on total_correcoes_1a_2a.id_corretor = discrepantes.id_corretor
    and discrepantes.data = total_correcoes_1a_2a.[data]
inner join dbo.usuarios_pessoa p on p.usuario_id = isnull(discrepantes.id_corretor, total_correcoes_1a_2a.id_corretor)
inner join dbo.usuarios_hierarquia_usuarios b on b.user_id = isnull(discrepantes.id_corretor, total_correcoes_1a_2a.id_corretor)
inner join dbo.usuarios_hierarquia as [time] on [time].id = b.hierarquia_id
inner join dbo.usuarios_hierarquia as polo on polo.id = [time].id_hierarquia_usuario_pai
inner join dbo.usuarios_hierarquia as fgv on fgv.id = polo.id_hierarquia_usuario_pai
inner join dbo.usuarios_hierarquia as geral on geral.id = fgv.id_hierarquia_usuario_pai

GO
/****** Object:  View [dbo].[vw_avaliadores]    Script Date: 22/11/2019 11:44:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER    view [dbo].[vw_avaliadores] as
select 
       a.geral_descricao as geral,
       a.fgv_descricao as fgv,
       a.polo_descricao as polo,
       a.time_descricao as time, 
       a.indice,
       b.cpf,
       b.email,
       b.telefone_celular,
       b.municipio,
       b.dddtelefone_celular,
       b.uf,
       b.nome,
       f.id_usuario_responsavel,
       f.descricao as hierarquia,
       b.usuario_id as id,
       b.cep,
       b.bairro,
       b.complemento,
       b.dddtelefone_residencial,
       b.logradouro,
       b.numero,
       b.telefone_residencial,
       a.time_id as hierarquia_id,
       c.max_correcoes_dia,
       c.status_id,
       e.id as group_id,
       e.name as group_name,
       c.pode_corrigir_1,
       c.pode_corrigir_2,
       c.pode_corrigir_3,
        (( CASE WHEN c.pode_corrigir_1 = 1
                        AND (c.pode_corrigir_2 = 1
                            OR c.pode_corrigir_3 = 1) THEN
                        '1ª, '
                        WHEN c.pode_corrigir_1 = 1 THEN
                        '1ª'
                    ELSE
                        ''
        END) + ( CASE WHEN c.pode_corrigir_2 = 1
                AND c.pode_corrigir_3 = 1 THEN
                '2ª, '
                WHEN c.pode_corrigir_2 = 1 THEN
                '2ª'
            ELSE
                ''
        END) + ( CASE WHEN c.pode_corrigir_3 = 1 THEN
                '3ª'
            ELSE
                ''
        END)) AS tipo_correcao,
        count(g.data_termino) as total_correcoes,
        (SELECT
            COUNT(j.id)
        FROM
            dbo.correcoes_suspensao j
        WHERE (j.id_corretor = c.id)) AS total_suspensoes,
        h.max_correcoes_dia as projeto_max_correcoes_dia,
        h.id AS projeto_id

  from vw_usuarios_hierarquia_para_vw_avaliadores a
       inner join usuarios_pessoa b on b.usuario_id = a.usuario_id
       inner join correcoes_corretor c on c.id = a.usuario_id
       inner join auth_user_groups d on c.id = d.user_id
       inner join auth_group e on e.id = d.group_id
       left outer join usuarios_hierarquia f on f.id = a.time_id
       left outer join projeto_projeto_usuarios i on i.user_id = c.id
       left outer join projeto_projeto h on h.id = i.projeto_id
       left outer join correcoes_correcao g on g.id_corretor = c.id
group by
       a.geral_descricao,
       a.fgv_descricao,
       a.polo_descricao,
       a.time_descricao, 
       a.indice,
       b.cpf,
       b.email,
       b.telefone_celular,
       b.municipio,
       b.dddtelefone_celular,
       b.uf,
       b.nome,
       f.id_usuario_responsavel,
       f.descricao,
       b.usuario_id,
       b.cep,
       b.bairro,
       b.complemento,
       b.dddtelefone_residencial,
       b.logradouro,
       b.numero,
       b.telefone_residencial,
       a.time_id,
       c.max_correcoes_dia,
       c.status_id,
       e.id,
       e.name,
       c.pode_corrigir_1,
       c.pode_corrigir_2,
       c.pode_corrigir_3,
       c.id,
       h.max_correcoes_dia,
       h.id

GO
/****** Object:  View [dbo].[vw_cor_avalia_discrepancia_divergencia_correcao_1_2]    Script Date: 22/11/2019 11:44:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER      view [dbo].[vw_cor_avalia_discrepancia_divergencia_correcao_1_2] as
select red.id, red.co_barra_redacao, red.id_projeto, cor1.id_corretor as id_corretor1, cor2.id_corretor as id_corretor2, cor1.id as correcao1, cor2.id as correcao2,
       cor1.id_correcao_situacao as situacao1, cor2.id_correcao_situacao as situacao2,
       abs(cor1.nota_final - cor2.nota_final) as notaTotal,
       abs(cor1.nota_competencia1 - cor2.nota_competencia1) as competencia1,
       abs(cor1.nota_competencia2 - cor2.nota_competencia2) as competencia2,
       abs(cor1.nota_competencia3 - cor2.nota_competencia3) as competencia3,
       abs(cor1.nota_competencia4 - cor2.nota_competencia4) as competencia4,
       abs(cor1.nota_competencia5 - cor2.nota_competencia5) as competencia5,
       case when abs(isnull(cor1.id_correcao_situacao, 0) - isnull(cor2.id_correcao_situacao, 0)) > 0 then 'SIM' else 'NÃO' end as divergenciaSituacao
  from correcoes_redacao red
       inner join correcoes_correcao cor1 on cor1.redacao_id = red.id and cor1.id_tipo_correcao = 1 and cor1.id_status = 3
       inner join correcoes_correcao cor2 on cor2.redacao_id = red.id and cor2.id_tipo_correcao = 2 and cor2.id_status = 3
 where red.id_redacaoouro is null


GO
/****** Object:  View [dbo].[vw_cor_avalia_discrepancia_divergencia_correcao_1_3]    Script Date: 22/11/2019 11:44:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER      view [dbo].[vw_cor_avalia_discrepancia_divergencia_correcao_1_3] as
select red.id, red.co_barra_redacao, red.id_projeto, cor1.id_corretor as id_corretor1, cor3.id_corretor as id_corretor2, cor1.id as correcao1, cor3.id as correcao2,
       cor1.id_correcao_situacao as situacao1, cor3.id_correcao_situacao as situacao2,
       abs(cor1.nota_final -   cor3.nota_final) as notaTotal,
       abs(cor1.nota_competencia1 - cor3.nota_competencia1) as competencia1,
       abs(cor1.nota_competencia2 - cor3.nota_competencia2) as competencia2,
       abs(cor1.nota_competencia3 - cor3.nota_competencia3) as competencia3,
       abs(cor1.nota_competencia4 - cor3.nota_competencia4) as competencia4,
       abs(cor1.nota_competencia5 - cor3.nota_competencia5) as competencia5,
       case when abs(isnull(cor1.id_correcao_situacao, 0) - isnull(cor3.id_correcao_situacao, 0)) > 0 then 'SIM' else 'NÃO' end as divergenciaSituacao
  from correcoes_redacao red
       inner join correcoes_correcao cor1 on cor1.redacao_id = red.id and cor1.id_tipo_correcao = 1 and cor1.id_status = 3
       inner join correcoes_correcao cor3 on cor3.redacao_id = red.id and cor3.id_tipo_correcao = 3 and cor3.id_status = 3
 where red.id_redacaoouro is null


GO
/****** Object:  View [dbo].[vw_cor_avalia_discrepancia_divergencia_correcao_2_3]    Script Date: 22/11/2019 11:44:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER      view [dbo].[vw_cor_avalia_discrepancia_divergencia_correcao_2_3] as
select red.id, red.co_barra_redacao, red.id_projeto, cor2.id_corretor as id_corretor1, cor3.id_corretor as id_corretor2, cor2.id as correcao1, cor3.id as correcao2,
       cor2.id_correcao_situacao as situacao1, cor3.id_correcao_situacao as situacao2,
       abs(cor2.nota_final -   cor3.nota_final) as notaTotal,
       abs(cor2.nota_competencia1 - cor3.nota_competencia1) as competencia1,
       abs(cor2.nota_competencia2 - cor3.nota_competencia2) as competencia2,
       abs(cor2.nota_competencia3 - cor3.nota_competencia3) as competencia3,
       abs(cor2.nota_competencia4 - cor3.nota_competencia4) as competencia4,
       abs(cor2.nota_competencia5 - cor3.nota_competencia5) as competencia5,
       case when abs(isnull(cor2.id_correcao_situacao, 0) - isnull(cor3.id_correcao_situacao, 0)) > 0 then 'SIM' else 'NÃO' end as divergenciaSituacao
  from correcoes_redacao red
       inner join correcoes_correcao cor2 on cor2.redacao_id = red.id and cor2.id_tipo_correcao = 2 and cor2.id_status = 3
       inner join correcoes_correcao cor3 on cor3.redacao_id = red.id and cor3.id_tipo_correcao = 3 and cor3.id_status = 3
 where red.id_redacaoouro is null


GO
/****** Object:  View [dbo].[vw_cor_avalia_discrepancia_divergencia_correcao_3_4]    Script Date: 22/11/2019 11:44:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER      view [dbo].[vw_cor_avalia_discrepancia_divergencia_correcao_3_4] as
select red.id, red.co_barra_redacao, red.id_projeto, cor3.id_corretor as id_corretor1, cor4.id_corretor as id_corretor2, cor3.id as correcao1, cor4.id as correcao2,
       cor3.id_correcao_situacao as situacao1, cor4.id_correcao_situacao as situacao2,
       abs(cor3.nota_final -   cor4.nota_final) as notaTotal,
       abs(cor3.competencia1 - cor4.competencia1) as competencia1,
       abs(cor3.competencia2 - cor4.competencia2) as competencia2,
       abs(cor3.competencia3 - cor4.competencia3) as competencia3,
       abs(cor3.competencia4 - cor4.competencia4) as competencia4,
       abs(cor3.competencia5 - cor4.competencia5) as competencia5,
       case when abs(isnull(cor3.id_correcao_situacao, 0) - isnull(cor4.id_correcao_situacao, 0)) > 0 then 'SIM' else 'NÃO' end as divergenciaSituacao
  from correcoes_redacao red
       inner join correcoes_correcao cor3 on cor3.redacao_id = red.id and cor3.id_tipo_correcao = 3 and cor3.id_status = 3
       inner join correcoes_correcao cor4 on cor4.redacao_id = red.id and cor4.id_tipo_correcao = 4 and cor4.id_status = 3
 where red.id_redacaoouro is null


GO
/****** Object:  View [dbo].[vw_cor_batimento_gabarito]    Script Date: 22/11/2019 11:44:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER    view [dbo].[vw_cor_batimento_gabarito] as

select cor.co_barra_redacao,
       cor.redacao_id,
       cor.id_projeto,
       cor.id_corretor,
       cor.id as id_correcao,
       cor.link_imagem_recortada,
       cor.link_imagem_original,
       cor.data_inicio as data_inicio_correcao,
       cor.data_termino as data_termino_correcao,
       cor.nota_final as nota_final_correcao,
       cor.id_auxiliar1,
       cor.id_auxiliar2,
       cor.id_status,
       cor.id_tipo_correcao,
       cor.competencia1 as id_competencia1_correcao,
       cor.competencia2 as id_competencia2_correcao,
       cor.competencia3 as id_competencia3_correcao,
       cor.competencia4 as id_competencia4_correcao,
       cor.competencia5 as id_competencia5_correcao,
       case when cor.id_correcao_situacao <> 1 then null else cor.nota_competencia1 end as nota_competencia1_correcao,
       case when cor.id_correcao_situacao <> 1 then null else cor.nota_competencia2 end as nota_competencia2_correcao,
       case when cor.id_correcao_situacao <> 1 then null else cor.nota_competencia3 end as nota_competencia3_correcao,
       case when cor.id_correcao_situacao <> 1 then null else cor.nota_competencia4 end as nota_competencia4_correcao,
       case when cor.id_correcao_situacao <> 1 then null else cor.nota_competencia5 end as nota_competencia5_correcao,
       cor.id_correcao_situacao as id_correcao_situacao_correcao,
       gab.nota_final as nota_final_gabarito,
       gab.id_competencia1 as id_competencia1_gabarito,
       gab.id_competencia2 as id_competencia2_gabarito,
       gab.id_competencia3 as id_competencia3_gabarito,
       gab.id_competencia4 as id_competencia4_gabarito,
       gab.id_competencia5 as id_competencia5_gabarito,
       gab.nota_competencia1 as nota_competencia1_gabarito,
       gab.nota_competencia2 as nota_competencia2_gabarito,
       gab.nota_competencia3 as nota_competencia3_gabarito,
       gab.nota_competencia4 as nota_competencia4_gabarito,
       gab.nota_competencia5 as nota_competencia5_gabarito,
       gab.id_correcao_situacao as id_correcao_situacao_gabarito,
       abs(isnull(cor.nota_final, 0) - isnull(gab.nota_final, 0)) as nota_final_diferenca,
       abs(isnull(cor.nota_competencia1, 0) - isnull(gab.nota_competencia1, 0)) as competencia1_diferenca,
       abs(isnull(cor.nota_competencia2, 0) - isnull(gab.nota_competencia2, 0)) as competencia2_diferenca,
       abs(isnull(cor.nota_competencia3, 0) - isnull(gab.nota_competencia3, 0)) as competencia3_diferenca,
       abs(isnull(cor.nota_competencia4, 0) - isnull(gab.nota_competencia4, 0)) as competencia4_diferenca,
       abs(isnull(cor.nota_competencia5, 0) - isnull(gab.nota_competencia5, 0)) as competencia5_diferenca,
       case when cor.id_correcao_situacao <> gab.id_correcao_situacao then 'SIM' else 'NAO' end as divergencia_situacao
from correcoes_correcao cor with(nolock)
     join correcoes_gabarito gab with(nolock) on cor.redacao_id = gab.redacao_id
where cor.id_status = 3

GO
/****** Object:  View [dbo].[vw_cor_usuario_grupo]    Script Date: 22/11/2019 11:44:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER    view [dbo].[vw_cor_usuario_grupo] as
select id_usuario = usr.id, usr.first_name, usr.last_name, usr.is_superuser, ugr.group_id,  
       grupo = gro.name, cor.max_correcoes_dia, grupo_corretor = cor.id_grupo ,  
    cor.pode_corrigir_1, cor.pode_corrigir_2, cor.pode_corrigir_3, cor.pode_corrigir_4, cor.status_id  
  from auth_user usr join auth_user_groups ugr on (ugr.user_id = usr.id)  
                     join auth_group       gro on (gro.id = ugr.group_id)  
      join correcoes_corretor cor on (cor.id = usr.id);  

GO
/****** Object:  View [dbo].[vw_correcao_correcoes]    Script Date: 22/11/2019 11:44:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER    VIEW [dbo].[vw_correcao_correcoes]
AS
SELECT        TOP (100) PERCENT dbo.correcoes_correcao.id, dbo.correcoes_correcao.data_inicio, dbo.correcoes_correcao.data_termino, dbo.correcoes_correcao.correcao, dbo.correcoes_correcao.link_imagem_recortada, 
                         dbo.correcoes_correcao.link_imagem_original, dbo.correcoes_correcao.nota_final, dbo.correcoes_correcao.competencia1, dbo.correcoes_correcao.competencia2, dbo.correcoes_correcao.competencia3, 
                         dbo.correcoes_correcao.competencia4, dbo.correcoes_correcao.competencia5, dbo.correcoes_correcao.nota_competencia1, dbo.correcoes_correcao.nota_competencia2, dbo.correcoes_correcao.nota_competencia3, 
                         dbo.correcoes_correcao.nota_competencia4, dbo.correcoes_correcao.nota_competencia5, dbo.correcoes_correcao.id_auxiliar1, dbo.correcoes_correcao.id_auxiliar2, dbo.correcoes_correcao.id_correcao_situacao, 
                         dbo.correcoes_situacao.descricao, dbo.correcoes_correcao.id_corretor, dbo.correcoes_correcao.id_status, dbo.correcoes_status.descricao AS status_correcao, dbo.correcoes_correcao.id_tipo_correcao, 
                         dbo.correcoes_tipo.descricao AS tipo_correcao, dbo.correcoes_correcao.id_projeto, dbo.projeto_projeto.descricao AS Projeto, dbo.correcoes_correcao.co_barra_redacao, dbo.correcoes_corretor.id AS IdCorretor, 
                         dbo.correcoes_corretor.id_grupo, dbo.correcoes_grupocorretor.grupo, dbo.correcoes_grupocorretor.proficiencia, dbo.auth_user.username, dbo.auth_user.first_name, dbo.auth_user.last_name
FROM            dbo.correcoes_corretor INNER JOIN
                         dbo.correcoes_grupocorretor ON dbo.correcoes_corretor.id_grupo = dbo.correcoes_grupocorretor.id INNER JOIN
                         dbo.auth_user ON dbo.correcoes_corretor.id = dbo.auth_user.id RIGHT OUTER JOIN
                         dbo.correcoes_correcao ON dbo.correcoes_corretor.id = dbo.correcoes_correcao.id_corretor LEFT OUTER JOIN
                         dbo.projeto_projeto ON dbo.correcoes_correcao.id_projeto = dbo.projeto_projeto.id LEFT OUTER JOIN
                         dbo.correcoes_tipo ON dbo.correcoes_correcao.id_tipo_correcao = dbo.correcoes_tipo.id LEFT OUTER JOIN
                         dbo.correcoes_situacao ON dbo.correcoes_correcao.id_correcao_situacao = dbo.correcoes_situacao.id LEFT OUTER JOIN
                         dbo.correcoes_status ON dbo.correcoes_correcao.id_status = dbo.correcoes_status.id

GO
/****** Object:  View [dbo].[VW_CORRECAO_DIA]    Script Date: 22/11/2019 11:44:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER    VIEW  [dbo].[VW_CORRECAO_DIA] AS
SELECT COR.ID, CORRECOES = ISNULL(COR.max_correcoes_dia,PRO.max_correcoes_dia), id_projeto = pro.id
FROM CORRECOES_CORRETOR COR JOIN PROJETO_PROJETO PRO ON (1=1)

GO
/****** Object:  View [dbo].[vw_correcao_resumo]    Script Date: 22/11/2019 11:44:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER    view [dbo].[vw_correcao_resumo] as
SELECT correcoes_analise.id_corretor_A as id, usuarios_pessoa.cpf, usuarios_pessoa.nome, usuarios_pessoa.email, vw_corretor_analise.nota, vw_corretor_analise.QTD_CORRECOES as correcoes, correcoes_contador.data_inicio_correcao as data_inicio,MAX(correcoes_analise.data_termino_A) AS data_termino
FROM correcoes_analise
inner join usuarios_pessoa on correcoes_analise.id_corretor_A = usuarios_pessoa.usuario_id
LEFT OUTER JOIN vw_corretor_analise on correcoes_analise.id_corretor_A = vw_corretor_analise.id_corretor
LEFT OUTER JOIN correcoes_correcao on correcoes_analise.id_corretor_A = correcoes_correcao.id_corretor
LEFT OUTER JOIN correcoes_contador on correcoes_analise.id_corretor_A = correcoes_contador.id_corretor
GROUP by correcoes_analise.id_corretor_A, usuarios_pessoa.cpf, usuarios_pessoa.nome, usuarios_pessoa.email, vw_corretor_analise.nota, vw_corretor_analise.QTD_CORRECOES, correcoes_contador.data_inicio_correcao


GO
/****** Object:  View [dbo].[vw_correcoes_presas]    Script Date: 22/11/2019 11:44:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER    view [dbo].[vw_correcoes_presas]
as
select polo.descricao as polo, time.descricao as time, b.last_name, a.id from (
select id, id_corretor from correcoes_correcao where data_termino is null
) a
join auth_user b on a.id_corretor = b.id
join correcoes_corretor d on b.id = d.id
left outer join usuarios_hierarquia_usuarios c on c.user_id = b.id
left outer join usuarios_hierarquia time on c.hierarquia_id = time.id
left outer join usuarios_hierarquia polo on time.id_hierarquia_usuario_pai = polo.id
where d.status_id = 4

GO
/****** Object:  View [dbo].[vw_correcoes_usuario]    Script Date: 22/11/2019 11:44:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER      VIEW [dbo].[vw_correcoes_usuario] AS
      SELECT
        usuario.id as usuario_id,
        last_name as nome,
        count(correcao.id) AS nr_corrigidas,
        MAX(correcao.data_termino) AS ultima_correcao,
        uh.indice
    FROM auth_user usuario
    LEFT JOIN correcoes_correcao correcao ON correcao.id_corretor = usuario.id
    JOIN usuarios_hierarquia_usuarios uhu on uhu.user_id = usuario.id
    join usuarios_hierarquia uh on uh.id = uhu.hierarquia_id
    where correcao.data_termino is not null
    GROUP BY usuario.id, last_name, uh.indice

GO
/****** Object:  View [dbo].[vw_corretor_analise]    Script Date: 22/11/2019 11:44:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER    view [dbo].[vw_corretor_analise] as
select id_corretor_A as id_corretor, sum(nota) as nota,
 QTD_CORRECOES = (SELECT COUNT(*)
                    FROM correcoes_analise ANAX
                   WHERE ANAX.id_corretor_A = TBLBASE.ID_CORRETOR_A),
 QTD_DISCREPANCIA = (SELECT COUNT(*)
                    FROM correcoes_analise ANAX
                   WHERE ANAX.id_corretor_A = TBLBASE.ID_CORRETOR_A AND
                         (diferenca_situacao    = 2 OR
                          situacao_nota_final   = 2 OR
                          situacao_competencia1 = 2 OR
                          situacao_competencia2 = 2 OR
                          situacao_competencia3 = 2 OR
                          situacao_competencia4 = 2 OR
                          situacao_competencia5 = 2
                          )) ,
 QTD_DIVERGENCIA = (SELECT COUNT(*)
                    FROM correcoes_analise ANAX
                   WHERE ANAX.id_corretor_A = TBLBASE.ID_CORRETOR_A AND
                         (diferenca_situacao    = 1 OR
                          situacao_nota_final   = 1 OR
                          situacao_competencia1 = 1 OR
                          situacao_competencia2 = 1 OR
                          situacao_competencia3 = 1 OR
                          situacao_competencia4 = 1 OR
                          situacao_competencia5 = 1
                          )) ,
 QTD_DISC_SITUACAO = (SELECT COUNT(*)
                    FROM correcoes_analise ANAX
                   WHERE ANAX.id_corretor_A = TBLBASE.ID_CORRETOR_A AND
                         (diferenca_situacao    = 2))
  from (select id_corretor_A,
               nota = case when diferenca_situacao     = 0 and situacao_nota_final   = 0 and
                                (situacao_competencia1 = 0 and situacao_competencia2 = 0 and
                                 situacao_competencia3 = 0 and situacao_competencia4 = 0 and
                                 situacao_competencia5 = 0 ) then 1.4
                           when diferenca_situacao > 0 then 0
                           when (situacao_nota_final   = 2 or
                                (situacao_competencia1 = 2 or situacao_competencia2 = 2 or
                                 situacao_competencia3 = 2 or situacao_competencia4 = 2 or
                                 situacao_competencia5 = 2 )) then 0 else 1.1 end
         from correcoes_analise) as tblbase
group by id_corretor_A

GO
/****** Object:  View [dbo].[vw_cotas_quarta_correcao]    Script Date: 22/11/2019 11:44:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER    view [dbo].[vw_cotas_quarta_correcao] as
select us.id as usuario_id, cota1,
       case when cota2 is null then cota1 else cota2 end as cota2,
       case when cota3 is null then (case when cota2 is null then cota1 else cota2 end) else cota3 end as cota3,
       case when cota4 is null then (case when (case when cota3 is null then (case when cota2 is null then cota1 else cota2 end) else cota3 end) is null then cota2 else (case when cota3 is null then (case when cota2 is null then cota1 else cota2 end) else cota3 end) end) else cota4 end as cota4 
 from auth_user us cross apply (
select (
select max_correcoes_dia
  from log_correcoes_corretor lg
 where lg.id = us.id 
   and history_id = (select max(lg2.history_id) from log_correcoes_corretor lg2 join core_parametros par on par.nome = 'COTAS_QUARTA_CORRECAO' and lg2.history_date between json_value(par.valor_padrao, '$.cotas[0].inicio') and json_value(par.valor_padrao, '$.cotas[0].termino') where lg2.id = lg.id)
) as cota1, (
select max_correcoes_dia
  from log_correcoes_corretor lg
 where lg.id = us.id 
   and history_id = (select max(lg2.history_id) from log_correcoes_corretor lg2 join core_parametros par on par.nome = 'COTAS_QUARTA_CORRECAO' and lg2.history_date between json_value(par.valor_padrao, '$.cotas[1].inicio') and json_value(par.valor_padrao, '$.cotas[1].termino') where lg2.id = lg.id)
) as cota2, (
select max_correcoes_dia
  from log_correcoes_corretor lg
 where lg.id = us.id 
   and history_id = (select max(lg2.history_id) from log_correcoes_corretor lg2 join core_parametros par on par.nome = 'COTAS_QUARTA_CORRECAO' and lg2.history_date between json_value(par.valor_padrao, '$.cotas[2].inicio') and json_value(par.valor_padrao, '$.cotas[2].termino') where lg2.id = lg.id)
) as cota3, (
select max_correcoes_dia
  from log_correcoes_corretor lg
 where lg.id = us.id 
   and history_id = (select max(lg2.history_id) from log_correcoes_corretor lg2 join core_parametros par on par.nome = 'COTAS_QUARTA_CORRECAO' and lg2.history_date between json_value(par.valor_padrao, '$.cotas[3].inicio') and json_value(par.valor_padrao, '$.cotas[3].termino') where lg2.id = lg.id)
) as cota4) as cotas

GO
/****** Object:  View [dbo].[vw_descartada_n70]    Script Date: 22/11/2019 11:44:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER      view [dbo].[vw_descartada_n70] as  
select  aud.co_barra_redacao,   
        cor.id_tipo_correcao,  
  descartada = case when (isnull(aud.nota_final  ,0) = isnull(cor.nota_final  ,0) and   
                          isnull(aud.competencia1,0) = isnull(cor.competencia1,0) and  
                          isnull(aud.competencia2,0) = isnull(cor.competencia2,0) and  
                          isnull(aud.competencia3,0) = isnull(cor.competencia3,0) and  
                          isnull(aud.competencia4,0) = isnull(cor.competencia4,0) and  
                          isnull(aud.competencia5,0) = isnull(cor.competencia5,0) and  
                          aud.id_correcao_situacao = cor.id_correcao_situacao) then 0 else 1 end  
  from correcoes_correcao aud with (nolock) join correcoes_correcao cor with (nolock) on (aud.co_barra_redacao = cor.co_barra_redacao and   
                                                                                          aud.id_tipo_correcao = 7 ) 

GO
/****** Object:  View [dbo].[vw_distribiucao_faixa_ouro]    Script Date: 22/11/2019 11:44:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER    view [dbo].[vw_distribiucao_faixa_ouro] as 
    select id_corretor, total_correcoes = correcao, 
           correcoes_ouro_dia = correcaoouro,
           total_correcao_dia = total_dia_correcao,
           total_correcao_anterior = correcao_dia_anterior,
           id_projeto = tab.id_projeto, 
           cota_correcao_dia = dia.correcoes,
           limite_dia = tab.correcao_dia_anterior + dia.correcoes, faixa = tab.correcao_dia_anterior + dia.correcoes - total_dia_correcao
    
    from (
select distinct  id_corretor, correcao = (select count(*) from correcoes_correcao cor with (nolock) where cor.Id_corretor = our.id_corretor  
                      and  cor.id_status = 3 ), 
                      correcaoouro = (select count(*) from correcoes_correcao cor with (nolock) where cor.Id_corretor = our.id_corretor  
                      and  cor.id_status = 3 and id_tipo_correcao = 5 and cast(data_termino as date)=  cast(GETDATE() as date)),
                total_dia_correcao = (select count(*) from correcoes_correcao cor with (nolock) where cor.Id_corretor = our.id_corretor  
                      and  cor.id_status = 3 and cast(data_termino as date)=  cast(GETDATE() as date)),
                 correcao_dia_anterior = (select count(*) from correcoes_correcao cor with (nolock) where cor.Id_corretor = our.id_corretor  
                      and  cor.id_status = 3  and cast(data_termino as date)  <  cast( GETDATE() as date)),
                id_projeto = our.id_projeto
 from correcoes_filaouro our) as tab join VW_CORRECAO_DIA dia on (tab.id_corretor = dia.id and tab.id_projeto = dia.id_projeto)

GO
/****** Object:  View [dbo].[VW_FILAS_DA_REDACAO]    Script Date: 22/11/2019 11:44:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER    VIEW [dbo].[VW_FILAS_DA_REDACAO] AS 							 
select red.id AS REDACAO_ID, fila = 1  , FILA_NOME = 'FILA 1'   , RED.ID_PROJETO from correcoes_redacao red join correcoes_fila1         fil1 on (red.id = fil1.redacao_id AND RED.ID_PROJETO = fil1.ID_PROJETO) UNION 
select red.id AS REDACAO_ID, fila = 2  , FILA_NOME = 'FILA 2'   , RED.ID_PROJETO from correcoes_redacao red join correcoes_fila2         fil2 on (red.id = fil2.redacao_id AND RED.ID_PROJETO = fil2.ID_PROJETO) UNION 
select red.id AS REDACAO_ID, fila = 3  , FILA_NOME = 'FILA 3'   , RED.ID_PROJETO from correcoes_redacao red join correcoes_fila3         fil3 on (red.id = fil3.redacao_id AND RED.ID_PROJETO = fil3.ID_PROJETO) UNION 
select red.id AS REDACAO_ID, fila = 4  , FILA_NOME = 'FILA 4'   , RED.ID_PROJETO from correcoes_redacao red join correcoes_fila4         fil4 on (red.id = fil4.redacao_id AND RED.ID_PROJETO = fil4.ID_PROJETO) UNION 
select red.id AS REDACAO_ID, fila = 7  , FILA_NOME = 'AUDITORIA', RED.ID_PROJETO from correcoes_redacao red join correcoes_filaauditoria fila on (red.id = fila.redacao_id AND RED.ID_PROJETO = fila.ID_PROJETO) UNION 
select red.id AS REDACAO_ID, fila = 10 , FILA_NOME = 'PESSOAL'  , RED.ID_PROJETO from correcoes_redacao red join correcoes_filapessoal   filp on (red.id = filp.redacao_id AND RED.ID_PROJETO = filp.ID_PROJETO) UNION 
select red.id AS REDACAO_ID, fila = 5  , FILA_NOME = 'OURO/MODA', RED.ID_PROJETO from correcoes_redacao red join correcoes_filaouro      filo on (red.id = filo.redacao_id AND RED.ID_PROJETO = filo.ID_PROJETO)

GO
/****** Object:  View [dbo].[vw_hierarquia_completa]    Script Date: 22/11/2019 11:44:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER        view [dbo].[vw_hierarquia_completa] as
select [time].id as time_id, polo.id as polo_id, fgv.id as fgv_id, geral.id as geral_id,
       [time].descricao as time_descricao, polo.descricao as polo_descricao, fgv.descricao as fgv_descricao, geral.descricao as geral_descricao,
       [time].indice as time_indice, polo.indice as polo_indice, fgv.indice as fgv_indice, geral.indice as geral_indice
  from usuarios_hierarquia as [time] with (nolock)
       inner join usuarios_hierarquia as polo with (nolock) on polo.id = [time].id_hierarquia_usuario_pai
       inner join usuarios_hierarquia as fgv with (nolock) on fgv.id = polo.id_hierarquia_usuario_pai
       inner join usuarios_hierarquia as geral with (nolock) on geral.id = fgv.id_hierarquia_usuario_pai

GO
/****** Object:  View [dbo].[vw_ocorrencias_ocorrencia]    Script Date: 22/11/2019 11:44:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER    VIEW [dbo].[vw_ocorrencias_ocorrencia]
AS
SELECT
     dbo.ocorrencias_ocorrencia.id,
     dbo.ocorrencias_ocorrencia.data_solicitacao,
     dbo.ocorrencias_ocorrencia.correcao_id,
     dbo.ocorrencias_tipo.descricao AS tipo_descricao,
     dbo.ocorrencias_categoria.descricao AS categoria_descricao,
     dbo.ocorrencias_situacao.descricao AS situacao_descricao,
     dbo.ocorrencias_status.descricao AS status_descricao,
     dbo.ocorrencias_status.icone AS status_icone,
     dbo.ocorrencias_status.classe AS status_classe,
     dbo.auth_user.last_name
FROM dbo.ocorrencias_ocorrencia
LEFT OUTER JOIN dbo.ocorrencias_situacao
     ON dbo.ocorrencias_ocorrencia.situacao_id = dbo.ocorrencias_situacao.id
INNER JOIN dbo.ocorrencias_status
     ON dbo.ocorrencias_ocorrencia.status_id = dbo.ocorrencias_status.id
LEFT OUTER JOIN dbo.ocorrencias_tipo
     ON dbo.ocorrencias_ocorrencia.tipo_id = dbo.ocorrencias_tipo.id
INNER JOIN dbo.ocorrencias_categoria
     ON dbo.ocorrencias_ocorrencia.categoria_id = dbo.ocorrencias_categoria.id
     AND dbo.ocorrencias_tipo.categoria_id = dbo.ocorrencias_categoria.id
LEFT OUTER JOIN dbo.auth_user
     ON dbo.ocorrencias_ocorrencia.usuario_autor_id = dbo.auth_user.id
     AND dbo.ocorrencias_ocorrencia.usuario_responsavel_id = dbo.auth_user.id
  

GO
/****** Object:  View [dbo].[vw_panorama_geral_ocorrencias]    Script Date: 22/11/2019 11:44:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER    view [dbo].[vw_panorama_geral_ocorrencias] as
select
    supervisor.last_name "supervisor",
    polo_descricao,
    time_descricao,
    polo_id,
    time_id,
    usuarios.time_indice as indice,
    sum(case when 1 = 1 then 1 else 0 end) total,
    sum(case when categoria.id = 2 then 1 else 0 end) ocorrencias_imagem,
    sum(case when categoria.id = 2 and chamado.status_id in (8, 2) then 1 else 0 end) ocorrencias_imagem_respondidas,
    sum(case when categoria.id = 2 and chamado.status_id not in (8, 2) then 1 else 0 end) ocorrencias_imagem_pendentes,
    sum(case when categoria.id = 1 then 1 else 0 end) ocorrencias_pedagogica,
    sum(case when categoria.id = 1 and chamado.status_id not in (8, 2) then 1 else 0 end) ocorrencias_pedagogica_pendentes,
    sum(case when categoria.id = 1 and chamado.status_id in (8, 2) then 1 else 0 end) ocorrencias_pedagogica_respondidas,
    sum(case when chamado.status_id not in (8, 2) and user_groups.group_id = 25 then 1 else 0 end) ocorrencias_pendentes_supervisor,
    sum(case when chamado.status_id not in (8, 2) and user_groups.group_id = 30 then 1 else 0 end) ocorrencias_pendentes_coord_polo,
    sum(case when chamado.status_id not in (8, 2) and user_groups.group_id = 29 then 1 else 0 end) ocorrencias_pendentes_coord_fgv,
    sum(case when chamado.status_id not in (8, 2) and chamado.responsavel_atual is null then 1 else 0 end) ocorrencias_pendentes_time_tecnico,
    CAST(chamado.criado_em as date) [data]
    from chamados_chamado chamado
        join chamados_tipo tipo
            on tipo.id = chamado.tipo_id
                join chamados_categoria categoria
                    on categoria.id = tipo.categoria_id
                        join auth_user [user]
                            on [user].id = chamado.responsavel_atual
                                join auth_user_groups user_groups
                                    on  user_groups.user_id = [user].id
                                        join vw_usuarios usuarios
                                            on usuarios.usuario_id = chamado.autor_id
                                                join usuarios_hierarquia hierarquia
                                                    on hierarquia.id = usuarios.time_id
                                                        join auth_user [supervisor]
                                                            on supervisor.id = hierarquia.id_usuario_responsavel
    group by CAST(chamado.criado_em as date), polo_descricao, time_descricao, polo_id, time_id, usuarios.time_indice, supervisor.last_name

GO
/****** Object:  View [dbo].[vw_prova_analise_cordgeral]    Script Date: 22/11/2019 11:44:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER    VIEW [dbo].[vw_prova_analise_cordgeral]
AS
SELECT DISTINCT 
                         r.id AS mascara, r.link_imagem_recortada, CASE WHEN r.link_imagem_recortada LIKE 'result/1810401_G%' THEN 'CESGRANRIO' WHEN r.link_imagem_recortada LIKE 'result/1810401_F%' THEN 'FGV' END AS empresa, 
                         r.co_inscricao, r.co_barra_redacao AS codigo_barra_redacao
FROM            dbo.ocorrencias_ocorrencia AS oc INNER JOIN
                         dbo.correcoes_correcao AS cc ON cc.id = oc.correcao_id INNER JOIN
                         dbo.correcoes_redacao AS r ON r.co_barra_redacao = cc.co_barra_redacao
WHERE        (oc.status_id = 11)

GO
/****** Object:  View [dbo].[vw_redacao_auditoria_nota_1000]    Script Date: 22/11/2019 11:44:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER    view [dbo].[vw_redacao_auditoria_nota_1000] as
SELECT distinct RED.ID AS REDACAO_ID, RED.ID_PROJETO
FROM correcoes_redacao RED JOIN CORRECOES_CORRECAO COR1 ON (RED.ID = COR1.REDACAO_ID AND RED.ID_PROJETO = COR1.ID_PROJETO AND COR1.ID_TIPO_CORRECAO = 1)
                           JOIN CORRECOES_CORRECAO COR2 ON (RED.ID = COR2.REDACAO_ID AND RED.ID_PROJETO = COR2.ID_PROJETO AND COR2.ID_TIPO_CORRECAO = 2)
                      left JOIN CORRECOES_CORRECAO COR3 ON (RED.ID = COR3.REDACAO_ID AND RED.ID_PROJETO = COR3.ID_PROJETO AND COR3.ID_TIPO_CORRECAO = 3)
                      left JOIN CORRECOES_CORRECAO COR4 ON (RED.ID = COR4.REDACAO_ID AND RED.ID_PROJETO = COR4.ID_PROJETO AND COR4.ID_TIPO_CORRECAO = 4)
WHERE (COR1.nota_final = 1000 and COR2.nota_final = 1000) OR 
      (COR1.nota_final = 1000 AND COR3.nota_final = 1000) OR 
	  (COR2.NOTA_FINAL = 1000 AND COR3.nota_final = 1000) OR 
	  (COR4.nota_final = 1000)
      
GO
/****** Object:  View [dbo].[vw_redacao_equidistante]    Script Date: 22/11/2019 11:44:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  View [dbo].[vw_redacao_equidistante]    Script Date: 19/11/2019 15:37:54 ******/

CREATE OR ALTER     view [dbo].[vw_redacao_equidistante] as 
select cor3.redacao_id, 
       cor3.id_projeto, 
       cor3.nota_final as nota_final3, 
       cor2.nota_final as nota_final2, 
	   cor1.nota_final as nota_final1 
  from correcoes_correcao cor3 join correcoes_correcao cor2 on (cor3.redacao_id = cor2.redacao_id and 
                                                                cor3.id_projeto = cor2.id_projeto and 
																cor3.id_tipo_correcao = 3 and
																cor2.id_tipo_correcao = 2)
                               join correcoes_correcao cor1 on (cor3.redacao_id = cor1.redacao_id and 
							                                    cor3.id_projeto = cor1.id_projeto and
																cor1.id_tipo_correcao = 1)
where abs(cor1.nota_final - cor3.nota_final) = abs(cor2.nota_final - cor3.nota_final) and 
      cor3.id_correcao_situacao = 1 and 
	  cor2.id_correcao_situacao = 1 and 
	  cor1.id_correcao_situacao = 1 

GO
/****** Object:  View [dbo].[vw_redacoes_pendentes]    Script Date: 22/11/2019 11:44:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER      view [dbo].[vw_redacoes_pendentes] as
select co_barra_redacao from (
select co_barra_redacao from correcoes_fila1 union
select co_barra_redacao from correcoes_fila2 union
select co_barra_redacao from correcoes_fila3 union
select co_barra_redacao from correcoes_fila4 union
select co_barra_redacao from correcoes_filaauditoria union
select co_barra_redacao from correcoes_correcao where data_termino is null and id_tipo_correcao in (1,2,3,4,7)
) tab

GO
/****** Object:  View [dbo].[vw_relatorio_acompanhamento_auditoria]    Script Date: 22/11/2019 11:44:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER      view [dbo].[vw_relatorio_acompanhamento_auditoria] as
select usuario_id, nome as auditor, hierarquia_id, '.1.3.' as indice, data,
       isnull(nota_maxima, 0) as nota_maxima,
       isnull(pd, 0) as pd, isnull(ddh, 0) as ddh, isnull(situacao_esdruxula, 0) as situacao_esdruxula, 
       isnull(nota_maxima, 0) + isnull(pd, 0) + isnull(ddh, 0) + isnull(situacao_esdruxula, 0) as total
  from (
    select usuario_id, nome, hierarquia_id, indice, data, [1] as nota_maxima, [2] as pd, [3] as ddh, [4] as situacao_esdruxula from (
        select a.usuario_id, a.nome, d.id as hierarquia_id, d.indice, convert(date, b.data_termino) as data, b.tipo_auditoria_id, count(*) as correcoes
        from usuarios_pessoa a, correcoes_correcao b, usuarios_hierarquia_usuarios c, usuarios_hierarquia d
        where b.id_corretor = a.usuario_id
    and c.user_id = a.usuario_id
    and c.hierarquia_id = d.id
        and b.id_status = 3
        and b.id_tipo_correcao = 7
        group by a.usuario_id, a.nome, d.id, d.indice, convert(date, b.data_termino), b.tipo_auditoria_id
    ) z pivot (sum(correcoes) for tipo_auditoria_id in ([1], [2], [3], [4]) ) z
) w

GO
/****** Object:  View [dbo].[vw_relatorio_acompanhamento_quarta_correcao]    Script Date: 22/11/2019 11:44:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER      view [dbo].[vw_relatorio_acompanhamento_quarta_correcao] as
select DISTINCT
    HIE.usuario_id,
    HIE.nome,
    HIE.POLO_ID,
    HIE.indice,
    HIE.POLO_DESCRICAO,
    HIE.time_id,
    HIE.time_descricao,
    DIS_cota_1 = (select cota1 from vw_cotas_quarta_correcao where usuario_id = HIE.usuario_id),
    COR_COTA_1 = (SELECT COUNT(*)
                    FROM CORRECOES_CORRECAO CORX join core_parametros par on par.nome = 'COTAS_QUARTA_CORRECAO'
       WHERE CORX.ID_STATUS = 3 AND
             CORX.id_tipo_correcao = 4 AND
       CORX.id_corretor = COR.id_corretor AND
       CAST(CORX.data_termino AS DATE) BETWEEN json_value(par.valor_padrao, '$.cotas[0].inicio') AND json_value(par.valor_padrao, '$.cotas[0].termino')),
    DIS_cota_2 = (select cota2 from vw_cotas_quarta_correcao where usuario_id = HIE.usuario_id),
    COR_COTA_2 = (SELECT COUNT(*)
                    FROM CORRECOES_CORRECAO CORX join core_parametros par on par.nome = 'COTAS_QUARTA_CORRECAO'
       WHERE CORX.ID_STATUS = 3 AND
             CORX.id_tipo_correcao = 4 AND
       CORX.id_corretor = COR.id_corretor AND
       CAST(CORX.data_termino AS DATE) BETWEEN json_value(par.valor_padrao, '$.cotas[1].inicio') AND json_value(par.valor_padrao, '$.cotas[1].termino')),

    DIS_cota_3 = (select cota3 from vw_cotas_quarta_correcao where usuario_id = HIE.usuario_id),
    COR_COTA_3 = (SELECT COUNT(*)
                    FROM CORRECOES_CORRECAO CORX join core_parametros par on par.nome = 'COTAS_QUARTA_CORRECAO'
       WHERE CORX.ID_STATUS = 3 AND
             CORX.id_tipo_correcao = 4 AND
       CORX.id_corretor = COR.id_corretor AND
       CAST(CORX.data_termino AS DATE) BETWEEN json_value(par.valor_padrao, '$.cotas[2].inicio') AND json_value(par.valor_padrao, '$.cotas[2].termino')),

    DIS_cota_4 = (select cota4 from vw_cotas_quarta_correcao where usuario_id = HIE.usuario_id),
    COR_COTA_4 = (SELECT COUNT(*)
                    FROM CORRECOES_CORRECAO CORX join core_parametros par on par.nome = 'COTAS_QUARTA_CORRECAO'
       WHERE CORX.ID_STATUS = 3 AND
             CORX.id_tipo_correcao = 4 AND
       CORX.id_corretor = COR.id_corretor AND
       CAST(CORX.data_termino AS DATE) >= json_value(par.valor_padrao, '$.cotas[3].inicio'))
  from  vw_usuario_hierarquia hie  left join correcoes_correcao cor on (cor.id_corretor = hie.usuario_id and
                                                                        cor.id_tipo_correcao = 4 and
                                                                        cor.id_status = 3)
where HIE.PERFIL = 'SUPERVISOR'

GO
/****** Object:  View [dbo].[vw_relatorio_aproveitamento_notas_geral]    Script Date: 22/11/2019 11:44:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER      view [dbo].[vw_relatorio_aproveitamento_notas_geral] as
select 1 as id, hierarquia_id, descricao, indice, data,
       sum(redacoes_corrigidas) as redacoes_corrigidas, sum(notas_aproveitadas) as notas_aproveitadas, sum(nao_discrepou) as nao_discrepou, sum(discrepou) as discrepou
  from (
select polo_id as hierarquia_id, polo_descricao as descricao, indice, data, sum(redacoes_corrigidas) as redacoes_corrigidas, notas_aproveitadas, sum(nao_discrepou) as nao_discrepou, sum(discrepou) as discrepou from (
  select e.polo_id, e.polo_descricao, e.polo_indice as indice, convert(date, d.data_termino) as data, count(*) as redacoes_corrigidas,
        sum(convert(int, isnull(a.aproveitamento, 1))) as notas_aproveitadas, sum((case when a.conclusao_analise in (0,1,2) then 1 else 0 end)) as nao_discrepou, sum((case when a.conclusao_analise in (3,4,5) then 1 else 0 end)) as discrepou
    from correcoes_analise a, usuarios_hierarquia_usuarios b, usuarios_hierarquia c, correcoes_correcao d, vw_usuario_hierarquia_completa e
  where a.id_corretor_A = b.user_id
    and b.hierarquia_id = c.id
    and a.id_tipo_correcao_B = 3
    and d.id = a.id_correcao_A
    and e.usuario_id = b.user_id
  group by e.polo_id, e.polo_descricao, e.polo_indice, convert(date, d.data_termino)
) z
group by polo_id, polo_descricao, indice, data, notas_aproveitadas
union all
select polo_id as hierarquia_id, polo_descricao as descricao, indice, data, sum(redacoes_corrigidas) as redacoes_corrigidas, notas_aproveitadas, sum(nao_discrepou) as nao_discrepou, sum(discrepou) as discrepou from (
  select e.polo_id, e.polo_descricao, e.polo_indice as indice, convert(date, d.data_termino) as data, count(*) as redacoes_corrigidas,
        sum(convert(int, isnull(a.aproveitamento, 1))) as notas_aproveitadas, sum((case when a.conclusao_analise in (0,1,2) then 1 else 0 end)) as nao_discrepou, sum((case when a.conclusao_analise in (3,4,5) then 1 else 0 end)) as discrepou
    from correcoes_analise a, usuarios_hierarquia_usuarios b, usuarios_hierarquia c, correcoes_correcao d, vw_usuario_hierarquia_completa e
  where a.id_corretor_B = b.user_id
    and b.hierarquia_id = c.id
    and a.id_tipo_correcao_B = 3
    and d.id = a.id_correcao_B
    and e.usuario_id = b.user_id
  group by e.polo_id, e.polo_descricao, e.polo_indice, convert(date, d.data_termino)
) z
group by polo_id, polo_descricao, indice, data, notas_aproveitadas
) w
group by hierarquia_id, descricao, indice, data

GO
/****** Object:  View [dbo].[vw_relatorio_aproveitamento_notas_por_polo]    Script Date: 22/11/2019 11:44:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER      view [dbo].[vw_relatorio_aproveitamento_notas_por_polo] as
select polo_id, polo_descricao, hierarquia_id, descricao, id_hierarquia_usuario_pai, id_tipo_hierarquia_usuario, indice, data,
       sum(redacoes_corrigidas) as redacoes_corrigidas,
       sum(notas_aproveitadas) as notas_aproveitadas,
       sum(notas_nao_aproveitadas) as notas_nao_aproveitadas,
       sum(nao_discrepou) as nao_discrepou,
       sum(discrepou) as discrepou
 from (

select a.polo_id, a.polo_descricao, time_id as hierarquia_id, time_descricao as descricao, time_indice as indice, f.id_hierarquia_usuario_pai, f.id_tipo_hierarquia_usuario, convert(date, data_termino) as data,
       count(*) as redacoes_corrigidas,
       sum(case when isnull(d.aproveitamento, 0) = 1 then 1 else 0 end) as notas_aproveitadas,
       sum(case when d.aproveitamento = 0 and d.aproveitamento is not null then 1 else 0 end) as notas_nao_aproveitadas,
       sum(convert(int, isnull(e.discrepou, 0))) as discrepou,
       count(*) - sum(convert(int, isnull(e.discrepou, 0))) as nao_discrepou
  from vw_usuario_hierarquia_completa a
       inner join correcoes_correcao b on a.usuario_id = b.id_corretor and b.id_tipo_correcao = 1
       inner join correcoes_analise c on c.id_correcao_a = b.id
       inner join usuarios_hierarquia f on f.id = a.time_id
       left outer join correcoes_analise d on d.id_correcao_a = b.id and d.id_tipo_correcao_b = 3   /*verificar aproveitamento e discrepância de comparação com terceiras*/
       left outer join correcoes_conclusao_analise e on e.id = c.conclusao_analise
 where b.data_termino is not null
group by a.polo_id, a.polo_descricao, a.polo_indice, time_id, time_descricao, time_indice, f.id_hierarquia_usuario_pai, f.id_tipo_hierarquia_usuario, convert(date, data_termino)
union
select a.polo_id, a.polo_descricao, time_id as hierarquia_id, time_descricao as descricao, time_indice as indice, f.id_hierarquia_usuario_pai, f.id_tipo_hierarquia_usuario, convert(date, data_termino) as data,
       count(*) as redacoes_corrigidas,
       sum(case when isnull(d.aproveitamento, 0) = 1 then 1 else 0 end) as notas_aproveitadas,
       sum(case when d.aproveitamento = 0 and d.aproveitamento is not null then 1 else 0 end) as notas_nao_aproveitadas,
       sum(convert(int, isnull(e.discrepou, 0))) as discrepou,
       count(*) - sum(convert(int, isnull(e.discrepou, 0))) as nao_discrepou
  from vw_usuario_hierarquia_completa a
       inner join correcoes_correcao b on a.usuario_id = b.id_corretor and b.id_tipo_correcao = 2
       inner join correcoes_analise c on c.id_correcao_b = b.id
       inner join usuarios_hierarquia f on f.id = a.time_id
       left outer join correcoes_analise d on d.id_correcao_a = b.id and d.id_tipo_correcao_b = 3   /*verificar aproveitamento e discrepância de comparação com terceiras*/
       left outer join correcoes_conclusao_analise e on e.id = c.conclusao_analise
 where b.data_termino is not null
group by a.polo_id, a.polo_descricao, a.polo_indice, time_id, time_descricao, time_indice, f.id_hierarquia_usuario_pai, f.id_tipo_hierarquia_usuario, convert(date, data_termino)
) z
group by polo_id, polo_descricao, hierarquia_id, descricao, id_hierarquia_usuario_pai, id_tipo_hierarquia_usuario, indice, data

GO
/****** Object:  View [dbo].[vw_relatorio_distribuicao_notas_competencia_time]    Script Date: 22/11/2019 11:44:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER       view [dbo].[vw_relatorio_distribuicao_notas_competencia_time] as
select polo.id as polo_id, polo.descricao as polo_descricao, polo.indice as polo_indice, time.id as time_id, time.descricao as time_descricao, time.indice as indice, p.usuario_id, p.nome,
       sum(case when competencia1 = 0 then 1 else 0 end) as nr_competencia1_0,
       sum(case when competencia1 = 1 then 1 else 0 end) as nr_competencia1_1,
       sum(case when competencia1 = 2 then 1 else 0 end) as nr_competencia1_2,
       sum(case when competencia1 = 3 then 1 else 0 end) as nr_competencia1_3,
       sum(case when competencia1 = 4 then 1 else 0 end) as nr_competencia1_4,
       sum(case when competencia1 = 5 then 1 else 0 end) as nr_competencia1_5,
       sum(case when competencia2 = 0 then 1 else 0 end) as nr_competencia2_0,
       sum(case when competencia2 = 1 then 1 else 0 end) as nr_competencia2_1,
       sum(case when competencia2 = 2 then 1 else 0 end) as nr_competencia2_2,
       sum(case when competencia2 = 3 then 1 else 0 end) as nr_competencia2_3,
       sum(case when competencia2 = 4 then 1 else 0 end) as nr_competencia2_4,
       sum(case when competencia2 = 5 then 1 else 0 end) as nr_competencia2_5,
       sum(case when competencia3 = 0 then 1 else 0 end) as nr_competencia3_0,
       sum(case when competencia3 = 1 then 1 else 0 end) as nr_competencia3_1,
       sum(case when competencia3 = 2 then 1 else 0 end) as nr_competencia3_2,
       sum(case when competencia3 = 3 then 1 else 0 end) as nr_competencia3_3,
       sum(case when competencia3 = 4 then 1 else 0 end) as nr_competencia3_4,
       sum(case when competencia3 = 5 then 1 else 0 end) as nr_competencia3_5,
       sum(case when competencia4 = 0 then 1 else 0 end) as nr_competencia4_0,
       sum(case when competencia4 = 1 then 1 else 0 end) as nr_competencia4_1,
       sum(case when competencia4 = 2 then 1 else 0 end) as nr_competencia4_2,
       sum(case when competencia4 = 3 then 1 else 0 end) as nr_competencia4_3,
       sum(case when competencia4 = 4 then 1 else 0 end) as nr_competencia4_4,
       sum(case when competencia4 = 5 then 1 else 0 end) as nr_competencia4_5,
       sum(case when competencia5 = -1 then 1 else 0 end) as nr_competencia5_ddh,
       sum(case when competencia5 = 0 then 1 else 0 end) as nr_competencia5_0,
       sum(case when competencia5 = 1 then 1 else 0 end) as nr_competencia5_1,
       sum(case when competencia5 = 2 then 1 else 0 end) as nr_competencia5_2,
       sum(case when competencia5 = 3 then 1 else 0 end) as nr_competencia5_3,
       sum(case when competencia5 = 4 then 1 else 0 end) as nr_competencia5_4,
       sum(case when competencia5 = 5 then 1 else 0 end) as nr_competencia5_5,
       convert(date, a.data_termino) as data,
       count_big(a.id) as nr_corrigidas,
       count_big(case when a.id_correcao_situacao = 1 then 1 else null end) as nr_com_nota_normal
  from dbo.correcoes_correcao a
       right join dbo.usuarios_pessoa p on p.usuario_id = a.id_corretor and a.id_status = 3
       inner join dbo.usuarios_hierarquia_usuarios b on b.user_id = p.usuario_id
       inner join dbo.usuarios_hierarquia as [time] on [time].id = b.hierarquia_id
       inner join dbo.usuarios_hierarquia as polo on polo.id = [time].id_hierarquia_usuario_pai
       inner join dbo.usuarios_hierarquia as fgv on fgv.id = polo.id_hierarquia_usuario_pai
       inner join dbo.usuarios_hierarquia as geral on geral.id = fgv.id_hierarquia_usuario_pai
group by polo.id, polo.descricao, polo.indice, time.id, time.descricao, time.indice, p.usuario_id, p.nome, convert(date, a.data_termino)

GO
/****** Object:  View [dbo].[vw_relatorio_distribuicao_notas_geral]    Script Date: 22/11/2019 11:44:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER      view [dbo].[vw_relatorio_distribuicao_notas_geral] as
select ROW_NUMBER() over (order by hierarquia_id) as id, hierarquia_id, descricao, indice, data, nr_total_avaliadores, nr_corrigidas, nr_com_nota_normal,
       (nr_competencia1_0 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia1_0,
       (nr_competencia1_1 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia1_1,
       (nr_competencia1_2 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia1_2,
       (nr_competencia1_3 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia1_3,
       (nr_competencia1_4 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia1_4,
       (nr_competencia1_5 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia1_5,
       (nr_competencia2_0 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia2_0,
       (nr_competencia2_1 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia2_1,
       (nr_competencia2_2 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia2_2,
       (nr_competencia2_3 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia2_3,
       (nr_competencia2_4 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia2_4,
       (nr_competencia2_5 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia2_5,
       (nr_competencia3_0 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia3_0,
       (nr_competencia3_1 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia3_1,
       (nr_competencia3_2 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia3_2,
       (nr_competencia3_3 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia3_3,
       (nr_competencia3_4 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia3_4,
       (nr_competencia3_5 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia3_5,
       (nr_competencia4_0 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia4_0,
       (nr_competencia4_1 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia4_1,
       (nr_competencia4_2 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia4_2,
       (nr_competencia4_3 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia4_3,
       (nr_competencia4_4 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia4_4,
       (nr_competencia4_5 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia4_5,
       (nr_competencia5_ddh * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia5_ddh,
       (nr_competencia5_0 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia5_0,
       (nr_competencia5_1 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia5_1,
       (nr_competencia5_2 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia5_2,
       (nr_competencia5_3 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia5_3,
       (nr_competencia5_4 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia5_4,
       (nr_competencia5_5 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia5_5
        from (
select c.polo_id as hierarquia_id, c.polo_descricao as descricao, c.polo_indice as indice,
       sum(case when competencia1 = 0 then 1 else 0 end) as nr_competencia1_0,
       sum(case when competencia1 = 1 then 1 else 0 end) as nr_competencia1_1,
       sum(case when competencia1 = 2 then 1 else 0 end) as nr_competencia1_2,
       sum(case when competencia1 = 3 then 1 else 0 end) as nr_competencia1_3,
       sum(case when competencia1 = 4 then 1 else 0 end) as nr_competencia1_4,
       sum(case when competencia1 = 5 then 1 else 0 end) as nr_competencia1_5,
       sum(case when competencia2 = 0 then 1 else 0 end) as nr_competencia2_0,
       sum(case when competencia2 = 1 then 1 else 0 end) as nr_competencia2_1,
       sum(case when competencia2 = 2 then 1 else 0 end) as nr_competencia2_2,
       sum(case when competencia2 = 3 then 1 else 0 end) as nr_competencia2_3,
       sum(case when competencia2 = 4 then 1 else 0 end) as nr_competencia2_4,
       sum(case when competencia2 = 5 then 1 else 0 end) as nr_competencia2_5,
       sum(case when competencia3 = 0 then 1 else 0 end) as nr_competencia3_0,
       sum(case when competencia3 = 1 then 1 else 0 end) as nr_competencia3_1,
       sum(case when competencia3 = 2 then 1 else 0 end) as nr_competencia3_2,
       sum(case when competencia3 = 3 then 1 else 0 end) as nr_competencia3_3,
       sum(case when competencia3 = 4 then 1 else 0 end) as nr_competencia3_4,
       sum(case when competencia3 = 5 then 1 else 0 end) as nr_competencia3_5,
       sum(case when competencia4 = 0 then 1 else 0 end) as nr_competencia4_0,
       sum(case when competencia4 = 1 then 1 else 0 end) as nr_competencia4_1,
       sum(case when competencia4 = 2 then 1 else 0 end) as nr_competencia4_2,
       sum(case when competencia4 = 3 then 1 else 0 end) as nr_competencia4_3,
       sum(case when competencia4 = 4 then 1 else 0 end) as nr_competencia4_4,
       sum(case when competencia4 = 5 then 1 else 0 end) as nr_competencia4_5,
       sum(case when competencia5 = -1 then 1 else 0 end) as nr_competencia5_ddh,
       sum(case when competencia5 = 0 then 1 else 0 end) as nr_competencia5_0,
       sum(case when competencia5 = 1 then 1 else 0 end) as nr_competencia5_1,
       sum(case when competencia5 = 2 then 1 else 0 end) as nr_competencia5_2,
       sum(case when competencia5 = 3 then 1 else 0 end) as nr_competencia5_3,
       sum(case when competencia5 = 4 then 1 else 0 end) as nr_competencia5_4,
       sum(case when competencia5 = 5 then 1 else 0 end) as nr_competencia5_5,
       convert(date, a.data_termino) as data, count(distinct a.id_corretor) as nr_total_avaliadores, count(*) as nr_corrigidas, count(case when a.id_correcao_situacao = 1 then 1 else null end) as nr_com_nota_normal
  from correcoes_correcao a with (nolock)
       inner join vw_usuario_hierarquia_completa c with (nolock) on c.usuario_id = a.id_corretor
 where a.id_status = 3
group by c.polo_id, c.polo_descricao, c.polo_indice, convert(date, a.data_termino)
) z

GO
/****** Object:  View [dbo].[vw_relatorio_distribuicao_notas_polo]    Script Date: 22/11/2019 11:44:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER      view [dbo].[vw_relatorio_distribuicao_notas_polo] as
SELECT  ROW_NUMBER() over (order by hierarquia_id) as id,
    q.polo_id,
    q.polo_descricao,
    q.polo_indice,
    q.time_id as hierarquia_id,
    q.time_descricao as descricao,
    q.time_indice as indice,
    u.data,
    u.nr_total_avaliadores,
    u.nr_corrigidas,
    u.nr_com_nota_normal,
    ISNULL(u.competencia1_0, 0) as competencia1_0,
    ISNULL(u.competencia1_1, 0) as competencia1_1,
    ISNULL(u.competencia1_2, 0) as competencia1_2,
    ISNULL(u.competencia1_3, 0) as competencia1_3,
    ISNULL(u.competencia1_4, 0) as competencia1_4,
    ISNULL(u.competencia1_5, 0) as competencia1_5,
    ISNULL(u.competencia2_0, 0) as competencia2_0,
    ISNULL(u.competencia2_1, 0) as competencia2_1,
    ISNULL(u.competencia2_2, 0) as competencia2_2,
    ISNULL(u.competencia2_3, 0) as competencia2_3,
    ISNULL(u.competencia2_4, 0) as competencia2_4,
    ISNULL(u.competencia2_5, 0) as competencia2_5,
    ISNULL(u.competencia3_0, 0) as competencia3_0,
    ISNULL(u.competencia3_1, 0) as competencia3_1,
    ISNULL(u.competencia3_2, 0) as competencia3_2,
    ISNULL(u.competencia3_3, 0) as competencia3_3,
    ISNULL(u.competencia3_4, 0) as competencia3_4,
    ISNULL(u.competencia3_5, 0) as competencia3_5,
    ISNULL(u.competencia4_0, 0) as competencia4_0,
    ISNULL(u.competencia4_1, 0) as competencia4_1,
    ISNULL(u.competencia4_2, 0) as competencia4_2,
    ISNULL(u.competencia4_3, 0) as competencia4_3,
    ISNULL(u.competencia4_4, 0) as competencia4_4,
    ISNULL(u.competencia4_5, 0) as competencia4_5,
    ISNULL(u.competencia5_ddh, 0) as competencia5_ddh,
    ISNULL(u.competencia5_0, 0) as competencia5_0,
    ISNULL(u.competencia5_1, 0) as competencia5_1,
    ISNULL(u.competencia5_2, 0) as competencia5_2,
    ISNULL(u.competencia5_3, 0) as competencia5_3,
    ISNULL(u.competencia5_4, 0) as competencia5_4,
    ISNULL(u.competencia5_5, 0) as competencia5_5

FROM vw_hierarquia_completa q LEFT OUTER JOIN (
select polo_id, polo_descricao, polo_indice, hierarquia_id, descricao, indice, data, nr_total_avaliadores, nr_corrigidas, nr_com_nota_normal,
       (nr_competencia1_0 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia1_0,
       (nr_competencia1_1 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia1_1,
       (nr_competencia1_2 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia1_2,
       (nr_competencia1_3 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia1_3,
       (nr_competencia1_4 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia1_4,
       (nr_competencia1_5 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia1_5,
       (nr_competencia2_0 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia2_0,
       (nr_competencia2_1 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia2_1,
       (nr_competencia2_2 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia2_2,
       (nr_competencia2_3 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia2_3,
       (nr_competencia2_4 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia2_4,
       (nr_competencia2_5 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia2_5,
       (nr_competencia3_0 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia3_0,
       (nr_competencia3_1 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia3_1,
       (nr_competencia3_2 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia3_2,
       (nr_competencia3_3 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia3_3,
       (nr_competencia3_4 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia3_4,
       (nr_competencia3_5 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia3_5,
       (nr_competencia4_0 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia4_0,
       (nr_competencia4_1 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia4_1,
       (nr_competencia4_2 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia4_2,
       (nr_competencia4_3 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia4_3,
       (nr_competencia4_4 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia4_4,
       (nr_competencia4_5 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia4_5,
       (nr_competencia5_ddh * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia5_ddh,
       (nr_competencia5_0 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia5_0,
       (nr_competencia5_1 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia5_1,
       (nr_competencia5_2 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia5_2,
       (nr_competencia5_3 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia5_3,
       (nr_competencia5_4 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia5_4,
       (nr_competencia5_5 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia5_5
        from (
select c.polo_id, c.polo_descricao, c.polo_indice, c.time_id as hierarquia_id, c.time_descricao as descricao, c.time_indice as indice,
       sum(case when competencia1 = 0 then 1 else 0 end) as nr_competencia1_0,
       sum(case when competencia1 = 1 then 1 else 0 end) as nr_competencia1_1,
       sum(case when competencia1 = 2 then 1 else 0 end) as nr_competencia1_2,
       sum(case when competencia1 = 3 then 1 else 0 end) as nr_competencia1_3,
       sum(case when competencia1 = 4 then 1 else 0 end) as nr_competencia1_4,
       sum(case when competencia1 = 5 then 1 else 0 end) as nr_competencia1_5,
       sum(case when competencia2 = 0 then 1 else 0 end) as nr_competencia2_0,
       sum(case when competencia2 = 1 then 1 else 0 end) as nr_competencia2_1,
       sum(case when competencia2 = 2 then 1 else 0 end) as nr_competencia2_2,
       sum(case when competencia2 = 3 then 1 else 0 end) as nr_competencia2_3,
       sum(case when competencia2 = 4 then 1 else 0 end) as nr_competencia2_4,
       sum(case when competencia2 = 5 then 1 else 0 end) as nr_competencia2_5,
       sum(case when competencia3 = 0 then 1 else 0 end) as nr_competencia3_0,
       sum(case when competencia3 = 1 then 1 else 0 end) as nr_competencia3_1,
       sum(case when competencia3 = 2 then 1 else 0 end) as nr_competencia3_2,
       sum(case when competencia3 = 3 then 1 else 0 end) as nr_competencia3_3,
       sum(case when competencia3 = 4 then 1 else 0 end) as nr_competencia3_4,
       sum(case when competencia3 = 5 then 1 else 0 end) as nr_competencia3_5,
       sum(case when competencia4 = 0 then 1 else 0 end) as nr_competencia4_0,
       sum(case when competencia4 = 1 then 1 else 0 end) as nr_competencia4_1,
       sum(case when competencia4 = 2 then 1 else 0 end) as nr_competencia4_2,
       sum(case when competencia4 = 3 then 1 else 0 end) as nr_competencia4_3,
       sum(case when competencia4 = 4 then 1 else 0 end) as nr_competencia4_4,
       sum(case when competencia4 = 5 then 1 else 0 end) as nr_competencia4_5,
       sum(case when competencia5 = -1 then 1 else 0 end) as nr_competencia5_ddh,
       sum(case when competencia5 = 0 then 1 else 0 end) as nr_competencia5_0,
       sum(case when competencia5 = 1 then 1 else 0 end) as nr_competencia5_1,
       sum(case when competencia5 = 2 then 1 else 0 end) as nr_competencia5_2,
       sum(case when competencia5 = 3 then 1 else 0 end) as nr_competencia5_3,
       sum(case when competencia5 = 4 then 1 else 0 end) as nr_competencia5_4,
       sum(case when competencia5 = 5 then 1 else 0 end) as nr_competencia5_5,
       convert(date, a.data_termino) as data, count(distinct a.id_corretor) as nr_total_avaliadores, count(*) as nr_corrigidas, count(case when a.id_correcao_situacao = 1 then 1 else null end) as nr_com_nota_normal
  from correcoes_correcao a with (nolock)
       inner join vw_usuario_hierarquia_completa c with (nolock) on c.usuario_id = a.id_corretor
 where a.id_status = 3
group by c.polo_id, c.polo_descricao, c.polo_indice, c.time_id, c.time_descricao, c.time_indice, convert(date, a.data_termino)
) z) u on q.time_id = u.hierarquia_id

GO
/****** Object:  View [dbo].[vw_relatorio_distribuicao_notas_situacao_geral]    Script Date: 22/11/2019 11:44:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER      view [dbo].[vw_relatorio_distribuicao_notas_situacao_geral] as
select  ROW_NUMBER() over (order by hierarquia_id) as id, *,
       (nr_nm + nr_fea + nr_copia + nr_ft + nr_natt + nr_pd) as nr_corrigidas,
       (nr_fea + nr_copia + nr_ft + nr_natt + nr_pd) as nr_situacoes from (
select polo_id as hierarquia_id, polo_descricao as descricao, polo_indice as indice, data,
       isnull([1], 0) as nr_nm, isnull([2], 0) as nr_fea, isnull([3], 0) as nr_copia, isnull([6], 0) as nr_ft, isnull([7], 0) as nr_natt, isnull([9], 0) as nr_pd from (
select c.polo_id, c.polo_descricao, c.polo_indice, a.id_correcao_situacao, convert(date, a.data_termino) as data,
       count(*) as nr_corrigidas
  from correcoes_correcao a
       left outer join correcoes_situacao b on a.id_correcao_situacao = b.id
       inner join vw_usuario_hierarquia_completa c on c.usuario_id = a.id_corretor
 where a.id_status = 3
group by c.polo_id, c.polo_descricao, c.polo_indice, a.id_correcao_situacao, convert(date, a.data_termino)
) z pivot (sum(nr_corrigidas) for id_correcao_situacao in ([1], [2], [3], [6], [7], [9])) z
) y

GO
/****** Object:  View [dbo].[vw_relatorio_distribuicao_notas_situacao_polo]    Script Date: 22/11/2019 11:44:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER      VIEW [dbo].[vw_relatorio_distribuicao_notas_situacao_polo]
AS
SELECT ROW_NUMBER()
    OVER (
    ORDER BY
        hierarquia_id) AS id,
        q.polo_id,
        q.polo_descricao,
        q.time_id as hierarquia_id,
        q.time_descricao as descricao,
        q.time_indice as indice,
        u.data,
        ISNULL(u.nr_nm, 0) AS nr_nm,
        ISNULL(u.nr_fea, 0) AS nr_fea,
        ISNULL(u.nr_copia, 0) AS nr_copia,
        ISNULL(u.nr_ft, 0) AS nr_ft,
        ISNULL(u.nr_natt, 0) AS nr_natt,
        ISNULL(u.nr_pd, 0) AS nr_pd,
        ISNULL(u.nr_corrigidas,0) as nr_corrigidas,
        ISNULL(u.nr_situacoes, 0) as nr_situacoes
        FROM vw_hierarquia_completa q LEFT OUTER JOIN(
SELECT
    *, (nr_nm + nr_fea + nr_copia + nr_ft + nr_natt + nr_pd) AS nr_corrigidas, (nr_fea + nr_copia + nr_ft + nr_natt + nr_pd) AS nr_situacoes
FROM (
    SELECT
        polo_id,
        polo_descricao,
        time_id AS hierarquia_id,
        time_descricao AS descricao,
        time_indice AS indice,
        data,
        ISNULL([1], 0) AS nr_nm,
        ISNULL([2], 0) AS nr_fea,
        ISNULL([3], 0) AS nr_copia,
        ISNULL([6], 0) AS nr_ft,
        ISNULL([7], 0) AS nr_natt,
        ISNULL([9], 0) AS nr_pd
    FROM (
        SELECT
            c.polo_id,
            c.polo_descricao,
            c.time_id,
            c.time_descricao,
            c.time_indice,
            a.id_correcao_situacao,
            convert(date, a.data_termino) AS data,
            count(*) AS nr_corrigidas
        FROM
            correcoes_correcao a
        LEFT OUTER JOIN correcoes_situacao b ON a.id_correcao_situacao = b.id
    INNER JOIN vw_usuario_hierarquia_completa c ON c.usuario_id = a.id_corretor
    WHERE
        a.id_status = 3
    GROUP BY
        c.polo_id,
        c.polo_descricao,
        c.time_id,
        c.time_descricao,
        c.time_indice,
        a.id_correcao_situacao,
        convert(date, a.data_termino)) z pivot (sum(nr_corrigidas)
        FOR id_correcao_situacao IN ([1],
            [2],
            [3],
            [6],
            [7],
            [9])) z) y) u ON q.time_id = u.hierarquia_id

GO
/****** Object:  View [dbo].[vw_relatorio_distribuicao_notas_situacao_time]    Script Date: 22/11/2019 11:44:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER      VIEW [dbo].[vw_relatorio_distribuicao_notas_situacao_time] AS
SELECT
        q.polo_id,
        q.polo_descricao,
        q.time_id,
        q.time_descricao,
        q.usuario_id,
        q.nome,
        q.time_indice AS indice,
        data,
        ISNULL(u.nr_nm, 0) as nr_nm,
        isnull(u.nr_fea, 0) as nr_fea,
        ISNULL(u.nr_copia, 0) as nr_copia,
        ISNULL(u.nr_ft, 0) as nr_ft,
        ISNULL(u.nr_natt, 0) as nr_natt,
        ISNULL(u.nr_pd, 0) as nr_pd,
        ISNULL(u.nr_corrigidas, 0) as nr_corrigidas,
        isnull(u.nr_situacoes, 0) as nr_situacoes
FROM dbo.vw_usuario_hierarquia_completa q left outer join (
SELECT
    polo_id, polo_descricao, time_id, time_descricao, usuario_id, nome, indice, data, nr_nm, nr_fea, nr_copia, nr_ft, nr_natt, nr_pd, (nr_nm + nr_fea + nr_copia + nr_ft + nr_natt + nr_pd) AS nr_corrigidas, (nr_fea + nr_copia + nr_ft + nr_natt + nr_pd) AS nr_situacoes
FROM (
    SELECT
        polo_id,
        polo_descricao,
        time_id,
        time_descricao,
        usuario_id,
        nome,
        time_indice AS indice,
        data,
        ISNULL([1], 0) AS nr_nm,
        ISNULL([2], 0) AS nr_fea,
        ISNULL([3], 0) AS nr_copia,
        ISNULL([6], 0) AS nr_ft,
        ISNULL([7], 0) AS nr_natt,
        ISNULL([9], 0) AS nr_pd
    FROM (
        SELECT
            c.polo_id,
            c.polo_descricao,
            c.time_id,
            c.time_descricao,
            c.time_indice,
            c.usuario_id,
            c.nome,
            a.id_correcao_situacao,
            convert(date, a.data_termino) AS data,
            count(*) AS nr_corrigidas
        FROM
            dbo.correcoes_correcao a
        LEFT OUTER JOIN dbo.correcoes_situacao b ON a.id_correcao_situacao = b.id
    INNER JOIN dbo.vw_usuario_hierarquia_completa c ON c.usuario_id = a.id_corretor
    WHERE
        a.id_status = 3
    GROUP BY
        c.polo_id,
        c.polo_descricao,
        c.time_id,
        c.time_descricao,
        c.time_indice,
        c.usuario_id,
        c.nome,
        a.id_correcao_situacao,
        convert(date, a.data_termino)) z pivot (sum(nr_corrigidas)
        FOR id_correcao_situacao IN ([1],
            [2],
            [3],
            [6],
            [7],
            [9])) z) y) u on u.usuario_id = q.usuario_id

GO
/****** Object:  View [dbo].[vw_relatorio_distribuicao_notas_time]    Script Date: 22/11/2019 11:44:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER      view [dbo].[vw_relatorio_distribuicao_notas_time] as
select 1 as id, polo_id, polo_descricao, polo_indice, time_id, time_descricao, time_indice, usuario_id, nome, data, nr_corrigidas, nr_com_nota_normal,
       (nr_competencia1_0 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia1_0,
       (nr_competencia1_1 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia1_1,
          (nr_competencia1_2 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia1_2,
          (nr_competencia1_3 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia1_3,
          (nr_competencia1_4 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia1_4,
          (nr_competencia1_5 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia1_5,
          (nr_competencia2_0 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia2_0,
       (nr_competencia2_1 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia2_1,
          (nr_competencia2_2 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia2_2,
          (nr_competencia2_3 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia2_3,
          (nr_competencia2_4 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia2_4,
          (nr_competencia2_5 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia2_5,
       (nr_competencia3_0 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia3_0,
       (nr_competencia3_1 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia3_1,
          (nr_competencia3_2 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia3_2,
          (nr_competencia3_3 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia3_3,
          (nr_competencia3_4 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia3_4,
          (nr_competencia3_5 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia3_5,
       (nr_competencia4_0 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia4_0,
       (nr_competencia4_1 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia4_1,
          (nr_competencia4_2 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia4_2,
          (nr_competencia4_3 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia4_3,
          (nr_competencia4_4 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia4_4,
          (nr_competencia4_5 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia4_5,
       (nr_competencia5_ddh * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia5_ddh,
       (nr_competencia5_0 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia5_0,
       (nr_competencia5_1 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia5_1,
          (nr_competencia5_2 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia5_2,
          (nr_competencia5_3 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia5_3,
          (nr_competencia5_4 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia5_4,
          (nr_competencia5_5 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia5_5
        from (
select c.polo_id, c.polo_descricao, c.polo_indice, c.time_id, c.time_descricao, c.time_indice, c.usuario_id, c.nome,
       sum(case when competencia1 = 0 then 1 else 0 end) as nr_competencia1_0,
       sum(case when competencia1 = 1 then 1 else 0 end) as nr_competencia1_1,
       sum(case when competencia1 = 2 then 1 else 0 end) as nr_competencia1_2,
       sum(case when competencia1 = 3 then 1 else 0 end) as nr_competencia1_3,
       sum(case when competencia1 = 4 then 1 else 0 end) as nr_competencia1_4,
       sum(case when competencia1 = 5 then 1 else 0 end) as nr_competencia1_5,
       sum(case when competencia2 = 0 then 1 else 0 end) as nr_competencia2_0,
       sum(case when competencia2 = 1 then 1 else 0 end) as nr_competencia2_1,
       sum(case when competencia2 = 2 then 1 else 0 end) as nr_competencia2_2,
       sum(case when competencia2 = 3 then 1 else 0 end) as nr_competencia2_3,
       sum(case when competencia2 = 4 then 1 else 0 end) as nr_competencia2_4,
       sum(case when competencia2 = 5 then 1 else 0 end) as nr_competencia2_5,
       sum(case when competencia3 = 0 then 1 else 0 end) as nr_competencia3_0,
       sum(case when competencia3 = 1 then 1 else 0 end) as nr_competencia3_1,
       sum(case when competencia3 = 2 then 1 else 0 end) as nr_competencia3_2,
       sum(case when competencia3 = 3 then 1 else 0 end) as nr_competencia3_3,
       sum(case when competencia3 = 4 then 1 else 0 end) as nr_competencia3_4,
       sum(case when competencia3 = 5 then 1 else 0 end) as nr_competencia3_5,
       sum(case when competencia4 = 0 then 1 else 0 end) as nr_competencia4_0,
       sum(case when competencia4 = 1 then 1 else 0 end) as nr_competencia4_1,
       sum(case when competencia4 = 2 then 1 else 0 end) as nr_competencia4_2,
       sum(case when competencia4 = 3 then 1 else 0 end) as nr_competencia4_3,
       sum(case when competencia4 = 4 then 1 else 0 end) as nr_competencia4_4,
       sum(case when competencia4 = 5 then 1 else 0 end) as nr_competencia4_5,
       sum(case when competencia5 = -1 then 1 else 0 end) as nr_competencia5_ddh,
       sum(case when competencia5 = 0 then 1 else 0 end) as nr_competencia5_0,
       sum(case when competencia5 = 1 then 1 else 0 end) as nr_competencia5_1,
       sum(case when competencia5 = 2 then 1 else 0 end) as nr_competencia5_2,
       sum(case when competencia5 = 3 then 1 else 0 end) as nr_competencia5_3,
       sum(case when competencia5 = 4 then 1 else 0 end) as nr_competencia5_4,
       sum(case when competencia5 = 5 then 1 else 0 end) as nr_competencia5_5,
       convert(date, a.data_termino) as data, count(*) as nr_corrigidas, count(case when a.id_correcao_situacao = 1 then 1 else null end) as nr_com_nota_normal
  from correcoes_correcao a with (nolock)
          inner join vw_usuario_hierarquia_completa c with (nolock) on c.usuario_id = a.id_corretor
 where a.id_status = 3
group by c.polo_id, c.polo_descricao, c.polo_indice, c.time_id, c.time_descricao, c.time_indice, c.usuario_id, c.nome, convert(date, a.data_termino)
) z

GO
/****** Object:  View [dbo].[vw_relatorio_geral]    Script Date: 22/11/2019 11:44:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER      VIEW [dbo].[vw_relatorio_geral]
AS
     SELECT 1 AS id,
            hierarquia_id,
            descricao,
            id_hierarquia_usuario_pai,
            id_tipo_hierarquia_usuario,
            indice,
            data,
            notas_aproveitadas,
            total_corrigidas,
            tempo_medio,
            dsp,
            media_dia
     FROM
     (
         SELECT a.polo_id AS hierarquia_id,
                a.polo_descricao AS descricao,
                g.id_hierarquia_usuario_pai,
                g.id_tipo_hierarquia_usuario,
                a.polo_indice AS indice,
                Convert(Date, b.data_termino) AS data,
                Sum((CASE
                         WHEN f.aproveitamento = 1
                         THEN 1
                         ELSE 0
                     END)) AS notas_aproveitadas,
                Count(DISTINCT b.id) AS total_corrigidas,
                Avg(b.tempo_em_correcao) AS tempo_medio,
                Avg(d.dsp) AS dsp,
                Round(Count(*) / DateDiff(day, e.data_inicio, dbo.getlocaldate()), 2) AS media_dia
         FROM vw_usuario_hierarquia_completa a WITH(NOLOCK)
              INNER JOIN correcoes_correcao b WITH(NOLOCK)
                       ON b.id_corretor = a.usuario_id
                          AND b.id_status = 3
              INNER JOIN usuarios_hierarquia c WITH(NOLOCK)
                       ON c.id = a.time_id
              INNER JOIN usuarios_hierarquia g WITH(NOLOCK)
                       ON g.id = a.polo_id
              INNER JOIN projeto_projeto e WITH(NOLOCK)
                       ON e.id = b.id_projeto
              LEFT OUTER JOIN correcoes_analise f WITH(NOLOCK)
                       ON f.id_correcao_A = b.id
                          AND f.id_tipo_correcao_b = 3
              LEFT OUTER JOIN correcoes_corretor_indicadores d WITH(NOLOCK)
                       ON d.usuario_id = b.id_corretor
                          AND d.data_calculo =
         (
             SELECT Max(data_calculo)
             FROM correcoes_corretor_indicadores z WITH(NOLOCK)
             WHERE z.usuario_id = b.id_corretor
         )
         GROUP BY a.polo_id,
                  a.polo_descricao,
                  g.id_hierarquia_usuario_pai,
                  g.id_tipo_hierarquia_usuario,
                  a.polo_indice,
                  Convert(Date, b.data_termino),
                  e.data_inicio
     ) f;

GO
/****** Object:  View [dbo].[vw_relatorio_geral_por_polo]    Script Date: 22/11/2019 11:44:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER      VIEW [dbo].[vw_relatorio_geral_por_polo] AS
SELECT  ROW_NUMBER() over (order by TIME_id) as id,
        POLO_ID,
        POLO_DESCRICAO,
        HIERARQUIA,
        TIME_ID,
        indice,
        DSP = AVG(MEDIA_DSP) ,
        TIME_DESCRICAO,
        TOTAL_CORRIGIDAS,
        TOTAL_CORRIGIDAS_POR_DIA = CAST(ROUND(TOTAL_CORRIGIDAS / (SELECT (CASE WHEN dbo.getlocaldate() <= DATA_TERMINO THEN DATEDIFF(DAY,DATEADD(DAY,-1,DATA_INICIO), dbo.getlocaldate())
                                                                                                             ELSE DATEDIFF(DAY,DATEADD(DAY,-1,DATA_INICIO), DATA_TERMINO) END) * 1.0
                                                                  FROM PROJETO_PROJETO with (nolock) WHERE ID = 4), 2) AS NUMERIC(10,2)),
        TOTAL_CORRETORES,
        TEMPO_MEDIO = CAST(ROUND(CASE WHEN TOTAL_CORRIGIDAS = 0 THEN 0 ELSE  SOMA_TEMPO / (TOTAL_CORRIGIDAS * 1.0) END , 2) AS NUMERIC(10,2)),
        APROVEITAMENTO_NOTA = ISNULL( CAST(ROUND((case when TOTAL_CORRIGIDAS = 0 then 0.00 else aproveitamento_nota / (total_corrigidas * 1.0) end) * 100, 2) AS NUMERIC(10,2)),0)
  FROM (
SELECT DISTINCT
       POLO_ID = HIE2.POLO_ID ,
       POLO_DESCRICAO =  HIE2.POLO_DESCRICAO,
       HIE.indice,
       HIERARQUIA =  HIE2.HIERARQUIA,
       HIE.TIME_ID,
       HIE.TIME_DESCRICAO,
       TOTAL_CORRIGIDAS = ISNULL(COR.QTD,0),
       SOMA_TEMPO = ISNULL(TEMPO,0),
       MEDIA_DSP  = CCI.MEDIA_DSP,
       APROVEITAMENTO_NOTA = QTD_APROVEITAMENTO,
       TOTAL_CORRETORES = ISNULL(CORRETOR.QTD,0)


  FROM (SELECT DISTINCT TIME_ID, TIME_DESCRICAO , INDICE
          FROM VW_USUARIO_HIERARQUIA
          WHERE id_tipo_hierarquia_usuario = 4) AS  HIE   left join (select HIEX.TIME_id, QTD = ISNULL(count(CORX.ID),0), TEMPO = SUM(ISNULL(CORX.TEMPO_EM_CORRECAO,0))
                                                             from correcoes_correcao corX join vw_usuario_hierarquia hieX on (corX.id_corretor = hieX.usuario_id)
                                                            where id_status = 3 GROUP BY HIEX.TIME_id ) AS COR ON (HIE.TIME_id = COR.TIME_id)
                                                LEFT JOIN (SELECT HIEX.TIME_id, MEDIA_DSP = AVG(ISNULL(CCIX.DSP,0))
                                                             FROM correcoes_corretor_indicadores CCIX join vw_usuario_hierarquia hieX on (CCIX.USUARIO_ID = hieX.usuario_id)
                                                            GROUP BY HIEX.TIME_id) AS CCI ON (HIE.TIME_id = CCI.TIME_id)
                                                LEFT JOIN (SELECT HIEX.TIME_id, QTD = ISNULL(count(CORR.ID),0)
                                                             FROM correcoes_corretor CORR join vw_usuario_hierarquia hieX on (CORR.id = hieX.usuario_id)
                                                            GROUP BY HIEX.TIME_id) AS CORRETOR ON (HIE.TIME_id = CORRETOR.TIME_id)
                                                LEFT JOIN (SELECT HIEX.TIME_id, QTD_APROVEITAMENTO = ISNULL(COUNT(ANAX.ID),0)
                                                             FROM correcoes_analise ANAX JOIN VW_USUARIO_HIERARQUIA HIEX ON (ANAX.id_correTOR_A = HIEX.USUARIO_ID AND
                                                                                                                             ANAX.ID_TIPO_CORRECAO_B = 3          AND
                                                                                                                             ANAX.aproveitamento = 1)
                                                            GROUP BY HIEX.TIME_id) AS ANA ON (ANA.TIME_id = HIE.TIME_id)
                                               LEFT JOIN (SELECT DISTINCT HIEX.TIME_ID, POLO_ID, POLO_DESCRICAO, HIERARQUIA
                                                            FROM VW_USUARIO_HIERARQUIA HIEX) AS HIE2 ON (HIE2.TIME_ID = HIE.TIME_ID)) AS TAB
GROUP BY POLO_ID,
      POLO_DESCRICAO,
      HIERARQUIA,
      TIME_ID,
      indice,
      TIME_DESCRICAO,
      TOTAL_CORRIGIDAS,
      SOMA_TEMPO,
      APROVEITAMENTO_NOTA,
      TOTAL_CORRETORES

GO
/****** Object:  View [dbo].[vw_relatorio_geral_por_time]    Script Date: 22/11/2019 11:44:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER    VIEW [dbo].[vw_relatorio_geral_por_time] AS 
WITH CTE_APROVEITAMENTO AS (
            SELECT usuario_id, SUM(nr_corrigidas) nr_corrigidas_1_2, SUM(nr_aproveitadas) as nr_aproveitadas,  
                SUM(nr_discrepantes) as nr_discrepantes, data  
              FROM vw_aproveitamento_notas_time WITH(NOLOCK)
                                 GROUP BY usuario_id, data
  ),

        CTE_TEMPO_MEDIO AS (
            SELECT 
                COUNT(1) nr_corrigidas,
                cast(data_termino as date) AS DATA_TERMINO,
                id_corretor,
                CASE WHEN AVG(tempo_em_correcao) > 1200 then 1200 else AVG(tempo_em_correcao) end as tempo_medio  
              FROM correcoes_correcao  WITH(NOLOCK) where data_termino is not null
             GROUP BY id_corretor, cast(data_termino as date)
    )

        SELECT   
        HIE.polo_id,  
        HIE.polo_descricao,  
        HIE.time_id,  
        HIE.time_descricao,  
        nome as avaliador,  
        HIE.usuario_id,  
        HIE.TIME_indice AS INDICE,  
        nr_corrigidas,
        nr_corrigidas_1_2,  
        nr_aproveitadas,  
        nr_discrepantes,  
        tempo_medio,  
        cast(COR.dsp as varchar(20)) as dsp,  
        data   
        FROM vw_usuario_hierarquia_completa HIE  WITH(NOLOCK) JOIN      correcoes_corretor   COR WITH(NOLOCK) ON (COR.id           = HIE.usuario_id) 
                                                                LEFT JOIN CTE_TEMPO_MEDIO    TEM WITH(NOLOCK) ON (TEM.id_corretor = HIE.usuario_id)
                                                                LEFT JOIN CTE_APROVEITAMENTO APR WITH(NOLOCK) ON (APR.usuario_id  = HIE.usuario_id AND 
                                                                                                                  APR.data        = TEM.DATA_TERMINO)

GO
/****** Object:  View [dbo].[vw_relatorio_padrao_ouro_avaliador]    Script Date: 22/11/2019 11:44:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER      VIEW [dbo].[vw_relatorio_padrao_ouro_avaliador]
 AS
SELECT
  a.id_correcao_a AS id_correcao,
  a.id_corretor_a AS id_corretor,
  b.id
  AS redacao,
  a.competencia1_a AS avaliador_c1,
  a.competencia2_a AS avaliador_c2,
  a.competencia3_a AS avaliador_c3,
  a.competencia4_a AS avaliador_c4,
  a.competencia5_a AS avaliador_c5,
  CASE
    WHEN a.competencia5_a = -1 THEN 1
    ELSE 0
  END AS avaliador_is_ddh,
  a.nota_final_a
  AS nota,
  c.id_competencia1 AS referencia_c1,
  c.id_competencia2 AS referencia_c2,
  c.id_competencia3 AS referencia_c3,
  c.id_competencia4 AS referencia_c4,
  c.id_competencia5 AS referencia_c5,
  CASE
    WHEN c.id_competencia5 = -1 THEN 1
    ELSE 0
  END AS referencia_is_ddh,
  c.nota_final
  AS nota_referencia,
  ABS(c.id_competencia1 - a.competencia1_a) AS diferenca_c1,
  ABS(c.id_competencia2 - a.competencia2_a) AS diferenca_c2,
  ABS(c.id_competencia3 - a.competencia3_a) AS diferenca_c3,
  ABS(c.id_competencia4 - a.competencia4_a) AS diferenca_c4,
  ABS(CASE c.id_competencia5
    WHEN -1 THEN 0
    ELSE c.id_competencia5
  END -
       CASE a.competencia5_a
         WHEN -1 THEN 0
         ELSE a.competencia5_a
       END) AS diferenca_c5,
  ABS(c.nota_final - a.nota_final_a) AS nota_diferenca,
  CAST(a.data_termino_a AS date) AS data,
  d.sigla AS avaliador_situacao,
  e.sigla AS referencia_situacao,
  f.discrepou,
  g.time_id,
  g.polo_id,
  g.fgv_id,
  g.geral_id,
  g.time_descricao,
  g.polo_descricao,
  g.fgv_descricao,
  g.geral_descricao,
  g.time_indice,
  g.polo_indice,
  g.fgv_indice,
  g.geral_indice
FROM correcoes_analise a WITH(NOLOCK) JOIN correcoes_redacao              b WITH(NOLOCK) ON (a.redacao_id     = b.id)
                                      JOIN correcoes_gabarito             c WITH(NOLOCK) ON (c.redacao_id     = b.id)
                                      JOIN correcoes_situacao             d WITH(NOLOCK) ON (d.id                   = a.id_correcao_situacao_a)
                                      JOIN correcoes_situacao             e WITH(NOLOCK) ON (c.id_correcao_situacao = e.id)
                                      JOIN correcoes_conclusao_analise    f WITH(NOLOCK) ON (f.id                   = a.conclusao_analise)
                                      JOIN vw_usuario_hierarquia_completa g WITH(NOLOCK) ON (g.usuario_id           = a.id_corretor_a)
WHERE  a.id_tipo_correcao_A = 5

GO
/****** Object:  View [dbo].[vw_relatorio_padrao_ouro_geral]    Script Date: 22/11/2019 11:44:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER      VIEW [dbo].[vw_relatorio_padrao_ouro_geral] as
select 1 as id, * from (
  SELECT c.id as hierarquia_id, c.descricao, c.indice,
        convert(date, a.data) as data, count(a.id_CORRECAO) as padrao_ouro, isnull(sum(convert(int, a.discrepou)), 0) as discrepancia_padrao_ouro
    from usuarios_hierarquia c 
        left outer join vw_relatorio_padrao_ouro_avaliador a on c.id = a.polo_id
   where c.id_tipo_hierarquia_usuario = 3
  group by c.id, c.descricao, c.indice, convert(date, a.data)
) z


SELECT * FROM vw_relatorio_padrao_ouro_avaliador
GO
/****** Object:  View [dbo].[vw_relatorio_padrao_ouro_polo]    Script Date: 22/11/2019 11:44:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER      VIEW [dbo].[vw_relatorio_padrao_ouro_polo] as
select 1 as id, b.id as polo_id, b.descricao as polo_descricao, c.id as hierarquia_id, c.descricao, c.indice,
        convert(date, a.data) as data, count(a.id_CORRECAO) as padrao_ouro, isnull(sum(convert(int, a.discrepou)), 0) as discrepancia_padrao_ouro
    from usuarios_hierarquia c
         inner join usuarios_hierarquia b on b.id = c.id_hierarquia_usuario_pai
         left outer join vw_relatorio_padrao_ouro_avaliador a on c.id = a.time_id
   where c.id_tipo_hierarquia_usuario = 4
  group by b.id, b.descricao, c.id, c.descricao, c.indice, convert(date, a.data)
  
GO
/****** Object:  View [dbo].[vw_relatorio_padrao_ouro_time]    Script Date: 22/11/2019 11:44:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER      VIEW [dbo].[vw_relatorio_padrao_ouro_time] as
SELECT d.polo_id, d.polo_descricao, d.time_id, d.time_descricao, b.user_id as usuario_id, b.hierarquia_id, c.id_usuario_responsavel, c.indice, c.id_tipo_hierarquia_usuario, d.nome as avaliador,
        convert(date, a.data) as data, count(a.id_corretor) as nr_padrao_ouro, isnull(sum(convert(int, a.discrepou)), 0) as nr_discrepancia_padrao_ouro
    from usuarios_hierarquia c
        inner join usuarios_hierarquia_usuarios b on c.id = b.hierarquia_id
        inner join vw_usuario_hierarquia_completa d on d.usuario_id = b.user_id
        left outer join vw_relatorio_padrao_ouro_avaliador a on a.id_corretor = b.user_id
   where c.id_tipo_hierarquia_usuario = 4
  group by d.polo_id, d.polo_descricao, d.time_id, d.time_descricao, b.user_id, b.hierarquia_id, c.id_usuario_responsavel, c.indice,
           c.id_tipo_hierarquia_usuario, d.nome, convert(date, a.data)

GO
/****** Object:  View [dbo].[vw_relatorio_panorama_geral_ocorrencias]    Script Date: 22/11/2019 11:44:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER      VIEW [dbo].[vw_relatorio_panorama_geral_ocorrencias] AS
SELECT
    *, (total_ocorrencias - ocorrencias_respondidas) AS ocorrencias_pendentes
FROM (
    SELECT
        c.id AS time_id,
        c.id as hierarquia_id,
        c.descricao AS time_descricao,
        e.id AS polo_id,
        e.descricao AS polo_descricao,
        c.id_usuario_responsavel,
        c.id_hierarquia_usuario_pai,
        c.id_tipo_hierarquia_usuario,
        c.indice,
        convert(date, a.data_termino) AS data,
        count(*) AS total_ocorrencias,
        count(data_resposta) AS ocorrencias_respondidas
    FROM
        correcoes_correcao a,
        usuarios_hierarquia_usuarios b,
        usuarios_hierarquia c,
        ocorrencias_ocorrencia d,
        usuarios_hierarquia e
    WHERE
        a.id_corretor = b.user_id
        AND b.hierarquia_id = c.id
        AND d.correcao_id = a.id
        AND c.id_hierarquia_usuario_pai = e.id
    GROUP BY
        c.id,
        c.descricao,
        c.id_hierarquia_usuario_pai,
        c.id_tipo_hierarquia_usuario,
        c.indice,
        convert(date, a.data_termino),
        c.id_usuario_responsavel,
        e.id,
        e.descricao) z


GO
/****** Object:  View [dbo].[vw_relatorio_reescameamento]    Script Date: 22/11/2019 11:44:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER    view [dbo].[vw_relatorio_reescameamento] as
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
/****** Object:  View [dbo].[vw_relatorio_reescaneamento]    Script Date: 22/11/2019 11:44:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER    view [dbo].[vw_relatorio_reescaneamento] as
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
/****** Object:  View [dbo].[vw_relatorio_terceira_correcao_avaliador]    Script Date: 22/11/2019 11:44:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/**********************************************************************************************************************************
*                                           [VW_RELATORIO_TERCEIRA_CORRECAO_AVALIADOR]                                            *
*                                                                                                                                 *
*  VIEW QUE RETORNA TODAS AS CORRECOES QUE TIVERAM TERCEIRA E ESTA NAO FOI APROVEITADA                                            *
*                                                                                                                                 *
*                                                                                                                                 *
* BANCO_SISTEMA : ENEM                                                                                                            *
* CRIADO POR    : WEMERSON BITTORI MADURO                                                                         DATA:03/10/2019 *
* ALTERADO POR  : WEMERSON BITTORI MADURO                                                                         DATA:03/10/2019 *
**********************************************************************************************************************************/

CREATE OR ALTER    VIEW [dbo].[vw_relatorio_terceira_correcao_avaliador] as 
SELECT 
    cor.id AS id_correcao,
    cor.id_corretor,
    hic.nome,
    CAST(red.id AS [nvarchar]) AS redacao,
    cor.competencia1 AS terceira_c1,
    cor.competencia2 AS terceira_c2,
    cor.competencia3 AS terceira_c3,
    cor.competencia4 AS terceira_c4,
    cor.competencia5 AS terceira_c5,
    CAST(cor.nota_final AS [int]) AS terceira_soma,
    sit.sigla AS terceira_situacao,
    cor4.competencia1 AS quarta_c1,
    cor4.competencia2 AS quarta_c2,
    cor4.competencia3 AS quarta_c3,
    cor4.competencia4 AS quarta_c4,
    cor4.competencia5 AS quarta_c5,
    CAST(cor4.nota_final AS [int]) AS quarta_soma,
    sit4.sigla AS quarta_situacao,
    cor.data_termino AS data,
    aproveitamento =
                    CASE
                        WHEN ana.conclusao_analise > 2 THEN 0
                        WHEN ana.conclusao_analise >= 0 THEN 1
                        ELSE NULL
                    END,
    hic.time_id,
    hic.polo_id,
    hic.fgv_id,
    hic.geral_id,
    hic.time_descricao,
    hic.polo_descricao,
    hic.fgv_descricao,
    hic.geral_descricao,
    hic.time_indice,
    hic.polo_indice,
    hic.fgv_indice,
    hic.geral_indice,
    red.co_barra_redacao,
    hie.id_hierarquia_usuario_pai,
    hie.id_tipo_hierarquia_usuario
FROM correcoes_correcao cor with(nolock) JOIN correcoes_redacao red with(nolock) ON (cor.redacao_id = red.id)
                          JOIN vw_usuario_hierarquia_completa   hic with(nolock) ON (hic.usuario_id = cor.id_corretor)
                          JOIN correcoes_situacao               sit with(nolock) ON (sit.id = cor.id_correcao_situacao)
                          JOIN usuarios_hierarquia              hie with(nolock) ON (hie.id = hic.time_id)
                     LEFT JOIN correcoes_analise                ana with(nolock) ON (ana.redacao_id = cor.redacao_id AND ana.id_projeto = cor.id_projeto  AND ana.id_tipo_correcao_A = 3 AND ana.id_tipo_correcao_B = 4)
                     LEFT JOIN correcoes_correcao               cor4 with(nolock) ON (cor4.redacao_id = red.id AND cor4.id_tipo_correcao = 4)
                     LEFT JOIN correcoes_situacao               sit4 with(nolock) ON (sit4.id = cor4.id_correcao_situacao)
WHERE cor.id_tipo_correcao = 3
AND cor.id_status = 3  
AND  EXISTS (SELECT TOP 1 1 FROM correcoes_analise  WHERE id_correcao_B = cor.id)
AND (EXISTS (SELECT TOP 1 1 FROM correcoes_correcao WHERE redacao_id    = cor.redacao_id AND id_tipo_correcao = 4) OR 
     EXISTS (SELECT TOP 1 1 FROM correcoes_fila4    WHERE redacao_id    = cor.redacao_id)                          OR 
     EXISTS (SELECT TOP 1 1 FROM correcoes_correcao WHERE redacao_id    = cor.redacao_id AND id_tipo_correcao = 7) OR 
     EXISTS (SELECT TOP 1 1 FROM correcoes_filaauditoria    WHERE redacao_id    = cor.redacao_id)                          
     )


GO
/****** Object:  View [dbo].[vw_relatorio_terceira_correcao_avaliador_AUX]    Script Date: 22/11/2019 11:44:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER      VIEW [dbo].[vw_relatorio_terceira_correcao_avaliador_AUX] as
select ROW_NUMBER() over (order by id_correcao) as id, * from (
select a.id as id_correcao, a.id_corretor, c.nome, b.id as redacao,
       a.competencia1 as terceira_c1,
       a.competencia2 as terceira_c2,
       a.competencia3 as terceira_c3,
       a.competencia4 as terceira_c4,
       a.competencia5 as terceira_c5,
       a.nota_final as terceira_soma,
       e.sigla as terceira_situacao,
       d.competencia1 as quarta_c1,
       d.competencia2 as quarta_c2,
       d.competencia3 as quarta_c3,
       d.competencia4 as quarta_c4,
       d.competencia5 as quarta_c5,
       d.nota_final as quarta_soma,
       f.sigla as quarta_situacao,
       a.data_termino as data,
       -- fila4 = fil4.id ,
      -- correcao4 = corQua.id, ANAX.conclusao_analise,analiseaproveitamento = ANAX.aproveitamento,auditoria = filaud.id,
       conta = ((case when coraud.id is null then 0 else 1 end ) +
                                    (case when corqua.id is null then 0 else 1 end ) +
                                    (case when filaud.id is null then 0 else 1 end ) +
                                    (case when fil4.id   is null then 0 else 1 end )),

       APROVEITAMENTO = (case when ((case when coraud.id is not null then 1 else 0 end ) +
                                    (case when corqua.id is not null then 1 else 0 end ) +
                                    (case when filaud.id is not null then 1 else 0 end ) +
                                    (case when fil4.id   is not null then 1 else 0 end )) > 0 then 0
                              when (case when isnull(ANAX.conclusao_analise,0) < 3 then 1
                                        when ANAX.aproveitamento = 1 then 1 else 0 end) = 1  then 1
                              else 0 end),
        foi_para_quarta = (case when fil4.id is not null or corQua.id is not null or filaud.id is not null or  isnull(ANAX.conclusao_analise,0) > 2 then 1 else 0 end ),
        c.time_id, c.polo_id, c.fgv_id, c.geral_id, c.time_descricao, c.polo_descricao, c.fgv_descricao, c.geral_descricao,
        c.time_indice, c.polo_indice, c.fgv_indice, c.geral_indice,
        a.co_barra_redacao, g.id_hierarquia_usuario_pai, g.id_tipo_hierarquia_usuario
  from correcoes_correcao a
       inner join correcoes_redacao              b on a.co_barra_redacao = b.co_barra_redacao
       inner join vw_usuario_hierarquia_completa c on c.usuario_id = a.id_corretor
       inner join correcoes_situacao             e on e.id = a.id_correcao_situacao
       inner join usuarios_hierarquia            g on g.id = c.time_id
       left  join correcoes_analise            ana on (ana.co_barra_redacao = a.co_barra_redacao and
                                                       ana.id_projeto       = a.id_projeto and
                                                       ana.id_tipo_correcao_A = 3 and
                                                       ana.id_tipo_correcao_B = 4)
       left outer join correcoes_correcao d on d.co_barra_redacao = b.co_barra_redacao and d.id_tipo_correcao = 4
       left outer join correcoes_situacao f on f.id = d.id_correcao_situacao

       left outer join correcoes_analise ANAX on  (ANAX.id_correcao_a = b.id and ANAX.id_tipo_correcao_b = 3)   --verificar aproveitamento e discrepância de comparação com terceiras
       left outer join correcoes_correcao corQua on (corQua.co_barra_redacao = b.co_barra_redacao and corQua.id_tipo_correcao = 4)  -- correcoes de quarta
       left outer join correcoes_correcao corAud on (corAud.co_barra_redacao = b.co_barra_redacao and corAud.id_tipo_correcao = 7)  -- correcoes de auditoria
       left outer join correcoes_fila3 fil3 on (fil3.co_barra_redacao = b.co_barra_redacao)  -- fila 3
       left outer join correcoes_fila4 fil4 on (fil4.co_barra_redacao = b.co_barra_redacao) -- fila 4
       left outer join correcoes_filaauditoria filaud on (filaud.co_barra_redacao = b.co_barra_redacao) -- fila auditoria
 where a.id_tipo_correcao = 3
   and a.id_status = 3
   --and  exists (select top 1 1 from correcoes_analise x where x.id_correcao_B = a.id)
   --and (exists (select top 1 1 from correcoes_correcao where co_barra_redacao = a.co_barra_redacao and id_tipo_correcao = 4) or
   --     exists (select top 1 1 from correcoes_fila4 where co_barra_redacao = a.co_barra_redacao)

        --)
) z

GO
/****** Object:  View [dbo].[vw_relatorio_terceira_correcao_avaliador_para_time]    Script Date: 22/11/2019 11:44:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER      VIEW [dbo].[vw_relatorio_terceira_correcao_avaliador_para_time] as
select 1 as id, a.id as id_correcao, a.id_corretor, c.nome, b.id as redacao,
       a.competencia1 as terceira_c1,
       a.competencia2 as terceira_c2,
       a.competencia3 as terceira_c3,
       a.competencia4 as terceira_c4,
       a.competencia5 as terceira_c5,
       a.nota_final as terceira_soma,
       e.sigla as terceira_situacao,
       d.competencia1 as quarta_c1,
       d.competencia2 as quarta_c2,
       d.competencia3 as quarta_c3,
       d.competencia4 as quarta_c4,
       d.competencia5 as quarta_c5,
       d.nota_final as quarta_soma,
       f.sigla as quarta_situacao,
       a.data_termino as data,

        aproveitamento = case when ana.conclusao_analise > 2 then 0
                                   when ana.conclusao_analise >=0 then 1 else null end,
        c.time_id, c.polo_id, c.fgv_id, c.geral_id, c.time_descricao, c.polo_descricao, c.fgv_descricao, c.geral_descricao,
        c.time_indice, c.polo_indice, c.fgv_indice, c.geral_indice,
        a.co_barra_redacao, g.id_hierarquia_usuario_pai, g.id_tipo_hierarquia_usuario
  from correcoes_correcao a
       inner join correcoes_redacao b on a.co_barra_redacao = b.co_barra_redacao
       inner join vw_usuario_hierarquia_completa c on c.usuario_id = a.id_corretor
       inner join correcoes_situacao e on e.id = a.id_correcao_situacao
       inner join usuarios_hierarquia g on g.id = c.time_id
       left  join correcoes_analise  ana on (ana.co_barra_redacao = a.co_barra_redacao and
                                             ana.id_projeto       = a.id_projeto and
                                             ana.id_tipo_correcao_A = 3 and
                                             ana.id_tipo_correcao_B = 4)
       left outer join correcoes_correcao d on d.co_barra_redacao = b.co_barra_redacao and d.id_tipo_correcao = 4
       left outer join correcoes_situacao f on f.id = d.id_correcao_situacao
 where a.id_tipo_correcao = 3
   and a.id_status = 3
   and exists (select top 1 1 from correcoes_analise x where x.id_correcao_B = a.id)

GO
/****** Object:  View [dbo].[vw_relatorio_terceira_correcao_geral]    Script Date: 22/11/2019 11:44:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER        VIEW [dbo].[vw_relatorio_terceira_correcao_geral] as
select u.id as polo_id,
       u.descricao as polo_descricao,
       u.indice,
       y.data,
       y.id_hierarquia_usuario_pai,
       y.id_tipo_hierarquia_usuario,
       isnull(y.terceiras_corrigidas, 0) as terceiras_corrigidas,
       isnull(y.terceiras_aproveitadas, 0) as terceiras_aproveitadas,
       isnull(y.foram_quarta, 0) as foram_quarta,
       isnull(y.aproveitadas_quarta, 0) as aproveitadas_quarta,
       isnull(y.nao_aproveitadas_quarta, 0) as nao_aproveitadas_quarta
  from usuarios_hierarquia u left outer join (
                                              select a.polo_id as hierarquia_id,
                                                     a.polo_descricao as descricao,
                                                     a.polo_indice as indice,
                                                     convert(date, data) as data,
                                                     a.id_hierarquia_usuario_pai,
                                                     a.id_tipo_hierarquia_usuario,
                                                     count(a.id_correcao) as terceiras_corrigidas,
                                                     sum(convert(int, a.aproveitamento)) as terceiras_aproveitadas,
                                                     sum(a.foi_para_quarta) as foram_quarta,
                                                     sum((case when isnull(c.discrepou, 1) = 1 then 0 else 1 end)) as aproveitadas_quarta,
                                                     sum((case when quarta_soma is null then 0 else isnull(convert(int, c.discrepou), 1) end)) as nao_aproveitadas_quarta
                                                from vw_relatorio_terceira_correcao_avaliador_AUX a
                                                     left outer join correcoes_analise b on a.id_correcao = b.id_correcao_A and b.id_tipo_correcao_B = 4
                                                     left outer join correcoes_conclusao_analise c on c.id = b.conclusao_analise
                                              group by a.polo_id, a.polo_descricao, a.polo_indice, convert(date, data), a.id_hierarquia_usuario_pai, a.id_tipo_hierarquia_usuario
                                              ) y on u.id = y.hierarquia_id where u.id_tipo_hierarquia_usuario = 3

GO
/****** Object:  View [dbo].[vw_relatorio_terceira_correcao_polo]    Script Date: 22/11/2019 11:44:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER      VIEW [dbo].[vw_relatorio_terceira_correcao_polo] as
SELECT
     q.time_id,
     q.time_descricao,
     q.time_indice AS indice,
     k.id_hierarquia_usuario_pai,
     k.id_tipo_hierarquia_usuario,
     u.data,
     q.polo_id,
     q.polo_descricao,
     ISNULL(u.terceiras_corrigidas, 0) as terceiras_corrigidas,
     ISNULL(u.terceiras_aproveitadas, 0) as terceiras_aproveitadas,
     ISNULL(u.foram_quarta, 0) as foram_quarta,
     ISNULL(u.aproveitadas_quarta, 0) as aproveitadas_quarta,
     ISNULL(u.nao_aproveitadas_quarta, 0) as nao_aproveitadas_quarta
FROM vw_hierarquia_completa q
     inner join usuarios_hierarquia k on k.id = q.time_id
     LEFT OUTER JOIN (

SELECT
    *
FROM (
    SELECT
        a.time_id AS hierarquia_id,
        a.time_descricao AS descricao,
        a.time_indice AS indice,
        a.id_hierarquia_usuario_pai,
        a.id_tipo_hierarquia_usuario,
        data,
        polo_id,
        polo_descricao AS polo,
        count(a.id_correcao) AS terceiras_corrigidas,
        sum(convert(int, ISNULL(a.aproveitamento, 0))) AS terceiras_aproveitadas,
        count(a.quarta_soma) AS foram_quarta,
        sum(( CASE WHEN ISNULL(c.discrepou, 1) = 1 THEN
                    0
                ELSE
                    1
END)) AS aproveitadas_quarta,
sum(( CASE WHEN quarta_soma IS NULL THEN
            0
        ELSE
            ISNULL(convert(int, c.discrepou), 1)
END)) AS nao_aproveitadas_quarta
FROM
    vw_relatorio_terceira_correcao_avaliador a
    LEFT OUTER JOIN correcoes_analise b ON a.id_correcao = b.id_correcao_A
    AND b.id_tipo_correcao_B = 4
    LEFT OUTER JOIN correcoes_conclusao_analise c ON c.id = b.conclusao_analise
GROUP BY
    a.time_id,
    a.time_descricao,
    a.time_indice,
    a.id_hierarquia_usuario_pai,
    a.id_tipo_hierarquia_usuario,
    data,
    polo_id,
    polo_descricao) z) u on q.time_id = u.hierarquia_id

GO
/****** Object:  View [dbo].[vw_relatorio_terceira_correcao_time]    Script Date: 22/11/2019 11:44:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/**********************************************************************************************************************************
*                                             [VW_RELATORIO_TERCEIRA_CORRECAO_TIME]                                               *
*                                                                                                                                 *
*  VIEW QUE SINTETIZA AS INFORMACOES REFERENTES A CORRECAO DAS TERCEIRAS                                                          *
*                                                                                                                                 *
*                                                                                                                                 *
* BANCO_SISTEMA : ENEM                                                                                                            *
* CRIADO POR    : WEMERSON BITTORI MADURO                                                                         DATA:03/10/2019 *
* ALTERADO POR  : WEMERSON BITTORI MADURO                                                                         DATA:03/10/2019 *
***********************************************************************************************************************************/
CREATE OR ALTER    VIEW [dbo].[vw_relatorio_terceira_correcao_time]
AS
SELECT
    hc.time_id,
    hc.time_descricao,
    hc.time_indice AS indice,
    hc.usuario_id AS avaliador_id,
    k.id_hierarquia_usuario_pai,
    k.id_tipo_hierarquia_usuario,
    hc.nome AS avaliador_descricao,
    z.data,
    hc.polo_id,
    hc.polo_descricao,
    ISNULL(z.terceiras_corrigidas, 0) AS terceiras_corrigidas,
    ISNULL(z.terceiras_aproveitadas, 0) AS terceiras_aproveitadas,
    ISNULL(z.foram_quarta, 0) AS foram_quarta,
    ISNULL(z.aproveitadas_quarta, 0) AS aproveitadas_quarta,
    ISNULL(z.nao_aproveitadas_quarta, 0) AS nao_aproveitadas_quarta,
    ISNULL(z.pode_corrigir_3, 0) AS pode_corrigir_3
FROM vw_usuario_hierarquia_completa hc
INNER JOIN usuarios_hierarquia k
    ON k.id = hc.time_id
LEFT OUTER JOIN (SELECT
        a.time_id AS hierarquia_id,
        a.time_descricao AS descricao,
        a.time_indice AS indice,
        a.id_corretor,
        a.nome,
        CONVERT(date, data) AS data,
        polo_id,
        polo_descricao AS polo,
        COUNT(a.id_correcao) AS terceiras_corrigidas,     --isnull(sum(convert(int, a.aproveitamento)), 0) as terceiras_aproveitadas, 
        COUNT(a.id_correcao) - (ISNULL(COUNT(f.id), 0) + ISNULL(COUNT(g.id), 0) + ISNULL(COUNT(k.id), 0) + ISNULL(COUNT(j.id), 0)) AS terceiras_aproveitadas,
        (ISNULL(COUNT(f.id), 0) + ISNULL(COUNT(g.id), 0) + ISNULL(COUNT(k.id), 0) + ISNULL(COUNT(j.id), 0)) AS foram_quarta,
        SUM((CASE
            WHEN ISNULL(c.discrepou, 1) = 1 THEN 0
            ELSE 1
        END)) AS aproveitadas_quarta,
        SUM((CASE
            WHEN quarta_soma IS NULL THEN 0
            ELSE ISNULL(CONVERT(int, c.discrepou), 1)
        END)) AS nao_aproveitadas_quarta,
        h.pode_corrigir_3
    FROM vw_relatorio_terceira_correcao_avaliador_para_time a WITH(NOLOCK)
                                         INNER JOIN correcoes_corretor          h WITH(NOLOCK) ON h.id = a.id_corretor
                                    LEFT OUTER JOIN correcoes_analise           b WITH(NOLOCK) ON a.id_correcao = b.id_correcao_A AND 
                                                                                                  b.id_tipo_correcao_B = 4
                                    LEFT OUTER JOIN correcoes_conclusao_analise c WITH(NOLOCK) ON c.id = b.conclusao_analise
                                    LEFT OUTER JOIN correcoes_fila4             f WITH(NOLOCK) ON f.co_barra_redacao = a.co_barra_redacao
                                    LEFT OUTER JOIN correcoes_filaauditoria     k WITH(NOLOCK) ON k.co_barra_redacao = a.co_barra_redacao
                                    LEFT OUTER JOIN correcoes_correcao          j WITH(NOLOCK) ON j.co_barra_redacao = a.co_barra_redacao       AND 
                                                                                                  j.id_tipo_correcao = 7
                                    LEFT OUTER JOIN correcoes_correcao          g WITH(NOLOCK) ON g.co_barra_redacao = a.co_barra_redacao       AND 
                                                                                g.id_tipo_correcao = 4  
    
    GROUP BY    a.time_id,
                a.time_descricao,
                a.time_indice,
                a.id_corretor,
                a.id_hierarquia_usuario_pai,
                a.id_tipo_hierarquia_usuario,
                a.nome,
                CONVERT(date, data),
                polo_id,
                polo_descricao,
                h.pode_corrigir_3) z
    ON hc.usuario_id = z.id_corretor

GO
/****** Object:  View [dbo].[vw_relatorios_acompanhamento_geral]    Script Date: 22/11/2019 11:44:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER      VIEW [dbo].[vw_relatorios_acompanhamento_geral] as
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
/****** Object:  View [dbo].[VW_TEMPO_TOTAL_OCORRENCIA_POR_CORRECAO_ID]    Script Date: 22/11/2019 11:44:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*****************************************************************************************************************
*                      VIEW CALCULA DIFERENCA DE TEMPO DE ABERTURA E FECHAMENTO OCORRENCIA                       *
*                                                                                                                *
*  VIEW QUE CALCULA A DIFERENCA DE DATA DE ABERTURA E FECHAMENTO DE UMA OCORRENCIA DE UMA CORRECAO LEVANDO EM CO *
* TA APENAS A OCRRENCIA PAI NA TABELA OCORRENCIAS_OCORRENCIA                                                     *
*                                                                                                                *
* BANCO_SISTEMA : ENCCEJA                                                                                        *
* CRIADO POR    : WEMERSON BITTORI MADURO                                                        DATA:26/09/2018 *
* ALTERADO POR  : WEMERSON BITTORI MADURO                                                        DATA:26/09/2018 *
******************************************************************************************************************/

CREATE OR ALTER    view [dbo].[VW_TEMPO_TOTAL_OCORRENCIA_POR_CORRECAO_ID] as
SELECT correcao_id, id_projeto, SUM(DATEDIFF(minute, data_solicitacao, data_resposta)) AS DIFERENCA  
  FROM dbo.ocorrencias_ocorrencia  
 WHERE (data_resposta IS NOT NULL) AND (data_solicitacao IS NOT NULL)  and 
       isnull(ocorrencia_pai_id, 0) <> id
GROUP BY correcao_id, id_projeto 


GO
/****** Object:  View [dbo].[vw_todas_as_filas]    Script Date: 22/11/2019 11:44:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER    VIEW [dbo].[vw_todas_as_filas]
AS

select co_barra_redacao from correcoes_fila1 union all 
select co_barra_redacao from correcoes_fila2 union all
select co_barra_redacao from correcoes_fila3 union all 
select co_barra_redacao from correcoes_fila4 union all 
select co_barra_redacao from correcoes_filapessoal union all 
select co_barra_redacao from correcoes_filaauditoria 

GO
/****** Object:  View [dbo].[vw_total_ocorrencias_pendentes]    Script Date: 22/11/2019 11:44:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER    view [dbo].[vw_total_ocorrencias_pendentes]
as
select b.id, polo.descricao as polo, time.descricao as time, b.last_name as nome, total from (
select usuario_responsavel_id, count(*) as total from ocorrencias_ocorrencia a
where status_id = 1
group by usuario_responsavel_id
) a
join auth_user b on a.usuario_responsavel_id = b.id
left outer join usuarios_hierarquia_usuarios c on c.user_id = b.id
left outer join usuarios_hierarquia time on c.hierarquia_id = time.id
left outer join usuarios_hierarquia polo on time.id_hierarquia_usuario_pai = polo.id

GO
/****** Object:  View [dbo].[vw_uitl_server_params]    Script Date: 22/11/2019 11:44:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER    view [dbo].[vw_uitl_server_params] as
SELECT 
    [name],
    [value],
    [description]
FROM 
    sys.configurations
WHERE 
    [name] IN ( 'max degree of parallelism', 'cost threshold for parallelism', 'min server memory (MB)',
                'max server memory (MB)', 'clr enabled', 'xp_cmdshell', 'Ole Automation Procedures',
                'user connections', 'fill factor (%)', 'cross db ownership chaining', 'remote access',
                'default trace enabled', 'external scripts enabled', 'Database Mail XPs', 'Ad Hoc Distributed Queries',
                'SMO and DMO XPs', 'clr strict security', 'remote admin connections'
              )

GO
/****** Object:  View [dbo].[vw_usuario_hierarquia]    Script Date: 22/11/2019 11:44:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER      VIEW [dbo].[vw_usuario_hierarquia]
AS
    SELECT pes.usuario_id,
            pes.nome,
            hie.id,
            hierarquia = hie.descricao,
            hie.id_usuario_responsavel,
            RESPONSAVEL = RES.nome,
            ID_HIERARQUIA = HIE.id,
            COR.MAX_CORRECOES_DIA,
            COR.ID_GRUPO,
            COR.PODE_CORRIGIR_1,
            COR.PODE_CORRIGIR_2,
            COR.PODE_CORRIGIR_3,
            COR.STATUS_Id,
            hie.indice,
            ppu.projeto_id,
            hie.id_tipo_hierarquia_usuario,
            hie.id_hierarquia_usuario_pai,
            [time].id AS time_id,
            polo.id AS polo_id,
            fgv.id AS fgv_id,
            geral.id AS geral_id,
            [time].descricao AS time_descricao,
            polo.descricao AS polo_descricao,
            fgv.descricao AS fgv_descricao,
            geral.descricao AS geral_descricao,
            [time].indice AS time_indice,
            polo.indice AS polo_indice,
            fgv.indice AS fgv_indice,
            geral.indice AS geral_indice,
            perfil = grp.name
     FROM usuarios_pessoa pes
         INNER JOIN usuarios_hierarquia_usuarios hieUsu WITH(NOLOCK)
                   ON(pes.usuario_id = hieUsu.user_id)
         INNER JOIN usuarios_hierarquia hie WITH(NOLOCK)
                   ON(hie.id = hieUsu.hierarquia_id)
         INNER JOIN usuarios_pessoa RES WITH(NOLOCK)
                   ON(RES.USUARIO_ID = HIE.id_usuario_responsavel)
         INNER JOIN projeto_projeto_usuarios ppu WITH(NOLOCK)
                   ON(res.usuario_id = ppu.user_id)
         INNER JOIN usuarios_hierarquia [time] WITH(NOLOCK)
                   ON [time].id = hieUsu.hierarquia_id
          LEFT JOIN CORRECOES_CORRETOR COR WITH(NOLOCK)
                   ON(COR.ID = PES.USUARIO_ID)
          LEFT JOIN usuarios_hierarquia polo WITH(NOLOCK)
                   ON polo.id = [time].id_hierarquia_usuario_pai
          LEFT JOIN usuarios_hierarquia fgv WITH(NOLOCK)
                   ON fgv.id = polo.id_hierarquia_usuario_pai
          LEFT JOIN usuarios_hierarquia geral WITH(NOLOCK)
                   ON geral.id = fgv.id_hierarquia_usuario_pai
          LEFT JOIN auth_user_groups gup WITH(NOLOCK)
                   ON(gup.user_id = pes.usuario_id)
          LEFT JOIN auth_group grp WITH(NOLOCK)
                   ON(grp.id = gup.group_id);

GO
/****** Object:  View [dbo].[vw_usuario_hierarquia_completa]    Script Date: 22/11/2019 11:44:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER       view [dbo].[vw_usuario_hierarquia_completa] as
select a.usuario_id, a.nome, [time].id as time_id, polo.id as polo_id, fgv.id as fgv_id, geral.id as geral_id,
       [time].descricao as time_descricao, polo.descricao as polo_descricao, fgv.descricao as fgv_descricao, geral.descricao as geral_descricao,
       [time].indice as time_indice, polo.indice as polo_indice, fgv.indice as fgv_indice, geral.indice as geral_indice
  from usuarios_pessoa a with (nolock)
       inner join usuarios_hierarquia_usuarios b with (nolock) on b.user_id = a.usuario_id
       inner join usuarios_hierarquia as [time] with (nolock) on [time].id = b.hierarquia_id
       inner join usuarios_hierarquia as polo with (nolock) on polo.id = [time].id_hierarquia_usuario_pai
       inner join usuarios_hierarquia as fgv with (nolock) on fgv.id = polo.id_hierarquia_usuario_pai
       inner join usuarios_hierarquia as geral with (nolock) on geral.id = fgv.id_hierarquia_usuario_pai

GO
/****** Object:  View [dbo].[vw_usuario_hierarquia_completa_para_vw_avaliadores]    Script Date: 22/11/2019 11:44:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER    view [dbo].[vw_usuario_hierarquia_completa_para_vw_avaliadores] as 
select a.usuario_id, a.nome, [time].id as time_id, polo.id as polo_id, fgv.id as fgv_id, geral.id as geral_id,
       [time].descricao as time_descricao, polo.descricao as polo_descricao, fgv.descricao as fgv_descricao, geral.descricao as geral_descricao,
       [time].indice as time_indice, polo.indice as polo_indice, fgv.indice as fgv_indice, geral.indice as geral_indice
  from usuarios_pessoa a
       inner join usuarios_hierarquia_usuarios b on b.user_id = a.usuario_id
       inner join usuarios_hierarquia as [time] on [time].id = b.hierarquia_id
       inner join usuarios_hierarquia as polo on polo.id = [time].id_hierarquia_usuario_pai
       inner join usuarios_hierarquia as fgv on fgv.id = polo.id_hierarquia_usuario_pai
       inner join usuarios_hierarquia as geral on geral.id = fgv.id_hierarquia_usuario_pai
union
select a.usuario_id, a.nome, null as time_id, polo.id as polo_id, fgv.id as fgv_id, geral.id as geral_id,
       null as time_descricao, polo.descricao as polo_descricao, fgv.descricao as fgv_descricao, geral.descricao as geral_descricao,
       null as time_indice, polo.indice as polo_indice, fgv.indice as fgv_indice, geral.indice as geral_indice
  from usuarios_pessoa a
       inner join usuarios_hierarquia_usuarios b on b.user_id = a.usuario_id
       inner join usuarios_hierarquia as polo on polo.id = b.hierarquia_id
       inner join usuarios_hierarquia as fgv on fgv.id = polo.id_hierarquia_usuario_pai
       inner join usuarios_hierarquia as geral on geral.id = fgv.id_hierarquia_usuario_pai
 where polo.id_tipo_hierarquia_usuario = 3
union
 select a.usuario_id, a.nome, null as time_id, null as polo_id, fgv.id as fgv_id, geral.id as geral_id,
       null as time_descricao, null as polo_descricao, fgv.descricao as fgv_descricao, geral.descricao as geral_descricao,
       null as time_indice, null as polo_indice, fgv.indice as fgv_indice, geral.indice as geral_indice
  from usuarios_pessoa a
       inner join usuarios_hierarquia_usuarios b on b.user_id = a.usuario_id
       inner join usuarios_hierarquia as fgv on fgv.id = b.hierarquia_id
       inner join usuarios_hierarquia as geral on geral.id = fgv.id_hierarquia_usuario_pai
 where fgv.id_tipo_hierarquia_usuario = 2
union
 select a.usuario_id, a.nome, null as time_id, null as polo_id, null as fgv_id, geral.id as geral_id,
       null as time_descricao, null as polo_descricao, null as fgv_descricao, geral.descricao as geral_descricao,
       null as time_indice, null as polo_indice, null as fgv_indice, geral.indice as geral_indice
  from usuarios_pessoa a
       inner join usuarios_hierarquia_usuarios b on b.user_id = a.usuario_id
       inner join usuarios_hierarquia as geral on geral.id = b.hierarquia_id
 where geral.id_tipo_hierarquia_usuario = 1

GO
/****** Object:  View [dbo].[vw_usuario_perfil]    Script Date: 22/11/2019 11:44:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER    VIEW [dbo].[vw_usuario_perfil]
AS
SELECT        a.usuario_id, a.nome, time.id AS time_id, polo.id AS polo_id, fgv.id AS fgv_id, geral.id AS geral_id, time.descricao AS time_descricao, polo.descricao AS polo_descricao, fgv.descricao AS fgv_descricao, 
                         geral.descricao AS geral_descricao, time.indice AS time_indice, polo.indice AS polo_indice, fgv.indice AS fgv_indice, geral.indice AS geral_indice, dbo.auth_group.name
FROM            dbo.auth_group INNER JOIN
                         dbo.auth_user_groups ON dbo.auth_group.id = dbo.auth_user_groups.group_id RIGHT OUTER JOIN
                         dbo.usuarios_pessoa AS a INNER JOIN
                         dbo.usuarios_hierarquia_usuarios AS b ON b.user_id = a.usuario_id INNER JOIN
                         dbo.usuarios_hierarquia AS time ON time.id = b.hierarquia_id INNER JOIN
                         dbo.usuarios_hierarquia AS polo ON polo.id = time.id_hierarquia_usuario_pai INNER JOIN
                         dbo.usuarios_hierarquia AS fgv ON fgv.id = polo.id_hierarquia_usuario_pai INNER JOIN
                         dbo.usuarios_hierarquia AS geral ON geral.id = fgv.id_hierarquia_usuario_pai ON dbo.auth_user_groups.user_id = a.id

GO
/****** Object:  View [dbo].[vw_usuarios]    Script Date: 22/11/2019 11:44:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER    view [dbo].[vw_usuarios] as
select g.id as group_id, g.name as group_name, a.usuario_id, a.nome, h1.id as time_id, h2.id as polo_id, h3.id as fgv_id, h4.id as geral_id,
       h1.descricao as time_descricao, h2.descricao as polo_descricao, h3.descricao as fgv_descricao, h4.descricao as geral_descricao,
       h1.indice as time_indice, h2.indice as polo_indice, h3.indice as fgv_indice, h4.indice as geral_indice
  from usuarios_pessoa a with (nolock)
       inner join auth_user_groups ug on ug.user_id = a.usuario_id
       inner join auth_group g on g.id = ug.group_id and g.id in (26, 34)
       inner join usuarios_hierarquia_usuarios b with (nolock) on b.user_id = a.usuario_id
       inner join usuarios_hierarquia as h1 with (nolock) on h1.id = b.hierarquia_id
       inner join usuarios_hierarquia as h2 with (nolock) on h2.id = h1.id_hierarquia_usuario_pai
       inner join usuarios_hierarquia as h3 with (nolock) on h3.id = h2.id_hierarquia_usuario_pai
       inner join usuarios_hierarquia as h4 with (nolock) on h4.id = h3.id_hierarquia_usuario_pai
union all
select g.id as group_id, g.name as group_name, a.usuario_id, a.nome, h1.id as time_id, h2.id as polo_id, h3.id as fgv_id, h4.id as geral_id,
       h1.descricao as time_descricao, h2.descricao as polo_descricao, h3.descricao as fgv_descricao, h4.descricao as geral_descricao,
       h1.indice as time_indice, h2.indice as polo_indice, h3.indice as fgv_indice, h4.indice as geral_indice
  from usuarios_pessoa a with (nolock)
       inner join auth_user_groups ug on ug.user_id = a.usuario_id
       inner join auth_group g on g.id = ug.group_id and g.id in (25)
       inner join usuarios_hierarquia_usuarios b with (nolock) on b.user_id = a.usuario_id
       inner join usuarios_hierarquia as h1 with (nolock) on h1.id_usuario_responsavel = b.user_id
       inner join usuarios_hierarquia as h2 with (nolock) on h2.id = b.hierarquia_id
       inner join usuarios_hierarquia as h3 with (nolock) on h3.id = h2.id_hierarquia_usuario_pai
       inner join usuarios_hierarquia as h4 with (nolock) on h4.id = h3.id_hierarquia_usuario_pai
union all
select g.id as group_id, g.name as group_name, a.usuario_id, a.nome, null as time_id, h2.id as polo_id, h3.id as fgv_id, h4.id as geral_id,
       null as time_descricao, h2.descricao as polo_descricao, h3.descricao as fgv_descricao, h4.descricao as geral_descricao,
       null as time_indice, h2.indice as polo_indice, h3.indice as fgv_indice, h4.indice as geral_indice
  from usuarios_pessoa a with (nolock)
       inner join auth_user_groups ug on ug.user_id = a.usuario_id
       inner join auth_group g on g.id = ug.group_id and g.id in (30,31)
       inner join usuarios_hierarquia_usuarios b with (nolock) on b.user_id = a.usuario_id
       inner join usuarios_hierarquia as h2 with (nolock) on h2.id_usuario_responsavel = b.user_id
       inner join usuarios_hierarquia as h3 with (nolock) on h3.id = b.hierarquia_id
       inner join usuarios_hierarquia as h4 with (nolock) on h4.id = h3.id_hierarquia_usuario_pai
union all
select g.id as group_id, g.name as group_name, a.usuario_id, a.nome, null as time_id, null as polo_id, h3.id as fgv_id, h4.id as geral_id,
       null as time_descricao, null as polo_descricao, h3.descricao as fgv_descricao, h4.descricao as geral_descricao,
       null as time_indice, null as polo_indice, h3.indice as fgv_indice, h4.indice as geral_indice
  from usuarios_pessoa a with (nolock)
       inner join auth_user_groups ug on ug.user_id = a.usuario_id
       inner join auth_group g on g.id = ug.group_id and g.id in (29)
       inner join usuarios_hierarquia_usuarios b with (nolock) on b.user_id = a.usuario_id
       inner join usuarios_hierarquia as h3 with (nolock) on h3.id_usuario_responsavel = b.user_id
       inner join usuarios_hierarquia as h4 with (nolock) on h4.id = b.hierarquia_id
union all
select g.id as group_id, g.name as group_name, a.usuario_id, a.nome, null as time_id, null as polo_id, null as fgv_id, h4.id as geral_id,
       null as time_descricao, null as polo_descricao, null as fgv_descricao, h4.descricao as geral_descricao,
       null as time_indice, null as polo_indice, null as fgv_indice, h4.indice as geral_indice
  from usuarios_pessoa a with (nolock)
       inner join auth_user_groups ug on ug.user_id = a.usuario_id
       inner join auth_group g on g.id = ug.group_id
       inner join usuarios_hierarquia as h4 with (nolock) on h4.id_usuario_responsavel = ug.user_id
 where not exists (select top 1 1 from usuarios_hierarquia_usuarios b where b.user_id = a.usuario_id)​
union all
select g.id as group_id, g.name as group_name, a.usuario_id, a.nome, null as time_id, null as polo_id, null as fgv_id, null as geral_id,
       null as time_descricao, null as polo_descricao, null as fgv_descricao, null as geral_descricao,
       null as time_indice, null as polo_indice, null as fgv_indice, null as geral_indice
  from usuarios_pessoa a with (nolock)
       inner join auth_user_groups ug on ug.user_id = a.usuario_id
       inner join auth_group g on g.id = ug.group_id
 where not exists (select top 1 1 from usuarios_hierarquia_usuarios b where b.user_id = a.usuario_id)
   and not exists (select top 1 1 from usuarios_hierarquia h where h.id_usuario_responsavel = ug.user_id)

GO
/****** Object:  View [dbo].[vw_usuarios_hierarquia_para_vw_avaliadores]    Script Date: 22/11/2019 11:44:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER    view [dbo].[vw_usuarios_hierarquia_para_vw_avaliadores] as 
select a.usuario_id, a.nome, [time].id as time_id, polo.id as polo_id, fgv.id as fgv_id, geral.id as geral_id,
       [time].descricao as time_descricao, polo.descricao as polo_descricao, fgv.descricao as fgv_descricao, geral.descricao as geral_descricao,
       [time].indice as time_indice, polo.indice as polo_indice, fgv.indice as fgv_indice, geral.indice as geral_indice, time.indice as indice
  from usuarios_pessoa a
       inner join usuarios_hierarquia_usuarios b on b.user_id = a.usuario_id
       inner join usuarios_hierarquia as [time] on [time].id = b.hierarquia_id
       inner join usuarios_hierarquia as polo on polo.id = [time].id_hierarquia_usuario_pai
       inner join usuarios_hierarquia as fgv on fgv.id = polo.id_hierarquia_usuario_pai
       inner join usuarios_hierarquia as geral on geral.id = fgv.id_hierarquia_usuario_pai
union
select a.usuario_id, a.nome, responsavel.id as time_id, polo.id as polo_id, fgv.id as fgv_id, geral.id as geral_id,
       responsavel.descricao time_descricao, polo.descricao as polo_descricao, fgv.descricao as fgv_descricao, geral.descricao as geral_descricao,
       null as time_indice, polo.indice as polo_indice, fgv.indice as fgv_indice, geral.indice as geral_indice, polo.indice as indice
  from usuarios_pessoa a
       inner join usuarios_hierarquia_usuarios b on b.user_id = a.usuario_id
       inner join usuarios_hierarquia as polo on polo.id = b.hierarquia_id
       inner join usuarios_hierarquia as fgv on fgv.id = polo.id_hierarquia_usuario_pai
       inner join usuarios_hierarquia as geral on geral.id = fgv.id_hierarquia_usuario_pai
       inner join usuarios_hierarquia as responsavel on responsavel.id_usuario_responsavel = a.usuario_id
 where polo.id_tipo_hierarquia_usuario = 3
union
 select a.usuario_id, a.nome, null as time_id, null as polo_id, fgv.id as fgv_id, geral.id as geral_id,
       null as time_descricao, null as polo_descricao, fgv.descricao as fgv_descricao, geral.descricao as geral_descricao,
       null as time_indice, null as polo_indice, fgv.indice as fgv_indice, geral.indice as geral_indice, fgv.indice as indice
  from usuarios_pessoa a
       inner join usuarios_hierarquia_usuarios b on b.user_id = a.usuario_id
       inner join usuarios_hierarquia as fgv on fgv.id = b.hierarquia_id
       inner join usuarios_hierarquia as geral on geral.id = fgv.id_hierarquia_usuario_pai
 where fgv.id_tipo_hierarquia_usuario = 2
union
 select a.usuario_id, a.nome, null as time_id, responsavel.id as polo_id, null as fgv_id, geral.id as geral_id,
       null as time_descricao, responsavel.descricao as polo_descricao, null as fgv_descricao, geral.descricao as geral_descricao,
       null as time_indice, null as polo_indice, null as fgv_indice, geral.indice as geral_indice, geral.indice as indice
  from usuarios_pessoa a
       inner join usuarios_hierarquia_usuarios b on b.user_id = a.usuario_id
       inner join usuarios_hierarquia as geral on geral.id = b.hierarquia_id
       inner join usuarios_hierarquia as responsavel on responsavel.id_usuario_responsavel = a.usuario_id
 where geral.id_tipo_hierarquia_usuario = 1

GO
/****** Object:  View [dbo].[vw_util_current_queries]    Script Date: 22/11/2019 11:44:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER    view [dbo].[vw_util_current_queries] as
SELECT
    RIGHT('00' + CAST(DATEDIFF(SECOND, COALESCE(B.start_time, A.login_time), GETDATE()) / 86400 AS VARCHAR), 2) + ' ' + 
    RIGHT('00' + CAST((DATEDIFF(SECOND, COALESCE(B.start_time, A.login_time), GETDATE()) / 3600) % 24 AS VARCHAR), 2) + ':' + 
    RIGHT('00' + CAST((DATEDIFF(SECOND, COALESCE(B.start_time, A.login_time), GETDATE()) / 60) % 60 AS VARCHAR), 2) + ':' + 
    RIGHT('00' + CAST(DATEDIFF(SECOND, COALESCE(B.start_time, A.login_time), GETDATE()) % 60 AS VARCHAR), 2) + '.' + 
    RIGHT('000' + CAST(DATEDIFF(SECOND, COALESCE(B.start_time, A.login_time), GETDATE()) AS VARCHAR), 3) 
    AS Duration,
    A.session_id AS session_id,
    B.command,
    CAST('<?query --' + CHAR(10) + (
        SELECT TOP 1 SUBSTRING(X.[text], B.statement_start_offset / 2 + 1, ((CASE
                                                                          WHEN B.statement_end_offset = -1 THEN (LEN(CONVERT(NVARCHAR(MAX), X.[text])) * 2)
                                                                          ELSE B.statement_end_offset
                                                                      END
                                                                     ) - B.statement_start_offset
                                                                    ) / 2 + 1
                     )
    ) + CHAR(10) + '--?>' AS XML) AS sql_text,
    CAST('<?query --' + CHAR(10) + X.[text] + CHAR(10) + '--?>' AS XML) AS sql_command,
    A.login_name,
    '(' + CAST(COALESCE(E.wait_duration_ms, B.wait_time) AS VARCHAR(20)) + 'ms)' + COALESCE(E.wait_type, B.wait_type) + COALESCE((CASE 
        WHEN COALESCE(E.wait_type, B.wait_type) LIKE 'PAGEIOLATCH%' THEN ':' + DB_NAME(LEFT(E.resource_description, CHARINDEX(':', E.resource_description) - 1)) + ':' + SUBSTRING(E.resource_description, CHARINDEX(':', E.resource_description) + 1, 999)
        WHEN COALESCE(E.wait_type, B.wait_type) = 'OLEDB' THEN '[' + REPLACE(REPLACE(E.resource_description, ' (SPID=', ':'), ')', '') + ']'
        ELSE ''
    END), '') AS wait_info,
    COALESCE(B.cpu_time, 0) AS CPU,
    COALESCE(F.tempdb_allocations, 0) AS tempdb_allocations,
    COALESCE((CASE WHEN F.tempdb_allocations > F.tempdb_current THEN F.tempdb_allocations - F.tempdb_current ELSE 0 END), 0) AS tempdb_current,
    COALESCE(B.logical_reads, 0) AS reads,
    COALESCE(B.writes, 0) AS writes,
    COALESCE(B.reads, 0) AS physical_reads,
    COALESCE(B.granted_query_memory, 0) AS used_memory,
    NULLIF(B.blocking_session_id, 0) AS blocking_session_id,
    COALESCE(G.blocked_session_count, 0) AS blocked_session_count,
    'KILL ' + CAST(A.session_id AS VARCHAR(10)) AS kill_command,
    (CASE 
        WHEN B.[deadlock_priority] <= -5 THEN 'Low'
        WHEN B.[deadlock_priority] > -5 AND B.[deadlock_priority] < 5 AND B.[deadlock_priority] < 5 THEN 'Normal'
        WHEN B.[deadlock_priority] >= 5 THEN 'High'
    END) + ' (' + CAST(B.[deadlock_priority] AS VARCHAR(3)) + ')' AS [deadlock_priority],
    B.row_count,
    B.open_transaction_count,
    (CASE B.transaction_isolation_level
        WHEN 0 THEN 'Unspecified' 
        WHEN 1 THEN 'ReadUncommitted' 
        WHEN 2 THEN 'ReadCommitted' 
        WHEN 3 THEN 'Repeatable' 
        WHEN 4 THEN 'Serializable' 
        WHEN 5 THEN 'Snapshot'
    END) AS transaction_isolation_level,
    A.[status],
    NULLIF(B.percent_complete, 0) AS percent_complete,
    A.[host_name],
    COALESCE(DB_NAME(CAST(B.database_id AS VARCHAR)), 'master') AS [database_name],
    A.[program_name],
    H.[name] AS resource_governor_group,
    COALESCE(B.start_time, A.last_request_end_time) AS start_time,
    A.login_time,
    COALESCE(B.request_id, 0) AS request_id,
    W.query_plan
FROM
    sys.dm_exec_sessions AS A WITH (NOLOCK)
    LEFT JOIN sys.dm_exec_requests AS B WITH (NOLOCK) ON A.session_id = B.session_id
    JOIN sys.dm_exec_connections AS C WITH (NOLOCK) ON A.session_id = C.session_id AND A.endpoint_id = C.endpoint_id
    LEFT JOIN (
        SELECT
            session_id, 
            wait_type,
            wait_duration_ms,
            resource_description,
            ROW_NUMBER() OVER(PARTITION BY session_id ORDER BY (CASE WHEN wait_type LIKE 'PAGEIO%' THEN 0 ELSE 1 END), wait_duration_ms) AS Ranking
        FROM 
            sys.dm_os_waiting_tasks
    ) E ON A.session_id = E.session_id AND E.Ranking = 1
    LEFT JOIN (
        SELECT
            session_id,
            request_id,
            SUM(internal_objects_alloc_page_count + user_objects_alloc_page_count) AS tempdb_allocations,
            SUM(internal_objects_dealloc_page_count + user_objects_dealloc_page_count) AS tempdb_current
        FROM
            sys.dm_db_task_space_usage
        GROUP BY
            session_id,
            request_id
    ) F ON B.session_id = F.session_id AND B.request_id = F.request_id
    LEFT JOIN (
        SELECT 
            blocking_session_id,
            COUNT(*) AS blocked_session_count
        FROM 
            sys.dm_exec_requests
        WHERE 
            blocking_session_id != 0
        GROUP BY
            blocking_session_id
    ) G ON A.session_id = G.blocking_session_id
    OUTER APPLY sys.dm_exec_sql_text(COALESCE(B.[sql_handle], C.most_recent_sql_handle)) AS X
    OUTER APPLY sys.dm_exec_query_plan(B.[plan_handle]) AS W
    LEFT JOIN sys.dm_resource_governor_workload_groups H ON A.group_id = H.group_id
WHERE
    A.session_id > 50
    AND A.session_id <> @@SPID
    AND (A.[status] != 'sleeping' OR (A.[status] = 'sleeping' AND B.open_transaction_count > 0))

GO
/****** Object:  View [dbo].[vw_util_indexes_to_compact]    Script Date: 22/11/2019 11:44:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER    view [dbo].[vw_util_indexes_to_compact] as
SELECT DISTINCT 
    C.[name] AS [Schema],
    A.[name] AS Tabela,
    NULL AS Indice,
    'ALTER TABLE [' + C.[name] + '].[' + A.[name] + '] REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE)' AS Comando
FROM 
    sys.tables                   A
    INNER JOIN sys.partitions    B   ON A.[object_id] = B.[object_id]
    INNER JOIN sys.schemas       C   ON A.[schema_id] = C.[schema_id]
WHERE 
    B.data_compression_desc = 'NONE'
    AND B.index_id = 0 -- HEAP
    AND A.[type] = 'U'
    
UNION
 
SELECT DISTINCT 
    C.[name] AS [Schema],
    B.[name] AS Tabela,
    A.[name] AS Indice,
    'ALTER INDEX [' + A.[name] + '] ON [' + C.[name] + '].[' + B.[name] + '] REBUILD PARTITION = ALL WITH ( STATISTICS_NORECOMPUTE = OFF, ONLINE = OFF, SORT_IN_TEMPDB = OFF, DATA_COMPRESSION = PAGE)'
FROM 
    sys.indexes                  A
    INNER JOIN sys.tables        B   ON A.[object_id] = B.[object_id]
    INNER JOIN sys.schemas       C   ON B.[schema_id] = C.[schema_id]
    INNER JOIN sys.partitions    D   ON A.[object_id] = D.[object_id] AND A.index_id = D.index_id
WHERE
    D.data_compression_desc =  'NONE'
    AND D.index_id <> 0
    AND A.[type] IN (1, 2) -- CLUSTERED e NONCLUSTERED (Rowstore)
    AND B.[type] = 'U'

GO
/****** Object:  View [dbo].[vw_util_list_locks]    Script Date: 22/11/2019 11:44:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER    view [dbo].[vw_util_list_locks] as
SELECT
    A.request_session_id AS session_id,
    COALESCE(G.start_time, F.last_request_start_time) AS start_time,
    COALESCE(G.open_transaction_count, F.open_transaction_count) AS open_transaction_count,
    A.resource_database_id,
    DB_NAME(A.resource_database_id) AS dbname,
    (CASE WHEN A.resource_type = 'OBJECT' THEN D.[name] ELSE E.[name] END) AS ObjectName,
    (CASE WHEN A.resource_type = 'OBJECT' THEN D.is_ms_shipped ELSE E.is_ms_shipped END) AS is_ms_shipped,
    --B.index_id,
    --C.[name] AS index_name,
    --A.resource_type,
    --A.resource_description,
    --A.resource_associated_entity_id,
    A.request_mode,
    A.request_status,
    F.login_name,
    F.[program_name],
    F.[host_name],
    G.blocking_session_id
FROM
    sys.dm_tran_locks A WITH(NOLOCK)
    LEFT JOIN sys.partitions B WITH(NOLOCK) ON B.hobt_id = A.resource_associated_entity_id
    LEFT JOIN sys.indexes C WITH(NOLOCK) ON C.[object_id] = B.[object_id] AND C.index_id = B.index_id
    LEFT JOIN sys.objects D WITH(NOLOCK) ON A.resource_associated_entity_id = D.[object_id]
    LEFT JOIN sys.objects E WITH(NOLOCK) ON B.[object_id] = E.[object_id]
    LEFT JOIN sys.dm_exec_sessions F WITH(NOLOCK) ON A.request_session_id = F.session_id
    LEFT JOIN sys.dm_exec_requests G WITH(NOLOCK) ON A.request_session_id = G.session_id
WHERE
    A.resource_associated_entity_id > 0
    AND A.resource_database_id = DB_ID()
    AND A.resource_type = 'OBJECT'
    AND (CASE WHEN A.resource_type = 'OBJECT' THEN D.is_ms_shipped ELSE E.is_ms_shipped END) = 0

GO
/****** Object:  View [dbo].[VwOcorrencia]    Script Date: 22/11/2019 11:44:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER    VIEW [dbo].[VwOcorrencia]
AS
SELECT
     ocorrencia.id,
     ocorrencia.usuario_autor_id AS usuario_autor,
     ocorrencia.usuario_responsavel_id AS usuario_responsavel,
     ocorrencia.categoria_id,
     ocorrencia.situacao_id,
     ocorrencia.tipo_id,
     ocorrencia.status_id,
     ocorrencia.data_solicitacao,
     ocorrencia.data_resposta,
     ocorrencia.pergunta,
     ocorrencia.resposta,
     ocorrencia.correcao_id,
     ocorrencia.dados_correcao,
     ocorrencia.competencia1,
     ocorrencia.competencia2,
     ocorrencia.competencia3,
     ocorrencia.competencia4,
     ocorrencia.competencia5,
     pessoa1.nome AS nome_responsavel,
     pessoa2.nome AS nome_autor,
     categoria.descricao AS categoria_descricao,
     situacao.descricao AS situacao_descricao,
     status.descricao AS status_descricao,
     status.icone AS status_icone,
     status.classe AS status_classe,
     tipo.descricao AS tipo_descricao
FROM usuarios_pessoa pessoa1,
     usuarios_pessoa pessoa2,
     ocorrencias_ocorrencia ocorrencia,
     ocorrencias_categoria categoria,
     ocorrencias_situacao situacao,
     ocorrencias_status status,
     ocorrencias_tipo tipo
WHERE pessoa1.usuario_id = ocorrencia.usuario_responsavel_id
AND pessoa2.usuario_id = ocorrencia.usuario_autor_id
AND status.id = ocorrencia.status_id
AND situacao.id = ocorrencia.situacao_id
AND tipo.id = ocorrencia.tipo_id
AND categoria.id = ocorrencia.categoria_id;

GO
