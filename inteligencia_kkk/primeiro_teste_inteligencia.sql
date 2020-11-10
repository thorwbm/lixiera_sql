select * from tmp_item_gabarito

select * into tmp_item_gabarito_aux from tmp_item_gabarito
update  tmp_item_gabarito_aux set referencia = null, value = -1.0, points = -1.0


select * from item_item where id = 404

--   select item_id = 0, resposta = replicate('x',150), texto_comparardo =  replicate('x',150), peso = 0.0 into tmp_inteligencia

select * -- delete 
from  tmp_inteligencia


     
----------------------------------------------------------------------------------------------------
     
with cte_pesos as (
select gab.id, max(peso) as peso

from tmp_item_gabarito_aux gab join tmp_inteligencia tmp on (tmp.item_id = gab.item_id)
where free_response like '%' + texto_comparado + '%' 
group by gab.id
) 

--select *  
 update gab set gab.referencia = itl.texto_comparado, gab.value = 1, gab.points = pes.peso
  from tmp_item_gabarito_aux gab left join cte_pesos pes on (pes.id = gab.id)
                                 left join tmp_inteligencia itl on (itl.peso = pes.peso and 
								                                    itl.item_id = gab.item_id AND
																	GAB.FREE_RESPONSE LIKE '%' + ITL.texto_comparado + '%'   )
where pes.peso is not null  AND 
      GAB.item_id = 405
	  	   
select * 
-- UPDATE AUX SET AUX.REFERENCIA = NULL, AUX.VALUE = -1, AUX.POINTS = -1
from tmp_item_gabarito_aux AUX 
WHERE ITEM_ID = 405 ORDER BY POINTS DESC 

----------------------------------------------------------------------------------------------------



select * from item_item



select ite.id,  dbo.udf_StripHTML(expected_free_response) 
from item_item ite join exam_examitem exi on (ite.id = exi.item_id)
where exi.exam_id = 45 and ite.id = 405


insert into tmp_item_gabarito_aux (item_id,free_response,referencia,value,points)
select distinct ans.item_id, ans.free_response, referencia = null, value = -1, points = -1 
  from application_answer ans join application_application app on (app.id = ans.application_id)
                              join item_item               ite on (ite.id = ans.item_id)
						 left join tmp_item_gabarito_aux   xxx on (xxx.item_id = ite.id and ans.free_response = xxx.free_response)
 where xxx.id is null and  
       ans.free_response is not null and 
       app.exam_id = 45 and 
       ite.category = 'FREE_RESPONSE' and 
	   ite.id = 405


	   
