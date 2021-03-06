xxxxxxxxxxxxxxxxxxxxxxxxx
-- drop table #temp
select distinct fnc.plano_nome, mac.lanc_conta_id, mac.ano_competencia, mac.mes_competencia, fnc.status_parcela, fnc.data_pagamento, 
       fnc.boleto_id, fnc.valor_pago, mac.responsavel_financeiro_id,lancamento_id, parcela_valor, lanc_valor_pago,MAC.LANC_VALOR_LIQUIDO,
	   creditado_em = cast(bol.data_pagamento as date)
	 into #temp
	  from VW_FNC_PARCELA_MAT_REM  fnc left join vw_financeiro_macro mac on (fnc.RA collate database_default = mac.aluno_ra collate database_default and
	                                                                         fnc.mes_competencia = mac.mes_competencia and 
																			 fnc.ano_competencia = mac.ano_competencia and
																			 cast(fnc.DATA_VENCIMENTO as date) = cast(mac.parcela_data_vencimento as date))
									   left join boletos_service.DB_OWNER.vw_boleto bol on (bol.boleto_id = fnc.boleto_id)
	where fnc.desconto_id is null and 
	      mac.curriculo_aluno_status_id = 13 and 
		  fnc.status_parcela = 'pago'
		  order by fnc.ra, mac.ano_competencia, mac.mes_competencia

		  select * from #temp where LANC_conta_ID =  1766

BEGIN TRY
BEGIN TRAN

declare @boleto_id int 

declare CUR_ cursor for 
	-------------------------------
	SELECT boleto_id FROM #temp
	-------------------------------

	open CUR_ 
		fetch next from CUR_ into @boleto_id
		while @@FETCH_STATUS = 0
			BEGIN
			     -- #######  INSERIR NA FINANCEIRO_NEGOCIACAO ########
				 insert into financeiro_negociacao (descricao, valor, autorizado_por_id, conta_id, responsavel_id, criado_em, 
				             atualizado_em, criado_por, atualizado_por)
				  select distinct descricao = 'Pagamento - boleto - ' + convert(varchar(20),boleto_id), 
				             valor= tem.valor_pago, autorizado_por_id = 832473, 
							 conta_id = tem.lanc_conta_id, responsavel_id = tem.responsavel_financeiro_id,
						     criado_em = getdate(), atualizado_em = getdate(), criado_por = 2137, atualizado_por = 2137 
					from #temp tem
				  where boleto_id = @boleto_id and 
				        not exists(select 1 from financeiro_negociacao neg 
						            where neg.descricao = 'Pagamento - boleto - ' + convert(varchar(20),tem.boleto_id))
				
			     -- #######  ATUALIZAR OS LANCAMENTOS FINANCEIROS ########
					  update lan set 
							 lan.pago_em = tem.data_pagamento, 
							 lan.valor_pago = round(tem.valor_pago/ (select cast(count(1) as float) from #temp temx where temx.boleto_id = tem.boleto_id),2),
							 lan.status_id = 5 , 
							 lan.negociacao_id = neg.id
					 from #temp tem join financeiro_lancamento lan on (lan.id = tem.lancamento_id)
									 join financeiro_negociacao neg on (neg.descricao = 'Pagamento - boleto - ' + convert(varchar(20),boleto_id))
					  where boleto_id = @boleto_id
				
			fetch next from CUR_ into  @boleto_id
			END
	close CUR_ 
deallocate CUR_ 

 
	-- #######  CRIAR LANCAMENTO BOLETO ########
	insert into financeiro_lancamentoboleto (boleto_id, lancamento_id, pago_em, valor_pago, valor_acrescimos, 
	            valor_descontos, creditado_em, metodo_pagamento_id, negociacao_id, criado_em, atualizado_em, 
				criado_por, atualizado_por)
	select boleto_id = tem.boleto_id, lancamento_id = lan.id, pago_em = lan.pago_em, valor_pago = lan.valor_pago, 
	       valor_acrescimos = lan.valor_acrescimos, valor_descontos = 0, creditado_em = tem.creditado_em, 
		   metodo_pagamento_id = 5, negociacao_id = lan.negociacao_id,
		   criado_em = getdate(), atualizado_em = getdate(), criado_por = 2137, atualizado_por = 2137 
	  from financeiro_lancamento lan join #temp tem on (lan.id = tem.lancamento_id)
	 where lan.status_id = 5 and tem.status_parcela = 'pago' and
	   not exists (select 1 from financeiro_lancamentoboleto bol 
		                where bol.lancamento_id = lan.id)

COMMIT
PRINT 'SUCESSO'
END TRY
BEGIN CATCH
	ROLLBACK
	PRINT ERROR_MESSAGE()
END CATCH
                                                                                                                                                                                                                 ��U S E   [ a t i v i d a d e