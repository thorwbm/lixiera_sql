
create procedure sp_executa_consistencia_fila as 
DECLARE @REDACAO_ID INT, @ID_PROJETO INT, @FILA INT

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