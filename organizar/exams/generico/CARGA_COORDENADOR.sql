 SELECT USUARIO_ID = NEWID(),
        USUARIO_NOME = 'Juscicléia Costa Martins', 
        USUARIO_EMAIL = 'juscicleiacosta@hotmail.com',
        ESCOLA_NOME = 'EEIEF Tirando de Letra' INTO #TMP_COORDENADOR

select distinct
       password = 'pbkdf2_sha256$180000$LmA3RFL35Vi6$6HIUlKjmZWX0aTbZq0RxFTh3IWdWBYlecPANz6mfj8o=',
       is_superuser = 0,
       username = NULL,
       is_staff = 0,
       is_active = 1,
       date_joined = GETDATE(),
       name = TMP.USUARIO_NOME,
       public_identifier = NULL,
	   EXTRA = '{  "hierarchy": {  "unity": { "name": "' + HIE.escola_NOME + '", "value": "' + CAST(HIE.escola_value AS VARCHAR(100)) + '" }}}',
  
       provider_id = 1,
       created_at = GETDATE(),
       updated_at = GETDATE(),
       first_name = LEFT(CASE WHEN charindex(' ',TMP.USUARIO_NOME) > 0 THEN left (TMP.USUARIO_NOME,  charindex(' ',TMP.USUARIO_NOME)-1)
                                                             ELSE TMP.USUARIO_NOME END,30),
       last_name = TMP.USUARIO_NOME,
       email = TMP.USUARIO_EMAIL
   INTO #TMP_INSERT 
  from #TMP_COORDENADOR  TMP JOIN vw_hierarquia_exam HIE ON (HIE.escola_nome = TMP.ESCOLA_NOME)
                        left join auth_user xxx on (xxx.name = TMP.USUARIO_NOME)
 where xxx.id is null AND TMP.USUARIO_NOME IS NOT NULL 




SELECT password, is_superuser, username = NEWID(), is_staff, is_active, date_joined, name, 
       public_identifier, EXTRA, provider_id, 
	   created_at, updated_at, first_name, last_name, email
	   INTO #TMP_FINAL 
FROM #TMP_INSERT


 insert into auth_user (password, is_superuser, username, is_staff, is_active, date_joined, name, public_identifier, 
                      extra, provider_id, created_at, updated_at, first_name, last_name, email)
SELECT FIN.password, FIN.is_superuser, FIN.username, FIN.is_staff, FIN.is_active, FIN.date_joined, FIN.name, 
       public_identifier = FIN.username, FIN.EXTRA, FIN.provider_id, FIN.created_at, FIN.updated_at, FIN.first_name, 
	   FIN.last_name, FIN.email 
  FROM #TMP_FINAL FIN LEFT JOIN AUTH_USER XXX ON (CAST(XXX.username AS VARCHAR(100)) = CAST(FIN.username AS VARCHAR(100)))
 WHERE XXX.ID IS NULL 



 INSERT INTO auth_user_groups (user_id, group_id)
SELECT user_id = USU.ID , group_id = 4
FROM #TMP_FINAL COO JOIN AUTH_USER USU ON (CAST(COO.username AS VARCHAR(100)) = CAST(USU.username AS VARCHAR(100)))
                       LEFT JOIN auth_user_groups xxx ON (xxx.user_id = usu.id AND xxx.group_id = 4)
 WHERE xxx.id IS NULL