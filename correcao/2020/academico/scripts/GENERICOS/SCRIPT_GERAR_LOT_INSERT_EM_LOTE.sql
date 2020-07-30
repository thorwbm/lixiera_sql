
DECLARE @AUXILIAR INT 
--  **** GERAR LOG
-- SET @AUX = ( 'instituicao_ensino_medio_id;' + CONVERT(VARCHAR(10),@ATUAL) + ';'+ CONVERT(VARCHAR(10),@NOVO))
declare CUR_INSERT cursor for 
	SELECT  ID FROM CONTRATOS_DESCONTO 
	open CUR_INSERT 
		fetch next from CUR_INSERT into @AUXILIAR
		while @@FETCH_STATUS = 0
			BEGIN
				EXEC SP_GERAR_LOG 'CONTRATOS_DESCONTO', @AUXILIAR, '+', 2137,NULL, NULL, NULL
			fetch next from CUR_INSERT into @AUXILIAR
			END
	close CUR_INSERT 
deallocate CUR_INSERT
SET @AUXILIAR = 0
--  **** GERAR LOG FIM