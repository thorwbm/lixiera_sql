CREATE   PROCEDURE SP_PRO_RODAR_SUBTURMA_E_TURMAS_ESPECIAIS_COM @CURRICULO_ID INT AS   
  
DECLARE @CURRICULO_ALUNO_ID INT  
DECLARE @TURMA_NOME VARCHAR(100)  
declare @curriculo_nome varchar(200)  
declare @aluno_nome varchar(200)  
   
declare CUR_CARGA cursor for   
 -----------------------------------------------------------------------------  
   select tda_curriculo_aluno_id, turma_nome, curriculo_nome, aluno_nome   
     from vw_curriculo_curso_turma_disciplina_aluno_grade  
    where status_mat_dis_id = 14 and  
          turma_nome like '%t' and  
    curriculo_id = @CURRICULO_ID  
    GROUP BY tda_curriculo_aluno_id, turma_nome, curriculo_nome, aluno_nome   
    ORDER BY curriculo_nome,  aluno_nome  
 -----------------------------------------------------------------------------  
 open CUR_CARGA   
  fetch next from CUR_CARGA into @CURRICULO_ALUNO_ID, @TURMA_NOME, @curriculo_nome, @aluno_nome   
  while @@FETCH_STATUS = 0  
   BEGIN  
   -- exec SP_PRO_CARGA_SUBTURMAS_ALUNO @CURRICULO_ALUNO_ID  
  
             exec SP_PRO_INSERT_DISCIPLINA_ESPECIAL_GENERICO_COM @CURRICULO_ALUNO_ID, 'Integração Curricular', @TURMA_NOME  
   
             exec SP_PRO_INSERT_DISCIPLINA_ESPECIAL_GENERICO_COM @CURRICULO_ALUNO_ID, 'Treinamento de Habilidade', null  
  
  
   fetch next from CUR_CARGA into @CURRICULO_ALUNO_ID, @TURMA_NOME, @curriculo_nome, @aluno_nome   
   END  
 close CUR_CARGA   
deallocate CUR_CARGA   
  
  
  
  
  