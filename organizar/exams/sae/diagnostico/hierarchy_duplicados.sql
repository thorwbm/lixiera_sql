select * from hierarchy_hierarchy 
where name in (
select   name
from hierarchy_hierarchy 
where type = 'unity'
group by name 
having count(value) > 1)  and type = 'unity'


select distinct * from hierarchy_hierarchy 
where name in (
select   name
from hierarchy_hierarchy 
where type = 'class'
group by name 
having count(value) > 1)  and type = 'class'

select * from hierarchy_hierarchy 
where name in (
select   name
from hierarchy_hierarchy 
where type = 'grade'
group by name 
having count(value) > 1)  and type = 'grade'