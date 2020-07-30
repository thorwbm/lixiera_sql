--begin tran insert into application_application (exam_id, user_id, should_update_answers, created_at, updated_at)
select distinct exam_id = e.id, user_id = u.id, should_update_answers = 0, created_at = GETDATE(), 
updated_at = GETDATE()--,JSON_VALUE(u.extra, '$.hierarchy.grade.value') , u.name
--INTO tmpimp_inserir_application
from auth_user u
    join exam_exam e on case when JSON_VALUE(u.extra, '$.hierarchy.grade.value') = '01E01411-D828-4F80-8264-B7587B1F4987' THEN 'EC369C51-44F6-4B5D-8E5D-2B3927C38B2F' ELSE JSON_VALUE(u.extra, '$.hierarchy.grade.value') end
	=  JSON_VALUE(e.extra, '$.grade.value')
	LEFT JOIN application_application XXX ON (XXX.exam_id =  e.id AND XXX.user_id = u.id )
	
    where XXX.ID IS NULL  AND 	      
	      u.provider_id = 1  AND  e.name like '%2º BI%' AND
	     not  EXISTS (SELECT 1 FROM  temp_bloqueados blo JOIN vw_turma_escola_grade vteg ON (blo.escola = vteg.escola_nome AND blo.simulado = vteg.grade_nome) 
		               WHERE vteg.grade_id = case when JSON_VALUE(u.extra, '$.hierarchy.grade.value') = '01E01411-D828-4F80-8264-B7587B1F4987' THEN 'EC369C51-44F6-4B5D-8E5D-2B3927C38B2F' ELSE JSON_VALUE(u.extra, '$.hierarchy.grade.value') end
					         and vteg.escola_id = JSON_VALUE(u.extra, '$.hierarchy.unity.value'))
	ORDER BY user_id


SELECT * FROM vw_turma_escola_grade
	-- commit 
	-- rollback


--  begin tran      insert into application_answer ([position], application_id, item_id, created_at, updated_at, seconds)
select EI.position, application_id = ap.id, EI.item_id, created_at = GETDATE(), updated_at = GETDATE(), seconds = 0
from application_application ap
    join exam_exam e   on ap.exam_id = e.id
    join exam_examitem ei  on ei.exam_id = e.id
	join auth_user au on (au.id = ap.user_id) 
	--JOIN application_answer XXX ON (XXX.application_id = ap.id AND XXX.item_id = EI.item_id AND XXX.position = EI.position)
	where not exists (
		select top 1 1 
			from application_answer app_ans
			where app_ans.item_id = ei.item_id
			and app_ans.application_id = ap.id
		) AND  e.name like '%2º BI%' AND
	     not  EXISTS (SELECT 1 FROM  temp_bloqueados blo JOIN vw_turma_escola_grade vteg ON (blo.escola = vteg.escola_nome AND blo.simulado = vteg.grade_nome) 
		               WHERE vteg.grade_id = case when JSON_VALUE(au.extra, '$.hierarchy.grade.value') = '01E01411-D828-4F80-8264-B7587B1F4987' THEN 'EC369C51-44F6-4B5D-8E5D-2B3927C38B2F' ELSE JSON_VALUE(au.extra, '$.hierarchy.grade.value') end 
					         and vteg.escola_id = JSON_VALUE(au.extra, '$.hierarchy.unity.value'))
    order by e.id, ei.[position]



