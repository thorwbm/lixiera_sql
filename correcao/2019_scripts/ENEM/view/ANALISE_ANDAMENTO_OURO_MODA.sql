-- **** quantidade de ouro e moda restantes por corretor
with cte_qtd_ouro_moda_restante as (
		select cor.id as id_corretor, 
			   tpr.tipo, count(our.id) as quantidade 
		  from  correcoes_corretor cor join (select tipo = 'ouro' union select tipo = 'moda') as tpr on (1 = 1)
		                               left join correcoes_filaouro  our on (cor.id = our.id_corretor and 
									                                         tpr.tipo = case when LEFT(co_barra_redacao,3) = '001' then 'ouro' else 'moda' end)
		 group by cor.id, tpr.tipo
)
	
	-- **** somatorio de todas as correcoes ate ontem 
	, cte_quantidade_ate_ontem as (
		select id_corretor, COUNT(1) as quatidade 
		  from correcoes_correcao 
		 where data_termino < CAST(dbo.getlocaldate() as date)
		 group by id_corretor
) 

	-- **** quantidade total corrigida hoje 
	, cte_quantidade_hoje as (
		select CAST(data_termino as date) as data ,id_corretor, COUNT(1) as quatidade 
		  from correcoes_correcao 
		 where  CAST(data_termino as date) = CAST(dbo.getlocaldate() as date)
		 group by CAST(data_termino as date),id_corretor
) 
	
	-- **** quantidade de correcoes ouro e moda do corretor por dia
	, cte_quantidade_ouro_por_dia as (
		select cast(data_termino as date) as data, id_corretor,  
			   case when LEFT(co_barra_redacao,3) = '001' then 'ouro' else 'moda' end as tipo, count(1) as quantidade 
		  from correcoes_correcao 
		 where id_tipo_correcao in (5,6)
		 group by cast(data_termino as date), id_corretor, case when LEFT(co_barra_redacao,3) = '001' then 'ouro' else 'moda' end
) 
	
	, cte_menor_posicao_ouro_moda as (
		select cor.id as id_corretor, 
			   tpr.tipo, isnull(min(posicao),0) as  menor_posicao
		  from  correcoes_corretor cor join (select tipo = 'ouro' union select tipo = 'moda') as tpr on (1 = 1)
		                               left join correcoes_filaouro  our on (cor.id = our.id_corretor and 
									                                         tpr.tipo = case when LEFT(co_barra_redacao,3) = '001' then 'ouro' else 'moda' end)
		 group by cor.id, tpr.tipo 
)


	select distinct cor.id, ontem.quatidade as qtd_ate_ontem, 
	               hoje.quatidade  as qtd_hoje, 
				   rest.tipo,
				   rest.quantidade as qtd_restante_para_correcao, 
				   isnull(OMdia.quantidade,0) as qtd_corrigida_hoje_OURO_MODA, 
				   menor.menor_posicao , 
				   dia.CORRECOES as cota_do_dia

	  from correcoes_corretor cor      join VW_CORRECAO_DIA            dia    on (dia.id = cor.id) 
	                              left join cte_quantidade_ate_ontem   ontem  on (cor.id = ontem.id_corretor)
	                              left join cte_quantidade_hoje        hoje   on (cor.id = hoje.id_corretor)
								  left join cte_qtd_ouro_moda_restante rest   on (cor.id = rest.id_corretor)
								  left join cte_quantidade_ouro_por_dia OMdia on (cor.id = OMdia.id_corretor and 
								                                                  rest.tipo = OMdia.tipo and 
																				  hoje.data = OMdia.data)
								  left join cte_menor_posicao_ouro_moda menor on (cor.id = menor.id_corretor and 
								                                                  rest.tipo = menor.tipo)
								  

	   WHERE  Ceiling(hoje.quatidade / 50.0) <   isnull(OMdia.quantidade,0) 

	   ORDER BY  1




/*
	--   select * from correcoes_filaouro where ID_corretor = 2587 order by posicao

	--   select * from log_correcoes_corretor where id = 3786 and  order by  history_id desc

	select COUNT(1) from correcoes_correcao where id_corretor = 658 and id_status = 3

	select * from log_correcoes_filaouro 
	where id_corretor = 3786 and 
	      cast(history_date as date) = '2019-12-05' 		  
	order by  history_id desc

	select * from correcoes_filaouro 
	where id_corretor = 422  
	     
		  order by posicao

		  select * from auth_user where last_name like 'Ambrosina%'

		  select * from VW_CORRECAO_DIA where ID = 1537

		  select id, id_corretor, case  id_tipo_correcao when 5 then 'ouro'
		                                                 when 6 then 'moda' else 'normal' end , data_inicio,
			     ROW_NUMBER() OVER(ORDER BY id ASC) + 950
		  from correcoes_correcao 
		   where id_corretor = 1537 and 
		        -- id_tipo_correcao in (5,6) and 
				 CAST(data_termino as date) = CAST(dbo.getlocaldate() as date)
				 order by id 

select * from log_correcoes_filaouro 
where id_corretor = 1537 and 
      cast(history_date as date) = '2019-12-04'
	order by history_date,id


select * from log_correcoes_corretor where id = 1537  order by history_id desc */