
 SELECT * FROM vw_contrato_parcela_desconto_aluno WHERE aluno_ra = '20105.00077' ORDER BY mes_competencia


 select lan.*--, vpar.valor_pago
   --update lan set lan.pago_em = null, lan.status_id = 2, lan.valor_pago = 0.00, lan.valor_acrescimos = 0.00, lan.valor_desconto_pontualidade = 0.00

   from financeiro_lancamento lan join curriculos_aluno cra on (cra.id = lan.curriculo_aluno_id)
                                  join academico_aluno  alu on (alu.id = cra.aluno_id)
								  join contratos_parcela par on (par.id = lan.parcela_id)
								  join VW_FNC_PARCELAS vpar  on (vpar.ra collate database_default = alu.ra collate database_default and 
								                                 cast(vpar.DATA_VENCIMENTO as date) = cast(lan.data_vencimento as date))

  where --alu.ra = '20105.00077' and 
        --par.mes_competencia = 2 and 
		lan.valor_pago > 0 and  vpar.valor_pago is null 

select lan.*--, lan.pago_em = null, lan.status_id = 2, lan.valor_pago = 0.00, lan.valor_acrescimos = 0.00, lan.valor_desconto_pontualidade = 0.00
   from financeiro_lancamento lan join curriculos_aluno cra on (cra.id = lan.curriculo_aluno_id)
                                  join academico_aluno  alu on (alu.id = cra.aluno_id)
								  join contratos_parcela par on (par.id = lan.parcela_id)
								  join VW_FNC_PARCELAS vpar  on (vpar.ra collate database_default = alu.ra collate database_default and 
								                                 cast(vpar.DATA_VENCIMENTO as date) = cast(lan.data_vencimento as date))

  where alu.ra = '20105.00077' and 
        par.mes_competencia = 3



	select * from VW_FNC_PARCELAS where ra = '20105.00077'

	select * from mat_prd..vw_parcelas where ra = '20105.00077'