select *  from hierarchy_hierarchy where name = 'COLÉGIO DOM BOSCO (BALSAS)'
and value <> '9618df4005ddc7d05a384b22553fd393'

select * from vw_hierarquia_tab_usuario
where escola_nome ='COLÉGIO DOM BOSCO (BALSAS)' and
      escola_id <>  '9618df4005ddc7d05a384b22553fd393'



select * from vw_hierarquia_tab_usuario 
where grade_id in (select value from hierarchy_hierarchy where parent_id in (14808, 35505))

-------------------------------------------------------
select * --delete 
from hierarchy_hierarchy 
where type = 'class' and parent_id in (22842, 22959, 23434, 23581, 26970, 26983, 
                                       35443, 35929, 35932, 35934, 35936, 35938, 35944)

-------------------------------------------------------
select * -- delete 
from hierarchy_hierarchy where type = 'grade' and parent_id in (14808, 35505)

-------------------------------------------------------
select * -- delete 
from hierarchy_hierarchy where type = 'unity' and name = 'CENTRO DE INTEGRAÇÃO ESCOLAR DOM BOSCO' in (14808, 35505)



select * from auth_user where json_value(extra, '$.hierarchy.unity.name') = 'COLÉGIO DOM BOSCO (BALSAS)'




 --  escola_nome =  'COLÉGIO DOM BOSCO (BALSAS)' and    escola_id = '9618df4005ddc7d05a384b22553fd393'