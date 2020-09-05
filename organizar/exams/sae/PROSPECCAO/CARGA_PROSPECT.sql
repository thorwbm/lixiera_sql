/***********************************************************************************************************************
*                         CARREGAR GRADES QUE NAO EXISTEM AINDA NA HIERARCHY
***********************************************************************************************************************/
insert into hierarchy_hierarchy (type, value, name)
SELECT TYPE = 'grade', value = newid(), name from (
  select distinct name = alu.serie_ano
  FROM tmp_imp_prospect_aluno ALU LEFT JOIN VW_HIERARQUIA HIE ON (ALU.SERIE_ANO = HIE.NOME AND HIE.TIPO = 'grade' )
WHERE HIE.CODIGO IS NULL  ) as tab


/***********************************************************************************************************************
*                         CARREGAR ESCOLA QUE NAO EXISTEM AINDA NA HIERARCHY
***********************************************************************************************************************/
insert into hierarchy_hierarchy (type, value, name)
SELECT TYPE = 'unity', value = newid(), name from (
  select distinct name = alu.escola_nome
  FROM tmp_imp_prospect_aluno ALU LEFT JOIN VW_HIERARQUIA HIE ON (ALU.ESCOLA_NOME = HIE.NOME AND HIE.TIPO = 'unity' )
WHERE HIE.CODIGO IS NULL ) as tab


/***********************************************************************************************************************
*                         CARREGAR TURMA QUE NAO EXISTEM AINDA NA HIERARCHY
***********************************************************************************************************************/
insert into hierarchy_hierarchy (type, value, name)
SELECT TYPE = 'class', value = newid(), name from (
    select distinct name = alu.aluno_turma_nome
  FROM tmp_imp_prospect_aluno ALU LEFT JOIN VW_HIERARQUIA HIE ON (ALU.aluno_turma_nome = HIE.NOME AND HIE.TIPO = 'class')
WHERE HIE.CODIGO IS NULL ) as tab 

-- rollback 
/***********************************************************************************************************************
*                         CARREGAR ALUNOS
***********************************************************************************************************************/

begin tran 
DECLARE @JSON_AUX VARCHAR(MAX)
SET @JSON_AUX = '{"hierarchy": {"provider": {"value": "SAE", "name": "SAE"}, '+       -- ENTIDADE
                              '"unity":{"value":"999999","name":"Não informado"}, '+ -- ESCOLA
                              '"class":{"value":"999999","name":"Não informado"}, '+  -- TURMA
                              '"grade":{"value":"999999","name":"Não informado"}}}'   -- GRADE

  INSERT INTO auth_user 
        (password, is_superuser, username, is_staff, is_active, date_joined, name, public_identifier, 
         extra, provider_id, created_at, updated_at, first_name, last_name, email)
SELECT DISTINCT   
       password = 'pbkdf2_sha256$180000$LmA3RFL35Vi6$6HIUlKjmZWX0aTbZq0RxFTh3IWdWBYlecPANz6mfj8o=',
       is_superuser = 0,
       username = ta.aluno_public_identifier,
       is_staff = 0,
       is_active = 1,
       date_joined = GETDATE(),
       name = ta.aluno_nome,
       public_identifier = aluno_public_identifier,
       extra =   JSON_MODIFY(
	                 JSON_MODIFY(
	                     JSON_MODIFY(
                             JSON_MODIFY(@JSON_AUX,
                                -- JSON_MODIFY(
                                   -- JSON_MODIFY(@JSON_AUX, '$.hierarchy.class.value', tur.codigo), 
                                  --   '$.hierarchy.class.name', tur.nome),
                                 '$.hierarchy.grade.value', gra.codigo),
                             '$.hierarchy.grade.name', gra.nome), 
					     '$.hierarchy.unity.name', esc.nome),
			         '$.hierarchy.unity.value', esc.codigo),
       provider_id = 1,
       created_at = GETDATE(),
       updated_at = GETDATE(),
       first_name = CASE WHEN charindex(' ',ta.aluno_nome) > 0 THEN left (ta.aluno_nome,  charindex(' ',ta.aluno_nome)-1)
                                                         ELSE ta.aluno_nome END,
       last_name = ta.aluno_nome,
       email = 'prospect@educat.com.br'	  
	 --  select distinct ta.escola, ta.serie_ano, ta.nome, json_value(xxx.extra, '$.hierarchy.unity.name'), json_value(xxx.extra, '$.hierarchy.grade.name')-- ta.matricula, gra.codigo, esc.codigo, tur.codigo, xxx.id,json_value(xxx.extra, '$.hierarchy.unity.name')
  FROM tmp_imp_prospect_aluno   ta JOIN VW_HIERARQUIA gra ON (gra.NOME = ta.serie_ano AND GRA.TIPO = 'grade')
								   join VW_HIERARQUIA esc on (esc.nome = ta.escola_nome    and esc.TIPO = 'unity')
                              left join VW_HIERARQUIA  tur on (ta.aluno_turma_nome = tur.nome and tur.TIPO = 'class')
					     	  LEFT JOIN auth_user  xxx ON (xxx.name = ta.aluno_nome and 
							                               json_value(xxx.extra, '$.hierarchy.unity.name') = ta.escola_nome)
	WHERE xxx.id IS  NULL 
	--and ta.Escola <> 'Colégio Vila Olímpia Florianópolis'

	 commit 
-- rollback 
/***********************************************************************************************************************
*                                            CARREGAR COORDENADOR
***********************************************************************************************************************/

 --begin tran
  
DECLARE @JSON_AUX_COO VARCHAR(MAX)
SET @JSON_AUX_COO =  '{"hierarchy": { "provider": { "value": "SAE", "name": "SAE" }, "unity": { "name": "<NOME DA ESCOLA>", "value": "<ID DA ESCOLA>" }}}'

insert into auth_user (password, is_superuser, username, is_staff, is_active, date_joined, name, public_identifier, 
           extra, provider_id, created_at, updated_at, first_name, last_name, email)
select distinct
       password = coordenador_senha,
       is_superuser = 0,
       username =  convert(varchar(200),temp.coordenador_public_identifier),
       is_staff = 0,
       is_active = 1,
       date_joined = GETDATE(),
       name = temp.coordenador_nome,
       public_identifier = convert(varchar(200),temp.coordenador_public_identifier),
       extra =  JSON_MODIFY(JSON_MODIFY(@JSON_AUX_COO, '$.hierarchy.unity.name' , hie.nome ), '$.hierarchy.unity.name', hie.codigo ),
       provider_id = 1,
       created_at = GETDATE(),
       updated_at = GETDATE(),
       first_name = LEFT(CASE WHEN charindex(' ',TEMP.coordenador_NOME) > 0 THEN left (TEMP.coordenador_NOME,  charindex(' ',TEMP.coordenador_NOME)-1)
                                                             ELSE TEMP.coordenador_NOME END,30),
       last_name = TEMP.coordenador_NOME,
       email = temp.email

  from tmp_imp_prospect_coodenador  temp JOIN VW_HIERARQUIA HIE ON (HIE.NOME = TEMP.escola_nome AND HIE.TIPO = 'unity')
                                     left join auth_user xxx on (xxx.name = TEMP.coordenador_NOME)
 where xxx.id is null AND TEMP.coordenador_NOME IS NOT NULL 


--------------------------------------------------------------------------------
INSERT INTO auth_user_groups (user_id, group_id)
SELECT distinct user_id = USU.ID , group_id = 4
FROM tmp_imp_prospect_coodenador COO JOIN AUTH_USER USU ON (convert(varchar(200),coo.coordenador_public_identifier) = USU.username)
                                 LEFT JOIN auth_user_groups xxx ON (xxx.user_id = usu.id AND xxx.group_id = 4)
 WHERE xxx.id IS NULL 

 --#####################################################################################################################

--  commit 
-- rollback 