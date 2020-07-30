exec sp_rel_relatorio_financeiro
select distinct CRC.ID AS CURRICULO_ID, CRC.NOME AS CURRICULO_NOME, 
       ALU.ID AS ALUNO_ID, ALU.NOME AS ALUNO_NOME, ALU.RA AS ALUNO_RA,
	   CON.DATA_MATRICULA, RLF.ANO_COMPETENCIA, RLF.MES_COMPETENCIA, 
	   LAN.DATA_VENCIMENTO, LAN.PAGO_EM, LAN.VALOR_ACRESCIMOS, 
	   JUROS = CASE WHEN LAN.VALOR_ACRESCIMOS > 0 THEN RLF.VALOR_LIQUIDO * (CAST(JSON_VALUE(LAN.EXTRA, '$.multa.multa')AS FLOAT) /100.0 ) ELSE 0 END,-- LAN.VALOR_BRUTO, LAN.VALOR_LIQUIDO, LAN.VALOR_PAGO,
	   MULTA = CASE WHEN LAN.VALOR_ACRESCIMOS > 0 THEN LAN.VALOR_ACRESCIMOS - (RLF.VALOR_LIQUIDO * (CAST(JSON_VALUE(LAN.EXTRA, '$.multa.multa')AS FLOAT) /100.0 )) ELSE 0 END,-- LAN.VALOR_BRUTO, LAN.VALOR_LIQUIDO, LAN.VALOR_PAGO,
	   RLF.*
from tmp_relatorio_financeiro rlf join contratos_contrato    con on (con.id = rlf.contrato_id)
                                  join curriculos_curriculo  crc on (crc.id = con.curriculo_id)
                                  join academico_aluno       alu on (alu.id = con.aluno_id)
								  join financeiro_lancamento lan on (con.id = lan.contrato_id and
								                                     rlf.ano_competencia = lan.ano_competencia and 
																	 rlf.mes_competencia = lan.mes_competencia)
where   alu.ra = '1190.000097'
                  

select * from financeiro_lancamento
				
/*
--INSERT INTO contratos_grupototalizador
SELECT * FROM (				  
select criado_em = getdate(), atualizado_em = getdate(), NOME = 'VALOR BOLSA', CRIADO_POR = 11717, ATUALIZADO_POR = 11717 UNION
select criado_em = getdate(), atualizado_em = getdate(), NOME = 'VALOR PROUNI', CRIADO_POR = 11717, ATUALIZADO_POR = 11717 UNION
select criado_em = getdate(), atualizado_em = getdate(), NOME = 'VALOR DESCONTO', CRIADO_POR = 11717, ATUALIZADO_POR = 11717 UNION
select criado_em = getdate(), atualizado_em = getdate(), NOME = 'OUTROS DESCONTOS', CRIADO_POR = 11717, ATUALIZADO_POR = 11717
) AS TAB ORDER BY NOME

  select * from contratos_grupototalizador
SELECT * FROM contratos_tipodesconto 
UPDATE contratos_tipodesconto SET grupo_totalizador_id = 3
WHERE ID IN (10,11,12,14,15)*/