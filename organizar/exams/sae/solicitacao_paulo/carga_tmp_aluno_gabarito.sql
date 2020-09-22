select application_id , ans.position, alt.letter
into tmp_resposta_aluno
from application_answer ans join item_alternative alt on (alt.id = ans.alternative_id)
order by 1