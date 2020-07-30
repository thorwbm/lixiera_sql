
select DISTINCT 
       public_identifier = login,
       name = aluno,
       grade_name = serie,
       class_value = turma_id,
       unity_value = colegio_id,
       unity_name  = colegio,
       class_name  = turma,
       provider_name = 'SAE',
       provider_value = 'SAE'

  from 
       Prospects_ava_conquista con  
ORDER BY ALUNO

       SELECT DISTINCT serie  from 
       Prospects_ava_conquista
       WHERE SERIE NOT IN (
       select NAME from hierarchy_hierarchy WHERE TYPE = 'GRADE')
       SELECT DISTINCT serie  from 
       Prospects_ava_conquista


       select top 100 * from auth_user 