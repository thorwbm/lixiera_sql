DECLARE @PROVA VARCHAR(200) = '3� s�rie - Diagn�stica 2/2020 - 1� dia'
DECLARE @ESCOLA VARCHAR(200) = 'UNICA MASTER'
DECLARE @GRADE VARCHAR(100) = 'Extensivo'

SELECT CONVERT(VARCHAR(10),COUNT(DISTINCT ALUNO)) + ' ALUNOS' 
FROM VW_AGENDAMENTO_PROVA_ALUNO
where ESCOLA = @ESCOLA and 
      PROVA = @PROVA  AND 
	  GRADE = @GRADE

SELECT DISTINCT PROVA, ESCOLA, ALUNO, EXA_TWD_INICIO, EXA_TWD_TERMINO, APP_TWD_INICIO, APP_TWD_TERMINO 
FROM VW_AGENDAMENTO_PROVA_ALUNO
where ESCOLA = @ESCOLA and 
      PROVA LIKE   @PROVA  AND 
	  GRADE = @GRADE
ORDER BY 1,2,3

SELECT  * 
FROM VW_AGENDAMENTO_PROVA_ALUNO
where ESCOLA = @ESCOLA and 
      PROVA = @PROVA  AND 
	  GRADE = @GRADE
ORDER BY 1,2,5,4,3


select * from tmp_imp_bloquear where nome_escola_ava = @ESCOLA