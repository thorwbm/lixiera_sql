 use EDUCAT_CMMG

select count(1)as qtd, 'CMMG_APPLICATION_ANSWER' as tabela  from CMMG_APPLICATION_ANSWER           union
select count(1)as qtd, 'CMMG_APPLICATION_APPLICATION' as tabela  from CMMG_APPLICATION_APPLICATION union
select count(1)as qtd, 'CMMG_DADOS_EXPORTACAO' as tabela  from CMMG_DADOS_EXPORTACAO               union
select count(1)as qtd, 'CMMG_EXAM_EXAM' as tabela  from CMMG_EXAM_EXAM                             union
select count(1)as qtd, 'CMMG_EXAM_EXAMITEM' as tabela  from CMMG_EXAM_EXAMITEM                     union
select count(1)as qtd, 'CMMG_ITEM_ALTERNATIVE' as tabela  from CMMG_ITEM_ALTERNATIVE               union
select count(1)as qtd, 'CMMG_ITEM_ITEM' as tabela  from CMMG_ITEM_ITEM                             union
select count(1)AS qtd, 'CMMG_USUARIO' AS tabela  from CMMG_USUARIO                                 

DROP TABLE CMMG_APPLICATION_ANSWER
DROP TABLE CMMG_APPLICATION_APPLICATION
DROP TABLE CMMG_DADOS_EXPORTACAO
DROP TABLE CMMG_EXAM_EXAM
DROP TABLE CMMG_EXAM_EXAMITEM
DROP TABLE CMMG_ITEM_ALTERNATIVE
DROP TABLE CMMG_ITEM_ITEM
DROP TABLE CMMG_USUARIO


  SELECT * INTO CMMG_APPLICATION_ANSWER      FROM EXAMS_CMMG..APPLICATION_ANSWER     
  SELECT * INTO CMMG_APPLICATION_APPLICATION FROM EXAMS_CMMG..APPLICATION_APPLICATION
  SELECT * INTO CMMG_DADOS_EXPORTACAO        FROM EXAMS_CMMG..VW_DADOS_EXPORTACAO       
  SELECT * INTO CMMG_EXAM_EXAM               FROM EXAMS_CMMG..EXAM_EXAM              
  SELECT * INTO CMMG_EXAM_EXAMITEM           FROM EXAMS_CMMG..EXAM_EXAMITEM          
  SELECT * INTO CMMG_ITEM_ALTERNATIVE        FROM EXAMS_CMMG..ITEM_ALTERNATIVE       
  SELECT * INTO CMMG_ITEM_ITEM               FROM EXAMS_CMMG..ITEM_ITEM              
  SELECT id,email, name INTO CMMG_USUARIO    FROM EXAMS_CMMG..AUTH_USER   
  
/*
SELECT * FROM TbAvaliacao WHERE TbAvaliacao.id_avaliacao = 374 
SELECT * FROM TbAvaliacaoAplicacao WHERE id_avaliacao = 374

SELECT * FROM tbdisciplina WHERE id_disciplina = 5
SELECT * FROM TbPeriodo WHERE id_periodo = 1

*/