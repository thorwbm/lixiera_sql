/****** Object:  View [dbo].[vw_relatorio_terceira_correcao_avaliador_para_time]    Script Date: 04/10/2019 10:16:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   VIEW [dbo].[vw_relatorio_terceira_correcao_avaliador_para_time] as
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
  from correcoes_correcao2019 a
       inner join correcoes_redacao2019 b on a.co_barra_redacao = b.co_barra_redacao
       inner join vw_usuario_hierarquia_completa c on c.usuario_id = a.id_corretor
       inner join correcoes_situacao e on e.id = a.id_correcao_situacao
	   inner join usuarios_hierarquia g on g.id = c.time_id
	   left  join correcoes_analise2019  ana on (ana.co_barra_redacao = a.co_barra_redacao and
	                                         ana.id_projeto       = a.id_projeto and
											 ana.id_tipo_correcao_A = 3 and
											 ana.id_tipo_correcao_B = 4)
       left outer join correcoes_correcao2019 d on d.co_barra_redacao = b.co_barra_redacao and d.id_tipo_correcao = 4
       left outer join correcoes_situacao f on f.id = d.id_correcao_situacao
 where a.id_tipo_correcao = 3
   and a.id_status = 3
   and exists (select top 1 1 from correcoes_analise2019 x where x.id_correcao_B = a.id)

GO
