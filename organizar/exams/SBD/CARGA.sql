/*******************************************************************************
                                CARGA CURSO
********************************************************************************/
-- SELECT TOP 100 * FROM TBCURSO
INSERT INTO TBCURSO (DS_CURSO)
select DESCRICAO
from SBD_prova.EDUCAT_SBD.[dbo].core_curso VCUR LEFT JOIN TBCURSO CUR ON (VCUR.descricao COLLATE DATABASE_DEFAULT = CUR.ds_curso  COLLATE DATABASE_DEFAULT)
WHERE CUR.id_curso IS NULL 
ORDER BY 1

/*******************************************************************************
                                CARGA DISCIPLINA
********************************************************************************/
-- SELECT TOP 100 * FROM TBDISCIPLINA
INSERT INTO TBDISCIPLINA (DS_DISCIPLINA)
select DESCRICAO
from SBD_prova.EDUCAT_SBD.[dbo].core_disciplina VDIS LEFT JOIN TBDISCIPLINA DIS ON (VDIS.descricao COLLATE DATABASE_DEFAULT = DIS.ds_disciplina COLLATE DATABASE_DEFAULT)
WHERE DIS.id_disciplina IS NULL 
ORDER BY 1

/*******************************************************************************
                                CARGA PERIODO
********************************************************************************/
-- SELECT TOP 1000 * FROM TBPERIODO
INSERT INTO TBPERIODO (DS_PERIODO)
select DESCRICAO
from SBD_prova.EDUCAT_SBD.[dbo].core_PERIODO VPER LEFT JOIN TBPERIODO PER ON (VPER.descricao COLLATE DATABASE_DEFAULT = PER.ds_periodo COLLATE DATABASE_DEFAULT)
WHERE PER.id_periodo IS NULL 
ORDER BY 1

/*******************************************************************************
                                CARGA INSTINTUICAO
********************************************************************************/
-- SELECT TOP 100 * FROM TBINSTITUICAO
INSERT INTO TBINSTITUICAO (ds_instituicao)
select DESCRICAO
from SBD_prova.EDUCAT_SBD.[dbo].core_instituicao VINS LEFT JOIN TBINSTITUICAO INS ON (VINS.descricao COLLATE DATABASE_DEFAULT = INS.ds_instituicao COLLATE DATABASE_DEFAULT)
WHERE INS.id_instituicao IS NULL 
ORDER BY 1

/*******************************************************************************
                                CARGA AVALIACAO
********************************************************************************/
--insert into tbavaliacao (nota, dt_criada, id_instituicao, id_usuario, id_tipo_prova, ds_avaliacao, enade)
select nota = VALOR, dt_criada = getdate(), id_instituicao = 27, id_usuario = 9, 
       id_tipo_prova = 1, ds_avaliacao = NOME, enade = 0
  FROM SBD_prova.EDUCAT_SBD.[dbo].avaliacoes_avaliacao
  WHERE ID IN (6,5,4,3)

/*******************************************************************************
                                CARGA ITEM
********************************************************************************/
select top 100 * from TbItemConteudo
where situacao_problema in (select  situacao_problema from SBD_prova.EDUCAT_SBD.[dbo].vw_exportacao_avaliacao)

select distinct  imp.* 
  from SBD_prova.EDUCAT_SBD.[dbo].vw_exportacao_avaliacao imp left join TbItemConteudo con on (con.situacao_problema COLLATE DATABASE_DEFAULT = imp.situacao_problema COLLATE DATABASE_DEFAULT)
where con.id_item is null AND 
      IMP.avaliacao_id IN (6,5,4,3)

/*******************************************************************************
                                CARGA ITEM
********************************************************************************/
-- insert TbItem (id_curso, id_disciplina, id_periodo, nr_aula, id_usuario, id_item_tipo, id_instituicao, dt_criada, id_estado_revisao)
select distinct  id_curso = 1, id_disciplina = 1727, id_periodo = 114, nr_aula = item_id,  id_usuario = 9, id_item_tipo = 1, 
                 id_instituicao = 27, dt_criada = getdate(), id_estado_revisao = 1
-- SELECT TOP 100 *
from SBD_prova.EDUCAT_SBD.[dbo].vw_exportacao_avaliacao 
WHERE avaliacao_id IN (6,5,4,3)
ORDER BY item_id 

/*******************************************************************************
                          CARGA ITEM CONTEUDO 
********************************************************************************/
-- INSERT INTO TBITEMCONTEUDO (ID_ITEM, situacao_problema, comando_resposta, ENUNCIADO_TXT)
  select distinct ITE.ID_ITEM, IMP.situacao_problema, IMP.comando_resposta, ENUNCIADO_TXT = 'IMPORTACAO'
    from IMP_vw_exportacao_avaliacao IMP JOIN TBITEM ITE ON (IMP.ITEM_ID = ITE.nr_aula)
	                                LEFT JOIN TBITEMCONTEUDO XXX ON (XXX.situacao_problema COLLATE DATABASE_DEFAULT = IMP.SITUACAO_PROBLEMA COLLATE DATABASE_DEFAULT AND 
									                                 XXX.comando_resposta  COLLATE DATABASE_DEFAULT = IMP.COMANDO_RESPOSTA  COLLATE DATABASE_DEFAULT)
	WHERE IMP.avaliacao_id IN (6,5,4,3) AND 
	      XXX.id_item_conteudo IS NULL 
	ORDER BY ITE.ID_ITEM

	--  select distinct ITE.ID_ITEM, IMP.situacao_problema, comando_resposta, ENUNCIADO_TXT = 'IMPORTACAO'
 --   from SBD_prova.EDUCAT_SBD.[dbo].vw_exportacao_avaliacao IMP JOIN TBITEM ITE ON (IMP.ITEM_ID = ITE.nr_aula)
	--WHERE IMP.avaliacao_id IN (6,5,4,3)
	--ORDER BY ITE.ID_ITEM


	--SELECT * INTO IMP_vw_exportacao_avaliacao FROM SBD_prova.EDUCAT_SBD.[dbo].vw_exportacao_avaliacao 

/*******************************************************************************
                       CARGA ITEM ALTERNATIVA
********************************************************************************/
INSERT INTO TbItemAlternativa (id_item_conteudo, ds_item_alternativa, DS_JUSTIFICATIVA, BL_RESPOSTA)
SELECT 
       CON.id_item_conteudo, 
       ds_item_alternativa = IMP.alternativa_desc, 
	   DS_JUSTIFICATIVA = IMP.alternativa_justificativa,
	   BL_RESPOSTA      = IMP.alternativa_gabarito
  FROM IMP_vw_exportacao_avaliacao IMP JOIN TBITEM         ITE ON (IMP.ITEM_ID = ITE.nr_aula)
                                       JOIN TBITEMCONTEUDO CON ON (ITE.ID_ITEM = CON.id_item)
								  LEFT JOIN TbItemAlternativa xxx ON (XXX.ds_item_alternativa COLLATE DATABASE_DEFAULT = IMP.ALTERNATIVA_DESC COLLATE DATABASE_DEFAULT)

	WHERE IMP.avaliacao_id IN (6,5,4,3) AND 
	      XXX.id_item_alternativa IS NULL 
		  order by item_id , alternativa_posicao

select * from IMP_vw_exportacao_avaliacao where item_id = 2

		  SELECT * FROM TbItemAlternativa WHERE id_item_conteudo IN (13008, 13009, 13016, 13017)
--SELECT DISTINCT
--       CON.id_item_conteudo, 
--       ds_item_alternativa = IMP.alternativa_desc, 
--	   DS_JUSTIFICATIVA = IMP.alternativa_justificativa,
--	   BL_RESPOSTA      = IMP.alternativa_gabarito
--  FROM SBD_prova.EDUCAT_SBD.[dbo].vw_exportacao_avaliacao IMP JOIN TBITEM         ITE ON (IMP.ITEM_ID = ITE.nr_aula)
--                                                              JOIN TBITEMCONTEUDO CON ON (ITE.ID_ITEM = CON.id_item)
--	WHERE IMP.avaliacao_id IN (6,5,4,3)

/*******************************************************************************
                       CARGA ITEM ALTERNATIVA
********************************************************************************/
insert into tbavaliacaoitem (valor, id_avaliacao, id_item, posicao, nr_questao, analise)
select  distinct valor = 1, ava.id_avaliacao, id_item = ite.id_item, posicao = imp.item_posicao, 
        nr_questao = imp.item_posicao, analise = 1 
  from tbavaliacao ava join VW_DE_PARA_AVALIACAO        DPA ON (AVA.id_avaliacao = DPA.ID_AVALIACAO)  
                       JOIN IMP_vw_exportacao_avaliacao imp on (IMP.avaliacao_id = DPA.ID)
                       join TbItem                      ite on (ite.nr_aula = imp.item_id)
				  LEFT JOIN TBAVALIACAOITEM             XXX ON (XXX.id_avaliacao = AVA.id_avaliacao AND 
				                                                XXX.id_item      = ITE.id_item)
	WHERE IMP.avaliacao_id IN (6,5,4,3) AND 
	      XXX.id_avaliacao_item IS NULL 



	SELECT * FROM tbavaliacao

--select  distinct valor = 1, ava.id_avaliacao, id_item = ite.id_item, posicao = imp.item_posicao, 
--        nr_questao = imp.item_posicao, analise = 1 
--  from tbavaliacao ava join SBD_prova.EDUCAT_SBD.[dbo].vw_exportacao_avaliacao imp on (ava.id_avaliacao = 1564)
--                       join TbItem                                         ite on (ite.nr_aula = imp.item_id)
--	WHERE IMP.avaliacao_id IN (6,5,4,3)



/**********************************************************************************
select top 100 * from TbAvaliacaoItem

select TOP 100 * from TbItemAlternativa 
 select TOP 100 * from SBD_prova.EDUCAT_SBD.[dbo].vw_exportacao_avaliacao

where situacao_problema

select i.* from TbItem i
    join TbItemConteudo tic
        on tic.id_item = i.id_item
    join TbItemAlternativa a
        on a.id_item_conteudo = tic.id_item_conteudo
		WHERE I.nr_aula IS NOT NULL 

**********************************************************************************/


--CREATE VIEW VW_DE_PARA_AVALIACAO AS 
-- SELECT TBA.ID_AVALIACAO, TBA.DS_AVALIACAO, AVA.ID, AVA.NOME 
-- FROM SBD_prova.EDUCAT_SBD.[dbo].avaliacoes_avaliacao AVA JOIN TbAvaliacao TBA ON (AVA.NOME COLLATE DATABASE_DEFAULT = TBA.ds_avaliacao COLLATE DATABASE_DEFAULT)



