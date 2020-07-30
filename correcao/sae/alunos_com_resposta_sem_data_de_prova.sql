select distinct escola_nome, curso_nome, usuario_nome, prova_grade_nome
from vw_analitico_processo 
where prova_inicio is null and reposta_marcada is not null 
order by escola_nome, curso_nome, usuario_nome, prova_grade_nome

