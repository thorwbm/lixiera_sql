create view vw_andamento_busca_redacao_ouro as 
with cte_correcoes_ouro_4 as  (
SELECT '4 correcoes' as tipo,id_corretor FROM CORRECOES_CORRECAO WITH(NOLOCK)
WHERE id_tipo_correcao = 5 AND 
	  CAST(DATA_INICIO AS DATE) = cast(dbo.getlocaldate() as date)
	  GROUP BY id_corretor
	  having COUNT(1) = 4
)
	,cte_correcoes_ouro_3 as  (
SELECT '3 correcoes' as tipo,id_corretor FROM CORRECOES_CORRECAO WITH(NOLOCK)
WHERE id_tipo_correcao = 5 AND
	  CAST(DATA_INICIO AS DATE) = cast(dbo.getlocaldate() as date)
	  GROUP BY id_corretor
	  having COUNT(1) = 3
)
	,cte_correcoes_ouro_2 as  (
SELECT '2 correcoes' as tipo,id_corretor FROM CORRECOES_CORRECAO WITH(NOLOCK)
WHERE id_tipo_correcao = 5 AND
	  CAST(DATA_INICIO AS DATE) = cast(dbo.getlocaldate() as date)
	  GROUP BY id_corretor
	  having COUNT(1) = 2
)
	,cte_correcoes_ouro_1 as  (
SELECT '1 correcoes' as tipo,id_corretor FROM CORRECOES_CORRECAO WITH(NOLOCK)
WHERE id_tipo_correcao = 5 AND 
	  CAST(DATA_INICIO AS DATE) = cast(dbo.getlocaldate() as date)
	  GROUP BY id_corretor
	  having COUNT(1) = 1
)

select tipo,COUNT(1) as quantidade from cte_correcoes_ouro_4 group by tipo union
select tipo,COUNT(1) as quantidade from cte_correcoes_ouro_3 group by tipo union
select tipo,COUNT(1) as quantidade from cte_correcoes_ouro_2 group by tipo union
select tipo,COUNT(1) as quantidade from cte_correcoes_ouro_1 group by tipo

