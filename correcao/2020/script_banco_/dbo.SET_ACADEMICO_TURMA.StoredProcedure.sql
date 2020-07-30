USE [erp_hmg]
GO
/****** Object:  StoredProcedure [dbo].[SET_ACADEMICO_TURMA]    Script Date: 09/01/2020 18:38:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SET_ACADEMICO_TURMA] AS

DECLARE @UNIVERSUS_ESCOLA    INT
DECLARE @UNIVERSUS_ANO          INT
DECLARE @UNIVERSUS_REGIME       INT
DECLARE @UNIVERSUS_PERIODO      INT
DECLARE @UNIVERSUS_TURMA        VARCHAR(20)
DECLARE @UNIVERSUS_DISCIPLINA   INT
DECLARE @UNIVERSUS_CODCURSO     INT

DECLARE @EDUCAT_TURMA           INT
DECLARE @EDUCAT_DISCIPLINA      INT
DECLARE @EDUCAT_CODCURSO        INT

DECLARE POPULA_TURMA_DISCIPLINA_EDUCAT CURSOR FOR

SELECT T.CODESCOLA, T.ANO, T.REGIME, T.PERIODO, T.TURMA, T.CODCURSO
FROM UNIVERSUS..TURMA T
WHERE T.CODESCOLA = 1 AND T.ANO = 2019 
--AND T.CODCURSO = 1
ORDER BY TURMA

OPEN POPULA_TURMA_DISCIPLINA_EDUCAT
FETCH NEXT FROM POPULA_TURMA_DISCIPLINA_EDUCAT INTO @UNIVERSUS_ESCOLA, @UNIVERSUS_ANO, @UNIVERSUS_REGIME, @UNIVERSUS_PERIODO, @UNIVERSUS_TURMA, @UNIVERSUS_CODCURSO
WHILE @@FETCH_STATUS = 0
BEGIN
  
  SET @EDUCAT_TURMA = 0
  
  SET @EDUCAT_CODCURSO = 0
	
  SELECT @EDUCAT_CODCURSO = ISNULL(ID,0)
  FROM ACADEMICO_CURSO
  WHERE CURSO_UNIVERSUS_ID = @UNIVERSUS_CODCURSO AND ESCOLA_CURSO_UNIVERSUS_ID = @UNIVERSUS_ESCOLA  

  SELECT @EDUCAT_TURMA = ISNULL(ID,0)
  FROM ACADEMICO_TURMA
  WHERE NOME = @UNIVERSUS_TURMA AND CURSO_ID = @EDUCAT_CODCURSO

/*
  SELECT *
  --ISNULL(ID,0)
  FROM ACADEMICO_TURMA
  WHERE NOME = '10E1º' AND CURSO_ID = 6
*/

  IF (SELECT COUNT(1)
      FROM ACADEMICO_TURMA
	  WHERE ID = @EDUCAT_TURMA
      ) = 0
  BEGIN
    
	SET @EDUCAT_CODCURSO = 0
	
	SELECT @EDUCAT_CODCURSO = ISNULL(ID,0)
	FROM ACADEMICO_CURSO
	WHERE CURSO_UNIVERSUS_ID = @UNIVERSUS_CODCURSO AND ESCOLA_CURSO_UNIVERSUS_ID = @UNIVERSUS_ESCOLA
	
	INSERT INTO ACADEMICO_TURMA
	VALUES (@UNIVERSUS_TURMA, @EDUCAT_CODCURSO, NULL, GETDATE())

	PRINT 'TURMA INSERIDA: '+@UNIVERSUS_TURMA+ ' NESTE PROCESSO'
  END
  ELSE
  BEGIN
    PRINT 'NÃO INSERIU UMA TURMA: ' +@UNIVERSUS_TURMA+ ' NESTE PROCESSO'
  END

  FETCH NEXT FROM POPULA_TURMA_DISCIPLINA_EDUCAT INTO @UNIVERSUS_ESCOLA, @UNIVERSUS_ANO, @UNIVERSUS_REGIME, @UNIVERSUS_PERIODO, @UNIVERSUS_TURMA, @UNIVERSUS_CODCURSO

END
CLOSE POPULA_TURMA_DISCIPLINA_EDUCAT
DEALLOCATE POPULA_TURMA_DISCIPLINA_EDUCAT

GO
