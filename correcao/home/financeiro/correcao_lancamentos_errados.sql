-- drop table #temp
/* 
with cte_aluno as (
select nome ='ALINE ROSE MAGALHÃES BARBOSA BRAGA' union
select nome ='ÁLVARO ALOÍSIO DE SOUZA' union
select nome ='ANA CAROLINA MOURA GUIMARAES MARTINEZ VELASCO' union
select nome ='ANA CLARA DOS SANTOS RIBEIRO' union
select nome ='ANA FLAVIA COURET DE CARVALHO BRAGA' union
select nome ='ANA HELENA SALLES DOS REIS' union
select nome ='ARTHUR FELLIPE SOARES CRUZ' union
select nome ='BARBARA CRISTINA CARNEIRO AZEVEDO' union
select nome ='BRUNA IRRTHUM OLIVEIRA' union
select nome ='DAYSIELLE OLIVEIRA BENTO' union
select nome ='DEBORA DIAS JARDIM' union
select nome ='EURIDES DE SOUZA LIMA NETA' union
select nome ='FABIANA CARVALHO GONÇALVES' union
select nome ='FABIANA CARVALHO GONÇALVES' union
select nome ='FERNANDA MICKAELA SOUZA GONÇALVES' union
select nome ='FERNANDA NORONHA INÁCIO' union
select nome ='FERNANDO CAMPOS SILVA DAL MARIA' union
select nome ='GABRIELA FIUZA CAPORALI DE OLIVEIRA' union
select nome ='GABRIELA GIOVANNA ALMEIDA COSTA' union
select nome ='GUILHERME TOFANE MAIA VILASBOAS' union
select nome ='IANNY DUMONT ÁVILA' union
select nome ='ISABELA STORCH CARVALHO' union
select nome ='ISABELLA DE OLIVEIRA GONÇALVES' union
select nome ='IVONE PEDRO OLIVEIRA' union
select nome ='IZABELLA RODRIGUES SIERVI' union
select nome ='JOÃO GABRIEL ALVARENGA ANDRADE' union
select nome ='JORDANY CRISTINA DOS REIS ROSA' union
select nome ='KLAUSS CAMPOS SALLES DA SILVA' union
select nome ='LAIS REGINA PENNA MOLLENDORFF LEÃO DIAS' union
select nome ='LOUYZZE VITORIA VIEIRA MEDRADO FERNANDES' union
select nome ='LUCAS OLIVEIRA E SOUZA' union
select nome ='LUIZA EDUARDA MENDES SILVA' union
select nome ='MARCELA DUARTE ALVIM' union
select nome ='MARIANNA AMENO' union
select nome ='MERICIA RODRIGUES TEIXEIRA' union
select nome ='MERLE GLEICE MELLO CAMPOLINA PONTES' union
select nome ='NATHALIA DE LIMA FERREIRA' union
select nome ='PEDRO HENRIQUE LORENTZ CAMPOS' union
select nome ='PEDRO HENRIQUE MARQUES PEREIRA' union
select nome ='POLLYANA ISABELE LIMA SILVA' union
select nome ='POLLYANA ISABELE LIMA SILVA' union
select nome ='RAFAELA ALVES SANTOS DE MELO' union
select nome ='RENATO ANATOLIO LIMA HORTA MACIEL' union
select nome ='RENATO ANATOLIO LIMA HORTA MACIEL' union
select nome ='ROBERTA ALVIM PAES LEME' union
select nome ='SOFIA THEODORA PEREIRA FREITAS' union
select nome ='TANIA CORREA OLIVEIRA' union
select nome ='WELKEMIR MÁRLON FERREIRA SILVA' union
select nome ='WISLEY RIBEIRO TEIXEIRA LOPES' 
)

select * into #temp from cte_aluno
*/

select distinct * from #temp


insert into #temp
select aluno_nome from vw_Curriculo_aluno_pessoa 
where curriculo_aluno_id in (
select curriculo_aluno_id from financeiro_lancamento lan 
where status_id = 5 and 
      (pago_em is null or valor_pago = 0) )



--select distinct * from cte_aluno
   insert into tmp_financeiro_lancamento_correcao_baixas
   select par.data_pagamento ,par.valor_pago as valor_pago_parcela, par.status_parcela, par.boleto_id,
          lan.pago_em, 
          lan.status_id, lan.valor_pago, lan.id as id_lancamento, par.ra, cap.aluno_nome into #tmp -- into tmp_financeiro_lancamento_correcao_baixas
	  -- select lan.* into tmp_financeiro_lancamento_LANCAMENTOS_SEM_BAIXA
	--  UPDATE LAN SET LAN.pago_em = PAR.data_pagamento, LAN.valor_pago = PAR.valor_pago, LAN.status_id = 5
  from financeiro_lancamento lan join vw_Curriculo_aluno_pessoa cap on (cap.curriculo_aluno_id = lan.curriculo_aluno_id)
                                        join VW_FNC_PARCELAS           par on (par.ra collate database_default = cap.aluno_ra collate database_default  and 
										                                       par.mes_competencia = lan.mes_competencia and 
																			   par.ano_competencia = lan.ano_competencia)
 where  cap.aluno_nome in (select nome from #temp) and 
        cap.aluno_nome not in (select aluno_nome from tmp_financeiro_lancamento_correcao_baixas) and 
	    par.status_parcela = 'pago'


       isnull(par.data_pagamento,'1970-08-03') <>  isnull(lan.pago_em,'1970-08-03') and 
	   lan.valor_pago <> par.valor_pago and
	   par.boleto_id is not null 


select distinct aluno_nome from tmp_financeiro_lancamento_correcao_baixas order by 1


select * from vw_fnc_parcelas where boleto_id = 31047


select * from boletos_service.db_owner.vw_boleto
where boleto_id in (
select boleto_id from #tmp) and 
       boleto_status = 'paid'





	   select distinct cpd.aluno_ra, cpd.aluno_nome, cpd.parcela_id, cpd.data_vencimento, 
	          lancamento_boleto_id, lancamento_pago_em, lancamento_valor_pago, cpd.lancamento_status_nome,lan.status_id,
			  par.valor_pago, par.data_pagamento, 
			  bls.boleto_id, bls.valor_pago, bls.data_pagamento, bls.boleto_status
	--	begin tran update lan set lan.status_id = case when bls.boleto_status = 'paid' then 5 else 2 end 
	   from vw_contrato_parcela_desconto_aluno cpd join vw_fnc_parcelas par on (cpd.aluno_ra collate database_default = par.RA collate database_default and 
	                                                                            cpd.mes_competencia = par.mes_competencia and 
																				cpd.ano_competencia = par.ano_competencia and 
																				cpd.boleto_id       = par.boleto_id)
												   join boletos_service.db_owner.vw_boleto bls on (bls.boleto_id = cpd.boleto_id)
	                                               join financeiro_lancamento              lan on (lan.parcela_id = cpd.parcela_id)
	   where cpd.aluno_nome in (select nome from #temp) and 
	         --cpd.aluno_nome = 'MARIANNA AMENO'  and 
	        -- cpd.mes_competencia = 1 and 
			-- cpd.ano_competencia = 2020 and 
			 cpd.lancamento_status_nome <> case when bls.boleto_status = 'paid' then 'pago' else 'Em Aberto' end
	   order by 2

	   -- commit 
	   
      select * from financeiro_lancamento where parcela_id in (11879,8690)
      select * from financeiro_statuslancamento

	  select * from vw_contrato_parcela_desconto_aluno