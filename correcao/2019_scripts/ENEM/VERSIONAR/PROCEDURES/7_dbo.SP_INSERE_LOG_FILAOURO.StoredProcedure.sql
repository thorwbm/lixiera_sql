/****** Object:  StoredProcedure [dbo].[SP_INSERE_LOG_FILAOURO]    Script Date: 25/11/2019 09:23:18 ******/
DROP PROCEDURE [dbo].[SP_INSERE_LOG_FILAOURO]
GO
/****** Object:  StoredProcedure [dbo].[SP_INSERE_LOG_FILAOURO]    Script Date: 25/11/2019 09:23:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_INSERE_LOG_FILAOURO]
@ID_FILAOURO INT, @ID_PROJETO INT, @USUARIO_ID INT, @TIPO VARCHAR(1)
AS 
INSERT INTO LOG_correcoes_filaOuro
	(history_date, history_change_reason, history_type, history_user_id, observacao,
		id, posicao, criado_em, id_corretor, id_projeto, co_barra_redacao, redacao_id, alcance)
SELECT dbo.getlocaldate(), null, @TIPO, @USUARIO_ID, null,
		id, posicao, criado_em, id_corretor, id_projeto, co_barra_redacao, redacao_id, alcance
	FROM correcoes_filaOuro
	WHERE ID = @ID_FILAOURO
GO
