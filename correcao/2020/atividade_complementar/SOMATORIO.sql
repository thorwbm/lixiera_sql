SELECT edu.aluno_id, edu.aluno_nome, edu.aluno_ra, edu.aluno_cpf, edu.curriculo_aluno_id, sum(edu.carga_horaria) as carga_horaria
 -- select sum(carga_horaria)
  FROM VW_ATIVIDADE_COMPLEMENTAR_ALUNO EDU LEFT JOIN ATIVIDADE_COMPLEMENTAR..VW_INTEGRACAO_EDUCAT ATI ON (EDU.ALUNO_CPF = ATI.CPFALUNO collate database_default AND 
                                                                                                          EDU.OBSERVACOES = ATI.OBSERVACAO collate database_default)
  WHERE ATI.CPFALUNO IS NULL AND 
        edu.aluno_nome = 'DANIEL LOPES MADEIRA'
  
  group by edu.aluno_id, edu.aluno_nome, edu.aluno_ra, edu.aluno_cpf, edu.curriculo_aluno_id