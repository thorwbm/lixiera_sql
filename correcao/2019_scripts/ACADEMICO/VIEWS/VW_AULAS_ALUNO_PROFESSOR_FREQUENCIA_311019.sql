create or alter view vw_aulas_aluno_professor_frequencia as 
select aul.id as aula_id, aul.data_inicio as aula_data_ini,  aul.duracao as aula_duracao, aul.conteudo as aula_conteudo, 
       pro.id as professor_id, pro.nome as professor_nome, 
	   tur.id as turma_id, tur.nome as turma_nome, 
	   dis.id as disciplina_id, dis.nome as disciplina_nome, 
	   alu.id as aluno_id, alu.nome as aluno_nome, alu.ra as aluno_ra, 
	   sta.id as status_aula_id, sta.nome as status_aula_nome, 
	   fre.presente
  from academico_aula                  aul with(nolock)
       join academico_turmadisciplina  tds with(nolock) on (tds.id = aul.turma_disciplina_id) 
       join academico_statusaula       sta with(nolock) on (sta.id = aul.status_id) 
	   join academico_professor        pro with(nolock) on (pro.id = aul.professor_id) 
       join academico_turma            tur with(nolock) on (tur.id = tds.turma_id) 
       join academico_disciplina       dis with(nolock) on (dis.id = tds.disciplina_id) 
       join academico_frequenciadiaria fre with(nolock) on (aul.id = fre.aula_id ) 
       join academico_aluno            alu with(nolock) on (alu.id = fre.aluno_id) 