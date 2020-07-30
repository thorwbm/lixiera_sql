WITH CTE_TURMAS_DUPLICADAS AS (
		SELECT NOME
		FROM ACADEMICO_TURMA 
		GROUP BY NOME 
		HAVING COUNT(1) > 1
)	

		select * 
		  from CTE_TURMAS_DUPLICADAS dup join academico_turma tur on (dup.nome = tur.nome)
		  where 
		  tur.id not in (select turma_id from academico_turmadisciplina)


select * from academico_turmadisciplina where turma_id in (
SELECT TUR.ID FROM CTE_TURMAS_DUPLICADAS CTE JOIN ACADEMICO_TURMA TUR ON (CTE.NOME = TUR.NOME))



--delete  from academico_turma where id in (
		SELECT TUR.ID FROM CTE_TURMAS_DUPLICADAS CTE JOIN ACADEMICO_TURMA TUR ON (CTE.NOME = TUR.NOME)
		                                   LEFT JOIN ACADEMICO_TURMADISCIPLINA TDS ON (TUR.ID = TDS.turma_id)
         WHERE TDS.ID IS NULL --)
		 ORDER BY 1

		 SELECT * FROM vw_tabela_coluna WHERE COLUNA = 'TURMA_ID'




