--begin tran;

with cte_parcela_duplicada as (
			select contrato_id, mes_competencia, ano_competencia--,data_vencimento
			from contratos_parcela 
			where contrato_id not in (1248, 1429, 827)
			group by contrato_id, mes_competencia, ano_competencia--,data_vencimento
			having count(1) > 1
) 
	--  delete  from financeiro_lancamentoboleto where lancamento_id in ( 	
		select *   from financeiro_lancamento where parcela_id in (
			select par.id 
			  from contratos_parcela par join cte_parcela_duplicada cte on (cte.contrato_id = par.contrato_id and
																				   cte.mes_competencia = par.mes_competencia and 
																				   cte.ano_competencia = par.ano_competencia)
											    join contratos_contrato    con on (con.id = par.contrato_id)
												join vw_Curriculo_aluno_pessoa pes on (pes.aluno_id = con.aluno_id and 
												                                       pes.curriculo_id = con.curriculo_id)
										   left join VW_FNC_PARCELAS           vwp on (vwp.ra collate database_default = pes.aluno_ra collate database_default and 
										                                               vwp.mes_competencia = par.mes_competencia and 
																					   vwp.ano_competencia = par.ano_competencia and 
																					   cast(vwp.DATA_VENCIMENTO as date) = cast(par.data_vencimento as date))
			  where    vwp.valor is null 
	  )
--  )
	--		order by par.ano_competencia, par.mes_competencia, par.id

	begin tran 
	  delete from financeiro_desconto where desconto_contrato_id = 1071
	  delete  from contratos_desconto where parcela_id = 10480
	  delete  from financeiro_lancamento where parcela_id = 10480
	  delete  from contratos_parcela where id in (10480)



	select *   from contratos_desconto where parcela_id in (10480)
	select * from financeiro_lancamento where id = 7627
	select id from contratos_parcela where contrato_id in (29) and mes_competencia = 1
	)

	-- commit 
	-- rollback

	select * delete from financeiro_desconto where desconto_contrato_id = 1071
--	select * from VW_FNC_PARCELAS where 




select * from vw_contrato_parcela_desconto_aluno
where parcela_id in (10479, 
10480)