SELECT DISCIPLINA_NOME, NEWID() AS CODIGO INTO DISCIPLINA_AUXILIAR FROM (
SELECT DISTINCT LTRIM(RTRIM(REVERSE(LEFT(REVERSE (NAME), CHARINDEX('-',REVERSE (NAME)) -1)))) AS DISCIPLINA_NOME
  FROM exam_EXAM EXA
  WHERE ID <= 155) AS TAB

  ------------------------------------------------------------------------------
DECLARE @JSON VARCHAR(MAX) = '{"provider": {"label": "SAE", "value": "SAE"}, "discipline": {"name": "<nome>", "value": "99999"}, "grade": {"name": "<nome>", "value": 99999}}'

--SELECT EXA.NAME, DIS.DISCIPLINA_NOME,dis.codigo, EXTRA , JSON_MODIFY(JSON_MODIFY(@JSON, '$.discipline.name',dis.disciplina_nome), '$.discipline.value',cast(dis.codigo as varchar(100)))
-- select *
  --update exa set exa.extra = JSON_MODIFY(JSON_MODIFY(@JSON, '$.discipline.name',dis.disciplina_nome), '$.discipline.value',cast(dis.codigo as varchar(100)))
FROM exam_EXAM EXA JOIN DISCIPLINA_AUXILIAR DIS ON (EXA.NAME LIKE '%' + DIS.DISCIPLINA_NOME + '%')
where extra is null
----------------------------------------------------------------------------------

select  exa.name, exa.extra, JSON_MODIFY(JSON_MODIFY(exa.extra, '$.grade.name', hie.NOME), '$.grade.value', hie.CODIGO)

--update exa set exa.extra =  JSON_MODIFY(JSON_MODIFY(exa.extra, '$.grade.name', hie.NOME), '$.grade.value', hie.CODIGO)
from exam_exam exa join VW_HIERARQUIA hie on (exa.name like '%' + hie.NOME + '%' and tipo = 'grade')
where hie.NOME <> '' and 
      json_value(exa.extra, '$.grade.name')  = '<nome>'
