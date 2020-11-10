-- CORRECAO ESCOLA CORRETOR 
-- ESCOLA BALSAS
SELECT * 
--UPDATE TMP SET TMP.EscolaId = '9618df4005ddc7d05a384b22553fd393'
FROM TMP_IMP_COORDENADOR_4BI TMP WHERE ESCOLAID = 'dae1e5d16ceecbbc14586bb1b8a9b418'

-- CORRECAO ESCOLA ALUNOS 
-- ESCOLA BALSAS
SELECT * 
--UPDATE TMP SET TMP.EscolaId = '9618df4005ddc7d05a384b22553fd393'
FROM TMP_IMP_ALUNOS_4BI TMP WHERE ESCOLAID = 'dae1e5d16ceecbbc14586bb1b8a9b418'

--------------------------------
-- CORRECAO ESCOLA CORRETOR 
-- ESCOLA Escola Santo Anjo
SELECT * 
--UPDATE TMP SET TMP.EscolaId = 'c37583ada557da3fae05eda1f39895cc'
FROM TMP_IMP_COORDENADOR_4BI TMP WHERE ESCOLAID = '6a05926dc211749512f0eb22f2266f18'

-- CORRECAO ESCOLA ALUNOS 
-- ESCOLA Escola Santo Anjo
SELECT * 
--UPDATE TMP SET TMP.EscolaId = 'c37583ada557da3fae05eda1f39895cc'
FROM TMP_IMP_ALUNOS_4BI TMP WHERE ESCOLAID = '6a05926dc211749512f0eb22f2266f18'

------------------------------
-- carga das escolas que nao existem 
insert into hierarchy_hierarchy (type, value, name, parent_id)
  select distinct type = 'unity', value = tmp.EscolaId, name =  tmp.escolanome, parent_id = null 
  from TMP_IMP_COORDENADOR_4BI  TMP left  JOIN hierarchy_hierarchy HIE ON (HIE.value = TMP.escolaid and 
                                                                           hie.type = 'unity')
  where hie.id is null 
  order by 3

insert into hierarchy_hierarchy (type, value, name, parent_id)
  select distinct type = 'unity', value = tmp.EscolaId, name =  tmp.escolanome, parent_id = null 
  from TMP_IMP_ALUNOS_4BI  TMP left  JOIN hierarchy_hierarchy HIE ON (HIE.value = TMP.escolaid and 
                                                                           hie.type = 'unity')
  where hie.id is null 
  order by 3