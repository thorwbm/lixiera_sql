with cte_qtd_por_turma as (
	  select curriculo_id, curriculo_nome, grade_id , grade_nome, COUNT(distinct tda_curriculo_aluno_id) as qtd_matriculados
	  from vw_curriculo_curso_turma_disciplina_aluno_grade dag	                                 
	  where status_mat_dis_id = 14
	  group by curriculo_id, curriculo_nome, grade_id, grade_nome
)

 select * 
 from  VW_ACD_ALUNOS_MATRICULADOS_POR_TURMA_DISCIPLINA ptd join cte_qtd_por_turma qtd on (ptd.curriculo_id = qtd.curriculo_id )
	where qtd.CURRICULO_NOME = 'PSICOLOGIA 2016/10-1' and
          ptd.DISCIPLINA_NOME = 'ESTÁGIO SUPERVISIONADO IX - b'