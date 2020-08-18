WITH cte_ano AS (
SELECT DISTINCT  ee.*,    hir.name AS grade, hir.[value] AS grade_id
FROM exam_exam ee JOIN hierarchy_hierarchy hir ON (ltrim(hir.name) = ltrim(left(ee.name, PATINDEX('%ano %', ee.name)+3 )) AND 
                                                   hir.type ='grade')
WHERE ee.name LIKE '%ano%BI/2020%'
),
	cte_serie AS (
SELECT DISTINCT  ee.*,   hir.name AS grade, hir.[value] AS grade_id
FROM exam_exam ee JOIN hierarchy_hierarchy hir ON (ltrim(hir.name) = ltrim(left(ee.name, PATINDEX('%série %', ee.name)+5 )) AND 
                                                   hir.type ='grade')
WHERE ee.name LIKE '%série%BI/2020%'
),

cte_uniao as (
SELECT id, grade, grade_id, ltrim(rtrim(replace(replace(name,grade,''),' - 2º BI/2020',''))) as disciplina FROM cte_ano UNION 
SELECT id, grade, grade_id, ltrim(rtrim(replace(replace(name,grade,''),' - 2º BI/2020',''))) AS disciplina FROM cte_serie )


SELECT '{"provider": {"label": "SAE", "value": "SAE"}, "discipline": {"name": "' + uni.disciplina + '", "value": 999999}, "grade": {"name": "' +uni.grade + '", "value": "' + uni.grade_id+ '"}}'   , * 
-- UPDATE  ee SET ee.extra = '{"provider": {"label": "SAE", "value": "SAE"}, "discipline": {"name": "' + uni.disciplina + '", "value": 999999}, "grade": {"name": "' +uni.grade + '", "value": "' + uni.grade_id+ '"}}'   
FROM exam_exam ee JOIN cte_uniao uni ON (ee.id = uni.id)
WHERE ee.name LIKE '%BI/2020%'


commit