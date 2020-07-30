/*

WITH CTE_QTD_PESSOA_ID AS (
	        select pessoa_id                , COUNT(1) AS QTD, tabela = 'pessoas_endereco'           from pessoas_endereco			 GROUP BY  pessoa_id  		  union
			select pessoa_id                , COUNT(1) AS QTD, tabela = 'financeiro_conta'           from financeiro_conta			 GROUP BY  pessoa_id 	  union
			select pessoa_id                , COUNT(1) AS QTD, tabela = 'pessoas_email'              from pessoas_email				 GROUP BY  pessoa_id 	  union
			select pessoa_id                , COUNT(1) AS QTD, tabela = 'pessoas_telefone'           from pessoas_telefone			 GROUP BY  pessoa_id 	  union
			select pessoa_id                , COUNT(1) AS QTD, tabela = 'academico_pessoa_titulacao' from academico_pessoa_titulacao GROUP BY  pessoa_id          union
			select pessoa_id                , COUNT(1) AS QTD, tabela = 'academico_aluno'            from academico_aluno			 GROUP BY  pessoa_id 	  union
			select pessoa_id                , COUNT(1) AS QTD, tabela = 'contratos_fiador'           from contratos_fiador			 GROUP BY  pessoa_id 	  union
			select pessoa_id                , COUNT(1) AS QTD, tabela = 'academico_professor'        from academico_professor        GROUP BY  pessoa_id             union
			select person_id                , COUNT(1) AS QTD, tabela = 'auth_user              '    from auth_user                  GROUP BY  person_id          union            
			select pai_id                   , COUNT(1) AS QTD, tabela = 'pessoas_pessoa         '    from pessoas_pessoa             GROUP BY  pai_id          union            
			select mae_id                   , COUNT(1) AS QTD, tabela = 'pessoas_pessoa         '    from pessoas_pessoa             GROUP BY  mae_id          union            
			select responsavel_id           , COUNT(1) AS QTD, tabela = 'financeiro_lancamento  '    from financeiro_lancamento      GROUP BY responsavel_id             union            
			select responsavel_id           , COUNT(1) AS QTD, tabela = 'financeiro_responsavel '    from financeiro_responsavel     GROUP BY responsavel_id             union            
			select responsavel_financeiro_id, COUNT(1) AS QTD, tabela = 'contratos_financiamento'    from contratos_financiamento    GROUP BY  responsavel_financeiro_id            union           
			select responsavel_financeiro_id, COUNT(1) AS QTD, tabela = 'contratos_contrato     '    from contratos_contrato 		 GROUP BY responsavel_financeiro_id

)
          
SELECT * FROM CTE_QTD_PESSOA_ID WHERE PESSOA_ID = 787398 UNION 
SELECT * FROM CTE_QTD_PESSOA_ID WHERE PESSOA_ID = 787398 
ORDER BY PESSOA_ID 

ALTER TABLE log_academico_frequenciadiaria  NOCHECK CONSTRAINT log_academico_frequenciadiaria_history_user_id_ccd29623_fk_auth_user_id; 
ALTER TABLE log_academico_aula  NOCHECK CONSTRAINT log_academico_aula_history_user_id_c6a88d3d_fk_auth_user_id; 
ALTER TABLE log_avisos_confirmacaoleitura  NOCHECK CONSTRAINT log_avisos_confirmacaoleitura_history_user_id_2ad62c44_fk_auth_user_id; 
ALTER TABLE log_academico_aula  NOCHECK CONSTRAINT log_academico_aula_history_user_id_c6a88d3d_fk_auth_user_id; 

ALTER TABLE log_academico_aula  CHECK CONSTRAINT log_academico_aula_history_user_id_c6a88d3d_fk_auth_user_id; 
ALTER TABLE log_academico_frequenciadiaria  CHECK CONSTRAINT log_academico_frequenciadiaria_history_user_id_ccd29623_fk_auth_user_id; 
ALTER TABLE log_academico_aula  CHECK CONSTRAINT log_academico_aula_history_user_id_c6a88d3d_fk_auth_user_id;  
ALTER TABLE log_avisos_confirmacaoleitura  CHECK CONSTRAINT log_avisos_confirmacaoleitura_history_user_id_2ad62c44_fk_auth_user_id;  
log_academico_aula_history_user_id_c6a88d3d_fk_auth_user_id
*/
-- unificar 

declare @pessoa_id_origem int, @pessoa_id_destino int
set @pessoa_id_origem  = 831910
set @pessoa_id_destino = 787398

-- COMMIT
-- ROLLBACK 
BEGIN TRAN 
-- *** ATUALIZAR PESSOAS ENDERECO ***
--select * from pessoas_endereco
 update pessoas_endereco set pessoa_id = @pessoa_id_destino
   where pessoa_id = @pessoa_id_origem

-- *** ATUALIZAR PESSOAS EMAIL ***
--select * from pessoas_email
 update pessoas_email set pessoa_id = @pessoa_id_destino
   where pessoa_id = @pessoa_id_origem
   
-- *** ATUALIZAR PESSOAS TELEFONE ***
--select * from pessoas_telefone
 update pessoas_telefone set pessoa_id = @pessoa_id_destino
   where pessoa_id = @pessoa_id_origem
   
-- *** ATUALIZAR PESSOA TITULACAO ***
--select * from academico_pessoa_titulacao
 update academico_pessoa_titulacao set pessoa_id = @pessoa_id_destino
   where pessoa_id = @pessoa_id_origem
   
-- *** ATUALIZAR PESSOA ALUNO ***
--select * from academico_aluno
 update academico_aluno set pessoa_id = @pessoa_id_destino
   where pessoa_id = @pessoa_id_origem
   
-- *** ATUALIZAR PESSOA PROFESSOR ***
--select * from academico_professor
 update academico_professor set pessoa_id = @pessoa_id_destino
   where pessoa_id = @pessoa_id_origem
--------
--select * from academico_professor
 update academico_professor set user_id =  (SELECT TOP 1 ID FROM auth_user WHERE person_id = @pessoa_id_destino)
   where user_id IN( SELECT ID FROM auth_user WHERE person_id = @pessoa_id_origem)






-- *** ATUALIZAR  ACADEMICO_AULA ***
--select * from academico_aula
 update academico_aula set user_envio_frequencia_id =  (SELECT TOP 1 ID FROM auth_user WHERE person_id = @pessoa_id_destino)
   where user_envio_frequencia_id IN( SELECT ID FROM auth_user WHERE person_id = @pessoa_id_origem) 
--------
--select * from academico_aula
 update academico_aula set user_envio_conteudo_id =  (SELECT TOP 1 ID FROM auth_user WHERE person_id = @pessoa_id_destino)
   where user_envio_conteudo_id IN( SELECT ID FROM auth_user WHERE person_id = @pessoa_id_origem) 

-- *** ATUALIZAR PESSOA PAI E MAE ***
-- PAI
--select * from pessoas_pessoa
 update pessoas_pessoa set PAI_id = @pessoa_id_destino
   where PAI_id = @pessoa_id_origem
-- MAE
--select * from pessoas_pessoa
 update pessoas_pessoa set MAE_id = @pessoa_id_destino
   where MAE_id = @pessoa_id_origem


--#####################################################

-- *** ATUALIZAR FINANCEIRO CONTA ***
-- select * from financeiro_conta
 update financeiro_conta set pessoa_id = @pessoa_id_destino
   where pessoa_id = @pessoa_id_origem
   -------- TITULAR ID
 --  select * from financeiro_conta
 update financeiro_conta set titular_id = @pessoa_id_destino
   where titular_id = @pessoa_id_origem
   
-- *** ATUALIZAR FINANCEIRO LANCAMENTO ***
--select * from financeiro_lancamento
 update financeiro_lancamento set responsavel_id = @pessoa_id_destino
   where responsavel_id = @pessoa_id_origem
   
-- *** ATUALIZAR FINANCEIRO RESPONSAVEL ***
--select * from financeiro_responsavel
 update financeiro_responsavel set responsavel_id = @pessoa_id_destino
   where responsavel_id = @pessoa_id_origem
   
-- *** ATUALIZAR FINANCEIRO FINANCIAMENTO ***
select * from contratos_financiamento
-- update contratos_financiamento set responsavel_financeiro_id = @pessoa_id_destino
   where responsavel_financeiro_id = @pessoa_id_origem
   
-- *** ATUALIZAR FINANCEIRO CONTRATO ***
--select * from contratos_contrato
 update contratos_contrato set responsavel_financeiro_id = @pessoa_id_destino
   where responsavel_financeiro_id = @pessoa_id_origem
   
-- *** ATUALIZAR FINANCEIRO FIADOR ***
--select * from contratos_fiador
 update contratos_fiador set pessoa_id = @pessoa_id_destino
   where pessoa_id = @pessoa_id_origem
   
-- *** ATUALIZAR AVISO CONFIRMACAOLEITURA ***
--select * from avisos_confirmacaoleitura
 update avisos_confirmacaoleitura set user_id =  (SELECT TOP 1 ID FROM auth_user WHERE person_id = @pessoa_id_destino)
   where USER_ID IN( SELECT ID FROM auth_user WHERE person_id = @pessoa_id_origem)
-------
--select * from avisos_confirmacaoleitura
 update avisos_confirmacaoleitura set CRIADO_POR = (SELECT TOP 1 ID FROM auth_user WHERE person_id = @pessoa_id_destino)
   where CRIADO_POR IN( SELECT ID FROM auth_user WHERE person_id = @pessoa_id_origem)
-------
--select * from avisos_confirmacaoleitura
 update avisos_confirmacaoleitura set ATUALIZADO_POR = (SELECT TOP 1 ID FROM auth_user WHERE person_id = @pessoa_id_destino)
   where ATUALIZADO_POR IN( SELECT ID FROM auth_user WHERE person_id = @pessoa_id_origem)
   ---

-- *** ATUALIZAR AUTH USER GROUP ***
--select * from auth_user_groups
 update auth_user_groups set user_id =  (SELECT TOP 1 ID FROM auth_user WHERE person_id = @pessoa_id_destino)
   where USER_ID IN( SELECT ID FROM auth_user WHERE person_id = @pessoa_id_origem)

DELETE FROM auth_user WHERE person_id =  @pessoa_id_origem
DELETE FROM PESSOAS_PESSOA WHERE ID = @pessoa_id_origem



--SELECT TOP 3 * FROM PESSOAS_PESSOA 
--SELECT TOP 3 * FROM auth_user
