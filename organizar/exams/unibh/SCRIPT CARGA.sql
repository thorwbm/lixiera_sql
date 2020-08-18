

/*
--         AVALIACAOITEM CARGA 
			select valor = exi.value, 
			       id_avaliacao = ctea.id_avaliacao, 
				   id_item = ctei.id_item, 
				   posicao = exi.position, 
				   nr_questao = exi.position, 
				   analise = 1 , xxx.*
			  from exam_examitem exi join cte_item       ctei on (exi.item_id = ctei.exa_item_id)
			                         join cte_avalicao   ctea on (exi.exam_id = ctea.exa_id)
			                    left join TbAvaliacaoItem xxx on (xxx.id_item = ctei.id_item and 
								                                  xxx.id_avaliacao = ctea.id_avaliacao) 
              where xxx.id_avaliacao_item is null


-- INSERIR NO USUARIO  
-- INSERT INTO TbPessoaFisica (nome)
SELECT DISTINCT USU.name
  FROM application_application APP JOIN IMP_USUARIO USU ON (APP.user_id = USU.id)
                               LEFT JOIN TbPessoaFisica XXX ON (XXX.nome = USU.NAME)
  WHERE XXX.id_pessoa_fisica IS NULL 
  ORDER BY name 

-- INSERIR NA TBUSUARIO 
INSERT INTO TbUsuario (PASSWORD, EMAIL, IS_ENABLED, id_pessoa_fisica)
SELECT DISTINCT 
       PASSWORD = '123456', EMAIL = USU.email, IS_ENABLED = 1, 
       TBF.id_pessoa_fisica
  FROM application_application APP JOIN IMP_USUARIO    USU ON (APP.user_id = USU.id)
                                   JOIN TbPessoaFisica TBF ON (TBF.nome = USU.NAME) 
							  LEFT JOIN TbUsuario      XXX ON (XXX.id_pessoa_fisica = TBF.id_pessoa_fisica)
  WHERE XXX.ID IS NULL 

INSERT INTO TbAvaliacaoAplicacao (id_avaliacao, ID_CURSO, ID_PERIODO, ID_DISCIPLINA, ID_STATUS, DT_APLICACAO, DURACAO, 
BL_HAS_ANALISE_TRI, ID_INSTITUICAO, NR_RESPONDENTES)
  SELECT DISTINCT  AVA.id_avaliacao, ID_CURSO = 14, ID_PERIODO = 106 , 
         ID_DISCIPLINA = 1717, ID_STATUS = 3, DATA_APLICACAO = '2020-04-23',
		 DURACAO = 0, BL_HAS_ANALISE_TRI = 1, ID_INSTITUICAO = 23, 
		 NR_RESPONDENTES = 39 
   FROM application_application APP JOIN IMP_USUARIO USU ON (APP.user_id = USU.id)
                                    JOIN cte_avalicao AVA ON (AVA.exa_id = APP.exam_id)
									JOIN TbPessoaFisica TBF ON (TBF.nome = USU.name)
									JOIN TbUsuario      TBU ON (TBU.ID_PESSOA_FISICA = TBF.id_pessoa_fisica)
   WHERE AVA.exa_id = 5
	

-- INSERT INTO TbAvaliacaoRealizacao (dt_criada, id_avaliacao_aplicacao, id_usuario, dt_concluida, bl_presente, bl_aberta)
	SELECT DISTINCT DT_CRIADA = '2020-04-23', TBA.id_avaliacao_aplicacao,
	      ID_USUARIO = TBU.id , DT_CONCLUIDA = '2020-04-23', BL_PRESENTE = 1, BL_ABERTA = 0
	FROM application_application APP JOIN IMP_USUARIO USU ON (APP.user_id = USU.id)
                                     JOIN cte_avalicao AVA ON (AVA.exa_id = APP.exam_id)
									 JOIN TbAvaliacaoAplicacao TBA ON (TBA.id_avaliacao = AVA.id_avaliacao)
									 JOIN TbPessoaFisica       TBF ON (TBF.nome = USU.name)
									 JOIN TbUsuario            TBU ON (TBU.ID_PESSOA_FISICA = TBF.id_pessoa_fisica)
                                LEFT JOIN TbAvaliacaoRealizacao XXX ON (XXX.id_avaliacao_aplicacao = TBA.id_avaliacao_aplicacao AND 
								                                        XXX.id_usuario = TBU.ID)

   WHERE AVA.exa_id = 5 AND 
         APP.started_at IS NOT NULL  AND 
		 TBA.dt_aplicacao = '2020-04-23' AND 
		 XXX.id_avaliacao_aplicacao IS NULL  

 */ 



  BEGIN TRAN ;
-- de para de avaliacao - exam
with	cte_avalicao as (
			select 
			       exa.external_id as exa_avaliacao_id,  
				   ava.id_avaliacao, ava.ds_avaliacao ,exa.id as exa_id
			  from 
			       exam_exam exa join tbavaliacao ava on (exa.name = ava.ds_avaliacao)
) 
	,	cte_item as (
			select 
			       ite.id as exa_item_id, tbi.id_item 
	          from 
			       item_item ite join tbitem tbi on (ite.external_id = tbi.id_item)
)
  INSERT INTO TbAvaliacaoRealizacaoResposta (id_avaliacao_realizacao, id_item_alternativa, id_avaliacao_item)
    SELECT  TRA.id_avaliacao_realizacao, ITX.external_id, TBI.id_avaliacao_item
	FROM application_application APP JOIN IMP_USUARIO USU ON (APP.user_id = USU.id)
                                     JOIN cte_avalicao AVA ON (AVA.exa_id = APP.exam_id)
									 JOIN TbAvaliacaoAplicacao TBA ON (TBA.id_avaliacao = AVA.id_avaliacao)
									 JOIN TbPessoaFisica       TBF ON (TBF.nome = USU.name)
									 JOIN TbUsuario            TBU ON (TBU.ID_PESSOA_FISICA = TBF.id_pessoa_fisica)
									 JOIN TbAvaliacaoRealizacao TRA ON (TRA.id_usuario = TBU.id AND 
									                                    TRA.id_avaliacao_aplicacao = TBA.id_avaliacao_aplicacao)									 
                                     JOIN application_answer APW  ON (APW.application_id = APP.ID)
									 JOIN cte_item           CTEI ON (CTEI.exa_item_id = APW.item_id )
									JOIN TbAvaliacaoItem     TBI ON (TBI.id_item = CTEI.id_item AND
									                                 TBI.id_avaliacao = AVA.id_avaliacao)
								LEFT	JOIN item_alternative    ITX ON (ITX.item_id = CTEI.exa_item_id AND 
									                                 ITX.ID = APW.alternative_id )


	WHERE AVA.exa_id = 5 AND 
         APP.started_at IS NOT NULL  

              
--  COMMIT 


   