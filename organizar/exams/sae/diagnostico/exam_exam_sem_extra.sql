select * 
from exam_exam 
where extra is null 
union 
select * 
from exam_exam 
where json_value(extra, '$.discipline.name') is null 

union 
select * 
from exam_exam 
where json_value(extra, '$.grade.name') is null 

select max( len(instructions)) from exam_exam