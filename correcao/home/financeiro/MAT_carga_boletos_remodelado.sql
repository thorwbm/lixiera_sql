CREATE OR ALTER PROCEDURE SP_CARGA_MATRICULA_REMATRICULA AS 
SET NOCOUNT ON; 

declare @passo varchar(200), @lancamento_id int, @lancamentoboleto_id int,
@negociacao_id int, @descricao_atual varchar(max), @descricao_nova varchar(max)

DECLARE @DATAEXECUCAO DATETIME
SET @DATAEXECUCAO = CAST( CONVERT(VARCHAR(19),GETDATE(),120) AS DATETIME)
print @DATAEXECUCAO
print CONVERT(VARCHAR(19),GETDATE(),120)

IF object_id('tempdb..#TEMP') IS NOT NULL 
	BEGIN
		 DROP TABLE #TEMP
	END;

begin try
begin tran 
---#####################################################################################  
--  IMPORTACAO DAS INFORMACOES DE PARCELAS E DESCONTOS DOS ALUNOS (CALOUROS) 
---#####################################################################################
--------------------------------------------------------------------------------------------------------------------
-- ****** INSERIR CONTRATOS 
			--* QUANDO NAO EXISTIR UM RESPONSAVEL CADASTRADO NA PESSOAS_PESSOA, O ALUNO SERA SEU PROPRIO RESPONSAVEL
--------------------------------------------------------------------------------------------------------------------
-- select * from contratos_contrato
-- COMMIT 
set @passo = 'INSERIR CONTRATO'

 insert into contratos_contrato (criado_em, atualizado_em, valor, valor_parcela, num_parcelas, num_fiadores, 
                       aluno_id, criado_por, curriculo_id, etapa_ano_id, responsavel_financeiro_id, atualizado_por, 
					   data_matricula, vigente, tipo_id,descricao)
select distinct criado_em = @DATAEXECUCAO, 
                atualizado_em = @DATAEXECUCAO, 
				valor = PAR.VALOR_CONTRATO, valor_parcela = -1, 
				num_parcelas =  PAR.QTD_PARCELA_CONTRATO, 
				num_fiadores = ISNULL(fia.qtd_fiadores,0), 
                aluno_id = alu.id, criado_por = 11717, 
				curriculo_id = CUR.id, etapa_ano_id= null, 
				responsavel_financeiro_id = isnull(pes.id, alu.pessoa_id), 
				atualizado_por = 11717,
				par.data_matricula, vigente = 1, tipo_id = 1, DESCRICAO = 'Contrato de Matrícula'
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
	   PAR.STATUS_MATRICULA_ID  = 6 AND 
	   PAR.status_matricula_nome = 'FINALIZADO' AND 
	   STATUS_PARCELA = 'PAGO' AND
		 not exists (select 1 from contratos_contrato contx
		             where contx.aluno_id =  alu.id and 
					       contx.curriculo_id = CUR.id)
 
 -- GERAR LOG
 EXEC SP_GERAR_LOG_EM_LOTE_INSERT 'CONTRATOS_CONTRATO', @DATAEXECUCAO

--####################################################################################
--------------------------------------------------------------------------------------------------------------------
-- ****** INSERIR CONTA PARA TODOS OS CONTRATOS
--------------------------------------------------------------------------------------------------------------------
 set @passo = 'INSERIR CONTA'
 insert into financeiro_conta (criado_em, atualizado_em, saldo, criado_por, pessoa_id, atualizado_por, titular_id)
	   select criado_em = @DATAEXECUCAO, atualizado_em = @DATAEXECUCAO, saldo = 0.0, criado_por = 11717, 
	          pessoa_id = alu.pessoa_id , atualizado_por = 11717, titular_id = ALU.PESSOA_ID  
	     from contratos_contrato con join academico_aluno  alu on (alu.id = con.aluno_id)
	                            left join financeiro_conta fcn on (fcn.pessoa_id = alu.pessoa_id)
where fcn.id is null 
 
 -- GERAR LOG
 EXEC SP_GERAR_LOG_EM_LOTE_INSERT 'FINANCEIRO_CONTA', @DATAEXECUCAO

-- ##################################################################################
--------------------------------------------------------------------------------------------------------------------
-- ****** INSERIR RESPONSAVEIS FINANCEIROS
--------------------------------------------------------------------------------------------------------------------
        -- BUSCA TODOS OS ALUNOS QUE POSSUEM BOLSAS (PROUNI, FIES, CAIXA) E QUE NAO POSSUEM REGISTRO DESTES 
		-- NA TABELA FINANCEIRO_RESPONSAVEL E INSERE ESTE REGISTRO
		EXEC SP_FNC_INSERIR_RESPONSAVEL_BOLSA 

		-- TODO ALUNO PRECISA POSSUIR PELO UM RESPONSAVEL FINANCEIRO QUE NAO SEJA RESPONSAVEIS (BOLSA) ENTAO 
		-- E PEGO OS RESPOSAVES CADASTRADOS NA MATRICULA/REMATRICULA E CASO NAO TENHAM SERA O PROPRIO ALUNO
		EXEC SP_FNC_INSERIR_RESPONSAVEL_NORMAL

-- ##################################################################################
--------------------------------------------------------------------------------------------------------------------
-- ****** INSERIR PARCELAS REFERENTES A UM CONTRATO 
--------------------------------------------------------------------------------------------------------------------
set @passo = 'INSERIR PARCELA'
 
insert into contratos_parcela (criado_em, atualizado_em, descricao, data_vencimento, valor, mes_competencia, ano_competencia, contrato_id, criado_por, tipo_id, atualizado_por)
select criado_em       = @DATAEXECUCAO, 
       atualizado_em   = @DATAEXECUCAO, 
       descricao       = 'parcela mes ' + par.competencia, 
	   data_vencimento = par.data_vencimento, valor = par.VALOR, 
       mes_competencia = par.mes_competencia, 
	   ano_competencia = par.ano_competencia, 
	   contrato_id     = con.id, criado_por = 11717,
	   tipo_id         = case when par.transacao_tipo_id in (1,3) then 2 
	                          when par.transacao_tipo_id in (2,4) then 1 end, 
	   atualizado_por  = 11717
         from contratos_contrato con join vw_Curriculo_aluno_pessoa pes on (con.aluno_id = pes.aluno_id and 
		                                                                    con.curriculo_id = pes.curriculo_id and 
																			con.tipo_id = 1)
                                     join VW_FNC_PARCELA_MAT_REM par on (pes.aluno_ra       collate database_default = par.ra             collate database_default and 
									                                     pes.curriculo_nome collate database_default = par.CURRICULO_NOME collate database_default )
        where
		   PAR.GRATUIDADE_ID is null and       
		   PAR.DESCONTO_ID is null and               
		   PAR.PERIODO_CORRENTE = 1  AND   
		   PAR.STATUS_MATRICULA_NOME  = 'FINALIZADO' AND 
			 not exists (select 1 from contratos_parcela parx
								 where parx.contrato_id     = con.id and
									   parx.mes_competencia = par.mes_competencia and
									   parx.ano_competencia = par.ano_competencia)
 
 -- GERAR LOG
 EXEC SP_GERAR_LOG_EM_LOTE_INSERT 'CONTRATOS_PARCELA', @DATAEXECUCAO

-- ##########################################################
--------------------------------------------------------------------------------------------------------------------
-- ****** INSERIR DESCONTOS REFERENTES A UMA PARCELA 
--------------------------------------------------------------------------------------------------------------------
set @passo = 'INSERIR DESCONTO'

  DECLARE @DATAEXECUCAO DATETIME
SET @DATAEXECUCAO = CAST( CONVERT(VARCHAR(19),GETDATE(),120) AS DATETIME)

 -- COMMIT 
 -- ROLLBACK 

BEGIN TRAN 
insert into     contratos_desconto ( descricao, porcentagem, valor, parcela_id, tipo_id, criado_em, criado_por, atualizado_em, atualizado_por)
select 
	descricao = 'desconto ' + DES.COMPETENCIA, porcentagem = null, valor = des.valor, parcela_id = par.id, 
    tipo_id = tpd.id, 
    criado_em = @DATAEXECUCAO, criado_por = 11717, 
	atualizado_em = @DATAEXECUCAO, atualizado_por = 11717
  from   
    contratos_contrato con join vw_Curriculo_aluno_pessoa pes on (con.aluno_id = pes.aluno_id and 
		                                                         con.curriculo_id = pes.curriculo_id and 
																 con.tipo_id = 1)
                           join VW_FNC_DESCONTO_MAT_REM   des on (pes.aluno_ra collate database_default = des.ra collate database_default)
						   join contratos_parcela         par on (par.contrato_id = con.id and 
						                                          par.mes_competencia = des.mes_competencia and
									     		                  par.ano_competencia = des.ano_competencia)
						   join DESCONTO_PORTAL_MATRICULA dpd on (dpd.desconto_matricula collate database_default = des.desconto_nome collate database_default )
					       join contratos_tipodesconto    tpd on (tpd.descricao = dpd.DESCONTO_PORTAL)
 where 
    des.GRATUIDADE_ID IS NULL AND 
	des.matricula_status_nome = 'finalizado' AND 
	des.PERIODO_CORRENTE = 1 AND 
    isnull(des.pessoa_prouni,0) = 0 AND 
    not exists (select 1  
	              from 
				    contratos_desconto desx  
				 where 
				    desx.parcela_id = par.id and 
				    desx.valor      = des.valor and
					desx.tipo_id    = tpd.id)
 
 -- GERAR LOG
 EXEC SP_GERAR_LOG_EM_LOTE_INSERT 'CONTRATOS_DESCONTO', @DATAEXECUCAO	

-- ##########################################################
--------------------------------------------------------------------------------------------------------------------
-- ****** INSERIR LANCAMENTOS REFERENTES A UMA PARCELA  DESDE QUE JA NAO EXISTA
--------------------------------------------------------------------------------------------------------------------
set @passo = 'INSERIR LANCAMENTO'

  DECLARE @DATAEXECUCAO DATETIME
SET @DATAEXECUCAO = CAST( CONVERT(VARCHAR(19),GETDATE(),120) AS DATETIME)

 -- COMMIT 
 -- ROLLBACK 

 BEGIN TRAN
insert into 
    financeiro_lancamento (criado_em, atualizado_em, mes_competencia, ano_competencia, data_vencimento, pago_em, valor_bruto, valor_liquido, 
                           pagamento_por_remessa, conta_id, contrato_id, criado_por, curriculo_aluno_id, operacao_id, parcela_id, protocolo_id, 
                           status_id, tipo_id, atualizado_por, extra, responsavel_id, valor_pago, valor_acrescimos,valor_desconto_pontualidade)
select distinct 
    criado_em = @DATAEXECUCAO, atualizado_em = @DATAEXECUCAO, par.mes_competencia, par.ano_competencia, par.data_vencimento, pago_em = PRX.data_pagamento, 
	valor_bruto = par.valor , valor_liquido = par.valor - sum( isnull(dsc.valor,0)) , pagamento_por_remessa = 1, conta_id = fnc.id, par.contrato_id, 
	criado_por = 11717, curriculo_aluno_id = cra.curriculo_aluno_id, operacao_id = 2, parcela_id = par.id, protocolo_id= null , 
	status_id = case when PRX.status_parcela = 'PAGO' THEN 5 ELSE 1 END ,
	tipo_id = case when PRX.transacao_tipo_id in (1,3) then 2 
	               when PRX.transacao_tipo_id in (2,4) then 1 end,
	atualizado_por = 11717, extra = null, responsavel_id = con.responsavel_financeiro_id, 
	valor_pago = isnull(prx.valor_pago,0), valor_acrescimos=0,valor_desconto_pontualidade =0

  from 
    contratos_parcela par join contratos_contrato            con on (con.id = par.contrato_id and 
                                                                     con.tipo_id = 1)
						  join vw_Curriculo_aluno_pessoa     cra on (con.aluno_id = cra.aluno_id and
					  	                                             con.curriculo_id = cra.curriculo_id)
						  JOIN VW_FNC_PARCELA_MAT_REM        PRX ON (PRX.RA collate database_default = cra.aluno_ra collate database_default AND 
						                                             par.mes_competencia = PRX.mes_competencia and
                                                                     par.ano_competencia = PRX.ano_competencia and
						 								             prx.status_matricula_nome = 'finalizado' and 
														             prx.desconto_id is null and 
														             prx.gratuidade_id is null )
                     left join financeiro_lancamento         lan on (par.id = lan.parcela_id)
                     left join contratos_desconto            dsc on (par.id = dsc.parcela_id)
					 left join financeiro_conta              fnc on (fnc.pessoa_id = cra.pessoa_id)
							 
 where lan.id is null   
 group by 
    par.mes_competencia, par.ano_competencia, par.data_vencimento, PRX.data_pagamento, par.valor, fnc.id, par.contrato_id,  
	cra.curriculo_aluno_id, par.id, PRX.status_parcela,con.responsavel_financeiro_id, prx.valor_pago, PRX.transacao_tipo_id
 
 -- GERAR LOG
 EXEC SP_GERAR_LOG_EM_LOTE_INSERT 'FINANCEIRO_LANCAMENTO', @DATAEXECUCAO
 
-- ##########################################################
--------------------------------------------------------------------------------------------------------------------
-- ****** INSERIR FINANCEIRO DESCONTO
--------------------------------------------------------------------------------------------------------------------
set @passo = 'INSERIR FINANCEIRO DESCONTO'

  DECLARE @DATAEXECUCAO DATETIME
SET @DATAEXECUCAO = CAST( CONVERT(VARCHAR(19),GETDATE(),120) AS DATETIME)

 -- COMMIT 
 -- ROLLBACK 

 BEGIN TRAN
INSERT INTO 
    FINANCEIRO_DESCONTO (descricao, porcentagem, valor, data_validade, lancamento_id, desconto_contrato_id, 
	                     tipo_id, criado_em, atualizado_em, criado_por, atualizado_por)
 select 
     descricao = ctd.descricao, porcentagem = ctd.porcentagem, valor = ctd.valor, data_validade = null, 
	 lancamento_id = lan.id, desconto_contrato_id = ctd.id, tipo_id = ctd.tipo_id,
     criado_em = @DATAEXECUCAO, atualizado_em = @DATAEXECUCAO, criado_por = 11717, atualizado_por = 11717
   from 
	 contratos_desconto ctd join contratos_parcela     par on (par.id = ctd.parcela_id)
	                        join financeiro_lancamento lan on (par.id = lan.parcela_id)
	                   left join financeiro_desconto fnd on (ctd.id = fnd.desconto_contrato_id)
  where 
     fnd.id is null 

 -- GERAR LOG
 EXEC SP_GERAR_LOG_EM_LOTE_INSERT 'FINANCEIRO_DESCONTO', @DATAEXECUCAO

-- ##########################################################
--------------------------------------------------------------------------------------------------------------------
-- ****** INSERIR FINANCEIRO LANCAMENTO BOLETO 
--------------------------------------------------------------------------------------------------------------------
set @passo = 'INSERIR FINANCEIRO BOLETO'

  DECLARE @DATAEXECUCAO DATETIME
SET @DATAEXECUCAO = CAST( CONVERT(VARCHAR(19),GETDATE(),120) AS DATETIME)

 -- COMMIT 
 -- ROLLBACK 

 BEGIN TRAN
 INSERT INTO 
     FINANCEIRO_LANCAMENTOBOLETO (BOLETO_ID, LANCAMENTO_ID, PAGO_EM, VALOR_PAGO, valor_acrescimos, VALOR_DESCONTOS, 
	                              BANCO, METODO_PAGAMENTO_ID, NEGOCIACAO_ID, criado_em, atualizado_em, criado_por, atualizado_por)
 select 
     BOLETO_ID = PAR.BOLETO_ID, LANCAMENTO_ID = LAN.ID, PAGO_EM = LAN.pago_em, VALOR_PAGO = LAN.VALOR_PAGO, 
	 valor_acrescimos = LAN.valor_acrescimos,VALOR_DESCONTOS = 0, BANCO = LAN.BANCO,
	 METODO_PAGAMENTO_ID = 5, NEGOCIACAO_ID = LAN.NEGOCIACAO_ID,
     criado_em = getdate(), atualizado_em = getdate(), criado_por = 11717, atualizado_por = 11717
   from 
     financeiro_lancamento lan join contratos_contrato        con on (con.id = lan.contrato_id)
                               join vw_Curriculo_aluno_pessoa pes on (pes.curriculo_id = con.curriculo_id and
	 						                                          pes.aluno_id     = con.aluno_id     and
	 																  con.tipo_id      =	1)
                               join VW_FNC_PARCELA_MAT_REM    par on (par.ra collate database_default   = pes.aluno_ra collate database_default and
	 						                                          par.ano_competencia               = lan.ano_competencia and
	 																  par.mes_competencia               = lan.mes_competencia and
	 																  cast(par.DATA_VENCIMENTO as date) = cast(lan.data_vencimento as date) and
	 																  par.desconto_id is null and 
																	  par.status_matricula_nome = 'finalizado' and 
	 																  par.status_parcela = 'pago') 
	                      LEFT JOIN FINANCEIRO_LANCAMENTOBOLETO FLB ON (LAN.ID = FLB.LANCAMENTO_ID)
  where 
     LAN.STATUS_ID = 5 AND 
     FLB.id is null  

 -- GERAR LOG
 EXEC SP_GERAR_LOG_EM_LOTE_INSERT 'FINANCEIRO_LANCAMENTOBOLETO', @DATAEXECUCAO

-- #####################################################################################################
--------------------------------------------------------------------------------------------------------
-- INSERIR A NEGOCIACAO 
--------------------------------------------------------------------------------------------------------
set @passo = 'INSERIR NEGOCIACAO'
  DECLARE @DATAEXECUCAO DATETIME
SET @DATAEXECUCAO = CAST( CONVERT(VARCHAR(19),GETDATE(),120) AS DATETIME)

 -- COMMIT 
 -- ROLLBACK 
/*
 BEGIN TRAN
INSERT INTO 
    FINANCEIRO_NEGOCIACAO (descricao, valor, conta_id, responsavel_id, criado_em, atualizado_em, criado_por, atualizado_por)    */
select 
    descricao = 'Pagamento - boleto - ' +  convert(varchar(10),par.boleto_id), 
	valor = par.valor_pago,
	conta_id = lan.conta_id,
	responsavel_id = lan.responsavel_id, 
	criado_em = @DATAEXECUCAO, atualizado_em = @DATAEXECUCAO, criado_por = 11717, atualizado_por = 11717
  from 
    financeiro_lancamento lan join contratos_contrato        con on (con.id = lan.contrato_id)
                              join vw_Curriculo_aluno_pessoa pes on (pes.curriculo_id = con.curriculo_id and
							                                         pes.aluno_id     = con.aluno_id     and
																	 con.tipo_id      =	1)
                              join VW_FNC_PARCELA_MAT_REM    par on (par.ra collate database_default   = pes.aluno_ra collate database_default and
							                                         par.ano_competencia               = lan.ano_competencia and
																	 par.mes_competencia               = lan.mes_competencia and
																	 cast(par.DATA_VENCIMENTO as date) = cast(lan.data_vencimento as date) and
																	 par.desconto_id is null and par.status_matricula_nome = 'finalizado' and 
																	 par.plano_nome <> 'mensal' and par.status_parcela = 'pago')
 where lan.status_id = 5 and 
       par.boleto_id is not null and 
	   not exists (select top 1 1 from financeiro_negociacao negx where negx.descricao = 'Pagamento - boleto - ' +  convert(varchar(10),par.boleto_id))

 -- GERAR LOG
 EXEC SP_GERAR_LOG_EM_LOTE_INSERT 'FINANCEIRO_NEGOCIACAO', @DATAEXECUCAO

-- #####################################################################################################
--------------------------------------------------------------------------------------------------------
-- ATUALIZAR LANCAMENTO COM BASE NA NEGOCIACAO
--------------------------------------------------------------------------------------------------------
set @passo = 'ATUALIZAR LANCAMENTO COM BASE NA NEGOCIACAO'

  select lan.id as lancamento_id, neg.id as negociacao_id 
         into #tmp_lancamento
  from 
    financeiro_lancamento lan join contratos_contrato        con on (con.id = lan.contrato_id AND 
	                                                                 LAN.negociacao_id IS NULL)
                              join vw_Curriculo_aluno_pessoa pes on (pes.curriculo_id = con.curriculo_id and
							                                         pes.aluno_id     = con.aluno_id     and
																	 con.tipo_id      =	1)
                              join VW_FNC_PARCELA_MAT_REM    par on (par.ra collate database_default   = pes.aluno_ra collate database_default and
							                                         par.ano_competencia               = lan.ano_competencia and
																	 par.mes_competencia               = lan.mes_competencia and
																	 cast(par.DATA_VENCIMENTO as date) = cast(lan.data_vencimento as date) and
																	 par.desconto_id is null and par.status_matricula_nome = 'finalizado' and 
																	 par.plano_nome <> 'mensal' and par.status_parcela = 'pago')
							 JOIN FINANCEIRO_NEGOCIACAO      NEG ON (NEG.DESCRICAO = 'Pagamento - boleto - ' +  convert(varchar(10),par.boleto_id))
 where lan.status_id = 5 and 
       par.boleto_id is not null AND LAN.negociacao_id IS NULL 

 -- GERAR LOG
---------------------------------------------------------------------------------
declare CUR_lanc cursor for 
	SELECT lancamento_id, negociacao_id FROM #tmp_lancamento
	open CUR_lanc 
		fetch next from CUR_lanc into @lancamento_id
		while @@FETCH_STATUS = 0
			BEGIN
				
				exec SP_GERAR_LOG 'financeiro_lancamento', @lancamento_id, '~',11717, NULL, NULL, NULL

			fetch next from CUR_lanc into @lancamento_id
			END
	close CUR_lanc 
deallocate CUR_lanc 
--------------------------------------------------------------------------------- 
	   UPDATE LAN SET
              LAN.valor_pago = LAN.valor_liquido, 
	          LAN.negociacao_id = tmp.negociacao_id
	   from financeiro_lancamento lan join #tmp_lancamento tmp on (lan.id = tmp.lancamento_id)

-- #####################################################################################################
--------------------------------------------------------------------------------------------------------
-- ATUALIZAR LANCAMENTO BOLETO COM BASE NA NEGOCIACAO
--------------------------------------------------------------------------------------------------------
set @passo = 'ATUALIZAR BOLETO COM BASE NA NEGOCIACAO'

  select lcb.id as lancamentoboleto_id, neg.id as negociacao_id 
         into #tmp_lancamentoboleto
  from 
    financeiro_lancamento lan join contratos_contrato        con on (con.id = lan.contrato_id AND 
	                                                                 LAN.negociacao_id IS NULL)
                              join vw_Curriculo_aluno_pessoa pes on (pes.curriculo_id = con.curriculo_id and
							                                         pes.aluno_id     = con.aluno_id     and
																	 con.tipo_id      =	1)
                              join VW_FNC_PARCELA_MAT_REM    par on (par.ra collate database_default   = pes.aluno_ra collate database_default and
							                                         par.ano_competencia               = lan.ano_competencia and
																	 par.mes_competencia               = lan.mes_competencia and
																	 cast(par.DATA_VENCIMENTO as date) = cast(lan.data_vencimento as date) and
																	 par.desconto_id is null and par.status_matricula_nome = 'finalizado' and 
																	 par.plano_nome <> 'mensal' and par.status_parcela = 'pago')
							 JOIN FINANCEIRO_NEGOCIACAO      NEG ON (NEG.DESCRICAO = 'Pagamento - boleto - ' +  convert(varchar(10),par.boleto_id))
							 join financeiro_lancamentoBoleto lcb on (lan.id = lcb.lancamento_id)
 where lan.status_id = 5 and 
       par.boleto_id is not null AND LAN.negociacao_id IS NULL 

 -- GERAR LOG
---------------------------------------------------------------------------------
declare CUR_lancbol cursor for 
	SELECT lancamentoboleto_id FROM #tmp_lancamentoboleto
	open CUR_lancbol 
		fetch next from CUR_lancbol into @lancamentoboleto_id
		while @@FETCH_STATUS = 0
			BEGIN
				exec SP_GERAR_LOG 'financeiro_lancamentoboleto', @lancamentoboleto_id, '~',11717, NULL, NULL, NULL

			fetch next from CUR_lancbol into  @lancamentoboleto_id
			END
	close CUR_lancbol 
deallocate CUR_lancbol 
---------------------------------------------------------------------------------
	   UPDATE lac SET lac.negociacao_id = tmp.negociacao_id
	   from financeiro_lancamentoboleto lac join #tmp_lancamentoboleto tmp on (lac.id = tmp.lancamentoboleto_id)
	   
-- #####################################################################################################
--------------------------------------------------------------------------------------------------------
-- ATUALIZAR DECRICAO NA NEGOCIACAO
--------------------------------------------------------------------------------------------------------
set @passo = 'ATUALIZAR DECRICAO NA NEGOCIACAO'


  select neg.id as negociacao_id, negociacao_descricao = PAR.plano_nome + ' - Pagamento - boleto - ' +  convert(varchar(10),par.boleto_id)
         into #tmp_negociacao
  FROM
    FINANCEIRO_NEGOCIACAO NEG JOIN FINANCEIRO_LANCAMENTO       LAN ON (NEG.ID = LAN.NEGOCIACAO_ID)
	                          JOIN FINANCEIRO_LANCAMENTOBOLETO FLC ON (NEG.ID = FLC.NEGOCIACAO_ID)
                              JOIN VW_FNC_PARCELA_MAT_REM      PAR ON (NEG.DESCRICAO = 'Pagamento - boleto - ' +  convert(varchar(10),par.boleto_id))

 -- GERAR LOG
---------------------------------------------------------------------------------
declare CUR_neg cursor for 
	SELECT negociacao_id FROM #tmp_negociacao
	open CUR_neg 
		fetch next from CUR_neg into @negociacao_id
		while @@FETCH_STATUS = 0
			BEGIN
				
				exec SP_GERAR_LOG 'financeiro_negociacao', @negociacao_id, '~',11717, NULL, NULL, NULL

			fetch next from CUR_neg into  @negociacao_id
			END
	close CUR_neg 
deallocate CUR_neg 
---------------------------------------------------------------------------------
  UPDATE NEG SET NEG.DESCRICAO = tmp.negociacao_descricao 
  from financeiro_negociacao neg join #tmp_negociacao tmp on (neg.id = tmp.negociacao_descricao)



commit
print ('PROCESSO FINALIZADO COM SUCESSO !!!')
end try 
begin catch

	rollback 
	 print @passo + ' ### ' + ERROR_MESSAGE()

end catch 

SET NOCOUNT OFF;  
