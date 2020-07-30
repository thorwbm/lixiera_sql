
select * from atividades_complementares_modalidade
where rtrim(ltrim(nome)) in (
select rtrim(ltrim(nome))
from atividades_complementares_modalidade
group by rtrim(ltrim(nome)) 
having count(1) > 1) 

update atividades_complementares_atividade set modalidade_id = 325 where modalidade_id = 367
update historicos_atividadecomplementar    set modalidade_id = 325 where modalidade_id = 367
delete from atividades_complementares_modalidade where id = 367
--------------------------------------------------------------------------------------------

update atividades_complementares_atividade set modalidade_id = 324 where modalidade_id = 368
update historicos_atividadecomplementar    set modalidade_id = 324 where modalidade_id = 368
delete from atividades_complementares_modalidade where id = 368
--------------------------------------------------------------------------------------------

update atividades_complementares_atividade set modalidade_id = 326 where modalidade_id = 366
update historicos_atividadecomplementar    set modalidade_id = 326 where modalidade_id = 366
delete from atividades_complementares_modalidade where id = 366
--------------------------------------------------------------------------------------------

update atividades_complementares_atividade set modalidade_id = 328 where modalidade_id = 344
update historicos_atividadecomplementar    set modalidade_id = 328 where modalidade_id = 344
delete from atividades_complementares_modalidade where id = 344
--------------------------------------------------------------------------------------------

update atividades_complementares_atividade set modalidade_id = 278 where modalidade_id = 329
update historicos_atividadecomplementar    set modalidade_id = 278 where modalidade_id = 329
delete from atividades_complementares_modalidade where id = 329
--------------------------------------------------------------------------------------------

update atividades_complementares_modalidade set nome = rtrim(ltrim(nome)) 



