with cte_aluno_duplicado as (
			select nome
			from academico_aluno
			group by nome
			having count(1) > 1
)	
	,	cte_aluno_problema as (
			select alu.id as aluno_id, alu.nome as aluno_nome 
			from academico_aluno alu join cte_aluno_duplicado dup on (alu.nome = dup.nome)
			where alu.ra is null 
)
	
			select pro.*
			into #tmp_final
			from cte_aluno_problema pro left join academico_turmadisciplinaaluno tda on (tda.aluno_id = pro.aluno_id)
			                            left join academico_frequenciadiaria     fre on (pro.aluno_id = fre.aluno_id) 
            where tda.id is null and 
			      fre.id is null 

-- drop table #tmp_final
				select *
			  -- update destino set destino.atributos = origem.atributos
			  from academico_aluno origem  join academico_aluno destino on (origem.nome = destino.nome and
			                                                                origem.atributos is not null and 
																			destino.atributos is null)
			                               join #tmp_final      fin     on (fin.aluno_nome = origem.nome)

--###########################################################################
		-- ******* GERAR LOG  ACADEMICO_ALUNO  DELECAO ******
		declare @ID_AUX int
		declare CUR_TDP_DEL cursor for 
			-- *********************************************
			select distinct alu.id			  
			  from academico_aluno alu join #tmp_final fin on (fin.aluno_nome = alu.nome)
			  where alu.pessoa_id is null 
			-- *********************************************
			open CUR_TDP_DEL 
				fetch next from CUR_TDP_DEL into @ID_AUX
				while @@FETCH_STATUS = 0
					BEGIN
						 EXEC SP_GERAR_LOG 'ACADEMICO_ALUNO', @ID_AUX, '-', 2136, NULL, NULL, 'HIGIENIZACAO'
					fetch next from CUR_TDP_DEL into @ID_AUX
					END
			close CUR_TDP_DEL 
		deallocate CUR_TDP_DEL
		-- ******* GERAR LOG DELECAO FIM ******
        delete alu			  
			  from academico_aluno alu join #tmp_final fin on (fin.aluno_nome = alu.nome)
			  where alu.pessoa_id is null 
			  /*
			  ALTER TABLE academico_aluno DROP COLUMN aluno_universus_id;
			  ALTER TABLE academico_aluno DROP COLUMN escola_aluno_universus_id;
			  */

			  select * from academico_aluno