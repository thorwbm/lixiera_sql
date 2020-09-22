-- SELECT * FROM tmp_imp_aluno_tirando_letra tja
-- SELECT * FROM exam_exam ee

drop table #tmp_usuario
DECLARE @JSON_AUX VARCHAR(MAX)
SET @JSON_AUX = '{"hierarchy": {"provider": {"value": "SAE", "name": "SAE"}, '+       -- ENTIDADE
                              '"unity":{"value":"999999","name":"Não informado"}, '+ -- ESCOLA
                              '"class":{"value":"999999","name":"Não informado"}, '+  -- TURMA
                              '"grade":{"value":"999999","name":"Não informado"}}}'   -- GRADE

SELECT DISTINCT   
       password = 'pbkdf2_sha256$180000$LmA3RFL35Vi6$6HIUlKjmZWX0aTbZq0RxFTh3IWdWBYlecPANz6mfj8o=',
       is_superuser = 0,
       username = newid(),
       is_staff = 0,
       is_active = 1,
       date_joined = GETDATE(),
       name = tmp.aluno,
       public_identifier = null,
       extra =   JSON_MODIFY(
                     JSON_MODIFY(
                         JSON_MODIFY(
                             JSON_MODIFY(
                                 JSON_MODIFY(
                                     JSON_MODIFY(@JSON_AUX, '$.hierarchy.class.value',hie.turma_value), 
                                     '$.hierarchy.class.name', hie.turma_nome),
                                 '$.hierarchy.grade.value', hie.grade_value),
                             '$.hierarchy.grade.name', hie.grade_nome), 
       			     '$.hierarchy.unity.name', hie.escola_nome),
       	         '$.hierarchy.unity.value', hie.escola_value),
       provider_id = 1,
       created_at = GETDATE(),
       updated_at = GETDATE(),
       first_name = CASE WHEN charindex(' ',tmp.aluno) > 0 THEN left (tmp.aluno,  charindex(' ',tmp.aluno)-1)
                                                             ELSE tmp.aluno END,
       last_name = tmp.aluno,
       email = ''
  into #tmp_usuario
  FROM tmp_imp_aluno_tirando_letra   tmp JOIN vw_hierarquia_exam hie ON (hie.escola_nome = tmp.escola and 
                                                                         hie.grade_nome  = tmp.grade  and
																		 hie.turma_nome  = tmp.turma)
						            LEFT JOIN auth_user          xxx ON (xxx.username    = CONVERT(VARCHAR(100),tmp.aluno))
	WHERE xxx.id IS NULL 




 INSERT INTO auth_user 
       (password, is_superuser, username, is_staff, is_active, date_joined, name, public_identifier, 
        extra, provider_id, created_at, updated_at, first_name, last_name, email)

select usu.password, usu.is_superuser, usu.username, usu.is_staff, usu.is_active, usu.date_joined, usu.name, 
       public_identifier = usu.username, usu.extra, usu.provider_id, usu.created_at, usu.updated_at, usu.first_name, 
	   usu.last_name, usu.email 
  from #tmp_usuario usu LEFT JOIN auth_user xxx ON (cast(usu.username as varchar(100)) = cast(xxx.username as varchar(100)))
	WHERE xxx.id IS NULL  

