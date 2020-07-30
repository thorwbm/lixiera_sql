with cte_disciplina_tds as (
			select distinct dis.id, dis.nome as disciplina_nome
              from academico_disciplina dis join academico_turmadisciplina tds on (dis.id = tds.disciplina_id)
)
	,	cte_disciplina_duplicada_tds as (
			select dis.id as disciplina_id, dis.nome as disciplina_nome, tds.id as disciplina_id_tds
			from academico_disciplina dis join cte_disciplina_tds tds on (tds.disciplina_nome = dis.nome) 		
			where dis.id <> tds.id
) 
	,	cte_disciplina as (
			select dis.nome as disciplina_nome, min(dis.id) as disciplina_id_tds 
			  from academico_disciplina dis 
			 where dis.nome not in (select disciplina_nome from cte_disciplina_tds)
			 group by dis.nome 
			 having count(dis.id) > 1
)
	,	cte_disciplina_sem_tds as (
			select  dis.id as disciplina_id, cte.*
			from cte_disciplina cte join academico_disciplina dis on (cte.disciplina_nome = dis.nome)
			where dis.id <> cte.disciplina_id_tds
)
-- DROP TABLE #tmp
select *  --into #tmp 
            from (
			select * from cte_disciplina_sem_tds union 
			select * from cte_disciplina_duplicada_tds) as tab ORDER BY 2

declare @disciplina varchar(500), @disciplina_atual int , @disciplina_destino int

declare CUR_ cursor for 
	SELECT disciplina_id, disciplina_nome, disciplina_id_tds FROM #tmp   order by disciplina_nome
	open CUR_ 
		fetch next from CUR_ into @disciplina_atual, @disciplina, @disciplina_destino
		while @@FETCH_STATUS = 0
			BEGIN
				--print @disciplina + ' *** ' + CONVERT(VARCHAR(10),@disciplina_atual) + ' -> '  + CONVERT(VARCHAR(10),@disciplina_destino)
				EXEC SP_MESCLAR_DISCIPLINA @disciplina_atual, @disciplina_destino, 'HIGIENIZACAO'

			fetch next from CUR_ into @disciplina_atual, @disciplina, @disciplina_destino
			END
	close CUR_ 
deallocate CUR_ 


SELECT disciplina_id, disciplina_nome, disciplina_id_tds FROM #tmp where disciplina_nome = 'ANÁLISE METODOLÓGICA' order by disciplina_nome

select * 
-- DELETE
from tmp_erro_higienizacao

SELECT NOME 
FROM ACADEMICO_DISCIPLINA  
WHERE NOME = 'METODOLOGIA CIENTÍFICA'

SELECT disciplina_nome 
FROM #tmp  
WHERE disciplina_nome = 'METODOLOGIA CIENTÍFICA'

SELECT *  FROM tmp_erro_higienizacao ORDER BY ID DESC


SELECT * FROM academico_disciplina
/*
select nome 
from academico_disciplina 
group by nome 
having count(1) >1
*/