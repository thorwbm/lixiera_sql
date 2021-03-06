/****** Object:  StoredProcedure [dbo].[SP_INSERE_LOG_REDACAO]    Script Date: 24/11/2019 21:41:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- EXEC INSERE_LOG_REDACAO @ID_REDACAO, @ID_PROJETO, @USUARIO_ID, @TIPO
CREATE PROCEDURE [dbo].[SP_INSERE_LOG_REDACAO]
@ID_REDACAO INT, @ID_PROJETO INT, @USUARIO_ID INT, @TIPO VARCHAR(1)
AS 
					-- CRIACAO LOG 
							INSERT INTO LOG_correcoes_redacao
								(history_date, history_change_reason, history_type, history_user_id, observacao,
								 id, co_barra_redacao, co_inscricao, link_imagem_recortada, link_imagem_original, nota_final, co_formulario, id_prova, id_correcao_situacao, 
								 id_redacao_situacao, id_projeto, id_redacaoouro, id_status, cancelado, justificativa_cancelamento, motivo_id, nota_competencia1, nota_competencia2, 
								 nota_competencia3, nota_competencia4, nota_competencia5, data_inicio, data_termino, faixa_plano_amostral)   
							SELECT dbo.getlocaldate(), null, @TIPO, @USUARIO_ID, null,
								   id, co_barra_redacao, co_inscricao, link_imagem_recortada, link_imagem_original, nota_final, co_formulario, id_prova, id_correcao_situacao, 
								   id_redacao_situacao, id_projeto, id_redacaoouro, id_status, cancelado, justificativa_cancelamento, motivo_id, nota_competencia1, nota_competencia2, 
								   nota_competencia3, nota_competencia4, nota_competencia5, data_inicio, data_termino, faixa_plano_amostral
							  FROM correcoes_redacao 
							  WHERE ID = @ID_REDACAO AND 
							        id_projeto = @ID_PROJETO
					-- CRIACAO LOG - FIM 
GO
