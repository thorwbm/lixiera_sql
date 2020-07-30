-- USE AVALIACAO_EDUCAT

-- ### DEVERA TER SIDO EXECUTADO O SCRIPT PARA IMPORATACAO DE BASE ###

/* ############ LISTA DE PARAMENTROS PARA IMPORTACAO ################
        select distinct 
               avaliacao_id, curso_id, periodo_id, data_aplicacao, 
               instituicao_id, id_disciplina, qtd_participante
     -- SELECT *
      from 
               VW_CMMG_PARAMENTRO_IMPORTACAO
   ################################################################## */
--   select * from TbAvaliacaoAplicacao where id_avaliacao = 360

-- 'Avaliação APIC - 1º período de Enfermagem - E015A01A201T - Trabalho em equipe' 363
-- Avaliação APIC - 3º período de Enfermagem - E014A02A201T - Metodologia do Trabalho e da Pesquisa Científica 362
-- Avaliação APIC - 7º período de Enfermagem - E013S07A201T - Assistência de Enfermagem à Saúde do idoso       360

   --SELECT * FROM VW_CMMG_AVALIACAO
   --select * from TBCURSO WHERE id_curso = 1
   --SELECT * FROM CMMG_APPLICATION_APPLICATION WHERE STARTED_at is not null 
   --SELECT * FROM TbDisciplina WHERE ds_disciplina LIKE '%Avaliação Parcial Integradora de Conteúdos%'
   --select * from tbperiodo = '1 '

    declare @AVALIACAO_EXT_ID INT = 6
    declare @ID_CURSO         int = 3
    declare @ID_PERIODO       int = 26
    declare @DATA_APLICACAO   datetime = '2020-06-10 08:00:00.000'
    declare @ID_INSTITUICAO   int = 7 
    declare @ID_DISCIPLINA    int = 1510
    declare @NR_RESPONDENTES  int = 38 

declare @inicio datetime = getdate()
declare @FINAL datetime 
declare @descricao varchar(max)
declare @error varchar(max)

select @descricao = 'CARGA AVALAICAO - [' + ds_avaliacao + ']' from VW_cmmg_AVALIACAO where exa_id = @AVALIACAO_EXT_ID 
BEGIN TRY
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
	   EMAIL = isnull(usu.email, 'educat' + CONVERT(VARCHAR(20),  ROW_NUMBER() OVER(ORDER BY USU.name ))  + '@educat.com.br'),
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
 INSERT INTO TbAvaliacaoRealizacao (dt_criada, id_avaliacao_aplicacao, id_usuario, dt_concluida, bl_presente, bl_aberta)

	SELECT DISTINCT DT_CRIADA = @DATA_APLICACAO, TBA.id_avaliacao_aplicacao,
	      ID_USUARIO = TBU.id , DT_CONCLUIDA = @DATA_APLICACAO, BL_PRESENTE = 1, BL_ABERTA = 0
	FROM CMMG_APPLICATION_APPLICATION APP JOIN CMMG_USUARIO         USU ON (APP.user_id = USU.id)
									     JOIN TbPessoaFisica        TBF ON (TBF.nome = USU.name and
										                                    tbf.external_id = usu.id)
                                         JOIN VW_CMMG_AVALIACAO     AVA ON (AVA.exa_id = APP.exam_id)
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
	FROM CMMG_APPLICATION_APPLICATION APP JOIN CMMG_USUARIO                 USU  ON (APP.user_id = USU.id)
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
								    LEFT JOIN CMMG_item_alternative          ITX  ON (ITX.item_id = CTEI.exa_item_id AND 
									                                                 ITX.ID = APW.alternative_id)
                                    left join TbAvaliacaoRealizacaoResposta XXX  ON (XXX.id_avaliacao_realizacao = TRA.id_avaliacao_realizacao AND 
                                                                                     isnull(XXX.id_item_alternativa,-1) = isnull(ITX.external_id,-1) AND
                                                                                     XXX.id_avaliacao_item = TBI.id_avaliacao_item)
	WHERE AVA.exa_id = @AVALIACAO_EXT_ID AND 
         APP.started_at IS NOT NULL      AND
         XXX.id_avaliacao_realizacao_resposta IS NULL --and 
         --itx.external_id is not null 
--------------------------------------------------------------------------------------------
        exec sp_gerar_log_carga 'CARGA AVALIACAO', @descricao, NULL, 'OK', @INICIO, @FINAL
-- COMMIT
        PRINT 'PROCESSAMENTO EFETUADO COM SUCESSO !!!'
END TRY
BEGIN CATCH
	ROLLBACK 
	SET @FINAL = GETDATE()
	SET @ERROR = 'ERRO DE PROCESSAMENTO - ##### - ' + ERROR_MESSAGE() 
	exec sp_gerar_log_carga 'CARGA AVALIACAO', @descricao, @ERROR, 'ERRO', @INICIO, @FINAL
	PRINT' ERRO DE PROCESSAMENTO - ##### - ' + ERROR_MESSAGE() 
END CATCH

/******************************************************************************************
CREATE OR ALTER VIEW VW_CMMG_AVALIACAO AS
	select 
		exa.external_id as exa_avaliacao_id,  
		ava.id_avaliacao, ava.ds_avaliacao ,exa.id as exa_id
	from 
		CMMG_EXAM_EXAM exa join tbavaliacao ava on (exa.name = ava.ds_avaliacao)

CREATE OR ALTER VIEW VW_CMMG_ITEM AS
		select 
			ite.id as exa_item_id, tbi.id_item 
	    from 
			CMMG_ITEM_ITEM ite join tbitem tbi on (ite.external_id = tbi.id_item)
*******************************************************************************************/


/*
SELECT * FROM TbAvaliacao WHERE id_avaliacao = 363
SELECT * FROM CMMG_EXAM_EXAM WHERE ID = 8 

-APIC do 1º período de Enfermagem - 1º/2020-
-APIC do 1º período de Enfermagem - 1º/2020-




create OR ALTER view VW_CMMG_PARAMENTRO_IMPORTACAO AS      
select distinct       
       ava.avaliacao_id, isnull(cur.id_curso,120) as curso_id, per.id_periodo as periodo_id,      
       ava.data_aplicacao, ins.id_instituicao as instituicao_id,       
       dis.id_disciplina, ava.qtd_participante,       
       ava.avaliacao_nome, 
       CASE WHEN LEFT(AVA.TURMA_NOME,1) = 'E' THEN 'ENFERMAGEM'
            WHEN LEFT(AVA.TURMA_NOME,1) = 'M' THEN 'MEDICINA'
            WHEN LEFT(AVA.TURMA_NOME,1) = 'P' THEN 'PSICOLOGIA'
            WHEN LEFT(AVA.TURMA_NOME,1) = 'F' THEN 'FISOTERAPIA' END AS CURSO_NOME, 
            ava.grade_nome,  ava.instituicao_nome,       
       ava.disciplina_nome     
  from CMMG_DADOS_EXPORTACAO ava left join tbperiodo per on (per.ds_periodo = ava.grade_nome)      
                                 left join TbInstituicao ins on (ins.ds_instituicao = CASE WHEN ava.instituicao_nome = 'CMMG'THEN 'CMMG - Faculdade de Ciências Médicas' ELSE  ava.instituicao_nome END  )      
                                 LEFT join TbDisciplina  dis on (dis.ds_disciplina  = ava.disciplina_nome)      
                                 LEFT join TbCurso cur on (CUR.DS_CURSO   = CASE WHEN LEFT(AVA.TURMA_NOME,1) = 'E' THEN 'ENFERMAGEM'
                                                                                 WHEN LEFT(AVA.TURMA_NOME,1) = 'M' THEN 'MEDICINA'
                                                                                 WHEN LEFT(AVA.TURMA_NOME,1) = 'P' THEN 'PSICOLOGIA'
                                                                                 WHEN LEFT(AVA.TURMA_NOME,1) = 'F' THEN 'FISOTERAPIA' END AND ID_CURSO <> 37)



SELECT * FROM CMMG_DADOS_EXPORTACAO 
SELECT * FROM TbCurso WHERE DS_CURSO = 'ENFERMAGEM'


 select distinct 
        avaliacao_id, curso_id, periodo_id, data_aplicacao, 
        instituicao_id, id_disciplina, qtd_participante
     -- SELECT *
      from 
               VW_CMMG_PARAMENTRO_IMPORTACAO



SELECT * FROM TBCURSO 
WHERE DS_CURSO IN (
'CURSO DE EXTENSÃO EM ORATÓRIA',
'CURSO DE TUTORIA',
'CURSO OFERTA OPTATIVAS',
'ENFERMAGEM',
'FISIOTERAPIA',
'MEDICINA',
'PSICOLOGIA'
)


select * from VW_CMMG_PARAMENTRO_IMPORTACAO

select * from TbAvaliacao

select * from TbAvaliacaoAplicacao where id_avaliacao = 363

select * from TbAvaliacaoRealizacao where id_avaliacao_aplicacao = 407
Avaliação APIC - 7º período de Enfermagem - E013S07A201T - Assistência de Enfermagem à Saúde do idosoAvaliação APIC - 3º período de Enfermagem - E014A02A201T - Metodologia do Trabalho e da Pesquisa Científica
*/