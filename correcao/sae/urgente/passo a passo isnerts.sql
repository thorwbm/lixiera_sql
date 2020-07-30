CREATE or alter VIEW vw_turma_escola_grade AS     
SELECT distinct json_value(usu.extra,'$.hierarchy.class.value') AS turma_id,    
                json_value(usu.extra,'$.hierarchy.class.name') AS turma_nome,          
                json_value(usu.extra,'$.hierarchy.unity.value') AS escola_id,    
                json_value(usu.extra,'$.hierarchy.grade.value') AS grade_id    
FROM auth_user usu    
where json_value(usu.extra,'$.hierarchy.class.value') is not null 
GROUP BY  json_value(usu.extra,'$.hierarchy.class.value') ,    
          json_value(usu.extra,'$.hierarchy.class.name'),          
          json_value(usu.extra,'$.hierarchy.unity.value') ,    
          json_value(usu.extra,'$.hierarchy.grade.value')  

  SELECT tem.* INTO tmp_alunos_importar 
    FROM temp_Alunos tem left JOIN auth_user usu ON (tem.UsuarioId = usu.username)
  WHERE usu.id IS NULL AND 
        NOT EXISTS (SELECT 1 FROM tmp_aluno_nao_importado tu WHERE tu.usuarioid = tem.UsuarioId)


------------------------------------------------------------------------------
-- BEGIN TRAN INSERT INTO  hierarchy_hierarchy
 SELECT distinct  type ='class',ta.usuariosturma, ta.turmanome, NULL  
   FROM tmp_alunos_importar ta left  JOIN hierarchy_hierarchy hie ON (hie.value = ta.usuariosturma AND type ='class' )
 where hie.id IS null 
-- COMMIT


BEGIN TRAN; WITH cte_grade AS (
			SELECT distinct name AS grade_nome, value AS grade_id
			 from hierarchy_hierarchy WHERE type = 'grade'
)

--INSERT INTO auth_user 
--      (password, is_superuser, username, is_staff, is_active, date_joined, name, public_identifier, 
--       extra, provider_id, created_at, updated_at, first_name, last_name, email)
SELECT DISTINCT   
       password = 'pbkdf2_sha256$180000$LmA3RFL35Vi6$6HIUlKjmZWX0aTbZq0RxFTh3IWdWBYlecPANz6mfj8o=',
       is_superuser = 0,
       username = ta.UsuarioId,
       is_staff = 0,
       is_active = 1,
       date_joined = GETDATE(),
       name = ta.UsuarioNome,
       public_identifier = ta.UsuarioId,
       extra =  '{"hierarchy": {"provider": {"value": "SAE", "name": "SAE"},'+
	                          ' "unity": {"name": "'+ta.escolanome   +'", "value": "'+ta.escolaid   +'"},'+
	                          ' "grade": {"name": "'+ gra.grade_nome +'", "value": "'+ gra.grade_id +'"},'+
	                          ' "class": {"name": "'+ tur.name +'", "value": "'+ tur.value +'"}}}',
       provider_id = 1,
       created_at = GETDATE(),
       updated_at = GETDATE(),
       first_name = CASE WHEN charindex(' ',UsuarioNome) > 0 THEN left (UsuarioNome,  charindex(' ',UsuarioNome)-1)
                                                             ELSE UsuarioNome END,
       last_name = ta.UsuarioNome,
       email = ''
  FROM tmp_alunos_importar ta JOIN cte_grade gra ON (gra.grade_nome = ta.UsuarioSerie)
                              JOIN  hierarchy_hierarchy tur ON (tur.value = ta.usuariosturma AND 
                                                               type ='class')
						LEFT JOIN auth_user xxx ON (xxx.username = ta.usuarioid)
	WHERE (xxx.id IS NULL AND
	      ta.usuarioid <> 'afdfe0b7f5aef989fc87bef79ad41018') OR 
          (ta.usuarioid = 'afdfe0b7f5aef989fc87bef79ad41018' AND  
		   tur.name  = '9º  A' AND xxx.id IS NULL)  


--  commit
--  rollback 

-------------------------------------------------------------------------------
select *  
--update tem set tem.usuarioserie = 'Extensivo'
from temp_alunos tem
where usuarioserie like '3ª série / Extensivo ,Extensivo%'
-------------------------------------------------------------------------------

SELECT motivo = 'turmas problema', alu.*
	--  into tmp_aluno_nao_importado
FROM temp_alunos alu left JOIN hierarchy_hierarchy hie ON (alu.TurmaNome = hie.name AND hie.type = 'class')
                     left join tmp_aluno_nao_importado imp on (alu.usuarioid = imp.usuarioid and imp.motivo = 'turmas problema')
WHERE hie.id IS NULL AND 
      alu.turmanome LIKE '%,%' and 
      imp.usuarioid is null 

insert into tmp_aluno_nao_importado
select 'problema serie',tem.*
--update tem set tem.usuarioserie = 'Extensivo'
from temp_alunos tem left join tmp_aluno_nao_importado imp on (tem.usuarioid = imp.usuarioid and imp.motivo = 'problema serie')
where tem.usuarioserie  like '%,%' and imp.usuarioid is null 

-----------------------------------------------------------------------


---INSERT INTO hierarchy_hierarchy (type,	value,	name,	parent_id)
SELECT type = 'class', value =  newid(), name = turmanome, parent_id = NULL 
  FROM (
SELECT distinct alu.turmanome
FROM temp_alunos alu left JOIN hierarchy_hierarchy hie ON (alu.TurmaNome = hie.name AND hie.type = 'class')
WHERE hie.id IS NULL AND alu.usuarioid NOT IN (SELECT usuarioid FROM tmp_aluno_nao_importado)
) AS tab

--------------------------------------------------------------------------

 begin tran insert into auth_user (password, is_superuser, username, is_staff, is_active, date_joined, name, public_identifier, 
                       extra, provider_id, created_at, updated_at, first_name, last_name, email)
select distinct
       password = 'pbkdf2_sha256$180000$LmA3RFL35Vi6$6HIUlKjmZWX0aTbZq0RxFTh3IWdWBYlecPANz6mfj8o=',
       is_superuser = 0,
       username = temp.UsuarioId,
       is_staff = 0,
       is_active = 1,
       date_joined = GETDATE(),
       name = temp.UsuarioNome,
       public_identifier = temp.UsuarioId,
       extra =  '{ "hierarchy": { "name": "' + temp.escolaNOme + '", "value": "' + temp.escolaid + '" }}',
       provider_id = 1,
       created_at = GETDATE(),
       updated_at = GETDATE(),
       first_name = CASE WHEN charindex(' ',UsuarioNome) > 0 THEN left (UsuarioNome,  charindex(' ',UsuarioNome)-1)
                                                             ELSE UsuarioNome END,
       last_name = temp.UsuarioNome,
       email = ''
  from temp_Coordenadores  temp left join auth_user xxx on (xxx.username = temp.UsuarioId and 
                                                                 xxx.name = temp.UsuarioNome)
 where xxx.id is null 
-- commit 
-- rollback

-------------------------------------------------------------------------------------------------------------------------
WITH cte_ano AS (
SELECT DISTINCT  ee.*,    hir.name AS grade, hir.[value] AS grade_id
FROM exam_exam ee JOIN hierarchy_hierarchy hir ON (hir.name = left(ee.name, PATINDEX('%ano %', ee.name)+3 ) AND 
                                                   hir.type ='grade')
WHERE ee.name LIKE '%ano%BI/2020%'
),
	cte_serie AS (
SELECT DISTINCT  ee.*,   hir.name AS grade, hir.[value] AS grade_id
FROM exam_exam ee JOIN hierarchy_hierarchy hir ON (hir.name = left(ee.name, PATINDEX('%série %', ee.name)+5 ) AND 
                                                   hir.type ='grade')
WHERE ee.name LIKE '%série%BI/2020%'
),

cte_uniao as (
SELECT id, grade, grade_id, ltrim(rtrim(replace(replace(name,grade,''),' - 2º BI/2020',''))) as disciplina FROM cte_ano UNION 
SELECT id, grade, grade_id, ltrim(rtrim(replace(replace(name,grade,''),' - 2º BI/2020',''))) AS disciplina FROM cte_serie )


SELECT '{"provider": {"label": "SAE", "value": "SAE"}, "discipline": {"name": "' + uni.disciplina + '", "value": 999999}, "grade": {"name": "' +uni.grade + '", "value": "' + uni.grade_id+ '2"}}'   , * 
-- UPDATE  ee SET ee.extra = '{"provider": {"label": "SAE", "value": "SAE"}, "discipline": {"name": "' + uni.disciplina + '", "value": 999999}, "grade": {"name": "' +uni.grade + '", "value": "' + uni.grade_id+ '2"}}'   
FROM exam_exam ee JOIN cte_uniao uni ON (ee.id = uni.id)
WHERE ee.name LIKE '%BI/2020%'
---------------------------------------------------------------------------------------------
WITH cte_grade AS (
			SELECT distinct name AS grade_nome, value AS grade_id
			 from hierarchy_hierarchy WHERE type = 'grade'
)

select ta.*, gra.grade_id , gra.grade_nome, tur.turma_nome, tur.turma_id 
 -- into tmpimp_aluno_sae 
  FROM temp_Alunos ta   JOIN cte_grade gra ON (gra.grade_nome = ta.UsuarioSerie)
                        JOIN vw_turma_escola_grade tur ON (tur.escola_id  = ta.escolaid AND 
						                                   tur.turma_nome = ta.TurmaNome AND 
														   tur.grade_id   = gra.grade_id)
  where not exists (select 1 from tmp_aluno_nao_importado tai where tai.usuarioid = ta.usuarioid)

--------------------------------------------------------------------------------------------


select * from vw_turma_escola_grade

select  tem.*
  from tmpimp_aluno_sae tem left JOIN auth_user usu ON (usu.username = tem.UsuarioId)
 where usu.username is null and
       not exists (select 1 from tmp_aluno_nao_importado imp where imp.usuarioid = tem.usuarioid)