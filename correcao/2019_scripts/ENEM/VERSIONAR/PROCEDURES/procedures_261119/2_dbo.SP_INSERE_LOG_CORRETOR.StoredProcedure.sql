/****** Object:  StoredProcedure [dbo].[SP_INSERE_LOG_CORRETOR]    Script Date: 26/11/2019 08:33:15 ******/
DROP PROCEDURE [dbo].[SP_INSERE_LOG_CORRETOR]
GO
/****** Object:  StoredProcedure [dbo].[SP_INSERE_LOG_CORRETOR]    Script Date: 26/11/2019 08:33:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_INSERE_LOG_CORRETOR] 
   @ID_ANALISE INT, @ID_PROJETO INT, @USUARIO_ID INT, @TIPO VARCHAR(1) 
AS 
SET NOCOUNT ON;
-- CRIACAO LOG 
INSERT INTO LOG_correcoes_corretor
	(history_date, history_change_reason, history_type, history_user_id, observacao,
	 id, max_correcoes_dia, pode_corrigir_1, pode_corrigir_2, pode_corrigir_3, nota_corretor, tipo_cota, 
atualizado_por, id_grupo, status_id, dsp, tempo_medio_correcao, supervisor_em_banca, pode_corrigir_4)
SELECT dbo.getlocaldate(), null, @TIPO, @USUARIO_ID, null,
	   id, max_correcoes_dia, pode_corrigir_1, pode_corrigir_2, pode_corrigir_3, nota_corretor, tipo_cota, 
       atualizado_por, id_grupo, status_id, dsp, tempo_medio_correcao, supervisor_em_banca, pode_corrigir_4				       
	FROM correcoes_corretor
	WHERE id IN (SELECT DISTINCT COR.id 
	               FROM correcoes_corretor AS cor INNER JOIN correcoes_corretor_indicadores cci ON cci.usuario_id = cor.id
                   WHERE cci.id = (SELECT max(cci2.id) FROM correcoes_corretor_indicadores cci2 WHERE cci2.usuario_id = cci.usuario_id))

-- CRIACAO LOG - FIM 
SET NOCOUNT Off;
GO
