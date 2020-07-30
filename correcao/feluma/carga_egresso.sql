
select top 3 * from egressos_univers

insert into egressos_univers (aluno, Foto, dtnascimento, ra, cpf, email, telefone1, telefone2, telefone3, nomepai, nomemae, 
                                endereco, numero, complemento, bairro, cep, cidade, UF, curso, curriculo, anomatricula, StatusCurricular, 
                                dataconclusao, datacolacaograu, anoconclusao, periodoconclusao, dataexpedicaodiploma, numeroexpedicaodiploma, 
                                dataregistrodiploma, numeroregistrodiploma, datadiariooficialuniao, Turma, ContatoData, ContatoResponsavel, 
                                ContatoDescricao, UltimaAtualizacao, comunidade_id)




select aluno, Foto = null, dtnascimento = cast(datanacimento as date), ra, cpf, email, telefone1, telefone2, telefone3, 
       nomepai = pai, nomemae = mae, endereco, numero, complemento, bairro, cep, cidade, UF, curso, curriculo, anomatricula, StatusCurricular, 
cast(dataconclusao as date), cast(datacolacaograu as date), anoconclusao, periodoconclusao, dataexpedicaodiploma, numeroexpedicaodiploma, 
(dataregistrodiploma ), numeroregistrodiploma, datadiariooficialuniao, Turma, ContatoData = null, ContatoResponsavel = null, 
ContatoDescricao = null, UltimaAtualizacao = getdate(), comunidade_id = null
-- select top 3 * 
from tmp_planilha_egresso_guilherme tmp 
where not
exists (select 1 from egressos_univers uni where uni.cpf = tmp.cpf)

