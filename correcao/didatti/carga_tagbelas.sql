-- ***** insert PERIODO *******
--  delete from core_periodo   DBCC CHECKIDENT('core_periodo', RESEED, 0)

insert into core_periodo (criado_em, atualizado_em, descricao)
select distinct criado_em = getdate(), atualizado_em = getdate(), DS_PERIODO
from avaliacao_2020..TbPeriodo
order by DS_PERIODO
-- select * from core_periodo

 
-------------------------------------------------------------------------------------------
-- ***** insert curso *******
--  delete from core_curso
--  DBCC CHECKIDENT('core_curso', RESEED, 0)
insert into core_curso (criado_em, atualizado_em, descricao, codigo)
select distinct criado_em = getdate(), atualizado_em = getdate(), ds_curso, id_curso
from avaliacao_2020..TbCurso
order by ds_curso
-- select * from core_curso

-------------------------------------------------------------------------------------------
--****** insert disciplina 
insert into core_disciplina (criado_em, atualizado_em, descricao, codigo)
select criado_em = getdate(), atualizado_em = getdate(), ds_disciplina, id_disciplina
from avaliacao_2020..TbDisciplina
order by ds_disciplina
-- select * from core_disciplina

-------------------------------------------------------------------------------------------
-- ***** insert item *******
--  delete from itens_item     DBCC CHECKIDENT('itens_item', RESEED, 0)


insert into itens_item (criado_em, criado_por, atualizado_em, versao, ano, situacao_problema, publico, 
                        comando_resposta, status_id, tipo_id, curso_id, disciplina_id, instituicao_id)
select distinct criado_em = getdate(), criado_por = 3, atualizado_em = getdate(), versao = 1, ano = 2019, 
                situacao_problema = conx.situacao_problema,
				publico = 0, 
                comando_resposta = conx.comando_resposta, status_id = 1, tipo_id = itex.id_item_tipo, 
				curso_id = cur.id, disciplina_id = dis.id, instituicao_id = ins.id

  from avaliacao_2020..TbItem itex join avaliacao_2020..TbItemConteudo conx on (itex.id_item  = conx.id_item)
                                   join avaliacao_2020..TbCurso        curx on (curx.id_curso = itex.id_curso)
								   join core_curso                     cur  on (cur.descricao = curx.ds_curso)         
								   join avaliacao_2020..TbDisciplina   disx on (disx.id_disciplina = itex.id_disciplina)
								   join core_disciplina                dis  on (disx.ds_disciplina = dis.descricao)
								   join avaliacao_2020..TbInstituicao  insx on (insx.id_instituicao = itex.id_instituicao)
								   join core_instituicao               ins  on (insx.ds_instituicao = ins.descricao)
where insx.id_instituicao = 15 
-- select * from itens_item

-------------------------------------------------------------------------------------------
-- ***** insert item alternativa *******
--  delete from itens_alternativa     DBCC CHECKIDENT('itens_alternativa', RESEED, 0)
 
insert into itens_alternativa (criado_em, atualizado_em, descricao, justificativa, gabarito, item_id, posicao)
select distinct 
    criado_em = getdate(), atualizado_em = getdate(), 
    descricao = altx.ds_item_alternativa, justificativa = altx.ds_justificativa, 
    gabarito  = altx.bl_resposta, ite.id, 
	posicao   = ROW_NUMBER() OVER(PARTITION BY altx.id_item_conteudo, ite.id ORDER BY altx.ds_item_alternativa, altx.ds_justificativa) 
from avaliacao_2020..TbItemAlternativa  altx join avaliacao_2020..TbItemConteudo conx on (conx.id_item_conteudo = altx.id_item_conteudo)
                                             join avaliacao_2020..tbitem         itex on (itex.id_item = conx.id_item)
											 join itens_item                     ite  on (ite.situacao_problema = isnull(conx.situacao_problema, conx.enunciado_txt) and 
                                                                                          ite.comando_resposta = conx.comando_resposta)
where itex.id_instituicao = 15

-- select top 10 * from itens_alternativa

--#############################################################################################

-- ######  ANALISES  ########

-------------------------------------------------------------------------------------------
-- ***** insert avaliacoes avaliacao *******
--  delete from avaliacoes_avaliacao     DBCC CHECKIDENT('avaliacoes_avaliacao', RESEED, 0)

insert into avaliacoes_avaliacao (criado_em, atualizado_em, atualizado_por_id, criado_por_id, 
                                  nome, valor, versao, instrucoes, exame_id)
select distinct criado_em = getdate(), atualizado_em = getdate(), atualizado_por_id = 3, criado_por_id =  3, 
                nome = ava.ds_avaliacao, valor = ava.nota, versao = 1, instrucoes = ava.instrucoes, exame_id = NULL

  from avaliacao_2020..TbAnalise ana join avaliacao_2020..TbAnalise_Aplicacao  tap on (tap.id_analise = ana.id_analise) 
                                     join avaliacao_2020..TbAvaliacaoAplicacao apl on (apl.id_avaliacao_aplicacao = tap.id_avaliacao_aplicacao)            
									 join avaliacao_2020..TbAvaliacao          ava on (ava.id_avaliacao = apl.id_avaliacao and 
									                                                   ava.id_instituicao = apl.id_instituicao)
where apl.id_instituicao = 15
-- SELECT * FROM avaliacoes_avaliacao

-------------------------------------------------------------------------------------------
-- ***** insert analise *******  OBS - EXTERNAL_ID COLOQUEI O ID VINDO DA BASE DE ORIGEM
--  delete from analises_analise     DBCC CHECKIDENT('analises_analise', RESEED, 0)

INSERT INTO analises_analise (CRIADO_EM, ATUALIZADO_EM, EXTERNAL_ID, AVALIACAO_ID)
SELECT CRIADO_EM = GETDATE(), ATUALIZADO_EM = GETDATE(), EXTERNAL_ID = AVA.id_avaliacao, AVALIACAO_ID = AVAX.ID 
  from avaliacao_2020..TbAnalise ana join avaliacao_2020..TbAnalise_Aplicacao  tap on (tap.id_analise = ana.id_analise) 
                                     join avaliacao_2020..TbAvaliacaoAplicacao apl on (apl.id_avaliacao_aplicacao = tap.id_avaliacao_aplicacao)            
									 join avaliacao_2020..TbAvaliacao          ava on (ava.id_avaliacao = apl.id_avaliacao and 
									                                                   ava.id_instituicao = apl.id_instituicao)
									 JOIN avaliacoes_avaliacao                AVAX ON (AVAX.NOME = ava.ds_avaliacao AND 
									                                                   AVAX.valor = AVA.nota AND 
																					   AVAX.instrucoes = AVA.instrucoes)
where apl.id_instituicao = 15
-- SELECT * FROM analises_analise

-------------------------------------------------------------------------------------------
-- ***** insert aplicacao *******  
--  delete from aplicacoes_aplicacao     DBCC CHECKIDENT('aplicacoes_aplicacao', RESEED, 0)
			
INSERT INTO aplicacoes_aplicacao (criado_em, atualizado_em, atualizado_por, criado_por, NOME, data,
            duracao, numero_candidatos, avaliacao_id, CURSO_ID, DISCIPLINA_ID, INSTITUICAO_ID, PERIODO_ID, STATUS_ID)
select distinct criado_em = getdate(), atualizado_em = getdate(), atualizado_pOR = 3, criado_por =  3, 
                NOME = ISNULL(apl.ds_aplicacao,'*** SEM NOME *** AVA-' + CONVERT(VARCHAR(10),avax.id)), data = apl.dt_aplicacao, 
				duracao = apl.duracao, numero_candidatos = apl.nr_respondentes,	avaliacao_id = avax.id, CURSO_ID = CURX.ID, 
				DISCIPLINA_ID = DISX.ID, INSTITUICAO_ID = INSX.ID, PERIODO_ID = PERX.id, STATUS_ID = APL.id_status

from avaliacao_2020..TbAnalise_Aplicacao tap join avaliacao_2020..TbAvaliacaoAplicacao apl on (apl.id_avaliacao_aplicacao = tap.id_avaliacao_aplicacao)                                                       
									         join avaliacao_2020..TbAvaliacao          ava on (ava.id_avaliacao = apl.id_avaliacao and 
									                                                           ava.id_instituicao = apl.id_instituicao)
											 join avaliacao_2020..TbCurso              cur on (cur.id_curso = apl.id_curso)
											 JOIN AVALIACAO_2020..TbDisciplina         DIS ON (DIS.id_disciplina = APL.id_disciplina)
											 JOIN AVALIACAO_2020..TbInstituicao        INS ON (INS.id_instituicao = APL.id_instituicao)
											 JOIN AVALIACAO_2020..TBPERIODO            PER ON (PER.id_periodo = APL.id_periodo)
											 JOIN core_periodo                        PERX ON (PERX.descricao = PER.ds_periodo)
											 JOIN core_instituicao                    INSX ON (INSX.descricao = INS.ds_instituicao)  
											 join core_curso                          CURX ON (CURX.descricao = CUR.ds_curso)
											 JOIN core_disciplina                     DISX ON (DISX.DESCRICAO = DIS.DS_DISCIPLINA)
									         JOIN avaliacoes_avaliacao                AVAX ON (AVAX.NOME = ava.ds_avaliacao AND 
									                                                           AVAX.valor = AVA.nota AND 
									         												   AVAX.instrucoes = AVA.instrucoes)
where apl.id_instituicao = 15 
-- SELECT DISTINCT * FROM aplicacoes_aplicacao

-------------------------------------------------------------------------------------------
-- ***** insert analiseaplicacao *******  
--  delete from analises_analiseaplicacao     DBCC CHECKIDENT('analises_analiseaplicacao', RESEED, 0)

--  INSERT INTO analises_analiseaplicacao (CRIADO_EM, ATUALIZADO_EM, BASE, ANALISE_ID, APLICACAO_ID)
select distinct criado_em = getdate(), atualizado_em = getdate(), base = tap.bl_aplicacao_base,  
                analise_id = ANAX.ID, aplicacao_id = APLX.id
  from avaliacao_2020..TbAnalise_Aplicacao tap join avaliacao_2020..TbAvaliacaoAplicacao apl on (apl.id_avaliacao_aplicacao = tap.id_avaliacao_aplicacao)                                                       
									         join avaliacao_2020..TbAvaliacao          ava on (ava.id_avaliacao = apl.id_avaliacao and 
									                                                           ava.id_instituicao = apl.id_instituicao)
											 join avaliacao_2020..TbCurso              cur on (cur.id_curso = apl.id_curso)
											 JOIN AVALIACAO_2020..TbDisciplina         DIS ON (DIS.id_disciplina = APL.id_disciplina)
											 JOIN AVALIACAO_2020..TbInstituicao        INS ON (INS.id_instituicao = APL.id_instituicao)
											 JOIN AVALIACAO_2020..TBPERIODO            PER ON (PER.id_periodo = APL.id_periodo)
											 JOIN AVALIACAO_2020..TbAnalise            ANA ON (ANA.id_analise = TAP.id_analise)
											 JOIN core_periodo                        PERX ON (PERX.descricao = PER.ds_periodo)
											 JOIN core_instituicao                    INSX ON (INSX.descricao = INS.ds_instituicao)  
											 join core_curso                          CURX ON (CURX.descricao = CUR.ds_curso)
											 JOIN core_disciplina                     DISX ON (DISX.DESCRICAO = DIS.DS_DISCIPLINA)
									         JOIN avaliacoes_avaliacao                AVAX ON (AVAX.NOME = ava.ds_avaliacao AND 
									                                                           AVAX.valor = AVA.nota AND 
									         												   AVAX.instrucoes = AVA.instrucoes)
											 join aplicacoes_aplicacao                APLX ON (APLX.NOME = ISNULL(apl.ds_aplicacao,'*** SEM NOME *** AVA-' + CONVERT(VARCHAR(10),avax.id)))
											 JOIN analises_analise                    ANAX ON (ANAX.external_id = ANA.id_analise)
where apl.id_instituicao = 15 
-- SELECT * FROM analises_analiseaplicacao



select distinct 
      cur.id as curso_id, cur.descricao as curso_nome, 
      dis.id as disciplina_id, dis.descricao as disciplina_nome, 
	  ite.id as item_id, -- ite.situacao_problema, ite.comando_resposta,
	  alt.id as alternativa_id, alt.descricao as alternativa_descricao, alt.posicao, alt.gabarito 
  from 
      itens_item ite join itens_alternativa alt on (ite.id = alt.item_id)
                     join itens_tipo        tip on (tip.id = ite.tipo_id)
					 join core_disciplina   dis on (dis.id = ite.disciplina_id)
					 join core_curso        cur on (cur.id = ite.curso_id)



SELECT * 
  FROM analises_analise ANA JOIN analises_analiseaplicacao ANP ON (ANA.id = ANP.analise_id)
                            JOIN aplicacoes_aplicacao      APL ON (APL.ID = ANP.aplicacao_id)
							JOIN avaliacoes_avaliacao      AVA ON (AVA.ID = ANA.avaliacao_id)
