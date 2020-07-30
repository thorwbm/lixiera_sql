SELECT * FROM correcoes_REDACAO WHERE id_status = 3

select * from correcoes_pendenteanalise where            redacao_id = 341038 
select * from correcoes_redacao where                                              id = 341038 
select id_tipo_correcao,* from correcoes_correcao where                    redacao_id = 341038 order by 1
select id_tipo_correcao_B,conclusao_analise,* from correcoes_analise where redacao_id = 341038 order by 1

 select * 
 --  delete 
 from correcoes_fila3 where redacao_id = 341038

 select id, * from correcoes_analise where redacao_id = 341038 order by 1
 -- exec SP_RECALCULA_ANALISE 670359, 4




select * 
--   delete 
from correcoes_analise where redacao_id = 466834 and id in (649065,649066)

-- exec SP_RECALCULA_ANALISE 466834, 4
select top 10  * from correcoes_pendenteanalise 
-- insert into correcoes_pendenteanalise
select null, id, id_projeto, co_barra_redacao,id_tipo_correcao, redacao_id, dbo.getlocaldate()
 from correcoes_correcao  where redacao_id = 466834 and id_tipo_correcao = 3


 select * from correcoes_redacao 
 --  update correcoes_redacao set id_status = 2  where id = 466834
 where id = 466834

