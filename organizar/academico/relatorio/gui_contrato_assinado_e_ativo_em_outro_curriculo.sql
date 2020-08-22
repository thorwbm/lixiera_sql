/*******************************************************************************
2) aluno com contrato assinado para um curriculo e ativo em outro curriculo

nome do aluno 
nome do curriculo no contrato
etapa de rematricula no contrato

nome do curriculo ativo vinculado ao aluno = cursando
etapa atual do aluno no curriculo
*******************************************************************************/

select distinct cap.aluno_nome, crc.nome as curriculo_contrato, cxc.nome as curriculo_ativo
  from contratos_contrato con join curriculos_aluno cra on (cra.aluno_id = con.aluno_id and
                                                            cra.curriculo_id = con.curriculo_id)
							  join curriculos_curriculo crc on (crc.id = cra.curriculo_id)
					          join curriculos_aluno crx on (crx.aluno_id = con.aluno_id and
						                                    crx.status_id = 13)
							  join curriculos_curriculo cxc on (cxc.id = crx.curriculo_id and 
							                                    cxc.curso_id in (1, 2, 4, 5))
							  join VW_ACD_CURRICULO_ALUNO_PESSOA cap on (cra.id = cap.curriculo_aluno_id)
where con.vigente = 1 and 
      crx.curriculo_id <> cra.curriculo_id and 
	  crc.curso_id in (1, 2, 4, 5)




