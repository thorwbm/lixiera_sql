begin tran 
insert into pessoas_pessoa(criado_em, atualizado_em, data_nascimento, rg, rg_emissor, rg_emissor_uf, rg_data_emissao, naturalidade_id, criado_por, 
                                    atualizado_por, nome_pai, nome_mae, sexo_id, nome_civil, nome, pai_id, mae_id, atributos, cpf)
select criado_em = getdate(), atualizado_em = getdate(), data_nascimento = null, rg = ofc.rg collate database_default, 
      rg_emissor = null, rg_emissor_uf = null, rg_data_emissao = null, naturalidade_id = null, criado_por = 2136, atualizado_por =  2136, 
	  nome_pai = null, nome_mae = null, sexo_id = null, nome_civil = real_name collate database_default, nome = real_name, pai_id = null , mae_id = null, atributos = null,
	  cpf = replace(replace(ofc.cpf,'-',''),'.','') collate database_default 

from mat_prd..onboarding_financeofficer ofc left join pessoas_pessoa pes on (replace(replace(pes.cpf,'-',''),'.','') collate database_default = replace(replace(ofc.cpf,'-',''),'.','') collate database_default)
where pes.cpf is  null 
-- commit 
--rollback
