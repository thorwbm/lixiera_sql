DECLARE @IMPORTADAS_UNIVERSUS VARCHAR(20) 
DECLARE @TURMAS      VARCHAR(100)
DECLARE @CURSO       VARCHAR(100) 
DECLARE @DISCIPLINAS VARCHAR(200)
DECLARE @ETAPA       INT
DECLARE @CRITERIO_TURMA_DISCIPLINA INT 
DECLARE @INICIO_VIGENCIA DATETIME 
DECLARE @TERMINO_VIGENCIA DATETIME
DECLARE @DESCONSIDERAR_DATAS INT 
DECLARE @BKP_SQL NVARCHAR(MAX)
DECLARE @DATA VARCHAR(20)

-- SETAR DATA PARA GERACAO DO BACKUP
SET @DATA = LEFT((REPLACE(REPLACE(REPLACE(CONVERT(VARCHAR(20),GETDATE(),121),'-',''),' ','__'),':','')),14)

-- FILTRO DE CURSO
SET @CURSO = 'MEDICINA'

-- [SIM (SOMENTE AS IMPORTADAS), NAO (SOMENTE AS NAO IMPORTADAS), TODAS] 
-- REPLICA OS CRITÉRIOS APENAS PARA TURMAS IMPORTADAS DO UNIVERSUS, POIS NO EDUCAT AINDA NÃO TEM A INDICAÇAO SE A TURMA E TEÓRICA OU PRÁTICA
SET @IMPORTADAS_UNIVERSUS = 'SIM'  

-- SELECIONAR TURMAS CASO NAO SELECIONE DEIXAR STRING VAZIA 
-- INDICA UMA TURMA ESPECÍFICA PARA REPLICAR OS CRITÉRIOS
SET @TURMAS  = '1MA1º2019-1'
SET @TURMAS = LTRIM(RTRIM(REPLACE(@TURMAS, '	', '')))

-- SELECIONAR TURMAS CASO NAO SELECIONE DEIXAR STRING VAZIA 
-- INDICA UMA TURMA ESPECÍFICA PARA REPLICAR OS CRITÉRIOS
SET @DISCIPLINAS  = ''
SET @DISCIPLINAS = LTRIM(RTRIM(REPLACE(@DISCIPLINAS, '	', '')))

-- CONSIDERA TURMA DE UMA DETERMINADA ETAPA
-- DESCONSIDERAR ETAPA PASSAR O VALOR 0 (ZERO) 
SET @ETAPA = 0

-- BLOQUEIA A INSERÇÃO DE CRITÉRIOS NA TURMA/DISCIPLINA SE JÁ EXISTIR ALGUM CRITÉRIO CADASTRADO NESSA TURMA/DISCIPLINA
-- SETAR 0 PERMITE TODOS SETAR 1 BLOQUEIA CRITERIOS JA CADASTRADOS
SET @CRITERIO_TURMA_DISCIPLINA = 0

-- CONSIDERAR DATAS DE INICIO E TERMINO DE VIGENCIA 
-- SETAR O CAMPO PARA 1 E INFORMAR AS DATAS
SET @DESCONSIDERAR_DATAS = 1 
SET @INICIO_VIGENCIA  = '2019-02-01' 
SET @TERMINO_VIGENCIA = '2019-07-16'

--###############################################################################################
	SELECT DISTINCT VW.* 
	    INTO #TEMP
		FROM  VW_PLANO_ENSINO_TURMA_DISCIPLINA_CRITERIO  VW LEFT JOIN (SELECT DISTINCT LTRIM(RTRIM(VALUE)) AS TURMA_NOME FROM STRING_SPLIT ( @TURMAS, ',')) AS TURX ON (VW.TURMA_NOME = TURX.TURMA_NOME)
		                                                    LEFT JOIN (SELECT DISTINCT LTRIM(RTRIM(VALUE)) AS DISCIPLINA_NOME FROM STRING_SPLIT ( @DISCIPLINAS, ',')) AS DISX ON (VW.DISCIPLINA_NOME = DISX.DISCIPLINA_NOME)
		                                                    LEFT JOIN atividades_criterio_turmadisciplina CTD ON (CTD.TURMA_DISCIPLINA_ID = VW.TURMADISCIPLINA_ID AND 
															                                                      CTD.criterio_id         = VW.CRITERIO_ID)
		WHERE ETAPAANO_ID IS NOT NULL AND 
		    -- ***
		    (VW.CURSO_NOME = @CURSO)  AND 
			-- ***
			(	(json_query(TURMA_atributos, '$.universus_key') is not null AND @IMPORTADAS_UNIVERSUS = 'SIM') OR --REPLICA OS CRITÉRIOS APENAS PARA TURMAS IMPORTADAS DO UNIVERSUS, POIS NO EDUCAT AINDA NÃO TEM A INDICAÇAO SE A TURMA E TEÓRICA OU PRÁTICA
				(json_query(TURMA_atributos, '$.universus_key') is     null AND @IMPORTADAS_UNIVERSUS = 'NAO') OR --REPLICA OS CRITÉRIOS APENAS PARA TURMAS IMPORTADAS DO UNIVERSUS, POIS NO EDUCAT AINDA NÃO TEM A INDICAÇAO SE A TURMA E TEÓRICA OU PRÁTICA
				(@IMPORTADAS_UNIVERSUS = 'TODAS')																  --REPLICA OS CRITÉRIOS APENAS PARA TURMAS IMPORTADAS DO UNIVERSUS, POIS NO EDUCAT AINDA NÃO TEM A INDICAÇAO SE A TURMA E TEÓRICA OU PRÁTICA
			)  AND 
			-- ***
			(	(TURX.TURMA_NOME IS NOT NULL AND LEN (@TURMAS) > 0) OR 
				(LEN (@TURMAS) = 0)
			)  AND 
			-- ***
		    (etapa = @ETAPA OR @ETAPA = 0) AND
			-- ***
			(	(CTD.id IS  NULL AND @CRITERIO_TURMA_DISCIPLINA = 1) OR 
			    (@CRITERIO_TURMA_DISCIPLINA = 0)
			) AND 
			-- ***
			(	(DISX.DISCIPLINA_NOME IS NOT NULL AND LEN (@DISCIPLINAS) > 0) OR 
				(LEN (@DISCIPLINAS) = 0)
			)   AND 
			-- ***
			(	(VW.inicio_vigencia >= @INICIO_VIGENCIA and VW.termino_vigencia >= @TERMINO_VIGENCIA and @DESCONSIDERAR_DATAS = 0) OR 
				(@DESCONSIDERAR_DATAS = 1)
			)

-- #########################################################################################################
	-- *** FAZER BACKUP 
	SET @BKP_SQL = N' SELECT * INTO BKP_ATIVIDADES_ATIVIDADE_' + @DATA + ' from atividades_atividade where criterio_turma_disciplina_id in (select id from atividades_criterio_turmadisciplina where turma_disciplina_id in (select turma_disciplina_id from #TEMP))'
	EXEC (@BKP_SQL)
	SET @BKP_SQL = N' SELECT * INTO atividades_criterio_turmadisciplina_' + @DATA + ' from atividades_criterio_turmadisciplina where turma_disciplina_id in (select turma_disciplina_id from #TEMP)'
	EXEC (@BKP_SQL)

	-- *** APAGAR
	begin tran
	--APAGA AS ATIVIDADES E CRITÉRIOS DA TURMA/DISCIPLINA, PARA GARANTIR QUE TODOS OS CRITÉRIOS E ATIVIDADES QUE ESTÃO NO PLANO DE ENSINO SERÃO REPLICADOS PARA AS TURMAS
	delete from atividades_atividade where criterio_turma_disciplina_id in (select id from atividades_criterio_turmadisciplina where turma_disciplina_id in (select turma_disciplina_id from #TEMP))
	delete from atividades_criterio_turmadisciplina where turma_disciplina_id in (select turma_disciplina_id from #TEMP)


	-- ###################################################################################################
	--COPIA OS CRITÉRIOS PARA AS TURMAS
insert into atividades_criterio_turmadisciplina (turma_disciplina_id, criterio_id, criado_em, criado_por, atualizado_em, atualizado_por, professor_id, inicio_janela_lancamento, termino_janela_lancamento, atributos)
select turma_disciplina_id, criterio_id, criado_em, criado_por, atualizado_em, atualizado_por, professor_id,
       case
          when criterio = 'AVALIAÇÃO PARCIAL' then '2019-09-23'
          when criterio = 'AVALIAÇÃO FORMATIVA' then '2019-11-11'
          when criterio = 'APIC - AVALIAÇÃO PARCIAL INTEGRADORA DE CONTEÚDOS' then '2019-11-11'
          when criterio = 'AVALIAÇÃO SOMATIVA' then '2019-11-19'
          else null
       end as inicio_janela_lancamento,
       case
          when criterio = 'AVALIAÇÃO PARCIAL' then '2019-10-07'
          when criterio = 'AVALIAÇÃO FORMATIVA' then '2019-11-18'
          when criterio = 'APIC - AVALIAÇÃO PARCIAL INTEGRADORA DE CONTEÚDOS' then '2019-11-18'
          when criterio = 'AVALIAÇÃO SOMATIVA' then '2019-12-13'
          else null
       end as termino_janela_lancamento,
       '{"planoensino_id":' + convert(varchar(100), planoensino_id) + '}'
  from #tmp1
go



--COPIA AS ATIVIDADES PARA AS TURMAS
insert into atividades_atividade (criado_em, criado_por, atualizado_em, atualizado_por, nome, valor, peso, criterio_turma_disciplina_id, status_id)
select getdate() as criado_em, 2137 as criado_por, getdate() as atualizado_em, 2137 as atualizado_por, patv.nome, patv.valor, 1,
       (select ctd.id from atividades_criterio_turmadisciplina ctd where ctd.criterio_id = t.criterio_id and ctd.turma_disciplina_id = t.turma_disciplina_id), 1
  from planos_ensino_atividade patv
       join #tmp1 t on t.planoensino_criterio_id = patv.planoensino_criterio_id

-- commit
-- ROLLBACK 

 



			SELECT planoensino_id,  planoensinocriterio_id, criterio_NOME, CRITERIO_posicao, turmadisciplina_id, 
                criterio_id, getdate() as criado_em, 2137 as criado_por, getdate() as atualizado_em, 2137 as atualizado_por, 
				professor_responsavel_id as professor_id 
			
			FROM #TEMP

