/****** Object:  StoredProcedure [dbo].[SP_INSERE_LOG_FILA2]    Script Date: 25/11/2019 09:23:18 ******/
DROP PROCEDURE [dbo].[SP_INSERE_LOG_FILA2]
GO
/****** Object:  StoredProcedure [dbo].[SP_INSERE_LOG_FILA2]    Script Date: 25/11/2019 09:23:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_INSERE_LOG_FILA2]
	@ID_FILA INT, @ID_PROJETO INT, @USUARIO_ID INT, @TIPO VARCHAR(1)
AS
	INSERT INTO LOG_correcoes_fila2
		(history_date, history_change_reason, history_type, history_user_id, observacao,
			id, corrigido_por, criado_em, id_correcao, id_grupo_corretor, id_projeto, co_barra_redacao, redacao_id	)
	SELECT dbo.getlocaldate(), null, @TIPO, @USUARIO_ID, null,
			id, corrigido_por, criado_em, id_correcao, id_grupo_corretor, id_projeto, co_barra_redacao, redacao_id
		FROM correcoes_fila2
		WHERE ID = @ID_FILA
GO
