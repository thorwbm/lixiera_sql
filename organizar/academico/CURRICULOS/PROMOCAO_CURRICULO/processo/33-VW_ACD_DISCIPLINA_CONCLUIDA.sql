
create view VW_ACD_DISCIPLINA_CONCLUIDA AS 
select cap.aluno_id, cap.curriculo_aluno_id, cap.aluno_nome, cap.curriculo_id, cap.curriculo_nome,
       dis.id as disciplina_id, dis.nome as disciplina_nome, sta.id as disciplina_status_id, sta.nome as disciplina_status_nome,
	   dsc.etapa_ano_id
  from curriculos_disciplinaconcluida dsc join academico_disciplina          dis on (dis.id = dsc.disciplina_id)
                                          join VW_ACD_CURRICULO_ALUNO_PESSOA cap on (cap.curriculo_aluno_id = dsc.curriculo_aluno_id)   
										  join curriculos_statusdisciplina   sta on (sta.id = dsc.status_id)

