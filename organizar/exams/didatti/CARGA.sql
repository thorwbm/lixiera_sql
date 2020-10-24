/*******************************************************************************
                                CARGA CURSO
********************************************************************************/
-- SELECT TOP 100 * FROM TBCURSO
INSERT INTO TBCURSO (DS_CURSO)
select DESCRICAO
from educat_didatti_v2..core_curso VCUR LEFT JOIN TBCURSO CUR ON (VCUR.descricao = CUR.ds_curso)
WHERE CUR.id_curso IS NULL 
ORDER BY 1

/*******************************************************************************
                                CARGA DISCIPLINA
********************************************************************************/
-- SELECT TOP 100 * FROM TBDISCIPLINA
INSERT INTO TBDISCIPLINA (DS_DISCIPLINA)
select DESCRICAO
from educat_didatti_v2..core_disciplina VDIS LEFT JOIN TBDISCIPLINA DIS ON (VDIS.descricao = DIS.ds_disciplina)
WHERE DIS.id_disciplina IS NULL 
ORDER BY 1

/*******************************************************************************
                                CARGA PERIODO
********************************************************************************/
-- SELECT TOP 1000 * FROM TBPERIODO
INSERT INTO TBPERIODO (DS_PERIODO)
select DESCRICAO
from educat_didatti_v2..core_PERIODO VPER LEFT JOIN TBPERIODO PER ON (VPER.descricao = PER.ds_periodo)
WHERE PER.id_periodo IS NULL 
ORDER BY 1

/*******************************************************************************
                                CARGA INSTINTUICAO
********************************************************************************/
-- SELECT TOP 100 * FROM TBINSTITUICAO
INSERT INTO TBINSTITUICAO (ds_instituicao)
select DESCRICAO
from educat_didatti_v2..core_instituicao VINS LEFT JOIN TBINSTITUICAO INS ON (VINS.descricao = INS.ds_instituicao)
WHERE INS.id_instituicao IS NULL AND  VINS.ID = 4
ORDER BY 1

/*******************************************************************************
                                CARGA AVALIACAO
********************************************************************************/
insert into tbavaliacao (nota, dt_criada, id_instituicao, id_usuario, id_tipo_prova, ds_avaliacao, enade)
select nota = 10, dt_criada = getdate(), id_instituicao = 26, id_usuario = 9, 
       id_tipo_prova = 1, ds_avaliacao = 'AVALIAÇÃO ABMFR', enade = 0

/*******************************************************************************
                                CARGA ITEM
********************************************************************************/
select top 100 * from TbItemConteudo
where situacao_problema in (select  situacao_problema from educat_didatti_v2..vw_exportacao_avaliacao_139)

select distinct  imp.* 
  from educat_didatti_v2..vw_exportacao_avaliacao_139 imp left join TbItemConteudo con on (con.situacao_problema = imp.situacao_problema)
where con.id_item is null

/*******************************************************************************
                                CARGA ITEM
********************************************************************************/
-- insert TbItem (id_curso, id_disciplina, id_periodo, nr_aula, id_usuario, id_item_tipo, id_instituicao, dt_criada, id_estado_revisao)
select distinct  id_curso = 1, id_disciplina = 1632, id_periodo = 106, nr_aula = item_id,  id_usuario = 9, id_item_tipo = 1, 
                 id_instituicao = 26, dt_criada = getdate(), id_estado_revisao = 1
-- SELECT TOP 100 *
from educat_didatti_v2..vw_exportacao_avaliacao_139 ORDER BY item_id 

/*******************************************************************************
                          CARGA ITEM CONTEUDO 
********************************************************************************/
-- INSERT INTO TBITEMCONTEUDO (ID_ITEM, situacao_problema, comando_resposta, ENUNCIADO_TXT)
  select distinct ITE.ID_ITEM, IMP.situacao_problema, comando_resposta, ENUNCIADO_TXT = 'IMPORTACAO'
    from educat_didatti_v2..vw_exportacao_avaliacao_139 IMP JOIN TBITEM ITE ON (IMP.ITEM_ID = ITE.nr_aula)

	ORDER BY IMP.ITEM_id

/*******************************************************************************
                       CARGA ITEM ALTERNATIVA
********************************************************************************/
INSERT INTO TbItemAlternativa (id_item_conteudo, ds_item_alternativa, DS_JUSTIFICATIVA, BL_RESPOSTA)
SELECT  CON.id_item_conteudo, 
       ds_item_alternativa = IMP.alternativa_desc, 
	   DS_JUSTIFICATIVA = IMP.alternativa_justificativa,
	   BL_RESPOSTA      = IMP.alternativa_gabarito
  FROM educat_didatti_v2..vw_exportacao_avaliacao_139 IMP JOIN TBITEM         ITE ON (IMP.ITEM_ID = ITE.nr_aula)
                                                          JOIN TBITEMCONTEUDO CON ON (ITE.ID_ITEM = CON.id_item)

--where imp.item_id = 5138
		  order by item_id , alternativa_posicao


/*******************************************************************************
                       CARGA ITEM ALTERNATIVA
********************************************************************************/
insert into tbavaliacaoitem (valor, id_avaliacao, id_item, posicao, nr_questao, analise)
select  distinct valor = 1, ava.id_avaliacao, id_item = ite.id_item, posicao = imp.item_posicao, 
        nr_questao = imp.item_posicao, analise = 1 
  from tbavaliacao ava join educat_didatti_v2..vw_exportacao_avaliacao_139 imp on (ava.id_avaliacao = 1564)
                       join TbItem                                         ite on (ite.nr_aula = imp.item_id)




select top 100 * from TbAvaliacaoItem






select TOP 100 * from TbItemAlternativa 
 select TOP 100 * from educat_didatti_v2..vw_exportacao_avaliacao_139


where situacao_problema

select i.* from TbItem i
    join TbItemConteudo tic
        on tic.id_item = i.id_item
    join TbItemAlternativa a
        on a.id_item_conteudo = tic.id_item_conteudo
		WHERE I.nr_aula IS NOT NULL 





select distinct tipo_item_nome, instituicao_nome 
  from educat_didatti_v2..vw_exportacao_avaliacao_139 imp 

  select * from educat_didatti_v2..vw_exportacao_avaliacao_139



