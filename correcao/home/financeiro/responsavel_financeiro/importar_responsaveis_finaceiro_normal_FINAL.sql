CREATE OR ALTER PROCEDURE SP_FNC_INSERIR_RESPONSAVEL_NORMAL AS

DECLARE @DATAEXECUCAO DATETIME
SET @DATAEXECUCAO = CAST( CONVERT(VARCHAR(19),GETDATE(),120) AS DATETIME)

IF object_id('tempdb..#TEMP') IS NOT NULL 
	BEGIN
		 DROP TABLE #TEMP
	END;

begin try
begin tran;
with cte_responsaveis_prd as (
select distinct aluno_ra, prs.cpf, con.id as contrato_id
  from financeiro_conta con join vw_Curriculo_aluno_pessoa pes on (pes.pessoa_id = con.pessoa_id)
                            join financeiro_responsavel    res on (con.id = res.conta_id)
					        join pessoas_pessoa            prs on (prs.id = res.responsavel_id)
) 
	,	cte_responsaveis_mat_rem as (
	SELECT distinct ra collate database_default as aluno_ra, replace(replace(PESSOA_CPF,'.',''),'-','') collate database_default as responsavel_cpf 
	  FROM VW_FNC_PARCELA_MAT_REM where desconto_id is null and origem = 'rematricula' union 

	 SELECT distinct ALUNO_RA collate database_default as aluno_ra, replace(replace(responsavel_cpf,'.',''),'-','') collate database_default as responsavel_cpf
	   FROM MAT_PRD..VW_RESPONSAVEL_FINANCEIRO_MATRICULA
)
	
select criado_em = @DATAEXECUCAO, criado_por = 11717, atualizado_em = @DATAEXECUCAO, atualizado_por = 11717, conta_id = con.id, responsavel_id = pes.id, mtr.responsavel_cpf
INTO #TEMP
 from cte_responsaveis_mat_rem mtr left join cte_responsaveis_prd prd on (mtr.aluno_ra = prd.aluno_ra and 
                                                                          mtr.responsavel_cpf = prd.cpf)
								        join vw_Curriculo_aluno_pessoa cap on (cap.aluno_ra = mtr.aluno_ra)
										join financeiro_conta          con on (con.pessoa_id = cap.pessoa_id)
								  left	join pessoas_pessoa            pes on (pes.cpf = mtr.responsavel_cpf)
where prd.aluno_ra is null 

 ------- INSERIR OS RESPONSAVEIS FINANCEIROS NA PESSOAS_PESSOA -----
INSERT INTO PESSOAS_PESSOA (criado_em, criado_por, atualizado_em, atualizado_por, RG, NOME_CIVIL, NOME, CPF, ESTADO_CIVIL_ID)
select criado_em = @DATAEXECUCAO, criado_por = 11717, atualizado_em = @DATAEXECUCAO, atualizado_por = 11717, 
       RFM.responsavel_rg AS RG, RFM.responsavel_nome AS NOME_CIVIL, RFM.responsavel_nome AS NOME, 
	   RFM.responsavel_cpf AS CPF, RFM.responsavel_estado_civil_id AS ESTADO_CIVIL_ID
from mat_prd..VW_RESPONSAVEL_FINANCEIRO_MATRICULA RFM JOIN #TEMP TEM ON (RFM.responsavel_cpf collate database_default = TEM.responsavel_cpf)
                                                 LEFT JOIN PESSOAS_PESSOA PES ON (PES.CPF = TEM.responsavel_cpf)
 WHERE PES.ID IS NULL 

 -- GERAR LOG
 EXEC SP_GERAR_LOG_EM_LOTE_INSERT 'PESSOAS_PESSOA', @DATAEXECUCAO

 --------------------- ADICIONAR ENDERECO AOS RESPONSAVEIS FINANCEIROS -------------
 insert into PESSOAS_ENDERECO (criado_em, criado_por, atualizado_em, atualizado_por, logradouro, numero, complemento, 
                               bairro, cep, endereco_cobranca, tipo_endereco_id, cidade_id, pessoa_id, endereco_principal)
 select criado_em = @DATAEXECUCAO, criado_por = 11717, atualizado_em = @DATAEXECUCAO, atualizado_por = 11717,
        logradouro = rfm.responsavel_end_logradouro collate database_default, numero = rfm.responsavel_end_numero, 
		complemento = rfm.responsavel_end_complemento collate database_default, bairro = rfm.responsavel_end_bairro collate database_default, 
		cep = responsavel_end_cep collate database_default,endereco_cobranca = 0, tipo_endereco_id = 1, cidade_id = cid.id, 
		pessoa_id = pes.id, endereco_principal = 1
 from mat_prd..VW_RESPONSAVEL_FINANCEIRO_MATRICULA RFM JOIN #TEMP TEM ON (RFM.responsavel_cpf collate database_default = TEM.responsavel_cpf)
                                                       JOIN PESSOAS_PESSOA   PES ON (PES.CPF = TEM.responsavel_cpf)
												  left join pessoas_endereco edr on (pes.id = edr.pessoa_id and
												                                     edr.logradouro = rfm.responsavel_end_logradouro collate database_default and
																					 edr.numero = rfm.responsavel_end_numero collate database_default and 
																					 edr.bairro = rfm.responsavel_end_bairro collate database_default)
												  left join cidades_cidade   cid on (cid.nome = rfm.responsavel_end_cidade collate database_default)
 WHERE edr.ID IS NULL

 -- GERAR LOG 
 EXEC SP_GERAR_LOG_EM_LOTE_INSERT 'PESSOAS_ENDERECO', @DATAEXECUCAO

 --------------------- ADICIONAR TELEFONE AOS RESPONSAVEIS FINANCEIROS -------------
 insert into PESSOAS_TELEFONE (numero, principal, pessoa_id, tipo_id)
 select numero = rfm.responsavel_telefone, principal = 0, pessoa_id = pes.id, 
        tipo_id = (case when rfm.responsavel_telefone like '%)9%' then 3 else 1 end)
   from mat_prd..VW_RESPONSAVEL_FINANCEIRO_MATRICULA RFM JOIN #TEMP TEM ON (RFM.responsavel_cpf collate database_default = TEM.responsavel_cpf)
                                                    LEFT JOIN PESSOAS_PESSOA   PES ON (PES.CPF = TEM.responsavel_cpf)
												    LEFT JOIN PESSOAS_TELEFONE TEL ON (PES.ID = TEL.PESSOA_ID AND 
												                                       tel.numero = rfm.responsavel_telefone collate database_default AND 
																					   LEN(RFM.responsavel_telefone) > 8)
 WHERE tel.id IS NULL and 
       rfm.responsavel_telefone <> ''  and 
       rfm.responsavel_telefone is not null   
 union
  select numero = rfm.responsavel_telefone_extra, principal = 0, pessoa_id = pes.id, 
        tipo_id = (case when rfm.responsavel_telefone_extra like '%)9%' then 3 else 1 end)
   from mat_prd..VW_RESPONSAVEL_FINANCEIRO_MATRICULA RFM JOIN #TEMP TEM ON (RFM.responsavel_cpf collate database_default = TEM.responsavel_cpf)
                                                    LEFT JOIN PESSOAS_PESSOA   PES ON (PES.CPF = TEM.responsavel_cpf)
												    LEFT JOIN PESSOAS_TELEFONE TEL ON (PES.ID = TEL.PESSOA_ID AND 
												                                       tel.numero = rfm.responsavel_telefone_extra collate database_default AND 
													 								   LEN(RFM.responsavel_telefone_extra) > 8)
 WHERE tel.id IS NULL and 
       rfm.responsavel_telefone_extra <> ''  and 
       rfm.responsavel_telefone_extra is not null 

 -- GERAR LOG  ****** nao em tabela de log
--  EXEC SP_GERAR_LOG_EM_LOTE_INSERT 'PESSOAS_TELEFONE', @DATAEXECUCAO -- NAO EXISTE TABELA DE LOG PARA PESSOAS_TELEFONE


 --------------------- ADICIONAR OS RESPONSAVEIS FINANCEIROS -------------
 INSERT INTO FINANCEIRO_RESPONSAVEL (criado_em, criado_por, atualizado_em, atualizado_por, CONTA_ID, RESPONSAVEL_ID)
 SELECT criado_em = @DATAEXECUCAO, criado_por = 11717, atualizado_em = @DATAEXECUCAO, atualizado_por = 11717, TEM.CONTA_ID, RESPONSAVEL_ID = PES.ID 
   from mat_prd..VW_RESPONSAVEL_FINANCEIRO_MATRICULA RFM JOIN #TEMP TEM ON (RFM.responsavel_cpf collate database_default = TEM.responsavel_cpf)
                                                    LEFT JOIN PESSOAS_PESSOA   PES ON (PES.CPF = TEM.responsavel_cpf)
													LEFT JOIN financeiro_responsavel RES ON (RES.conta_id = TEM.conta_id AND 
													                                         PES.ID = RES.responsavel_id)
 WHERE RES.ID IS NULL 

 -- GERAR LOG
  EXEC SP_GERAR_LOG_EM_LOTE_INSERT 'FINANCEIRO_RESPONSAVEL',@DATAEXECUCAO
 
 commit
 PRINT 'PROCESSO EFETUADO COM SUCESSO'
 PRINT CONVERT(VARCHAR(40),@DATAEXECUCAO)
 end try
 begin catch
	rollback 
	print 'ERRO DURANTE O PROCESSO - ' + ERROR_MESSAGE()
 end catch
