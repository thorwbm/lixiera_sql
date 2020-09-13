create view VW_VETOR_RESPOSTA AS 
WITH CTE_AGENDADO AS (
select distinct 
       col.id as prova_id, col.name as prova_nome, 
	   exa.id as exame_id, exa.name as exame_nome,app.id as application_id,	  
	   json_value(usu.extra, '$.hierarchy.unity.name')      as escola_nome,
	   json_value(usu.extra, '$.hierarchy.unity.value')     as escola_id,
	   json_value(usu.extra, '$.hierarchy.class.name')      as turma_nome,
	   json_value(usu.extra, '$.hierarchy.class.value')     as turma_id,
	   json_value(usu.extra, '$.hierarchy.grade.name')      as grade_nome,
	   json_value(usu.extra, '$.hierarchy.grade.value')     as grade_id,
	   json_value(usu.extra, '$.hierarchy.discipline.name') as disciplina_nome,
	   usu.id as ALUNO_ID, usu.name as ALUNO_NOME, usu.public_identifier as aluno_identificador
	   
			from exam_exam exa with(nolock) join exam_collection         col with(nolock) on (col.id = exa.collection_id)
										    join application_application app with(nolock) on (exa.id = app.exam_id)
										    join auth_user               usu with(nolock) on (usu.id = app.user_id)
)

SELECT distinct 
       aluno_id, aluno_nome, aluno_identificador, prova_id, prova_nome, exame_id, exame_nome, 
       escola_id, escola_nome, turma_id, turma_Nome, grade_id, grade_nome, disciplina_nome, 
	   dbo.FN_GABARITO_ALUNO(application_id) as aluno_gabarito, 
	   DBO.FN_GABARITO_EXAME(exame_id) AS GABARITO_EXAME
FROM CTE_AGENDADO WHERE 
aluno_nome = 'Clarice Barbosa Da Costa' and 
      escola_nome = 'Anglo Zona Oeste' and 
	  prova_nome = 'Desafio SAE de Ensino Médio 2°BI - 1ª série'


	
