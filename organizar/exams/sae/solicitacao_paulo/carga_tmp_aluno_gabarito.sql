select application_id , ans.position, alt.letter
into tmp_resposta_aluno
from application_answer ans join item_alternative alt on (alt.id = ans.alternative_id)
order by 1

select top 100 * from  tmp_resposta_aluno
select top 100 * from tmp_aluno_gabarito