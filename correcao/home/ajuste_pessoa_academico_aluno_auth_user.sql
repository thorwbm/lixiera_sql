--########## CARGA NA PESSOAS_PESSOA ################
	  --insert into pessoas_pessoa(criado_em, atualizado_em, data_nascimento, rg_emissor, criado_por, atualizado_por, nome_civil, nome, cpf)
	  select getdate(), getdate(),datanascimento, imp.rg, 11717, 11717, imp.nome, imp.nome, cpf = right('000000' + imp.cpf,11)
	  from [import_aluno_sem_informacao] imp  left join pessoas_pessoa pes on (imp.nome = pes.nome)
      where    imp.cpf is not null  and 
      pes.id is null 

-- ######### ATUALIZACAO DA ACADEMICO_ALUNO #########
	  select * 
	  -- update alu set alu.pessoa_id = pes.id
	  from academico_aluno alu join pessoas_pessoa pes on (alu.nome = pes.nome)
	  where  alu.pessoa_id is null 

-- ########### UPDATE NA TABELA AUTH_USER ##############
	   select USU.* 
	  -- update USU set USU.PERSON_ID = pes.id
	  from AUTH_USER USU join pessoas_pessoa pes on (USU.LAST_NAME = pes.nome)
	  where  USU.PERSON_ID is null 