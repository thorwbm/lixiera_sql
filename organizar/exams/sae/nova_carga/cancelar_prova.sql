select * from VW_AGENDAMENTO_PROVA_ALUNO apa join application_applicationtimewindow apw on (apw.application_id = apa.application_application_id)
where ESCOLA_NOME = 'COLEGIO ALFA LOGOS' and 
      prova_nome like '% - Diagnóstica 2/2020 - % dia'


select * from VW_AGENDAMENTO_PROVA_ALUNO apa join exam_timewindow apw on (apw.application_id = apa.application_application_id)
where ESCOLA_NOME = 'COLEGIO ALFA LOGOS' and 
      prova_nome like '% - Diagnóstica 2/2020 - % dia'






select 