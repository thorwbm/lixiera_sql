/****** Object:  StoredProcedure [dbo].[SP_INSERE_LOG_FILA4]    Script Date: 24/11/2019 21:41:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_INSERE_LOG_FILA4]
@ID_FILA INT, @ID_PROJETO INT, @USUARIO_ID INT, @TIPO VARCHAR(1)
AS
INSERT INTO LOG_correcoes_fila3
	(history_date, history_change_reason, history_type, history_user_id, observacao,
		id, corrigido_por, criado_em, id_correcao, id_grupo_corretor, id_projeto, co_barra_redacao, redacao_id, 
		consistido, consistido_auditoria)
SELECT dbo.getlocaldate(), null, @TIPO, @USUARIO_ID, null,
		id, corrigido_por, criado_em, id_correcao, id_grupo_corretor, id_projeto, co_barra_redacao, redacao_id, 
		consistido, consistido_auditoria
	FROM correcoes_fila4
	WHERE id = @ID_FILA
GO
