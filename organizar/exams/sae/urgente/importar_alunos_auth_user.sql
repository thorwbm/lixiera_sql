-- SELECT * FROM tmpimp_janela_aplicacao tja
-- SELECT * FROM exam_exam ee

DECLARE @JSON_AUX VARCHAR(MAX)
SET @JSON_AUX = '{"hierarchy": {"provider": {"value": "SAE", "name": "SAE"}, '+       -- ENTIDADE
                              '"unity":{"value":"999999","name":"N�o informado"}, '+ -- ESCOLA
                              '"class":{"value":"999999","name":"N�o informado"}, '+  -- TURMA
                              '"grade":{"value":"999999","name":"N�o informado"}}}'   -- GRADE
  --BEGIN TRAN;

WITH cte_grade AS (
			SELECT distinct name AS grade_nome,  max(value)  AS grade_id
			 from hierarchy_hierarchy WHERE type = 'grade'
			 group by name, type
)
	,	cte_turma as (
			SELECT distinct name AS Turma_nome, max(value) AS Turma_id
			 from hierarchy_hierarchy WHERE type = 'class' 
			 group by name, type
)
	,	cte_escola as (
			SELECT distinct name AS escola_nome, max(value) AS escola_id
			 from hierarchy_hierarchy WHERE type = 'unity' 
			 group by name, type
)
select * from tmp_imp_aluno_prospect
--  INSERT INTO auth_user 
--        (password, is_superuser, username, is_staff, is_active, date_joined, name, public_identifier, 
--         extra, provider_id, created_at, updated_at, first_name, last_name, email)
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
                             JSON_MODIFY(
                                 JSON_MODIFY(
                                    JSON_MODIFY(@JSON_AUX, '$.hierarchy.class.value', tur.turma_value), 
                                     '$.hierarchy.class.name', tur.turma_name),
                                 '$.hierarchy.grade.value', gra.grade_id),
                             '$.hierarchy.grade.name', gra.grade_nome), 
					     '$.hierarchy.unity.name', ta.escolanome),
			         '$.hierarchy.unity.value', TA.EscolaId),
       provider_id = 1,
       created_at = GETDATE(),
       updated_at = GETDATE(),
       first_name = CASE WHEN charindex(' ',ta.nome) > 0 THEN left (ta.nome,  charindex(' ',ta.nome)-1)
                                                             ELSE ta.nome END,
       last_name = ta.nome,
       email = ''

  FROM tmp_imp_aluno_prospect   ta JOIN cte_grade gra ON (gra.grade_nome = ta.serie_ano)
                                   join cte_turma tur on (tur.turma_nome = ta.turma)
								   join cte_escola esc on (esc.escola_nome = ta.escola)
						LEFT JOIN auth_user xxx ON (xxx.name = ta.Nome)
	WHERE xxx.id IS NULL  
	

 -- COMMIT 
 -- rollback 
/*
select * from tmp_imp_aluno_prospect
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
 SELECT TYPE = 'CLASS', VALUE = USUARIOsTURMA, TURMANOME, NULL FROM (
 SELECT DISTINCT TURMANOME, USUARIOsTURMA
 FROM TMP_IMP_ALUNO_ava_08 SAE LEFT JOIN hierarchy_hierarchy HIE ON (SAE.TURMANOME = HIE.NAME AND TYPE = 'CLASS')
 WHERE HIE.ID IS NULL and 
      sae.USUARIOID NOT IN (SELECT USUARIOID FROM TMP_IMP_ALUNO_ERRO)) AS TAB 




  SELECT DISTINCT ESCOLANOME, ESCOLAID
 FROM TEMP_ALUNOS_NOVO SAE LEFT JOIN hierarchy_hierarchy HIE ON (SAE.ESCOLANOME = HIE.NAME AND TYPE = 'UNITY')
 WHERE HIE.ID IS NULL

 select * from TEMP_ALUNOS_NOVO WHERE USUARIONOME = 'GILBERTO HENRIQUE GASPAR'


 SELECT *, MOTIVO = 'ALUNO SE ENCONTRA EM MAIS DE UMA TURMA, NAO SEI COMO ME COMPORTAR NESTE CASO' 
 --INTO TMP_IMP_ALUNO_08 
 FROM TMP_IMP_ALUNO_ava_08 WHERE USUARIOID IN (
 SELECT USUARIOiD
 FROM TMP_IMP_ALUNO_ava_08 
 GROUP BY USUARIOiD
 HAVING COUNT(USUARIOstURMA)>1)


insert into tmp_imp_aluno_erro 
 select *, MOTIVO = 'ALUNO SE ENCONTRA EM MAIS DE UMA TURMA, NAO SEI COMO ME COMPORTAR NESTE CASO'  from TMP_IMP_ALUNO_ava_08
 where usuarioserie like '%,%' and 
       usuarioserie not in ('3� s�rie / Extensivo ,Extensivo')