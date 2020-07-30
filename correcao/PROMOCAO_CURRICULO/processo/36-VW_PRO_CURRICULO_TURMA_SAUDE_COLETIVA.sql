CREATE VIEW VW_PRO_CURRICULO_TURMA_SAUDE_COLETIVA AS   
SELECT DISTINCT curriculo_id, curriculo_nome, TURMA_ID, turma_nome, DISCIPLINA_ID, disciplina_nome,   
       GRADE_ID, GRADE_NOME, turma_disciplina_id  
FROM vw_acd_curriculo_curso_turma_disciplina  
WHERE disciplina_nome = 'INTERNATO DE SAÚDE COLETIVA' AND   
      --curriculo_nome = 'ENFERMAGEM 2016/10-1' AND   
   turma_disciplina_id IS NOT NULL 