select distinct tda.id, tda.turma_id, tda.disciplina_id, 
tab1.turma_disciplina_id  as academico_aula, 
tab2.turma_disciplina_id  as academico_complementacaocargahoraria, 
tab3.turma_disciplina_id  as academico_grupoaula, 
tab4.turma_disciplina_id  as academico_turmadisciplinaaluno, 
tab5.turma_disciplina_id  as academico_turmadisciplinaprofessor, 
tab6.turma_disciplina_id  as atividades_criterio_turmadisciplina, 
tab7.turma_disciplina_id  as atividades_protocolosegundachamadaprova, 
tab8.turma_disciplina_id  as aulas_agendamento, 
tab9.turma_disciplina_id  as aulas_pendentes, 
tab10.turma_disciplina_id as frequencias_excecaofrequenciaforaprazo, 
tab11.turma_disciplina_id as frequencias_protocolofrequenciaforaprazo, 
tab12.turma_disciplina_id as frequencias_revisao, 
tab13.turma_disciplina_id as materiais_didaticos_publicacao_turmadisciplina

from academico_turmadisciplina tda 
left join academico_aula								 tab1   on (tab1.turma_disciplina_id  = tda.id )
left join academico_complementacaocargahoraria			 tab2   on (tab2.turma_disciplina_id  = tda.id )
left join academico_grupoaula							 tab3   on (tab3.turma_disciplina_id  = tda.id )
left join academico_turmadisciplinaaluno				 tab4   on (tab4.turma_disciplina_id  = tda.id )
left join academico_turmadisciplinaprofessor			 tab5   on (tab5.turma_disciplina_id  = tda.id )
left join atividades_criterio_turmadisciplina			 tab6   on (tab6.turma_disciplina_id  = tda.id )
left join atividades_protocolosegundachamadaprova		 tab7   on (tab7.turma_disciplina_id  = tda.id )
left join aulas_agendamento								 tab8   on (tab8.turma_disciplina_id  = tda.id )
left join aulas_pendentes								 tab9   on (tab9.turma_disciplina_id  = tda.id )
left join frequencias_excecaofrequenciaforaprazo		 tab10  on (tab10.turma_disciplina_id = tda.id )
left join frequencias_protocolofrequenciaforaprazo		 tab11  on (tab11.turma_disciplina_id = tda.id )
left join frequencias_revisao							 tab12  on (tab12.turma_disciplina_id = tda.id )
left join materiais_didaticos_publicacao_turmadisciplina tab13  on (tab13.turma_disciplina_id = tda.id )
where 
tda.id in (10037) --10037,10038,10039,10047,10088,10145)
and (
tab1.turma_disciplina_id  is not null or
tab2.turma_disciplina_id  is not null or
tab3.turma_disciplina_id  is not null or
tab4.turma_disciplina_id  is not null or
tab5.turma_disciplina_id  is not null or
tab6.turma_disciplina_id  is not null or
tab7.turma_disciplina_id  is not null or
tab8.turma_disciplina_id  is not null or
tab9.turma_disciplina_id  is not null or
tab10.turma_disciplina_id is not null or
tab11.turma_disciplina_id is not null or
tab12.turma_disciplina_id is not null or
tab13.turma_disciplina_id is not null ) 