--  select name from auth_user where name like '%xavier%' order by name 

select usu.name,exa.name, app.id
from auth_user usu left join application_application app on (usu.id = app.user_id)
                   left join exam_exam exa on (exa.id = app.exam_id)
where usu.name = 'LUIZ HENRIQUE NUNES'

--###############################################################
-- 'LUIZ HENRIQUE NUNES'
select * 
-- begin tran delete 
from application_answer where application_id in (1216)

select *
-- begin tran delete 
from application_application where id in (1216)
-- commit 
-- rollback
-- ##############################################################

--###############################################################
-- 'CARLA CRISTINA RIBEIRO ORNELAS'
select * 
-- begin tran delete 
from application_answer where application_id in (1192)

select *
-- begin tran delete 
from application_application where id in (1192)
-- commit 
-- rollback
-- ##############################################################

--###############################################################
-- 'JESSICA RIBEIRO DE ALMEIDA XAVIER'
select * 
-- begin tran delete 
from application_answer where application_id in (1275)

select *
-- begin tran delete 
from application_application where id in (1275)
-- commit 
-- rollback
-- ##############################################################

--###############################################################
-- 'LARISSA LEMOS GONÇALVES DO AMARAL'
select * 
-- begin tran delete 
from application_answer where application_id in (1153,1211)

select *
-- begin tran delete 
from application_application where id in (1153,1211)
-- commit 
-- rollback
-- ##############################################################

--###############################################################
-- 'NATALIA LUIZA MENDES SILVA'
select * 
-- begin tran delete 
from application_answer where application_id in (1237,1271)

select *
-- begin tran delete 
from application_application where id in (1237,1271)
-- commit 
-- rollback
-- ##############################################################

--###############################################################
-- 'MARIANA VALERIO SOLANO'
select * 
-- begin tran delete 
from application_answer where application_id in (1219, 2044, 2275)

select *
-- begin tran delete 
from application_application where id in (1219, 2044, 2275)
-- commit 
-- rollback
-- ##############################################################