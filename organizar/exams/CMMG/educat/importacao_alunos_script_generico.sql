-- use EDUCAT_CMMG

-- ### DEVERA TER SIDO EXECUTADO O SCRIPT PARA IMPORATACAO DE BASE ###
-- ###
       -- UPDATE APP SET APP.EXTRA = '{"hierarchy": {"class":{"value":"9999999","name":"' +  LTRIM(RTRIM(REVERSE(LEFT(REVERSE(DS_APLICACAO),CHARINDEX(' ',REVERSE(DS_APLICACAO)))))) + '"}}}'
       -- FROM TBAVALIACAOAPLICACAO app WHERE DS_APLICACAO LIKE 'APIC do% - 1º/2020 -%'
-- ###

/* ############ LISTA DE PARAMENTROS PARA IMPORTACAO ################
        select distinct 
               avaliacao_id, curso_id, periodo_id, data_aplicacao, 
               instituicao_id, id_disciplina, qtd_participante
     -- SELECT *
      from 
               VW_CMMG_PARAMENTRO_IMPORTACAO IMP 

			   select * from tbcurso where id_curso in (1,
37)

######################################################################
 select distinct 
        avaliacao_id, curso_id, apl.id_periodo,apl.dt_aplicacao,  
        instituicao_id, apl.id_disciplina, qtd_participante
        - , CMM.id_avaliacao, cmm.ds_avaliacao, cmm.exa_id, apl.ds_aplicacao, apl.id_instituicao, apl.extra, apl.id_avaliacao as ava_id
   from 
        VW_CMMG_PARAMENTRO_IMPORTACAO IMP JOIN VW_CMMG_AVALIACAO    CMM ON (imp.avaliacao_id = cmm.exa_id)
                                          JOIN TbAvaliacaoAplicacao apl ON (CMM.ID_AVALIACAO = apl.ID_AVALIACAO)
  WHERE 
        apl.id_avaliacao = 367 AND 
        imp.curso_nome IS NOT NULL 


		select * from VW_CMMG_PARAMENTRO_IMPORTACAO where avaliacao_id = 10
		select * from VW_CMMG_AVALIACAO where id_avaliacao = 365
		select * from TbAvaliacaoAplicacao where id_avaliacao = 365
   ################################################################## */
--   select * from TbAvaliacaoAplicacao where id_avaliacao = 374

-- 'Avaliação APIC - 1º período de Enfermagem - E015A01A201T - Trabalho em equipe' 363
-- Avaliação APIC - 3º período de Enfermagem - E014A02A201T - Metodologia do Trabalho e da Pesquisa Científica 362
-- Avaliação APIC - 7º período de Enfermagem - E013S07A201T - Assistência de Enfermagem à Saúde do idoso       360

   --SELECT * FROM VW_CMMG_AVALIACAO
   --select * from TBCURSO WHERE id_curso = 37
   --SELECT * FROM CMMG_APPLICATION_APPLICATION WHERE STARTED_at is not null 
   --SELECT * FROM TbDisciplina WHERE id_disciplina in (41)
   --select * from tbperiodo 

    declare @AVALIACAO_EXT_ID INT = 12
    declare @ID_CURSO         int = 1
    declare @ID_PERIODO       int = 22
    declare @DATA_APLICACAO   datetime = '2020-06-15 14:00:00.000'
    declare @ID_INSTITUICAO   int = 7 
    declare @ID_DISCIPLINA    int = 41
    declare @NR_RESPONDENTES  int = 173

declare @inicio datetime = getdate()
declare @FINAL datetime 
declare @descricao varchar(max)
declare @error varchar(max)

select @descricao = 'CARGA AVALAICAO - [' + ds_avaliacao + ']' from VW_cmmg_AVALIACAO where exa_id = @AVALIACAO_EXT_ID 
--BEGIN TRY
BEGIN TRAN 

--  ######### INSERT USUARIO  ######### 
 INSERT INTO TbPessoaFisica (nome, external_id)
SELECT DISTINCT  nome = USU.name, external_id = USU.ID
  FROM CMMG_APPLICATION_APPLICATION APP JOIN CMMG_USUARIO USU ON (APP.user_id = USU.id)
                                  LEFT JOIN TbPessoaFisica XXX ON (XXX.nome = USU.NAME and 
								                                   xxx.external_id = usu.id)
  WHERE XXX.id_pessoa_fisica IS NULL 
  ORDER BY usu.name 
--------------------------------------------------------------------------------------------
INSERT INTO TbUsuario (PASSWORD, EMAIL, IS_ENABLED, id_pessoa_fisica)
SELECT DISTINCT 
       PASSWORD = '123456',
	  -- EMAIL = isnull(usu.email, 'educat_ex' + CONVERT(VARCHAR(20),  ROW_NUMBER() OVER(ORDER BY USU.name ))  + '@educat.com.br'),
       EMAIL =  'educat_ex' + CONVERT(VARCHAR(20), TBF.EXTERNAL_ID  )  + '@educat.com.br',
	   IS_ENABLED = 1, TBF.id_pessoa_fisica
  FROM  TbPessoaFisica TBF  JOIN CMMG_USUARIO USU ON (USU.ID = TBF.EXTERNAL_ID)   
                       LEFT JOIN TbUsuario XXX ON (XXX.id_pessoa_fisica = TBF.id_pessoa_fisica)
   WHERE XXX.ID IS NULL
--------------------------------------------------------------------------------------------
--  ######### INSERT TBAVALIACAOAPLICACAO  #########

INSERT INTO TbAvaliacaoAplicacao (id_avaliacao, ID_CURSO, ID_PERIODO, ID_DISCIPLINA, ID_STATUS, DT_APLICACAO,
                                  DURACAO, BL_HAS_ANALISE_TRI, ID_INSTITUICAO, NR_RESPONDENTES, 
								  ds_aplicacao)
 SELECT DISTINCT  
         AVA.id_avaliacao, ID_CURSO = @ID_CURSO, ID_PERIODO = @ID_PERIODO , 
         ID_DISCIPLINA = @ID_DISCIPLINA, ID_STATUS = 3, DATA_APLICACAO = @DATA_APLICACAO,
		 DURACAO = 0, BL_HAS_ANALISE_TRI = 1, ID_INSTITUICAO = @ID_INSTITUICAO, 
		 NR_RESPONDENTES = @NR_RESPONDENTES, DS_APLICACAO = UPPER(AVA.DS_AVALIACAO)
   FROM CMMG_APPLICATION_APPLICATION APP JOIN CMMG_USUARIO         USU ON (APP.user_id = USU.id)
                                         JOIN VW_CMMG_AVALIACAO    AVA ON (AVA.exa_id = APP.exam_id)
									     JOIN TbPessoaFisica       TBF ON (TBF.nome = USU.name and 
										                                   tbf.external_id = usu.id)
									     JOIN TbUsuario            TBU ON (TBU.ID_PESSOA_FISICA = TBF.id_pessoa_fisica)
								    left join TbAvaliacaoAplicacao xxx on (xxx.id_avaliacao = AVA.id_avaliacao and
								                                           xxx.id_curso       = @ID_CURSO and
																		   xxx.id_periodo     = @ID_PERIODO and
																		   xxx.id_disciplina  = @ID_DISCIPLINA and
																		   xxx.id_instituicao = @ID_INSTITUICAO )
   WHERE AVA.exa_id = @AVALIACAO_EXT_ID and 
         xxx.id_avaliacao_aplicacao is null 

--------------------------------------------------------------------------------------------
--  ######### INSERT TBAVALIACAOREALIZACAO  #########
 INSERT INTO TbAvaliacaoRealizacao (dt_criada, dt_concluida, id_avaliacao_aplicacao, id_usuario, bl_presente, bl_aberta)

	SELECT DISTINCT DT_CRIADA = @DATA_APLICACAO,DT_CONCLUIDA = @DATA_APLICACAO, 
                    TBA.id_avaliacao_aplicacao, ID_USUARIO = TBU.id , BL_PRESENTE = 1, BL_ABERTA = 0
	FROM CMMG_APPLICATION_APPLICATION APP JOIN CMMG_USUARIO         USU ON (APP.user_id = USU.id)
									     JOIN TbPessoaFisica        TBF ON (TBF.nome = USU.name and
										                                    tbf.external_id = usu.id)
                                         JOIN VW_CMMG_AVALIACAO     AVA ON (AVA.exa_id = APP.exam_id)
									     JOIN TbAvaliacaoAplicacao  TBA ON (TBA.id_avaliacao = AVA.id_avaliacao AND
                                                                            JSON_VALUE(tba.extra,'$.hierarchy.class.name')  = JSON_VALUE(APP.extra,'$.hierarchy.class.name'))
									     JOIN TbUsuario             TBU ON (TBU.ID_PESSOA_FISICA = TBF.id_pessoa_fisica)
                                    LEFT JOIN TbAvaliacaoRealizacao XXX ON (XXX.id_avaliacao_aplicacao = TBA.id_avaliacao_aplicacao AND 
								                                            XXX.id_usuario = TBU.ID)
   WHERE AVA.exa_id       =  @AVALIACAO_EXT_ID AND 
		 TBA.dt_aplicacao = @DATA_APLICACAO AND 
         APP.started_at   IS NOT NULL  AND 
		 XXX.id_avaliacao_aplicacao IS  NULL  


--------------------------------------------------------------------------------------------
--  ######### INSERT TBAVALIACAOREALIZACAORESPOSTA  #########
  INSERT INTO TbAvaliacaoRealizacaoResposta (id_avaliacao_realizacao, id_item_alternativa, id_avaliacao_item)
    SELECT TRA.id_avaliacao_realizacao, ITX.external_id, TBI.id_avaliacao_item
	FROM CMMG_APPLICATION_APPLICATION APP JOIN CMMG_USUARIO                  USU  ON (APP.user_id = USU.id)
                                          JOIN VW_CMMG_AVALIACAO             AVA  ON (AVA.exa_id = APP.exam_id)
									      JOIN TbAvaliacaoAplicacao          TBA  ON (TBA.id_avaliacao = AVA.id_avaliacao)
									      JOIN TbPessoaFisica                TBF  ON (TBF.nome = USU.name and
									                                                  tbf.external_id = usu.id)
									      JOIN TbUsuario                     TBU  ON (TBU.ID_PESSOA_FISICA = TBF.id_pessoa_fisica)
									      JOIN TbAvaliacaoRealizacao         TRA  ON (TRA.id_usuario = TBU.id AND 
									                                                  TRA.id_avaliacao_aplicacao = TBA.id_avaliacao_aplicacao)									 
                                          JOIN CMMG_application_answer       APW  ON (APW.application_id = APP.ID)
									      JOIN vw_CMMG_item                  CTEI ON (CTEI.exa_item_id = APW.item_id )
									      JOIN TbAvaliacaoItem               TBI  ON (TBI.id_item = CTEI.id_item AND
									                                                  TBI.id_avaliacao = AVA.id_avaliacao)
								     LEFT JOIN CMMG_item_alternative         ITX  ON (ITX.item_id = CTEI.exa_item_id AND 
									                                                  ITX.ID = APW.alternative_id)
                                    left join TbAvaliacaoRealizacaoResposta XXX  ON (XXX.id_avaliacao_realizacao = TRA.id_avaliacao_realizacao AND 
                                                                                     isnull(XXX.id_item_alternativa,-1) = isnull(ITX.external_id,-1) AND
                                                                                     XXX.id_avaliacao_item = TBI.id_avaliacao_item)
	WHERE AVA.exa_id =  @AVALIACAO_EXT_ID AND 
         APP.started_at IS NOT NULL      AND
         XXX.id_avaliacao_realizacao_resposta IS NULL and 
         itx.external_id is not null 


-- commit 
-- rollback


--select * from tbavaliacao 

/*
BEGIN TRAN 
DECLARE @JSON_AUX VARCHAR(MAX)
SET @JSON_AUX = '{"hierarchy": {"class":{"value":"9999999","name":"M072S02B201T"}}}'
  
       UPDATE app SET app.EXTRA = JSON_MODIFY(@JSON_AUX, '$.hierarchy.class.name', ltrim(rtrim(reverse(left(reverse(ltrim(rtrim(ds_aplicacao))),charindex(' ',reverse(ltrim(rtrim(ds_aplicacao)))))))))
--  select * 
FROM TbAvaliacaoAplicacao app
WHERE ds_aplicacao LIKE '%201t' AND extra IS  NULL


*/


