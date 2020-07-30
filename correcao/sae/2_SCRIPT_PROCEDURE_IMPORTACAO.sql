



-- USE AVALIACAO_EDUCAT

-- ### DEVERA TER SIDO EXECUTADO O SCRIPT PARA IMPORATACAO DE BASE ###

/* ############ LISTA DE PARAMENTROS PARA IMPORTACAO ################
        select distinct 
               avaliacao_id, curso_id, periodo_id, data_aplicacao, 
               instituicao_id, id_disciplina, qtd_participante, grade_nome as periodo_nome
			   --, curso_nome, grade_nome as periodo_nome, instituicao_nome, disciplina_nome
          from 
               VW_SAE_PARAMENTRO_IMPORTACAO where grade_nome = '7º ano'

   ################################################################## */
--    select * from tbcurso where id_curso = 120

create procedure sp_carga_prova_sae 
 @AVALIACAO_EXT_ID INT, 
 @ID_DISCIPLINA    int, 
 @ID_CURSO         int, 
 @ID_PERIODO       int, 
 @DATA_APLICACAO   datetime, 
 @ID_INSTITUICAO   int, 
 @NR_RESPONDENTES  int  
 as 
    --declare @AVALIACAO_EXT_ID INT = 54
    --declare @ID_DISCIPLINA    int = 1699
    --declare @ID_CURSO         int = 120
    --declare @ID_PERIODO       int = 100
    --declare @DATA_APLICACAO   datetime = '2020-04-22'
    --declare @ID_INSTITUICAO   int = 22 
    --declare @NR_RESPONDENTES  int = 3563 

declare @inicio datetime = getdate()
declare @FINAL datetime 
declare @descricao varchar(max)
declare @error varchar(max)

select @descricao = 'CARGA AVALAICAO - [' + ds_avaliacao + ']' from VW_SAE_AVALIACAO where exa_id = @AVALIACAO_EXT_ID
BEGIN TRY
BEGIN TRAN 

--  ######### INSERT USUARIO  ######### 
 INSERT INTO TbPessoaFisica (nome, external_id)
SELECT DISTINCT  nome = USU.name, external_id = USU.ID
  FROM SAE_APPLICATION_APPLICATION APP JOIN SAE_USUARIO USU ON (APP.user_id = USU.id)
                                  LEFT JOIN TbPessoaFisica XXX ON (XXX.nome = USU.NAME and 
								                                   xxx.external_id = usu.id)
  WHERE USU.name is not null and 
        XXX.id_pessoa_fisica IS NULL 
  ORDER BY usu.name 
--------------------------------------------------------------------------------------------
INSERT INTO TbUsuario (PASSWORD, EMAIL, IS_ENABLED, id_pessoa_fisica)
SELECT DISTINCT 
       PASSWORD = '123456',
	   EMAIL = 'educat1EX' + CONVERT(VARCHAR(20), TBF.EXTERNAL_ID) + '@educat.com.br',
	   --case when usu.email = '' then 'educat' + CONVERT(VARCHAR(20),  ROW_NUMBER() OVER(ORDER BY USU.name ))  + '@educat.com.br'
	   --             else isnull(usu.email, 'educat' + CONVERT(VARCHAR(20),  ROW_NUMBER() OVER(ORDER BY USU.name ))  + '@educat.com.br') end,
	   IS_ENABLED = 1, TBF.id_pessoa_fisica
  FROM  TbPessoaFisica TBF  JOIN SAE_USUARIO USU ON (USU.ID = TBF.EXTERNAL_ID)   
                       LEFT JOIN TbUsuario XXX ON (XXX.id_pessoa_fisica = TBF.id_pessoa_fisica)
   WHERE XXX.ID IS NULL
--------------------------------------------------------------------------------------------
--  ######### INSERT TBAVALIACAOAPLICACAO  #########
INSERT INTO TbAvaliacaoAplicacao (id_avaliacao, ID_CURSO, ID_PERIODO, ID_DISCIPLINA, 
            ID_STATUS, DT_APLICACAO, DURACAO, BL_HAS_ANALISE_TRI, ID_INSTITUICAO, NR_RESPONDENTES, DS_APLICACAO)
  SELECT DISTINCT  AVA.id_avaliacao, ID_CURSO = @ID_CURSO, ID_PERIODO = @ID_PERIODO , 
         ID_DISCIPLINA = @ID_DISCIPLINA, ID_STATUS = 3, DATA_APLICACAO = @DATA_APLICACAO,
		 DURACAO = 0, BL_HAS_ANALISE_TRI = 1, ID_INSTITUICAO = @ID_INSTITUICAO, 
		 NR_RESPONDENTES = @NR_RESPONDENTES, DS_APLICACAO = UPPER(AVA.DS_AVALIACAO) 
   FROM SAE_APPLICATION_APPLICATION APP JOIN SAE_USUARIO      USU ON (APP.user_id = USU.id)
                                        JOIN VW_SAE_AVALIACAO AVA ON (AVA.exa_id = APP.exam_id)
									    JOIN TbPessoaFisica   TBF ON (TBF.nome = USU.name and 
										                              tbf.external_id = usu.id)
									    JOIN TbUsuario        TBU ON (TBU.ID_PESSOA_FISICA = TBF.id_pessoa_fisica)
								   left join TbAvaliacaoAplicacao xxx on (xxx.id_avaliacao = AVA.id_avaliacao and
								                                          xxx.id_curso       = @ID_CURSO and
																		  xxx.id_periodo     = @ID_PERIODO and
																		  xxx.id_disciplina  = @ID_DISCIPLINA and
																		  xxx.id_instituicao = @ID_INSTITUICAO )
   WHERE AVA.exa_id = @AVALIACAO_EXT_ID and 
         xxx.id_avaliacao_aplicacao is null 
--------------------------------------------------------------------------------------------
--  ######### INSERT TBAVALIACAOREALIZACAO  #########
 INSERT INTO TbAvaliacaoRealizacao (dt_criada, id_avaliacao_aplicacao, id_usuario, dt_concluida, bl_presente, bl_aberta, EXTRA)
	SELECT DISTINCT DT_CRIADA = @DATA_APLICACAO, TBA.id_avaliacao_aplicacao,
	      ID_USUARIO = TBU.id , DT_CONCLUIDA = @DATA_APLICACAO, BL_PRESENTE = 1, BL_ABERTA = 0, USU.EXTRA
	FROM SAE_APPLICATION_APPLICATION APP JOIN SAE_USUARIO           USU ON (APP.user_id = USU.id)
									     JOIN TbPessoaFisica        TBF ON (TBF.nome = USU.name and
										                                    tbf.external_id = usu.id)
                                         JOIN VW_SAE_AVALIACAO      AVA ON (AVA.exa_id = APP.exam_id)
									     JOIN TbAvaliacaoAplicacao  TBA ON (TBA.id_avaliacao = AVA.id_avaliacao)
									     JOIN TbUsuario             TBU ON (TBU.ID_PESSOA_FISICA = TBF.id_pessoa_fisica)
                                    LEFT JOIN TbAvaliacaoRealizacao XXX ON (XXX.id_avaliacao_aplicacao = TBA.id_avaliacao_aplicacao AND 
								                                            XXX.id_usuario = TBU.ID)
   WHERE AVA.exa_id = @AVALIACAO_EXT_ID AND 
		 TBA.dt_aplicacao = @DATA_APLICACAO AND 
         APP.started_at IS NOT NULL  AND 
		 XXX.id_avaliacao_aplicacao IS NULL  
--------------------------------------------------------------------------------------------
--  ######### INSERT TBAVALIACAOREALIZACAORESPOSTA  #########
  INSERT INTO TbAvaliacaoRealizacaoResposta (id_avaliacao_realizacao, id_item_alternativa, id_avaliacao_item)
    SELECT TRA.id_avaliacao_realizacao, ITX.external_id, TBI.id_avaliacao_item
	FROM SAE_APPLICATION_APPLICATION APP JOIN SAE_USUARIO                   USU  ON (APP.user_id = USU.id)
                                         JOIN VW_SAE_AVALIACAO              AVA  ON (AVA.exa_id = APP.exam_id)
									     JOIN TbAvaliacaoAplicacao          TBA  ON (TBA.id_avaliacao = AVA.id_avaliacao)
									     JOIN TbPessoaFisica                TBF  ON (TBF.nome = USU.name and
									                                                 tbf.external_id = usu.id)
									     JOIN TbUsuario                     TBU  ON (TBU.ID_PESSOA_FISICA = TBF.id_pessoa_fisica)
									     JOIN TbAvaliacaoRealizacao         TRA  ON (TRA.id_usuario = TBU.id AND 
									                                                 TRA.id_avaliacao_aplicacao = TBA.id_avaliacao_aplicacao)									 
                                         JOIN sae_application_answer        APW  ON (APW.application_id = APP.ID)
									     JOIN vw_sae_item                   CTEI ON (CTEI.exa_item_id = APW.item_id )
									     JOIN TbAvaliacaoItem               TBI  ON (TBI.id_item = CTEI.id_item AND
									                                                 TBI.id_avaliacao = AVA.id_avaliacao)
								    LEFT JOIN sae_item_alternative          ITX  ON (ITX.item_id = CTEI.exa_item_id AND 
									                                                 ITX.ID = APW.alternative_id)
                                    left join TbAvaliacaoRealizacaoResposta XXX  ON (XXX.id_avaliacao_realizacao = TRA.id_avaliacao_realizacao AND 
                                                                                     XXX.id_avaliacao_item = TBI.id_avaliacao_item)
	WHERE AVA.exa_id = @AVALIACAO_EXT_ID AND 
         APP.started_at IS NOT NULL      AND
         XXX.id_avaliacao_realizacao_resposta IS NULL
--------------------------------------------------------------------------------------------
     SET @FINAL = GETDATE()
     exec sp_gerar_log_carga 'CARGA AVALIACAO', @descricao, NULL, 'OK', @INICIO, @FINAL
 COMMIT
        PRINT 'PROCESSAMENTO EFETUADO COM SUCESSO -- ' + convert(varchar(20), @AVALIACAO_EXT_ID) + ' -- ' + convert(varchar(20), @ID_DISCIPLINA) 
END TRY
BEGIN CATCH
	ROLLBACK 
	SET @FINAL = GETDATE()
	SET @ERROR = 'ERRO DE PROCESSAMENTO - ##### - ' + ERROR_MESSAGE() 
	exec sp_gerar_log_carga 'CARGA AVALIACAO', @descricao, @ERROR, 'ERRO', @INICIO, @FINAL
	PRINT' ERRO DE PROCESSAMENTO - ##### - ' + ERROR_MESSAGE() 
END CATCH

/******************************************************************************************
CREATE OR ALTER VIEW VW_SAE_AVALIACAO AS
	select 
		exa.external_id as exa_avaliacao_id,  
		ava.id_avaliacao, ava.ds_avaliacao ,exa.id as exa_id
	from 
		SAE_EXAM_EXAM exa join tbavaliacao ava on (exa.name = ava.ds_avaliacao)

CREATE OR ALTER VIEW VW_SAE_ITEM AS
		select 
			ite.id as exa_item_id, tbi.id_item 
	    from 
			SAE_ITEM_ITEM ite join tbitem tbi on (ite.external_id = tbi.id_item)


			select top 10 * from TbAvaliacaoRealizacaoResposta
*******************************************************************************************/