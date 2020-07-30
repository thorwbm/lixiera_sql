/*
--  drop table tmp_redacoes_corrigidas

declare @data datetime
set @data = getdate()
select top 1 red.co_barra_redacao, red.nota_final, red.id_correcao_situacao, data_processamento = @data, status_redacao = 1 , data_correcao = max(cor.data_termino),
       motivo = replicate ('x',1000)
 into tmp_redacoes_corrigidas  from correcoes_redacao red with (nolock) join correcoes_correcao cor with (nolock) on (red.co_barra_redacao = cor.co_barra_redacao)
where red.nota_final is not null and 
      cor.data_termino is not null 
	group by red.co_barra_redacao, red.nota_final, red.id_correcao_situacao


--truncate table tmp_redacoes_corrigidas


declare @data datetime
set @data = getdate()
insert into tmp_redacoes_corrigidas
select red.co_barra_redacao, red.nota_final, red.id_correcao_situacao, data_processamento = @data, status_redacao = 1 , data_correcao = max(cor.data_termino),
       motivo = null
   from correcoes_redacao red with (nolock) join correcoes_correcao cor with (nolock) on (red.co_barra_redacao = cor.co_barra_redacao)
-- where red.nota_final is not null and       cor.data_termino is not null 
	group by red.co_barra_redacao, red.nota_final, red.id_correcao_situacao
*/

-- ***** VALIDACAO DA AUDITORIA *****
/* cte lista auditorias feitas*/
with cte_auditoria as (
select red.co_barra_redacao, red.nota_final, red.id_correcao_situacao, termino = cor.data_termino, red.id as redacao_id
 from [20191016].correcoes_redacao red with (nolock) join [20191016].correcoes_correcao cor with (nolock) on (red.id = cor.redacao_id)
 where cor.id_tipo_correcao = 7 and 
       red.nota_final is not null),
/* cte busca origem das auditorias*/ 
	cte_validar_auditoria as (
	select aud.co_barra_redacao, aud.nota_final, aud.id_correcao_situacao, termino = aud.termino, cor.redacao_id, 
	       situacao = (case when cor.id_correcao_situacao = 9 then 1 else 0 end) + 
		              (case when cor.competencia5         = -1 then 1 else 0 end), 
		   final    = (case when cor.nota_final = 1000 and id_tipo_correcao = 4 then 2000 else cor.nota_final end)
	  from [20191016].correcoes_correcao cor with (nolock)  join cte_auditoria aud with (nolock) on (cor.redacao_id = aud.redacao_id)
	 where cor.id_tipo_correcao < 7),
/* cte agrupar validacao*/
	cte_agrupar_validacao as (
	 select val.redacao_id, val.nota_final, val.id_correcao_situacao, situacao = sum(val.situacao), final = sum(val.final)
	   from  cte_validar_auditoria val with (nolock) 
	  group by val.redacao_id, val.nota_final, val.id_correcao_situacao)

/* select que valida se a nota e situacao sao iguais e se realmente e necesserario estar na auditoria*/ 
  select count(red.id) 
 --   update tmp set tmp.status_redacao = 0, motivo = 'Redacao com nota e situacao com auditoria porem com divergencia de nota, situacao, ou motivo de ser auditada'
      from [20191016].correcoes_redacao red with (nolock) join cte_agrupar_validacao   agr with (nolock) on (red.id = agr.redacao_id)
                                              -- join tmp_redacoes_corrigidas tmp with (nolock) on (tmp.co_barra_redacao = red.co_barra_redacao)
     where (situacao >  0 or 
            final    >= 2000) and
           (red.nota_final           <> agr.nota_final or 
            red.id_correcao_situacao <> agr.id_correcao_situacao)  

GO		                                         
-- #################################################################################################################################################################
-- ****** VALIDACAO DA QUARTA CORRECAO FINAL *********

/* cte que reune todas as quartas que sao finais */
with cte_quarta_correcao as (
	select distinct red.co_barra_redacao, red.nota_final, red.id_correcao_situacao,
	                                      nota_final_qua = cor.nota_final, id_correcoes_situacao_qua = cor.id_correcao_situacao
	  from correcoes_redacao red with (nolock) join correcoes_correcao cor  with (nolock)  on (red.co_barra_redacao = cor.co_barra_redacao)
	 where 
	       cor.id_tipo_correcao = 4 and
	       cor.id_status = 3 and
	       not exists (select top 1 1 from correcoes_correcao      coraud with (nolock) where coraud.co_barra_redacao = cor.co_barra_redacao and coraud.id_tipo_correcao = 7) and
	       not exists (select top 1 1 from correcoes_filaauditoria filaud with (nolock) where filaud.co_barra_redacao = cor.co_barra_redacao)
   ),
/* cte para comparacao das discrepancias de terceira */
cte_comparacao_terceira as (
   select qua.co_barra_redacao, qua.nota_final, qua.id_correcao_situacao, 
          qua.nota_final_qua, qua.id_correcoes_situacao_qua
     from cte_quarta_correcao qua with (nolock) join correcoes_correcao cor3  with (nolock) on (qua.co_barra_redacao  = cor3.co_barra_redacao and 
                                                                                                cor3.id_tipo_correcao = 3) 
												join correcoes_correcao cor2  with (nolock) on (qua.co_barra_redacao  = cor2.co_barra_redacao and 
                                                                                                cor2.id_tipo_correcao = 2) 
												join correcoes_correcao cor1  with (nolock) on (qua.co_barra_redacao  = cor1.co_barra_redacao and 
                                                                                                cor1.id_tipo_correcao = 1)
	where (abs(cor3.nota_final   - cor2.nota_final  ) > 100 or
	       abs(cor3.competencia1 - cor2.competencia1) > 2   or 
	       abs(cor3.competencia2 - cor2.competencia2) > 2   or 
	       abs(cor3.competencia3 - cor2.competencia3) > 2   or 
	       abs(cor3.competencia4 - cor2.competencia4) > 2   or 
	       abs(cor3.competencia5 - cor2.competencia5) > 2   or
		   (cor3.id_correcao_situacao <> cor2.id_correcao_situacao)) and 
		  (abs(cor3.nota_final   - cor1.nota_final  ) > 100 or
	       abs(cor3.competencia1 - cor1.competencia1) > 2   or 
	       abs(cor3.competencia2 - cor1.competencia2) > 2   or 
	       abs(cor3.competencia3 - cor1.competencia3) > 2   or 
	       abs(cor3.competencia4 - cor1.competencia4) > 2   or 
	       abs(cor3.competencia5 - cor1.competencia5) > 2   or
		   (cor3.id_correcao_situacao <> cor1.id_correcao_situacao))
	)

select count(cor.id)
   -- update tmp set tmp.status_redacao = 0, motivo = 'Redacao com nota e situacao com 4 correcao porem com divergencia de nota, situacao'
	  from correcoes_correcao cor with (nolock) join cte_quarta_correcao     qua with (nolock) on (cor.co_barra_redacao = qua.co_barra_redacao)
	                                            join tmp_redacoes_corrigidas tmp with (nolock) on (tmp.co_barra_redacao = cor.co_barra_redacao)
	                                       left join cte_comparacao_terceira com with (nolock) on (com.co_barra_redacao = cor.co_barra_redacao)
	where cor.id_tipo_correcao = 4 and 
	      ((cor.nota_final <> qua.nota_final_qua or 
	        cor.id_correcao_situacao <> qua.id_correcoes_situacao_qua) or 
			com.co_barra_redacao is null)

GO		                                         
-- #################################################################################################################################################################
-- ****** VALIDACAO DA TERCEIRA CORRECAO FINAL *********

/* cte que reune todas as terceiras que sao finais */
with cte_terceira_correcao as (
	select distinct red.co_barra_redacao, red.nota_final, red.id_correcao_situacao,
	                                      nota_final_ter = cor.nota_final, id_correcoes_situacao_ter = cor.id_correcao_situacao
	  from correcoes_redacao red with (nolock) join correcoes_correcao cor  with (nolock)  on (red.co_barra_redacao = cor.co_barra_redacao)
	 where 
	       cor.id_tipo_correcao = 3 and
	       cor.id_status = 3 and
	       not exists (select top 1 1 from correcoes_correcao      coraud with (nolock) where coraud.co_barra_redacao = cor.co_barra_redacao and coraud.id_tipo_correcao = 7) and
	       not exists (select top 1 1 from correcoes_filaauditoria filaud with (nolock) where filaud.co_barra_redacao = cor.co_barra_redacao) and 
		   not exists (select top 1 1 from correcoes_correcao      corqua with (nolock) where corqua.co_barra_redacao = cor.co_barra_redacao and corqua.id_tipo_correcao = 4) and
	       not exists (select top 1 1 from correcoes_fila4         filqua with (nolock) where filqua.co_barra_redacao = cor.co_barra_redacao)
   ),
/* cte para comparar as notas de tercerira com segunda */
 cte_comparacao_3_2 as (
	select  cor3.co_barra_redacao, 
       situacao =  case when (abs(cor3.nota_final   - cor2.nota_final  ) > 100 or
	                          abs(cor3.competencia1 - cor2.competencia1) > 2   or 
	                          abs(cor3.competencia2 - cor2.competencia2) > 2   or 
	                          abs(cor3.competencia3 - cor2.competencia3) > 2   or 
	                          abs(cor3.competencia4 - cor2.competencia4) > 2   or 
	                          abs(cor3.competencia5 - cor2.competencia5) > 2   or
		                      (cor3.id_correcao_situacao <> cor2.id_correcao_situacao)) then 'discrepou' else 'nao discrecpou' end,
	   media = case when cor3.id_correcao_situacao = 1 and cor2.id_correcao_situacao = 1 then (cor3.nota_final + cor2.nota_final)/2 else 0 end 
   from correcoes_correcao cor3 with (nolock) join correcoes_correcao cor2 with (nolock) on (cor3.co_barra_redacao = cor2.co_barra_redacao and cor2.id_tipo_correcao = 2 and cor3.id_tipo_correcao = 3)
   where cor2.id_status = 3 and cor2.id_status = 3	--and  cor3.co_barra_redacao = '029218100027740803'   
),
/* cte para comparar as notas de tercerira com primeira */
cte_comparacao_3_1 as (
	select  cor3.co_barra_redacao, 
       situacao =  case when (abs(cor3.nota_final   - cor1.nota_final  ) > 100 or
	                          abs(cor3.competencia1 - cor1.competencia1) > 2   or 
	                          abs(cor3.competencia2 - cor1.competencia2) > 2   or 
	                          abs(cor3.competencia3 - cor1.competencia3) > 2   or 
	                          abs(cor3.competencia4 - cor1.competencia4) > 2   or 
	                          abs(cor3.competencia5 - cor1.competencia5) > 2   or
		                      (cor3.id_correcao_situacao <> cor1.id_correcao_situacao)) then 'discrepou' else 'nao discrecpou' end,
	   media = case when cor3.id_correcao_situacao = 1 and cor1.id_correcao_situacao = 1 then (cor3.nota_final + cor1.nota_final)/2 else 0 end
	from correcoes_correcao cor3 with (nolock) join correcoes_correcao cor1 with (nolock) on (cor3.co_barra_redacao = cor1.co_barra_redacao and cor1.id_tipo_correcao = 1 and cor3.id_tipo_correcao = 3)
	where cor3.id_status = 3 and cor1.id_status = 3	 --and  cor3.co_barra_redacao = '029218100027740803' 
),
/* cte para comparar primeira com segunda */
cte_comparacao_1_2 as (
	select  cor2.co_barra_redacao, 
       situacao =  case when (abs(cor2.nota_final   - cor1.nota_final  ) > 100 or
	                          abs(cor2.competencia1 - cor1.competencia1) > 2   or 
	                          abs(cor2.competencia2 - cor1.competencia2) > 2   or 
	                          abs(cor2.competencia3 - cor1.competencia3) > 2   or 
	                          abs(cor2.competencia4 - cor1.competencia4) > 2   or 
	                          abs(cor2.competencia5 - cor1.competencia5) > 2   or
		                      (cor2.id_correcao_situacao <> cor1.id_correcao_situacao)) then 'discrepou' else 'nao discrecpou' end 
	from correcoes_correcao cor2 with (nolock) join correcoes_correcao cor1 with (nolock) on (cor2.co_barra_redacao = cor1.co_barra_redacao and cor1.id_tipo_correcao = 1 and cor2.id_tipo_correcao = 2)
	where cor2.id_status = 3 and cor1.id_status = 3	       
)

	 select  red.co_barra_redacao, red.nota_final, com13.media, com13.situacao, com23.media,com23.situacao 
  --   update tmp set tmp.status_redacao = 0, motivo = 'Redacao com nota e situacao com 3 correcao porem com divergencia de nota, situacao'
	  from correcoes_redacao red with (nolock) join correcoes_correcao    cor   with (nolock) on (red.co_barra_redacao = cor.co_barra_redacao and 
	                                                                                              cor.id_tipo_correcao = 3)
							                   join cte_terceira_correcao ter   with (nolock) on (ter.co_barra_redacao = red.co_barra_redacao)
											   join tmp_redacoes_corrigidas tmp with (nolock) on (tmp.co_barra_redacao = cor.co_barra_redacao)
										  left join cte_comparacao_1_2    com12 with (nolock) on (red.co_barra_redacao = com12.co_barra_redacao)
										  left join cte_comparacao_3_1    com13 with (nolock) on (red.co_barra_redacao = com13.co_barra_redacao)
										  left join cte_comparacao_3_2    com23 with (nolock) on (red.co_barra_redacao = com23.co_barra_redacao)
	where --cor.data_termino <= '2018-12-04 05:12' and 
	      (com12.co_barra_redacao is not null    and 
		   com13.co_barra_redacao is not null    and
		   com23.co_barra_redacao is not null)   and
		  ((red.nota_final <> cast(com13.media as int) and com13.situacao = 'nao discrepou') or  
		   (red.nota_final <> cast(com23.media as int) and com23.situacao = 'nao discrepou'))

go
-- ###############################################################################################################################################
/*VALIDADACAO DA PRIMEIRA COM SEGUNDA FINAL */		    

/* cte que reune todas as primeiras e segundas que sao finais */
with cte_2_1_correcao as (
	select distinct red.co_barra_redacao, red.nota_final, red.id_correcao_situacao,
	                                      nota_final_ter = cor.nota_final, id_correcoes_situacao_ter = cor.id_correcao_situacao
	  from correcoes_redacao red with (nolock) join correcoes_correcao cor  with (nolock)  on (red.co_barra_redacao = cor.co_barra_redacao)
	 where 
	       cor.id_tipo_correcao IN (1,2) and
	       cor.id_status = 3 and
	       not exists (select top 1 1 from correcoes_correcao      coraud with (nolock) where coraud.co_barra_redacao = cor.co_barra_redacao and coraud.id_tipo_correcao = 7) and
	       not exists (select top 1 1 from correcoes_filaauditoria filaud with (nolock) where filaud.co_barra_redacao = cor.co_barra_redacao) and 
		   not exists (select top 1 1 from correcoes_correcao      corqua with (nolock) where corqua.co_barra_redacao = cor.co_barra_redacao and corqua.id_tipo_correcao = 4) and
	       not exists (select top 1 1 from correcoes_fila4         filqua with (nolock) where filqua.co_barra_redacao = cor.co_barra_redacao) and
		   not exists (select top 1 1 from correcoes_correcao      corter with (nolock) where corter.co_barra_redacao = cor.co_barra_redacao and corter.id_tipo_correcao = 3) and
	       not exists (select top 1 1 from correcoes_fila3         fil3   with (nolock) where fil3.co_barra_redacao   = cor.co_barra_redacao) and 
		   not exists (select top 1 2 from ocorrencias_ocorrencia  oco    with (nolock) where oco.correcao_id         = cor.id and oco.status_id <> 2)

   ) ,

/* cte para comparar primeira com segunda */
 cte_comparacao_1_2 as (
	select  cor2.co_barra_redacao, 
       situacao =  case when (abs(cor2.nota_final   - cor1.nota_final  ) > 100 or
	                          abs(cor2.competencia1 - cor1.competencia1) > 2   or 
	                          abs(cor2.competencia2 - cor1.competencia2) > 2   or 
	                          abs(cor2.competencia3 - cor1.competencia3) > 2   or 
	                          abs(cor2.competencia4 - cor1.competencia4) > 2   or 
	                          abs(cor2.competencia5 - cor1.competencia5) > 2   or
		                      (cor2.id_correcao_situacao <> cor1.id_correcao_situacao)) then 'discrepou' else 'nao discrecpou' end, 	       
	       media = case when cor2.id_correcao_situacao = 1 and cor1.id_correcao_situacao = 1 then (cor2.nota_final + cor1.nota_final)/2 else 0 end 
	from correcoes_correcao cor2 with (nolock) join correcoes_correcao cor1    with (nolock) on (cor2.co_barra_redacao = cor1.co_barra_redacao and cor1.id_tipo_correcao = 1 and cor2.id_tipo_correcao = 2)
	                                           join cte_2_1_correcao   cor_2_1 with (nolock) on (cor2.co_barra_redacao = cor_2_1.co_barra_redacao)
	where cor2.id_status = 3 and cor1.id_status = 3	       
)
    --select distinct red.co_barra_redacao 
     update tmp set tmp.status_redacao = 0, motivo = 'Redacao com nota e situacao com que nao houve discrepancia entre 1 e 2 mas que a nota nao confrere com a redacao'
     from correcoes_redacao red with (nolock) join cte_2_1_correcao  segpri with (nolock) on (red.co_barra_redacao = segpri.co_barra_redacao)
	                                          join cte_comparacao_1_2 com12 with (nolock) on (red.co_barra_redacao = com12.co_barra_redacao)
											  join tmp_redacoes_corrigidas tmp with (nolock) on (tmp.co_barra_redacao = red.co_barra_redacao)
	where red.nota_final <> com12.media 

go
-- ################################################################################################################################################
/* redacao ouro ou moda que estao para usuarios errados */
-- select  * 
-- update tmp set tmp.status_redacao = 0, motivo = 'Redacao ouro ou moda que estao na correcao para usuario diferente'
  from correcoes_correcao cor with (nolock)  join tmp_redacoes_corrigidas tmp with (nolock) on (tmp.co_barra_redacao = cor.co_barra_redacao)
 where left(cor.co_barra_redacao,3) in ('001','002') and 
       id_corretor <> cast(right(cor.co_barra_redacao,6) as int)	
	
go   
-- ################################################################################################################################################
/* valida as redacoes finalizadas que ainda estao com ocorrencias em aberto */
-- select * 
-- update tmp set tmp.status_redacao = 0, motivo = 'Redacao finalizada com ocorrencias em aberto'
  from correcoes_correcao cor with (nolock) join ocorrencias_ocorrencia  oco with (nolock) on (cor.id = oco.correcao_id and oco.status_id <> 2) 
                                            join tmp_redacoes_corrigidas tmp with (nolock) on (tmp.co_barra_redacao = cor.co_barra_redacao)

go   
-- ################################################################################################################################################
/* valida as redacoes finalizadas que que a data final e menor que a data inicial */
 -- select  * 
 -- update tmp set tmp.status_redacao = 0, motivo = 'Redacao onde a data termino e menor que a data inicio'
  from correcoes_correcao cor with (nolock)  join tmp_redacoes_corrigidas tmp with (nolock) on (tmp.co_barra_redacao = cor.co_barra_redacao)
 where cor.data_termino < cor.data_inicio	
 
go   
-- ################################################################################################################################################
/* valida as redacoes finalizadas que que a nota final e diferente do somatorio das notas de competencia */
 -- select  * 
 --  update tmp set tmp.status_redacao = 0, motivo = 'Redacao onde a somatorio das competencias e diferente da nota final'
  from correcoes_correcao cor with (nolock)  join tmp_redacoes_corrigidas tmp with (nolock) on (tmp.co_barra_redacao = cor.co_barra_redacao)
 where (cor.nota_competencia1 +
  	   cor.nota_competencia2 +
  	   cor.nota_competencia3 +
  	   cor.nota_competencia4 +
  	   cor.nota_competencia5) <> cor.nota_final 
 
go   
-- ################################################################################################################################################
/* valida as redacoes possuem correcao de 4 que nao possui alguma das anterirores 1,2,3 */
 -- select  *  	

 -- select count(cor4.id) 
   update tmp set tmp.status_redacao = 0, motivo = 'Redacao onde a existe 4 correcao e  que nao possui alguma das anterirores 1,2,3 '
   from correcoes_correcao cor4 with (nolock) join tmp_redacoes_corrigidas tmp  with (nolock) on (tmp.co_barra_redacao  = cor4.co_barra_redacao and cor4.id_tipo_correcao = 4)
                                        left join correcoes_correcao      cor3 with (nolock) on (cor3.co_barra_redacao = cor4.co_barra_redacao and cor3.id_tipo_correcao = 3)
                                        left join correcoes_correcao      cor2 with (nolock) on (cor2.co_barra_redacao = cor4.co_barra_redacao and cor2.id_tipo_correcao = 2)
                                        left join correcoes_correcao      cor1 with (nolock) on (cor1.co_barra_redacao = cor4.co_barra_redacao and cor1.id_tipo_correcao = 1)
 where (cor3.co_barra_redacao is null or
        cor2.co_barra_redacao is null or
        cor1.co_barra_redacao is null)





 select * from tmp_redacoes_corrigidas
 where status_redacao = 0