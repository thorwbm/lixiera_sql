create view vw_aula_professor_turma_disciplina as 
select aul.id as aula_id, aul.data_inicio as data_inicio, aul.data_termino as data_termino, aul.conteudo as aula_conteudo, 
       pro.id as professor_id, pro.nome as professor_nome, 
	   tur.id as turma_id, tur.nome as turma_nome, 
	   dis.id as disciplina_id, dis.nome as disciplina_nome, 
	   tds.id as turma_disciplina_id 
  from academico_aula aul with(nolock) join academico_turmadisciplina tds with(nolock) on (tds.id = aul.turma_disciplina_id)
                                       join academico_professor       pro with(nolock) on (pro.id = aul.professor_id)
									   join academico_turma           tur with(nolock) on (tur.id = tds.turma_id)
									   join academico_disciplina      dis with(nolock) on (dis.id = tds.disciplina_id)

