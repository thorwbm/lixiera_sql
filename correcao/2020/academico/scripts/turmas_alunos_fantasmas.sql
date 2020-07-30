select tur.id as turma_id, tur.nome as turma_nome, 
       dis.id as disciplina_id, dis.nome as disciplina_nome, 
	   alu.id as aluno_id, alu.nome as aluno_nome,
	   aul.data_inicio, aul.data_termino

  from academico_frequenciadiaria fre join academico_aula aul on (aul.id = fre.aula_id)
                                      join academico_turmadisciplina tds on (tds.id = aul.turma_disciplina_id)
									  join academico_turma                tur on (tur.id = tds.turma_id)
									  join academico_disciplina           dis on (dis.id = tds.disciplina_id)
									  join academico_aluno                alu on (alu.id = fre.aluno_id)
                                 left join academico_turmadisciplinaaluno tda on (aul.turma_disciplina_id = tda.turma_disciplina_id and 
								                                                  fre.aluno_id = tda.aluno_id)
  where tda.id is null 