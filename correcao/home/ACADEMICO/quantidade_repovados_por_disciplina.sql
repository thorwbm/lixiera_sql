select cur.nome as curso, crc.nome as curriculo, turma = tur.nome, dis.nome as disciplina,
       ano = etp.ano, periodo = etp.periodo, count(distinct cra.aluno_id) as qtd
  from curriculos_disciplinaconcluida dsc join academico_etapaano             etp on (etp.id = dsc.etapa_ano_id)
                                          join academico_disciplina           dis on (dis.id = dsc.disciplina_id)
										  join curriculos_aluno               cra on (cra.id = dsc.curriculo_aluno_id)
										  join curriculos_curriculo           crc on (crc.id = cra.curriculo_id)
										  join academico_curso                cur on (cur.id = crc.curso_id)
									      join academico_turmadisciplina      tds on ( dis.id = tds.disciplina_id)
										  join academico_turma                tur on (tur.id = tds.turma_id)
										  join academico_turmadisciplinaaluno tda on (tds.id = tda.turma_disciplina_id and 
										                                              cra.id = tda.curriculo_aluno_id)

where dsc.status_id in (9,10)
and tur.nome = 'OPTAEPFO1º'
group by cur.nome, crc.nome,  tur.nome, dis.nome, etp.ano, etp.periodo
order by 1,2,3,4,5,6