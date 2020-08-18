CREATE VIEW VW_ACD_ALUNOS_MATRICULADOS_POR_TURMA_DISCIPLINA AS 
SELECT TURMA_ID, turma_nome, DISCIPLINA_ID, disciplina_nome, CURRICULO_ID, curriculo_nome, COUNT(ALUNO_ID) AS QTD_MATRICULADO
FROM vw_curriculo_curso_turma_disciplina_aluno_grade GRA
WHERE status_mat_dis_id = 14
GROUP BY TURMA_ID, turma_nome, DISCIPLINA_ID, disciplina_nome, CURRICULO_ID, curriculo_nome