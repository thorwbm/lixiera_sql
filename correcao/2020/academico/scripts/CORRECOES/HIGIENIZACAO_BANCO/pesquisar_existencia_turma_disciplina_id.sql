SELECT TURMA_DISCIPLINA_ID, tabela FROM (
SELECT TURMA_DISCIPLINA_ID, 'academico_turmadisciplinaaluno ' as tabela FROM academico_turmadisciplinaaluno UNION 
SELECT TURMA_DISCIPLINA_ID, 'academico_turmadisciplinaprofessor' as tabela FROM academico_turmadisciplinaprofessor UNION 
SELECT TURMA_DISCIPLINA_ID, 'academico_grupoaula' as tabela FROM academico_grupoaula UNION 
SELECT TURMA_DISCIPLINA_ID, 'materiais_didaticos_publicacao_turmadisciplina' as tabela FROM materiais_didaticos_publicacao_turmadisciplina UNION 
SELECT TURMA_DISCIPLINA_ID, 'aulas_agendamento' as tabela FROM aulas_agendamento UNION 
SELECT TURMA_DISCIPLINA_ID, 'atividades_protocolosegundachamadaprova' as tabela FROM atividades_protocolosegundachamadaprova UNION 
SELECT TURMA_DISCIPLINA_ID, 'atividades_criterio_turmadisciplina' as tabela FROM atividades_criterio_turmadisciplina UNION 
SELECT TURMA_DISCIPLINA_ID, 'frequencias_excecaofrequenciaforaprazo' as tabela FROM frequencias_excecaofrequenciaforaprazo UNION 
SELECT TURMA_DISCIPLINA_ID, 'frequencias_protocolofrequenciaforaprazo ' as tabela FROM frequencias_protocolofrequenciaforaprazo UNION 
SELECT TURMA_DISCIPLINA_ID, 'academico_complementacaocargahoraria ' as tabela FROM academico_complementacaocargahoraria UNION 
SELECT TURMA_DISCIPLINA_ID, 'aulas_pendentes' as tabela FROM aulas_pendentes UNION 
SELECT TURMA_DISCIPLINA_ID, 'frequencias_revisao' as tabela FROM frequencias_revisao UNION 
SELECT TURMA_DISCIPLINA_ID, 'academico_aula' as tabela FROM academico_aula ) AS TAB
WHERE TURMA_DISCIPLINA_ID IS NOT NULL and 
 turma_disciplina_id in (5142,12623)