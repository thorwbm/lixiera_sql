/****** Object:  StoredProcedure [dbo].[SP_INSERE_LOG_INDICADORES]    Script Date: 26/11/2019 08:33:15 ******/
DROP PROCEDURE [dbo].[SP_INSERE_LOG_INDICADORES]
GO
/****** Object:  StoredProcedure [dbo].[SP_INSERE_LOG_INDICADORES]    Script Date: 26/11/2019 08:33:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_INSERE_LOG_INDICADORES] 
	@ID INT, @ID_PROJETO INT, @USUARIO_ID INT, @TIPO VARCHAR(1)
AS
SET NOCOUNT ON;
	INSERT INTO LOG_correcoes_corretor_indicadores
		(history_date, history_change_reason, history_type, history_user_id, observacao,
         id, id_hierarquia, dsp, data_calculo, nome, indice, tempo_correcao, ouros_corrigidas, 
		 modas_corrigidas, discrepancias_ouro, aproveitamentos_com_disc, aproveitamentos_sem_disc, 
		 total_correcoes, tempo_medio_correcao, taxa_discrepancia_ouro, taxa_aproveitamento, taxa_aproveitamento_coletivo, 
		 flg_dado_atual, desempenho_ouro, desempenho_moda, projeto_id, usuario_id, id_usuario_responsavel)
	SELECT dbo.getlocaldate(), null, @TIPO, @USUARIO_ID, null,	       
           id, id_hierarquia, dsp, data_calculo, nome, indice, tempo_correcao, ouros_corrigidas, 
		   modas_corrigidas, discrepancias_ouro, aproveitamentos_com_disc, aproveitamentos_sem_disc, 
		   total_correcoes, tempo_medio_correcao, taxa_discrepancia_ouro, taxa_aproveitamento, taxa_aproveitamento_coletivo, 
		   flg_dado_atual, desempenho_ouro, desempenho_moda, projeto_id, usuario_id, id_usuario_responsavel
		FROM correcoes_corretor_indicadores
		WHERE ID = @ID

		
SET NOCOUNT OFF;
GO
