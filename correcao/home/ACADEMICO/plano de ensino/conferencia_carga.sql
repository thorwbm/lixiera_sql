select distinct 
       act.curso_id, act.curso_nome, 
       act.disciplina_id, act.disciplina_nome,
       ple.id as plano_ensino_id, ple.matriz, ple.carga_horaria, ple.ano, ple.etapa_ano_id
  from vw_acd_curso_turma_disciplina_grade act left join planos_ensino_planoensino ple on(act.disciplina_id = ple.disciplina_id and 
                                                                                          ple.ano = 2020 and
                                                                                          act.curso_id      = ple.curso_id)
 where  
       act.turma_ano = 2020
 order by 2,4