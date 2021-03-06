/****** Object:  StoredProcedure [dbo].[SP_INSERE_LOG_FILAPESSOAL]    Script Date: 24/11/2019 21:41:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_INSERE_LOG_FILAPESSOAL] 
@FILAPESSOAL_ID INT, @ID_PROJETO INT, @USUARIO_ID INT, @TIPO VARCHAR(1)
AS 
-- CRIACAO LOG 
insert log_correcoes_filapessoal ( history_date, history_change_reason, history_type, history_user_id, observacao,
									id, corrigido_por, criado_em, atual,  id_correcao, id_corretor, id_grupo_corretor, id_projeto, 
									co_barra_redacao, id_tipo_correcao,  redacao_id)
	select dbo.getlocaldate(), null, @TIPO, @USUARIO_ID, null,
		id, corrigido_por, criado_em, atual,  id_correcao, id_corretor, id_grupo_corretor, id_projeto, 
co_barra_redacao, id_tipo_correcao,  redacao_id
from correcoes_filapessoal 
where id = @FILAPESSOAL_ID
-- CRIACAO LOG - FIM 
GO
