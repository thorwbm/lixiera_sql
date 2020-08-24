create OR ALTER view VW_ATIVIDADES_COMPLEMENTARES_SINTETICO  
as  
select 
       CRC.ID AS CURRICULO_ID, CRC.NOME AS CURRICULO, 
	   ALU.ID AS ALUNO_ID, ALU.NOME AS ALUNO, ALU.RA AS ALUNO_RA, 
	   CRA.ID AS CURRICULO_ALUNO_ID, 
	   STA.ID AS CURRICULO_STATUS_ID, STA.NOME AS CURRICULO_STATUS_NOME, 
	   SUM(COMP.CARGA_HORARIA) AS CHTOTALATIVCOMP  
  from 
       atividades_complementares_atividade comp join curriculos_aluno       CRA on (CRA.id = comp.curriculo_aluno_id)  
                                                join academico_aluno        ALU on (ALU.id = CRA.aluno_id)
                                                join curriculos_curriculo   CRC on (CRC.id = CRA.curriculo_id)
                                                join curriculos_statusaluno sta on (sta.id = cra.status_id)
 where CRA.status_id = 13  
 group by CRC.nome, ALU.nome, STA.ID, CRA.ID, STA.NOME, ALU.ID, ALU.RA, CRC.ID 