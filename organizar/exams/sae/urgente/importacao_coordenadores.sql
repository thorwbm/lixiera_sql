-- begin tran insert into auth_user (password, is_superuser, username, is_staff, is_active, date_joined, name, public_identifier, 
--                       extra, provider_id, created_at, updated_at, first_name, last_name, email)
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
  from tmpimp_Coordenadores  temp left join auth_user xxx on (xxx.username = temp.UsuarioId and 
                                                                 xxx.name = temp.UsuarioNome)
 where xxx.id is null 
-- commit 
-- rollback

SELECT * DELETE FROM auth_user WHERE cast(created_at AS date) = '2020-06-23'




DECLARE @JSON_AUX VARCHAR(MAX)
SET @JSON_AUX = ---'{"hierarchy": {"unity":{"value":"CMMG","name":"Faculdade Ciências Médicas"},"class":{"value":"CMMG","name":"CMMG"},"grade":{"value":"999999","name":"Não informado"}}}'
  
  '{  "hierarchy": { "provider": { "value": "SAE", "name": "SAE" }, "unity": { "name": "<NOME DA ESCOLA>", "value": "<ID DA ESCOLA>" }}}'

SELECT JSON_MODIFY(JSON_MODIFY(@JSON_AUX, '$.hierarchy.unity.value', COO.ESCOLAID),'$.hierarchy.unity.name', COO.ESCOLANOME),*
---BEGIN TRAN  UPDATE USU SET USU.EXTRA = JSON_MODIFY(JSON_MODIFY(@JSON_AUX, '$.hierarchy.unity.value', COO.ESCOLAID),'$.hierarchy.unity.name', COO.ESCOLANOME)
  FROM TEMP_COORDENADORES COO JOIN AUTH_USER USU ON (COO.USUARIOID = USU.USERNAME)

 -- COMMIT 
  SELECT TOP 100 * FROM auth_user_groups aug
  SELECT TOP 100 * FROM auth_group

----{"hierarchy": {"provider": {"value": "SAE", "name": "SAE"}, "unity": {"name": "Colégio Ouro Preto", "value": "34d3a52e96b0087c48b4a7d761133a57"}, "grade": {"name": "6º ano", "value": "58B960FD-F62F-4421-B54C-CC183A77EFBA"}, "class": {"name": "6º Ano A - 2017", "value": "737c53113c92784d3b9a2a4e9eb8b7fc"}}}


INSERT INTO auth_user_groups (user_id, group_id)
SELECT user_id = USU.ID , group_id = 4
FROM TEMP_COORDENADORES COO JOIN AUTH_USER USU ON (COO.USUARIOID = USU.USERNAME)
                       LEFT JOIN auth_user_groups xxx ON (xxx.user_id = usu.id AND xxx.group_id = 4)
 WHERE xxx.id IS NULL 