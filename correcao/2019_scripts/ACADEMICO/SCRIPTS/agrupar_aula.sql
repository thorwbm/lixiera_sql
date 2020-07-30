with cte_professor_turma_data as (
		select CAST(data_inicio as date) as dt_ini, turma_disciplina_id, professor_id, id as aula_id
		  from academico_aula with(nolock)
		 group by CAST(data_inicio as date), turma_disciplina_id, professor_id, id
)

	,cte_prof_tur_dat_ant as (
		select ptd.*, aul.data_inicio, aul.data_termino, 
		       data_termino_anterior = (select top 1 aulx.data_termino 
	                                      from academico_aula aulx
	                                     where CAST(aulx.data_inicio as date) = ptd.dt_ini and 
										       aulx.professor_id = ptd.professor_id and 
											   aulx.turma_disciplina_id = ptd.turma_disciplina_id and
											   aulx.data_inicio < aul.data_inicio order by aulx.data_termino desc)
		  from cte_professor_turma_data ptd with(nolock) join academico_aula aul  with(nolock) on (ptd.aula_id = aul.id )
	)
	    -- drop table #temp 
		select * , case when data_termino_anterior is null then 'inicio'
		                when DATEDIFF(minute,  data_termino_anterior, data_inicio)> 50 then 'inicio' else 'agrupar' end as tipo, grupo = 0
						into #temp
		  from cte_prof_tur_dat_ant
		 -- where dt_ini = '2019-04-15'
		        --professor_id = 5533 and   
				--turma_disciplina_id = 3770 
			--and	case when data_termino_anterior is null then 0 else DATEDIFF(minute,  data_termino_anterior, data_inicio)end > 50
				order by turma_disciplina_id, professor_id,  data_inicio
		     

	
	declare @cont int, @aula_id int, @tipo varchar(50), @professor_id int, @turma_disciplina_id int
	set @cont = 0
	declare abc cursor for 
	select aula_id, tipo, turma_disciplina_id, professor_id from #temp order by turma_disciplina_id, professor_id, aula_id
	open abc 
		fetch next from abc into @aula_id, @tipo, @turma_disciplina_id, @professor_id
		while @@FETCH_STATUS = 0
			BEGIN
				if(@tipo = 'inicio')
					begin
						set @cont = @cont + 1						
					end
				update #temp set grupo = @cont where aula_id = @aula_id
			fetch next from abc into @aula_id, @tipo, @turma_disciplina_id, @professor_id
			END
	close abc 
deallocate abc 

select * from #temp order by  grupo, aula_id


select * from academico_aula where grupo_id = (select grupo_id from academico_aula where id = 146177)