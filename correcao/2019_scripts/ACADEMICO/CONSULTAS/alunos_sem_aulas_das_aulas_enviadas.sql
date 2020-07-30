with cte_aulas as (
select aul.id as aula_id, tda.aluno_id, tds.id as turmaDisciplina_id 
  from academico_aula aul join academico_turmadisciplina      tds on (tds.id = aul.turma_disciplina_id)
                          join academico_turmadisciplinaaluno tda on (tds.id = tda.turma_disciplina_id)
 where aul.status_id = 3
)


select * from cte_aulas aul left join academico_frequenciadiaria fre on (aul.aula_id = fre.aula_id and 
                                                                         aul.aluno_id = fre.aluno_id)

where fre.id is null 


