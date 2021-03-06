xxxxxxxxxxxxxxxxxxxxxxxxx
-- drop table #temp
select mac.aluno_nome, mac.aluno_ra, mac.curriculo_nome, 
       mac.ano_competencia, mac.mes_competencia, mac.lanc_valor_bruto, fnc.plano_nome,
       fnc.status_parcela, mac.status_lancamento, mac.lanc_conta_id,fnc.data_pagamento, 
       fnc.boleto_id, fnc.valor_pago, mac.responsavel_financeiro_id,lancamento_id, 
	   parcela_valor, lanc_valor_pago, creditado_em = cast(bol.data_pagamento as date)
	 into #temp
	  from VW_FNC_PARCELA_MAT_REM  fnc left join vw_financeiro_macro mac on (fnc.RA collate database_default = mac.aluno_ra collate database_default and
	                                                                         fnc.mes_competencia = mac.mes_competencia and 
																			 fnc.ano_competencia = mac.ano_competencia and
																			 cast(fnc.DATA_VENCIMENTO as date) = cast(mac.parcela_data_vencimento as date))
									   left join boletos_service.DB_OWNER.vw_boleto bol on (bol.boleto_id = fnc.boleto_id)
	where fnc.desconto_id is null and 
	      mac.curriculo_aluno_status_id = 13 and 
	     -- mac.curriculo_aluno_status_id not in (13,19,16) and
		  fnc.status_parcela = 'pago'
		  order by fnc.ra, mac.ano_competencia, mac.mes_competencia

BEGIN TRY
BEGIN TRAN

declare @boleto_id int 

declare CUR_ cursor for 
	-------------------------------
	SELECT distinct boleto_id FROM #temp
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
                          declare @passo varchar(200)

begin try
begin tran 
---#####################################################################################  
--  IMPORTACAO DAS INFORMACOES DE PARCELAS E DESCONTOS DOS ALUNOS (CALOUROS) 
---#####################################################################################
--------------------------------------------------------------------------------------------------------------------
-- ****** INSERIR CONTRATOS 
			--* QUANDO NAO EXISTIR UM RESPONSAVEL CADASTRADO NA PESSOAS_PESSOA, O ALUNO SERA SEU PROPRIO RESPONSAVEL
--------------------------------------------------------------------------------------------------------------------
-- COMMIT 
set @passo = 'contrato'
BEGIN TRAN insert into contratos_contrato (criado_em, atualizado_em, valor, valor_parcela, num_parcelas, num_fiadores, aluno_id, criado_por, curriculo_id, etapa_ano_id, responsavel_financeiro_id, atualizado_por, data_matricula)
select distinct criado_em = getdate(), 
                atualizado_em = getdate(), 
				valor = PAR.VALOR_CONTRATO, valor_parcela = -1, 
				num_parcelas =  PAR.QTD_PARCELA_CONTRATO, 
				num_fiadores = ISNULL(fia.qtd_fiadores,0), 
                aluno_id = alu.id, criado_por = 11717, 
				curriculo_id = CUR.id, etapa_ano_id= null, 
				responsavel_financeiro_id = isnull(pes.id, alu.pessoa_id), 
				atualizado_por = 11717,
				par.data_matricula
  from  academico_aluno alu   join VW_FNC_PARCELA_MAT_REM        par on (par.ra collate database_default = alu.ra collate database_default)
                              JOIN CURRICULOS_CURRICULO          CUR ON (CUR.nome COLLATE DATABASE_DEFAULT = PAR.CURRICULO_NOME COLLATE DATABASE_DEFAULT)
						 LEFT JOIN vw_FNC_responsavel_financeiro rsp on (rsp.ra collate database_default = par.ra collate database_default and 
						                                                 rsp.competencia collate database_default = par.COMPETENCIA collate database_default)
						 left join pessoas_pessoa                pes on (pes.cpf collate database_default = rsp.cpf collate database_default)
                         left join vw_FNC_QTD_fiadores           fia on (par.ra = fia.ra)
  where  
       PAR.GRATUIDADE_ID is null and       
       PAR.DESCONTO_ID is null and               
       PAR.PERIODO_CORRENTE = 1  AND   
	   PAR.STATUS_MATRICULA_ID  = 11 AND 
	  -- PAR.MES_COMPETENCIA = 1 AND 
	   STATUS_PARCELA = 'PAGO' AND
		 not exists (select 1 from contratos_contrato contx
		             where contx.aluno_id =  alu.id  )
 
--####################################################################################
--------------------------------------------------------------------------------------------------------------------
-- ****** INSERIR CONTA PARA TODOS OS CONTRATOS
--------------------------------------------------------------------------------------------------------------------
 set @passo = 'conta'
 insert into financeiro_conta (criado_em, atualizado_em, saldo, criado_por, pessoa_id, atualizado_por, titular_id)
	   select criado_em = getdate(), atualizado_em = getdate(), saldo = 0.0, criado_por = 11717, 
	          pessoa_id = alu.pessoa_id , atualizado_por = 11717, titular_id = ALU.PESSOA_ID  
	     from contratos_contrato con join academico_aluno  alu on (alu.id = con.aluno_id)
	                            left join financeiro_conta fcn on (fcn.pessoa_id = alu.pessoa_id)
where fcn.id is null 
-- ##################################################################################
--------------------------------------------------------------------------------------------------------------------
-- ****** INSERIR PARCELAS REFERENTES A UM CONTRATO 
--------------------------------------------------------------------------------------------------------------------
set @passo = 'inserir parcela'
-- COMMIT 
-- ROLLBACK 
BEGIN TRAN insert into contratos_parcela (criado_em, atualizado_em, descricao, data_vencimento, valor, mes_competencia, ano_competencia, contrato_id, criado_por, tipo_id, atualizado_por)
sewith cte_educat as (
			select aluno_cpf collate database_default  as aluno_cpf, cast(round(sum(carga_horaria),2) as numeric(10,2)) as horas_academicas
			from VW_ATIVIDADE_COMPLEMENTAR_ALUNO
			group by aluno_cpf
) 

	,	cte_atividade as (
			select CPFALUNO collate database_default  as aluno_cpf, cast(round(sum(horcomputada),2) as numeric(10,2)) as horas_academicas, 
			CURSO_NOME collate database_default  as curso_nome
			from atividade..VW_INTEGRACAO_EDUCAT_PARTICIPACAO
			where exportado = 1
			group by cpfaluno,CURSO_NOME
)

			select  pes.aluno_cpf, pes.aluno_ra, pes.aluno_nome, pes.curriculo_aluno_status_nome, pes.curriculo_nome  ,
			       ati.horas_academicas as horas_academicas_atividade,
			       horas_atividade = right('0000'+cast(cast(ati.horas_academicas as int) as varchar(4)),4) + ':' +  right('00'+cast(cast(round(ati.horas_academicas * 60,1)as int) % 60 as varchar(3)),2),
			       edu.horas_academicas as horas_academicas_educat,
			       horas_educat    = right('0000'+cast(cast(edu.horas_academicas as int) as varchar(4)),4) + ':' +  right('00'+cast(cast(round(edu.horas_academicas * 60,1)as int) % 60 as varchar(3)),2)
			
			from cte_atividade ati join vw_Curriculo_aluno_pessoa pes on (ati.aluno_cpf = pes.aluno_cpf and 
			                                                              pes.curriculo_aluno_status_id in  (13,16,14,18) and 
																		  pes.curriculo_nome not in ('CURR�CULO CURSO EXTENS�O EM ORAT�RIA 2020') and 
																		  ati.curso_nome = pes.curso_nome)
			                        left join cte_educat edu on (ati.aluno_cpf = edu.aluno_cpf)
			   
			where edu.aluno_cpf is not null  and 
			      edu.horas_academicas <> ati.horas_academicas 
				  order by pes.aluno_nome




				--  select distinct curriculo_aluno_status_id,curriculo_aluno_status_nome from vw_Curriculo_aluno_pessoa


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        