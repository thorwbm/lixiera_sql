/****** Object:  View [dbo].[VwOcorrencia]    Script Date: 04/10/2019 10:16:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create VIEW [dbo].[VwOcorrencia]
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
