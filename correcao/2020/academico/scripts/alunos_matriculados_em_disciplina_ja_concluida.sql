select distinct  alc.ALUNO_NOME, alc.ALUNO_RA, alc.CURRICULO_NOME,  alc.TURMA_PAI, alc.DISCIPLINA_NOME, alc.STATUSCURRICULO_NOME,alc.STATUS_TURMADISCIPLINAALUNO, 
dis.nome as disciplina_concluida, cdc.nota, cdc.etapa_ano_id , etp.ano, sdc.nome as status_disciplinaconcluida
from vw_aluno_curriculo_curso_turma_etapa_discplina alc join curriculos_disciplinaconcluida cdc on (cdc.disciplina_id = alc.DISCIPLINA_ID and 
                                                                                                    cdc.status_id     = 2)
												        join curriculos_aluno               cda on (cda.id = cdc.curriculo_aluno_id and 
														                                            alc.ALUNO_ID = cda.aluno_id)
													    join academico_disciplina           dis on (dis.id = cdc.disciplina_id)
														join academico_etapaano             etp on (etp.id = cdc.etapa_ano_id)
														join curriculos_statusdisciplina    sdc on (sdc.id = cdc.status_id)
where TURMA_INICIOVIGENCIA >= '2020-01-01' and 
      alc.STATUSCURRICULO_ID = 13 and 
	  alc.STATUS_TURMADISCIPLINAALUNO_ID = 1 