/****** Object:  StoredProcedure [dbo].[SP_INSERE_LOG_FILAAUDITORIA]    Script Date: 26/11/2019 18:12:04 ******/
DROP PROCEDURE [dbo].[SP_INSERE_LOG_FILAAUDITORIA]
GO
/****** Object:  StoredProcedure [dbo].[SP_INSERE_LOG_FILAAUDITORIA]    Script Date: 26/11/2019 18:12:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_INSERE_LOG_FILAAUDITORIA]
@ID_FILA INT, @ID_PROJETO INT, @USUARIO_ID INT, @TIPO VARCHAR(1)
AS 
SET NOCOUNT ON;
	INSERT INTO LOG_CORRECOES_FILAAUDITORIA
		(history_date, history_change_reason, history_type, history_user_id, observacao,
			id, corrigido_por, pendente, criado_em, id_correcao, id_corretor, id_projeto, co_barra_redacao, 
			tipo_id, redacao_id, consistido, consistido_auditoria)
	SELECT dbo.getlocaldate(), null, @TIPO, @USUARIO_ID, null,
			id, corrigido_por, pendente, criado_em, id_correcao, id_corretor, id_projeto, co_barra_redacao, 
			tipo_id, redacao_id, consistido, consistido_auditoria

		FROM CORRECOES_FILAAUDITORIA
		WHERE id = @ID_FILA
		
SET NOCOUNT OFF;
GO
