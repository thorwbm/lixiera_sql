select distinct 
       crc.id as curriculo_id, crc.nome as curriculo_nome,    
          alu.id as aluno_id, alu.nome as aluno_nome, alu.ra as aluno_ra,    
          lan.id as lancamento_id, lan.valor_bruto, lan.valor_liquido, lan.valor_pago, lan.status_id,    
          lan.ano_competencia as lancamento_ano, lan.mes_competencia as lancamento_mes,    
          ctp.id as lancamento_tipo_id, ctp.descricao as lancamento_tipo_nome,     
          fsl.id as lancamento_satus_id, fsl.nome as lancamento_status_nome,     
          des.id as desconto_id, des.descricao, des.valor, tds.id as desconto_tipo_id, tds.descricao as desconto_tipo_nome,    
          con.id as contrato_id
  from financeiro_lancamento lan join financeiro_desconto         des on (lan.id = des.lancamento_id)    
                                 join contratos_tipodesconto      tds on (tds.id = des.tipo_id)    
                                 join contratos_contrato          con on (con.id = lan.contrato_id)    
                                 join academico_aluno             alu on (alu.id = con.aluno_id)    
                                 join curriculos_curriculo        crc on (crc.id = con.curriculo_id)    
                                 join financeiro_statuslancamento fsl on (fsl.id = lan.status_id)    
                                 join contratos_tipopagamento     ctp on (ctp.id = lan.tipo_id) 

order by crc.nome, alu.nome, ctp.descricao, tds.descricao

select distinct 
       crc.id as curriculo_id, crc.nome as curriculo_nome,    
          alu.id as aluno_id, alu.nome as aluno_nome, alu.ra as aluno_ra,       
          ctp.id as lancamento_tipo_id, ctp.descricao as lancamento_tipo_nome,     
		  des.valor, tds.id as desconto_tipo_id, tds.descricao as desconto_tipo_nome
  from financeiro_lancamento lan join financeiro_desconto         des on (lan.id = des.lancamento_id)    
                                 join contratos_tipodesconto      tds on (tds.id = des.tipo_id)    
                                 join contratos_contrato          con on (con.id = lan.contrato_id)    
                                 join academico_aluno             alu on (alu.id = con.aluno_id)    
                                 join curriculos_curriculo        crc on (crc.id = con.curriculo_id)    
                                 join financeiro_statuslancamento fsl on (fsl.id = lan.status_id)    
                                 join contratos_tipopagamento     ctp on (ctp.id = lan.tipo_id) 
order by crc.nome, alu.nome, ctp.descricao, tds.descricao