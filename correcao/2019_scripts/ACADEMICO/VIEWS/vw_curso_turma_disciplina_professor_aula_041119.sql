create or alter  view vw_curso_turma_disciplina_professor_aula as   
select cur.id as curso_id, cur.nome as curso_nome,    
       tur.id as turma_id, tur.nome as turma_nome,   
       dis.id as disciplina_id, dis.nome as disciplina_nome,   
       pro.id as professor_id, pro.nome as professor_nome,  
       aul.id as aula_id, aul.data_inicio, aul.data_termino, aul.grupo_id as grupo_aula_id, aul.agendamento_id,
	   tda.id as turma_disciplina_id 
  from academico_turmadisciplina tda join academico_turma      tur on (tur.id = tda.turma_id)  
                                     join academico_disciplina dis on (dis.id = tda.disciplina_id)  
                                     join academico_curso      cur on (cur.id = tur.curso_id)  
                                     join academico_aula       aul on (tda.id = aul.turma_disciplina_id)  
                                     join academico_professor  pro on (pro.id = aul.professor_id)