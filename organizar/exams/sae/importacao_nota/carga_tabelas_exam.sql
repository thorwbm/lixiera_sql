
--  CREATE PROCEDURE SP_COPIAR_TABELA_IMPORTACAO AS
use educat_sae

DECLARE @INICIO  DATETIME = getdate()
DECLARE @PARCIAL DATETIME
DECLARE @FINAL   DATETIME

--#####################################################################################
-- SELECT TOP 5 * FROM SAE_PROVA.EXAMS.DBO.ITEM_ITEM

SET @PARCIAL = GETDATE()
IF(EXISTS(SELECT 1 FROM SYS.TABLES WHERE NAME = 'SAE_USUARIO'))
	BEGIN
		DROP TABLE SAE_USUARIO
	END 

	SELECT distinct usu.[id],usu.[email],usu.[name], usu.extra 
	       INTO SAE_USUARIO
    FROM exams_sae..[auth_user] usu join exams_sae..application_application app on (usu.id = app.user_id)
    where  user_id <> 2 
    order by usu.name
	-- CRIAR INDEX
	CREATE INDEX IX_SAE_USUARIO__ID ON SAE_USUARIO (ID)

SET @FINAL = GETDATE()	
	PRINT 'CARGA SAE_USUARIO'
	PRINT 'TEMPO GASTO (SEGUNDOS) - ' + CONVERT(VARCHAR(50),DATEDIFF(SECOND, @PARCIAL,@FINAL))

--#####################################################################################
-- SELECT TOP 5 * FROM SAE_PROVA.EXAMS.DBO.VW_DADOS_EXPORTACAO

SET @PARCIAL = GETDATE()
IF(EXISTS(SELECT 1 FROM SYS.TABLES WHERE NAME = 'SAE_DADOS_EXPORTACAO'))
	BEGIN
		DROP TABLE SAE_DADOS_EXPORTACAO
	END 
	
	SELECT * INTO SAE_DADOS_EXPORTACAO FROM exams_sae..VW_DADOS_EXPORTACAO
--	 CRIAR INDEX
	CREATE INDEX IX_SAE_DADOS_EXPORTACAO__USUARIO_ID     ON SAE_DADOS_EXPORTACAO (USUARIO_ID)
	CREATE INDEX IX_SAE_DADOS_EXPORTACAO__AVALIACAO_ID ON SAE_DADOS_EXPORTACAO (AVALIACAO_ID)

SET @FINAL = GETDATE()	
	PRINT 'CARGA SAE_DADOS_EXPORTACAO'
	PRINT 'TEMPO GASTO (SEGUNDOS) - ' + CONVERT(VARCHAR(50),DATEDIFF(SECOND, @PARCIAL,@FINAL))
-- ##################################################################################
-- SELECT TOP 5 * FROM SAE_PROVA.EXAMS.DBO.ITEM_ITEM

SET @PARCIAL = GETDATE()
IF(EXISTS(SELECT 1 FROM SYS.TABLES WHERE NAME = 'SAE_ITEM_ITEM'))
	BEGIN
		DROP TABLE SAE_ITEM_ITEM
	END 
	
	SELECT * INTO SAE_ITEM_ITEM FROM exams_sae..ITEM_ITEM
	-- CRIAR INDEX
	CREATE INDEX IX_SAE_ITEM_ITEM__EXTERNAL_ID     ON SAE_ITEM_ITEM (EXTERNAL_ID)
	CREATE INDEX IX_SAE_ITEM_ITEM__ID__EXTERNAL_ID ON SAE_ITEM_ITEM (ID, EXTERNAL_ID)
	PRINT 'FIM - SAE_ITEM_ITEM'
	PRINT GETDATE()

SET @FINAL = GETDATE()	
	PRINT 'CARGA SAE_ITEM_ITEM'
	PRINT 'TEMPO GASTO (SEGUNDOS) - ' + CONVERT(VARCHAR(50),DATEDIFF(SECOND, @PARCIAL,@FINAL))
-- ##################################################################################
-- SELECT count(1) FROM SAE_PROVA.EXAMS.DBO.EXAM_EXAM
-- select count(1) from SAE_EXAM_EXAM
SET @PARCIAL = GETDATE()
IF(EXISTS(SELECT 1 FROM SYS.TABLES WHERE NAME = 'SAE_EXAM_EXAM'))
	BEGIN
		DROP TABLE SAE_EXAM_EXAM
	END 	
	
	SELECT * INTO SAE_EXAM_EXAM FROM exams_sae..EXAM_EXAM
	-- CRIAR INDEX
	CREATE INDEX IX_SAE_EXAM_EXAM__EXTERNAL_ID     ON SAE_EXAM_EXAM (EXTERNAL_ID)
	CREATE INDEX IX_SAE_EXAM_EXAM__ID__EXTERNAL_ID ON SAE_EXAM_EXAM (ID, EXTERNAL_ID)

SET @FINAL = GETDATE()	
	PRINT 'CARGA SAE_EXAM_EXAM'
	PRINT 'TEMPO GASTO (SEGUNDOS) - ' + CONVERT(VARCHAR(50),DATEDIFF(SECOND, @PARCIAL,@FINAL))
-- ##################################################################################
-- SELECT TOP 5 * FROM SAE_PROVA.EXAMS.DBO.EXAM_EXAMITEM

SET @PARCIAL = GETDATE()
IF(EXISTS(SELECT 1 FROM SYS.TABLES WHERE NAME = 'SAE_EXAM_EXAMITEM'))
	BEGIN
		DROP TABLE SAE_EXAM_EXAMITEM
	END 

	SELECT * INTO SAE_EXAM_EXAMITEM FROM exams_sae..EXAM_EXAMITEM
	-- CRIAR INDEX
	CREATE INDEX IX_SAE_EXAM_EXAMITEM__ID               ON SAE_EXAM_EXAMITEM (ID)
	CREATE INDEX IX_SAE_EXAM_EXAMITEM__EXAM_ID__ITEM_ID ON SAE_EXAM_EXAMITEM (EXAM_ID, ITEM_ID)

SET @FINAL = GETDATE()	
	PRINT 'CARGA SAE_EXAM_EXAMITEM'
	PRINT 'TEMPO GASTO (SEGUNDOS) - ' + CONVERT(VARCHAR(50),DATEDIFF(SECOND, @PARCIAL,@FINAL))
-- ##################################################################################
-- SELECT TOP 5 * FROM SAE_PROVA.EXAMS.DBO.ITEM_ALTERNATIVE

SET @PARCIAL = GETDATE()
IF(EXISTS(SELECT 1 FROM SYS.TABLES WHERE NAME = 'SAE_ITEM_ALTERNATIVE'))
	BEGIN
		DROP TABLE SAE_ITEM_ALTERNATIVE
	END 	
	
	SELECT * INTO SAE_ITEM_ALTERNATIVE FROM exams_sae..ITEM_ALTERNATIVE
	-- CRIAR INDEX
	CREATE INDEX IX_SAE_ITEM_ALTERNATIVE__EXTERNAL_ID           ON SAE_ITEM_ALTERNATIVE (EXTERNAL_ID)
	CREATE INDEX IX_SAE_ITEM_ALTERNATIVE__ITEM_ID__EXTERNAL_IDD ON SAE_ITEM_ALTERNATIVE (ITEM_ID,EXTERNAL_ID)

SET @FINAL = GETDATE()	
	PRINT 'CARGA SAE_ITEM_ALTERNATIVE'
	PRINT 'TEMPO GASTO (SEGUNDOS) - ' + CONVERT(VARCHAR(50),DATEDIFF(SECOND, @PARCIAL,@FINAL))
-- ##################################################################################
-- SELECT TOP 5 * FROM SAE_PROVA.EXAMS.DBO.APPLICATION_APPLICATION

SET @PARCIAL = GETDATE()
IF(EXISTS(SELECT 1 FROM SYS.TABLES WHERE NAME = 'SAE_APPLICATION_APPLICATION'))
	BEGIN
		DROP TABLE SAE_APPLICATION_APPLICATION
	END 	

	SELECT * INTO SAE_APPLICATION_APPLICATION FROM exams_sae..APPLICATION_APPLICATION
	-- CRIAR INDEX
	CREATE INDEX IX_SAE_APPLICATION_APPLICATION__ID               ON SAE_APPLICATION_APPLICATION (ID)
	CREATE INDEX IX_SAE_APPLICATION_APPLICATION__EXAM_ID__USER_ID ON SAE_APPLICATION_APPLICATION (EXAM_ID, USER_ID)

SET @FINAL = GETDATE()	
	PRINT 'CARGA SAE_APPLICATION_APPLICATION'
	PRINT 'TEMPO GASTO (SEGUNDOS) - ' + CONVERT(VARCHAR(50),DATEDIFF(SECOND, @PARCIAL,@FINAL))
-- ##################################################################################
   --  SELECT TOP 5 * FROM SAE_PROVA.EXAMS.DBO.SAE_APPLICATION_ANSWER

SET @PARCIAL = GETDATE()
    IF(EXISTS(SELECT 1 FROM SYS.TABLES WHERE NAME = 'SAE_APPLICATION_ANSWER'))
    	BEGIN
    		DROP TABLE SAE_APPLICATION_ANSWER
    	END 	

    	SELECT * INTO SAE_APPLICATION_ANSWER FROM exams_sae..APPLICATION_ANSWER
    	-- CRIAR INDEX
    	CREATE INDEX IX_SAE_APPLICATION_ANSWER__ID               ON SAE_APPLICATION_ANSWER (ID)
    	CREATE INDEX IX_SAE_APPLICATION_ANSWER__ITEM_ID ON SAE_APPLICATION_ANSWER (ITEM_ID)

SET @FINAL = GETDATE()	
	PRINT 'CARGA SAE_APPLICATION_ANSWER'
	PRINT 'TEMPO GASTO (SEGUNDOS) - ' + CONVERT(VARCHAR(50),DATEDIFF(SECOND, @PARCIAL,@FINAL))
---- ##################################################################################
PRINT '##################################################################################'
PRINT 'TEMPO TOTAL GASTO (SEGUNDOS) - ' + CONVERT(VARCHAR(50),DATEDIFF(SECOND, @INICIO, @FINAL))
exec sp_gerar_log_carga 'COPIA TABELAS SAE', 'COPIA DAS TABELAS DO SAE', NULL, 'OK', @INICIO, @FINAL

