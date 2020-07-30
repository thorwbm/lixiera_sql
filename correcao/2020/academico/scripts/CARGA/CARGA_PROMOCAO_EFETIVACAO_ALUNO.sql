select  distinct  ALU.ID, cra.id as curriculo_aluno_id,  etp.nome, alu.nome, crc.nome CURRICULO, etp.ETAPA, ETP.ID, eta.periodo, eta.id as etapaaluno_id  -- , CRO.tipo_oferta_id --cur.nome, alu.nome, alu.ra, etp.etapa, eta.ano
  from curriculos_aluno cra join curriculos_curriculo crc on (crc.id = cra.curriculo_id)
                            join curriculos_grade      gra on (cra.grade_id = gra.id)
							join academico_etapa       etp on (etp.id = gra.etapa_id and 
							                                   crc.curso_oferta_id = etp.curso_oferta_id)
							join academico_etapaano    eta on (etp.id = eta.etapa_id)
							join academico_aluno       alu on (alu.id = cra.aluno_id)
							join academico_turmadisciplinaaluno tda on (tda.aluno_id = cra.aluno_id )
							join academico_turmadisciplina      tds on (tds.id = tda.turma_disciplina_id)
							join academico_turma                tur on (tur.id = tds.turma_id and 
							                                            gra.id = tur.grade_id and 
																		eta.id = tur.etapa_ano_id)
  where 
     cra.status_id = 13 and 
	 alu.id = 25159 and eta.ano = 2019

	 select * from academico_statusmatriculadisciplina
	 SELECT * FROM CURRICULOS_aluno  WHERE ALUNO_ID = 20484

	 SELECT * FROM curriculos_gradedisciplinaequivalente where etapa_id = 2 and ano = 2019

	 select * from curriculos_gradedisciplina where id in (69792	,70785)

	 sp_help academico_etapaano  etapa_id, ano, periodo, oferta
	 --***** chegar numero de dependencias (repovacoes do ano anterior)

	 -- disciplinas do aluno na academico_turmadisciplinaaluno
	 select dis.nome, alu.nome , tur.grade_id, grd.id, * 
	   from academico_turmadisciplinaaluno tda join curriculos_aluno  cra on (tda.aluno_id = cra.aluno_id)
	                                                                       join curriculos_curriculo       crc on (crc.id = cra.curriculo_id)
													                       join academico_turmadisciplina  tds on (tds.id = tda.turma_disciplina_id)
																		   join academico_turma            tur on (tur.id = tds.turma_id and tur.turma_pai_id is null)
													                       join academico_disciplina       dis on (dis.id = tds.disciplina_id)
													                       join academico_aluno            alu on (alu.id = cra.aluno_id)
																		   join curriculos_gradedisciplina grd on (tur.grade_id = grd.grade_id and  
																		                                           dis.id= grd.disciplina_id)
	 where tda.aluno_id = 20484 and status_matricula_disciplina_id = 1 and cra.status_id = 13 order by 1,2

	 select * from vw_disciplina_equivalente
	 -- registros para o aluno na curriculos_disciplinaconcluida
	 SELECT dis.nome, alu.nome, cra.* 
	   FROM curriculos_disciplinaconcluida con join academico_disciplina dis on (dis.id  = con.disciplina_id)
	                                           join curriculos_aluno     cra on (cra.id = con.curriculo_aluno_id)
											   join academico_aluno      alu on (alu.id = cra.aluno_id)
											   join vw_disciplina_equivalente equ on (equ.grade_id = cra.grade_id )
	 WHERE etapa_ano_id = 2 AND cra.aluno_id  = 20484    order by 1,2 
	  
	  -- **** CHECAR SE O ALUNO E FIES OU PROUNI (CHECAR APROVEITAMENTO 75% -APROVACAO)

	 -- **** listar disciplina da proxima etapa
	 select * from vw_curriculo_grade_disciplina vw join curriculos_grade gra on (gra.id = vw.grade_id)
	                                                join academico_etapa  etp on (etp.id = gra.etapa_id)
	 where curriculo_nome = 'MEDICINA 2018/6-2 (2-2018)'
	 and etp.etapa = 3

	 -- **** verificar se nao e cursada nem dispensada

	 -- **** achar turma turma disciplina 
	        -- **** veteranos manter a mesma turma (usar de para)

	 -- **** inserir na turma disciplina aluno

	 -- **** ALTERAR ETAPA_ALUNO 
