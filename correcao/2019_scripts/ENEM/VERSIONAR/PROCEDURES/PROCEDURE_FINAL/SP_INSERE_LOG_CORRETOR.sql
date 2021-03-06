
CREATE OR ALTER PROCEDURE [dbo].[SP_INSERE_LOG_CORRETOR] 
   @ID_correcoes_corretor INT, @ID_PROJETO INT, @USUARIO_ID INT, @TIPO VARCHAR(1) 
AS 
SET NOCOUNT ON;
-- CRIACAO LOG 
INSERT INTO LOG_correcoes_corretor
	(history_date, history_change_reason, history_type, history_user_id, observacao,
	 id, max_correcoes_dia, pode_corrigir_1, pode_corrigir_2, pode_corrigir_3, nota_corretor, 
     tipo_cota, atualizado_por, id_grupo, status_id, dsp, tempo_medio_correcao, supervisor_em_banca, 
     pode_corrigir_4, enviado_para_correcao_em, recapacitacao_criada_em, recapacitacao_habilitada_em)
SELECT dbo.getlocaldate(), null, @TIPO, @USUARIO_ID, null,
	   id, max_correcoes_dia, pode_corrigir_1, pode_corrigir_2, pode_corrigir_3, nota_corretor, 
       tipo_cota, atualizado_por, id_grupo, status_id, dsp, tempo_medio_correcao, supervisor_em_banca, 
       pode_corrigir_4, enviado_para_correcao_em, recapacitacao_criada_em, recapacitacao_habilitada_em			       
	FROM correcoes_corretor
	WHERE id = @ID_correcoes_corretor

-- CRIACAO LOG - FIM 
SET NOCOUNT Off;