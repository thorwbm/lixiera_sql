/*
begin tran 
insert into atividades_complementares_atividade
select criado_em = getdate(), atualizado_em = getdate(), atributos = null, carga_hararia = HORACOMPUTADA/60.0, data_realizacao = DATACERTIFICADO,
       observacoes = observacao, periodo = 10, ano = year(DATACERTIFICADO), criado_por = 2137, modadalidade_id = mdl.id, 
       curriculo_aluno_id = 35092, tipo_id = tip.id, atualizado_por = 2137
from atividade_complementar..VW_INTEGRACAO_EDUCAT vw join  atividades_complementares_modalidade mdl on (mdl.nome = vw.FUNCAO collate SQL_Latin1_General_CP1_CI_AS)
                                                     join  atividades_complementares_tipo       tip on (tip.nome = vw.CATEGORIA collate SQL_Latin1_General_CP1_CI_AS)
where cpfaluno = '129.013.756-00'
and OBSERVACAO collate SQL_Latin1_General_CP1_CI_AS  not in (
select observacoes from  atividades_complementares_atividade where curriculo_aluno_id = 35092 )
*/
-- commit
 -- begin tran insert into atividades_complementares_atividade
select  criado_em = getdate(), atualizado_em = getdate(), atributos = null, 
       carga_hararia      = HORACOMPUTADA/60.0, 
	   data_realizacao    = cast(DATACERTIFICADO as date),
       observacoes        = observacao, 
	   periodo            = case when month (DATACERTIFICADO) < 7 then 1 else 2  end, 
	   ano                = year(DATACERTIFICADO), 
	   criado_por         = 11717, 
	   modadalidade_id    = mdl.id, 
       curriculo_aluno_id = cra.curriculo_aluno_id, 
	   tipo_id            = tip.id, 
	   atualizado_por     = 11717
from atividade_complementar..VW_INTEGRACAO_EDUCAT vw join atividades_complementares_modalidade mdl on (mdl.nome  collate database_default  = vw.FUNCAO collate database_default )
                                                     join atividades_complementares_tipo       tip on (tip.nome collate database_default = vw.CATEGORIA  collate database_default )
                                                     join vw_Curriculo_aluno_pessoa            cra on (cra.aluno_cpf  collate database_default = vw.CPFALUNO  collate database_default  and 
													                                                   cra.curriculo_aluno_status_id = 13)
where --CPFALUNO = '10543096637' and
      OBSERVACAO collate SQL_Latin1_General_CP1_CI_AS  
	  not in (select observacoes from  atividades_complementares_atividade where curriculo_aluno_id = cra.curriculo_aluno_id)

/*
select OBSERVACAO,HORACOMPUTADA/60.0  
select *
from atividade_complementar..VW_INTEGRACAO_EDUCAT
where  cpfaluno = '07606220603' 
order by observacao

select observacoes, carga_horaria
from atividades_complementares_atividade where curriculo_aluno_id = 35315 order by observacoes
and observacao = 'JORNADA CIENTIFICA DE FISIOLOGIA 2016- A ROBOTICA E A REABILITAÇÃO EM PACIENTES COM AVC'



select *  from atividades_complementares_tipo where nome = 'Participações em comissões institucionais:Colegiados, diretórios, ligas acadêmicas, Comissão Própria de Avaliação e demais comissões'

commit

insert into atividades_complementares_tipo
select getdate(), getdate(), 'Disciplina optativa da própria instituição de ensino',2137,2137,null
insert into atividades_complementares_tipo
select getdate(), getdate(), 'Disciplina optativa de outra instituição reconhecida de ensino',2137,2137,null



select distinct edu.categoria 
from atividade_complementar..VW_INTEGRACAO_EDUCAT edu left join  atividades_complementares_tipo tip on (edu.categoria collate database_default = tip.nome collate database_default)
where tip.id is null 

select * from vw_Curriculo_aluno_pessoa where aluno_nome = 'LUCAS DE ARAUJO LOPES'


select * from vw_Curriculo_aluno_pessoa where curriculo_aluno_id in (35739,
35407,
36380)


*/