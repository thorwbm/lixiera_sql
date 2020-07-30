create or alter view VW_PRO_QUANTIDADE_ALUNO_PREMATRICULADO_TURMA_DISCIPLINA as   
select tds.id as turma_disciplina_id, COUNT(tda.id)  as quantidade  
  from academico_turmadisciplina tds left join academico_turmadisciplinaaluno tda on (tds.id = tda.turma_disciplina_id and 
                                                                                      status_matricula_disciplina_id = 14)  
  group by tds.id  