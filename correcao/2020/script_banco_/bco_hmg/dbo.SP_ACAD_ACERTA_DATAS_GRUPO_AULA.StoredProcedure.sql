USE [erp_hmg]
GO
/****** Object:  StoredProcedure [dbo].[SP_ACAD_ACERTA_DATAS_GRUPO_AULA]    Script Date: 12/02/2020 15:40:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[SP_ACAD_ACERTA_DATAS_GRUPO_AULA] AS 
DECLARE @GRUPO_ID INT, @INICIO DATETIME, @TERMINO DATETIME

-- **** APGAR OS GRUPOS QUE NAO POSSUEM AULA ASSOCIADAS  
	   DELETE 
	  FROM academico_grupoaula 
	 WHERE id IN (SELECT ID FROM VW_ACAD_AULA_GRUPO_DIVERGENCIA WHERE TIPO = 'GRUPO_SEM_AULA')

 -- **** ATUALIZAR AS DATAS DE INICIO E TERMINO DO GRUPO
declare abc cursor for 
	SELECT ID, INICIO, TERMINO 
	  FROM VW_AULA_GRUPO_DIVERGENCIA_DATA_INICIO_OU_TERMINO
	open abc 
		fetch next from abc into @GRUPO_ID, @INICIO, @TERMINO
		while @@FETCH_STATUS = 0
			BEGIN
				UPDATE academico_grupoaula SET data_inicio = @INICIO, data_termino = @TERMINO WHERE id = @GRUPO_ID

				fetch next from abc into @GRUPO_ID, @INICIO, @TERMINO
			END
	close abc 
deallocate abc 
GO
