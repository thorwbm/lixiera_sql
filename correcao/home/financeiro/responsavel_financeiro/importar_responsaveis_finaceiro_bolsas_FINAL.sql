CREATE OR ALTER PROCEDURE SP_FNC_INSERIR_RESPONSAVEL_BOLSA AS 
DECLARE @DATAEXECUCAO DATETIME
SET @DATAEXECUCAO = CAST( CONVERT(VARCHAR(19),GETDATE(),120) AS DATETIME);

------------------------------------------------------------------------------
with cte_bolsa as (
			SELECT DISTINCT  
			       ra collate database_default as aluno_ra, curriculo_nome collate database_default as corriculo_nome, 
				   gratuidade_nome collate database_default as gratuidade_nome
			  FROM VW_FNC_PARCELA_MAT_REM  par left join mat_prd..VW_RESPONSAVEL_FINANCEIRO_MATRICULA res on (par.ra = res.aluno_ra)
			 WHERE GRATUIDADE_id is not null  
)
			insert into financeiro_responsavel (CRIADO_EM, CRIADO_POR, ATUALIZADO_EM, ATUALIZADO_POR, CONTA_ID, RESPONSAVEL_ID)
			select 
				   CRIADO_EM = @DATAEXECUCAO,CRIADO_POR = 2136, ATUALIZADO_EM = @DATAEXECUCAO, ATULAIZADO_POR = 2136, CONTA_ID = cta.id, RESPONSAVEL_ID = rpf.responsavel_id 
			  from  cte_bolsa cte join DE_PARA_GRATUIDADE_RESPONSAVEL_FINANCEIRO rpf on (cte.gratuidade_nome = rpf.gratuidade_nome)
										 join vw_Curriculo_aluno_pessoa                 cap on (cap.aluno_ra = cte.aluno_ra and 
																								cap.curriculo_aluno_status_id in (18, 13))
										 join financeiro_conta                          cta on (cta.pessoa_id = cap.pessoa_id)
									left join financeiro_responsavel                    res on (cta.id = res.conta_id and 
																								res.responsavel_id = rpf.responsavel_id)
			where res.id is null 
			order by cte.aluno_ra

-- CARGA NA TABELA DE LOG		
 EXEC SP_GERAR_LOG_EM_LOTE_INSERT 'FINANCEIRO_RESPONSAVEL', @DATAEXECUCAO


/************************************************************************************************************
--*****  PARA A PROCEDURE FUNCIONAR E NECESSARIO A EXISTENCIA DO DE PARA ABAIXO ****
************************************************************************************************************/

-- SELECT ID = 0,GRATUIDADE_NOME = REPLICATE('XX', 50), RESPONSAVEL_ID = REPLICATE('X',20) 
-- INTO DE_PARA_GRATUIDADE_RESPONSAVEL_FINANCEIRO
-- DELETE FROM DE_PARA_GRATUIDADE_RESPONSAVEL_FINANCEIRO

-- INSERT INTO DE_PARA_GRATUIDADE_RESPONSAVEL_FINANCEIRO
-- SELECT 1, 'FIES 100%', 782928 UNION 
-- SELECT 2, 'FIES CAIXA',782928 UNION
-- SELECT 3, 'FIES CAIXA',801455 UNION
-- SELECT 4, 'PROUNI',832401


-------- PROUNI ------------
-- SELECT DISTINCT RA, PESSOA_NOME FROM VW_FNC_PARCELA_MAT_REM WHERE GRATUIDADE_NOME = 'PROUNI'

select distinct ra , cap.aluno_nome, pes.nome as responsavel
  from VW_FNC_PARCELA_MAT_REM fnc join vw_Curriculo_aluno_pessoa cap on (cap.aluno_ra = fnc.ra collate database_default) 
                                  join financeiro_conta          cta on (cta.pessoa_id = cap.pessoa_id)
						     left join financeiro_responsavel    res on (cta.id = res.conta_id)
							 left join pessoas_pessoa            pes on (pes.id = res.responsavel_id and pes.nome = 'PROUNI')
 where fnc.gratuidade_nome = 'prouni'
 
-------- FIES ------------
-- SELECT DISTINCT RA, PESSOA_NOME FROM VW_FNC_PARCELA_MAT_REM WHERE GRATUIDADE_NOME = 'FIES'

select distinct ra , cap.aluno_nome, pes.nome as responsavel
  from VW_FNC_PARCELA_MAT_REM fnc join vw_Curriculo_aluno_pessoa cap on (cap.aluno_ra = fnc.ra collate database_default) 
                                  join financeiro_conta          cta on (cta.pessoa_id = cap.pessoa_id)
						     left join financeiro_responsavel    res on (cta.id = res.conta_id)
							 left join pessoas_pessoa            pes on (pes.id = res.responsavel_id and pes.nome = 'FUNDO NACIONAL DE DESENVOLVIMENTO DA EDUCAÇÃO - FNDE')
 where fnc.gratuidade_nome = 'FIES 100%'
  
-------- FIES CAIXA ------------
-- SELECT DISTINCT RA, PESSOA_NOME FROM VW_FNC_PARCELA_MAT_REM WHERE GRATUIDADE_NOME = 'FIES CAIXA'

select distinct ra , cap.aluno_nome, pes.nome as responsavel
  from VW_FNC_PARCELA_MAT_REM fnc join vw_Curriculo_aluno_pessoa cap on (cap.aluno_ra = fnc.ra collate database_default) 
                                  join financeiro_conta          cta on (cta.pessoa_id = cap.pessoa_id)
						     left join financeiro_responsavel    res on (cta.id = res.conta_id)
							 left join pessoas_pessoa            pes on (pes.id = res.responsavel_id and (pes.nome = 'FUNDO NACIONAL DE DESENVOLVIMENTO DA EDUCAÇÃO - FNDE'  OR 
							                                                                              pes.nome = 'CAIXA ECONOMICA FEDERAL'))
 where fnc.gratuidade_nome = 'FIES CAIXA'
  
-------- BOLSA ACADÊMICA 100% ------------
-- SELECT DISTINCT RA, PESSOA_NOME FROM VW_FNC_PARCELA_MAT_REM WHERE GRATUIDADE_NOME = 'BOLSA ACADÊMICA 100%'

select distinct ra , cap.aluno_nome, pes.nome as responsavel
  from VW_FNC_PARCELA_MAT_REM fnc join vw_Curriculo_aluno_pessoa cap on (cap.aluno_ra = fnc.ra collate database_default) 
                                  join financeiro_conta          cta on (cta.pessoa_id = cap.pessoa_id)
						     left join financeiro_responsavel    res on (cta.id = res.conta_id)
							 left join pessoas_pessoa            pes on (pes.id = res.responsavel_id and pes.nome = CAP.aluno_nome)
 where fnc.gratuidade_nome = 'BOLSA ACADÊMICA 100%'
  


select distinct aluno_ra, prs.cpf, con.id as contrato_id
  from financeiro_conta con join vw_Curriculo_aluno_pessoa pes on (pes.pessoa_id = con.pessoa_id)
                            join financeiro_responsavel    res on (con.id = res.conta_id)
					        join pessoas_pessoa            prs on (prs.id = res.responsavel_id)

SELECT distinct ra, replace(replace(PESSOA_CPF,'.',''),'-','') FROM VW_FNC_PARCELA_MAT_REM where desconto_id is null and origem = 'rematricula' union 

 SELECT distinct ALUNO_RA, replace(replace(responsavel_cpf,'.',''),'-','')   FROM MAT_PRD..VW_RESPONSAVEL_FINANCEIRO_MATRICULA
