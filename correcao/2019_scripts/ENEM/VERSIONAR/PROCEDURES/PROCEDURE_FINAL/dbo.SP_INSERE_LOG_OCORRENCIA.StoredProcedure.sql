/****** Object:  StoredProcedure [dbo].[SP_INSERE_LOG_OCORRENCIA]    Script Date: 26/11/2019 18:12:04 ******/
DROP PROCEDURE [dbo].[SP_INSERE_LOG_OCORRENCIA]
GO
/****** Object:  StoredProcedure [dbo].[SP_INSERE_LOG_OCORRENCIA]    Script Date: 26/11/2019 18:12:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_INSERE_LOG_OCORRENCIA]
	@ID_OCORRENCIA INT, @ID_PROJETO INT, @USUARIO_ID INT, @TIPO VARCHAR(1)
AS
SET NOCOUNT ON;
	INSERT INTO LOG_ocorrencias_ocorrencia
		(history_date, history_change_reason, history_type, history_user_id, observacao,
         id, data_solicitacao, data_resposta, data_fechamento, pergunta, resposta, nivel, dados_correcao, 
competencia1, competencia2, competencia3, competencia4, competencia5, correcao_situacao, img, 
atualizado_por, categoria_id, correcao_id, id_projeto, lote_solicitado_id, ocorrencia_pai_id, 
situacao_id, status_id, tipo_id, usuario_autor_id, usuario_responsavel_id, ocorrencia_relacionada_id

)
	SELECT dbo.getlocaldate(), null, @TIPO, @USUARIO_ID, null,
	       id, data_solicitacao, data_resposta, data_fechamento, pergunta, resposta, nivel, dados_correcao, 
competencia1, competencia2, competencia3, competencia4, competencia5, correcao_situacao, img, 
atualizado_por, categoria_id, correcao_id, id_projeto, lote_solicitado_id, ocorrencia_pai_id, 
situacao_id, status_id, tipo_id, usuario_autor_id, usuario_responsavel_id, ocorrencia_relacionada_id
		FROM ocorrencias_ocorrencia
		WHERE ID = @ID_OCORRENCIA
		
SET NOCOUNT OFF;
GO
