select escola_nome, prova_nome, grade_nome, count(distinct usuario_id) as qtd_alunos 
from VW_AGENDAMENTO_PROVA_ALUNO
where PROVA_NOME like 'Desafio SAE Teens 3°BI%'
group by prova_nome, escola_nome, grade_nome
order by  escola_nome, grade_nome