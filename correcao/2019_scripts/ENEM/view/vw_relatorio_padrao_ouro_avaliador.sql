 ALTER VIEW vw_relatorio_padrao_ouro_avaliador
 AS
SELECT
  1 AS id,
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