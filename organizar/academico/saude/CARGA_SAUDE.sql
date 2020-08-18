begin tran
DECLARE @DATAEXECUCAO DATETIME  
SET @DATAEXECUCAO = CAST( CONVERT(VARCHAR(19),GETDATE(),120) AS DATETIME)  


-- ### CARGA NA TABELA TIPO SANGUINEO
insert into saude_tiposanguineo (nome)
select name 
from mat_prd..health_bloodtype tps 
 where not exists (select 1 
                     from saude_tiposanguineo tpsx
					where tpsx.nome collate database_default = tps.name collate database_default)
order by tps.id
-- SELECT * FROM saude_tiposanguineo
------------------------------------------------------------------------------------------------

-- ### CARGA NA TABELA QUESTOES ###
 INSERT INTO saude_pergunta (DESCRICAO, VISIVEL)
 SELECT description, VISIVEL = 1 
   FROM MAT_PRD..health_question QUE LEFT JOIN saude_pergunta XXX ON (XXX.descricao COLLATE DATABASE_DEFAULT = QUE.description COLLATE DATABASE_DEFAULT)
  WHERE XXX.ID IS NULL 
  ORDER BY QUE.ID 

-- SELECT * FROM saude_pergunta
------------------------------------------------------------------------------------------------

-- ### CARGA NA TABELA TIPO VACINA ###
 INSERT INTO SAUDE_TIPOVACINA (NOME)
 SELECT DISTINCT LTRIM(RTRIM(NAME))
   FROM MAT_PRD..health_vaccine VAC LEFT JOIN SAUDE_TIPOVACINA XXX ON (XXX.nome COLLATE DATABASE_DEFAULT = LTRIM(RTRIM(VAC.NAME)) COLLATE DATABASE_DEFAULT)
  WHERE XXX.ID IS NULL 
  ORDER BY 1

--  SELECT * FROM SAUDE_TIPOVACINA
------------------------------------------------------------------------------------------------

-- ### CARGA TABELA PARENTESCO ###
insert into saude_parentesco (name)
SELECT DISTINCt upper (dbo.fn_TiraAcento(mat.CONTATO_PARENTESCO)) 
FROM MAT_PRD..vw_sau_questionario_saude_matricula mat left join saude_parentesco xxx on (xxx.name collate database_default = dbo.fn_TiraAcento(mat.CONTATO_PARENTESCO)  collate database_default)
where xxx.id is null  and 
      mat.contato_parentesco is not null 
order by 1
------------------------------------------------------------------------------------------------

-- ### CARGA NA TABELA DE SAUDE DADOS SAUDE #####
insert into saude_dadosaude (criado_em, atualizado_em, criado_por, atualizado_por, hospital, possui_plano_saude, matricula_plano_saude, 
                             telefone_plano_saude, plano_saude, tipo_sanguineo_id, pessoa_id)
select  distinct 
        criado_em = @DATAEXECUCAO, atualizado_em = @DATAEXECUCAO, criado_por = 11717, atualizado_por = 11717, 
        hospital              = sau.hospital, 
		possui_plano_saude    = sau.plano_saude_tem , 
		matricula_plano_saude = sau.plano_saude_numero, 
		telefone_plano_saude  = sau.plano_saude_fone, 
		plano_saude           = sau.plano_saude , 
		tipo_sanguineo_id     = SAN.ID, 
		pessoa_id             = pes.pessoa_id
from vw_Curriculo_aluno_pessoa pes join mat_prd..vw_sau_questionario_saude_matricula sau on (pes.aluno_ra collate database_default = sau.aluno_ra collate database_default)
                              LEFT JOIN saude_tiposanguineo                          SAN ON (SAN.nome collate database_default = SAU.TIPO_SANGUINEO_NOME collate database_default)
                              left join saude_dadosaude                              xxx on (xxx.pessoa_id = pes.pessoa_id) 
where xxx.id is null                  
 -- GERAR LOG  
 EXEC SP_GERAR_LOG_EM_LOTE_INSERT 'saude_dadosaude', @DATAEXECUCAO  
----------------------------------------------------------------------------------------------

-- ### CARGA NA TABELA SAUDE PERGUNTADO		
insert into saude_perguntadado (criado_em, atualizado_em, criado_por, atualizado_por, resposta, note, pergunta_id, dado_id)
SELECT distinct   
       criado_em = @DATAEXECUCAO, atualizado_em = @DATAEXECUCAO, criado_por = 11717, atualizado_por = 11717, 
       resposta = mat.resposta, note = mat.observacao, pergunta_id = per.id, dado_id = sau.id
  FROM saude_dadosaude sau join vw_Curriculo_aluno_pessoa                    cap on (cap.pessoa_id = sau.pessoa_id) 
                           join mat_prd..vw_sau_questionario_saude_matricula mat on (cap.aluno_ra collate database_default = mat.aluno_ra collate database_default)
						   join saude_pergunta                               per on (per.descricao collate database_default = mat.questao_nome collate database_default)
                      left join saude_perguntadado                           xxx on (xxx.dado_id = sau.id and 
					                                                                 xxx.pergunta_id = per.id)
 where xxx.id is null
 order by sau.id 
-- GERAR LOG  
 EXEC SP_GERAR_LOG_EM_LOTE_INSERT 'saude_perguntadado', @DATAEXECUCAO 
 --------------------------------------------------------------------------------------------

 -- ### CARGA NA TABELA SAUDE CONTATO
 insert into saude_contato (criado_em, atualizado_em, criado_por, atualizado_por, nome, telefone, dado_id, relacionamento_id)
 select distinct 
        criado_em = @DATAEXECUCAO, atualizado_em = @DATAEXECUCAO, criado_por = 11717, atualizado_por = 11717,
		nome = tab.contato_nome, telefone = tab.telefone ,dado_id = tab.dados_id, relacionamento_id = tab.parentesco_id
   from (
 SELECT mat.contato_nome, mat.contato_fone_fixo as telefone, sau.id as dados_id, par.id as parentesco_id
   FROM saude_dadosaude sau join vw_Curriculo_aluno_pessoa                    cap on (cap.pessoa_id = sau.pessoa_id) 
                            join mat_prd..vw_sau_questionario_saude_matricula mat on (cap.aluno_ra collate database_default = mat.aluno_ra collate database_default)
							join saude_parentesco                             par on (par.name collate database_default = dbo.fn_TiraAcento(mat.contato_parentesco) collate database_default)
where mat.contato_fone_fixo is not null and 
      mat.contato_fone_fixo <> ''
union 
 SELECT mat.contato_nome, mat.contato_telefone,  sau.id as dados_id, par.id as parentesco_id
   FROM saude_dadosaude sau join vw_Curriculo_aluno_pessoa                    cap on (cap.pessoa_id = sau.pessoa_id) 
                            join mat_prd..vw_sau_questionario_saude_matricula mat on (cap.aluno_ra collate database_default = mat.aluno_ra collate database_default)
							join saude_parentesco                             par on (par.name collate database_default = dbo.fn_TiraAcento(mat.contato_parentesco) collate database_default)
where mat.contato_telefone is not null  and 
      mat.contato_telefone <> ''
) as tab left join saude_contato xxx on (xxx.dado_id = tab.dados_id and 
                                         xxx.relacionamento_id = tab.parentesco_id and 
										 xxx.telefone collate database_default = tab.telefone collate database_default)
where tab.contato_nome is not null and 
      xxx.id is null 
-- GERAR LOG  
 EXEC SP_GERAR_LOG_EM_LOTE_INSERT 'saude_contato', @DATAEXECUCAO 
----------------------------------------------------------------------------------------------------------------------

-- ### CARGA NA TABELA VACINAS

insert into saude_vacina (criado_em, atualizado_em, criado_por, atualizado_por, DATA_DOSE, DATA_VALIDADE, note, possui_exame, 
                          resultado_exame, prefixo_arquivo_exame, dado_id, tipo_id)
SELECT DISTINCT 
       criado_em = @DATAEXECUCAO, atualizado_em = @DATAEXECUCAO, criado_por = 11717, atualizado_por = 11717,
       DATA_DOSE = null, DATA_VALIDADE = mat.vacina_data_expiracao, 
	   note = mat.vacina_observacao, possui_exame = mat.vacina_exame_possui, resultado_exame = mat.vacina_observacao,
       prefixo_arquivo_exame = mat.vacina_exame, dado_id = sau.id, tipo_id = vac.id 
  FROM saude_dadosaude sau join vw_Curriculo_aluno_pessoa                    cap on (cap.pessoa_id = sau.pessoa_id) 
                           join mat_prd..vw_sau_questionario_saude_matricula MAT on (cap.aluno_ra collate database_default = mat.aluno_ra collate database_default)
                           join saude_tipovacina                             vac on (vac.nome collate database_default = mat.vacina_nome collate database_default)
                      left join saude_vacina                                 xxx on (xxx.tipo_id = vac.id and
                                                                                     xxx.dado_id = sau.id)
 where xxx.id is null 
-- GERAR LOG  
 EXEC SP_GERAR_LOG_EM_LOTE_INSERT 'saude_VACINA', @DATAEXECUCAO 


-- commit 
-- rollback 



--select  distinct aluno_nome ,plano_saude from  mat_prd..vw_sau_questionario_saude_matricula