
select * DELETE from academico_turmadisciplinaaluno where id in (
select distinct TURMA_DISCIPLINA_ALUNO_ID
from vw_curriculo_curso_turma_disciplina_aluno_grade
where --aluno_nome = 'ADRIANO LOURENÇONI FREITAS' and
      status_mat_dis_id = 14 and 
	  tda_curriculo_aluno_id in (36678))
	  



select distinct aluno_nome, tda_curriculo_aluno_id, turma_nome, disciplina_nome
--  select distinct aluno_nome, tda_curriculo_aluno_id, turma_nome
from vw_curriculo_curso_turma_disciplina_aluno_grade
where 
      status_mat_dis_id = 14 and 
	  tda_curriculo_aluno_id in (36678, 36873, 37136)
order by 1, 4
	  
	  
	  select distinct aluno_nome, tda_curriculo_aluno_id, turma_nome, curriculo_nome 
	 -- into #temp
	  from vw_curriculo_curso_turma_disciplina_aluno_grade
	  where status_mat_dis_id = 14 and
	        turma_nome like '%t' and
			aluno_nome = 'ÁGATHA MASCARENHAS BAÊTA MORAIS'


      select aluno_nome, COUNT(turma_nome) from #temp group by aluno_nome order by 2 desc, 1




	 exec SP_PRO_CARGA_SUBTURMAS_ALUNO 37136

	exec   SP_PRO_INSERT_DISCIPLINA_ESPECIAL_GENERICO 37136, 'Integração Curricular', 'M072S03A202T'
	
	exec   SP_PRO_INSERT_DISCIPLINA_ESPECIAL_GENERICO 37136, 'Treinamento de Habilidade', null


    