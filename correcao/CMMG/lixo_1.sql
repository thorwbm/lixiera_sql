CREATE or alter VIEW vw_resposta_prova_aluno AS 
SELECT DISTINCT 
       ava.id_avaliacao AS avaliacao_id, ava.ds_avaliacao ,apl.id_avaliacao_aplicacao AS aplicacao_id, apl.ds_aplicacao,
       usu.id, pes.nome AS aluno, avi.posicao, ita.letra_ AS resposta
  FROM TbAvaliacaoRealizacaoResposta res JOIN TbAvaliacaoRealizacao rel ON (res.id_avaliacao_realizacao = rel.id_avaliacao_realizacao)
                                         JOIN tbavaliacaoaplicacao  apl ON (apl.id_avaliacao_aplicacao = rel.id_avaliacao_aplicacao)
                                         JOIN tbusuario             usu ON (usu.id = rel.id_usuario)
                                         JOIN tbpessoafisica        pes ON (pes.id_pessoa_fisica = usu.id_pessoa_fisica)
                                         JOIN tbavaliacao           ava ON (ava.id_avaliacao = apl.id_avaliacao)
                                         JOIN tbitemalternativa     ita ON (ita.id_item_alternativa = res.id_item_alternativa)
                                         JOIN tbavaliacaoitem       avi ON (avi.id_avaliacao_item = res.id_avaliacao_item)
                                         JOIN tbitem                ite ON (ite.id_item = avi.id_item)
 
 
 SELECT * FROM vw_resposta_prova_aluno
 WHERE --aluno = 'victor gomide cabral' AND
       avaliacao_id = 364
 ORDER BY aluno, posicao
 --JSON_VALUE(apl.extra,'$.hierarchy.class.name') =
 

 
 SELECT * FROM TbAvaliacaoRealizacaoResposta
 SELECT * FROM tbassunto


 SELECT * FROM tbavaliacaoitem WHERE id_avaliacao_item = 7548



 SELECT * FROM CMMG_APPLICATION_ANSWER res JOIN cmmg_application_application apl ON (apl.id = res.application_id)
 WHERE res.id  In (65365, 65366, 65367, 65368, 65369, 65370, 65371, 65372, 65373, 65374, 65375, 65376, 65377, 65378, 
 65379, 65380, 65381, 65382, 65383, 65384, 65385, 65386, 65387, 65388, 65389, 65390, 65391, 65392, 65393, 65394)