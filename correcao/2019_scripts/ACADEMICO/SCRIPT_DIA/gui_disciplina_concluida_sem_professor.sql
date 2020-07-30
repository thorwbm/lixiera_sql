If Exists(Select * from Tempdb..SysObjects Where Name Like '#tem_discon%')
       drop table #tem_discon;
with cte_duplicidades as (
		select cra.aluno_id, dis.nome as disciplina_nome, carga_horaria, nota, faltas, frequencia, count(1) as qtd
		from curriculos_disciplinaconcluida crdc join curriculos_aluno cra on (cra.id = crdc.curriculo_aluno_id)
		                                         join academico_disciplina dis on (dis.id = crdc.disciplina_id)
		where cra.aluno_id = 45296
		group by cra.aluno_id, dis.nome, carga_horaria, nota, faltas, frequencia
		having count(1)> 1
) 
	, cte_sem_pofessor as (
		select cte.* from cte_duplicidades cte join curriculos_aluno cra on (cte.aluno_id = cra.aluno_id) 
										   join curriculos_disciplinaconcluida con on (cra.id = con.curriculo_aluno_id)
		                                   join academico_disciplina           dis on (dis.id = con.disciplina_id and 
										                                               cte.disciplina_nome = dis.nome)
		where professor_id is null 
)

	

		select cte.aluno_id, cte.disciplina_nome, 
		       con.id as disciplinaconcluida_id_com, con.professor_id as professor_id_com, con.titulacao_id as titulacao_id_con,
			   sem.id as disciplinaconcluida_id_sem, sem.professor_id as professor_id_sem, sem.titulacao_id as titulacao_id_sem
			     into #tem_discon
		         from cte_sem_pofessor cte join curriculos_aluno cra on (cte.aluno_id = cra.aluno_id) 
										   join curriculos_disciplinaconcluida con on (cra.id = con.curriculo_aluno_id)
		                                   join academico_disciplina           disc on (disc.id = con.disciplina_id and 
										                                               cte.disciplina_nome = disc.nome)
									       join curriculos_aluno               crax on (cte.aluno_id = crax.aluno_id)
										   join curriculos_disciplinaconcluida sem on (crax.id = sem.curriculo_aluno_id)
		                                   join academico_disciplina           diss on (diss.id = con.disciplina_id and 
										                                               cte.disciplina_nome = diss.nome)
		where con.professor_id is not null and
		    --  cte.disciplina_id = 3882 and 
		      sem.professor_id is null
order by 1,2


begin tran

declare @discon_id int, @atual_pro int, @novo_pro int, @atual_tit int, @novo_tit int, @aux varchar(max)

declare CUR_DISCON cursor for 
	SELECT disciplinaconcluida_id_sem, professor_id_sem, titulacao_id_sem, professor_id_com, titulacao_id_con FROM #tem_discon
	open CUR_DISCON 
		fetch next from CUR_DISCON into @discon_id, @atual_pro, @atual_tit, @novo_pro, @novo_tit
		while @@FETCH_STATUS = 0
			BEGIN
				SET @AUX = ( 'professor_id;' + isnull(CONVERT(VARCHAR(10),@atual_pro),'null') + ';'+ isnull(CONVERT(VARCHAR(10),@novo_pro),'null') + 
				             '|'+ 'titulacao_id;' + isnull(CONVERT(VARCHAR(10),@atual_tit),'null') + ';'+ isnull(CONVERT(VARCHAR(10),@novo_tit),'null')
						   )

				   EXEC SP_GERAR_LOG 'curriculos_disciplinaconcluida', @discon_id, '~', 2137,@AUX, NULL, NULL
				   update cdc set cdc.titulacao_id = tem.titulacao_id_con, cdc.professor_id = tem.professor_id_com
				  from curriculos_disciplinaconcluida cdc join #tem_discon tem on (cdc.id = tem.disciplinaconcluida_id_sem)
				  where cdc.id = @discon_id



			fetch next from CUR_DISCON into @discon_id, @atual_pro, @atual_tit, @novo_pro, @novo_tit
			END
	close CUR_DISCON 
deallocate CUR_DISCON 




select * from LOG_curriculos_disciplinaconcluida order by history_date desc 



/*
-- ####### professores com mais de uma titulacao distinta #######
select top 10 * from curriculos_disciplinaconcluida where professor_id is not null and titulacao_id is null 
select top 10 * from curriculos_disciplinaconcluida where professor_id =5626 and titulacao_id is not null 
select professor_id, count(distinct titulacao_id) 
from curriculos_disciplinaconcluida 
where titulacao_id is not null 
group by professor_id 
having count(distinct titulacao_id)  > 1
order by 2 desc

-- ####### consultas guilherme  #######
select concluida.*
from curriculos_disciplinaconcluida concluida
join curriculos_aluno ca on ca.id = concluida.curriculo_aluno_id
join academico_aluno aluno on aluno.id = ca.aluno_id 
join academico_disciplina disc on disc.id = concluida.disciplina_id
where aluno.nome = 'suellen caroline romulo teixeira'



select concluida.*, aluno.id
from curriculos_disciplinaconcluida concluida
join curriculos_aluno ca on ca.id = concluida.curriculo_aluno_id
join academico_aluno aluno on aluno.id = ca.aluno_id 
join academico_disciplina disc on disc.id = concluida.disciplina_id
where aluno.nome = 'suellen caroline romulo teixeira'
  and disciplina_id = 3882
*/