with cte_duplicidade_criterios as (
		select turma_disciplina_id, criterio_id, count(1) as qtd
		  from atividades_criterio_turmadisciplina
		  group by turma_disciplina_id, criterio_id
		  having count(1) > 1
)

	, cte_duplicidade as (
   select atc.id as atividadeCriterioTurmaDisciplina_id , cte.criterio_id, tds.id as turmadisciplina_id, tur.nome as turma_nome,
          dis.nome as disciplina_nome, cri.nome as criterio_nome
     from cte_duplicidade_criterios cte join academico_turmadisciplina tds on (tds.id = cte.turma_disciplina_id)
                                        join academico_turma           tur on (tur.id = tds.turma_id)
										join atividades_criterio       cri on (cri.id = cte.criterio_id)
										join academico_disciplina      dis on (dis.id = tds.disciplina_id) 
										join atividades_criterio_turmadisciplina atc on (tds.id = atc.turma_disciplina_id and 
										                                                 cri.id = atc.criterio_id         )
)



 select distinct dup.*, vw.COM_NOTA, vw.ATIVIDADE_DATA, vw.ATIVIDADE_DATA_DIVULGACAO, vw.STATUS_ATIVIDADE_NOME

   from cte_duplicidade dup join atividades_atividade       atv on (atv.criterio_turma_disciplina_id = dup.atividadeCriterioTurmaDisciplina_id)
                            join vw_atividade_quantidades_com_sem_nota vw on (atv.criterio_turma_disciplina_id =  vw.criterio_turma_disciplina_id)
                       left join atividades_atividade_aluno alu on (atv.id = alu.atividade_id)
  -- where turma_nome = '1MC1º2019-1' and disciplina_nome = 'ANATOMIA HUMANA I'
 --and alu.id is null	
 --where com_nota = 0
order by 4,5,6,1

/*
select * from #tmp
-- exec sp_deletar_criterioTurmaDisciplina_sem_atividade 4526, 2136

declare @criterio_turmadisciplina_id int 
declare abc cursor for 
	SELECT atividadeCriterioTurmaDisciplina_id FROM #tmp 
	open abc 
		fetch next from abc into @criterio_turmadisciplina_id
		while @@FETCH_STATUS = 0
			BEGIN
				exec sp_deletar_criterioTurmaDisciplina_sem_atividade 4313, 2136


			fetch next from abc into @criterio_turmadisciplina_id
			END
	close abc 
deallocate abc 

-- ***** EXCLUIR ATIVIDADE_ALUNO PARA PODER EXCLUIR O CRITERIO *******
select * from atividades_atividade where criterio_turma_disciplina_id = 4313

begin tran 
exec sp_gerar_log_atividades_atividade_aluno null, null, null, '-', 2136, 72079
delete  from atividades_atividade_aluno where atividade_id = 3958

-- commit 
-- rollback
*/
