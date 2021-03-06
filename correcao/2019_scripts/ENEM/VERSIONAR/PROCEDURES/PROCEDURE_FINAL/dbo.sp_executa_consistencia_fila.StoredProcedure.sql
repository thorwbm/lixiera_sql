/****** Object:  StoredProcedure [dbo].[sp_executa_consistencia_fila]    Script Date: 26/11/2019 18:12:04 ******/
DROP PROCEDURE [dbo].[sp_executa_consistencia_fila]
GO
/****** Object:  StoredProcedure [dbo].[sp_executa_consistencia_fila]    Script Date: 26/11/2019 18:12:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*****************************************************************************************************************
*                                        [SP_EXECUTA_CONSISTENCIA_FILA]                                          *
*                                                                                                                *
*  PROCEDURE QUE BUSCA NAS FILAS 3, 4 E AUDITORIA AS REDACOES QUE AINDA NAO FORAM VALIDADAS E FAZ UMA VALIDACAO  *
* SE ESTAS DEVRIAM ESTA REALMENTE NESTA FILA                                                                     *
*                                                                                                                *
*                                         DEVERÁ SER CRIADO UM JOB                                               *
*                                                                                                                *
* BANCO_SISTEMA : ENEM                                                                                           *
* CRIADO POR    : WEMERSON BITTORI MADURO                                                        DATA:23/11/2019 *
* ALTERADO POR  : WEMERSON BITTORI MADURO                                                        DATA:23/11/2019 *
******************************************************************************************************************/
CREATE     procedure [dbo].[sp_executa_consistencia_fila] as 
DECLARE @REDACAO_ID INT, @ID_PROJETO INT, @FILA INT


SET NOCOUNT ON;
declare abc cursor for 
		SELECT redacao_id,id_projeto,FILA = 3 FROM correcoes_fila3         WHERE consistido IS NULL  UNION
		SELECT redacao_id,id_projeto,FILA = 4 FROM correcoes_fila4         WHERE consistido IS NULL  UNION
		SELECT  redacao_id,id_projeto,FILA =7 FROM correcoes_filaAUDITORIA WHERE consistido IS NULL
	open abc 
		fetch next from abc into @REDACAO_ID, @ID_PROJETO, @FILA
		while @@FETCH_STATUS = 0
			BEGIN
				EXEC sp_consiStir_filas @REDACAO_ID, @ID_PROJETO, @FILA


			fetch next from abc into @REDACAO_ID, @ID_PROJETO, @FILA
			END
	close abc 
deallocate abc 


SET NOCOUNT OFF;
GO
