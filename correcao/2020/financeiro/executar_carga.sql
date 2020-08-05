

drop table #temp_importacao
select distinct curriculo_aluno_id, aluno_nome, aluno_ra-- into #temp_importacao  
from vw_Curriculo_aluno_pessoa
where curriculo_aluno_status_id = 13 and 
      curso_nome <> 'CURSO DE TUTORIA' and 
	  aluno_ra in (
select student_id  collate database_default from mat_prd..onboarding_enrollment e
                    join mat_prd..onboarding_onboarding o
                        on e.onboarding_id = o.id
                    join mat_prd..onboarding_termyear t
                        on t.id = o.term_year_id
                    where t.[current] = 1 and status_id = 6) 
					order by 2


declare @curriculo_aluno_id int 

declare CUR_ cursor for 
	select curriculo_aluno_id from #temp_importacao 
	open CUR_ 
		fetch next from CUR_ into @curriculo_aluno_id
		while @@FETCH_STATUS = 0
			BEGIN
				 exec SP_FNC_CARGA_MATRICULA_REMATRICULA_ALUNO @curriculo_aluno_id, 2137


			fetch next from CUR_ into @curriculo_aluno_id
			END
	close CUR_ 
deallocate CUR_ 