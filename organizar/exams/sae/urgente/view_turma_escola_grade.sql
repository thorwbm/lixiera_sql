SELECT * FROM vw_turma_escola_grade
WHERE turma_nome = '701'

SELECT TOP 100  * FROM  hierarchy_hierarchy
where type = 'class'




INSERT INTO hierarchy_hierarchy (type,	value,	name,	parent_id)
SELECT type = 'class', value =  newid(), name = turmanome, parent_id = NULL 
  FROM (
SELECT distinct alu.turmanome
FROM temp_alunos alu left JOIN hierarchy_hierarchy hie ON (alu.TurmaNome = hie.name AND hie.type = 'class')
WHERE hie.id IS NULL AND alu.usuarioid NOT IN (SELECT usuarioid FROM tmp_aluno_nao_importado)
) AS tab



--SELECT * FROM tmp_aluno_nao_importado

--SELECT motivo = 'turmas problema                                                                                          ',
--       alu.*
--	  into tmp_aluno_nao_importado
--FROM temp_alunos alu left JOIN hierarchy_hierarchy hie ON (alu.TurmaNome = hie.name AND hie.type = 'class')
--WHERE hie.id IS NULL AND 
--      alu.turmanome LIKE '%,%'

CREATE VIEW vw_turma_escola_grade AS   
SELECT  json_value(usu.extra,'$.hierarchy.class.value') AS turma_id,  
               json_value(usu.extra,'$.hierarchy.class.name') AS turma_nome,        
               json_value(usu.extra,'$.hierarchy.unity.value') AS escola_id,  
               json_value(usu.extra,'$.hierarchy.grade.value') AS grade_id  
FROM auth_user usu  
GROUP BY  json_value(usu.extra,'$.hierarchy.class.value') ,  
               json_value(usu.extra,'$.hierarchy.class.name'),        
               json_value(usu.extra,'$.hierarchy.unity.value') ,  
               json_value(usu.extra,'$.hierarchy.grade.value') 