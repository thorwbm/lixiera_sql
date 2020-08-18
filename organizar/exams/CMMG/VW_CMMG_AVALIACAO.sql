CREATE   VIEW VW_CMMG_AVALIACAO AS  
 select   
  exa.external_id as exa_avaliacao_id,    
  ava.id_avaliacao, ava.ds_avaliacao ,exa.id as exa_id  
 from   
  CMMG_EXAM_EXAM exa join tbavaliacao ava on (exa.name = ava.ds_avaliacao)