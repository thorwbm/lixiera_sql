-- SELECT * FROM tmpimp_janela_aplicacao tja
-- SELECT * FROM exam_exam ee

DECLARE @JSON_AUX VARCHAR(MAX)
SET @JSON_AUX = '{"hierarchy": {"provider": {"value": "SAE", "name": "SAE"}, '+       -- ENTIDADE
                              '"unity":{"value":"999999","name":"Não informado"}, '+ -- ESCOLA
                              '"class":{"value":"999999","name":"Não informado"}, '+  -- TURMA
                              '"grade":{"value":"999999","name":"Não informado"}}}'   -- GRADE
--  BEGIN TRAN;
-- {"hierarchy": {"provider": {"value": "SAE", "name": "SAE"}, "unity": {"name": "Colégio Ouro Preto", "value": "34d3a52e96b0087c48b4a7d761133a57"}, "grade": {"name": "1ª série", "value": "BF6A4629-FC03-4162-9AC1-788ADD934D8C"}, "class": {"name": "1ª Médio A - 2017", "value": "a53e7ecf10db953bafb24a01c5dec6f7"}}}
 ;
WITH cte_grade AS (
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
       extra =   JSON_MODIFY(
	                 JSON_MODIFY(
	                     JSON_MODIFY(
                             JSON_MODIFY(@JSON_AUX,
                            --     JSON_MODIFY(
                                    -- JSON_MODIFY(@JSON_AUX, '$.hierarchy.class.value', tur.value), 
                                    -- '$.hierarchy.class.name', tur.name),
                                 '$.hierarchy.grade.value', gra.grade_id),
                             '$.hierarchy.grade.name', gra.grade_nome), 
					     '$.hierarchy.unity.name', ta.escolanome),
			         '$.hierarchy.unity.value', TA.EscolaId),
       provider_id = 1,
       created_at = GETDATE(),
       updated_at = GETDATE(),
       first_name = CASE WHEN charindex(' ',UsuarioNome) > 0 THEN left (UsuarioNome,  charindex(' ',UsuarioNome)-1)
                                                             ELSE UsuarioNome END,
       last_name = ta.UsuarioNome,
       email = ''


  FROM TEMP_IMPORTAR_SAE   ta JOIN cte_grade gra ON (gra.grade_nome = ta.UsuarioSerie)
						LEFT JOIN auth_user xxx ON (xxx.username = ta.usuarioid)
	WHERE xxx.id IS NULL 

 -- COMMIT 
/*
select count(1) from temp_alunos
select count(1) from tmpimp_aluno_sae
select count(1) from tmp_aluno_nao_importado

 tmp left join hierarchy_hierarchy hie on (hie.type = 'class' and 
                                                                         hie.name = tmp.turma_nome)
where hie.id is null 

select  tem.*
  from tmpimp_aluno_sae tem left JOIN auth_user usu ON (usu.username = tem.UsuarioId)
 where usu.id is null and
       not exists (select 1 from tmp_aluno_nao_importado imp where imp.usuarioid = tem.usuarioid)

 -- tudo que tiver virgula no usuario serie 
 --     SELECT TOP 10 * FROM tmpimp_janela_aplicacao tja
 --     SELECT TOP 10 * FROM application_applicationtimewindow aa
 --     
 --     SELECT TOP 10 * FROM exam_timewindow et nao mexer
 --     SELECT TOP 10 * FROM exam_exam
 --     
 --     
 --     SELECT TOP 10 * FROM tmpimp_Alunos sle

WITH cte_grade AS (
			SELECT distinct name AS grade_nome, value AS grade_id
			 from hierarchy_hierarchy WHERE type = 'grade'
),
	cte_turma as (
			SELECT distinct name AS turma_nome, value AS turma_id
			 from hierarchy_hierarchy 
            WHERE type = 'class' and
                  value not in (select turma_id from vw_turma_escola_grade)
)

-- select count(distinct ta.usuarioid)
--   FROM temp_Alunos ta JOIN cte_grade gra ON (gra.grade_nome = ta.UsuarioSerie) 
--                       join cte_turma ctr on (ctr.turma_nome = ta.turmanome)


select distinct ta.*, gra.grade_id , gra.grade_nome, tur.turma_id--,ctr.turma_id  --isnull(tur.turma_id,ctr.turma_id) as turma_id
  into tmpimp_aluno_sae 
--select distinct ta.turmanome
  FROM temp_Alunos ta JOIN cte_grade gra ON (gra.grade_nome = ta.UsuarioSerie) 
                      JOIN vw_turma_escola_grade tur ON (tur.escola_id  = ta.escolaid AND 
						                                   tur.turma_nome = ta.TurmaNome AND 
														   tur.grade_id   = gra.grade_id)


*/

--SELECT * FROM TEMP_ALUNOS_NOVO 


--   INSERT INTO hierarchy_hierarchy 
 SELECT TYPE = 'CLASS', VALUE = USUARIOSTURMA, TURMANOME, NULL FROM (
 SELECT DISTINCT TURMANOME, USUARIOTURMA
 FROM TEMP_ALUNOS_NOVO SAE LEFT JOIN hierarchy_hierarchy HIE ON (SAE.TURMANOME = HIE.NAME AND TYPE = 'CLASS')
 WHERE HIE.ID IS NULL ) AS TAB 




  SELECT DISTINCT ESCOLANOME, ESCOLAID
 FROM TEMP_ALUNOS_NOVO SAE LEFT JOIN hierarchy_hierarchy HIE ON (SAE.ESCOLANOME = HIE.NAME AND TYPE = 'UNITY')
 WHERE HIE.ID IS NULL