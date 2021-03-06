/****** Object:  StoredProcedure [dbo].[SP_INSERE_LOG_HISTORICOCORRECAO]    Script Date: 26/11/2019 18:12:04 ******/
DROP PROCEDURE [dbo].[SP_INSERE_LOG_HISTORICOCORRECAO]
GO
/****** Object:  StoredProcedure [dbo].[SP_INSERE_LOG_HISTORICOCORRECAO]    Script Date: 26/11/2019 18:12:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_INSERE_LOG_HISTORICOCORRECAO] 
@HISTORICOCORRECAO INT, @ID_PROJETO INT, @USUARIO_ID INT, @TIPO VARCHAR(1)
AS 
SET NOCOUNT ON;
-- CRIACAO LOG 
	INSERT INTO LOG_correcoes_historicocorrecao 
		(history_date, history_change_reason, history_type, history_user_id, observacao,
		id, dt_historico, data, correcao_id, evento_id, usuario_id)
SELECT dbo.getlocaldate(), null, @TIPO, @USUARIO_ID, null,
		id, dt_historico, data, correcao_id, evento_id, usuario_id
	FROM correcoes_historicocorrecao
	WHERE id = @HISTORICOCORRECAO
-- CRIACAO LOG - FIM 
SET NOCOUNT OFF;
GO
