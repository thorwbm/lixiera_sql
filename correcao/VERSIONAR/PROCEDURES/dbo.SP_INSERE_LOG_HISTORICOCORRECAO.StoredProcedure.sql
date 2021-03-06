/****** Object:  StoredProcedure [dbo].[SP_INSERE_LOG_HISTORICOCORRECAO]    Script Date: 24/11/2019 21:41:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_INSERE_LOG_HISTORICOCORRECAO] 
@HISTORICOCORRECAO INT, @ID_PROJETO INT, @USUARIO_ID INT, @TIPO VARCHAR(1)
AS 
-- CRIACAO LOG 
	INSERT INTO LOG_correcoes_historicocorrecao 
		(history_date, history_change_reason, history_type, history_user_id, observacao,
		id, dt_historico, data, correcao_id, evento_id, usuario_id)
SELECT dbo.getlocaldate(), null, @TIPO, @USUARIO_ID, null,
		id, dt_historico, data, correcao_id, evento_id, usuario_id
	FROM correcoes_historicocorrecao
	WHERE id = @HISTORICOCORRECAO
-- CRIACAO LOG - FIM 
GO
