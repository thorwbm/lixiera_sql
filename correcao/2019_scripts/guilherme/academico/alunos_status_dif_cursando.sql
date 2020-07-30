

 select --CODSTATUS, *,
        
        aluno_nome = alu.nome,
		aluno_ra   = alu.ra, 
		turma_nome = tur.nome, 
		disciplina_nome = dis.nome 
   from carga_universus.dbo.ENTURMA ent with(nolock)  join academico_turmadisciplinaaluno tda with(nolock)  on (  json_value(tda.atributos, '$.universus_key.codescola')      = ent.codescola
                                                                                  and json_value(tda.atributos, '$.universus_key.ano')            = ent.ano
                                                                                  and json_value(tda.atributos, '$.universus_key.regime')         = ent.regime
                                                                                  and json_value(tda.atributos, '$.universus_key.periodo')        = ent.periodo
                                                                                  and json_value(tda.atributos, '$.universus_key.codcurso')       = ent.codcurso
									                                              and json_value(tda.atributos, '$.universus_key.numetapa')       = ent.numetapa
									                                              and json_value(tda.atributos, '$.universus_key.codetapa')       = ent.codetapa
									                                              and json_value(tda.atributos, '$.universus_key.codturno')       = ent.codturno
									                                              and json_value(tda.atributos, '$.universus_key.numgrade')       = ent.numgrade
									                                              and json_value(tda.atributos, '$.universus_key.anograde')       = ent.anograde
									                                              and json_value(tda.atributos, '$.universus_key.regimegrade')    = ent.regimegrade
									                                              and json_value(tda.atributos, '$.universus_key.periodograde')   = ent.periodograde
									                                              and json_value(tda.atributos, '$.universus_key.codaluno')       = ent.codaluno
									                                              and json_value(tda.atributos, '$.universus_key.coddisciplina')  = ent.coddisciplina
                                                                                  and json_value(tda.atributos, '$.universus_key.seqenturma')  = ent.SEQENTURMA
                                                                                     )
						       join academico_aluno alu with(nolock)  on (alu.id = tda.aluno_id )
							   join academico_turmadisciplina tds with(nolock)  on (tds.id = tda.turma_disciplina_id)
							   join academico_disciplina  dis with(nolock)  on (dis.id = tds.disciplina_id)
							   join academico_turma       tur with(nolock)  on (tur.id = tds.turma_id) 
							   join carga_universus.dbo.ALUCURRICULO alc with(nolock) on (ent.CODALUNO = alc.CODALUNO and 
							                                                              ent.CODCURRICULO = alc.CODCURRICULO and 
																						  ent.CODESCOLA    = alc.CODESCOLA) 

 where ent.CODESCOLA = 1 and ent.codstatus > 2  and ent.ANO = 2019 order by 1

