with cte_lista as (
select tda.id, tda.aluno_id, disciplina_id = disc.id, disciplina_nome = disc.nome, exigencia_matricula_disciplina_id = isnull(exigencia_matricula_disciplina_id, -1), 
status_matricula_disciplina_id = isnull(status_matricula_disciplina_id,-1),  
tipo_matricula_id = ISNULL(tipo_matricula_id,-1),
qtd = count(1)  

from academico_turmadisciplinaaluno tda
join academico_turmadisciplina td on td.id = tda.turma_disciplina_id
join academico_turma turma on turma.id = td.turma_id
join academico_disciplina disc on disc.id = td.disciplina_id
-- where  turma_disciplina_id in (5117,5132,5624) and       aluno_id = 38192
group by tda.id,  tda.aluno_id, disc.id, disc.nome, isnull(exigencia_matricula_disciplina_id, -1),  isnull(status_matricula_disciplina_id,-1), ISNULL(tipo_matricula_id,-1)
), 

cte_problema as (
select  aluno_id, disciplina_id, disciplina_nome 
 from cte_lista 
 group by  aluno_id, disciplina_id, disciplina_nome 
 having COUNT(1) > 1) 


 select * from cte_problema

 select * from academico_turmadisciplinaaluno tda join academico_turmadisciplina td on (tda.turma_disciplina_id = td.id)
     where td.disciplina_id = 3858 and aluno_id =        45242                                      

 select distinct tda.*, ace.*
-- into tmp_academico_turmadisciplinaaluno_141019__1725
 /*update tda set tda.exigencia_matricula_disciplina_id = ace.exigencia_matricula_disciplina_id,
               tda.status_matricula_disciplina_id    = ace.status_matricula_disciplina_id, 
			   tda.tipo_matricula_id                 = ace.tipo_matricula_id*/
  from academico_turmadisciplinaaluno tda join academico_turmadisciplina trd on (tda.turma_disciplina_id = trd.id)
                                                  join cte_problema              pro on (pro.aluno_id = tda.aluno_id and 
												                                         pro.disciplina_id = trd.disciplina_id)
									              join cte_lista                 lis on (lis.aluno_id  = pro.aluno_id and 
												                                         lis.disciplina_id = pro.disciplina_id and 
																						 lis.status_matricula_disciplina_id = -1 and 
																						 lis.id = tda.id) 
												left  join cte_lista                 ace on (ace.aluno_id  = pro.aluno_id and 
												                                         ace.disciplina_id = pro.disciplina_id and 
																						 ace.status_matricula_disciplina_id <> -1  ) 
 where --tda.aluno_id = 38192 and 
       tda.atributos is not null and 
	   ace.id is not null 


