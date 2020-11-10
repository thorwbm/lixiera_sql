--SELECT * FROM TMP_IMP_COORDENADOR_4BI   -- 2895
declare @json varchar(max) = ' {"hierarchy":{"unity": {"name": null, "value": null}}}'
select distinct
       password = 'pbkdf2_sha256$180000$LmA3RFL35Vi6$6HIUlKjmZWX0aTbZq0RxFTh3IWdWBYlecPANz6mfj8o=',
       is_superuser = 0,
       username = tmp.login,
       is_staff = 0,
       is_active = 1,
       date_joined = GETDATE(),
       name = TMP.usuarionome,
       public_identifier = tmp.usuarioid,
	  --  hie.name as escola,
	 --  EXTRA = JSON_MODIFY( JSON_MODIFY(@json, '$.hierarchy.unity.name', hie.name), '$.hierarchy.unity.value', hie.value),  
       provider_id = 1,
       created_at = GETDATE(),
       updated_at = GETDATE(),
       first_name = LEFT(CASE WHEN charindex(' ',TMP.usuarionome) > 0 THEN left (TMP.usuarionome,  charindex(' ',TMP.usuarionome)-1)
                                                             ELSE TMP.usuarionome END,30),
       last_name = TMP.usuarionome,
       email = ''
	   --select distinct tmp.*
	 
  from TMP_IMP_COORDENADOR_4BI  TMP  JOIN hierarchy_hierarchy HIE ON (HIE.value = TMP.escolaid and
                                                                      hie.name = tmp.EscolaNome)
                              
  where hie.id is null 
  order by 3


                               left join auth_user xxx on (tmp.usuarioId = xxx.public_identifier)
 where xxx.id is null AND TMP.USUARIONOME IS NOT NULL 



 select * from vw_hierarquia_exam where escola_nome = 'COLEGIO CALIFORNIA'


 select * from vw_coordenador

 {"hierarchy":{"unity": {"name": null, "value": null}}}


 select distinct escolaid, escolanome from tmp_imp_coordenador_4bi where usuarioid in (
 select distinct public_identifier from #temp_maior 
 group by public_identifier
 having count(1)>1) 
order by 2 


select value, name from hierarchy_hierarchy 
where value in (
'1e7955dece8fa86b4a718b93e3e3b5cc',
'2ee7630de6ea23d02ea370a659efb037',
'41f8ae1755363221e6769793682738a7',
'6065508295d47b1eb78bbc1298965aa0',
'fe004bac0de7196e25924908ec992c4d')
order by 2



select *
-- delete 
from hierarchy_hierarchy where value = '1e7955dece8fa86b4a718b93e3e3b5cc'  and id = 35512


select * --  delete
from hierarchy_hierarchy where parent_id =22871   35512

select *-- delete 
from hierarchy_hierarchy where parent_id in (22872, 35720)