
/*
SELECT 
  FROM atividades_atividade_aluno AAA WITH(NOLOCK) JOIN atividades_atividade                ATI  WITH(NOLOCK) ON (ATI.id = AAA.atividade_id)
                                                   JOIN atividades_criterio_turmadisciplina ACTD WITH(NOLOCK) ON (ACTD.id = ATI.criterio_turma_disciplina_id)
												   JOIN academico_turmadisciplina           ATD  WITH(NOLOCK) ON (ATD.id = ACTD.turma_disciplina_id)

*/
alter VIEW VW_CURSO_TURMA_DISCIPLINA_QTD_ATIVIDADE as 
SELECT ATD.id AS TURMA_DISCIPLINA_ID,  ACUR.id AS CURSO_ID, ACUR.nome AS CURSO_NOME, 
			   ATUR.id AS TURMA_ID, ATUR.nome AS TURMA_NOME, 
			   ADIS.id AS DISCIPLINA_ID, ADIS.nome AS DISCIPLINA_NOME, 
			   ati.id as atividade_id, ati.nome as atividade_nome,
			   SUM( CASE WHEN AAA.id IS NULL THEN 0 ELSE 1 END) AS ALUNOS_COM_NOTA_ATIVIDADE
				 FROM academico_turmadisciplina ATD WITH(NOLOCK)      JOIN academico_turma                     ATUR WITH(NOLOCK) ON (ATUR.id = ATD.turma_id)
																	  JOIN academico_disciplina                ADIS WITH(NOLOCK) ON (ADIS.id = ATD.disciplina_id)
																	  JOIN academico_curso                     ACUR WITH(NOLOCK) ON (ACUR.id = ATUR.curso_id)
																 LEFT JOIN atividades_criterio_turmadisciplina ACTD WITH(NOLOCK) ON (ATD.id = ACTD.turma_disciplina_id)
																 LEFT JOIN atividades_atividade                ATI  WITH(NOLOCK) ON  (ACTD.id = ATI.criterio_turma_disciplina_id)	
																 LEFT JOIN atividades_atividade_aluno          AAA	WITH(NOLOCK) ON (ATI.id = AAA.atividade_id)		
			  GROUP BY ATD.id, ACUR.id, ACUR.nome, ATUR.id, ATUR.nome, ADIS.id, ADIS.nome, ATI.id, ATI.nome										 					   