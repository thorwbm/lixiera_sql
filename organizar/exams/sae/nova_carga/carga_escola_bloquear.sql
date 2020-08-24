--select * from sys.tables where name like 'bloque%'
--  drop table tmp_imp_bloquear
select [Nome da Escola:] as nome_escola_ava,
       [Simulado Bimestral] as simulado_bimestral, 
	   [Janela de Aplicação] as janela_aplicacao
	
	   into tmp_imp_bloquear
from (
select *              from bloquear_1serie         union 
select *              from bloquear_2serie		union 
select *              from bloquear_3serie		union 
select *              from bloquear_4ano      union 
select *              from bloquear_5ano	union 
select *              from bloquear_6ano	union 
select *              from bloquear_7ano	union 
select *              from bloquear_8ano	union 
select *              from bloquear_9ano     ) as tab	


