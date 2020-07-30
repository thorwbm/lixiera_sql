with cte_registros as (
		select aul.* , 
		       tur.id as turma_id, tur.nome as turma_nome, 
			   usu.id as usuario_id, usu.username 
		  from academico_aula aul with(nolock) join academico_turmadisciplina trd with(nolock) on (trd.id = aul.turma_disciplina_id)
		                                       join auth_user usu on (aul.atualizado_por = usu.id)
		                                       join academico_turma           tur with(nolock) on (tur.id = trd.turma_id) 
		 where cast(aul.atualizado_em as date) = '2019-10-14' and 
		       usu.username = 'leandro.carvalho' and 
		       tur.nome in ('1MA2º2019-2','1MAP022º2019-2','1MAP012º2019-2','1MAP01.22º2019-2','1MAP02.22º2019-2','1MAP02.12º2019-2','1MAP01.12º2019-2' )

), 
      cte_atualizacoes_feitas as (
			select reg.id as atual, reg.atualizado_em as data, laa.* from log_academico_aula laa join cte_registros reg on (laa.id = reg.id and 
														                                                    cast(reg.atualizado_em as date) = cast(laa.atualizado_em as date))
		--	where laa.id = 156842
)

			select top 1 aul.atualizado_em, * from log_academico_aula aul 
			  where not exists (select 1 from cte_atualizacoes_feitas fei 
			                      where fei.id = aul.id and 
								        fei.atualizado_em = aul.atualizado_em)
			  and aul.id = 156842
				order by aul.atualizado_em desc


			--	select * from log_academico_aula