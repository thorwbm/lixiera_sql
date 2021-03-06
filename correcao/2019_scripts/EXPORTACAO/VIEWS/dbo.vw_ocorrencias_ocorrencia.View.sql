/****** Object:  View [dbo].[vw_ocorrencias_ocorrencia]    Script Date: 04/10/2019 10:16:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[vw_ocorrencias_ocorrencia]
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
