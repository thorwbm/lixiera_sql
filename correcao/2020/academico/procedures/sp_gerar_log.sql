/**********************************************************************************************************************************
*                                                          SP_GERAR_LOG                                                           *
*                                                                                                                                 *
*  PROCEDURE QUE RECEBE O NOME DA TABELA O ID DE IDENTIFICACAO DA LINHA QUE ESTA GERANDO O LOG E O TIPO DE ACAO (INSERT, DELETE O *
* U UPDATE) TAMBEM RECEBE INFORMACOES DE CONTROLE DO LOG - O QUE FOI ALTERADO, QUEM, MOTIVO                                       *
*                                                                                                                                 *
* BANCO_SISTEMA : EDUCAT                                                                                                          *
* CRIADO POR    : WEMERSON BITTORI MADURO                                                                         DATA:08/01/2020 *
* ALTERADO POR  : WEMERSON BITTORI MADURO                                                                         DATA:08/01/2020 *
**********************************************************************************************************************************/
-- EXEC SP_GERAR_LOG @TABELA, @ID_TABLE, @history_type, @history_user_id, @observacao, @atributos_log, @history_change_reason

CREATE OR ALTER  PROCEDURE [dbo].[SP_GERAR_LOG] @TABELA VARCHAR(MAX),@ID_TABLE INT, @history_type VARCHAR(4),@history_user_id INT, @observacao NVARCHAR(MAX),
        @atributos_log NVARCHAR(MAX), @history_change_reason VARCHAR(200)
 AS        

DECLARE @SQL VARCHAR(MAX)
DECLARE @HISTORY_USER_ID_CRT varchar(20)

SET @atributos_log         = ISNULL(CHAR(39) + @atributos_log + CHAR(39),'NULL')
SET @history_change_reason = ISNULL(CHAR(39) + @history_change_reason + CHAR(39),'NULL')
SET @history_type          =  ISNULL(CHAR(39) + @history_type + CHAR(39),'NULL')
SET @HISTORY_USER_ID_CRT   = ISNULL(CONVERT(VARCHAR(20),@history_user_id),'NULL')

if (@observacao IS NOT NULL )
	BEGIN
	     
		SELECT @observacao = CHAR(39) + DBO.fn_gerar_json_update(@observacao)+ CHAR(39)
	END
ELSE 
	BEGIN		
		SET @observacao = 'NULL'
	END 

SET @SQL = N'INSERT INTO LOG_' + @TABELA + '( atributos_log,history_change_reason,history_date,history_type,history_user_id,observacao,'+
             DBO.fn_retorna_colunas_tabela(@TABELA) + ') ' +
		    ' SELECT '+ @atributos_log + ',' + @history_change_reason + ', GETDATE(), '  + @history_type + ',' +  @HISTORY_USER_ID_CRT + ',' + @observacao + ',' +
			 DBO.fn_retorna_colunas_tabela(@TABELA) + 
			' FROM ' + @TABELA + 
			' WHERE ID = ' + CONVERT(VARCHAR(20), @ID_TABLE)

 EXEC (@SQL)

GO

