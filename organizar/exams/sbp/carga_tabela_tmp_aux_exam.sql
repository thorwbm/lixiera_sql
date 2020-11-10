select aux.*, tmp.base, qtd_base into tmp_aux_exam
from vw_exam_sbp_quantidade aux join tmp_aux_exam_exam tmp on (tmp.exam_id = aux.exam_id)
order by 2

  tmp_aux_exam

create or alter view vw_exam_sbp_quantidade as   
select exa.id as exam_id, exa.name as exam_nome,          
       count(app.id) as qtd_inscritos  
from application_application app join exam_exam exa on (exa.id = app.exam_id)  
                                 join auth_user usu on (usu.id = app.user_id)  
                                 join IMP_SBP_CONSOLIDADA con on (con.nome = usu.name )  
         join tmp_aux_exam_exam        aux on (aux.EXAM_ID = exa.id)   
  group by exa.id, exa.name