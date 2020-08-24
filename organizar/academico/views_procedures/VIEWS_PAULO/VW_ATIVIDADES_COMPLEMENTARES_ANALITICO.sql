
create OR ALTER view VW_ATIVIDADES_COMPLEMENTARES_ANALITICO  
as  
select
       CRC.ID AS CURRICULO_ID, CRC.nome as curriculo, 
	   ALU.ID AS ALUNO_ID, ALU.nome as aluno, ALU.RA AS ALUNO_RA, 
	   COM.ID AS MODALIDADE_ID, COM.carga_horaria, MDL.nome as Modalidade, 
       TIP.ID AS TIPO_ID, TIP.nome as Tipo, COM.observacoes as Obs  
  from
       atividades_complementares_atividade COM join curriculos_aluno                     CRA on (CRA.id = COM.curriculo_aluno_id)  
                                               join curriculos_curriculo                 CRC on (CRC.id = CRA.curriculo_id)
                                               join academico_aluno                      ALU on (ALU.id = CRA.aluno_id)
                                               join atividades_complementares_modalidade MDL on (MDL.id = COM.modalidade_id)
                                               join atividades_complementares_tipo       TIP on (TIP.id = COM.tipo_id)
 where 
       CRA.status_id = 13  