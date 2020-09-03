select * from auth_user
where extra is null 
union 
select * from auth_user
where json_value(extra, '$.hierarchy.unity.name') is null 
union

select * from auth_user
where json_value(extra, '$.hierarchy.class.name') is null 
union 

select * from auth_user
where json_value(extra, '$.hierarchy.grade.name') is null 
