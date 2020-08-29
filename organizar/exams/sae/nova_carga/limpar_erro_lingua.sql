/*
select distinct nome_escola_ava,* from tmp_imp_escola_2dia where lingua_ingles = 'bloquear'


*/

select * from VW_AGENDAMENTO_PROVA_ALUNO_CODIGO
where escola_Nome =  'COLÉGIO REFFERENCIAL' and 
      grade_nome in ('Extensivo Mega') and 
	  exame_nome like '%Língua Espanhola%2º dia'

--select * 
-- commit 
declare @escola varchar(500) ='COLÉGIO REFFERENCIAL'
  begin tran
  delete apa
from application_answer apa
 where apa.application_id in (select ApPLICATION_ID from VW_AGENDAMENTO_PROVA_ALUNO_CODIGO
where escola_Nome = @escola and 
       grade_nome in ('Extensivo Mega') and 
	  exame_nome like '%Língua Espanhola%2º dia')

----------------------------------------------------------------------------------------------------
--select * 
 delete atw
from application_applicationtimewindow atw 
where atw.application_id in (select ApPLICATION_ID from VW_AGENDAMENTO_PROVA_ALUNO_CODIGO
where escola_Nome = @escola and 
         grade_nome in ('Extensivo Mega') and 
	  exame_nome like '%Língua Espanhola%2º dia')
-- commit 
-- rollback 
----------------------------------------------------------------------------------------------------
--select * 
 delete app
from application_application app 
where app.id in (select ApPLICATION_ID from VW_AGENDAMENTO_PROVA_ALUNO_CODIGO
where escola_Nome = @escola and 
        grade_nome in ( 'Extensivo Mega') and 
	  exame_nome like '%Língua Espanhola%2º dia')
-- commit 
-- rollback 