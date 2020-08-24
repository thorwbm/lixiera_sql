select * from sys.tables where name like 'escola_2dia%'

select [Nome da escola AVA] as nome_escola_ava,
       [Avaliação Diagnostica] as avaliacao_diagnostica, 
	   [Janela de Aplicação] as janela_aplicacao, 
	   [Dia aplicação] as dia_aplicacao, 
	   [Língua Estrangeira Inglês] as lingua_ingles, 
	   [Língua Estrangeira Espenhol] as lingua_espanhol

into tmp_imp_escola_2dia
from (
select * from escola_2dia_1serie            union 
select * from escola_2dia_2serie			union 
select * from escola_2dia_3serie			union 
select * , null, null from escola_2dia_4ano	union 
select * , null, null from escola_2dia_5sno				union 
select * , null, null from escola_2dia_6ano				union 
select * , null, null  from escola_2dia_7ano				union 
select * , null, null from escola_2dia_8ano				union 
select * , null, null from escola_2dia_9ano		) as tab		 