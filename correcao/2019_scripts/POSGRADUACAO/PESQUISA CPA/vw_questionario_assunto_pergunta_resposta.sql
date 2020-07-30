create view vw_questionario_assunto_pergunta_resposta as 
select que.id as questionario_id, que.nome as questionario_nome, 
       ass.id as assunto_id, ass.nome as assunto_nome, ass.posicao as assunto_posicao, 
	   per.id as pergunta_id, per.nome as pergunta_nome, per.posicao as pergunta_posicao,
	   tpp.id as tipoPergunta_id, tpp.nome as tipoPergunta_nome, 
	   alt.id as resposta_id, alt.nome as resposta_nome, alt.valor as resposta_valor, alt.posicao as resposta_posicao
  from Questionario que join Assunto      ass on (que.id = ass.questionarioId)
                        join Pergunta     per on (ass.id = per.assuntoId)
						join TipoPergunta tpp on (tpp.id = per.tipoPerguntaId)
				   left join Alternativa  alt on (per.id = alt.perguntaId)



select distinct questionario_nome, assunto_nome, pergunta_nome, resposta_nome
from vw_questionario_assunto_pergunta_resposta
where questionario_id = 4