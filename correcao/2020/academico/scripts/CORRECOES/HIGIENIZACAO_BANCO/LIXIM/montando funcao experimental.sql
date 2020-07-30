create function fn_listar_ocorrencia_campo (@CAMPO VARCHAR(500), @TABELA VARCHAR(500))
returns @tabela table
  (valor_campo

  )
as 
DECLARE @SQL VARCHAR(MAX), @CONT INT 
 

SET @CAMPO = 'TURMA_DISCIPLINA_ID'

SET @CONT = 0
SET @SQL = 'SELECT *  FROM ( '

declare CUR_ cursor for 
	SELECT TABELA, COLUNA FROM VW_TABELA_COLUNA WHERE COLUNA = @CAMPO
	open CUR_ 
		fetch next from CUR_ into @TABELA, @CAMPO
		while @@FETCH_STATUS = 0
			BEGIN
			    IF (@CONT = 0)
					BEGIN
						SET @SQL = @SQL + ' SELECT ' + @CAMPO + ', QTD = COUNT(1), TABELA = '+ CHAR(39) + @TABELA + CHAR(39) +' FROM ' + @TABELA + ' GROUP BY ' + @CAMPO
					END
				ELSE
					BEGIN
						SET @SQL = @SQL + ' UNION SELECT ' + @CAMPO + ', QTD = COUNT(1), TABELA = '+ CHAR(39) + @TABELA + CHAR(39) +' FROM ' + @TABELA +  + ' GROUP BY ' + @CAMPO
					END
				
				SET @CONT = @CONT + 1
			fetch next from CUR_ into @TABELA, @CAMPO
			END
	close CUR_ 
deallocate CUR_ 

SET @SQL = @SQL + ' ) AS TAB ORDER BY TABELA'
--PRINT @SQL 
EXEC (@SQL)