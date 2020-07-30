
-- exec sp_agrupar_aula 73222, null, null, null 
create or alter procedure sp_agrupar_aula @grupo_id int, @data date, @turmaDis_id int, @prof_id int as 
-- **** APAGO TABELAS TEMPORARIAS  *****
if (object_id('tempdb..#temp') is not null)
  drop table #temp;

if (object_id('tempdb..#temp_grupo') is not null)
  drop table #temp_grupo;
-- **** APAGO TABELAS TEMPORARIAS - FIM *****  

-- **** BUSCO REFERENCIA DO GRUPO PARA ALTERACAO CRIACAO ****
select distinct  @grupo_id = id, 
                 @prof_id  = professor_id, 
		         @turmaDis_id = turma_disciplina_id, 
		         @data = CAST(data_inicio as date)
  from academico_grupoaula 
where id = @grupo_id or 
      (CAST(data_inicio as date) = @data        and 
	        turma_disciplina_id  = @turmaDis_id and 
			professor_id         = @prof_id     and 
			@grupo_id is null);
-- **** BUSCO REFERENCIA DO GRUPO PARA ALTERACAO CRIACAO - FIM ****

-- **** CTE QUE BUSCA AS REFERENCIAS DA AULA COM BASE NOS PARAMETROS PASSADOS ****
with cte_professor_turma_data as (
		select CAST(data_inicio as date) as dt_ini, turma_disciplina_id, professor_id, id as aula_id
		  from academico_aula with(nolock)
		  where professor_id = @prof_id AND 
		        turma_disciplina_id = @turmaDis_id AND
				CAST(DATA_INICIO AS date) = @data 
		 group by CAST(data_inicio as date), turma_disciplina_id, professor_id, id
)
	-- **** CTE QUE TRAS A DATA ANTERIOR TERMINO ****
	,cte_prof_tur_dat_ant as (
		select ptd.*, aul.data_inicio, aul.data_termino, 
		       data_termino_anterior = (select top 1 aulx.data_termino 
	                                      from academico_aula aulx
	                                     where CAST(aulx.data_inicio as date) = ptd.dt_ini and 
										       aulx.professor_id = ptd.professor_id and 
											   aulx.turma_disciplina_id = ptd.turma_disciplina_id and
											   aulx.data_inicio < aul.data_inicio order by aulx.data_termino desc)
		  from cte_professor_turma_data ptd with(nolock) join academico_aula aul  with(nolock) on (ptd.aula_id = aul.id )
	)
		    
		-- **** MONTO TABELA TEMPORARIA QUE SINALIZA QUAL A PRIMEIRA TUPLA PARA O AGRUPAMENTO DE CADA CONJUNTO turma_disciplina_id, professor_id,  data_inicio ****
		select * , case when data_termino_anterior is null then 'inicio'
		                when DATEDIFF(minute,  data_termino_anterior, data_inicio)> 50 then 'inicio' else 'agrupar' end as tipo, grupo = 0
						into #temp
		  from cte_prof_tur_dat_ant
				order by turma_disciplina_id, professor_id,  data_inicio
		PRINT 'TABELA TEMPORARIA 1 CRIADA'     
	-- **** CURSOR QUE SEPARA POR GRUPOAULA LEVANDO EM CONTA O PARAMETRO DE TEMPO LIMITE DE INTERVALO ENTRE CADA AULA ****
	declare @cont int, @aula_id int, @tipo varchar(50), @professor_id int, @turma_disciplina_id int
	set @cont = 0
	declare abc cursor for 
	select aula_id, tipo, turma_disciplina_id, professor_id from #temp order by turma_disciplina_id, professor_id, aula_id
	open abc 
		fetch next from abc into @aula_id, @tipo, @turma_disciplina_id, @professor_id
		while @@FETCH_STATUS = 0
			BEGIN
				if(@tipo = 'inicio')
					begin
						set @cont = @cont + 1						
					end
				update #temp set grupo = @cont where aula_id = @aula_id
			fetch next from abc into @aula_id, @tipo, @turma_disciplina_id, @professor_id
			END
	close abc 
deallocate abc 
	PRINT 'TABELA TEMPORARIA ORGANIZADA'
	-- **** CRIO TABELA TEMPORARIA PARA AGRUPAMENTO DE GRUPOSAULA ****
	select grupo, turma_disciplina_id, professor_id, MIN(data_inicio) as data_ini, MAX(data_termino) as data_ter
	 into #temp_grupo
	 from #temp 
	 group by grupo, turma_disciplina_id, professor_id
	 PRINT 'TABELA GRUPO CRIADA'
	 PRINT 'INICIO CURSOR AUX'
BEGIN TRAN
	BEGIN TRY
	       SELECT * FROM #temp_grupo
			-- **** CURSOR PARA PROCESSAMENTO DO AGRUPAMENTO *****
			DECLARE @GRUPO_AUX INT, @GRUPO_ID_AUX INT, @GRUPO_AULA_ID INT  
			declare abc_GRUP cursor for 
				SELECT GRUPO FROM #temp_grupo
				open abc_GRUP 
					fetch next from abc_GRUP into @GRUPO_AUX
					while @@FETCH_STATUS = 0
						BEGIN
						    PRINT 'INSERT NA TABELA GRUPOAULA'

							--DECLARE @GRUPO_AUX INT, @GRUPO_ID_AUX INT, @GRUPO_AULA_ID INT  
							--begin tran
							INSERT INTO academico_grupoaula (criado_em, atualizado_em, data_inicio, data_termino,conteudo, data_envio_frequencia, agendamento_id, 
										criado_por, professor_id, sala_id, status_id, turma_disciplina_id, atualizado_por, user_envio_frequencia_id)
							select distinct criado_em = GETDATE(), atualizado_em = GETDATE(), data_inicio = dateadd(second,1,tem.data_ini), data_termino = tem.data_ter, aul.conteudo, 
										data_envio_frequencia = aul.data_envio_frequencia, agendamento_id = aul.agendamento_id, 
										criado_por = null, tem.professor_id, sala_id = aul.sala_id,  status_id = aul.status_id, tem.turma_disciplina_id, 
										aul.atualizado_por, aul.user_envio_frequencia_id
							from academico_grupoaula gpa     join #temp_grupo    tem on (tem.turma_disciplina_id = gpa.turma_disciplina_id and 
																						tem.professor_id        = gpa.professor_id        and 
																						tem.data_ini            = gpa.data_inicio         and
																						tem.data_ter            = gpa.data_termino) 
														left join academico_aula aul on (gpa.turma_disciplina_id = aul.turma_disciplina_id and 
																						gpa.professor_id        = aul.professor_id        and 
																						aul.data_inicio between gpa.data_inicio and gpa.data_termino)
						    WHERE tem.grupo = @GRUPO_AUX

						SET @GRUPO_ID_AUX = @@IDENTITY
						PRINT 'ID GRUPO NOVO'
						PRINT @GRUPO_ID_AUX
						EXEC sp_gerar_log_academico_grupoaula NULL, NULL, NULL, '+',NULL, @GRUPO_ID_AUX

						-- **** RECUPERAR GRUPO_ID SE EXISTIR ****      rollback 
						SELECT DISTINCT  @GRUPO_AULA_ID = grupo_id
						  FROM academico_aula AUL JOIN #temp_grupo TMP ON (AUL.turma_disciplina_id = TMP.turma_disciplina_id AND 
																		   AUL.professor_id        = TMP.professor_id        AND
																		   AUL.data_inicio  BETWEEN TMP.data_ini AND TMP.data_ter)
						  where grupo_id <> @GRUPO_ID_AUX
						 PRINT 'INSERIR' PRINT @GRUPO_ID_AUX PRINT @@ROWCOUNT
						  -- **** ATUALIZAR GRUPO_ID DAS AULA *****
						  UPDATE AUL SET AUL.grupo_id = @GRUPO_ID_AUX
						  FROM academico_aula AUL JOIN #temp_grupo TMP ON (AUL.turma_disciplina_id = TMP.turma_disciplina_id AND 
																		   AUL.professor_id        = TMP.professor_id        AND
																		   AUL.data_inicio  BETWEEN TMP.data_ini AND TMP.data_ter)
						  where aul.grupo_id = @GRUPO_AULA_ID
                          
						  -- **** APAGAR GRUPO AULAS ANTIGOS ****
						  EXEC sp_gerar_log_academico_grupoaula NULL, NULL, NULL, '-',NULL, @GRUPO_AULA_ID
						  DELETE FROM academico_grupoaula 
						  WHERE id = @GRUPO_AULA_ID 

						  --**** CORRIGO A DATA DE INICIO NA GRUPO AULA, TIVE QUE ACRESCENTAR UM ANTERIORMENTE PARA PODER INSERIR (CONSTRAINT QUE NAO PERMITE A MESMA DATA)
						  update academico_grupoaula set data_inicio = DATEADD(second,-1,data_inicio) where id = @GRUPO_ID_AUX

						fetch next from abc_GRUP into @GRUPO_AUX
						END
				close abc_GRUP 
			deallocate abc_GRUP 
			COMMIT
	END TRY
	BEGIN CATCH
	    PRINT 'ERRO'
	    PRINT @@ERROR
		ROLLBACK 
	END CATCH
