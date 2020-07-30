SELECT *
 FROM academico_turmadisciplinaaluno TDA JOIN 


 select TD.ID, aluno.nome, tda.aluno_id, turma.nome, disc.nome , DISC.ID, TURMA.ID, CRC.curriculo_id
from academico_turmadisciplinaaluno tda
join academico_turmadisciplina td on td.id = tda.turma_disciplina_id
join academico_turma turma on turma.id = td.turma_id
join academico_disciplina disc on disc.id = td.disciplina_id
join academico_aluno aluno on aluno.id = tda.aluno_id 
JOIN curriculos_aluno CRC ON (CRC.aluno_id = ALUNO.ID AND CRC.status_id = 13)
WHERE ALUNO.ID = 38204 AND 
     DISC.NOME = 'INTERNATO DE SAÚDE DO IDOSO' AND 
	 TURMA.NOME = '5MABP03'

-- ***** VERIFICAR SE A DISCIPLINA ESTA NA GRADE DO CURRICULO ATIVO DO ALUNO 
 SELECT * FROM vw_curriculo_grade_disciplina WHERE curriculo_id = 2285

 DECLARE @TURMADISCIPLINA_ID INT = 10263


delete FROM #TMP
INSERT INTO #TMP
select TDS_ID = 11351 INTO #TMP

select * from tmp_higienizacao_turma_disciplina where disciplina_NOME = 'INTERNATO DE SAÚDE DO IDOSO'

 SELECT * into #temp FROM (
SELECT TURMA_DISCIPLINA_ID, QTD = COUNT(1), TABELA = 'academico_turmadisciplinaaluno' FROM academico_turmadisciplinaaluno                                 WHERE turma_disciplina_id IN (SELECT TDS_ID FROM #TMP )GROUP BY TURMA_DISCIPLINA_ID UNION 
SELECT TURMA_DISCIPLINA_ID, QTD = COUNT(1), TABELA = 'academico_turmadisciplinaprofessor' FROM academico_turmadisciplinaprofessor						 WHERE TURMA_DISCIPLINA_ID  IN (SELECT TDS_ID FROM #TMP )GROUP BY TURMA_DISCIPLINA_ID UNION 
SELECT TURMA_DISCIPLINA_ID, QTD = COUNT(1), TABELA = 'academico_grupoaula' FROM academico_grupoaula														 WHERE TURMA_DISCIPLINA_ID  IN (SELECT TDS_ID FROM #TMP )GROUP BY TURMA_DISCIPLINA_ID UNION 
SELECT TURMA_DISCIPLINA_ID, QTD = COUNT(1), TABELA = 'materiais_didaticos_publicacao_turmadisciplina' FROM materiais_didaticos_publicacao_turmadisciplina WHERE TURMA_DISCIPLINA_ID IN (SELECT TDS_ID FROM #TMP )GROUP BY TURMA_DISCIPLINA_ID UNION 
SELECT TURMA_DISCIPLINA_ID, QTD = COUNT(1), TABELA = 'aulas_agendamento' FROM aulas_agendamento															 WHERE TURMA_DISCIPLINA_ID  IN (SELECT TDS_ID FROM #TMP )GROUP BY TURMA_DISCIPLINA_ID UNION 
SELECT TURMA_DISCIPLINA_ID, QTD = COUNT(1), TABELA = 'atividades_protocolosegundachamadaprova' FROM atividades_protocolosegundachamadaprova				 WHERE TURMA_DISCIPLINA_ID  IN (SELECT TDS_ID FROM #TMP )GROUP BY TURMA_DISCIPLINA_ID UNION 
SELECT TURMA_DISCIPLINA_ID, QTD = COUNT(1), TABELA = 'atividades_criterio_turmadisciplina' FROM atividades_criterio_turmadisciplina						 WHERE TURMA_DISCIPLINA_ID  IN (SELECT TDS_ID FROM #TMP )GROUP BY TURMA_DISCIPLINA_ID UNION 
SELECT TURMA_DISCIPLINA_ID, QTD = COUNT(1), TABELA = 'frequencias_excecaofrequenciaforaprazo' FROM frequencias_excecaofrequenciaforaprazo				 WHERE TURMA_DISCIPLINA_ID  IN (SELECT TDS_ID FROM #TMP )GROUP BY TURMA_DISCIPLINA_ID UNION 
SELECT TURMA_DISCIPLINA_ID, QTD = COUNT(1), TABELA = 'frequencias_protocolofrequenciaforaprazo' FROM frequencias_protocolofrequenciaforaprazo			 WHERE TURMA_DISCIPLINA_ID  IN (SELECT TDS_ID FROM #TMP )GROUP BY TURMA_DISCIPLINA_ID UNION 
SELECT TURMA_DISCIPLINA_ID, QTD = COUNT(1), TABELA = 'academico_complementacaocargahoraria' FROM academico_complementacaocargahoraria					 WHERE TURMA_DISCIPLINA_ID  IN (SELECT TDS_ID FROM #TMP )GROUP BY TURMA_DISCIPLINA_ID UNION 
SELECT TURMA_DISCIPLINA_ID, QTD = COUNT(1), TABELA = 'aulas_pendentes' FROM aulas_pendentes																 WHERE TURMA_DISCIPLINA_ID  IN (SELECT TDS_ID FROM #TMP )GROUP BY TURMA_DISCIPLINA_ID UNION 
SELECT TURMA_DISCIPLINA_ID, QTD = COUNT(1), TABELA = 'frequencias_revisao' FROM frequencias_revisao														 WHERE TURMA_DISCIPLINA_ID  IN (SELECT TDS_ID FROM #TMP )GROUP BY TURMA_DISCIPLINA_ID UNION 
SELECT TURMA_DISCIPLINA_ID, QTD = COUNT(1), TABELA = 'academico_aula' FROM academico_aula																 WHERE TURMA_DISCIPLINA_ID  IN (SELECT TDS_ID FROM #TMP )GROUP BY TURMA_DISCIPLINA_ID 
) AS TAB 

select * from #temp where turma_disciplina_id in (13773,
14243)


select turma_disciplina_id, count(1)
from #temp group by turma_disciplina_id order by 2 desc 


select * from vw_aluno_curriculo_curso_turma_etapa_discplina where TURMADISCIPLINA_ID = 10304

