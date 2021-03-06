/****** Object:  StoredProcedure [dbo].[SP_INSERE_LOG_CORRECAO]    Script Date: 26/11/2019 08:33:15 ******/
DROP PROCEDURE [dbo].[SP_INSERE_LOG_CORRECAO]
GO
/****** Object:  StoredProcedure [dbo].[SP_INSERE_LOG_CORRECAO]    Script Date: 26/11/2019 08:33:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_INSERE_LOG_CORRECAO]
@ID_CORRECAO INT, @ID_PROJETO INT, @USUARIO_ID INT, @TIPO VARCHAR(1)
AS 
SET NOCOUNT ON;
INSERT INTO LOG_correcoes_correcao
			      ( history_date, history_change_reason, history_type, history_user_id, observacao,
				   id, token_auxiliar1, token_auxiliar2, data_inicio, data_termino, correcao, link_imagem_recortada, link_imagem_original, 
                   nota_final, competencia1, competencia2, competencia3, competencia4, competencia5, nota_competencia1, nota_competencia2, 
	               nota_competencia3, nota_competencia4, nota_competencia5, tempo_em_correcao, angulo_imagem, atualizado_por, id_auxiliar1, 
	               id_auxiliar2, id_correcao_situacao, id_corretor, id_projeto, co_barra_redacao, id_status, tipo_auditoria_id, id_tipo_correcao, 
	               redacao_id)
			SELECT dbo.getlocaldate(), null, @TIPO, @USUARIO_ID, null,
			       id, token_auxiliar1, token_auxiliar2, data_inicio, data_termino, correcao, link_imagem_recortada, link_imagem_original, 
                   nota_final, competencia1, competencia2, competencia3, competencia4, competencia5, nota_competencia1, nota_competencia2, 
	               nota_competencia3, nota_competencia4, nota_competencia5, tempo_em_correcao, angulo_imagem, atualizado_por, id_auxiliar1, 
	               id_auxiliar2, id_correcao_situacao, id_corretor, id_projeto, co_barra_redacao, id_status, tipo_auditoria_id, id_tipo_correcao, 
	               redacao_id
			FROM correcoes_correcao
			WHERE  id = @ID_CORRECAO
SET NOCOUNT Off;
GO
