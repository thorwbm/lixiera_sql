-- CRIAR NOVO CURRICULO ALUNO (CURRICULO DE DESTINO)

-- SETAR O CURRICULO ANTERIOR PARA TRANFERENCIA CURRICULAR

-- MIGRAR AS ATIVIDADES COMPLEMENTARES DO CURRICULO ORIGEM PARA O DESTINO (UPDATAR OU CRIAR NOVO)

-- ACADEMICO_TRUMADISCIPLINAALUNO (e pra trocar o curriclo aluno id ou criar um novo registro)

-- CURRICULO_DISCIPLINACONCLUIDA (CRIAR NOVOS REGISTROS)
-- 1) Sim, inserir registro na tabela [curriculos_aluno] para o curriculo de destino
-- 2) Alterar o campo [status_id] da tabela [curriculos_aluno] para o curriculo de origem
-- 3) Alterar, updatar as atividades complementares para o curriculo_aluno_id de destino
-- 4) Alterar, updatar os registros da TDA DO SEMESTRE ATUAL para o curriculo de destino; A alteração deverá ser feita antes de alterar o status do curriculo de origem por causa da trigger
-- 5) criar novos registros para o novo curriculo_aluno_id


WITH    cte_transferencia AS (
            SELECT tra.*, 
                   Oalu.id AS aluno_id,
                   Ocra.id AS curriculo_aluno_id_origem, Ocur.id AS curriculo_id_origem, Oalu.nome, Dcur.id AS curriculo_id_destino, 
                   ogra.id AS grade_id_origem, isnull(dgra.id,ogra.id) AS grade_id_destino
              FROM tmpimp_tranferenciaCurricular tra JOIN curriculos_curriculo Ocur ON (Ocur.nome = tra.curriculo)
                                                     JOIN academico_aluno      Oalu ON (Oalu.ra   = tra.ra)
                                                     JOIN curriculos_aluno     Ocra ON (Ocur.id   = Ocra.curriculo_id AND
                                                                                        Oalu.id   = Ocra.aluno_id)  
                                                     JOIN curriculos_grade     ogra ON (ogra.id = ocra.grade_id)
                                                     JOIN curriculos_curriculo Dcur ON (Dcur.nome = tra.transferenciacurricular)
                                               LEFT  JOIN curriculos_grade     dgra ON (dcur.id = dgra.curriculo_id AND 
                                                                                        dgra.nome = ogra.nome)
       WHERE Oalu.nome = 'RAFAEL HENRIQUE FAGUNDES DINIZ COUTO'
)


-- drop table #TBM_TRANSFERENCIA
   SELECT * INTO #TBM_TRANSFERENCIA FROM cte_transferencia

  --   Insert Into curriculos_aluno (criado_em, atualizado_em, criado_por, atualizado_por, data_admissao, pontuacao_processo_seletivo, 
  --                                 data_processo_seletivo, metodo_admissao_id, curriculo_id, aluno_id, posicao_processo_seletivo, 
	--				                 atributos, status_id, periodo_admissao, data_expedicao_diploma, data_colacao_grau, ano_admissao, 
	--				                 grade_id, observacoes, data_conclusao, media_geral_aluno, data_termino, data_inicio)

            SELECT cra.criado_em, cra.atualizado_em, cra.criado_por, cra.atualizado_por, cra.data_admissao, cra.pontuacao_processo_seletivo, 
                   cra.data_processo_seletivo, cra.metodo_admissao_id, 
                   curriculo_id = tra.curriculo_id_destino, 
                   cra.aluno_id, cra.posicao_processo_seletivo, 
				   cra.atributos, cra.status_id, cra.periodo_admissao, cra.data_expedicao_diploma, cra.data_colacao_grau, cra.ano_admissao, 
				   grade_id = tra.grade_id_destino, 
                   cra.observacoes, cra.data_conclusao, cra.media_geral_aluno, cra.data_termino, cra.data_inicio , tra.curriculo_id_destino
              FROM curriculos_aluno cra JOIN #TBM_TRANSFERENCIA tra ON (cra.id = tra.curriculo_aluno_id_origem)
                                   LEFT JOIN curriculos_aluno   XXX ON (XXX.aluno_id     = cra.aluno_id AND
                                                                        XXX.CURRICULO_ID = TRA.curriculo_id_destino AND
                                                                        XXX.grade_id     = TRA.grade_id_destino) 
             WHERE XXX.ID IS NULL 
                                        


     SELECT * 
       FROM academico_turmadisciplinaalun-- CRIAR NOVO CURRICULO ALUNO (CURRICULO DE DESTINO)

-- SETAR O CURRICULO ANTERIOR PARA TRANFERENCIA CURRICULAR

-- MIGRAR AS ATIVIDADES COMPLEMENTARES DO CURRICULO ORIGEM PARA O DESTINO (UPDATAR OU CRIAR NOVO)

-- ACADEMICO_TRUMADISCIPLINAALUNO (e pra trocar o curriclo aluno id ou criar um novo registro)

-- CURRICULO_DISCIPLINACONCLUIDA (CRIAR NOVOS REGISTROS)
-- 1) Sim, inserir registro na tabela [curriculos_aluno] para o curriculo de destino
-- 2) Alterar o campo [status_id] da tabela [curriculos_aluno] para o curriculo de origem
-- 3) Alterar, updatar as atividades complementares para o curriculo_aluno_id de destino
-- 4) Alterar, updatar os registros da TDA DO SEMESTRE ATUAL para o curriculo de destino; A alteração deverá ser feita antes de alterar o status do curriculo de origem por causa da trigger
-- 5) criar novos registros para o novo curriculo_aluno_id


WITH    cte_transferencia AS (
            SELECT tra.*, 
                   Oalu.id AS aluno_id,
                   Ocra.id AS curriculo_aluno_id_origem, Ocur.id AS curriculo_id_origem, Oalu.nome, Dcur.id AS curriculo_id_destino, 
                   ogra.id AS grade_id_origem, isnull(dgra.id,ogra.id) AS grade_id_destino
              FROM tmpimp_tranferenciaCurricular tra JOIN curriculos_curriculo Ocur ON (Ocur.nome = tra.curriculo)
                                                     JOIN academico_aluno      Oalu ON (Oalu.ra   = tra.ra)
                                                     JOIN curriculos_aluno     Ocra ON (Ocur.id   = Ocra.curriculo_id AND
                                                                                        Oalu.id   = Ocra.aluno_id)  
                                                     JOIN curriculos_grade     ogra ON (ogra.id = ocra.grade_id)
                                                     JOIN curriculos_curriculo Dcur ON (Dcur.nome = tra.transferenciacurricular)
                                               LEFT  JOIN curriculos_grade     dgra ON (dcur.id = dgra.curriculo_id AND 
                                                                                        dgra.nome = ogra.nome)
       WHERE Oalu.nome = 'RAFAEL HENRIQUE FAGUNDES DINIZ COUTO'
)


-- drop table #TBM_TRANSFERENCIA
   SELECT * INTO #TBM_TRANSFERENCIA FROM cte_transferencia

  --   Insert Into curriculos_aluno (criado_em, atualizado_em, criado_por, atualizado_por, data_admissao, pontuacao_processo_seletivo, 
  --                                 data_processo_seletivo, metodo_admissao_id, curriculo_id, aluno_id, posicao_processo_seletivo, 
	--				                 atributos, status_id, periodo_admissao, data_expedicao_diploma, data_colacao_grau, ano_admissao, 
	--				                 grade_id, observacoes, data_conclusao, media_geral_aluno, data_termino, data_inicio)

            SELECT cra.criado_em, cra.atualizado_em, cra.criado_por, cra.atualizado_por, cra.data_admissao, cra.pontuacao_processo_seletivo, 
                   cra.data_processo_seletivo, cra.metodo_admissao_id, 
                   curriculo_id = tra.curriculo_id_destino, 
                   cra.aluno_id, cra.posicao_processo_seletivo, 
				   cra.atributos, cra.status_id, cra.periodo_admissao, cra.data_expedicao_diploma, cra.data_colacao_grau, cra.ano_admissao, 
				   grade_id = tra.grade_id_destino, 
                   cra.observacoes, cra.data_conclusao, cra.media_geral_aluno, cra.data_termino, cra.data_inicio , tra.curriculo_id_destino
              FROM curriculos_aluno cra JOIN #TBM_TRANSFERENCIA tra ON (cra.id = tra.curriculo_aluno_id_origem)
                                   LEFT JOIN curriculos_aluno   XXX ON (XXX.aluno_id     = cra.aluno_id AND
                                                                        XXX.CURRICULO_ID = TRA.curriculo_id_destino AND
                                                                        XXX.grade_id     = TRA.grade_id_destino) 
             WHERE XXX.ID IS NULL 
                                        


     SELECT * 
     UPDATE 
       FROM academico_turma getdate(), tda.atualizado_por = 111717,
                    tda.curriculo_aluno_id = tbm.
       FROM academico_turmadisciplinaaluno tda JOIN academico_turmadisciplina tds ON (tds.id = tda.turma_disciplina_id)
                                               JOIN academico_turma           tur ON (tur.id = tds.turma_id)
                                               JOIN #TBM_TRANSFERENCIA        tbm ON (tbm.aluno_id = tda.aluno_id AND
                                                                                      tda.curriculo_aluno_id = tbm.curriculo_aluno_id_origem)
                                               join curriculos_aluno          cra on (cra.curriculo_id = tbm.curriculo_id_destino and 
                                                                                      cra.aluno_id = tda.aluno_id)
      WHERE year(tur.inicio_vigencia) = 2020 AND
            tda.aluno_id = 38274




SELECT distinct crco.nome, crcd.nome, diso.nome, disd.nome, etao.id, etad.id, etao.ano, etao.periodo, etad.periodo
  FROM curriculos_disciplinaconcluida cdco JOIN curriculos_aluno           calo ON (calo.id = cdco.curriculo_aluno_id)
                                           JOIN curriculos_curriculo       crco ON (crco.id = calo.curriculo_id)
                                           JOIN academico_disciplina       diso ON (diso.id = cdco.disciplina_id)
                                           JOIN academico_etapaano         etao ON (etao.id = cdco.etapa_ano_id)
                                           JOIN academico_etapa            etpo ON (etpo.id = etao.etapa_id)
                                           JOIN curriculos_grade           grdo ON (etpo.id = grdo.etapa_id AND
                                                                                    crco.id = grdo.curriculo_id)
                                           JOIN curriculos_gradedisciplina cgdo ON (grdo.id = cgdo.grade_id AND
                                                                                    diso.id = cgdo.disciplina_id)
                                           
                                           JOIN vw_ACD_CURRICULO_DISCIPLINA_EQUIVALENTE eqv ON (cgdo.id = eqv.grade_disciplina_id_origem)
                                           
                                           JOIN curriculos_gradedisciplina cgdd ON (cgdd.id = eqv.grade_disciplina_id_destino)
                                           JOIN curriculos_aluno           cald ON (cald.curriculo_id = eqv.curriculo_id_destino) 
                                           JOIN curriculos_curriculo       crcd ON (crcd.id = cald.curriculo_id)
                                           JOIN academico_disciplina       disd ON (disd.id = cgdd.disciplina_id)
                                           JOIN curriculos_grade           grdd ON (grdd.id = cgdd.grade_id)
                                           JOIN academico_etapa            etpd ON (etpd.id = grdd.etapa_id)                                          
                                           JOIN academico_etapaano         etad ON (etpd.id = etad.etapa_id AND
                                                                                    etpd.etapa = etpo.etapa)
                                            
  
  
  
  WHERE calo.id = 35653 AND 
        diso.nome LIKE 'anatomia%' AND 
        cald.id = 38081 AND 
        etad.ano = 2020


        SELECT * FROM academico_etapaano ae WHERE id = 1432

--  SELECT * FROM vw_Curriculo_aluno_pessoa vcap   WHERE aluno_ra = '1162.000027'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       o tda JOIN academico_turmadisciplina tds ON (tds.id = tda.turma_disciplina_id)
                                               JOIN academico_turma           tur ON (tur.id = tds.turma_id)
                                               JOIN #TBM_TRANSFERENCIA        tbm ON (tbm.aluno_id = tda.aluno_id AND
                                                                                      tda.curriculo_aluno_id = tbm.curriculo_aluno_id_origem)
      WHERE year(tur.inicio_vigencia) = 2020




SELECT distinct crco.nome, crcd.nome, diso.nome, disd.nome, etao.id, etad.id, etao.ano, etao.periodo, etad.periodo
  FROM curriculos_disciplinaconcluida cdco JOIN curriculos_aluno           calo ON (calo.id = cdco.curriculo_aluno_id)
                                           JOIN curriculos_curriculo       crco ON (crco.id = calo.curriculo_id)
                                           JOIN academico_disciplina       diso ON (diso.id = cdco.disciplina_id)
                                           JOIN academico_etapaano         etao ON (etao.id = cdco.etapa_ano_id)
                                    