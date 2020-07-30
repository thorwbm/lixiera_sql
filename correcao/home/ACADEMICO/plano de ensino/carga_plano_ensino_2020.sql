
-- ******** CRONOGRAMA SEM PLANO DE ENSINO EM 2019 *******
DECLARE @DATAEXECUCAO DATETIME    
SET @DATAEXECUCAO = CAST( CONVERT(VARCHAR(19),GETDATE(),120) AS DATETIME)  

BEGIN

 insert into planos_ensino_planoensino(criado_em, atualizado_em, criado_por, atualizado_por, carga_horaria, ementa, 
                                       curso_id, disciplina_Id, matriz, serie, conteudo_programatico, metodos_de_ensino, 
                                       etapa_ano_id, curriculo_id, replicado_em, permite_replicacao_criterio, grade_disciplina_id,
                                       ano)
select distinct 
       criado_em = @DATAEXECUCAO, atualizado_em = @DATAEXECUCAO, criado_por = 11717, atualizado_por = 11717,
       carga_horaria = 0, ementa = 'nova ementa', cro.curso_id, cro.disciplina_Id, 
	   matriz = 'nova matriz', 
	   serie = 'descobrir', 
	   conteudo_programatico = 'novo conteudo programatico', 
	   metodos_de_ensino = 'novo metodo de ensino',
	   etapa_ano_id = null, 
	   curriculo_id = null, 
	   replicado_em = null, 
	   permite_replicacao_criteiro = 0, 
	   grade_disciplina_id = null, 
	   ano = 2020
   from 
       cronogramas_cronograma cro join academico_etapaano        eta on (eta.id = cro.etapa_ano_id)
	                              join academico_disciplina      dis on (dis.id = cro.disciplina_id)
								  join academico_curso           cur on (cur.id = cro.curso_id)
	                         left join planos_ensino_planoensino ple on (cro.curso_id = ple.curso_id and 
	                                                                     cro.disciplina_id = ple.disciplina_id and
																	     ple.ano = 2019)
 where eta.ano = 2020 and ple.id is  null 

-- ###################################################################################################
-- ******** CRONOGRAMA COM PLANO DE ENSINO EM 2019 *******

 
 insert into planos_ensino_planoensino(criado_em, atualizado_em, criado_por, atualizado_por, carga_horaria, ementa, 
                                       curso_id, disciplina_Id, matriz, serie, conteudo_programatico, metodos_de_ensino, 
                                       etapa_ano_id, curriculo_id, replicado_em, permite_replicacao_criterio, grade_disciplina_id,
                                       ano)
select distinct 
       criado_em = @DATAEXECUCAO, atualizado_em = @DATAEXECUCAO, criado_por = 11717, atualizado_por = 11717,
       carga_horaria = 0, ementa = ple.ementa, cro.curso_id, cro.disciplina_Id, 
	   matriz = ple.matriz, 
	   serie  = ple.serie, 
	   conteudo_programatico = ple.conteudo_programatico, 
	   metodos_de_ensino = ple.metodos_de_ensino,
	   etapa_ano_id = null, 
	   curriculo_id = null, 
	   replicado_em = getdate(), 
	   permite_replicacao_criteiro = 0, 
	   grade_disciplina_id = null,
	   ano = eta.ano
   from 
       cronogramas_cronograma cro join academico_etapaano        eta on (eta.id = cro.etapa_ano_id)
	                              join academico_disciplina      dis on (dis.id = cro.disciplina_id)
								  join academico_curso           cur on (cur.id = cro.curso_id)
	                         left join planos_ensino_planoensino ple on (cro.curso_id = ple.curso_id and 
	                                                                     cro.disciplina_id = ple.disciplina_id and
																	     ple.ano = 2019)
 where eta.ano = 2020 and ple.id is not  null 

 -- GERAR LOG    
 EXEC SP_GERAR_LOG_EM_LOTE_INSERT 'PLANOS_ENSINO_PLANOENSINO', @DATAEXECUCAO, 11717    
    
	-- COMMIT
	-- ROLLBACK 
