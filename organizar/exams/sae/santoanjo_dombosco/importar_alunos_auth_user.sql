/*******************************************************************************
                         CARGA DAS TURMAS QUE NAO EXISTEM
*******************************************************************************/
--   INSERT INTO hierarchy_hierarchy 
 SELECT TYPE = 'class', VALUE = TURMA_ID, TURMA_NOME, NULL FROM (
 SELECT DISTINCT TURMA_NOME, TURMA_ID
 FROM tmp_imp_carga_aluno_db_sa SAE LEFT JOIN hierarchy_hierarchy HIE ON ( TYPE = 'class' AND SAE.TURMA_ID = HIE.value)
 WHERE HIE.ID IS NULL) AS TAB 

/*******************************************************************************
                         CARGA DAS ESCOLAS QUE NAO EXISTEM
*******************************************************************************/
--   INSERT INTO hierarchy_hierarchy 
 SELECT TYPE = 'unity', VALUE = ESCOLA_ID, ESCOLA_NOME, NULL FROM (
  SELECT DISTINCT ESCOLA_NOME, ESCOLA_ID
 FROM tmp_imp_carga_aluno_db_sa SAE LEFT JOIN hierarchy_hierarchy HIE ON (SAE.ESCOLA_ID = HIE.VALUE AND TYPE = 'unity')
 WHERE HIE.ID IS NULL) AS TAB 


/*******************************************************************************
                         CARGA DOS ALUNOS QUE NAO EXISTEM
*******************************************************************************/


-- SELECT * FROM tmpimp_janela_aplicacao tja
-- SELECT * FROM exam_exam ee

DECLARE @JSON_AUX VARCHAR(MAX)
SET @JSON_AUX = '{"hierarchy": {"provider": {"value": "SAE", "name": "SAE"}, '+       -- ENTIDADE
                              '"unity":{"value":"999999","name":"Não informado"}, '+ -- ESCOLA
                              '"class":{"value":"999999","name":"Não informado"}, '+  -- TURMA
                              '"grade":{"value":"999999","name":"Não informado"}}}'   -- GRADE
 BEGIN TRAN
 INSERT INTO auth_user 
       (password, is_superuser, username, is_staff, is_active, date_joined, name, public_identifier, 
        extra, provider_id, created_at, updated_at, first_name, last_name, email)
SELECT DISTINCT   
       password = 'pbkdf2_sha256$180000$LmA3RFL35Vi6$6HIUlKjmZWX0aTbZq0RxFTh3IWdWBYlecPANz6mfj8o=',
       is_superuser = 0,
       username = imp.aluno_id,
       is_staff = 0,
       is_active = 1,
       date_joined = GETDATE(),
       name = imp.aluno_nome,
       public_identifier = imp.aluno_id,
       extra =   JSON_MODIFY(
	                 JSON_MODIFY(
	                     JSON_MODIFY(
                             JSON_MODIFY(
                                 JSON_MODIFY(
                                     JSON_MODIFY(@JSON_AUX, '$.hierarchy.class.value', cast(imp.turma_id as varchar(200))), 
                                     '$.hierarchy.class.name', imp.turma_nome),
                                 '$.hierarchy.grade.value', gra.codigo),
                             '$.hierarchy.grade.name', gra.nome), 
					     '$.hierarchy.unity.name', imp.escola_nome),
			         '$.hierarchy.unity.value', imp.escola_id),
       provider_id = 1,
       created_at = GETDATE(),
       updated_at = GETDATE(),
       first_name = CASE WHEN charindex(' ',imp.aluno_nome) > 0 THEN left (imp.aluno_nome,  charindex(' ',imp.aluno_nome)-1)
                                                                ELSE imp.aluno_nome END,
       last_name = imp.aluno_nome,
       email = ''
  FROM tmp_imp_carga_aluno_db_sa imp JOIN VW_HIERARQUIA gra ON (gra.NOME = imp.grade_nome and gra.tipo = 'grade')
						LEFT JOIN auth_user xxx ON (xxx.username = CONVERT(VARCHAR(100),imp.aluno_id))
	WHERE xxx.id IS NULL 

 -- COMMIT 
 -- rollback 
  

