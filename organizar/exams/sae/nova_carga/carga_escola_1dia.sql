--select * from sys.tables where name like 'escola_1dia%'

select [Nome da escola AVA] as nome_escola_ava,
       [Avaliação Diagnostica] as avaliacao_diagnostica, 
	   [Janela de Aplicação] as janela_aplicacao, 
	   [Dia aplicação] as dia_aplicacao
	   into tmp_imp_escola_1dia
from (
select *              from escola_1dia_1serie         union 
select *              from escola_1dia_2serie		union 
select *              from escola_1dia_3serie		union 
select *              from escola_1dia_4ano        union 
select *              from escola_1dia_5ano		union 
select *              from escola_1dia_6ano		union 
select *              from escola_1dia_7ano		union 
select *              from escola_1dia_8ano		union 
select *              from escola_1dia_9ano) as tab		 










