select PROVA_NOME, ESCOLA_NOME, EXAME_NOME, GRADE_NOME, ALUNO_NOME, PUBLIC_IDENTIFIER, APP_TWD_INICIO, APP_TWD_TERMINO, APP_TWD_DURACAO
  from VW_AGENDAMENTO_PROVA_ALUNO 
  where  prova_nome like 'Desafio SAE%4�BI -%' and 
         APP_TWD_INICIO is not null 



select PROVA_NOME, ESCOLA_NOME, EXAME_NOME, GRADE_NOME, ALUNO_NOME, PUBLIC_IDENTIFIER
  from VW_AGENDAMENTO_PROVA_ALUNO 
  where  prova_nome like 'Desafio SAE%4�BI -%' and 
         APP_TWD_INICIO is  null 



