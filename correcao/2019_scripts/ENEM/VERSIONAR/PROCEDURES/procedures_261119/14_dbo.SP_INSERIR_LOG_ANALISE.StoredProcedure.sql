/****** Object:  StoredProcedure [dbo].[SP_INSERIR_LOG_ANALISE]    Script Date: 26/11/2019 08:33:15 ******/
DROP PROCEDURE [dbo].[SP_INSERIR_LOG_ANALISE]
GO
/****** Object:  StoredProcedure [dbo].[SP_INSERIR_LOG_ANALISE]    Script Date: 26/11/2019 08:33:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_INSERIR_LOG_ANALISE] 
   @ID_ANALISE INT, @ID_PROJETO INT, @USUARIO_ID INT, @TIPO VARCHAR(1) AS 
SET NOCOUNT ON;
	-- CRIACAO LOG 
	INSERT INTO LOG_correcoes_analise
		(history_date, history_change_reason, history_type, history_user_id, observacao,
			id, data_inicio_A, data_inicio_B, data_termino_A, data_termino_B, link_imagem_recortada, 
			link_imagem_original, nota_final_A, nota_final_B, situacao_nota_final, competencia1_A, 
			competencia1_B, competencia2_A, competencia2_B, competencia3_A, competencia3_B, competencia4_A, 
			competencia4_B, competencia5_A, competencia5_B, nota_competencia1_A, nota_competencia1_B, 
			diferenca_competencia1, situacao_competencia1, nota_competencia2_A, nota_competencia2_B, 
			diferenca_competencia2, situacao_competencia2, nota_competencia3_A, nota_competencia3_B, 
			diferenca_competencia3, situacao_competencia3, nota_competencia4_A, nota_competencia4_B, 
			diferenca_competencia4, situacao_competencia4, nota_competencia5_A, nota_competencia5_B, 
			diferenca_competencia5, situacao_competencia5, diferenca_nota_final, id_auxiliar1_A, id_auxiliar2_A, 
			id_auxiliar1_B, id_auxiliar2_B, diferenca_situacao, id_status_A, id_status_B, id_tipo_correcao_A, id_tipo_correcao_B, 
			conclusao_analise, fila, nota_corretor, aproveitamento, nota_desempenho, id_correcao_A, id_correcao_B, id_correcao_situacao_A, 
			id_correcao_situacao_B, id_corretor_A, id_corretor_B, id_projeto, co_barra_redacao, redacao_id, criado_em	)
	SELECT dbo.getlocaldate(), null, @TIPO, @USUARIO_ID, null,	   
			id, data_inicio_A, data_inicio_B, data_termino_A, data_termino_B, link_imagem_recortada, 
			link_imagem_original, nota_final_A, nota_final_B, situacao_nota_final, competencia1_A, 
			competencia1_B, competencia2_A, competencia2_B, competencia3_A, competencia3_B, competencia4_A, 
			competencia4_B, competencia5_A, competencia5_B, nota_competencia1_A, nota_competencia1_B, 
			diferenca_competencia1, situacao_competencia1, nota_competencia2_A, nota_competencia2_B, 
			diferenca_competencia2, situacao_competencia2, nota_competencia3_A, nota_competencia3_B, 
			diferenca_competencia3, situacao_competencia3, nota_competencia4_A, nota_competencia4_B, 
			diferenca_competencia4, situacao_competencia4, nota_competencia5_A, nota_competencia5_B, 
			diferenca_competencia5, situacao_competencia5, diferenca_nota_final, id_auxiliar1_A, id_auxiliar2_A, 
			id_auxiliar1_B, id_auxiliar2_B, diferenca_situacao, id_status_A, id_status_B, id_tipo_correcao_A, id_tipo_correcao_B, 
			conclusao_analise, fila, nota_corretor, aproveitamento, nota_desempenho, id_correcao_A, id_correcao_B, id_correcao_situacao_A, 
			id_correcao_situacao_B, id_corretor_A, id_corretor_B, id_projeto, co_barra_redacao, redacao_id, criado_em				       
		FROM correcoes_analise
		WHERE ID = @ID_ANALISE AND 
				id_projeto = @ID_PROJETO 
	-- CRIACAO LOG - FIM
SET NOCOUNT OFF;
GO
