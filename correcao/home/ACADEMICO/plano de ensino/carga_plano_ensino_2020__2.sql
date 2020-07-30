-- ******** CRONOGRAMA SEM PLANO DE ENSINO EM 2019 *******
--

BEGIN tran 
DECLARE @DATAEXECUCAO DATETIME    
SET @DATAEXECUCAO = CAST( CONVERT(VARCHAR(19),GETDATE(),120) AS DATETIME)  

 insert into planos_ensino_planoensino(criado_em, atualizado_em, criado_por, atualizado_por, carga_horaria, ementa, 
                                       curso_id, disciplina_Id, matriz, serie, conteudo_programatico, metodos_de_ensino, 
                                       etapa_ano_id, curriculo_id, replicado_em, permite_replicacao_criterio, grade_disciplina_id,
                                       ano, alterar_competencias_gerais, alterar_competencias_especificas)
select distinct 
       criado_em = @DATAEXECUCAO, atualizado_em = @DATAEXECUCAO, criado_por = 11717, atualizado_por = 11717,
       carga_horaria = vw.carga_horaria, ementa = null, cro.curso_id, cro.disciplina_Id, 
	   matriz = cur.nome + ' / ' + dis.nome + ' / 2020' , 
	   serie = etp.nome, 
	   conteudo_programatico = null, 
	   metodos_de_ensino = null,
	   etapa_ano_id = eta.id, 
	   curriculo_id = null, 
	   replicado_em = getdate(), 
	   permite_replicacao_criteiro = 0, 
	   grade_disciplina_id = null, 
	   ano = 2020,
        alterar_competencias_gerais = 1, 
        alterar_competencias_especificas = 1
   from 
       cronogramas_cronograma cro join academico_etapaano         eta on (eta.id = cro.etapa_ano_id)
                                  join academico_etapa            etp on (etp.id = eta.etapa_id)
	                              join academico_disciplina       dis on (dis.id = cro.disciplina_id)
								  join academico_curso            cur on (cur.id = cro.curso_id)
                             left join vw_acd_curriculo_curso_disciplina_turma_carga_horaria vw on (dis.id = vw.disciplina_id and
                                                                                                    cur.id = vw.curso_id and 
                                                                                                    vw.ano = 2020)
                             left join planos_ensino_planoensino  ple on (cro.curso_id = ple.curso_id and 
	                                                                     cro.disciplina_id = ple.disciplina_id and
																	     ple.ano = 2019)
                             left join academico_etapaano         etax on (etax.id = ple.etapa_ano_id and 
                                                                           etax.etapa_id = eta.etapa_id and 
                                                                           etax.ano = 2019)
 where eta.ano = 2020 and ple.id is  null  and 
       dis.id    in (5616,6412,5118) 
     -- and   'FISIOTERAPIA / ANATOMIA II / 2020' =  cur.nome + ' / ' + dis.nome + ' / 2020' 
       and 
       ((eta.id = 1347 and vw.carga_horaria = 40) or
        (eta.id = 1349 and vw.carga_horaria = 100)or

        (eta.id = 1377 and vw.carga_horaria = 40) or
        (eta.id = 1378 and vw.carga_horaria = 60) or

        (eta.id = 1372 and vw.carga_horaria = 60) or
        (eta.id = 1330 and vw.carga_horaria = 40) or  

        (eta.id = 1382 and vw.carga_horaria = 80) or
        (eta.id = 1383 and vw.carga_horaria = 40) )
order by 5
 -- GERAR LOG    
 EXEC SP_GERAR_LOG_EM_LOTE_INSERT 'PLANOS_ENSINO_PLANOENSINO', @DATAEXECUCAO
    
-- ###################################################################################################
-- ******** CRONOGRAMA COM PLANO DE ENSINO EM 2019 *******
 
 insert into planos_ensino_planoensino(criado_em, atualizado_em, criado_por, atualizado_por, carga_horaria, ementa, 
                                       curso_id, disciplina_Id, matriz, serie, conteudo_programatico, metodos_de_ensino, 
                                       etapa_ano_id, curriculo_id, replicado_em, permite_replicacao_criterio, grade_disciplina_id,
                                       ano, alterar_competencias_gerais, alterar_competencias_especificas)
select distinct 
      -- criado_em = @DATAEXECUCAO, atualizado_em = @DATAEXECUCAO, criado_por = 11717, atualizado_por = 11717,
       carga_horaria = vw.carga_horaria, ementa = ple.ementa, cro.curso_id, cro.disciplina_Id, 
	   matriz =  cur.nome + ' / ' + dis.nome + ' / 2020', 
	   serie  = etp.nome, 
	   conteudo_programatico = ple.conteudo_programatico, 
	   metodos_de_ensino = ple.metodos_de_ensino,
	   etapa_ano_id = eta.id, 
	   curriculo_id = null, 
	   replicado_em = getdate(), 
	   permite_replicacao_criteiro = 0, 
	   grade_disciplina_id = null,
	   ano = eta.ano,
       ple.alterar_competencias_gerais, 
       ple.alterar_competencias_especificas
   from 
       cronogramas_cronograma cro join academico_etapaano        eta on (eta.id = cro.etapa_ano_id)
                                  join academico_etapa            etp on (etp.id = eta.etapa_id)
	                              join academico_disciplina      dis on (dis.id = cro.disciplina_id)
								  join academico_curso           cur on (cur.id = cro.curso_id)
                             left join vw_acd_curriculo_curso_disciplina_turma_carga_horaria vw on (dis.id = vw.disciplina_id and
                                                                                                    cur.id = vw.curso_id and 
                                                                                                    vw.ano = 2020)
                          left join planos_ensino_planoensino ple on (cro.curso_id = ple.curso_id and 
	                                                                  cro.disciplina_id = ple.disciplina_id and 
                                                                      ple.ano = 2019)
 where eta.ano = 2020 and ple.id is not  null 
       and 'MEDICINA / INTEGRAÇÃO CURRICULAR IV / 2020' = cur.nome + ' / ' + dis.nome + ' / 2020'

 -- GERAR LOG    
 EXEC SP_GERAR_LOG_EM_LOTE_INSERT 'PLANOS_ENSINO_PLANOENSINO', @DATAEXECUCAO
    
	-- COMMIT
	-- ROLLBACK 



  select distinct 
    
           cur.nome as curso_nome, 
           dis.nome as disciplina_nome, 
           ple.matriz, 
           ple.serie
      from planos_ensino_planoensino ple join academico_curso      cur on (cur.id = ple.curso_id)
                                         join academico_disciplina dis on (dis.id = ple.disciplina_id)
    where ano = 2020 and 
          ementa is null 
    order by 1, 2, 4


