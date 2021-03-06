USE [erp_hmg]
GO
/****** Object:  StoredProcedure [dbo].[DEL_ACADEMICO_TURMADISCIPLINAALUNO_2018]    Script Date: 12/02/2020 15:40:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DEL_ACADEMICO_TURMADISCIPLINAALUNO_2018] AS

DECLARE @UNIVERSUS_ESCOLA             INT
DECLARE @UNIVERSUS_ALUNO              INT
DECLARE @UNIVERSUS_TURMA              VARCHAR(20)
DECLARE @UNIVERSUS_DISCIPLINA         INT
DECLARE @UNIVERSUS_CODCURSO           INT
								      
DECLARE @EDUCAT_TURMA                 INT
DECLARE @EDUCAT_DISCIPLINA            INT
DECLARE @EDUCAT_ALUNO                 INT
DECLARE @EDUCAT_TURMADISCIPLINA       INT
DECLARE @EDUCAT_TURMADISCIPLINAALUNO  INT
DECLARE @EDUCAT_CODCURSO              INT

DECLARE APAGA_ALUNO_TURMA_DISCIPLINA_APOS_REMANEJAMENTO CURSOR FOR

SELECT E.CODESCOLA, E.CODALUNO, E.TURMA, E.CODDISCIPLINA, E.CODCURSO
FROM UNIVERSUS..ENTURMA E
JOIN UNIVERSUS..TURMA T ON T.CODESCOLA = E.CODESCOLA
                       AND T.ANO = E.ANO
					   AND T.REGIME = E.REGIME
					   AND T.PERIODO = E.PERIODO
					   AND T.TURMA = E.TURMA
WHERE E.CODESCOLA = 1 
AND E.ANO = 2018 
AND E.CODSTATUS NOT IN (1,2) -- 3,4,5,6,7,8
--AND E.CODDISCIPLINA NOT IN (57) -- CLÍNICA MÉDICA II
AND E.TURMA NOT IN ('4MB1º(TPA)P01', '4MB1º(TPA)P02', '4MB1º(TPA)P03', '4MB1º(TPA)P04')
--AND E.CODCURSO = 1
AND T.DTINICIAL >= CONVERT(DATETIME,'01/01/2019',103)
AND CODALUNO NOT IN (43382)

-- SELECT * FROM UNIVERSUS..PESSOA WHERE CODPESSOA IN (SELECT CODPESSOA FROM UNIVERSUS..ALUNO WHERE CODALUNO = 47606)

OPEN APAGA_ALUNO_TURMA_DISCIPLINA_APOS_REMANEJAMENTO
FETCH NEXT FROM APAGA_ALUNO_TURMA_DISCIPLINA_APOS_REMANEJAMENTO INTO @UNIVERSUS_ESCOLA, @UNIVERSUS_ALUNO, @UNIVERSUS_TURMA, @UNIVERSUS_DISCIPLINA, @UNIVERSUS_CODCURSO
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

  SET @EDUCAT_DISCIPLINA = 0
  
  SELECT @EDUCAT_DISCIPLINA = ISNULL(ID,0)
  FROM ACADEMICO_DISCIPLINA
  WHERE DISCIPLINA_UNIVERSUS_ID = @UNIVERSUS_DISCIPLINA

  SET @EDUCAT_TURMADISCIPLINA = 0
  
  SELECT @EDUCAT_TURMADISCIPLINA = ISNULL(ID,0)
  FROM ACADEMICO_TURMADISCIPLINA
  WHERE TURMA_UNIVERSUS = @UNIVERSUS_TURMA AND DISCIPLINA_UNIVERSUS_ID = @UNIVERSUS_DISCIPLINA
  
  IF (SELECT COUNT(1)
      FROM ACADEMICO_TURMADISCIPLINAALUNO
	  WHERE ALUNO_ID = @EDUCAT_ALUNO AND TURMA_DISCIPLINA_ID = @EDUCAT_TURMADISCIPLINA
      ) > 0
  BEGIN
    
    /*
	SELECT ID = @EDUCAT_TURMADISCIPLINAALUNO
    FROM ACADEMICO_TURMADISCIPLINAALUNO
	WHERE ALUNO_ID = @EDUCAT_ALUNO AND TURMA_DISCIPLINA_ID = @EDUCAT_TURMADISCIPLINA
	*/

	DELETE FROM ACADEMICO_TURMADISCIPLINAALUNO
	WHERE ALUNO_ID = @EDUCAT_ALUNO AND TURMA_DISCIPLINA_ID = @EDUCAT_TURMADISCIPLINA

	/*
	INSERT INTO ACADEMICO_TURMADISCIPLINAALUNOLOG
	VALUES (1, @EDUCAT_TURMADISCIPLINAALUNO, @EDUCAT_TURMADISCIPLINA, @EDUCAT_ALUNO, NULL, GETDATE(), NULL, NULL)
	*/

	PRINT 'O ALUNO ' +CONVERT(VARCHAR(100),@UNIVERSUS_ALUNO)+ ' FOI EXCLUIDO NA TURMA: '+@UNIVERSUS_TURMA+' / ' +CONVERT(VARCHAR(100),@EDUCAT_TURMA)+ ' DISCIPLINA: ' +CONVERT(VARCHAR(100),@UNIVERSUS_DISCIPLINA)+ ' / ' +CONVERT(VARCHAR(100),@EDUCAT_DISCIPLINA)+ ' NESTE PROCESSO'
  END
  ELSE
  BEGIN
    PRINT 'O ALUNO: ' +CONVERT(VARCHAR(100),@EDUCAT_ALUNO)+ ' NÃO ESTA VINCULADO A TURMA:' +@UNIVERSUS_TURMA+' / ' +CONVERT(VARCHAR(100),@EDUCAT_TURMA)+ ' DISCIPLINA: ' +CONVERT(VARCHAR(100),@UNIVERSUS_DISCIPLINA)+ ' / ' +CONVERT(VARCHAR(100),@EDUCAT_DISCIPLINA)+ ' NESTE PROCESSO'
  END

  FETCH NEXT FROM APAGA_ALUNO_TURMA_DISCIPLINA_APOS_REMANEJAMENTO INTO @UNIVERSUS_ESCOLA, @UNIVERSUS_ALUNO, @UNIVERSUS_TURMA, @UNIVERSUS_DISCIPLINA, @UNIVERSUS_CODCURSO

END
CLOSE APAGA_ALUNO_TURMA_DISCIPLINA_APOS_REMANEJAMENTO
DEALLOCATE APAGA_ALUNO_TURMA_DISCIPLINA_APOS_REMANEJAMENTO
GO
