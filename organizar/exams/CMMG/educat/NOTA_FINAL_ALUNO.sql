select ds_avaliacao, ds_aplicacao, aluno, sum(nota) as nota_aluno, 
       nta.nr_questoes, nta.valor_prova

from vw_resposta_prova_aluno alu join vw_avaliacao_questoes_nota nta on (alu.avaliacao_id = nta.id_avaliacao)
where --aluno = 'VITOR BARROS LOUREIRO'
 avaliacao_id = 381
group by ds_avaliacao, ds_aplicacao, aluno,nta.nr_questoes, nta.valor_prova


