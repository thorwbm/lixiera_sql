create or alter view vw_acd_curriculo_curso_turma_disciplina as   
select    
       cur.id as curso_id, cur.nome as curso_nome,   
       crc.id as curriculo_id, crc.nome as curriculo_nome,   
       tur.id as turma_id, tur.nome as turma_nome, tur.inicio_vigencia, tur.termino_vigencia,  
       gra.id as grade_id, gra.nome as grade_nome,   
       etp.id as etapa_id, etp.nome as etapa_nome, etp.etapa as nro_etapa,   
       eta.ano as etapa_ano, eta.periodo etapa_periodo, 
	   dis.id as disciplina_id, dis.nome as disciplina_nome,
	   tds.id as turma_disciplina_id, tds.maximo_vagas as turma_disciplina_max_vaga
  from academico_turma tur join curriculos_grade           gra on (gra.id = tur.grade_id)  
                           join academico_etapa            etp on (etp.id = gra.etapa_id)  
                           join academico_etapaano         eta on (etp.id = eta.etapa_id)  
                           join academico_curso            cur on (cur.id = tur.curso_id)  
                           join curriculos_curriculo       crc on (crc.id = gra.curriculo_id)
					       join curriculos_gradedisciplina cgd on (gra.id = cgd.grade_id)
					       join academico_disciplina       dis on (dis.id = cgd.disciplina_id)
					  left join academico_turmadisciplina  tds on (dis.id = tds.disciplina_id and
					                                               tur.id = tds.turma_id)
					  
	