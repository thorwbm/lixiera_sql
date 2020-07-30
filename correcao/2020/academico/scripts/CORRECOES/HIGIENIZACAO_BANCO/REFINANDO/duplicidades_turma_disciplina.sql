 
WITH CTE_DUPLICIDADE_TURMA_DISCIPLINA AS (
		 select  turma.nome AS TURMA_NOME, disc.nome DISCIPLINA_NOME
		from academico_turmadisciplina    td  join academico_turma           turma on (turma.id = td.turma_id)
		                                      join academico_disciplina      disc  on (disc.id = td.disciplina_id)
		group by  turma.nome, disc.nome
		having count(1) > 1
)
	, CTE_OCORRENCIAS_TABELAS AS (
		SELECT TURMA_DISCIPLINA_ID, QTD = COUNT(1), TABELA = 'academico_turmadisciplinaaluno' FROM academico_turmadisciplinaaluno                                 GROUP BY TURMA_DISCIPLINA_ID UNION 
		SELECT TURMA_DISCIPLINA_ID, QTD = COUNT(1), TABELA = 'academico_turmadisciplinaprofessor' FROM academico_turmadisciplinaprofessor						  GROUP BY TURMA_DISCIPLINA_ID UNION 
		SELECT TURMA_DISCIPLINA_ID, QTD = COUNT(1), TABELA = 'academico_grupoaula' FROM academico_grupoaula														  GROUP BY TURMA_DISCIPLINA_ID UNION 
		SELECT TURMA_DISCIPLINA_ID, QTD = COUNT(1), TABELA = 'materiais_didaticos_publicacao_turmadisciplina' FROM materiais_didaticos_publicacao_turmadisciplina GROUP BY TURMA_DISCIPLINA_ID UNION 
		SELECT TURMA_DISCIPLINA_ID, QTD = COUNT(1), TABELA = 'aulas_agendamento' FROM aulas_agendamento															  GROUP BY TURMA_DISCIPLINA_ID UNION 
		SELECT TURMA_DISCIPLINA_ID, QTD = COUNT(1), TABELA = 'atividades_protocolosegundachamadaprova' FROM atividades_protocolosegundachamadaprova				  GROUP BY TURMA_DISCIPLINA_ID UNION 
		SELECT TURMA_DISCIPLINA_ID, QTD = COUNT(1), TABELA = 'atividades_criterio_turmadisciplina' FROM atividades_criterio_turmadisciplina						  GROUP BY TURMA_DISCIPLINA_ID UNION 
		SELECT TURMA_DISCIPLINA_ID, QTD = COUNT(1), TABELA = 'frequencias_excecaofrequenciaforaprazo' FROM frequencias_excecaofrequenciaforaprazo				  GROUP BY TURMA_DISCIPLINA_ID UNION 
		SELECT TURMA_DISCIPLINA_ID, QTD = COUNT(1), TABELA = 'frequencias_protocolofrequenciaforaprazo' FROM frequencias_protocolofrequenciaforaprazo			  GROUP BY TURMA_DISCIPLINA_ID UNION 
		SELECT TURMA_DISCIPLINA_ID, QTD = COUNT(1), TABELA = 'academico_complementacaocargahoraria' FROM academico_complementacaocargahoraria					  GROUP BY TURMA_DISCIPLINA_ID UNION 
		SELECT TURMA_DISCIPLINA_ID, QTD = COUNT(1), TABELA = 'aulas_pendentes' FROM aulas_pendentes																  GROUP BY TURMA_DISCIPLINA_ID UNION 
		SELECT TURMA_DISCIPLINA_ID, QTD = COUNT(1), TABELA = 'frequencias_revisao' FROM frequencias_revisao														  GROUP BY TURMA_DISCIPLINA_ID UNION 
		SELECT TURMA_DISCIPLINA_ID, QTD = COUNT(1), TABELA = 'academico_aula' FROM academico_aula																  GROUP BY TURMA_DISCIPLINA_ID  
)
    ,  CTE_POSSUI_ALUNO AS (
			SELECT TURMA_DISCIPLINA_ID, QTD = COUNT(1), TABELA = 'academico_turmadisciplinaaluno' FROM academico_turmadisciplinaaluno GROUP BY TURMA_DISCIPLINA_ID
)
	,  CTE_POSSUI_AULA AS (
			SELECT TURMA_DISCIPLINA_ID, QTD = COUNT(1), TABELA = 'academico_aula' FROM academico_aula GROUP BY TURMA_DISCIPLINA_ID
)
	,  CTE_POSSUI_FREQUENCIA AS (
	        select TURMA_DISCIPLINA_ID, QTD = COUNT(1), TABELA = 'academico_frequenciadiaria'
			from academico_frequenciadiaria  FRE JOIN ACADEMICO_AULA AUL ON (AUL.ID = FRE.aula_id)   
            GROUP BY TURMA_DISCIPLINA_ID 
)
	,  CTE_POSSUI_COMP_CARG_HORARIA AS (
	       SELECT TURMA_DISCIPLINA_ID, QTD = COUNT(1), TABELA = 'academico_complementacaocargahoraria'
		   FROM academico_complementacaocargahoraria
		   GROUP BY TURMA_DISCIPLINA_ID  
)		
	,  CTE_TURMADISCIPLINA AS (
        SELECT DISTINCT tds.id as turma_disciplina_id,
		       tur.id as turma_id, tur.nome as turma_nome, 
			   dis.id as disciplina_id, dis.nome as disciplina_nome, 
		       disc_pertence_curriculo_ativo = case when cgd.curriculo_id is null then 'NAO' ELSE 'SIM' END,
			   TEM_LANCAMENTO = CASE WHEN OCO.TURMA_DISCIPLINA_ID IS NULL THEN 'NAO' ELSE 'SIM'END, 
			   TEM_ALUNO_LANC = CASE WHEN PAL.TURMA_DISCIPLINA_ID IS NULL THEN 'NAO' ELSE 'SIM'END, 
			   TEM_AULA       = CASE WHEN PSA.TURMA_DISCIPLINA_ID IS NULL THEN 'NAO' ELSE 'SIM'END, 
			   TEM_FREQUENCIA = CASE WHEN PSF.TURMA_DISCIPLINA_ID IS NULL THEN 'NAO' ELSE 'SIM'END,
			   TEM_COMP_HORARIA = CASE WHEN CCH.TURMA_DISCIPLINA_ID IS NULL THEN 'NAO' ELSE 'SIM'END,
			   CGD.curriculo_nome
		FROM  academico_turmadisciplina tds  join academico_turma                  tur on (tur.id              = tds.turma_id)
		                                     join academico_disciplina             dis on (dis.id              = tds.disciplina_id)
											 join CTE_DUPLICIDADE_TURMA_DISCIPLINA cte on (cte.turma_nome      = tur.nome and 
																						   cte.disciplina_nome = dis.nome)
										left join vw_curriculo_grade_disciplina    cgd on (tur.grade_id        = cgd.grade_id and 
													                                       cgd.disciplina_id   = dis.id)
										LEFT JOIN CTE_OCORRENCIAS_TABELAS          OCO ON (TDS.id = OCO.turma_disciplina_id)
										LEFT JOIN CTE_POSSUI_ALUNO                 PAL ON (TDS.ID = PAL.turma_disciplina_id)
										LEFT JOIN CTE_POSSUI_AULA                  PSA ON (TDS.ID = PSA.turma_disciplina_id)
										LEFT JOIN CTE_POSSUI_FREQUENCIA            PSF ON (TDS.ID = PSF.turma_disciplina_id)
										LEFT JOIN CTE_POSSUI_COMP_CARG_HORARIA     CCH ON (TDS.ID = CCH.turma_disciplina_id)
) 
		select *--vw.* into tmp_alunos_afetados_higienizacao_tds
		from CTE_TURMADISCIPLINA TDS --join vw_aluno_curriculo_curso_turma_etapa_discplina vw on (tds.turma_disciplina_id = vw.TURMADISCIPLINA_ID)
		order by 3,5

			
ALTER TABLE academico_aula NOCHECK CONSTRAINT academico_aula_grupo_id_84f74ebf_fk_academico_grupoaula_id;
ALTER TABLE academico_grupoaula NOCHECK CONSTRAINT academico_grupoaula_agendamento_id_327ae61e_fk_aulas_agendamento_id
ALTER TABLE academico_aula NOCHECK CONSTRAINT academico_aula_agendamento_id_a8686f6e_fk_aulas_agendamento_id 
		exec sp_transportar_turmadisciplina_id 9979, 9975, 'HIGIENIZACAO'
ALTER TABLE academico_aula CHECK CONSTRAINT academico_aula_grupo_id_84f74ebf_fk_academico_grupoaula_id;
ALTER TABLE academico_grupoaula CHECK CONSTRAINT academico_grupoaula_agendamento_id_327ae61e_fk_aulas_agendamento_id
ALTER TABLE academico_aula CHECK CONSTRAINT academico_aula_agendamento_id_a8686f6e_fk_aulas_agendamento_id
		

--###########################################################################
		-- ******* GERAR LOG  academico_turmadisciplina  DELECAO ******
		declare @ID_AUX int
		declare CUR_TDP_DEL cursor for 
			-- *********************************************
				SELECT id
		FROM ACADEMICO_TURMA WHERE NOME IN (
		SELECT  TUR.NOME FROM ACADEMICO_TURMA TUR join academico_turma turx on (tur.nome = turx.nome)
		                                    LEFT  JOIN academico_turmadisciplina TDS ON (TUR.ID = TDS.TURMA_ID)		                                          
		WHERE TDS.ID IN (
                          9979, 9975, 12623, 5142,11382, 11383
						 )) AND 
		ID NOT IN (SELECT TURMA_ID FROM academico_turmadisciplina)
			-- *********************************************
			open CUR_TDP_DEL 
				fetch next from CUR_TDP_DEL into @ID_AUX
				while @@FETCH_STATUS = 0
					BEGIN
						 EXEC SP_GERAR_LOG 'ACADEMICO_TURMA', @ID_AUX, '-', 2136, NULL, NULL, 'HIGIENIZACAO'
					fetch next from CUR_TDP_DEL into @ID_AUX
					END
			close CUR_TDP_DEL 
		deallocate CUR_TDP_DEL
		-- ******* GERAR LOG DELECAO FIM ******

		--SELECT *   
		 DELETE
		FROM ACADEMICO_TURMA WHERE NOME IN (
		SELECT  TUR.NOME FROM ACADEMICO_TURMA TUR join academico_turma turx on (tur.nome = turx.nome)
		                                    LEFT  JOIN academico_turmadisciplina TDS ON (TUR.ID = TDS.TURMA_ID)		                                          
		WHERE TDS.ID IN (
		                  9979, 9975, 12623, 5142, 11382, 11383
		                )) AND 
		ID NOT IN (SELECT TURMA_ID FROM academico_turmadisciplina)

--###########################################################################

	SELECT TOP 10 * FROM academico_turmadisciplina WHERE TURMA_ID = 	417
/*
 
ALTER TABLE academico_turmadisciplina DROP COLUMN turma_universus         ;
ALTER TABLE academico_turmadisciplina DROP COLUMN professor_universus_id	;
ALTER TABLE academico_turmadisciplina DROP COLUMN disciplina_universus_id	;
ALTER TABLE academico_turmadisciplina DROP COLUMN escola_universus_id		;
ALTER TABLE academico_turmadisciplina DROP COLUMN ano_universus_id		;
ALTER TABLE academico_turmadisciplina DROP COLUMN regime_universus_id		;
ALTER TABLE academico_turmadisciplina DROP COLUMN periodo_universus_id	;

*/

select distinct  tds.turma_id from academico_turmadisciplina tds join academico_turma tur on (tur.id = tds.turma_id)
                                            join academico_etapaano eta on (eta.id = tur.etapa_ano_id and eta.ano <= 2019)
where tur.nome in (select nome 
from academico_turma 
group by nome 
having count(1) >1)


