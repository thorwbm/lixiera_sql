
select * 
  from vw_curso_turma_disciplina_professor_aula tdpa left join aulas_agendamento age on (tdpa.turma_disciplina_id = age.turma_disciplina_id and 
                                                                                         tdpa.professor_id        = age.professor_id        and 
																					     tdpa.agendamento_id      = age.id)
 where tdpa.turma_nome = '2MA2º2018-2' AND 
      CAST(aula_data_inicio as date) ='2019-11-09'
	  order by aula_id

-- ##########################################################################################

select aula_data_inicio, aula_data_termino, 
       AGD.data_inicio as agendamento_data_ini, AGD.data_termino as agendamento_data_termino, 
	   * 
  from vw_curso_turma_disciplina_professor_aula tdpa left join aulas_agendamento age on (tdpa.turma_disciplina_id = age.turma_disciplina_id and 
                                                                                         tdpa.professor_id        = age.professor_id        and 
																					     tdpa.agendamento_id      = age.id)
													 LEFT JOIN agendamento_agendamento AGD ON (age.agendamento_id = AGD.id)
 where age.id IS NOT NULL AND 
      NOT (CAST(TDPA.aula_data_inicio as date) BETWEEN AGD.data_inicio AND AGD.data_termino)

	  and aula_data_inicio > GETDATE()
	  order by aula_data_inicio

