select aul.atualizado_em,* 
  from academico_aula aul with(nolock) join academico_turmadisciplina trd with(nolock) on (trd.id = aul.turma_disciplina_id)
                                       join auth_user usu on (aul.atualizado_por = usu.id)
                                       join academico_turma           tur with(nolock) on (tur.id = trd.turma_id) 
 where cast(aul.atualizado_em as date) = '2019-10-14' and 
       usu.username = 'leandro.carvalho' and 
       tur.nome in (
'1MA2º2019-2',
'1MAP022º2019-2',
'1MAP012º2019-2',
'1MAP01.22º2019-2',
'1MAP02.22º2019-2',
'1MAP02.12º2019-2',
'1MAP01.12º2019-2'
	   )and 
aul.id = 156842

select atualizado_em,* from log_academico_aula 
where id in (
select aul.id
  from academico_aula aul with(nolock) join academico_turmadisciplina trd with(nolock) on (trd.id = aul.turma_disciplina_id)
                                       join auth_user usu on (aul.atualizado_por = usu.id)
                                       join academico_turma           tur with(nolock) on (tur.id = trd.turma_id) 
 where cast(aul.atualizado_em as date) = '2019-10-14' and 
       usu.username = 'leandro.carvalho' and 
       tur.nome in (
'1MA2º2019-2',
'1MAP022º2019-2',
'1MAP012º2019-2',
'1MAP01.22º2019-2',
'1MAP02.22º2019-2',
'1MAP02.12º2019-2',
'1MAP01.12º2019-2'))
and  cast(atualizado_em as date) = '2019-10-14' and 
id = 156842


select top 3 aul.atualizado_em,* from log_academico_aula aul
where aul.id= 156842 and aul.atualizado_em < (select top 1 aulx.atualizado_em from log_academico_aula aulx 
                                       where aulx.id = aul.id and cast(aulx.atualizado_em as date) = '2019-10-14' and 
									         aulx.atualizado_por = 130)
order by aul.atualizado_em desc 



