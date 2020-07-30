ALTER  VIEW [dbo].[vw_relatorio_terceira_correcao_avaliador_para_time] as
SELECT
	1 AS id,
	a.id AS id_correcao,
	a.id_corretor,
	c.nome,
	b.id AS redacao,
	a.competencia1 AS terceira_c1,
	a.competencia2 AS terceira_c2,
	a.competencia3 AS terceira_c3,
	a.competencia4 AS terceira_c4,
	a.competencia5 AS terceira_c5,
	a.nota_final AS terceira_soma,
	e.sigla AS terceira_situacao,
	d.competencia1 AS quarta_c1,
	d.competencia2 AS quarta_c2,
	d.competencia3 AS quarta_c3,
	d.competencia4 AS quarta_c4,
	d.competencia5 AS quarta_c5,
	d.nota_final AS quarta_soma,
	f.sigla AS quarta_situacao,
	a.data_termino AS data,
	aproveitamento =
					CASE
						WHEN ana.conclusao_analise > 2 THEN 0
						WHEN ana.conclusao_analise >= 0 THEN 1
						ELSE NULL
					END,
	c.time_id,
	c.polo_id,
	c.fgv_id,
	c.geral_id,
	c.time_descricao,
	c.polo_descricao,
	c.fgv_descricao,
	c.geral_descricao,
	c.time_indice,
	c.polo_indice,
	c.fgv_indice,
	c.geral_indice,
	a.co_barra_redacao,
	g.id_hierarquia_usuario_pai,
	g.id_tipo_hierarquia_usuario,
	b.id AS REDACAO_ID
FROM correcoes_correcao a INNER JOIN correcoes_redacao              b   WITH(NOLOCK) ON (a.redacao_id = b.ID)
                          INNER JOIN vw_usuario_hierarquia_completa c   WITH(NOLOCK) ON (c.usuario_id = a.id_corretor)
                          INNER JOIN correcoes_situacao             e   WITH(NOLOCK) ON (e.id = a.id_correcao_situacao)
                          INNER JOIN usuarios_hierarquia            g   WITH(NOLOCK) ON (g.id = c.time_id)
                          LEFT JOIN correcoes_analise               ana WITH(NOLOCK) ON (ana.redacao_id = b.ID AND
	                                                                                     ana.id_projeto = a.id_projeto AND
	                                                                                     ana.id_tipo_correcao_A = 3 AND
	                                                                                     ana.id_tipo_correcao_B = 4)
                         LEFT OUTER JOIN correcoes_correcao         d   WITH(NOLOCK) ON (d.redacao_id = b.ID AND 
						                                                                 d.id_tipo_correcao = 4)
                         LEFT OUTER JOIN correcoes_situacao         f   WITH(NOLOCK) ON (f.id = d.id_correcao_situacao)
WHERE a.id_tipo_correcao = 3
      AND a.id_status = 3
      AND EXISTS (SELECT TOP 1 1 FROM correcoes_analise x
      	         WHERE x.id_correcao_B = a.id)