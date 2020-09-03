
DECLARE @JSON_AUX VARCHAR(MAX)
SET @JSON_AUX = '{"hierarchy": {"provider": {"value": "SAE", "name": "SAE"}, '+       -- ENTIDADE
                              '"unity":{"value":"999999","name":"Não informado"}, '+ -- ESCOLA
                              '"class":{"value":"999999","name":"Não informado"}, '+  -- TURMA
                              '"grade":{"value":"999999","name":"Não informado"}}}'   -- GRADE
  --BEGIN TRAN;
  ;
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
--  INSERT INTO auth_user 
--        (password, is_superuser, username, is_staff, is_active, date_joined, name, public_identifier, 
--         extra, provider_id, created_at, updated_at, first_name, last_name, email)
SELECT DISTINCT   
       password = 'pbkdf2_sha256$180000$LmA3RFL35Vi6$6HIUlKjmZWX0aTbZq0RxFTh3IWdWBYlecPANz6mfj8o=',
       is_superuser = 0,
       username = newId(),
       is_staff = 0,
       is_active = 1,
       date_joined = GETDATE(),
       name = ta.nome,
       public_identifier = null,
       extra =   JSON_MODIFY(
	                 JSON_MODIFY(
	                     JSON_MODIFY(
                             JSON_MODIFY(
                                 JSON_MODIFY(
                                    JSON_MODIFY(@JSON_AUX, '$.hierarchy.class.value', tur.turma_id), 
                                     '$.hierarchy.class.name', tur.turma_id),
                                 '$.hierarchy.grade.value', gra.grade_id),
                             '$.hierarchy.grade.name', gra.grade_nome), 
					     '$.hierarchy.unity.name', esc.escola_nome),
			         '$.hierarchy.unity.value', esc.Escola_Id),
       provider_id = 1,
       created_at = GETDATE(),
       updated_at = GETDATE(),
       first_name = CASE WHEN charindex(' ',ta.nome) > 0 THEN left (ta.nome,  charindex(' ',ta.nome)-1)
                                                         ELSE ta.nome END,
       last_name = ta.nome,
       email = ''	   		    
  FROM tmp_imp_aluno_prospect   ta JOIN cte_grade  gra ON (gra.grade_nome = ta.serie_ano)
								   join cte_escola esc on (esc.escola_nome = ta.escola)
                              left join cte_turma  tur on (convert(varchar(500),ta.turma) = tur.turma_nome)
					     	  LEFT JOIN auth_user  xxx ON (xxx.name = ta.Nome)
	WHERE xxx.id IS NULL  
--	commit 


select pro.*, json_value(usu.extra, '$.hierarchy.unity.name') as escola_na_base 
into tmp_imp_prospect_ja_existe_base 
from tmp_imp_aluno_prospect pro join auth_user usu on ( pro.nome = usu.name)

drop table tmp_imp_prospect_aluno
select pro.escola as escola_nome, pro.serie_ano, pro.nome as aluno_nome, pro.matricula as aluno_matricula, 
       aluno_public_identifier = newid(), aluno_turma_nome = 'Prospect - ' + serie_ano,
       aluno_senha =  'pbkdf2_sha256$180000$LmA3RFL35Vi6$6HIUlKjmZWX0aTbZq0RxFTh3IWdWBYlecPANz6mfj8o=',
	   aluno_email = isnull(pro.email, lower(replace(nome, ' ','_') + '@Prospect.edu.br'))
into tmp_imp_prospect_aluno
from tmp_imp_aluno_prospect pro

drop table tmp_imp_prospect_coodenador
 SELECT pro.escola as escola_nome, pro.nome as coordenador_nome, pro.[e-mail] as email, 
       coordenador_public_identifier = newid(),
       coordenador_senha =  'pbkdf2_sha256$180000$LmA3RFL35Vi6$6HIUlKjmZWX0aTbZq0RxFTh3IWdWBYlecPANz6mfj8o=',
	   coordenador_email = isnull(pro.[e-mail] ,lower(replace(nome, ' ','_') + '@Prospect.edu.br'))
	   into tmp_imp_prospect_coodenador
 FROM tmp_imp_COORDENADOR_prospect pro