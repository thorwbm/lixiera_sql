-- total -- 3852
-- EXTENSIVO, 3 SERIE -- 287
-- TOTAL SEM EXTENSIVO -- 3565 
-- existe no auth -- 2167
-- nao existe -- 1398
--  INSERT INTO auth_user 
--        (password, is_superuser, username, is_staff, is_active, date_joined, name, public_identifier, 
--         extra, provider_id, created_at, updated_at, first_name, last_name, email)
DECLARE @JSON_AUX VARCHAR(MAX)
SET @JSON_AUX = '{"hierarchy": {"provider": {"value": "SAE", "name": "SAE"}, '+       -- ENTIDADE
                              '"unity":{"value":"999999","name":"Não informado"}, '+ -- ESCOLA
                              '"class":{"value":"999999","name":"Não informado"}, '+  -- TURMA
                              '"grade":{"value":"999999","name":"Não informado"}}}' 

SELECT DISTINCT   
       password = 'pbkdf2_sha256$180000$LmA3RFL35Vi6$6HIUlKjmZWX0aTbZq0RxFTh3IWdWBYlecPANz6mfj8o=',
       is_superuser = 0,
       username = tem.UsuarioId,
       is_staff = 0,
       is_active = 1,
       date_joined = GETDATE(),
       name = tem.UsuarioNome,
       public_identifier = tem.UsuarioId,
       extra =   JSON_MODIFY(
	                 JSON_MODIFY(
	                     JSON_MODIFY(
                             JSON_MODIFY(
                                 JSON_MODIFY(
                                    JSON_MODIFY(@JSON_AUX, '$.hierarchy.class.value', hie.class_value), 
                                     '$.hierarchy.class.name', hie.class_nome),
                                 '$.hierarchy.grade.value', hie.grade_id),
                             '$.hierarchy.grade.name', hie.grade_nome), 
					     '$.hierarchy.unity.name', hie.escola_nome),
			         '$.hierarchy.unity.value', hie.Escola_value),
       provider_id = 1,
       created_at = GETDATE(),
       updated_at = GETDATE(),
       first_name = CASE WHEN charindex(' ',tem.UsuarioNome) > 0 THEN left (tem.UsuarioNome,  charindex(' ',tem.UsuarioNome)-1)
                                                             ELSE tem.UsuarioNome END,
       last_name = tem.UsuarioNome,
       email = ''
  into  #tmp_carga_usuario
  FROM TMP_IMP_ALUNOS_4BI   tem JOIN vw_hierarquia_geral hie on (tem.EscolaId = hie.escola_value and 
                                                                 tem.UsuariosTurma = hie.class_value and 
																 tem.UsuarioSerie = hie.grade_nome)
					  	   LEFT JOIN auth_user           xxx ON (xxx.public_identifier = tem.Usuarioid)
	WHERE xxx.id IS  NULL  

insert into auth_user (password, is_superuser, username, is_staff, is_active, date_joined, name, 
                       public_identifier, extra, provider_id, created_at, updated_at, first_name, last_name, email)
SELECT tmp.password, tmp.is_superuser, tmp.username, tmp.is_staff, tmp.is_active, tmp.date_joined, tmp.name, 
       tmp.public_identifier, tmp.extra, tmp.provider_id, tmp.created_at, tmp.updated_at, tmp.first_name, tmp.last_name, tmp.email
FROM  #tmp_carga_usuario tmp left join auth_user xxx on (xxx.public_identifier = tmp.public_identifier) 
where xxx.id is null 


 select json_value(extra, '$.hierarchy.unity.name') as escola_nome, last_name ,public_identifier, json_value(extra, '$.hierarchy.grade.name') as grade, 
        json_value(extra, '$.hierarchy.class.name') as turma
 from  #tmp_carga_usuario
 order by 1,2
