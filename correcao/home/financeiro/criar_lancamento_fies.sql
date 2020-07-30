
declare @contrato_id int, @percentual_fies float, @percentual_aluno float
set @contrato_id = 815
set @percentual_fies = 80.0

set @percentual_aluno = (100 - @percentual_fies) /100.0
set @percentual_fies  = 1.0 - @percentual_aluno

BEGIN TRY
	BEGIN TRAN

		print '####### INICIANDO O PROCESSO DE APLICACAO DO FIES #######'
		-- ####### lancar as parcelas do fies ##########
		INSERT INTO financeiro_lancamento(criado_em, atualizado_em, criado_por, atualizado_por, contrato_id, ano_competencia, mes_competencia, 
					data_vencimento, pago_em, valor_bruto, valor_liquido, pagamento_por_remessa, conta_id, curriculo_aluno_id, 
					operacao_id, parcela_id, status_id, tipo_id, responsavel_id, justificativa, valor_pago, valor_acrescimos, valor_desconto_pontualidade)
		select criado_em = getdate(), atualizado_em = getdate(), criado_por = 2136, atualizado_por = 2136, lan.contrato_id,
			   lan.ano_competencia, lan.mes_competencia, lan.data_vencimento, lan.pago_em, valor_bruto = PAR.valor * @percentual_fies, valor_liquido = PAR.valor  * @percentual_fies,
			   lan.pagamento_por_remessa, lan.conta_id, lan.curriculo_aluno_id, lan.operacao_id, lan.parcela_id, status_id = 1, lan.tipo_id, 
			   responsavel_id = 782928, justificativa = 'FIES', valor_pago = lan.valor_pago  * @percentual_fies, lan.valor_acrescimos, valor_desconto_pontualidade = 0
		  from contratos_parcela par left join financeiro_lancamento lan on (par.id = lan.parcela_id and 
																			 par.contrato_id = lan.contrato_id) 
		where par.contrato_id = @contrato_id AND 
			  LAN.responsavel_id <> 782928 AND 
			  NOT EXISTS (SELECT 1 FROM financeiro_lancamento LANX 
						   WHERE LANX.curriculo_aluno_id = LAN.curriculo_aluno_id AND 
								 LANX.mes_competencia    = LAN.mes_competencia AND
								 LANX.ano_competencia    = LAN.ano_competencia AND 
								 LANX.responsavel_id     = 782928)

		-- ##### corrigir o valor das parcelas da aluna ########
		  update lan set lan.valor_bruto = lan.valor_bruto * @percentual_aluno, lan.valor_liquido = lan.valor_liquido * @percentual_aluno,
						 lan.valor_pago = lan.valor_pago * @percentual_aluno
		  from contratos_parcela par left join financeiro_lancamento lan on (par.id = lan.parcela_id and 
																			 par.contrato_id = lan.contrato_id) 
		where par.contrato_id = @contrato_id AND 
			  LAN.responsavel_id <> 782928

	COMMIT
	PRINT '##### SUCESSO ####'
END TRY 
BEGIN CATCH
	ROLLBACK 
	PRINT '#### ERRO #### ' + ERROR_MESSAGE()
END CATCH



select * from vw_contrato_parcela_desconto_aluno where contrato_id = 815