

  select alu.aluno_id, alu.aluno_nome, alu.aluno_ra, alu.curriculo_aluno_id, alu.curriculo_id, alu.curriculo_nome, 
        alu.curriculo_aluno_status_nome, 
		con.descricao as contrato_descricao, con.id as contrato_id, con.data_matricula as contrato_data_matricula
    from VW_ACD_CURRICULO_ALUNO_PESSOA alu join contratos_contrato con on (alu.aluno_id = con.aluno_id)  
  where con.curriculo_aluno_id is null 
  
  order by aluno_nome, curriculo_nome


