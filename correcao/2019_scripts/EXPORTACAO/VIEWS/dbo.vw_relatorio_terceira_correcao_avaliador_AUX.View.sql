/****** Object:  View [dbo].[vw_relatorio_terceira_correcao_avaliador_AUX]    Script Date: 04/10/2019 10:16:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE    VIEW [dbo].[vw_relatorio_terceira_correcao_avaliador_AUX] as
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
