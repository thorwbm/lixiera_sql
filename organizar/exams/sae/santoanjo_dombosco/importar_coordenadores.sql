

DECLARE @JSON_AUX VARCHAR(MAX)
SET @JSON_AUX = '{  "hierarchy": { "provider": { "value": "SAE", "name": "SAE" }, "unity": { "name": "<NOME DA ESCOLA>", "value": "<ID DA ESCOLA>" }}}'
 begin tran insert into auth_user (password, is_superuser, username, is_staff, is_active, date_joined, name, public_identifier, 
                      extra, provider_id, created_at, updated_at, first_name, last_name, email)
select distinct
       password = 'pbkdf2_sha256$180000$LmA3RFL35Vi6$6HIUlKjmZWX0aTbZq0RxFTh3IWdWBYlecPANz6mfj8o=',
       is_superuser = 0,
       username = tmp.coordenador_login,
       is_staff = 0,
       is_active = 1,
       date_joined = GETDATE(),
       name = tmp.coordenador_nome,
       public_identifier = tmp.coordenador_id,
       extra = JSON_MODIFY(JSON_MODIFY(@JSON_AUX, '$.hierarchy.unity.name', tmp.escola_nome),'$.hierarchy.unity.value', tmp.escola_id),
       provider_id = 1,
       created_at = GETDATE(),
       updated_at = GETDATE(),
       first_name = LEFT(CASE WHEN charindex(' ',tmp.coordenador_nome) > 0 THEN left (tmp.coordenador_nome,  charindex(' ',tmp.coordenador_nome)-1)
                                                                           ELSE tmp.coordenador_nome END,30),
       last_name = tmp.coordenador_nome,
       email = ''
	   --  select * 
  from TMP_IMP_carga_coordenador_db_sa  tmp left join auth_user xxx on (xxx.public_identifier = tmp.coordenador_id and 
                                                                        xxx.name = tmp.coordenador_nome)
 where xxx.id is null AND tmp.coordenador_nome IS NOT NULL 

-- commit 
-- rollback

  SELECT TOP 100 * FROM auth_user_groups aug
  SELECT TOP 100 * FROM auth_group


--   INSERT INTO auth_user_groups (user_id, group_id)
SELECT user_id = USU.ID , group_id = 4
FROM TMP_IMP_carga_coordenador_db_sa COO JOIN AUTH_USER USU ON (COO.coordenador_id = USU.public_identifier)
                                    LEFT JOIN auth_user_groups xxx ON (xxx.user_id = usu.id AND xxx.group_id = 4)
 WHERE xxx.id IS NULL 





