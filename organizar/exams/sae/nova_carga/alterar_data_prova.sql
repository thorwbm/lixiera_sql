select * 
---    begin tran update apw set apw.start_time = '2020-08-31 10:30:00.0000000' , apw.end_time = '2020-09-01 00:00:00.0000000'
from VW_AGENDAMENTO_PROVA_ALUNO apa join application_applicationtimewindow apw on (apa.application_application_id = apw.application_id)
where ESCOLA_NOME = 'CENTRO EDUCACIONAL TOTH' and 
      grade_nome in ( '6º ano','7º ano','8º ano','9º ano') and 
	  prova_nome like '% - Diagnóstica 2/2020 - 2º dia'


	  -- commit
	  -- rollback 


select * from hierarchy_hierarchy
where value = '52b4e5e77163203a4eec0acd6cbf844c'
select * from auth_user where public_identifier = '52b4e5e77163203a4eec0acd6cbf844c'


select * 
--     update tmp set tmp.janela_aplicacao = '2020-09-29 00:00:00.000'
from tmp_imp_escola_1dia tmp where nome_escola_ava = 'CENTRO EDUCACIONAL TOTH'

select * from tmp_imp_bloquear where nome_escola_ava = 'SOCIEDADE EDUCACIONAL DOM OTAVIO AGUIAR LTDA' 



select distinct  DATEPART(hour, apa.APP_TWD_INICIO ),escola_nome, prova_nome, exame_nome, grade_nome, APP_TWD_INICIO, APP_TWD_TERMINO, apa.application_application_id
---    begin tran update apw set apw.start_time = '2020-09-30 10:30:00.0000000' , apw.end_time = '2020-10-01 00:00:00.0000000'
from VW_AGENDAMENTO_PROVA_ALUNO apa join application_applicationtimewindow apw on (apa.application_application_id = apw.application_id)
where --ESCOLA_NOME = 'SOCIEDADE EDUCACIONAL DOM OTAVIO AGUIAR LTDA' and 
     -- grade_nome in ( '1ª série','2ª série','3ª série','extensivo') and 
	 -- prova_nome like '% - Diagnóstica 2/2020 - %º dia' and DATEPART(hour, apa.APP_TWD_TERMINO ) <> 21
	  prova_nome like '% - Diagnóstica 2/2020 - %º dia' and DATEPART(hour, apa.APP_TWD_INICIO ) > 7