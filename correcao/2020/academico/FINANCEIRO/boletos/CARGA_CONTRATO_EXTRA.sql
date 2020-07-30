
INSERT INTO CONTRATOS_CONTRATO (criado_em, atualizado_em, valor, valor_parcela, num_parcelas, num_fiadores, aluno_id, criado_por, 
            curriculo_id, etapa_ano_id, responsavel_financeiro_id, atualizado_por, data_matricula)
SELECT DISTINCT criado_em = getdate(), 
                atualizado_em = getdate(), 
				valor = -1, valor_parcela = -1, 
				num_parcelas = -1, 
				num_fiadores = ISNULL(fia.qtd_fiadores,0), 
                aluno_id = alu.id, criado_por = 11717, 
				curriculo_id = CUR.id, etapa_ano_id= null, 
			responsavel_financeiro_id = isnull(pes.id, alu.pessoa_id), 
				atualizado_por = 11717,
				CON.DATA_MATRICULA
 from  academico_aluno alu join VW_FNC_CANDIDATO_CONTRATO     CON on (CON.ra   collate database_default = alu.ra collate database_default)
                           JOIN CURRICULOS_CURRICULO          CUR ON (CUR.nome COLLATE DATABASE_DEFAULT = CON.CURRICULO_NOME COLLATE DATABASE_DEFAULT)
					  LEFT JOIN (SELECT DISTINCT CURRICULO, RA, CPF FROM vw_FNC_responsavel_financeiro) rsp on (rsp.ra   collate database_default = CON.ra collate database_default AND 
					                                                                                            RSP.CURRICULO = CON.CURRICULO_NOME)
					  left join pessoas_pessoa                pes on (pes.cpf  collate database_default = rsp.cpf collate database_default)
                      left join vw_FNC_QTD_fiadores           fia on (CON.ra = fia.ra)

WHERE NOT EXISTS (SELECT 1 FROM CONTRATOS_CONTRATO CNT 
                   WHERE CNT.ALUNO_ID = alu.id AND 
				         CNT.curriculo_id = CUR.ID)


