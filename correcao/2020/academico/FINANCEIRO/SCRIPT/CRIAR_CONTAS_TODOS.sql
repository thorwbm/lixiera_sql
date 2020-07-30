

insert into financeiro_conta (criado_em, atualizado_em, saldo, criado_por, pessoa_id, atualizado_por, titular_id)
	   select DISTINCT criado_em = getdate(), atualizado_em = getdate(), saldo = 0.0, criado_por = 2136, 
	                   pessoa_id = alu.pessoa_id , atualizado_por = 2136, titular_id = ISNULL(PES.ID, ALU.PESSOA_ID) 

FROM ACADEMICO_ALUNO ALU LEFT JOIN MAT_PRD..vw_responsavel_financeiro RES ON (ALU.RA collate database_default = RES.RA collate database_default)
                         LEFT JOIN PESSOAS_PESSOA                     PES ON (PES.CPF collate database_default = RES.CPF collate database_default)
                         LEFT JOIN FINANCEIRO_CONTA                   CON ON (CON.pessoa_id = ALU.pessoa_id)
WHERE CON.ID IS NULL AND ALU.pessoa_id IS NOT NULL 

