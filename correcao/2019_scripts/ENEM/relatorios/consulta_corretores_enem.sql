with cte_total_corrigidas as (
		select id_corretor, count(1) as qtd_corrigidas
		  from correcoes_correcao with(nolock) 
		 where id_status = 3
		group by id_corretor
)


--(nao_discrepantes + aproveitadas) / nr_corrigidas) * 100)
	, cte_aproveitamento_corretor as (
	    select usuario_id, aproveitamento = cast( round((((corrigidas - discrepantes) + aproveitadas)/corrigidas) * 100,2) as decimal(10,2)) 
		  from (
				select usuario_id, 
					   corrigidas   = cast(sum(nr_corrigidas)   as float) , 
					   discrepantes = cast(sum(nr_discrepantes) as float) , 
					   aproveitadas = cast(sum(nr_aproveitadas) as float)
				  from vw_aproveitamento_notas_time 
				 group by usuario_id
		      ) as tab 
)    
	, cte_dsp_corretor as (
        select usuario_id, dsp
		  from correcoes_corretor_indicadores ind 
		  where data_calculo = (select max(data_calculo) from correcoes_corretor_indicadores indx where indx.usuario_id = ind.usuario_id )		
) 

select corretor         = usu.last_name,
       cpf              = crd.cpf, 
	   email            = crd.email, 
	   polo             = hie.polo_descricao, 
	   [time]           = hie.time_descricao, 
       total_corrigidas = isnull(tcg.qtd_corrigidas,0), 
	   aproveitamento   = isnull(apv.aproveitamento,0), 
	   dsp              = isnull(dsp.dsp,0)
  from correcoes_corretor crt with(nolock) join auth_user                      usu with(nolock) on (crt.id = usu.id) 
                                      left join cte_total_corrigidas           tcg with(nolock) on (crt.id = tcg.id_corretor) 
									  left join cte_aproveitamento_corretor    apv with(nolock) on (crt.id = apv.usuario_id)
									  left join cte_dsp_corretor               dsp with(nolock) on (crt.id = dsp.usuario_id)
                                      left join correcoes_corretordados        crd with(nolock) on (crd.cpf = usu.username)
									  left join vw_usuario_hierarquia_completa hie with(nolock) on (crt.id = hie.usuario_id)

order by 1