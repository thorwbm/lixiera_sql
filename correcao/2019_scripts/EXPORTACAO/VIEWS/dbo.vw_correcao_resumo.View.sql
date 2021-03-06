/****** Object:  View [dbo].[vw_correcao_resumo]    Script Date: 04/10/2019 10:16:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[vw_correcao_resumo] as
SELECT correcoes_analise.id_corretor_A as id, usuarios_pessoa.cpf, usuarios_pessoa.nome, usuarios_pessoa.email, vw_corretor_analise.nota, vw_corretor_analise.QTD_CORRECOES as correcoes, correcoes_contador.data_inicio_correcao as data_inicio,MAX(correcoes_analise.data_termino_A) AS data_termino
FROM correcoes_analise
inner join usuarios_pessoa on correcoes_analise.id_corretor_A = usuarios_pessoa.usuario_id
LEFT OUTER JOIN vw_corretor_analise on correcoes_analise.id_corretor_A = vw_corretor_analise.id_corretor
LEFT OUTER JOIN correcoes_correcao on correcoes_analise.id_corretor_A = correcoes_correcao.id_corretor
LEFT OUTER JOIN correcoes_contador on correcoes_analise.id_corretor_A = correcoes_contador.id_corretor
GROUP by correcoes_analise.id_corretor_A, usuarios_pessoa.cpf, usuarios_pessoa.nome, usuarios_pessoa.email, vw_corretor_analise.nota, vw_corretor_analise.QTD_CORRECOES, correcoes_contador.data_inicio_correcao

GO
