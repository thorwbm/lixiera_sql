USE [erp_hmg]
GO
/****** Object:  StoredProcedure [dbo].[SET_TURMA_DISCIPLINA_ALUNO_2018]    Script Date: 09/01/2020 18:38:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [dbo].[SET_TURMA_DISCIPLINA_ALUNO_2018] AS

DECLARE @UNIVERSUS_ESCOLA       INT
DECLARE @UNIVERSUS_ALUNO        INT
DECLARE @UNIVERSUS_TURMA        VARCHAR(20)
DECLARE @UNIVERSUS_DISCIPLINA   INT
DECLARE @UNIVERSUS_CODCURSO     INT

DECLARE @EDUCAT_TURMA           INT
DECLARE @EDUCAT_DISCIPLINA      INT
DECLARE @EDUCAT_ALUNO           INT
DECLARE @EDUCAT_TURMADISCIPLINA INT
DECLARE @EDUCAT_CODCURSO        INT

DECLARE POPULA_TURMADISCIPLINAALUNO_EDUCAT CURSOR FOR

SELECT E.CODESCOLA, E.CODALUNO, E.TURMA, E.CODDISCIPLINA, E.CODCURSO
FROM UNIVERSUS..ENTURMA E
JOIN UNIVERSUS..TURMA T ON T.CODESCOLA = E.CODESCOLA
                       AND T.ANO = E.ANO
					   AND T.REGIME = E.REGIME
					   AND T.PERIODO = E.PERIODO
					   AND T.TURMA = E.TURMA
WHERE E.CODESCOLA = 1 
AND E.ANO = 2018 
AND E.CODSTATUS IN (1,2) 
--AND E.CODDISCIPLINA NOT IN (57) -- CLÍNICA MÉDICA II
AND E.TURMA NOT IN ('4MB1º(TPA)P01', '4MB1º(TPA)P02', '4MB1º(TPA)P03', '4MB1º(TPA)P04')
--AND E.CODCURSO = 1
AND E.TURMA IS NOT NULL
AND T.DTINICIAL >= CONVERT(DATETIME,'01/01/2019',103)
--AND CODALUNO = 43382

OPEN POPULA_TURMADISCIPLINAALUNO_EDUCAT
FETCH NEXT FROM POPULA_TURMADISCIPLINAALUNO_EDUCAT INTO @UNIVERSUS_ESCOLA, @UNIVERSUS_ALUNO, @UNIVERSUS_TURMA, @UNIVERSUS_DISCIPLINA, @UNIVERSUS_CODCURSO
WHILE @@FETCH_STATUS = 0
BEGIN
  
  SET @EDUCAT_ALUNO = 0
  
  SELECT @EDUCAT_ALUNO = ISNULL(ID,0)
  FROM ACADEMICO_ALUNO
  WHERE ALUNO_UNIVERSUS_ID = @UNIVERSUS_ALUNO AND ESCOLA_ALUNO_UNIVERSUS_ID = @UNIVERSUS_ESCOLA

  SET @EDUCAT_CODCURSO = 0
	
  SELECT @EDUCAT_CODCURSO = ISNULL(ID,0)
  FROM ACADEMICO_CURSO
  WHERE CURSO_UNIVERSUS_ID = @UNIVERSUS_CODCURSO AND ESCOLA_CURSO_UNIVERSUS_ID = @UNIVERSUS_ESCOLA  

  SET @EDUCAT_TURMA = 0
  
  SELECT @EDUCAT_TURMA = ISNULL(ID,0)
  FROM ACADEMICO_TURMA
  WHERE NOME = @UNIVERSUS_TURMA AND CURSO_ID = @EDUCAT_CODCURSO

  /*
  SELECT ID
  FROM ACADEMICO_TURMA
  WHERE NOME = '4MB2º(TA)A02'
  */

  SET @EDUCAT_DISCIPLINA = 0

  SELECT @EDUCAT_DISCIPLINA = ISNULL(ID,0)
  FROM ACADEMICO_DISCIPLINA
  WHERE DISCIPLINA_UNIVERSUS_ID = @UNIVERSUS_DISCIPLINA

  /*
  SELECT ID
  FROM EDUCAT_ERP_FREQUENCIA.DBO.ACADEMICO_DISCIPLINA
  WHERE DISCIPLINA_UNIVERSUS_ID = 1534
  */

  SET @EDUCAT_TURMADISCIPLINA = 0
  
  SELECT @EDUCAT_TURMADISCIPLINA = ISNULL(ID,0)
  FROM ACADEMICO_TURMADISCIPLINA
  WHERE TURMA_UNIVERSUS = @UNIVERSUS_TURMA AND DISCIPLINA_UNIVERSUS_ID = @UNIVERSUS_DISCIPLINA
  
 /* 
  SELECT ID
  FROM ACADEMICO_TURMADISCIPLINA WITH(NOLOCK)
  WHERE TURMA_UNIVERSUS = '4MB2º(TA)A02' AND DISCIPLINA_UNIVERSUS_ID = 1534
  */

  IF (SELECT COUNT(1)
      FROM ACADEMICO_TURMADISCIPLINAALUNO
	  WHERE ALUNO_ID = @EDUCAT_ALUNO AND TURMA_DISCIPLINA_ID = @EDUCAT_TURMADISCIPLINA
      ) = 0

	  /*
	  SELECT COUNT(1)
      FROM ACADEMICO_TURMADISCIPLINAALUNO
	  WHERE ALUNO_ID = 45415 AND TURMA_DISCIPLINA_ID = @EDUCAT_TURMADISCIPLINA
	  */
  BEGIN
    
	INSERT INTO ACADEMICO_TURMADISCIPLINAALUNO
	VALUES (@EDUCAT_ALUNO, @EDUCAT_TURMADISCIPLINA, NULL, GETDATE())

	PRINT 'ALUNO INSERIDO: ' +CONVERT(VARCHAR(100),@EDUCAT_ALUNO)+ ' NA TURMA: '+@UNIVERSUS_TURMA+ ' NESTE PROCESSO'
  END
  ELSE
  BEGIN
    PRINT 'NÃO INSERIU O ALUNO: ' +CONVERT(VARCHAR(100),@EDUCAT_ALUNO)+ ' NESTE PROCESSO'
  END

  FETCH NEXT FROM POPULA_TURMADISCIPLINAALUNO_EDUCAT INTO @UNIVERSUS_ESCOLA, @UNIVERSUS_ALUNO, @UNIVERSUS_TURMA, @UNIVERSUS_DISCIPLINA, @UNIVERSUS_CODCURSO

END
CLOSE POPULA_TURMADISCIPLINAALUNO_EDUCAT
DEALLOCATE POPULA_TURMADISCIPLINAALUNO_EDUCAT

GO
