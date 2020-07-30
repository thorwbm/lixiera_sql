select  
        rg, aluno_rg,
		rg_emissor, aluno_rg_orgao_emissor, 
		rg_data_emissao, aluno_rg_emissao,
	   naturalidade_id, cid.id,
	    vw.aluno_pais, 
	   data_nascimento, 
	   nome_civil,  
	   pes.nacionalidade_id, vw.aluno_nacionalidade_id, 
	   estado_civil_id, aluno_estado_civil_id
-- select pes.*
-- commit 
-- rollback 

begin tran update pes set 
       pes.rg               = case when isnull(pes.rg               ,'')           <> vw.aluno_rg and vw.aluno_rg is not null then vw.aluno_rg else pes.rg end, 
       pes.rg_emissor       = case when isnull(pes.rg_emissor       ,'')           <> vw.aluno_rg_orgao_emissor and vw.aluno_rg_orgao_emissor is not null then vw.aluno_rg_orgao_emissor else pes.rg_emissor end, 
       pes.rg_data_emissao  = case when isnull(pes.rg_data_emissao  ,'1900-01-01') <> vw.aluno_rg_emissao and vw.aluno_rg_emissao is not null then vw.aluno_rg_emissao else pes.rg_data_emissao end, 
       pes.naturalidade_id  = case when isnull(pes.naturalidade_id  ,0)            <> cid.id and cid.id is not null then cid.id else pes.naturalidade_id end, 
       pes.data_nascimento  = case when isnull(pes.data_nascimento  ,'1900-01-01') <> vw.aluno_data_nascimento and vw.aluno_data_nascimento is not null then vw.aluno_data_nascimento else pes.data_nascimento end, 
       pes.nacionalidade_id = case when isnull(pes.nacionalidade_id , 0)           <> vw.aluno_nacionalidade_id and vw.aluno_nacionalidade_id is not null then vw.aluno_nacionalidade_id else pes.nacionalidade_id end, 
       pes.nome             = case when isnull(pes.nome             ,'')           <> vw.nome_real and vw.nome_real is not null then vw.nome_real else pes.nome end, 
       pes.estado_civil_id  = case when isnull(pes.estado_civil_id  ,0)            <> vw.aluno_estado_civil_id and vw.aluno_estado_civil_id is not null then vw.aluno_estado_civil_id else pes.estado_civil_id end

from pessoas_pessoa pes join vw_pes_pessoa vw on (vw.aluno_cpf = replace(replace(pes.cpf,'.',''),'-',''))
                        join cidades_cidade cid on (cid.nome = vw.aluno_cidade)


select * from pessoas_pessoa where nome_civil = 'ANA CAROLINA CIRILO DE MOURA'
select * from vw_pes_pessoa where nome_real =  'ANA CAROLINA CIRILO DE MOURA'

select * from vw_pes_pessoa
select * from mat_prd..core_maritalstatus
select * from rem_prd..core_maritalstatus
 


select nome_civil, nome,* from pessoas_pessoa where nome_civil like 'c%drumond%'


select * from pessoas_nacionalidade
select * from pessoas_naturalidade 