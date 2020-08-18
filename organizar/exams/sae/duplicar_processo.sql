

-- #########################################################################################################################
-- carga na collection

-- insert into exam_collection (created_at, updated_at, name, start_time, end_time, max_duration, share_timeouts, instructions,can_disclose_report)
select distinct 
       created_at = getdate(), updated_at = getdate(), name = 'Avaliação ' + exa.name, exa.start_time, exa.end_time, 
       exa.max_duration, exa.share_timeouts, exa.instructions, EXA.can_disclose_report
from exam_collection  exa left join exam_collection xxx on (xxx.name = 'Avaliação ' + exa.name)
where xxx.id is null  and 
      cast(exa.created_at as date) = '2020-04-21'

-- #########################################################################################################################
-- carga na exam
 --  insert into exam_exam (name, shuffle_items, extra, external_id, instructions, created_at, updated_at, collection_id, can_update_answer)
   select distinct    
          name = 'Avaliação ' + ori.name, ori.shuffle_items, ori.extra, ori.external_id, ori.instructions, 
          created_at = getdate(), 
          updated_at = getdate(), 
          collection_id = dst.id, ORI.can_update_answer
     from exam_exam ori join exam_collection cri on (cri.id = ori.collection_id)
                        join exam_collection dst on (dst.name = 'Avaliação ' + cri.name)
                   left join exam_exam       xxx on (xxx.name = 'Avaliação ' + ori.name)
    where cast(cri.created_at as date) = '2020-04-21' and 
          xxx.id is null 
    order by 1

-- #########################################################################################################################
-- carga exame item

-- insert into exam_examitem (position, exam_id, item_id, created_at, updated_at, value)
   select distinct 
          position   = exi.position, 
          exam_id    = dst.id, 
          item_id    = exi.item_id, 
          created_at = getdate(), 
          updated_at = getdate(), 
          value      = exi.value
   from exam_examitem exi join exam_exam     ori on (ori.id = exi.exam_id)
                          join exam_exam     dst on (dst.name = 'Avaliação ' + ori.name)
                     left join exam_examitem xxx on (xxx.exam_id = dst.id and 
                                                     xxx.item_id = exi.item_id)
  where xxx.id is null 

-- #########################################################################################################################



