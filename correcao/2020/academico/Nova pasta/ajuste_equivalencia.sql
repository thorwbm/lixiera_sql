with cte_equiv as (
select grade_disciplina_id as origem, grade_disciplina_equivalente_id as destino
from curriculos_gradedisciplinaequivalente
) 

	,	cte_grade_disc_cur as (
			select distinct gds.id as grade_disciplina_id, crc.id as curriculo_id, crc.nome as curriculo_nome 
			  from curriculos_curriculo crc join curriculos_grade           gra on (crc.id = gra.curriculo_id)
											join curriculos_gradedisciplina gds on (gra.id = gds.grade_id)
)



select * from cte_equiv ida join cte_grade_disc_cur gdc on (gdc.grade_disciplina_id = ida.origem)
                       left join cte_equiv vol on (ida.origem = vol.destino and ida.destino = vol.origem)

where --vol.origem is null and 
      gdc.curriculo_nome like 'medicina%2020%'


select * from vw_gradedisciplinaequivalente
where --vol.origem is null and 
      nome_curriculo like 'medicina%2020%'


	  select * from curriculos_gradedisciplinaequivalente