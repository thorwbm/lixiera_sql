USE [erp_hmg]
GO
/****** Object:  StoredProcedure [dbo].[SET_ACADEMICO_ALUNO]    Script Date: 12/02/2020 15:40:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SET_ACADEMICO_ALUNO]
AS
DECLARE @UNIVERSUS_NOME         VARCHAR(100)
DECLARE @UNIVERSUS_ALUNO        INT
DECLARE @UNIVERSUS_ESCOLA       INT

DECLARE @EDUCAT_ALUNO           INT

DECLARE POPULA_ALUNO_EDUCAT CURSOR FOR

SELECT DISTINCT NOME, E.CODALUNO, E.CODESCOLA
FROM UNIVERSUS..ALUNO A
JOIN UNIVERSUS..PESSOA P ON P.CODPESSOA = A.CODPESSOA
JOIN UNIVERSUS..ENTURMA E ON E.CODESCOLA = A.CODESCOLA AND
                  E.CODALUNO = A.CODALUNO
WHERE E.CODESCOLA = 1
AND E.ANO = 2019
--AND E.CODALUNO = 51698
--AND E.CODCURSO = 1
--AND E.CODALUNO = 51695

OPEN POPULA_ALUNO_EDUCAT
FETCH NEXT FROM POPULA_ALUNO_EDUCAT INTO @UNIVERSUS_NOME, @UNIVERSUS_ALUNO, @UNIVERSUS_ESCOLA
WHILE @@FETCH_STATUS = 0
BEGIN
  
  SET @EDUCAT_ALUNO = 0
  
  SELECT @EDUCAT_ALUNO = ISNULL(ID,0)
  FROM ACADEMICO_ALUNO
  WHERE ALUNO_UNIVERSUS_ID = @UNIVERSUS_ALUNO AND ESCOLA_ALUNO_UNIVERSUS_ID = @UNIVERSUS_ESCOLA
  
  IF (SELECT COUNT(1)
      FROM ACADEMICO_ALUNO
	  WHERE ID = @EDUCAT_ALUNO
      ) = 0
  BEGIN
    
	INSERT INTO ACADEMICO_ALUNO
	VALUES (@UNIVERSUS_NOME, NULL, @UNIVERSUS_ALUNO, @UNIVERSUS_ESCOLA, GETDATE(), NULL)

	PRINT 'ALUNO INSERIDO: '+ CONVERT(VARCHAR(100),@UNIVERSUS_NOME) 
  END
  ELSE
  BEGIN
    PRINT 'NÃO INSERIU O ALUNO: ' +@UNIVERSUS_NOME+ ' NESTE PROCESSO'
  END

  FETCH NEXT FROM POPULA_ALUNO_EDUCAT INTO @UNIVERSUS_NOME, @UNIVERSUS_ALUNO, @UNIVERSUS_ESCOLA

END
CLOSE POPULA_ALUNO_EDUCAT
DEALLOCATE POPULA_ALUNO_EDUCAT

GO
