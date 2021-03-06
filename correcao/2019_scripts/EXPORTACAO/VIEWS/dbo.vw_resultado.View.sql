/****** Object:  View [dbo].[vw_resultado]    Script Date: 04/10/2019 10:16:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   view [dbo].[vw_resultado] as
select cor.data_termino, cor.id_corretor, tipo.descricao, cor.nota_final as nota_final_correcao, cor.nota_competencia1, cor.nota_competencia2, cor.nota_competencia3, cor.nota_competencia4, cor.nota_competencia5, competencia5, cor_sit.sigla as situacao_correcao,
       red.nota_final as nota_final_redacao, red_sit.sigla as situacao_redacao, n59.nota_final as nota_final_n59, n59.id_correcao_situacao as situacao_n59,
	   red.id as mascara, left(n02.co_inscricao, 12) as co_inscricao, red.co_barra_redacao, n02.no_inscrito as nome_participante, n02.NO_MUNICIPIO_PROVA, n02.SG_UF_PROVA
  from correcoes_correcao cor 
       inner join correcoes_redacao red on red.co_barra_redacao = cor.co_barra_redacao
	   inner join inep.inep_n02 n02 on n02.co_inscricao = red.co_inscricao
	   inner join correcoes_tipo tipo on tipo.id = cor.id_tipo_correcao
	   inner join correcoes_situacao as cor_sit on cor_sit.id = cor.id_correcao_situacao
	   inner join correcoes_situacao as red_sit on red_sit.id = red.id_correcao_situacao
	   inner join entregas.n59 on n59.co_inscricao = left(red.co_inscricao, 12)
 where red.id_redacaoouro is null and cancelado = 0
GO
