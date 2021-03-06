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
--   select * from TbAvaliacaoAplicacao where id_avaliacao = 368

-- 'Avalia��o APIC - 1� per�odo de Enfermagem - E015A01A201T - Trabalho em equipe' 363
-- Avalia��o APIC - 3� per�odo de Enfermagem - E014A02A201T - Metodologia do Trabalho e da Pesquisa Cient�fica 362
-- Avalia��o APIC - 7� per�odo de Enfermagem - E013S07A201T - Assist�ncia de Enfermagem � Sa�de do idoso       360

   --SELECT * FROM VW_CMMG_AVALIACAO
   --select * from TBCURSO WHERE id_curso = 1
   --SELECT * FROM CMMG_APPLICATION_APPLICATION WHERE STARTED_at is not null 
   --SELECT * FROM TbDisciplina WHERE ds_disciplina LIKE '%Avalia��o Parcial Integradora de Conte�dos%'
   --select * from tbperiodo = '1 '

    declare @AVALIACAO_EXT_ID INT = 13
    declare @ID_CURSO         int = 1
    declare @ID_PERIODO       int = 23
    declare @DATA_APLICACAO   datetime = '2020-06-16 14:00:00.000'
    declare @ID_INSTITUICAO   int = 7 
    declare @ID_DISCIPLINA    int = 49
    declare @NR_RESPONDENTES  int = 124 

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

	SELECT DISTINCT --DT_CRIADA = @DATA_APLICACAO,DT_CONCLUIDA = @DATA_APLICACAO, 
                    TBA.id_avaliacao_aplicacao, ID_USUARIO = TBU.id , BL_PRESENTE = 1, BL_ABERTA = 0
	FROM CMMG_APPLICATION_APPLICATION APP JOIN CMMG_USUARIO         USU ON (APP.user_id = USU.id)
									     JOIN TbPessoaFisica        TBF ON (TBF.nome = USU.name and
										                                    tbf.external_id = usu.id)
                                         JOIN VW_CMMG_AVALIACAO     AVA ON (AVA.exa_id = APP.exam_id)
									     JOIN TbAvaliacaoAplicacao  TBA ON (TBA.id_avaliacao = AVA.id_avaliacao AND
                                                                            tba.extra = app.extra)
									     JOIN TbUsuario             TBU ON (TBU.ID_PESSOA_FISICA = TBF.id_pessoa_fisica)
                                    LEFT JOIN TbAvaliacaoRealizacao XXX ON (XXX.id_avaliacao_aplicacao = TBA.id_avaliacao_aplicacao AND 
								                                            XXX.id_usuario = TBU.ID)
   WHERE  
          AVA.exa_id = @AVALIACAO_EXT_ID AND 
		 TBA.dt_aplicacao = @DATA_APLICACAO AND 
         APP.started_at IS NOT NULL  AND 
		 XXX.id_avaliacao_aplicacao IS NULL  


--------------------------------------------------------------------------------------------
--  ######### INSERT TBAVALIACAOREALIZACAORESPOSTA  #########
 -- INSERT INTO TbAvaliacaoRealizacaoResposta (id_avaliacao_realizacao, id_item_alternativa, id_avaliacao_item)
 



