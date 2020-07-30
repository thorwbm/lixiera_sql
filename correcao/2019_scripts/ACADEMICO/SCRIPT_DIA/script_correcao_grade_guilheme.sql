--begin tran;
with cte_turma_sem_grade as (
		select distinct tur.id as turma_id, tur.nome as turma_nome,  
		                cur.id as curso_id, cur.nome as curso_nome, 
						dis.id as disciplina_id, dis.nome as disciplina_nome, 
						trd.id as turmaDisciplina_id
		  from academico_turma tur with(nolock) join academico_curso cur with(nolock) on (cur.id = tur.curso_id)
		                                        join academico_turmadisciplina trd with(nolock) on (tur.id = trd.turma_id)
												join academico_disciplina      dis with(nolock) on (dis.id = trd.disciplina_id)
		 where grade_id is null  
),

     cte_turma_com_grade as (
		select distinct tur.id as turma_id, tur.nome as turma_nome,  
		                cur.id as curso_id, cur.nome as curso_nome, 
						dis.id as disciplina_id, dis.nome as disciplina_nome, 
						trd.id as turmaDisciplina_id
		  from academico_turma tur with(nolock) join academico_curso cur with(nolock) on (cur.id = tur.curso_id)
		                                        join academico_turmadisciplina trd with(nolock) on (tur.id = trd.turma_id)
												join academico_disciplina      dis with(nolock) on (dis.id = trd.disciplina_id)
		 where grade_id is not null  
)

	 --, cte_curso_turma_disciplina_aluno_sem as (
		select distinct tda.turma_disciplina_id, tda.aluno_id, cte.disciplina_id, cte.curso_id
		  from cte_turma_sem_grade cte with(nolock) join academico_turmadisciplinaaluno tda with(nolock) on (cte.turmaDisciplina_id = tda.turma_disciplina_id)
		  where aluno_id = 38573
)

	 --, cte_curso_turma_disciplina_aluno_com as (
		select distinct tda.turma_disciplina_id, tda.aluno_id, cte.disciplina_id, cte.curso_id
		  from cte_turma_com_grade cte with(nolock) join academico_turmadisciplinaaluno tda with(nolock) on (cte.turmaDisciplina_id = tda.turma_disciplina_id)
where aluno_id = 38573
)
 select distinct   turs.nome, turs.grade_id , turc.grade_id, turs.etapa_ano_id , turc.etapa_ano_id--, turc.nome --sem.*, turs.nome as turmasem, turs.grade_id, turc.grade_id as gradecom
-- update turs set turs.etapa_ano_id = turc.etapa_ano_id, turs.grade_id = turc.grade_id
 from cte_curso_turma_disciplina_aluno_sem sem join cte_curso_turma_disciplina_aluno_com com on (com.aluno_id = sem.aluno_id and 
                                                                                                          com.disciplina_id = sem.disciplina_id and 
																										  com.curso_id      = sem.curso_id)
														join academico_turmadisciplina            tdss on (tdss.id = sem.turma_disciplina_id)
														join academico_turma                      turs on (turs.id = tdss.turma_id)
														join academico_turmadisciplina            tdsc on (tdsc.id = com.turma_disciplina_id)
														join academico_turma                      turc on (turc.id = tdsc.turma_id)




-- commit