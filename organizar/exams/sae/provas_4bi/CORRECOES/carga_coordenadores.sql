--SELECT * FROM TMP_IMP_COORDENADOR_4BI   -- 2895
declare @json varchar(max) = ' {"hierarchy":{"unity": {"name": null, "value": null}}}'
select distinct
       password = 'pbkdf2_sha256$180000$LmA3RFL35Vi6$6HIUlKjmZWX0aTbZq0RxFTh3IWdWBYlecPANz6mfj8o=',
       is_superuser = 0,
       username = tmp.login,
       is_staff = 0,
       is_active = 1,
       date_joined = GETDATE(),
       name = TMP.usuarionome,
       public_identifier = tmp.usuarioid,
	  --  hie.name as escola,
	   EXTRA = JSON_MODIFY( JSON_MODIFY(@json, '$.hierarchy.unity.name', hie.escola_nome), '$.hierarchy.unity.value', hie.escola_value),  
       provider_id = 1,
       created_at = GETDATE(),
       updated_at = GETDATE(),
       first_name = LEFT(CASE WHEN charindex(' ',TMP.usuarionome) > 0 THEN left (TMP.usuarionome,  charindex(' ',TMP.usuarionome)-1)
                                                                    ELSE TMP.usuarionome END,30),
       last_name = TMP.usuarionome,
       email = ''
   into #temp_coordenador
  from TMP_IMP_COORDENADOR_4BI  TMP  JOIN vw_hierarquia_geral HIE ON (HIE.escola_value = TMP.escolaid )
							  left join auth_user xxx on (xxx.public_identifier = tmp.UsuarioId)                              
  where xxx.id is  null 
  order by TMP.usuarionome
   
 insert into auth_user (password, is_superuser, username, is_staff, is_active, date_joined, name, public_identifier, 
 provider_id, created_at, updated_at, first_name, last_name, email, extra)
 select tmp.password, tmp.is_superuser,tmp.username, tmp.is_staff, tmp.is_active, tmp.date_joined, tmp.name, tmp.public_identifier, 
        tmp.provider_id, tmp.created_at, tmp.updated_at, first_name = isnull(tmp.first_name, 'sem nome'), last_name = isnull(tmp.last_name, 'sem nome'), tmp.email, tmp.extra
 from #temp_coordenador tmp left join auth_user xxx on (xxx.public_identifier = tmp.public_identifier)
 where xxx.id is null 

INSERT INTO auth_user_groups (user_id, group_id)
SELECT user_id = USU.ID , group_id = 4
FROM #temp_coordenador COO JOIN AUTH_USER USU ON (COO.public_identifier = USU.public_identifier)
                       LEFT JOIN auth_user_groups xxx ON (xxx.user_id = usu.id AND xxx.group_id = 4)
 WHERE xxx.id IS NULL 


 select public_identifier, last_name, json_value(extra, '$.hierarchy.unity.name') as escola_nome from  #temp_coordenador
 order by 3,2


 