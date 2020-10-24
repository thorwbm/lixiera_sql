 

--   insert into avaliacoes_avaliacao (criado_em,	atualizado_em,	nome,	valor,	versao,	instrucoes,	atualizado_por_id,	criado_por_id,	exame_id)
select criado_em =getdate(),	atualizado_em=getdate(),	nome = nome + ' - 2',	valor,	versao,	instrucoes,	atualizado_por_id,	criado_por_id,	exame_id
from avaliacoes_avaliacao  
where id = 9

-- insert into avaliacoes_avaliacaoitem (criado_em, atualizado_em,	posicao, valor,	avaliacao_id, item_id)
select criado_em =getdate(), atualizado_em =getdate(),	posicao,	valor,	avaliacao_id = 20,	item_id 
from avaliacoes_avaliacaoitem
where avaliacao_id = 9



Exame de Suficiência para Obtenção do Certificado de Área de Atuação em ANGIORRADIOLOGIA E CIRURGIA ENDOVASCULAR - SBACV/2020 - PROVA TEÓRICA - 1
select * from core_exame where id = 5