CREATE OR ALTER VIEW VW_HIERARQUIA AS 
WITH cte_grade AS (
			SELECT distinct TYPE AS TIPO, name AS NOME,  max(value)  AS CODIGO 
			 from hierarchy_hierarchy WHERE type = 'grade'
			 group by name, type
)
	,	cte_turma as (
			SELECT distinct TYPE AS TIPO, name AS Turma_nome, max(value) AS Turma_id
			 from hierarchy_hierarchy WHERE type = 'class' 
			 group by name, type
)
	,	cte_escola as (
			SELECT distinct TYPE AS TIPO, name AS escola_nome, max(value) AS escola_id
			 from hierarchy_hierarchy WHERE type = 'unity' 
			 group by name, type
)

SELECT * FROM CTE_GRADE  UNION
SELECT * FROM CTE_TURMA  UNION 
SELECT * FROM CTE_ESCOLA 