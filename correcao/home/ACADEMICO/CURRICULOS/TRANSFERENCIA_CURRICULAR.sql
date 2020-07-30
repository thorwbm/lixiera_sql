SELECT * 
  FROM curriculos_disciplinaconcluida cdc JOIN curriculos_aluno     cal ON (cal.id = cdc.curriculo_aluno_id)
                                          JOIN academico_disciplina dis ON (dis.id = cdc.disciplina_id)
                                          JOIN academico_etapaano   eta ON (eta.id = cdc.etapa_ano_id)
                                          JOIN academico_etapa      etp ON (etp.id = eta.etapa_id)

                                          JOIN vw_ACD_CURRICULO_DISCIPLINA_EQUIVALENTE eqv ON (eqv.curriculo_id_origem = cal.curriculo_id AND 
                                                                                               eqv.disciplina_id_origem = cdc.disciplina_id)
  
  
  
  WHERE cal.id = 35653 AND 
        dis.nome LIKE 'anatomia%'




--  SELECT * FROM vw_Curriculo_aluno_pessoa vcap   WHERE aluno_ra = '1162.000027'