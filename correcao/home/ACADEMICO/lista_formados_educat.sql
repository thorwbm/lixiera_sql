/*select distinct 
       alu.nome as aluno_nome, pes.cpf as aluno_cpf, CONVERT(VARCHAR(10),pes.data_nascimento,103) as aluno_data_nascimento,
       crc.nome as curriculo_nome, CONVERT(VARCHAR(10),cra.data_admissao,103) as data_ingresso, 
       CONVERT(VARCHAR(10),cra.data_conclusao,103) AS DATA_CONCLUSAO
      -- * 
*/
--    CONVERT(VARCHAR(10),,103)

with    cte_telefone as (
            select * from pessoas_telefone tel 
)



select distinct 
       alu.nome as aluno, pes.data_nascimento as datanacimento, alu.ra, pes.cpf, ema.email, 
       telefone1 = tel.telefone_1, 
       telefone2 = tel.telefone_2, 
       telefone3 = tel.telefone_3,
       pai.nome as pai, 
       mae.nome as mae, edr.logradouro as endereco, edr.numero, edr.complemento, edr.bairro, edr.cep, 
       cid.nome as cidade, est.nome as UF, cur.nome as curso, crc.nome as curriculo, 
       year(cra.data_admissao) as anomatricula, sta.nome as StatusCurricular, cra.data_conclusao as dataconclusao, 
       cra.data_colacao_grau as datacolacaograu, year(cra.data_conclusao) as anoconclusao,
       cra.data_conclusao periodoconclusao, cra.data_expedicao_diploma as dataexpedicaodiploma, 
       numeroexpedicaodiploma = null, dataregistrodiploma = null, numeroregistrodiploma = null, datadiariooficialuniao = null, 
       Turma= null	
       into tmp_planilha_egresso_guilherme
from curriculos_aluno cra join curriculos_statusaluno sta on (sta.id = cra.status_id)
                          join academico_aluno        alu on (alu.id = cra.aluno_id)
                          join pessoas_pessoa         pes on (pes.id = alu.pessoa_id)
                          join curriculos_curriculo   crc on (crc.id = cra.curriculo_id)
                          join academico_curso        cur on (cur.id = crc.curso_id)
                          join pessoas_endereco       edr on (pes.id = edr.pessoa_id)
                          join cidades_cidade         cid on (cid.id = edr.cidade_id)
                          join cidades_estado         est on (est.id = cid.estado_id)
                     left join pessoas_pessoa         pai on (pai.id = pes.pai_id)
                     left join pessoas_pessoa         mae on (mae.id = pes.mae_id)
                     left join pessoas_email          ema on (pes.id = ema.pessoa_id and 
                                                              ema.principal = 1)
                     left join vw_telefone_pessoa     tel on (pes.id = tel.pessoa_id)
where cra.status_id = 15 and 
      edr.endereco_principal = 1 
order by 1

