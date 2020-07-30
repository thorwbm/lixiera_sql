  
-- ***** RODAR CARGA DAS SUBTURMAS PARA TODOS OS ALUNOS JA PRE ENTURMADOS COM DISCPLINA PAI  
CREATE OR ALTER  PROCEDURE SP_PRO_CARGA_SUBTURMA_CURRICULO @CURRICULO_ID int AS   
  
DECLARE @CURRICULOALUNO_ID int 
DECLARE @CURRICULO_NOME VARCHAR(200) 
DECLARE @TURMA_NOME VARCHAR(200)
DECLARE @ALUNO_NOME VARCHAR(200)
  
 declare CUR_SUB cursor for   
 ----------------------------------------------------------  
 SELECT  DISTINCT CURRICULOALUNO_ID, CURRICULO_NOME,  TURMA_NOME, ALUNO_NOME   
      from vw_aluno_curriculo_curso_turma_etapa_discplina ted  
     where STATUS_TURMADISCIPLINAALUNO = 'Pr�-enturmado' AND  
        CURRICULO_ID = @CURRICULO_ID 
	ORDER BY CURRICULO_NOME,  TURMA_NOME, ALUNO_NOME
 ----------------------------------------------------------  
 open CUR_SUB   
  fetch next from CUR_SUB into @CURRICULOALUNO_ID, @CURRICULO_NOME,  @TURMA_NOME, @ALUNO_NOME     
  while @@FETCH_STATUS = 0  
   BEGIN  
    EXEC SP_PRO_CARGA_SUBTURMAS_ALUNO @CURRICULOALUNO_ID  
  
   fetch next from CUR_SUB into  @CURRICULOALUNO_ID, @CURRICULO_NOME,  @TURMA_NOME, @ALUNO_NOME
   END  
 close CUR_SUB   
deallocate CUR_SUB   
  
  
  
  
  
  
  